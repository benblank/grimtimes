## EasyMod Compliant
##############################################################
##
## $Id: gt_wow_items.mod 9 2006-09-12 23:52:37Z dark.ryder $
##
## MOD Title: Better BBcode UID Remover
## MOD Author: DrDark < N/A > (N/A) http://code.google.com/p/grimtimes/
## MOD Description: Makes the removal of BBcode UIDs more
## consistent, more accurate, and more flexible.
## MOD Version: 0.9
##
## Installation Level: Easy
## Installation Time: 5 Minutes
## Files To Edit: ?
##     modcp.php
##     posting.php
##     includes/bbcode.php
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
## The regexes used to "clean" BBcode which has already been
## first-pass processed is scattered all over the code and most
## of them operate in completely different ways.  This mod replaces
## all of them with a call to a new function -- bbcode_clean --
## which removes any occurences of "(:\w+)*:$uid".  This not only
## squashes a few (minor) potental bugs, but also allows authors of
## BBcode mods to store information in the first pass by prepending
## "<info>:" to the $uid and still have it automatically stripped out.
##
##############################################################
##
##############################################################
##
## Before Adding This MOD To Your Forum, You Should Back Up All Files Related To This MOD
##
##############################################################

#
#-----[ OPEN ]------------------------------------------
#

modcp.php

#
#-----[ FIND ]------------------------------------------
#

if ( $bbcode_uid != '' )
{
	$message = ( $board_config['allow_bbcode'] ) ?
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace('/\:[0-9a-z\:]+\]/si', ']', $message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($message, $bbcode_uid)

#
#-----[ OPEN ]------------------------------------------
#

posting.php

#
#-----[ FIND ]------------------------------------------
#

if ( $post_info['bbcode_uid'] != '' )
{
	$message = preg_replace(
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace('/\:(([a-z0-9]:)?)' . $post_info['bbcode_uid'] . '/s', '', $message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($message, $post_info['bbcode_uid'])

#
#-----[ OPEN ]------------------------------------------
#

privmsg.php

#
#-----[ FIND ]------------------------------------------
#

if ( $post_info['bbcode_uid'] != '' )
{
	$message = preg_replace(
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace('/\:(([a-z0-9]:)?)' . $post_info['bbcode_uid'] . '/s', '', $message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($message, $post_info['bbcode_uid'])

#
#-----[ OPEN ]------------------------------------------
#

includes/bbcode.php

#
#-----[ FIND ]------------------------------------------
#

?>

#
#-----[ BEFORE, ADD ]------------------------------------------
#

// Improved BBcode cleaner.  Allows automatic translation of, e.g.,
// "[mycode:extra:info:$uid=option]" to "[mycode=option]" without
// messing up ordinary text involving colons (e.g. ":regular:text:"
// by keying off the $uid.
function bbcode_clean($text, $uid) {
	return preg_replace('/(:\w+)*:' . $uid . '/s', '', $text);
}

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------
#
# EoM
