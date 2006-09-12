<?php /* $Id$ */
	if (!defined('IMG_GIF')) {
		$rank = file_exists("rank" . $_GET['rank'] . ".gif") ? $_GET['rank'] : "bg";

		header("HTTP/1.1 301 Moved Permanently");
		header("Location: rank$rank.gif");
		exit();
	} else {
		header('Content-type: image/gif');

		$bg = @imageCreateFromGIF("rankbg.gif");
		$fg = @imageCreateFromGIF("rank{$_GET['rank']}.gif");

		if (!$bg && !$fg) exit(); // Null image, but who cares?  Wrong is wrong is wrong.

		if (!$bg) {
			imageGIF($fg);
			exit();
		}

		if ($fg) {
			imageCopyMerge($bg, $fg, 0, 0, 0, 0, 17, 17, 100);
		}

		imageGIF($bg);
	}
