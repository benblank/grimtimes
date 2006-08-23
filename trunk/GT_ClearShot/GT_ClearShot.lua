-- $LastChangedBy$
-- $LastChangedRevision$
-- $LastChangedDate$
-- $HeadURL$

BINDING_HEADER_GRIMTIMES = "Grim Times"
BINDING_NAME_GTCSSHOOT   = "Take a ClearShot (no UI)"
BINDING_NAME_GTCSFIX     = "Restore Settings (if something goes wrong)"

GT_ClearShot_None     = 0
GT_ClearShot_TakeShot = 1
GT_ClearShot_Cleanup  = 2

if GT_Config == nil then GT_Config = {} end
if GT_Config.Headers == nil then GT_Config.Headers = {} end

GT_Config["Headers"] = {
	GT_ClearShot = "When taking a ClearShot,",
}

GT_Config["GT_ClearShot"] = {
	{"Remove Chat Bubbles",    "bool", true},
	{"Remove Character Names", "bool", true},
}

GT_ClearShot_Config = {
	disable_bubbles = true,
	disable_names   = true,
}

GT_ClearShot = {
	Values = {
		CVars = nil,
		FPS = nil,
		UI = nil,
	},

	State = GT_ClearShot_None,

	Disable = {
		CVars = function()
			GT_ClearShot.Values.CVars = {}

			local cvars = {}

			if GT_ClearShot_Config.disable_bubbles then
				table.insert(cvars, "ChatBubbles");
				table.insert(cvars, "ChatBubblesParty");
			end

			if GT_ClearShot_Config.disable_names then
				table.insert(cvars, "PetNamePlates");
				table.insert(cvars, "UnitNameNPC");
				table.insert(cvars, "UnitNamePlayer");
				table.insert(cvars, "UnitNamePlayerGuild");
				table.insert(cvars, "UnitNamePlayerPVPTitle");
			end

			for cvar in cvars do
				GT_ClearShot.Values.CVars[cvars[cvar]] = GetCVar(cvars[cvar])
				SetCVar(cvars[cvar], 0)
			end
		end,

		FPS = function()
			GT_ClearShot.Values.FPS = FramerateText:IsShown()
			FramerateLabel:Hide()
			FramerateText:Hide()
		end,

		Timers = function()
			for timer, color in MirrorTimerColors do
			end
		end,

		UI = function()
			GT_ClearShot.Values.UI = UIParent:IsShown()
			UIParent:Hide()
		end,
	},

	Restore = {
		CVars = function()
			if not GT_ClearShot.Values.CVars then return end

			for cvar, value in GT_ClearShot.Values.CVars do
				if value then
					SetCVar(cvar, value)
				end
			end

			GT_ClearShot.Values.CVars = nil
		end,

		FPS = function()
			if GT_ClearShot.Values.FPS then
				FramerateLabel:Show()
				FramerateText:Show()
			end

			GT_ClearShot.Values.FPS = nil
		end,

		UI = function()
			if GT_ClearShot.Values.UI then
				UIParent:Show()
			end

			GT_ClearShot.Values.UI = nil
		end,
	},

	All = function(action)
		for func in action do
			action[func]()
		end
	end,

	Prep = function()
		if GT_ClearShot.State == GT_ClearShot_None then
			GT_ClearShot.All(GT_ClearShot.Disable)
			GT_ClearShot.State = GT_ClearShot_TakeShot
		end
	end,

	Trigger = function()
		if GT_ClearShot.State == GT_ClearShot_TakeShot then
			TakeScreenshot()
			GT_ClearShot.State = GT_ClearShot_Cleanup
		elseif GT_ClearShot.State == GT_ClearShot_Cleanup then
			GT_ClearShot.All(GT_ClearShot.Restore)
			GT_ClearShot.State = GT_ClearShot_None
		end
	end,
}

GT_Event.AddEvent("GT_ClearShot", "Update", GT_ClearShot.Trigger)
