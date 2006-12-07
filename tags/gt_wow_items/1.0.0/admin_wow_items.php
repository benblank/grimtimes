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

	$itemlist['mc'] = array( /* Does not include Tier 1 drops */
		17063, 17066, 17069, 17071, 17072, 17073, 17074, 17076, 17077, 17082,
		17102, 17103, 17104, 17105, 17106, 17107, 17109, 17110, 18203, 18803,
		18805, 18806, 18808, 18809, 18810, 18811, 18812, 18814, 18815, 18816,
		18817, 18820, 18821, 18822, 18823, 18824, 18829, 18832, 18842, 18861,
		18870, 18872, 18875, 18878, 18879, 19136, 19137, 19138, 19139, 19140,
		19142, 19143, 19144, 19145, 19146, 19147, 27079,
	);
	$itemlist['ony'] = array( /* Quest rewards and unique drops, sans Tier 2 helms */
		15410, 17064, 17067, 17068, 17075, 17078, 17966, 18205, 18403, 18404, 18406, 18813,
	);
	$itemlist['pvp_a'] = array(
		12584, 15196, 15198, 16342, 16369, 16391, 16392, 16393, 16396, 16397, 16401,
		16403, 16405, 16406, 16409, 16410, 16413, 16414, 16415, 16416, 16417, 16418,
		16419, 16420, 16421, 16422, 16423, 16424, 16425, 16426, 16427, 16428, 16429,
		16430, 16431, 16432, 16433, 16434, 16435, 16436, 16437, 16440, 16441, 16442,
		16443, 16444, 16446, 16448, 16449, 16450, 16451, 16452, 16453, 16454, 16455,
		16456, 16457, 16459, 16462, 16463, 16465, 16466, 16467, 16468, 16471, 16472,
		16473, 16474, 16475, 16476, 16477, 16478, 16479, 16480, 16483, 16484, 17562,
		17564, 17566, 17567, 17568, 17569, 17578, 17579, 17580, 17581, 17583, 17584,
		17594, 17596, 17598, 17599, 17600, 17601, 17602, 17603, 17604, 17605, 17607,
		17608, 18241, 18242, 18243, 18244, 18440, 18441, 18442, 18443, 18444, 18445,
		18447, 18448, 18449, 18452, 18453, 18454, 18455, 18456, 18457, 18606, 18825,
		18827, 18830, 18833, 18836, 18838, 18839, 18841, 18843, 18847, 18854, 18855,
		18856, 18857, 18858, 18859, 18862, 18863, 18864, 18865, 18867, 18869, 18873,
		18876, 23272, 23273, 23274, 23275, 23276, 23277, 23278, 23279, 23280, 23281,
		23282, 23283, 23284, 23285, 23286, 23287, 23288, 23289, 23290, 23291, 23292,
		23293, 23294, 23295, 23296, 23297, 23298, 23299, 23300, 23301, 23302, 23303,
		23304, 23305, 23306, 23307, 23308, 23309, 23310, 23311, 23312, 23313, 23314,
		23315, 23316, 23317, 23318, 23319, 23451, 23452, 23453, 23454, 23455, 23456,
		25829, 28118, 28119, 28120, 28123, 28234, 28235, 28236, 28237, 28238, 28244,
		28245, 28246, 28247, 28362, 28363, 29465, 29467, 29468, 29471, 30348, 30350,
	);
	$itemlist['pvp_a_ab'] = array(
		17349, 17352, 20041, 20042, 20043, 20045, 20046, 20047, 20048, 20049,
		20050, 20052, 20053, 20054, 20055, 20057, 20058, 20059, 20060, 20061,
		20069, 20070, 20071, 20073, 20088, 20089, 20090, 20091, 20092, 20093,
		20094, 20095, 20096, 20097, 20098, 20099, 20100, 20101, 20102, 20103,
		20104, 20105, 20106, 20107, 20108, 20109, 20110, 20111, 20112, 20113,
		20114, 20115, 20116, 20117, 20124, 20125, 20126, 20127, 20128, 20129,
		20132, 20225, 20226, 20227, 20237, 20243, 20244, 21117, 21118, 21119,
	);
	$itemlist['pvp_a_av'] = array(
		17348, 17349, 17351, 17352, 19030, 19032, 19045, 19084, 19086,
		19091, 19092, 19093, 19094, 19097, 19098, 19100, 19102, 19104,
		19301, 19307, 19308, 19309, 19310, 19311, 19312, 19315, 19316,
		19317, 19318, 19319, 19320, 19321, 19323, 19324, 19325, 21563,
	);
	$itemlist['pvp_a_wsg'] = array(
		19514, 19515, 19516, 19517, 19522, 19523, 19524, 19525, 19530,
		19531, 19532, 19533, 19538, 19539, 19540, 19541, 19546, 19547,
		19548, 19549, 19554, 19555, 19556, 19557, 19562, 19563, 19564,
		19565, 19570, 19571, 19572, 19573, 20428, 20431, 20434, 20438,
		20439, 20440, 20443, 20444, 21565, 21566, 21567, 21568, 19578,
		19580, 19581, 19582, 19583, 19584, 19587, 19589, 19590, 19595,
		19596, 19597, 22672, 22748, 22749, 22750, 22752, 22753, 17349,
		17351, 17352, 19060, 19061, 19062, 19066, 19067, 19068, 19506,
	);
	$itemlist['pvp_h'] = array(
		15197, 15199, 15200, 16335, 16341, 16345, 16485, 16486, 16487, 16489, 16490,
		16491, 16492, 16494, 16496, 16497, 16498, 16499, 16501, 16502, 16503, 16504,
		16505, 16506, 16507, 16508, 16509, 16510, 16513, 16514, 16515, 16516, 16518,
		16519, 16521, 16522, 16523, 16524, 16525, 16526, 16527, 16528, 16530, 16531,
		16532, 16533, 16534, 16535, 16536, 16539, 16540, 16541, 16542, 16543, 16544,
		16545, 16548, 16549, 16550, 16551, 16552, 16554, 16555, 16558, 16560, 16561,
		16562, 16563, 16564, 16565, 16566, 16567, 16568, 16569, 16571, 16573, 16574,
		16577, 16578, 16579, 16580, 17570, 17571, 17572, 17573, 17576, 17577, 17586,
		17588, 17590, 17591, 17592, 17593, 17610, 17611, 17612, 17613, 17616, 17617,
		17618, 17620, 17622, 17623, 17624, 17625, 18245, 18246, 18247, 18248, 18427,
		18428, 18429, 18430, 18432, 18434, 18435, 18436, 18437, 18461, 18607, 18826,
		18828, 18831, 18834, 18835, 18837, 18839, 18840, 18841, 18844, 18845, 18846,
		18848, 18849, 18850, 18851, 18852, 18853, 18860, 18866, 18868, 18871, 18874,
		18877, 22843, 22852, 22855, 22856, 22857, 22858, 22859, 22860, 22862, 22863,
		22864, 22865, 22867, 22868, 22869, 22870, 22872, 22873, 22874, 22875, 22876,
		22877, 22878, 22879, 22880, 22881, 22882, 22883, 22884, 22885, 22886, 22887,
		23243, 23244, 23251, 23252, 23253, 23254, 23255, 23256, 23257, 23258, 23259,
		23260, 23261, 23262, 23263, 23264, 23464, 23465, 23466, 23467, 23468, 23469,
		24551, 28118, 28119, 28120, 28123, 28239, 28240, 28241, 28243, 28244, 28245,
		28246, 28247, 28362, 28363, 29466, 29469, 29470, 29472, 30343, 30344, 30346,
	);
	$itemlist['pvp_h_ab'] = array(
		20072, 20131, 20150, 20151, 20152, 20153, 20154, 20155, 20156, 20157,
		20159, 20160, 20161, 20162, 20163, 20164, 20165, 20166, 20167, 20168,
		20169, 20170, 20171, 20172, 20173, 20174, 20186, 20187, 20188, 20189,
		20190, 20191, 20192, 20193, 20195, 20196, 20197, 20198, 20199, 20200,
		20201, 20202, 20204, 20205, 20206, 20207, 20208, 20209, 20210, 20211,
		21115, 21116, 21120, 20068, 20158, 20175, 20176, 20194, 20203, 20212,
		20214, 20220, 17349, 17352, 20222, 20223, 20224, 20232, 20234, 20235,
	);
	$itemlist['pvp_h_av'] = array(
		19046, 19083, 19085, 19087, 19088, 19089, 19090, 19095, 19096,
		19099, 19101, 19103, 19319, 19320, 19316, 19317, 19029, 19308,
		19309, 19310, 19311, 19312, 19315, 19321, 19323, 19324, 19325,
		21563, 17348, 17349, 17351, 17352, 19031, 19301, 19307, 19318,
	);
	$itemlist['pvp_h_wsg'] = array(
		17348, 17349, 17351, 17352, 19060, 19061, 19062, 19066, 19067,
		19068, 19505, 19510, 19511, 19512, 19513, 19518, 19519, 19520,
		19521, 19526, 19527, 19528, 19529, 19534, 19535, 19536, 19537,
		19542, 19543, 19544, 19545, 19550, 19551, 19552, 19553, 19558,
		19559, 19560, 19561, 19566, 19567, 19568, 19569, 19578, 19580,
		19581, 19582, 19583, 19584, 19587, 19589, 19590, 19595, 19596,
		19597, 20425, 20426, 20427, 20428, 20429, 20430, 20431, 20434,
		20437, 20438, 20439, 20440, 20441, 20442, 20443, 20444, 21565,
		21566, 21567, 21568, 22651, 22673, 22676, 22740, 22741, 22747,
	);
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
		/* Mage    */ 16795, 16796, 16797, 16798, 16799, 16800, 16801, 16802,
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
		/* Rogue   */ 22476, 22477, 22478, 22479, 22480, 22481, 22482, 22483, // Ring not yet seen by Allakhazam's
		/* Shaman  */ 22464, 22465, 22466, 22467, 22468, 22469, 22470, 22471, // Ring not yet seen by Allakhazam's
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
		/* Other   */ 19948, 19949, 19950, // Zandalarian Hero's X
	);

	$status = array();

	$updating = false;
	if (isset($HTTP_POST_VARS['update']) && $HTTP_POST_VARS['update'] == 1) {
		wow_item_cache_map();
		$updating = true;
		$status[] = $lang['wow_items_status_update'];
	}

	$precaching = array();
	if (isset($HTTP_POST_VARS['precache']) && count($HTTP_POST_VARS['precache']) > 0) {
		foreach ($HTTP_POST_VARS['precache'] as $set) {
			wow_item_cache_item($itemlist[$set]);
			$precaching[] = $set;
			$status[] = str_replace("{SET}", $lang['wow_items_set'][$set], $lang['wow_items_status_precache']);
		}
	}

	$template->set_filenames(array("body" => "admin/wow_items.tpl"));

	foreach($status as $text) $template->assign_block_vars("status", array("TEXT" => $text));

	$items = array();
	$update_items = $updating ? $lang['wow_items_cache_updating'] : 0;
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
		"UPDATE_ITEMS" => $update_items - 1, // Don't count the index
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
		$set_updating = $updating || in_array($set, $precaching);
		$set_status = ($cached == $count) ? $lang['Yes'] : ($set_updating ? $lang['wow_items_cache_updating'] : (($cached == 0) ? $lang['No'] : $lang['wow_items_precache_partial']));

		$template->assign_block_vars("precache", array(
			"ROW_CLASS" => $row_class,

			"SET_CHECKBOX" => '<input type="checkbox" name="precache[]"' . (($set_updating || ($cached == $count)) ? ' disabled="disabled"' : '') . ' value="' . $set . '"></input>',
			"SET_NAME" => $lang['wow_items_set'][$set],
			"SET_COUNT" => $count,
			"SET_STATUS" => $set_status,
		));
	}

	$template->pparse("body");

	include('./page_footer_admin.'.$phpEx);
?>
