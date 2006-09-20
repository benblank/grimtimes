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

function wow_item_search($search) {
	global $db;

	$params = preg_match('/^([^\(\)]+)(?:\(()\))?/$', $search);
	$params[0] = trim($params[0]);
	$sql = "SELECT item_id FROM " . WOW_ITEMS_TABLE . " WHERE item_name LIKE '%{$params[0]}%'";

	if (isset($params[1])) {
		$params[1] = trim($params[1]);
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
	global $board_config, $phpEx;

	// Copied from redirect() in includes/functions.php
	$server_protocol = ($board_config['cookie_secure']) ? 'https://' : 'http://';
	$server_name = preg_replace('#^\/?(.*?)\/?$#', '\1', trim($board_config['server_name']));
	$server_port = ($board_config['server_port'] <> 80) ? ':' . trim($board_config['server_port']) : '';
	$script_name = preg_replace('#^\/?(.*?)\/?$#', '\1', trim($board_config['script_path']));
	$script_name = ($script_name == '') ? $script_name : '/' . $script_name;

	if (gettype($item) == "array") {
		// Do array stuff
	} else if (is_numeric($item)) {
		// Do numeric stuff
	} else return false;

	// The wow_items_cache script uses ignore_user_abort() to "asynchonously" cache items in the background.
	$handle = fopen($server_protocol . $server_name . $server_port . $script_name . "wow_items_cache.$phpEx?item=$item", 'r');
	fclose($handle);

	// We may not know whether it worked or not, but we successfully made the request.
	return true;
}

function wow_item_get_info($itemnum) {
	if (!is_numeric($itemnum)) return false;
	if (!($result = $db->sql_query("SELECT * FROM " . WOW_ITEMS_TABLE . " WHERE item_id = " . intval($itemnum)))) return false;
	if (!($result = $db->sql_fetchrow($result))) return false;
	return $result[0];
}

// Wow_Item_Bbode_Pass_Data -- I tried to prevent having this
// global, but frankly, it was just too much trouble.
$wibpd = array('uid' => "", 'list' => array());

function wow_item_bbcode_first_pass($text, $uid) {
	global $wibpd;

	$wibpd['uid'] = $uid;
	preg_replace_callback('#\[item((?:desc)?)((?:=\d+)?)\]([^\[]+)\[/item(?:desc)?\]#is', $callback, $text);
}

function wow_item_bbcode_first_pass_callback($matches) {
	global $wibpd;

	$tag = $matches[1];
	$id = "";
	$q = 1;
	$text = $matches[3];

	if ($matches[2]) {
		$id = $matches[2];
		$info = wow_item_get_info($matches[2]);
		if ($info) $q = $info['item_quality'];
	} else if (preg_match('/^\d+$/', $matches[3])) {
		$info = wow_item_get_info($matches[3]);
		if ($info) $q = $info['item_quality'];
	} else {
		$info = wow_item_search($matches[3]);
		if ($info && count($info) == 1) {
			$id = ":" . $info[0];
			$info = wow_item_get_info($info[0]);
			if ($info) $q = $info['item_quality'];
		}
	}

	return "[item$tag$id:$q]$text[/item$tag]";
}

function wow_item_bbcode_second_pass($text, $uid) {
	global $wibpd;

}
