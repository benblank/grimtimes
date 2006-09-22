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

	$itemlist['pvp_a_ab'] = array();
	$itemlist['pvp_a_av'] = array();
	$itemlist['pvp_a_honor'] = array();
	$itemlist['pvp_a_wsg'] = array();
	$itemlist['pvp_h_ab'] = array();
	$itemlist['pvp_h_av'] = array();
	$itemlist['pvp_h_honor'] = array();
	$itemlist['pvp_h_wsg'] = array();
	$itemlist['tier0'] = array(
		/* Druid   */ 16706, 16714, 16715, 16716, 16717, 16718, 16719, 16720,
		/* Hunter  */ 16674, 16675, 16676, 16677, 16678, 16679, 16680, 16681,
		/* Mage    */ 16682, 16683, 16684, 16685, 16686, 16687, 16688, 16689,
		/* Paladin */ 16722, 16723, 16724, 16725, 16726, 16727, 16728, 16729,
		/* Priest  */ 16690, 16691, 16692, 16693, 16694, 16695, 16696, 16697,
		/* Rogue   */ 16707, 16708, 16709, 16710, 16711, 16712, 16713, 16721,
		/* Shaman  */ 16666, 16667, 16668, 16669, 16670, 16671, 16672, 16673,
		/* Warlock */ 16698, 16699, 16700, 16701, 16702, 16703, 16704, 16705,
		/* Warrior */ 16730, 16731, 16732, 16733, 16734, 16735, 16736, 16737,
	);
	$itemlist['tier0_5'] = array(
		/* Druid   */ 22106, 22107, 22108, 22109, 22110, 22111, 22112, 22113,
		/* Hunter  */ 22010, 22011, 22013, 22015, 22016, 22017, 22060, 22061,
		/* Mage    */ 22062, 22063, 22064, 22065, 22066, 22067, 22068, 22069,
		/* Paladin */ 22086, 22087, 22088, 22089, 22090, 22091, 22092, 22093,
		/* Priest  */ 22078, 22079, 22080, 22081, 22082, 22083, 22084, 22085,
		/* Rogue   */ 22002, 22003, 22004, 22005, 22006, 22007, 22008, 22009,
		/* Shaman  */ 22095, 22096, 22097, 22098, 22099, 22100, 22101, 22102,
		/* Warlock */ 22070, 22071, 22072, 22073, 22074, 22075, 22076, 22077,
		/* Warrior */ 21994, 21995, 21996, 21997, 21998, 21999, 22000, 22001,
	);
	$itemlist['tier1'] = array(
		/* Druid   */ 16828, 16829, 16830, 16831, 16833, 16834, 16835, 16836,
		/* Hunter  */ 16845, 16846, 16847, 16848, 16849, 16850, 16851, 16852,
		/* Mage    */ 16795, 16796, 19797, 16798, 16799, 16800, 16801, 16802,
		/* Paladin */ 16853, 16854, 16855, 16856, 16857, 16858, 16859, 16860,
		/* Priest  */ 16811, 16812, 16813, 16814, 16815, 16816, 16817, 16819,
		/* Rogue   */ 16820, 16821, 16822, 16823, 16824, 16825, 16826, 16827,
		/* Shaman  */ 16837, 16838, 16839, 16840, 16841, 16842, 16843, 16844,
		/* Warlock */ 16803, 16804, 16805, 16806, 16807, 16808, 16809, 16810,
		/* Warrior */ 16861, 16862, 16863, 16864, 16865, 16866, 16867, 16868,
	);
	$itemlist['tier2'] = array(
		/* Druid   */ 16897, 16898, 16899, 16900, 16901, 16902, 16903, 16904,
		/* Hunter  */ 16935, 16936, 16937, 16938, 16939, 16940, 16941, 16942,
		/* Mage    */ 16818, 16912, 16913, 16914, 16915, 16916, 16917, 16918,
		/* Paladin */ 16951, 16952, 16953, 16954, 16955, 16956, 16957, 16958,
		/* Priest  */ 16919, 16920, 16921, 16922, 16923, 16924, 16925, 16926,
		/* Rogue   */ 16832, 16905, 16906, 16907, 16908, 16909, 16910, 16911,
		/* Shaman  */ 16943, 16944, 16945, 16946, 16947, 16948, 16949, 16950,
		/* Warlock */ 16927, 16928, 16929, 16930, 16931, 16932, 16933, 16934,
		/* Warrior */ 16959, 16960, 16961, 16962, 16963, 16964, 16965, 16966,
	);
	$itemlist['tier3'] = array(
		/* Druid   */ 22488, 22489, 22490, 22491, 22492, 22493, 22494, 22495, 23064,
		/* Hunter  */ 22436, 22437, 22438, 22439, 22440, 22441, 22442, 22443, 23067,
		/* Mage    */ 22496, 22497, 22498, 22499, 22500, 22501, 22502, 22503, 23062,
		/* Paladin */ 22424, 22425, 22426, 22427, 22428, 22429, 22430, 22431, 23066,
		/* Priest  */ 22512, 22513, 22514, 22515, 22516, 22517, 22518, 22519, 23061,
		/* Rogue   */ 22476, 22477, 22478, 22479, 22480, 22481, 22482, 22483, // Not yet seen
		/* Shaman  */ 22464, 22465, 22466, 22467, 22468, 22469, 22470, 22471, // Not yet seen
		/* Warlock */ 22504, 22505, 22506, 22507, 22508, 22509, 22510, 22511, 23063,
		/* Warrior */ 22416, 22417, 22418, 22419, 22420, 22421, 22422, 22423, 23059,
	);
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
	$itemlist['zg_quest'] = array(
		/* Druid   */ 19610, 19611, 19612, 19613, 19838, 19839, 19840, 19955,
		/* Hunter  */ 19618, 19619, 19620, 19621, 19831, 19832, 19833, 19953,
		/* Mage    */ 19598, 19599, 19600, 19601, 19845, 19846, 19959, 20034,
		/* Paladin */ 19579, 19585, 19586, 19588, 19825, 19826, 19827, 19952,
		/* Priest  */ 19591, 19592, 19593, 19594, 19841, 19842, 19843, 19958,
		/* Rogue   */ 19614, 19615, 19616, 19617, 19834, 19835, 19836, 19954,
		/* Shaman  */ 19606, 19607, 19608, 19609, 19828, 19829, 19830, 19956,
		/* Warlock */ 19602, 19603, 19604, 19605, 19848, 19849, 19957, 20033,
		/* Warrior */ 19574, 19575, 19576, 19577, 19822, 19823, 19824, 19951,
		/* Other   */ 19948, 19949, 19950,
	);

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

			"SET_CHECKBOX" => '<input type="checkbox" name="precache[]"' . ($cached == $count ? ' disabled="disabled"' : '') . ' value="' . $set . '"></input>',
			"SET_NAME" => $lang['wow_items_set'][$set],
			"SET_COUNT" => $count,
			"SET_STATUS" => $set_status,
		));
	}

	$template->pparse("body");

	include('./page_footer_admin.'.$phpEx);
?>
