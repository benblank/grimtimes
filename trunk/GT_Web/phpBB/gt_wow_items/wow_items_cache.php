<?php /* $Id$ */

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

	include($phpbb_root_path . 'includes/functions_wow_items.'.$phpEx);

	$pending = "This item has not yet been cached.  It is possible that Allakhazam is down or that the item ID is invalid.  Please try again later.";

	function die_text($msg, $line) {
		// "Magic" database errors.
		if (gettype($msg) == "array") $msg = "Database error {$msg['code']}: \"{$msg['message']}\"";
		else if (gettype($msg) != "string") $msg = "Error";
		else $msg = "Error \"$msg\"";

		die($msg . " on line " . $line);
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
		for ($i = 1; $i < $argc - 1; $i++) if (preg_match('/^\d+$/', $argv[$i])) $items[] = intval($argv[$i]);
	} else {
		die_text("Could not find POST request, GET request, or command line parameters", __LINE__);
	}

	if (count($items) == 0) die_text("No items specified; make sure you are using item IDs", __LINE__);

	// Item "zero" means rebuild the ID <-> Name mapping
	if (in_array(0, $items)) {
		// Get a list of which items need to be re-cached.  We use
		// item_desc instead of item_stamp because the latter is used
		// to track when the mapping was last updated.
		$result = $db->sql_query("SELECT item_id FROM " . WOW_ITEMS_TABLE . " WHERE item_desc IS NOT NULL", BEGIN_TRANSACTION);
		if (!$result) die_text($db->sql_error(), __LINE__);
		$result = $db->sql_fetchrowset($result);
		if ($result) foreach ($result as $v) $items[] = intval($v['item_id']);

		// And here's why we're doing this transactionally.  Ouch!
		if (!$db->sql_query("TRUNCATE " . WOW_ITEMS_TABLE)) die_text($db->sql_error(), __LINE__);

		if (!($lines = file("http://wow.allakhazam.com/itemlist.xml"))) die_text("Failure reading item list from Allakhazam", __LINE__);

		$rows = array("(0, '00index', NULL)");

		foreach ($lines as $line) if (preg_match('#<wowitem\s+name="([^"]+)"\s+id="(\d+)"\s*/>#', $line, $match) && $match[1]{0} != "ÿ") {
			$id = intval($match[2]);
			$rows[] = "($id,'" . str_replace("'", "''", $match[1]) . "'," . (in_array($id, $items) ? "'$pending')" : "NULL)");
		}

		$sql = "INSERT INTO " . WOW_ITEMS_TABLE . " (item_id, item_name, item_desc)
		        VALUES " . implode(",", $rows);

		if (!($db->sql_query($sql, END_TRANSACTION))) die_text($db->sql_error(), __LINE__);
	}

	// Only cache items we don't already have.
	if (!($result = $db->sql_query("SELECT item_id FROM " . WOW_ITEMS_TABLE . " WHERE item_icon IS NULL"))) die_text($db->sql_error(), __LINE__);
	if (!($result = $db->sql_fetchrowset($result))) die_text($db->sql_error(), __LINE__);
	foreach ($result as $k => $v) $result[$k] = $v['item_id'];
	$items = array_intersect(array_unique($items), $result);

	$rows = array();

	// Any kind of failure in this loop causes a continue instead of an abort;
	// no need to throw it all away because one item is bad.
	foreach ($items as $id) {
		if ($id == 0) continue; // Ignore item "zero".

		if (!($lines = file("http://wow.allakhazam.com/dev/wow/item-xml.pl?witem=$id"))) continue;
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

		$rows[] = "($id,'"  . str_replace("'", "''", $name) . "',$quality,'" . str_replace("'", "''", $icon) . "','" . str_replace("'", "''", wow_item_clean($desc)) . "')";
	}

	if (count($rows) > 0) {
		$sql = "REPLACE INTO " . WOW_ITEMS_TABLE . " (item_id,item_name,item_quality,item_icon,item_desc)
		        VALUES " . implode(",", $rows);

		if (!$db->sql_query($sql)) die_text($db->sql_error(), __LINE__);
	}
