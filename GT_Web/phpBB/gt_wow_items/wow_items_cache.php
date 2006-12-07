<?php /* $Id$ */

	// When called via the command line or from a script on the same server (a
	// la functions_wow_items.php), the local and remote addresses are the same.
	if ($_SERVER['SERVER_ADDR'] != $_SERVER['REMOTE_ADDR']) die("Hacking attempt!");

	define('IN_PHPBB', true);

	// Prevent caching from being interrupted by silly little things like
	// closed connections and slow responses from Allakhazam.
	ignore_user_abort(true);
	set_time_limit(0);

	// Just enough to get the DBAL working...
	$phpbb_root_path = './';
	include($phpbb_root_path . 'extension.inc');
	include($phpbb_root_path . 'config.'.$phpEx);
	include($phpbb_root_path . 'includes/constants.'.$phpEx);
	include($phpbb_root_path . 'includes/db.'.$phpEx);
	unset($dbpasswd);

	$stamp = time();
	$limit = $stamp - 2592000; // Cache expires after 30 days
	$table = $table_prefix . 'wow_items';

	// Clean up silliness in Allak's HTML
	function clean_item($html) {
		static $wow_item_clean;

		if (!isset($wow_item_clean)) {
			$wow_item_clean['#&lt;#'] = '<';
			$wow_item_clean['#&gt;#'] = '>';
			$wow_item_clean['#&quot;#'] = '"';
			$wow_item_clean['#&amp;#'] = '&';
			$wow_item_clean['#&nbsp;#'] = ' ';
			$wow_item_clean['#\s*(?:&nbsp;)*\s*<br\s*/>\s*(?:&nbsp;)*\s*#'] = '<br />';
			$wow_item_clean['#[\r\n]+#'] = '';
			$wow_item_clean['#<span class="iname"><span class="([^"]+)">(.+?)</span>(.*?)</span>#'] = '<span class="itemname \1">\2\3</span>';
			$wow_item_clean['#gr[ae]yname#'] = 'quality0';
			$wow_item_clean['#whitename#'] = 'quality1';
			$wow_item_clean['#greenname#'] = 'quality2';
			$wow_item_clean['#bluename#'] = 'quality3';
			$wow_item_clean['#purplename#'] = 'quality4';
			$wow_item_clean['#orangename#'] = 'quality5';
			$wow_item_clean['#redname#'] = 'quality6';
			$wow_item_clean['#wowrttxt#'] = 'right';
			$wow_item_clean['#(<span class="itemeffect)link#'] = '\1';
			$wow_item_clean['#(<a[^>]*) class="itemeffectlink"#'] = '\1';
			$wow_item_clean['#(<a[^>]*)><span class="goldtext">(.+)</span></a>#'] = '\1 class="itemdesc">\2</a>';
			$wow_item_clean['#goldtext#'] = 'itemdesc';
		}

		return preg_replace(array_keys($wow_item_clean), array_values($wow_item_clean), $html);
	}

	function die_text($msg, $line) {
		// "Magic" database errors.
		if (gettype($msg) == "array") $msg = "Database error {$msg['code']}: \"{$msg['message']}\"";
		else if (gettype($msg) != "string") $msg = "Error";
		else $msg = "Error \"$msg\"";

		die($msg . " on line " . $line);
	}

	// Fall back to CURL if fopen wrappers aren't working.
	function url($url) {
		$result = @file($url);
		if (false !== $result) return $result;

		$curl = curl_init($url);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$result = curl_exec($curl);
		curl_close($curl);

		return explode("\n", $result);
	}

	$items = array();

	if (isset($_POST) && (isset($_POST['item']) || isset($_POST['items']))) {
		$req = &$_POST;
	} else if (isset($_GET) && (isset($_GET['item']) || isset($_GET['items']))) {
		$req = &$_GET;
	} else if (isset($HTTP_POST_VARS) && (isset($HTTP_POST_VARS['item']) || isset($HTTP_POST_VARS['items']))) {
		$req = &$HTTP_POST_VARS;
	} else if (isset($HTTP_GET_VARS) && (isset($HTTP_GET_VARS['item']) || isset($HTTP_GET_VARS['items']))) {
		$req = &$HTTP_GET_VARS;
	} else if (!isset($argc)) {
		if (isset($_SERVER) && isset($_SERVER['argc'])) {
			$argc = &$_SERVER['argc'];
			$argv = &$_SERVER['argv'];
		} else if (isset($HTTP_SERVER_VARS) && isset($HTTP_SERVER_VARS['argc'])) {
			$argc = &$HTTP_SERVER_VARS['argc'];
			$argv = &$HTTP_SERVER_VARS['argv'];
		}
	}

	if (isset($req)) {
		if (isset($req['item']) && preg_match('/^\d+$/', $req['item'])) $items[] = intval($req['item']);
		if (isset($req['items'])) foreach ($req['items'] as $v) if (preg_match('/^\d+$/', $v)) $items[] = intval($v);
	} else if (isset($argc)) {
		for ($i = 1; $i < $argc; $i++) if (preg_match('/^\d+$/', $argv[$i])) $items[] = intval($argv[$i]);
	} else {
		die_text("Could not find POST request, GET request, or command line parameters", __LINE__);
	}

	if (count($items) == 0) die_text("No items specified; make sure you are using item IDs", __LINE__);

	if (!($result = $db->sql_query("SELECT item_stamp FROM $table WHERE item_id = 0"))) die_text($db->sql_error(), __LINE__);
	if ($db->sql_numrows($result) == 0) {
		if (!($result = $db->sql_query("INSERT INTO $table (item_id, item_stamp, item_name) VALUES (0, 0, '00index')"))) die_text($db->sql_error(), __LINE__);
		$items[] = 0;
	} else {
		if (!($result = $db->sql_fetchrowset($result))) die_text($db->sql_error(), __LINE__);
		if (intval($result[0]['item_stamp']) < $limit) $items[] = 0;
	}

	// Update the ID <--> Name mapping if it is missing or out of date
	if (in_array(0, $items)) {
		if (!($lines = url("http://wow.allakhazam.com/itemlist.xml"))) die_text("Failure reading item list from Allakhazam", __LINE__);

		$ids = array();
		$rows = array();
		foreach ($lines as $line) if (preg_match('#<wowitem\s+name="([^"]+)"\s+id="(\d+)"\s*/>#', $line, $match) && $match[1]{0} > "\x1F" && $match[1]{0} < "\x7F") {
			$id = intval($match[2]);
			$good_ids[] = $id;
			$rows[] = "($id, 0, '" . str_replace("'", "''", $match[1]) . "')";
		}

		if (!($result = $db->sql_query("SELECT item_id FROM $table"))) die_text($db->sql_error(), __LINE__);
		if ($db->sql_numrows($result) > 0) {
			if (!($result = $db->sql_fetchrowset($result))) die_text($db->sql_error(), __LINE__);
			$bad_ids = array();
			foreach ($result as $v) $bad_ids[] = intval($v['item_id']);
			$bad_ids = array_diff($bad_ids, $good_ids, array(0));
			if (count($bad_ids) > 0) if (!($db->sql_query("DELETE FROM $table WHERE item_id IN (" . implode(",", $bad_ids) . ")"))) die_text($db->sql_error(), __LINE__);
		}

		if (!($db->sql_query("INSERT INTO $table (item_id, item_stamp, item_name) VALUES " . implode(",", $rows) . " ON DUPLICATE KEY UPDATE item_name=VALUES(item_name), item_stamp=IF(item_name = VALUES(item_name), item_stamp, 0)"))) die_text($db->sql_error(), __LINE__);
		if (!($db->sql_query("UPDATE $table SET item_stamp=$stamp WHERE item_id = 0"))) die_text($db->sql_error(), __LINE__);
	}

	// Only cache items which aren't already up to date
	if (!($result = $db->sql_query("SELECT item_id FROM $table WHERE item_stamp < $limit"))) die_text($db->sql_error(), __LINE__);
	if (!($result = $db->sql_fetchrowset($result))) die_text($db->sql_error(), __LINE__);
	$rows = array();
	foreach ($result as $v) $rows[] = $v['item_id'];
	$items = array_intersect(array_unique($items), $rows);

	$rows = array();

	// Any kind of failure in this loop causes a continue instead of an abort;
	// no need to throw it all away because one item is bad.
	foreach ($items as $id) {
		if ($id == 0) continue; // Ignore item "zero".

		if (!($lines = url("http://wow.allakhazam.com/dev/wow/item-xml.pl?witem=$id"))) continue;
		$xml = implode("", $lines);

		if (!preg_match('#<id>(\d+)</id>#', $xml, $match) || $match[1] != $id) continue;

		if (!preg_match('#<display_html>(.+?)</display_html>#s', $xml, $match)) continue;
		$desc = $match[1];

		if (!preg_match('#<icon>(.+?)</icon>#', $xml, $match)) continue;
		$icon = $match[1];

		if (!preg_match('#<name1>(.+?)</name1>#', $xml, $match)) continue;
		$name = $match[1];

		if (!preg_match('#<quality>(.+?)</quality>#', $xml, $match)) continue;
		$quality = intval($match[1]);

		$rows[] = "($id,$stamp,'" . str_replace("'", "''", $name) . "',$quality,'" . str_replace("'", "''", $icon) . "','" . str_replace("'", "''", clean_item($desc)) . "')";
	}

	if (count($rows) > 0) {
		$sql = "REPLACE INTO $table (item_id,item_stamp,item_name,item_quality,item_icon,item_desc)
		        VALUES " . implode(",", $rows);

		if (!$db->sql_query($sql)) die_text($db->sql_error(), __LINE__);
	}
?>
