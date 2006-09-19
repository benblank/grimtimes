<?php /* $Id$ */

	// Just enough to get the DBAL working...
	define('IN_PHPBB', true);
	$phpbb_root_path = './';
	include($phpbb_root_path . 'extension.inc');
	include($phpbb_root_path . 'common.'.$phpEx);
	include($phpbb_root_path . 'config.'.$phpEx);
	include($phpbb_root_path . 'includes/db.'.$phpEx);
	unset($dbpasswd);

	include($phpbb_root_path . 'includes/functions_wow_items.'.$phpEx);

	ignore_user_abort(true);

	die_text($msg, $file, $line) {
		// "Magic" database errors.
		if (gettype($msg) == "array") $msg = "Database error {$msg['code']}: {$msg['message']}";
		else if (gettype($msg) != "string") $msg = "Error";
		else $msg = "Error \"$msg\"";

		die($msg . " in " . $file . " on line " . $line);
	}

	if (!isset($_POST)) {
		if (!isset($HTTP_POST_VARS)) die_text("Not a request", __FILE__, __LINE__);
		$_POST = $HTTP_POST_VARS;
	}

	if (!isset($_POST['item'])) die_text("You must specify an item", __FILE__, __LINE__);
	$post = trim($_POST['item']);

	if (!preg_match('/\d+/', $item)) die_text("Items must be referenced by ID", __FILE__, __LINE__);

	// Item "zero" means rebuild the ID <-> Name mapping
	if ($item == 0) {
		// Get a list of which items need to be re-cached.  We use
		// item_desc instead of item_stamp because the latter is used
		// to track when the mapping was last updated.
		$items = $db->sql_query("SELECT item_id FROM " . WOW_ITEMS_TABLE . " WHERE item_desc IS NOT NULL", BEGIN_TRANSACTION);
		if (!$items) die_text($db->sql_error(), __FILE__, __LINE__);
		$items = $db->sql_fetchrowset($items);
		foreach ($items as $k => $v) $items[$k] = $v['item_id'];
		sort($items);

		// And here's why we're doing this transactionally.  Ouch!
		if (!$db->sql_query("TRUNCATE " . WOW_ITEMS_TABLE)) die_text($db->sql_error(), __FILE__, __LINE__);

		$lines = file("http://wow.allakhazam.com/itemlist.xml");
		$sql = "INSERT INTO " . WOW_ITEMS_TABLE . " (item_id, item_name, item_stamp) VALUES ((0, '00index', TIMESTAMP())";

		foreach ($lines as $line) {
			if (preg_match('#<wowitem name="([^"]+)" id="(\d+)"/>#', $line, $match)) {
				$sql .= ", ({$match[1]}, '{$match[0]}', NULL)";
			}
		}

		$sql .= ")";

		if (!$db->sql_query($sql)) die_text($db->sql_error(), __FILE__, __LINE__);
	} else {
		$items[] = $item;
	}

	// Do item caching

	// If this is an index recache, we need to commit the transaction.
	if ($db->in_transaction) $db->sql_query("", END_TRANSACTION);
