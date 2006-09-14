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
## Files To Edit: 10
##     modcp.php
##     posting.php
##     privmsg.php
##     search.php
##     viewtopic.php
##     admin/admin_users.php
##     includes/bbcode.php
##     includes/functions_search.php
##     includes/topic_review.php
##     includes/usercp_register.php
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
## "<info>:" to the $uid and still have it automatically stripped
## out.
##
## In addition to the changes made automatically, it's worth noting
## that install/upgrade.php would also benefit from this mod, save
## that it is removed during installation:
##
## find:      $subject = preg_replace("/\[.*?\:(([a-z0-9]:)?)$uid.*?\]/si", "", $subject);
## change to: $subject = bbcode_clean($subject, $uid);
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

if ( $user_sig != ''
{
	$user_sig = ( $board_config['allow_bbcode'] ) ?
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace('/\:[0-9a-z\:]+\]/si', ']', $user_sig)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($user_sig, $user_sig_bbcode_uid)

#
#-----[ FIND ]------------------------------------------
#

if ( $bbcode_uid != '' )
{
	$private_message = ( $board_config['allow_bbcode'] ) ?
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace('/\:[0-9a-z\:]+\]/si', ']', $private_message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($private_message, $bbcode_uid)

#
#-----[ FIND ]------------------------------------------
#

$privmsg_message = preg_replace("/\:(([a-z0-9]:)?)$privmsg_bbcode_uid/si", '', $privmsg_message);

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace("/\:(([a-z0-9]:)?)$privmsg_bbcode_uid/si", '', $privmsg_message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($privmsg_message, $privmsg_bbcode_uid)

#
#-----[ FIND ]------------------------------------------
#
# Yes, this line appears twice in privmsg.php and needs identical
# changes in both cases.
#

$privmsg_message = preg_replace("/\:(([a-z0-9]:)?)$privmsg_bbcode_uid/si", '', $privmsg_message);

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace("/\:(([a-z0-9]:)?)$privmsg_bbcode_uid/si", '', $privmsg_message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($privmsg_message, $privmsg_bbcode_uid)

#
#-----[ OPEN ]------------------------------------------
#

search.php

#
#-----[ FIND ]------------------------------------------
#

						$message = preg_replace("/\[.*?:$bbcode_uid:?.*?\]/si", '', $message);
						$message = preg_replace('/\[url\]|\[\/url\]/si', '', $message);

#
#-----[ REPLACE WITH ]---------------------------------------------------
#

						$message = bbcode_strip($message, $bbcode_uid);

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

viewtopic.php

#
#-----[ FIND ]------------------------------------------
#

if ($user_sig != '' && $user_sig_bbcode_uid != '')
{
	$user_sig = ($board_config['allow_bbcode']) ?
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace("/\:$user_sig_bbcode_uid/si", '', $user_sig)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($user_sig, $user_sig_bbcode_uid)

#
#-----[ FIND ]------------------------------------------
#

if ($bbcode_uid != '')
{
	$message = ($board_config['allow_bbcode']) ?
}

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace("/\:$bbcode_uid/si", '', $message)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($message, $bbcode_uid)

#
#-----[ OPEN ]------------------------------------------
#

admin/admin_users.php

#
#-----[ FIND ]------------------------------------------
#

$signature = ($this_userdata['user_sig_bbcode_uid'] != '') ?

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace('#:' . $this_userdata['user_sig_bbcode_uid'] . '#si', '', $this_userdata['user_sig'])

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($this_userdata['user_sig'], $this_userdata['user_sig_bbcode_uid'])

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
function bbcode_clean($text, $uid = '') {
	if (!$uid) $uid = '[0-9a-f]{' . BBCODE_UID_LEN . '}';

	return preg_replace('/(:\w+)*:' . $uid . '/i', '', $text);
}

// Removes any BBcodes entirely.  Note that the original code in
// search.php did not handle [url=] or [email], which this function
// does.
function bbcode_strip($text, $uid = '') {
	if (!$uid) $uid = '[0-9a-f]{' . BBCODE_UID_LEN . '}';

	$retval = preg_replace('/\[[^\]]*?:' . $uid . '[^\]]*?\]/i', '', $text);
	return preg_replace('#\[/?(email|url(=[^\]]+)?)\]#i', '', $retval);
}

#
#-----[ OPEN ]------------------------------------------
#

includes/functions_search.php

#
#-----[ FIND ]------------------------------------------
#

		// Quickly remove BBcode.
		$entry = preg_replace('/\[img:[a-z0-9]{10,}\].*?\[\/img:[a-z0-9]{10,}\]/', ' ', $entry); 
		$entry = preg_replace('/\[\/?url(=.*?)?\]/', ' ', $entry);
		$entry = preg_replace('/\[\/?[a-z\*=\+\-]+(\:?[0-9a-z]+)?:[a-z0-9]{10,}(\:[a-z0-9]+)?=?.*?\]/', ' ', $entry);

#
#-----[ REPLACE WITH ]---------------------------------------------------
#

		// Quickly remove BBcode.
		$entry = bbcode_strip($entry);

#
#-----[ OPEN ]------------------------------------------
#

includes/topic_review.php

#
#-----[ FIND ]------------------------------------------
#

if ( $bbcode_uid != "" )
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

includes/usercp_register.php

#
#-----[ FIND ]------------------------------------------
#

$signature = ($signature_bbcode_uid != '') ?

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace("/:(([a-z0-9]+:)?)$signature_bbcode_uid(=|\])/si", '\\3', $signature)

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($signature, $signature_bbcode_uid)

#
#-----[ FIND ]------------------------------------------
#

$signature = ($signature_bbcode_uid != '') ?

#
#-----[ IN-LINE FIND ]---------------------------------------------------
#

preg_replace("/:(([a-z0-9]+:)?)$signature_bbcode_uid(=|\])/si", '\\3', $userdata['user_sig'])

#
#-----[ IN-LINE REPLACE WITH ]---------------------------------------------------
#

bbcode_clean($userdata['user_sig'], $signature_bbcode_uid)

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------
#
# EoM
