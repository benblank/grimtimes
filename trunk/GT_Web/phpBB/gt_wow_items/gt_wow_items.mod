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
##     templates/subSilver/posting_body.tpl
##     templates/subSilver/simple_header.tpl
##
## Included Files: 3
##     functions_wow_items.php
##     wow_items.css
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

Copy functions_wow_items.php to includes/functions_wow_items.php
Copy wow_items.css to templates/subSilver/wow_items.css
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
# Rule of thumb seems to be 25 + 5/char?
#

, '45', '50', '65'

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

	$text = wow_item_bbcode_second_pass($text, $bbcode_tpl);

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

<!-- BEGIN item --><div id="item{ID}" style="display:none">{ITEMDIV}</div><a class="quality{QUALITY}" onmouseover="wow_item_hover('{ID}')" onmouseover="wow_item_unhover()" target="_blank" href="{URL}">{TEXT}</a><!-- END item -->

<!-- BEGIN itemdesc --></span>
<div id="{ID}">{ITEMDIV}</div>
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

templates/subSilver/simple_header.tpl

#
#-----[ FIND ]------------------------------------------
#

link rel="stylesheet" href="templates/subSilver/{T_HEAD_STYLESHEET}" type="text/css"

#
#-----[ AFTER, ADD ]------------------------------------------
#

<link rel="stylesheet" href="templates/subSilver/wow_items.css" type="text/css" />

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------
#
# EoM
