-- $LastChangedBy$
-- $LastChangedRevision$
-- $LastChangedDate$
-- $HeadURL$

if GT_Config == nil then GT_Config = {} end

GT_Bartender_MCom = {
	hasbool = true,
	uitype = K_CHECKBOX,
	uisec = "Khaos Section?",

	{"Use Out-of-range Coloring", "bool", "range_color_use"},
	{"Out-of-range Color",        "color", "range_color"},
	{"Remove Left Dragon",        "bool", "remove_art_left"},
	{"Remove Right Dragon",       "bool", "remove_art_right"},
	{"Remove Pet Bar Art",        "bool", "remove_art_pet"},
	{"Remove Shift Bar Art",      "bool", "remove_art_shift"},
}

GT_Bartender_Config = {
	range_color      = { r = 1.0, g = 0.5, b = 0.5 },
	range_color_use  = true,
	remove_art_left  = true,
	remove_art_pet   = true,
	remove_art_right = true,
	remove_art_shift = true,
}

GT_Bartender = {
	ActionOnUpdate = nil,

	ButtonUpdate = function(elapsed)
		if GT_Bartender.ActionOnUpdate ~= nil then
			GT_Bartender.ActionOnUpdate(elapsed)
		end

		local isUsable, notEnoughMana = IsUsableAction(ActionButton_GetPagedID(this))

		if this.rangeTimer and this.rangeTimer <= elapsed then
			if isUsable and not notEnoughMana then
				if IsActionInRange(ActionButton_GetPagedID(this)) == 0 then
					getglobal(this:GetName() .. "Icon"):SetVertexColor(1.0, 0.5, 0.5)
					getglobal(this:GetName() .. "NormalTexture"):SetVertexColor(1.0, 0.5, 0.5)
				else
					getglobal(this:GetName() .. "Icon"):SetVertexColor(1.0, 1.0, 1.0)
					getglobal(this:GetName() .. "NormalTexture"):SetVertexColor(1.0, 1,0, 1.0)
				end
			end
		end
	end,

	FrameDisplay = function(frame, value)
		if not value or value == false or value == 0 then
			if getglobal(frame):IsVisible() then
				getglobal(frame):Hide()
			end
		else
			if not getglobal(frame):IsVisible() then
				getglobal(frame):Show()
			end
		end
	end,

	OnLoad = function()
		if (Sea and Sea.util and Sea.util.hook) then
			-- Use the hooking routine from Sea, if available, to avoid conflicts.
			Sea.util.hook("ActionButton_OnUpdate", "GT_Bartender.ButtonUpdate", "after")
		else
			-- Otherwise, bruteforce it.
			GT_Bartender.ActionOnUpdate = ActionButton_OnUpdate
			ActionButton_OnUpdate       = GT_Bartender.ButtonUpdate
		end

		GT_Bartender.FrameDisplay("MainMenuBarLeftEndCap",  not GT_Bartender_Config.remove_art_left)
		GT_Bartender.FrameDisplay("MainMenuBarRightEndCap", not GT_Bartender_Config.remove_art_right)

		GT_Bartender.FrameDisplay("SlidingActionBarTexture0", not GT_Bartender_Config.remove_art_pet)
		GT_Bartender.FrameDisplay("SlidingActionBarTexture1", not GT_Bartender_Config.remove_art_pet)

		GT_Bartender.FrameDisplay("ShapeshiftBarLeft",   not GT_Bartender_Config.remove_art_shift)
		GT_Bartender.FrameDisplay("ShapeshiftBarMiddle", not GT_Bartender_Config.remove_art_shift)
		GT_Bartender.FrameDisplay("ShapeshiftBarRight",  not GT_Bartender_Config.remove_art_shift)
	end,
}

GT_Event.AddEvent("GT_Bartender", "VARIABLES_LOADED", GT_Bartender.OnLoad)
