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
## Files To Edit: ?
##     file!
##
## Included Files: ?
##     file!
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
  item_quality TINYINT UNSIGNED DEFAULT NULL,
  item_icon TINYTEXT DEFAULT NULL,
  item_stamp INT DEFAULT NULL,
  item_html TEXT DEFAULT NULL,
  PRIMARY KEY (item_id)
);

#
#-----[ COPY ]------------------------------------------
#

#
#-----[ OPEN ]------------------------------------------
#

includes/constants.php

#
#-----[ FIND ]------------------------------------------
#

?>

#
#-----[ BEFORE, ADD ]------------------------------------------
#

// BEGIN -- Grim Times: WoW Items for phpBB
define('WOW_ITEMS_TABLE', $table_prefix.'wow_items');
// END -- Grim Times: WoW Items for phpBB

#
#-----[ OPEN ]------------------------------------------
#

includes/bbcode.php

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

, '45', '65'

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

$EMBB_values = array(''

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------------------------
#

, 'item', 'itemdesc'

#
#-----[ FIND ]------------------------------------------
#

	$replacements[] = $bbcode_tpl['email'];

#
#-----[ AFTER, ADD ]------------------------------------------
#

	// BEGIN -- Grim Times: WoW Items for phpBB

	// [item]<non-unique search or name>[/item]
	$patterns[] = "#\[item:(\d)\]([^\[]+)\[/item\]#is";
	$replacements[] = $bbcode_tpl['wow_item1'];

	// [item]<unique search or name>[/item] and [item=<itemnum>]<link text>[/item]
	$patterns[] = "#\[item[=:](\d+):(\d)\]([^\[]+)\[/item\]#is";
	$replacements[] = $bbcode_tpl['wow_item2'];

	// [itemdesc]<non-unique search or name>[/itemdesc]
	$patterns[] = "#\[itemdesc:(\d)\]([^\[]+)\[/itemdesc\]#is";
	$replacements[] = $bbcode_tpl['wow_itemdesc1'];

	// [itemdesc]<unique search or name>[/itemdesc] and [itemdesc=<itemnum>]<ignored>[/itemdesc]
	$patterns[] = "#\[itemdesc[=:](\d+):(\d)\][^\[]*\[/item\]#is";
	$replacements[] = $bbcode_tpl['wow_itemdesc2'];

	// END -- Grim Times: WoW Items for phpBB

#
#-----[ OPEN ]------------------------------------------
#

templates/subSilver/bbcode.tpl

#
#-----[ FIND ]------------------------------------------
#

<!-- BEGIN email -->

#
#-----[ AFTER, ADD ]------------------------------------------
#

<!-- BEGIN item --><a class="{QUALITY}" target="_blank" href="{URL}">{TEXT}</a><!-- END item -->

<!-- BEGIN itemdesc --></span>
{ITEMDIV}
<span class="postbody"><!-- END itemdesc -->

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------
#
# EoM