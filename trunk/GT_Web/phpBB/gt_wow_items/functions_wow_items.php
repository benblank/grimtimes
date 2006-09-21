<?php /* $Id$ */

if (!defined('IN_PHPBB')) {
	die("Hacking attempt");
}

define('WOW_ITEMS_TABLE', $table_prefix.'wow_items');

function wow_item_clean($html) {
	static $wow_item_clean;

	if (!isset($wow_item_clean)) {
		$wow_item_clean['#&lt;#'] = '<';
		$wow_item_clean['#&gt;#'] = '>';
		$wow_item_clean['#&quot;#'] = '"';
		$wow_item_clean['#&amp;#'] = '&';
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
		$wow_item_clean['#<span class="akznotice">(.+)</span>#'] = '\1';
	}

	return preg_replace(array_keys($wow_item_clean), array_values($wow_item_clean), $html);
}

function wow_item_search($search, $with_desc = true) {
	global $db;

	if (!preg_match('/^([^\(\)]+)(?:\(([^\(\)]+)\))?$/', $search, $params)) return array();
	$params[1] = str_replace("'", "''", trim($params[1]));
	$sql = "SELECT item_id FROM " . WOW_ITEMS_TABLE . " WHERE item_name LIKE '%{$params[1]}%'";

	if ($with_desc && isset($params[2])) {
		$params[2] = str_replace("'", "''", trim($params[2]));
		$sql .= " AND item_desc LIKE '%{$params[1]}%'";
	}

	if (!($result = $db->sql_query($sql))) return array();
	if (!($result = $db->sql_fetchrowset($result))) return array();

	foreach ($result as $k =>$v) $result[$k] = $v['item_id'];
	sort($result);

	return $result;
}

function wow_item_cache_map() {
	wow_item_cache_item(0);
}

function wow_item_cache_item($item) {
	global $board_config, $db, $lang, $phpEx;

	// Copied from redirect() in includes/functions.php
	$server_protocol = ($board_config['cookie_secure']) ? 'https://' : 'http://';
	$server_name = preg_replace('#^\/?(.*?)\/?$#', '\1', trim($board_config['server_name']));
	$server_port = ($board_config['server_port'] <> 80) ? ':' . trim($board_config['server_port']) : '';
	$script_name = preg_replace('#^\/?(.*?)\/?$#', '\1', trim($board_config['script_path']));
	$script_name = ($script_name == '') ? $script_name : '/' . $script_name;

	if (gettype($item) == "array") {
		$query = array();
		$sql = array();

		$item = array_unique($item);
		foreach ($item as $v) if (is_numeric($v)) {
			$query[] = "items[]=" . intval($v);
			$sql[] = intval($v);
		}
		if (count($query) == 0) return false;

		$query = implode("&", $query);
		$sql = "IN (" . implode(",", $sql) . ")";
	} else if (is_numeric($item)) {
		$query = "item=" . intval($item);
		$sql = "= " . intval($item);
	} else return false;

	$db->sql_query("UPDATE " . WOW_ITEMS_TABLE . " SET item_desc='" . str_replace("'", "''", $lang['wow_items_pending']) . "' WHERE item_desc IS NULL AND item_id $sql");

	// The wow_items_cache script uses ignore_user_abort() to "asynchonously" cache items in the background.
	$handle = fopen($server_protocol . $server_name . $server_port . $script_name . "/wow_items_cache.$phpEx?$query", 'r');
	fclose($handle);

	// We may not know whether it worked or not, but we successfully made the request.
	return true;
}

function wow_item_get_info($itemnum) {
	global $db;

	if (!is_numeric($itemnum)) return false;
	if (!($result = $db->sql_query("SELECT * FROM " . WOW_ITEMS_TABLE . " WHERE item_id = " . intval($itemnum)))) return false;
	if (!($result = $db->sql_fetchrow($result))) return false;
	return $result[0];
}

function wow_item_bbcode_first_pass($text) {
	preg_match_all('#\[item(?:desc)?((?:=[1-9]\d*)?)\]([^\[]+)\[/item(?:desc)?\]#is', $text, $matches, PREG_SET_ORDER);

	// There's no way to gather useful info ahead of time on non-cached items,
	// so we'll cache them on the first pass and process on the second.
	foreach($matches as $match) {
		if ($match[1]) {
			wow_item_cache_item(intval(substr($match[1], 1)));
		} else if (preg_match('/^[1-9]\d*$/', $match[2])) {
			wow_item_cache_item(intval($match[2]));
		} else {
			// For items with description matches (e.g. "Eldre'Thalas
			// (Warlock)"), the part in parentheses is ignored during the first
			// pass, to ensure that the data is available to the second pass.
			wow_item_cache_item(wow_item_search(str_replace("\\'", "'", $match[2]), false));
		}
	}
}

function wow_item_bbcode_second_pass($text) {
	global $wibspcd;

	return preg_replace_callback('#\[item((?:desc)?)((?:=[1-9]\d*)?)\]([^\[]+)\[/item(?:desc)?\]#is', "wow_item_bbcode_second_pass_callback", $text);
}

$wibspcd = array();

function wow_item_bbcode_second_pass_callback($match) {
	global $bbcode_tpl, $lang, $wibspcd;

	// Determine whether there is a single-item match.
	if ($match[2]) {
		$id = intval(substr($match[2], 1));
	} else if (preg_match("/^[1-9]\d*$/", $match[3])) {
		$id = intval($match[3]);
	} else {
		$search = wow_item_search(str_replace("\\'", "'", $match[3]));
		if (count($search) == 1) $id = $search[0];
	}

	if ($id && ($info = wow_item_get_info($id))) {
		$url = "http://wow.allakhazam.com/db/item.html?witem=$id";
		$itemdesc = $info['item_desc'] ? $info['item_desc'] : $lang['wow_items_pending'];
		$quality = $info['item_quality'] ? $info['item_quality'] : 99;
		if ($match[2]) $text = $match[3];
		else $text = $info['item_name'];
	} else if (count($search) > 1) {
		$text = $match[3];
		$url = "http://wow.allakhazam.com/search.html?q=" . urlencode($text);
		$id = md5($text);
		$quality = 1;
		$itemdesc = str_replace(array("{SEARCH}", "{COUNT}"), array($text, count($search)), $lang['wow_items_multi']) . "<br />";
		foreach ($search as $v) $itemdesc .= "<br />[item]{$v}[/item]";
		$itemdesc = wow_item_bbcode_second_pass($itemdesc); // A dirty trick, but...
	} else if ($id) {
		// An item ID was found, but it did not return data.
		$text = $match[3];
		$url = "http://wow.allakhazam.com/search.html?q=" . urlencode($text);
		$quality = 99;
		$itemdesc = str_replace("{ID}", $id, $lang['wow_item_badid']);
	} else {
		$text = $match[3];
		$url = "http://wow.allakhazam.com/search.html?q=" . urlencode($text);
		$id = md5($text);
		$quality = 99;
		$itemdesc = str_replace("{SEARCH}", $text, $lang['wow_item_none']);
	}

	if (!in_array($id, $wibspcd)) {
		$wibspcd[] = $id;
		$idattr = " id=\"item$id\"";
		if (!$match[1]) $itemdiv = str_replace(array("{IDATTR}", "{ITEMDESC}"), array($idattr, $itemdesc), $bbcode_tpl['itemdiv']);
	} else {
		$itemdiv = "";
		$idattr = "";
	}

	if ($match[1]) {
		return str_replace(array("{IDATTR}", "{ITEMDESC}"), array($idattr, $itemdesc), $bbcode_tpl['itemdesc']);
	} else {
		return str_replace(array("{ITEMDIV}", "{QUALITY}", "{ID}", "{URL}", "{TEXT}"), array($itemdiv, $quality, $id, $url, $text), $bbcode_tpl['item']);
	}
}
