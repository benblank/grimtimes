##############################################################
##
## $Id$
##
## MOD Title: Grim Times: WoW Profiles for phpBB
## MOD Author: Malefactor < N/A > (N/A) http://code.google.com/p/grimtimes/
## MOD Description: Adds fields for WoW race, class, PvP rank,
## gender, profile and talent build to user profiles and posts.
## MOD Version: 1.0.0
##
## Installation Level: Easy
## Installation Time: 5 Minutes
##
## Files To Edit: 10
##     includes/functions.php
##     includes/functions_selects.php
##     includes/usercp_avatar.php
##     includes/usercp_register.php
##     includes/usercp_viewprofile.php
##     language/lang_english/lang_main.php
##     templates/subSilver/profile_add_body.tpl
##     templates/subSilver/profile_view_body.tpl
##     templates/subSilver/viewtopic_body.tpl
##     viewtopic.php
##
## Included Files: 45
##     images/*.gif => images/gt_wow_profiles/*.gif
##     images/rankgif.php => images/gt_wow_profiles/rankgif.php
##
## License: http://opensource.org/licenses/bsd-license.php The BSD License
##
##############################################################
##
## For security purposes, please check: http://www.phpbb.com/mods/
## for the latest version of this MOD. Although MODs are checked
## before being allowed in the MODs Database there is no guarantee
## that there are no security problems within the MOD. No support
## will be given for MODs not found within the MODs Database which
## can be found at http://www.phpbb.com/mods/
##
##############################################################
##
## Author Notes:
##
## Adds fields in user profile (edit) for "WoW Race", "WoW Class",
## "WoW Profile Service" (CTProfiles, Thottbot, or Allakhazam), "WoW
## Profile Name/Number", "WoW Talents", and "WoW PvP Rank".  WoW
## talents are specified using the same format as for the official
## WoW Forum.  Use the Talent Calculator on the official web site
## and copy the string of numbers from the URL.
##
##############################################################
##
## Before Adding This MOD To Your Forum, You Should Back Up All Files Related To This MOD
##
##############################################################

#
#-----[ SQL ]-------------------------------------------
#

ALTER TABLE phpbb_users ADD user_wow_race VARCHAR(2) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_gender VARCHAR(1) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_class VARCHAR(2) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_profile_service VARCHAR(8) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_profile_name VARCHAR(64) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_talents VARCHAR(108) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_talents_title VARCHAR(32) DEFAULT '' NOT NULL;
ALTER TABLE phpbb_users ADD user_wow_pvp_rank TINYINT UNSIGNED DEFAULT 0 NOT NULL;

#
#-----[ COPY ]------------------------------------------
#

copy images/*.gif to images/gt_wow_profiles/*.gif
copy images/rankgif.php to images/gt_wow_profiles/rankgif.php

#
#-----[ OPEN ]------------------------------------------
#

includes/functions.php

#
#-----[ FIND ]------------------------------------------
#

?>

#
#-----[ BEFORE, ADD ]------------------------------------------
#

// BEGIN -- Grim Times: WoW Profiles for phpBB

function wow_image_race($race, $gender, $service = "", $svcname = "") {
	global $lang;

	$img = "<img border=\"0\" src=\"images/gt_wow_profiles/$race-$gender.gif\" alt=\"{$lang['wow_genders'][$gender]} {$lang['wow_races'][$race] }\" title=\"{$lang['wow_genders'][$gender]} {$lang['wow_races'][$race]}\"/>";
	return ($service && $svcname) ? wow_link_service($service, $svcname, $img) : $img;
}

function wow_image_class($class, $talents = "", $title = "") {
	global $lang;

	if ($title) $title = " ($title)";
	else $title = "";

	$img = "<img border=\"0\" src=\"images/gt_wow_profiles/$class.gif\" alt=\"{$lang['wow_classes'][$class]}$title \" title=\"{$lang['wow_classes'][$class]}$title\"/>";
	return $talents ? wow_link_talents($class, $talents, $img) : $img;
}

function wow_image_pvp_rank($rank, $race = "") {
	global $lang;

	if (!array_key_exists($race, $lang['wow_race_factions'])) $race = "";

	if ($rank) return "<img border=\"0\" src=\"images/gt_wow_profiles/rankgif.php?rank=$rank\" alt=\"{$lang['wow_pvp_ranks'][$lang['wow_race_factions'][$race]][$rank]} \" title=\"{$lang['wow_pvp_ranks'][$lang['wow_race_factions'][$race]][$rank]}\"/>";
}

function wow_link_service($service, $name, $text = "Profile") {
	static $services = array(
		"ak" => "http://wow.allakhazam.com/profile.html?%s",
		"ct" => "http://ctprofiles.net/%s",
		"tb" => "http://www.thottbot.com/?profile=%s",
	);

	if (!array_key_exists($service, $services)) return "";

	return '<a target="_blank" href="' . sprintf($services[$service], $name) . '">' . $text . '</a>';
}

function wow_link_talents($class, $talents, $text = "Talents") {
	global $lang;

	return '<a target="_blank" href="http://www.worldofwarcraft.com/info/classes/' . strtolower($lang['wow_classes'][$class]) . "/talents.html?$talents\">$text</a>";
}

// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ OPEN ]------------------------------------------
#

includes/functions_selects.php

#
#-----[ FIND ]------------------------------------------
#

?>

#
#-----[ BEFORE, ADD ]------------------------------------------
#

// BEGIN -- Grim Times: WoW Profiles for phpBB

function wow_select($array, $name, $selected, $default) {
	$service_select = "<select name=\"$name\">";

	if (!is_array($array)) $array = array();

	if (!array_key_exists($selected, $array)) {
		$selected = $default;
		$isSelected = " selected=\"selected\"";
	} else {
		$isSelected = "";
	}

	if (!array_key_exists($default, $array)) {
		$service_select .= "<option value=\"$default\"$isSelected></option>";
	}

	foreach ($array as $k => $v) {
		$isSelected = ($selected == $k ? " selected=\"selected\"" : "");
		$service_select .= "<option value=\"$k\"$isSelected>$v</option>";
	}

	return $service_select . "</select>";
}

// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ OPEN ]-------------------------------------
#

viewtopic.php

#
#-----[ FIND ]-------------------------------------
#

$sql = "SELECT u.username, u.user_id,

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

u.user_email

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, u.user_wow_race, u.user_wow_gender, u.user_wow_class, u.user_wow_pvp_rank, u.user_wow_profile_service, u.user_wow_profile_name, u.user_wow_talents, u.user_wow_talents_title

#
#-----[ FIND ]-------------------------------------
#

	$temp_url = '';

	if ( $poster_id != ANONYMOUS )
	{

#
#-----[ AFTER, ADD ]------------------------------------------
#

		// BEGIN -- Grim Times: WoW Profiles for phpBB

		if ($postrow[$i]['user_wow_race'] && $postrow[$i]['user_wow_gender']) {
			$wow_race_img = wow_image_race($postrow[$i]['user_wow_race'], $postrow[$i]['user_wow_gender'], $postrow[$i]['user_wow_profile_service'], $postrow[$i]['user_wow_profile_name']);
		} else {
			$wow_race_img = '';
		}

		if ($postrow[$i]['user_wow_gender']) {
			$wow_gender_race_class = $lang['wow_genders'][$postrow[$i]['user_wow_gender']];
		} else {
			$wow_gender_race_class = "";
		}

		if ($postrow[$i]['user_wow_race']) {
			$wow_gender_race_class .= ($wow_gender_race_class ? " " : "") . $lang['wow_races'][$postrow[$i]['user_wow_race']];
		}

		if ($postrow[$i]['user_wow_class']) {
			$wow_class_img = wow_image_class($postrow[$i]['user_wow_class'], $postrow[$i]['user_wow_talents'], $postrow[$i]['user_wow_talents_title']);
			$wow_gender_race_class .= ($wow_gender_race_class ? " " : "") . $lang['wow_classes'][$postrow[$i]['user_wow_class']];
		} else {
			$wow_class_img = '';
		}

		if ($postrow[$i]['user_wow_pvp_rank']) {
			$wow_pvp_rank_img = wow_image_pvp_rank($postrow[$i]['user_wow_pvp_rank'], $postrow[$i]['user_wow_race']);
			$wow_pvp_rank = $lang['wow_pvp_ranks'][$lang['wow_race_factions'][$postrow[$i]['user_wow_race']]][$postrow[$i]['user_wow_pvp_rank']] . " ";
		} else {
			$wow_pvp_rank_img = '';
			$wow_pvp_rank = '';
		}

		if ($postrow[$i]['user_wow_profile_service'] && $postrow[$i]['user_wow_profile_name']) {
			$wow_profile = wow_link_service($postrow[$i]['user_wow_profile_service'], $postrow[$i]['user_wow_profile_name'], $lang['wow_profile_services'][$postrow[$i]['user_wow_profile_service']]);
			if ($wow_profile) $wow_profile = $lang['wow_profile'] . ": $wow_profile";
		} else {
			$wow_profile = '';
		}

		if ($postrow[$i]['user_wow_class'] && $postrow[$i]['user_wow_talents'] && $postrow[$i]['user_wow_talents_title']) {
			$wow_talents = $lang['wow_talents'] . ": " . wow_link_talents($postrow[$i]['user_wow_class'], $postrow[$i]['user_wow_talents'], $postrow[$i]['user_wow_talents_title']);
		} else {
			$wow_talents = '';
		}

		// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ FIND ]-------------------------------------
#

		$profile_img = '';
		$profile = '';

#
#-----[ BEFORE, ADD ]------------------------------------------
#

		// BEGIN -- Grim Times: WoW Profiles for phpBB
		$wow_race_img = '';
		$wow_class_img = '';
		$wow_pvp_rank_img = '';
		$wow_pvp_rank = '';
		$wow_gender_race_class = '';
		$wow_profile = '';
		$wow_talents = '';
		// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ FIND ]-------------------------------------
#

		'RANK_IMAGE' => $rank_image,

#
#-----[ AFTER, ADD ]------------------------------------------
#

		// BEGIN -- Grim Times: WoW Profiles for phpBB
		'WOW_RACE_IMG' => $wow_race_img,
		'WOW_CLASS_IMG' => $wow_class_img,
		'WOW_PVP_RANK_IMG' => $wow_pvp_rank_img,
		'WOW_PVP_RANK' => $wow_pvp_rank,
		'WOW_GENDER_RACE_CLASS' => $wow_gender_race_class,
		'WOW_PROFILE' => $wow_profile,
		'WOW_TALENTS' => $wow_talents,
		// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ OPEN ]-------------------------------------
#

templates/subSilver/viewtopic_body.tpl

#
#-----[ FIND ]-------------------------------------
#

<span class="name"><a name="{postrow.U_POST_ID}"></a><b>{postrow.POSTER_NAME}</b></span>

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

{postrow.POSTER_NAME}</b>

#
#-----[ IN-LINE BEFORE, ADD ]---------------------------------------------------
#

{postrow.WOW_PVP_RANK}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

<br />{postrow.POSTER_JOINED}

#
#-----[ IN-LINE BEFORE, ADD ]---------------------------------------------------
#

<br />{postrow.WOW_GENDER_RACE_CLASS}<br />{postrow.WOW_PROFILE}<br />{postrow.WOW_TALENTS}

#
#-----[ FIND ]-------------------------------------
#

{postrow.PROFILE_IMG}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

postrow.PROFILE_IMG}

#
#-----[ IN-LINE BEFORE, ADD ]---------------------------------------------------
#

postrow.WOW_RACE_IMG} {postrow.WOW_CLASS_IMG} {postrow.WOW_PVP_RANK_IMG} {

#
#-----[ OPEN ]------------------------------------------
#

includes/usercp_viewprofile.php

#
#-----[ FIND ]---------------------------------------------------
#

make_jumpbox('viewforum.'.$phpEx);

#
#-----[ AFTER, ADD ]------------------------------------------
#

// BEGIN -- Grim Times: WoW Profiles for phpBB

if ($profiledata['user_wow_gender']) {
	$wow_gender = $lang['wow_genders'][$profiledata['user_wow_gender']];
} else {
	$wow_gender = "&nbsp;";
}

if ($profiledata['user_wow_race']) {
	$wow_race = $lang['wow_races'][$profiledata['user_wow_race']];
} else {
	$wow_race = "&nbsp;";
}

if ($profiledata['user_wow_class']) {
	$wow_class = $lang['wow_classes'][$profiledata['user_wow_class']];
} else {
	$wow_class = "&nbsp;";
}

if ($profiledata['user_wow_pvp_rank']) {
	$wow_pvp_rank = $lang['wow_pvp_ranks'][$lang['wow_race_factions'][$profiledata['user_wow_race']]][$profiledata['user_wow_pvp_rank']];
} else {
	$wow_pvp_rank = "&nbsp;";
}

if ($profiledata['user_wow_profile_service'] && $profiledata['user_wow_profile_name']) {
	$wow_profile = wow_link_service($profiledata['user_wow_profile_service'], $profiledata['user_wow_profile_name'], $lang['wow_profile_services'][$profiledata['user_wow_profile_service']]);
}

if (!$wow_profile) {
	$wow_profile = "&nbsp;";
}

if ($profiledata['user_wow_class'] && $profiledata['user_wow_talents'] && $profiledata['user_wow_talents_title']) {
	$wow_talents = wow_link_talents($profiledata['user_wow_class'], $profiledata['user_wow_talents'], $profiledata['user_wow_talents_title']);
} else {
	$wow_talents = "&nbsp;";
}

// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ FIND ]---------------------------------------------------
#

	'USERNAME' => $profiledata['username'],

#
#-----[ AFTER, ADD ]------------------------------------------
#

	// BEGIN -- Grim Times: WoW Profiles for phpBB
	'WOW_GENDER' => $wow_gender,
	'WOW_RACE' => $wow_race,
	'WOW_CLASS' => $wow_class,
	'WOW_PVP_RANK' => $wow_pvp_rank,
	'WOW_PROFILE' => $wow_profile,
	'WOW_TALENTS' => $wow_talents,
	// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ FIND ]---------------------------------------------------
#

	'L_JOINED' => $lang['Joined'],

#
#-----[ BEFORE, ADD ]------------------------------------------
#

	// BEGIN -- Grim Times: WoW Profiles for phpBB
	'L_WOW_GENDER' => $lang['wow_gender'],
	'L_WOW_RACE' => $lang['wow_race'],
	'L_WOW_CLASS' => $lang['wow_class'],
	'L_WOW_PVP_RANK' => $lang['wow_pvp_rank'],
	'L_WOW_PROFILE' => $lang['wow_profile'],
	'L_WOW_TALENTS' => $lang['wow_talents'],
	// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ OPEN ]------------------------------------------
#

templates/subSilver/profile_view_body.tpl

#
#-----[ FIND ]---------------------------------------------------
#

		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_JOINED}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{JOINED}</span></b></td>
		</tr>

#
#-----[ BEFORE, ADD ]------------------------------------------
#

		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_WOW_GENDER}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{WOW_GENDER}</span></b></td>
		</tr>
		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_WOW_RACE}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{WOW_RACE}</span></b></td>
		</tr>
		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_WOW_CLASS}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{WOW_CLASS}</span></b></td>
		</tr>
		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_WOW_PVP_RANK}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{WOW_PVP_RANK}</span></b></td>
		</tr>
		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_WOW_PROFILE}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{WOW_PROFILE}</span></b></td>
		</tr>
		<tr>
		  <td valign="middle" align="right" nowrap="nowrap"><span class="gen">{L_WOW_TALENTS}:&nbsp;</span></td>
		  <td width="100%"><b><span class="gen">{WOW_TALENTS}</span></b></td>
		</tr>

#
#-----[ OPEN ]------------------------------------------
#

includes/usercp_register.php

#
#-----[ FIND ]---------------------------------------------------
#

	$strip_var_list = array(

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

'email' => 'email'

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, 'wow_race' => 'wow_race', 'wow_gender' => 'wow_gender', 'wow_class' => 'wow_class', 'wow_profile_service' => 'wow_profile_service', 'wow_profile_name' => 'wow_profile_name', 'wow_talents' => 'wow_talents', 'wow_talents_title' => 'wow_talents_title'

#
#-----[ FIND ]---------------------------------------------------
#

	$user_timezone =

#
#-----[ BEFORE, ADD ]----------------------------------------------
#

	$wow_pvp_rank = isset($HTTP_POST_VARS['wow_pvp_rank']) ? intval($HTTP_POST_VARS['wow_pvp_rank']) : 0;

#
#-----[ FIND ]---------------------------------------------------
#

		$email = stripslashes($email);

#
#-----[ AFTER, ADD ]----------------------------------------------
#

		$wow_race = stripslashes($wow_race);
		$wow_gender = stripslashes($wow_gender);
		$wow_class = stripslashes($wow_class);
		$wow_pvp_rank = stripslashes($wow_pvp_rank);
		$wow_profile_service = stripslashes($wow_profile_service);
		$wow_profile_name = stripslashes($wow_profile_name);
		$wow_talents = stripslashes($wow_talents);
		$wow_talents_title = stripslashes($wow_talents_title);

#
#-----[ FIND ]---------------------------------------------------
#

SET " . $username_sql . $passwd_sql .

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

"user_email = '" . str_replace("\'", "''", $email) ."'

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, user_wow_race = '" . str_replace("\'", "''", $wow_race) . "', user_wow_gender = '" . str_replace("\'", "''", $wow_gender) . "', user_wow_class = '" . str_replace("\'", "''", $wow_class) . "', user_wow_pvp_rank = '" . str_replace("\'", "''", $wow_pvp_rank) . "', user_wow_profile_service = '" . str_replace("\'", "''", $wow_profile_service) . "', user_wow_profile_name = '" . str_replace("\'", "''", $wow_profile_name) . "', user_wow_talents = '" . str_replace("\'", "''", $wow_talents) . "', user_wow_talents_title = '" . str_replace("\'", "''", $wow_talents_title) . "'

#
#-----[ FIND ]---------------------------------------------------
#

$sql = "INSERT INTO " . USERS_TABLE . "	(

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

user_email

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, user_wow_race, user_wow_gender, user_wow_class, user_wow_pvp_rank, user_wow_profile_service, user_wow_profile_name, user_wow_talents, user_wow_talents_title

#
#-----[ FIND ]---------------------------------------------------
#

VALUES ($user_id, '" . str_replace(

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

'" . str_replace("\'", "''", $email) . "'

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, '" . str_replace("\'", "''", $wow_race) . "', '" . str_replace("\'", "''", $wow_gender) . "', '" . str_replace("\'", "''", $wow_class) . "', '" . str_replace("\'", "''", $wow_pvp_rank) . "', '" . str_replace("\'", "''", $wow_profile_service) . "', '" . str_replace("\'", "''", $wow_profile_name) . "', '" . str_replace("\'", "''", $wow_talents) . "', '" . str_replace("\'", "''", $wow_talents_title) . "'

#
#-----[ FIND ]---------------------------------------------------
#

	$email = stripslashes($email);

#
#-----[ AFTER, ADD ]----------------------------------------------
#

	$wow_race = stripslashes($wow_race);
	$wow_talents = stripslashes($wow_gender);
	$wow_class = stripslashes($wow_class);
	$wow_pvp_rank = stripslashes($wow_pvp_rank);
	$wow_profile_service = stripslashes($wow_profile_service);
	$wow_profile_name = stripslashes($wow_profile_name);
	$wow_talents = stripslashes($wow_talents);
	$wow_talents_title = stripslashes($wow_talents_title);

#
#-----[ FIND ]---------------------------------------------------
#

	$email = $userdata['user_email'];

#
#-----[ AFTER, ADD ]----------------------------------------------
#

	$wow_race = $userdata['user_wow_race'];
	$wow_gender = $userdata['user_wow_gender'];
	$wow_class = $userdata['user_wow_class'];
	$wow_pvp_rank = $userdata['user_wow_pvp_rank'];
	$wow_profile_service = $userdata['user_wow_profile_service'];
	$wow_profile_name = $userdata['user_wow_profile_name'];
	$wow_talents = $userdata['user_wow_talents'];
	$wow_talents_title = $userdata['user_wow_talents_title'];

#
#-----[ FIND ]---------------------------------------------------
#

display_avatar_gallery(

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

$email

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, $wow_race, $wow_gender, $wow_class, $wow_pvp_rank, $wow_profile_service, $wow_profile_name, $wow_talents, $wow_talents_title

#
#-----[ FIND ]---------------------------------------------------
#

		'EMAIL' => isset($email) ? $email : '',

#
#-----[ AFTER, ADD ]----------------------------------------------
#

		'WOW_RACE' => wow_select($lang['wow_races'], 'wow_race', $wow_race, ""),
		'WOW_GENDER' => wow_select($lang['wow_genders'], 'wow_gender', $wow_gender, ""),
		'WOW_CLASS' => wow_select($lang['wow_classes'], 'wow_class', $wow_class, ""),
		'WOW_PVP_RANK' => wow_select($lang['wow_pvp_ranks'][$lang['wow_race_factions'][$wow_race]], 'wow_pvp_rank', $wow_pvp_rank, 0),
		'WOW_PROFILE_SERVICE' => wow_select($lang['wow_profile_services'], 'wow_profile_service', $wow_profile_service, ""),
		'WOW_PROFILE_NAME' => isset($wow_profile_name) ? $wow_profile_name : '',
		'WOW_TALENTS' => isset($wow_talents) ? $wow_talents : '',
		'WOW_TALENTS_TITLE' => isset($wow_talents_title) ? $wow_talents_title : '',

#
#-----[ FIND ]---------------------------------------------------
#

		'L_EMAIL_ADDRESS' => $lang['Email_address'],

#
#-----[ AFTER, ADD ]----------------------------------------------
#

		'L_WOW_RACE' => $lang['wow_race'],
		'L_WOW_GENDER' => $lang['wow_gender'],
		'L_WOW_HELP_GENDER' => $lang['wow_help_gender'],
		'L_WOW_CLASS' => $lang['wow_class'],
		'L_WOW_PVP_RANK' => $lang['wow_pvp_rank'],
		'L_WOW_PROFILE_SERVICE' => $lang['wow_profile_service'],
		'L_WOW_PROFILE_NAME' => $lang['wow_profile_name'],
		'L_WOW_HELP_PROFILE' => $lang['wow_help_profile'],
		'L_WOW_TALENTS' => $lang['wow_talents'],
		'L_WOW_TALENTS_TITLE' => $lang['wow_talents_title'],
		'L_WOW_HELP_TALENTS' => $lang['wow_help_talents'],

#
#-----[ OPEN ]------------------------------------------
#

templates/subSilver/profile_add_body.tpl

#
#-----[ FIND ]---------------------------------------------------
#

	<tr>
	  <td class="row2" colspan="2"><span class="gensmall">{L_PROFILE_INFO_NOTICE}</span></td>
	</tr>

#
#-----[ AFTER, ADD ]----------------------------------------------
#

	<tr>
	  <td class="row1"><span class="gen">{L_WOW_GENDER}:</span><br /><span class="gensmall">{L_WOW_HELP_GENDER}</span></td>
	  <td class="row2"><span class="gensmall">{WOW_GENDER}</span></td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_RACE}:</span></td>
	  <td class="row2"><span class="gensmall">{WOW_RACE}</span></td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_CLASS}:</span></td>
	  <td class="row2"><span class="gensmall">{WOW_CLASS}</span></td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_PVP_RANK}:</span></td>
	  <td class="row2"><span class="gensmall">{WOW_PVP_RANK}</span></td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_PROFILE_SERVICE}:</span><br /><span class="gensmall">{L_WOW_HELP_PROFILE}</span></td>
	  <td class="row2"><span class="gensmall">{WOW_PROFILE_SERVICE}</span></td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_PROFILE_NAME}:</span></td>
	  <td class="row2">
		<input type="text" class="post" style="width: 150px"  name="wow_profile_name" size="20" maxlength="255" value="{WOW_PROFILE_NAME}" />
	  </td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_TALENTS}:</span><br /><span class="gensmall">{L_WOW_HELP_TALENTS}</span></td>
	  <td class="row2">
		<input type="text" class="post" style="width: 300px"  name="wow_talents" size="40" maxlength="255" value="{WOW_TALENTS}" />
	  </td>
	</tr>
	<tr>
	  <td class="row1"><span class="gen">{L_WOW_TALENTS_TITLE}:</span></td>
	  <td class="row2">
		<input type="text" class="post" style="width: 150px"  name="wow_talents_title" size="20" maxlength="255" value="{WOW_TALENTS_TITLE}" />
	  </td>
	</tr>

#
#-----[ OPEN ]------------------------------------------
#

includes/usercp_avatar.php

#
#-----[ FIND ]---------------------------------------------------
#

function display_avatar_gallery($mode, &$category

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

&$email

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, &$wow_race, &$wow_gender, &$wow_class, &$wow_pvp_rank, &$wow_profile_service, &$wow_profile_name, &$wow_talents, &$wow_talents_title

#
#-----[ FIND ]---------------------------------------------------
#

$params = array('coppa',

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

'email'

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, 'wow_race', 'wow_gender', 'wow_class', 'wow_pvp_rank', 'wow_profile_service', 'wow_profile_name', 'wow_talents', 'wow_talents_title'

#
#-----[ OPEN ]------------------------------------------
#

language/lang_english/lang_main.php

#
#-----[ FIND ]---------------------------------------------------
#

//
// That's all, Folks!
// -------------------------------------------------

#
#-----[ BEFORE, ADD ]----------------------------------------------
#

// BEGIN -- Grim Times: WoW Profiles for phpBB

$lang['wow_race'] = "WoW Race";
$lang['wow_gender'] = "WoW Gender";
$lang['wow_class'] = "WoW Class";
$lang['wow_pvp_rank'] = "WoW PvP Rank";
$lang['wow_profile'] = "WoW Profile";
$lang['wow_profile_service'] = "WoW Profile Service";
$lang['wow_profile_name'] = "WoW Profile Name/Number";
$lang['wow_talents'] = "WoW Talents";
$lang['wow_talents_title'] = "WoW Talent Build Name";

$lang['wow_help_gender'] = "You must specify a Gender in order for your Race icon to appear (they are race/gender specific).";
$lang['wow_help_profile'] = "You must specify both a Service and a Name/Number for a profile link to appear on your posts.";
$lang['wow_help_talents'] = "You must specify a Class, your Talents and a Build Name for a talents link to appear on your posts.  To specify Talents, use the talent calulators on the official WoW web site, then copy the string of numbers at the end of the link provided.";

$lang['wow_races']['be'] = "Blood Elf";
$lang['wow_races']['dr'] = "Dranei";
$lang['wow_races']['dw'] = "Dwarf";
$lang['wow_races']['gn'] = "Gnome";
$lang['wow_races']['hu'] = "Human";
$lang['wow_races']['ne'] = "Night Elf";
$lang['wow_races']['or'] = "Orc";
$lang['wow_races']['ta'] = "Tauren";
$lang['wow_races']['tr'] = "Troll";
$lang['wow_races']['un'] = "Undead";

$lang['wow_race_factions'][''] = "";
$lang['wow_race_factions']['be'] = "h";
$lang['wow_race_factions']['dr'] = "a";
$lang['wow_race_factions']['dw'] = "a";
$lang['wow_race_factions']['gn'] = "a";
$lang['wow_race_factions']['hu'] = "a";
$lang['wow_race_factions']['ne'] = "a";
$lang['wow_race_factions']['or'] = "h";
$lang['wow_race_factions']['ta'] = "h";
$lang['wow_race_factions']['tr'] = "h";
$lang['wow_race_factions']['un'] = "h";

$lang['wow_genders']['f'] = "Female";
$lang['wow_genders']['m'] = "Male";

$lang['wow_classes']['dr'] = "Druid";
$lang['wow_classes']['hu'] = "Hunter";
$lang['wow_classes']['ma'] = "Mage";
$lang['wow_classes']['pa'] = "Paladin";
$lang['wow_classes']['pr'] = "Priest";
$lang['wow_classes']['ro'] = "Rogue";
$lang['wow_classes']['sh'] = "Shaman";
$lang['wow_classes']['wl'] = "Warlock";
$lang['wow_classes']['wr'] = "Warrior";

$lang['wow_pvp_ranks'][''][0] = "None";
$lang['wow_pvp_ranks'][''][1] = "Rank 1";
$lang['wow_pvp_ranks'][''][2] = "Rank 2";
$lang['wow_pvp_ranks'][''][3] = "Rank 3";
$lang['wow_pvp_ranks'][''][4] = "Rank 4";
$lang['wow_pvp_ranks'][''][5] = "Rank 5";
$lang['wow_pvp_ranks'][''][6] = "Rank 6";
$lang['wow_pvp_ranks'][''][7] = "Rank 7";
$lang['wow_pvp_ranks'][''][8] = "Rank 8";
$lang['wow_pvp_ranks'][''][9] = "Rank 9";
$lang['wow_pvp_ranks'][''][10] = "Rank 10";
$lang['wow_pvp_ranks'][''][11] = "Rank 11";
$lang['wow_pvp_ranks'][''][12] = "Rank 12";
$lang['wow_pvp_ranks'][''][13] = "Rank 13";
$lang['wow_pvp_ranks'][''][14] = "Rank 14";

$lang['wow_pvp_ranks']['a'][0] = "None";
$lang['wow_pvp_ranks']['a'][1] = "Private";
$lang['wow_pvp_ranks']['a'][2] = "Corporal";
$lang['wow_pvp_ranks']['a'][3] = "Sergeant";
$lang['wow_pvp_ranks']['a'][4] = "Master Sergeant";
$lang['wow_pvp_ranks']['a'][5] = "Sergeant Major";
$lang['wow_pvp_ranks']['a'][6] = "Knight";
$lang['wow_pvp_ranks']['a'][7] = "Knight-Lieutenant";
$lang['wow_pvp_ranks']['a'][8] = "Knight-Captain";
$lang['wow_pvp_ranks']['a'][9] = "Knight-Champion";
$lang['wow_pvp_ranks']['a'][10] = "Lieutenant Commander";
$lang['wow_pvp_ranks']['a'][11] = "Commander";
$lang['wow_pvp_ranks']['a'][12] = "Marshal";
$lang['wow_pvp_ranks']['a'][13] = "Field Marshal";
$lang['wow_pvp_ranks']['a'][14] = "Grand Marshal";

$lang['wow_pvp_ranks']['h'][0] = "None";
$lang['wow_pvp_ranks']['h'][1] = "Scout";
$lang['wow_pvp_ranks']['h'][2] = "Grunt";
$lang['wow_pvp_ranks']['h'][3] = "Sergeant";
$lang['wow_pvp_ranks']['h'][4] = "Senior Sergeant";
$lang['wow_pvp_ranks']['h'][5] = "First Sergeant";
$lang['wow_pvp_ranks']['h'][6] = "Stone Guard";
$lang['wow_pvp_ranks']['h'][7] = "Blood Guard";
$lang['wow_pvp_ranks']['h'][8] = "Legionnare";
$lang['wow_pvp_ranks']['h'][9] = "Centurion";
$lang['wow_pvp_ranks']['h'][10] = "Champion";
$lang['wow_pvp_ranks']['h'][11] = "Lieutenant General";
$lang['wow_pvp_ranks']['h'][12] = "General";
$lang['wow_pvp_ranks']['h'][13] = "Warlord";
$lang['wow_pvp_ranks']['h'][14] = "High Warlord";

$lang['wow_profile_services']['ak'] = "Allakhazam";
$lang['wow_profile_services']['ct'] = "CTProfiles";
$lang['wow_profile_services']['tb'] = "ThottBot";

// END -- Grim Times: WoW Profiles for phpBB

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------
#
# EoM
