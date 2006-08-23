GT_EnhQuality = {
	TooltipHook = function(funcVars, retVal, frame, name, link, quality, count)
		if EnhTooltip.LinkType(link) ~= "item" then return end

		EnhTooltip.AddLine("Quality: " .. getglobal("ITEM_QUALITY" .. quality .. "_DESC"))
		EnhTooltip.LineQuality(quality)
	end,
}

Stubby.RegisterFunctionHook("EnhTooltip.AddTooltip", 301, GT_EnhQuality.TooltipHook)
