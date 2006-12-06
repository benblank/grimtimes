<h1>{L_WOW_TITLE}</h1>
<p>{L_WOW_TEXT}</p>

<!-- BEGIN status -->
<p style="font-style:italic;text-align:center">{status.TEXT}</p>
<!-- END status -->

<form method="post" action="{S_WOW_ACTION}"><table cellspacing="1" cellpadding="4" border="0" align="center" class="forumline">
	<tr><th align="center" class="thHead">{L_UPDATE}</th></tr>
	<tr><td align="center" class="row1">{UPDATE_ITEMS} {L_UPDATE_ITEMS}<br />{UPDATE_CACHED} {L_UPDATE_CACHED}</td></tr>
	<tr><td align="center" class="catBottom">{S_UPDATE_HIDDEN}<input type="submit" name="add" value="{L_UPDATE_SUBMIT}" class="mainoption" /></td></tr>
</table></form>

<form method="post" action="{S_WOW_ACTION}"><table cellspacing="1" cellpadding="4" border="0" align="center" class="forumline">
	<tr>
		<th class="thCornerL">&nbsp;</th>
		<th class="thTop">{L_PRECACHE_SET}</th>
		<th class="thTop">{L_PRECACHE_COUNT}</th>
		<th class="thCornerR">{L_PRECACHE_STATUS}</th>
	</tr>
	<!-- BEGIN precache -->
	<tr>
		<td class="{precache.ROW_CLASS}" align="center">{precache.SET_CHECKBOX}</td>
		<td class="{precache.ROW_CLASS}" align="left">{precache.SET_NAME}</td>
		<td class="{precache.ROW_CLASS}" align="center">{precache.SET_COUNT}</td>
		<td class="{precache.ROW_CLASS}" align="center">{precache.SET_STATUS}</td>
	</tr>
	<!-- END precache -->
	<tr><td colspan="4" align="center" class="catBottom"><input type="submit" name="add" value="{L_PRECACHE_SUBMIT}" class="mainoption" /></td></tr>
</table></form>
