<?php /* $Id$ */

	// Just enough to get the DBAL working...
	define('IN_PHPBB', true);
	$phpbb_root_path = './';
	include($phpbb_root_path . 'extension.inc');
	include($phpbb_root_path . 'common.'.$phpEx);
	include($phpbb_root_path . 'config.'.$phpEx);
	include($phpbb_root_path . 'includes/db.'.$phpEx);
	unset($dbpasswd);

	ignore_user_abort(true);

	if (!isset($_POST)) {
		if (!isset($HTTP_POST_VARS)) die("Not a request");
		$_POST = $HTTP_POST_VARS;
	}

	if (!isset($_POST['item'])) die("You must specify an item");
	$post = trim($_POST['item']);

	if (!preg_match('/\d+/', $item)) die("Items must be referenced by ID");

	// Item "zero" means rebuild the ID <-> Name mapping
	if ($item == 0) {
		$lines = file("http://wow.allakhazam.com/itemlist.xml");

		exit();
	}
