<?php /* $Id$ */

function wow_image_race($race, $gender, $service = "", $svcname = "") {
	global $lang;

	$img = "<img border=\"0\" src=\"images/gt_wow_profiles/$race-$gender.gif\" alt=\"{$lang['wow_gender'][$gender]} {$lang['wow_race'][$race] }\" title=\"{$lang['wow_gender'][$gender]} {$lang['wow_race'][$race]}\"/>";
	return ($service && $svcname) ? wow_link_service($service, $svcname, $img) : $img;
}

function wow_image_class($class, $talents = "", $title = "") {
	global $lang;

	if ($title) $title = " ($title)";
	else $title = "";

	$img = "<img border=\"0\" src=\"images/gt_wow_profiles/$class.gif\" alt=\"{$lang['wow_class'][$class]}$title \" title=\"{$lang['wow_class'][$class]}$title\"/>";
	return $talents ? wow_link_talents($class, $talents, $img) : $img;
}

function wow_image_pvp_rank($rank, $race = "") {
	global $lang;

	if (!array_key_exists($race, $lang['wow_race_faction'])) $race = "";

	if ($rank) return "<img border=\"0\" src=\"images/gt_wow_profiles/rankgif.php?rank=$rank\" alt=\"{$lang['wow_pvp_rank'][$lang['wow_race_faction'][$race]][$rank]} \" title=\"{$lang['wow_pvp_rank'][$lang['wow_race_faction'][$race]][$rank]}\"/>";
}

function wow_link_service($service, $name, $text = "Profile") {
	global $lang;

	if (!array_key_exists($service, $lang['wow_profile_service_url'])) return "";

	return '<a target="_blank" href="' . str_replace("{PROFILE}", $name, $lang['wow_profile_service_url'][$service]) . "\">$text</a>";
}

function wow_link_talents($class, $talents, $text = "Talents") {
	global $lang;

	return '<a target="_blank" href="http://www.worldofwarcraft.com/info/classes/' . strtolower($lang['wow_class'][$class]) . "/talents.html?$talents\">$text</a>";
}

function wow_script_talents() {
	global $lang;

	$script = <<<WOW_SCRIPT_TALENTS_DECLARE
//<![CDATA[
function wow_validate_talents() {
	if (!document.getElementById) return;

	var talents = document.getElementById("wow_talents");
	var class = document.getElementById("wow_class");
	if (!talents || !class || !talents.value) return;

	var urls = new Array();
WOW_SCRIPT_TALENTS_DECLARE;

	$i = 0;
	foreach ($lang['wow_talent_service_url'] as $url) {
		$class = strpos($url, '{CLASS}');
		$talents = strpos($url, '{TALENTS}');

		$class = ($class < $talents) ? 1 : 2;
		$talents = ($class == 1) ? 2 : 1;

		$url = str_replace(array('\{CLASS\}', '\{TALENTS\}', '\\'), array('([A-Za-z]+)', '([0-9]+)', '\\\\'), preg_quote($url));
		$script .= "\n\turls[$i] = new Array(new RegExp('$url'), $class, $talents);";
		$i++;
	}

	$script .= <<<WOW_SCRIPT_TALENTS_PROCESS

	var matches;
	for (var i = 0; i < $i; i++) {
		matches = urls[i][0](talents.value);
		if (!matches) continue;

		talents.value = matches[urls[i][2]];
		var class_val = matches[urls[i][1]].toLowerCase();

		for (var j = 1; j < class.childNodes.length; j++) {
			if (class.childNodes[j].innerHTML.toLowerCase() == class_val) {
				class.selectedIndex = j;
				break;
			}
		}

		break;
	}
}
//]]>
WOW_SCRIPT_TALENTS_PROCESS;

	return $script;
}

?>
