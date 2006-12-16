function wow_item_hover(event,id) {
	var hover = wow_item_gethover();
	var item = document.getElementById("item"+id);
	if (item == null) return;

	hover.innerHTML = item.innerHTML;

	var x, y;
	if (document.all) {
		x = event.clientX + document.body.scrollLeft + 10;
		y = event.clientY + document.body.scrollTop;
	} else {
		x = event.pageX + 10;
		y = event.pageY;
	}

	hover.style.left = x + "px";
	hover.style.top = y + "px";
	hover.style.display = "block";
}

function wow_item_unhover() {
	var hover = wow_item_gethover();
	hover.style.display = "none";
}

function wow_item_gethover() {
	var hover = document.getElementById("wowhover");

	if (hover == null) {
		hover = document.createElement("div");
		hover.id = "wowhover";
		hover.style.display = "none";
		hover.style.position = "absolute";
		document.body.appendChild(hover);
	}

	return hover;
}
