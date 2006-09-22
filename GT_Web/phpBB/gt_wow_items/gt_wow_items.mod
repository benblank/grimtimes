## EasyMod Compliant
##############################################################
##
## $Id$
##
## MOD Title: Grim Times: WoW Items for phpBB
## MOD Author: DrDark < N/A > (N/A) http://code.google.com/p/grimtimes/
## MOD Description: Adds a new BBcode for producing styled links
## to WoW item data, with mouseover tooltips.
## MOD Version: 0.9
##
## Installation Level: Easy
## Installation Time: 5 Minutes
## Files To Edit: 5
##     includes/bbcode.php
##     language/lang_english/lang_main.php
##     templates/subSilver/bbcode.tpl
##     templates/subSilver/overall_header.tpl
##     templates/subSilver/posting_body.tpl
##
## Included Files: 6
##     admin_wow_items.php
##     admin_wow_items.tpl
##     functions_wow_items.php
##     wow_items.css
##     wow_items.js
##     wow_items_cache.php
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
## IMPORTANT: you MUST first have already installed the Multi BBCode
## MOD available at http://www.phpbb.com/mods/
##
##############################################################
##
## IMPORTANT: you MUST also install the "Better BBcode UID Remover"
## included with this mod!
##
##############################################################
##
## Author Notes:
##
## All item data courtesy of Allakhazam.  Caches both item data
## (refreshed every 21 days) and the ID<->Name map (refreshed
## daily).  A button on the ACP expires the entire cache to allow
## a global data refresh (say, after a WoW content patch).
##
## Usage:
##
## [item]<name or partial name>[/item]
## [item]<itemnum>[/item]
## [item=<itemnum>]<link text>[/item]
##
## [itemdesc]<name or partial name>[/itemdesc]
## [itemdesc]<itemnum>[/itemdesc]
## [itemdesc=<itemnum>]<ignored>[/itemdesc]
##
##############################################################
##
## Before Adding This MOD To Your Forum, You Should Back Up All Files Related To This MOD
##
##############################################################

#
#-----[ SQL ]-------------------------------------------
#

CREATE TABLE phpbb_wow_items (
  item_id MEDIUMINT UNSIGNED NOT NULL,
  item_name TINYTEXT NOT NULL,
  item_quality TINYINT UNSIGNED NULL,
  item_icon TINYTEXT NULL,
  item_desc TEXT NULL,
  PRIMARY KEY (item_id)
);

#
#-----[ COPY ]------------------------------------------
#

Copy admin_wow_items.php to admin/admin_wow_items.php
Copy admin_wow_items.tpl to templates/subSilver/admin/wow_items.tpl
Copy functions_wow_items.php to includes/functions_wow_items.php
Copy wow_items.css to templates/subSilver/wow_items.css
Copy wow_items.js to templates/subSilver/wow_items.js
Copy wow_items_cache.php to wow_items_cache.php

#
#-----[ OPEN ]------------------------------------------
#

includes/bbcode.php

#
#-----[ FIND ]------------------------------------------
#

define("BBCODE_UID_LEN", 10);

#
#-----[ AFTER, ADD ]------------------------------------------
#

include($phpbb_root_path . 'includes/functions_wow_items.'.$phpEx);

#
#-----[ FIND ]------------------------------------------
#

	$EMBB_widths = array(''
	$EMBB_values = array(''

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

$EMBB_widths = array(''

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, '39', '48', '66'

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

$EMBB_values = array(''

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, 'item', 'item=', 'itemdesc'

#
#-----[ FIND ]------------------------------------------
#

	$text = bbencode_second_pass_code($text, $uid, $bbcode_tpl);

#
#-----[ AFTER, ADD ]------------------------------------------
#

	$text = wow_item_bbcode_second_pass($text);

#
#-----[ FIND ]------------------------------------------
#

	$text = bbencode_first_pass_pda($text, $uid, '[code]', '[/code]', '', true, '');

#
#-----[ AFTER, ADD ]------------------------------------------
#

	// Our first pass doesn't actually change the text.
	wow_item_bbcode_first_pass($text);

#
#-----[ OPEN ]---------------------------------
#

language/lang_english/lang_main.php

#
#-----[ FIND ]---------------------------------
#

$lang['bbcode_help']['value'] = 'BBCode Name: Info (Alt+%s)';

#
#-----[ AFTER, ADD ]------------------------------------------
#

$lang['bbcode_help']['item'] = "Item link (by name search or item ref)";
$lang['bbcode_help']['item='] = "Item link (by item ref, with link text)";
$lang['bbcode_help']['itemdesc'] = "Item (in-line)";

#
#-----[ FIND ]---------------------------------
#

//
// That's all, Folks!
// -------------------------------------------------

#
#-----[ BEFORE, ADD ]------------------------------------------
#

// WoW Items admin page
$lang['wow_items_admin'] = 'WoW Items';
$lang['wow_items_admin_text'] = 'From this page you can perform various options on the WoW item database used for this forum.  The most important is the Update option, which updates the cached list of <a href="http://wow.allakhazam.com/">Allakhazam\'s</a> items and ensures the cached items are up to date.  You may want to do this every few days when a patch has just been released, but probably no more than once a week otherwise.  You can also choose to pre-load commonly used items to ensure they are available when your users need them.  (Non-precached items are loaded on an as-needed basis.)';
$lang['wow_items_admin_title'] = 'WoW Item Database Management';
$lang['wow_items_cache_available'] = 'items available in <a href="http://wow.allakhazam.com/">Allakhazam\'s</a> database';
$lang['wow_items_cache_current'] = 'items currently in the local cache';
$lang['wow_items_cache_stats'] = 'WoW Item Database Stats';
$lang['wow_items_cache_update'] = 'Update Cache';
$lang['wow_items_cache_updating'] = "&lt;updating&gt;";
$lang['wow_items_precache_count'] = 'Items in Set';
$lang['wow_items_precache_partial'] = "Partial";
$lang['wow_items_precache_set'] = 'Set Name';
$lang['wow_items_precache_status'] = 'Cached?';
$lang['wow_items_precache_submit'] = 'Cache Selected Sets';

$lang['wow_items_status_precache'] = 'Item set "{SET}" has been cached.';
$lang['wow_items_status_update'] = 'Cache update requested.  This operation can take several minutes to complete, depending on how many items you currently have cached.  Until the update completes, item tooltips will display "uncached or invalid".';

$lang['wow_items_set']['pvp_a_ab'] = 'Alliance PvP: League of Arathor faction rewards (AB)';
$lang['wow_items_set']['pvp_a_av'] = 'Alliance PvP: Stormpike faction rewards (AV)';
$lang['wow_items_set']['pvp_a_honor'] = 'Alliance PvP: Honor rank rewards';
$lang['wow_items_set']['pvp_a_wsg'] = 'Alliance PvP: Silverwing faction rewards (WSG)';
$lang['wow_items_set']['pvp_h_ab'] = 'Horde PvP: Defilers faction rewards (AB)';
$lang['wow_items_set']['pvp_h_av'] = 'Horde PvP: Frostwolf faction rewards (AV)';
$lang['wow_items_set']['pvp_h_honor'] = 'Horde PvP: Honor rank rewards';
$lang['wow_items_set']['pvp_h_wsg'] = 'Horde PvP: Warsong faction rewards (WSG)';
$lang['wow_items_set']['tier0'] = 'Tier 0 (a.k.a. Dungeon Set 1)';
$lang['wow_items_set']['tier0_5'] = 'Tier 0.5 (a.k.a. Dungeon Set 2)';
$lang['wow_items_set']['tier1'] = 'Tier 1';
$lang['wow_items_set']['tier2'] = 'Tier 2';
$lang['wow_items_set']['tier3'] = 'Tier 3';
$lang['wow_items_set']['zg_loot'] = 'Zul\'Gurub loot';
$lang['wow_items_set']['zg_quest'] = 'Zul\'Gurub quest rewards';

// WoW Items display
$lang['wow_items_badid'] = 'There does not appear to be an item with ID {ID}.';
$lang['wow_items_multi'] = 'The search "{SEARCH}" matched {COUNT} items:';
$lang['wow_items_none'] = 'The search "{SEARCH}" did not match any items.';
$lang['wow_items_pending'] = 'This item has not yet been cached.  It is possible that Allakhazam is down or that the item ID is invalid.  Please try again later.';

#
#-----[ OPEN ]------------------------------------------
#

templates/subSilver/bbcode.tpl

#
#-----[ FIND ]------------------------------------------
#

<!-- END email -->

#
#-----[ AFTER, ADD ]------------------------------------------
#

<!-- BEGIN item -->{ITEMDIV}<a class="quality{QUALITY}" onmouseover="wow_item_hover(event,'{ID}')" onmouseout="wow_item_unhover()" target="_blank" href="{URL}">[{TEXT}]</a><!-- END item -->

<!-- BEGIN itemdiv --><div{IDATTR} style="display:none">{ITEMDESC}</div><!-- END itemdiv -->

<!-- BEGIN itemdesc --></span>
<div{IDATTR}>{ITEMDESC}</div>
<span class="postbody"><!-- END itemdesc -->

#
#-----[ OPEN ]---------------------------------
#

templates/subSilver/posting_body.tpl

#
#-----[ FIND ]------------------------------------------
#

bbtags = new Array(

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

'[/url]'

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, '[item]', '[/item]', '[item=####]', '[/item]', '[itemdesc]', '[/itemdesc]'

#
#-----[ OPEN ]------------------------------------------
#

templates/subSilver/overall_header.tpl

#
#-----[ FIND ]------------------------------------------
#

link rel="stylesheet" href="templates/subSilver/{T_HEAD_STYLESHEET}" type="text/css"

#
#-----[ AFTER, ADD ]------------------------------------------
#

<link rel="stylesheet" href="templates/subSilver/wow_items.css" type="text/css" />
<script src="templates/subSilver/wow_items.js" type="text/javascript"></script>

#
#-----[ DIY INSTRUCTIONS ]------------------------------------------
#

Before item links can be used, you must:
Open the new "WoW Items" ACP
Click the "Update Cache" button
Wait for the cache to be filled (usually takes about 10 seconds, but you won't be told when it's done)
If you like, select item sets to preload (loading too many makes recaching take longer, so don't go nuts)

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------
#
# EoM
