<?php /* $Id$ */

if (!defined('IN_PHPBB')) {
	die("Hacking attempt");
}

define('WOW_ITEMS_TABLE', $table_prefix.'wow_items');

function wow_item_clean($html) {
	static $wow_item_clean;

	if (!isset($wow_item_clean)) {
		$wow_item_clean['&lt;']  = '<';
		$wow_item_clean['&gt;']  = '>';
		$wow_item_clean['&quot;']  = '"';
		$wow_item_clean['&amp;']  = '&';
		$wow_item_clean['\s*(?:&nbsp;)*\s*<br\s*/>\s*(?:&nbsp;)*\s*']  = '<br />';
		$wow_item_clean['[\r\n]+']  = '';
		$wow_item_clean['<span class="iname"><span class="([^"]+)">(.+)</span></span>']  = '<span class="itemname \1">\2</span>';
		$wow_item_clean['gr[ae]yname']  = 'quality0';
		$wow_item_clean['whitename']  = 'quality1';
		$wow_item_clean['greenname']  = 'quality2';
		$wow_item_clean['bluename']  = 'quality3';
		$wow_item_clean['purplename']  = 'quality4';
		$wow_item_clean['orangename']  = 'quality5';
		$wow_item_clean['redname']  = 'quality6';
		$wow_item_clean['wowrttxt']  = 'right';
		$wow_item_clean['(<span class="itemeffect)link']  = '\1';
		$wow_item_clean['(<a[^>]*) class="itemeffectlink"']  = '\1';
		$wow_item_clean['(<a[^>]*)><span class="goldtext">(.+)</span></a>']  = '\1 class="itemdesc">\2</a>';
		$wow_item_clean['<span class="akznotice">(.+)</span>']  = '\1';
	}

	return preg_replace($html, array_keys($wow_item_clean), array_values($wow_item_clean));
}

function wow_item_search($search) {
	global $db;

	$params = preg_match('/^([^\(\)]+)(?:\(()\))?/$', $search);
	$params[0] = trim($params[0]);
	$sql = "SELECT item_id FROM " . WOW_ITEMS_TABLE . "WHERE item_name LIKE '%{$params[0]}%'";

	if (isset($params[1])) {
		$params[1] = trim($params[1]);
		$sql .= " AND item_desc LIKE '%{$params[1]}%'";
	}

	$result = $db->sql_query($sql);
	$result = $db->sql_fetchrowset($result);

	foreach ($result as $k =>$v) $result[$k] = $v['item_id'];

	return $result;
}

function wow_item_cache_map() {
	global $db;
}

function wow_item_cache_item($item) {
	global $board_config, $phpEx;

	// Copied from redirect() in includes/functions.php
	$server_protocol = ($board_config['cookie_secure']) ? 'https://' : 'http://';
	$server_name = preg_replace('#^\/?(.*?)\/?$#', '\1', trim($board_config['server_name']));
	$server_port = ($board_config['server_port'] <> 80) ? ':' . trim($board_config['server_port']) : '';
	$script_name = preg_replace('#^\/?(.*?)\/?$#', '\1', trim($board_config['script_path']));
	$script_name = ($script_name == '') ? $script_name : '/' . $script_name;

	// The wow_item_cache script uses ignore_user_abort() to "asynchonously" cache items in the background.
	$handle = fopen($server_protocol . $server_name . $server_port . $script_name . "wow_item_cache.$phpEx?item=$item", 'r');
	fclose($handle);
}

function wow_item_cache_items($items) {
	foreach ($items as $v) wow_item_cache_item($v);
}

function wow_item_get_info($itemnum) {
	$fetch_url = "http://wow.allakhazam.com/dev/wow/item-xml.pl?witem=" + $item_num;
}

function wow_item_bbcode_first_pass($text, $uid) {
	$result = $text;

	$callback = create_function('$matches', '
		$uid = ' . $uid . ';
		$q = 1;
		$sql = "SELECT item_quality FROM " . WOW_ITEMS_TABLE . " WHERE item_id = " . $id;
	');

	preg_replace_callback('#\[item((?:desc)?)\]([^\[]+)\[/item(?:desc)?\]#is', $callback, $text);
}

function wow_item_bbcode_second_pass($text, $uid) {
}
