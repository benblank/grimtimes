-- $LastChangedBy$
-- $LastChangedRevision$
-- $LastChangedDate$
-- $HeadURL$

GT_TitanAltXP_Config = {
	xp       = true,
	xp_pct   = true,
	rest     = true,
	rest_pct = false,
	left     = true,
	left_pct = false,

	--[[ Note: all xp_* values will be replaced with "n/a" for characters who have reached their level cap (currently 60)
		xp_current         XP earned so far this level
		xp_current_pct     XP earned so far this level as a percentage of the XP needed to attain the next level
		xp_left            XP remaining before attaining the next level
		xp_left_pct        XP remaining before attaining the next level as a percentage of the total needed
		xp_level           Your current level
		xp_rest            Earned rest (you will gain this many "freebie" XP before losing rest status)
		xp_rest_pct_max    Earned rest as a percentage of the maximum amount of rest (1.5 * xp_total)
		xp_rest_pct_total  Earned rest as a percentage of the amount needed to level
		xp_total           The total amount of XP needed to attain the next level
		(more?)
	]]
	xp_str = "XP: #xp_current_pct#  Rest: #xp_rest# (#xp_rest_pct_max#)  Left: #xp_left#",
	xp_norest_color = {r = 1, g = 0, b = 0},
	xp_norest_colorize = true,

	--[[ Note: all rep_* values will be replaced with "n/a" for characters without a faction selected on the Reputation frame
		rep_atwar        If you are at war with the selected faction, "At War" (otherwise blank)
		rep_atwar_comma  If you are at war with the selected faction, a comma (otherwise blank)
		rep_atwar_space  If you are at war with the selected faction, a space (otherwise blank)
		rep_current      Reputation earned towards the next level
		rep_current_pct  Reputation earned towards the next level, as a percentage of the total needed
		rep_left         Reputation left until the next level is attained
		rep_left_pct     Reputation left until the next level is attained, as a percentage of the total needed
		rep_level        Your current reputation level with the selected faction (Hostile, Friendly, Revered, ...)
		rep_name         The name of the currently selected faction
		rep_total        The total amount of reputation needed to attain the next level
		(more?)
	]]
	rep_str = "#rep_name#: #rep_current_pct# (#rep_level##rep_atwar_comma##rep_atwar_space##rep_atwar#)  Left: #rep_left#",
	rep_atwar_color = {r = 1, g = 0, b = 0},
	rep_atwar_colorize = true,
}

function GT_TitanAltXP_OnLoad()
	this.registry = {
		id = "GrimAltExp",
		menuText = "Grim Times: AltXP",
		buttonTextFunction = "GT_TitanAltXP_GetButtonText",
	}

	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEVEL_UP");
	this:RegisterEvent("PLAYER_UPDATE_RESTING");
	this:RegisterEvent("PLAYER_XP_UPDATE");
	this:RegisterEvent("UPDATE_EXHAUSTION");
end

function GT_TitanAltXP_OnEvent()
	TitanPanelButton_UpdateButton()
end

function GT_TitanAltXP_MakePercent(num, denom)
	if not num or not denom or denom == 0 then
		return "0%"
	end

	return floor((num / denom) * 100) .. "%"
end

function GT_TitanAltXP_BuildXP(pat)
	xp_level = TitanUtils_Ternary(event and event == "PLAYER_LEVEL_UP", arg1, UnitLevel("player"))

	if xp_level == 60 then
		xp_current = TitanUtils_GetHighlightText("n/a")
		xp_current_pct = xp_current
		xp_left = xp_current
		xp_left_pct = xp_current
		xp_level = xp_current
		xp_rest = xp_current
		xp_rest_pct_max = xp_current
		xp_rest_pct_total = xp_current
		xp_total = xp_current
	else
		xp_current = UnitXP("player")
		xp_rest    = GetXPExhaustion()
		xp_total   = UnitXPMax("player")

		if xp_rest == 0 then
			xp_rest = "none"
			if GT_TitanAltXP_Config.rep_atwar_colorize then xp_rest = TitanUtils_GetColoredText(xp_rest, GT_TitanAltXP_Config.rep_atwar_color) end
			xp_rest_pct_max   = xp_rest
			xp_rest_pct_total = xp_rest
		else
			xp_rest_pct_max   = GT_TitanAltXP_MakePercent(xp_rest, xp_total * 1.5)
			xp_rest_pct_total = GT_TitanAltXP_MakePercent(xp_rest, xp_total)
		end

		xp_current_pct = GT_TitanAltXP_MakePercent(xp_current, xp_total)
		xp_left        = xp_total - xp_current
		xp_left_pct    = GT_TitanAltXP_MakePercent(xp_left, xp_total)
	end

	str, count = string.gsub(pat, "#xp_current#",        xp_current)
	str, count = string.gsub(str, "#xp_current_pct#",    xp_current_pct)
	str, count = string.gsub(str, "#xp_left#",           xp_left)
	str, count = string.gsub(str, "#xp_left_pct#",       xp_left_pct)
	str, count = string.gsub(str, "#xp_level#",          xp_level)
	str, count = string.gsub(str, "#xp_rest#",           xp_rest)
	str, count = string.gsub(str, "#xp_rest_pct_max#",   xp_rest_pct_max)
	str, count = string.gsub(str, "#xp_rest_pct_total#", xp_rest_pct_total)
	str, count = string.gsub(str, "#xp_total#",          xp_total)

	return str
end

function GT_TitanAltXP_GetButtonText()
	str = "";

	if 60 == TitanUtils_Ternary(event and event == "PLAYER_LEVEL_UP", arg1, UnitLevel("player")) then
		if GT_TitanAltXP_Config.xp then
			str = str .. "XP: " .. TitanUtils_GetHighlightText("n/a")
		end

		if GT_TitanAltXP_Config.rest then
			if strlen(str) > 0 then str = str .. "  " end
			str = str .. "Rest: " .. TitanUtils_GetHighlightText("n/a")
		end

		if GT_TitanAltXP_Config.left then
			if strlen(str) > 0 then str = str .. "  " end
			str = str .. "Left: " .. TitanUtils_GetHighlightText("n/a")
		end

		return str
	end

	local xp    = UnitXP("player")
	local rest  = GetXPExhaustion()
	local total = UnitXPMax("player")

	local disp_xp   = TitanUtils_Ternary(GT_TitanAltXP_Config.xp_pct,   GT_TitanAltXP_MakePercent(xp,           total), xp)
	local disp_rest = TitanUtils_Ternary(GT_TitanAltXP_Config.rest_pct, GT_TitanAltXP_MakePercent(rest, (total * 1.5)), rest)
	local disp_left = TitanUtils_Ternary(GT_TitanAltXP_Config.left_pct, GT_TitanAltXP_MakePercent(total - xp,   total), total - xp)

	if GT_TitanAltXP_Config.xp then
		str = str .. "XP: " .. disp_xp
	end

	if GT_TitanAltXP_Config.rest then
		if strlen(str) > 0 then str = str .. "  " end
		str = str .. "Rest: " .. TitanUtils_Ternary(rest and rest > 0, disp_rest, TitanUtils_GetRedText("none"))
	end

	if GT_TitanAltXP_Config.left then
		if strlen(str) > 0 then str = str .. "  " end
		str = str .. "Left: " .. disp_left
	end

	return str
end
