############################################################## 
## MOD Title: Grim Times: WoWWiki BBCode
## MOD Author: DrDark < N/A > (N/A) http://code.google.com/p/grimtimes/
## MOD Description: Allows easy linking to WoWWiki articles: [wowwiki]Main Page[/wowwiki]
## MOD Version: 1.0.0
##
## Installation Level: (Easy) 
## Installation Time: 5 Minutes
## Files To Edit: includes/bbcode.php,
##           langugage/lang_english/lang_main.php,
##           templates/subSilver/bbcode.tpl,
##           templates/subSilver/posting_body.tpl
## Included Files: n/a
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
## Before Adding This MOD To Your Forum, You Should Back Up All Files Related To This MOD 
##
############################################################## 

#
#-----[ OPEN ]------------------------------------------
#

includes/bbcode.php

#
#-----[ FIND ]---------------------------------
#

// MULTI BBCODE-begin
function Multi_BBCode()

#
#-----[ BEFORE, ADD ]------------------------------------------
#

function mediawikify($article) {
	return urlencode(str_replace(" ", "_", html_entity_decode($article, ENT_QUOTES)));
}

#
#-----[ FIND ]---------------------------------
#

$EMBB_widths = array(''

#
#-----[ IN-LINE FIND ]---------------------------------
#

array(''

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------
#

, '65'

#
#-----[ FIND ]---------------------------------
#

$EMBB_values = array(''

#
#-----[ IN-LINE FIND ]---------------------------------
#

array(''

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------
#

, 'wowwiki'

#
#-----[ FIND ]------------------------------------------
#

	$bbcode_tpl['email'] = str_replace('{EMAIL}', '\\1', $bbcode_tpl['email']);

#
#-----[ AFTER, ADD ]------------------------------------------
#

	$bbcode_tpl['wowwiki'] = '\'' . $bbcode_tpl['wowwiki'] . '\'';
	$bbcode_tpl['wowwiki'] = str_replace('{ARTICLE}', "' . mediawikify('\\1') . '", $bbcode_tpl['wowwiki']);

	$bbcode_tpl['wowwiki1'] = str_replace('{TEXT}', '\\1', $bbcode_tpl['wowwiki']);
	$bbcode_tpl['wowwiki2'] = str_replace('{TEXT}', '\\2', $bbcode_tpl['wowwiki']);

#
#-----[ FIND ]------------------------------------------
#

	$replacements[] = $bbcode_tpl['email'];

#
#-----[ AFTER, ADD ]------------------------------------------
#
# 

	$patterns[] = "#\[wowwiki\](.+?)\[/wowwiki\]#ise";
	$replacements[] = $bbcode_tpl['wowwiki1'];

	$patterns[] = "#\[wowwiki=([^\]]+)\](.+?)\[/wowwiki\]#ise";
	$replacements[] = $bbcode_tpl['wowwiki2'];

#
#-----[ OPEN ]---------------------------------
#

language/lang_english/lang_main.php

#
#-----[ FIND ]---------------------------------
#

$lang['bbcode_f_help'] =

#
#-----[ AFTER, ADD ]---------------------------------
#

$lang['bbcode_help']['wowwiki'] = "WoWWiki: [wowwiki]Article[/wowwiki] or [wowwiki=Article]link text[/wowwiki] ";

#
#-----[ OPEN ]------------------------------------------ 
#

templates/subSilver/bbcode.tpl
    
#
#-----[ FIND ]------------------------------------------ 
#

<!-- BEGIN email --><a href="mailto:{EMAIL}">{EMAIL}</a><!-- END email -->

#
#-----[ AFTER, ADD ]------------------------------------------ 
#

<!-- BEGIN wowwiki --><a href="http://www.wowwiki.com/{ARTICLE}" target="_blank">{TEXT}</a><!-- END wowwiki -->

#
#-----[ OPEN ]---------------------------------
#

templates/subSilver/posting_body.tpl

#
#-----[ FIND ]---------------------------------
#

bbtags = new Array(

#
#-----[ IN-LINE FIND ]---------------------------------
#

'[url]','[/url]'

#
#-----[ IN-LINE AFTER, ADD ]---------------------------------
#

,'[wowwiki]','[/wowwiki]'

#
#-----[ SAVE/CLOSE ALL FILES ]------------------------------------------ 
#
# EoM
