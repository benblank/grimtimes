<?php /* $Id$ */

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

function wow_item_clean($html) {
	global $wow_item_clean;

	return preg_replace($html, array_keys($wow_item_clean), array_values($wow_item_clean));
}

function wow_item_get_id($name) {
	global $db;

	$result = $db->sql_query("SELECT item_stamp FROM " . WOW_ITEMS_TABLE . " WHERE item_id = 0");
}

function wow_item_get_info($itemnum) {
	$fetch_url = "http://wow.allakhazam.com/dev/wow/item-xml.pl?witem=" + $item_num;
}
