<?php /* $Id$ */

	define('IN_PHPBB', 1);

	if(!empty($setmodules)) {
		$filename = basename(__FILE__);
		$module['General']['wow_items_admin'] = $filename;

		return;
	}

	$phpbb_root_path = "./../";
	require($phpbb_root_path . 'extension.inc');
	require('./pagestart.' . $phpEx);

	include($phpbb_root_path . 'includes/functions_wow_items.'.$phpEx);

	$itemlist['pvp_ab'] = array();
	$itemlist['pvp_av'] = array();
	$itemlist['pvp_honor'] = array();
	$itemlist['pvp_wsg'] = array();
	$itemlist['tier0'] = array(
		/* Druid   */ 16706, 16714, 16715, 16716, 16717, 16718, 16719, 16720,
		/* Hunter  */ 16674, 16675, 16676, 16677, 16678, 16679, 16680, 16681,
		/* Mage    */ 16682, 16683, 16684, 16685, 16686, 16687, 16688, 16689,
		/* Paladin */ 16722, 16723, 16724, 16725, 16726, 16727, 16728, 16729,
		/* Priest  */ 16690, 16691, 16692, 16693, 16694, 16695, 16696, 16697,
		/* Rogue   */ 16707, 16708, 16709, 16710, 16711, 16712, 16713, 16721,
		/* Shaman  */ 16666, 16667, 16668, 16669, 16670, 16671, 16672, 16673,
		/* Warlock */ 16798, 16799, 16700, 16701, 16702, 16703, 16704, 16705,
		/* Warrior */ 16730, 16731, 16732, 16733, 16734, 16735, 16736, 16737,
	);
	$itemlist['tier0_5'] = array();
	$itemlist['tier1'] = array();
	$itemlist['tier2'] = array();
	$itemlist['tier3'] = array();
	$itemlist['zg_loot'] = array( /* Blue or better boss/trash drops, sans quest items */
		19727, 19852, 19853, 19854, 19855, 19856, 19857, 19859, 19861, 19862, 19863, 19864,
		19865, 19866, 19867, 19869, 19870, 19871, 19872, 19873, 19874, 19875, 19876, 19877,
		19878, 19884, 19885, 19886, 19887, 19888, 19889, 19890, 19891, 19892, 19893, 19894,
		19895, 19896, 19897, 19898, 19899, 19900, 19901, 19902, 19903, 19904, 19905, 19906,
		19907, 19908, 19909, 19910, 19912, 19913, 19914, 19915, 19918, 19919, 19920, 19921,
		19922, 19923, 19925, 19927, 19928, 19929, 19930, 19944, 19945, 19946, 19947, 19961,
		19962, 19963, 19964, 19965, 19967, 19968, 19993, 20032, 20038, 20257, 20258, 20259,
		20260, 20261, 20262, 20263, 20264, 20265, 20266, 22711, 22712, 22713, 22714, 22715,
		22716, 22718, 22720, 22721, 22722, 22739,
	);
	$itemlist['zg_quest'] = array();

	$status = array();

	$updating = false;
	if (isset($HTTP_POST_VARS['update']) && $HTTP_POST_VARS['update'] == 1) {
		wow_item_cache_map();
		$updating = true;
		$status[] = $lang['wow_items_status_update'];
	}

	if (isset($HTTP_POST_VARS['precache']) && count($HTTP_POST_VARS['precache']) > 0) {
		foreach ($HTTP_POST_VARS['precache'] as $set) {
			wow_item_cache_item($itemlist[$set]);
			$status[] = str_replace("{SET}", $lang['wow_items_set'][$set], $lang['wow_items_status_precache']);
		}
	}

	$template->set_filenames(array("body" => "admin/wow_items.tpl"));

	foreach($status as $text) $template->assign_block_vars("status", array("TEXT" => $text));

	$items = array();
	$update_items = 0;
	$update_cached = $updating ? $lang['wow_items_cache_updating'] : 0;

	if ($result = $db->sql_query("SELECT item_id FROM " . WOW_ITEMS_TABLE))
		if ($result = $db->sql_fetchrowset($result))
			$update_items = count($result);

	if ($result = $db->sql_query("SELECT item_id FROM " . WOW_ITEMS_TABLE . " WHERE item_desc IS NOT NULL"))
		if ($result = $db->sql_fetchrowset($result)) {
			$update_cached = count($result) - ($updating ? 1 : 0); // I really wish I knew why this is necessary...
			foreach ($result as $row) $items[] = $row['item_id'];
		}

	$template->assign_vars(array(
		"UPDATE_ITEMS" => $update_items,
		"UPDATE_CACHED" => $update_cached,

		"L_WOW_TITLE" => $lang['wow_items_admin_title'],
		"L_WOW_TEXT" => $lang['wow_items_admin_text'],
		"L_UPDATE" => $lang['wow_items_cache_stats'],
		"L_UPDATE_ITEMS" => $lang['wow_items_cache_available'],
		"L_UPDATE_CACHED" => $lang['wow_items_cache_current'],
		"L_UPDATE_SUBMIT" => $lang['wow_items_cache_update'],
		"L_PRECACHE_SET" => $lang['wow_items_precache_set'],
		"L_PRECACHE_COUNT" => $lang['wow_items_precache_count'],
		"L_PRECACHE_STATUS" => $lang['wow_items_precache_status'],
		"L_PRECACHE_SUBMIT" => $lang['wow_items_precache_submit'],

		"S_WOW_ACTION" => append_sid("admin_wow_items.$phpEx"),
		"S_UPDATE_HIDDEN" => '<input type="hidden" name="update" value="1" />',
	));

	foreach($itemlist as $set => $array) {
		$count = count($array);
		if ($count == 0) continue;

		$row_class = (!($i % 2)) ? $theme['td_class1'] : $theme['td_class2'];

		$count = count($array);
		$cached = count(array_intersect($array, $items));
		$set_status = ($cached == $count) ? $lang['Yes'] : (($cached == 0) ? $lang['No'] : $lang['wow_items_precache_partial']);

		$template->assign_block_vars("precache", array(
			"ROW_CLASS" => $row_class,

			"SET_CHECKBOX" => '<input type="checkbox" name="precache[]" value="' . $set . '"></input>',
			"SET_NAME" => $lang['wow_items_set'][$set],
			"SET_COUNT" => $count,
			"SET_STATUS" => $set_status,
		));
	}

	$template->pparse("body");

	include('./page_footer_admin.'.$phpEx);
?>
