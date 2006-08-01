GT_Event = {
	EventCount = {},
	EventTable = {},
	Ready = false,

	AddEvent = function(addon, event, callback)
		if addon == nil or event == nil or callback == nil then
			GT_Output.Error("GT_Event", "InvalidAdd", addon, event)
			return
		end

		if GT_Event.EventTable[event] == nil then
			GT_Event.EventCount[event] = 0
			GT_Event.EventTable[event] = {}

			if (GT_Event.Ready) then
				GT_Output.Debug("GT_Event", "RegisterEvent", event)
				GT_Event_TriggerFrame:RegisterEvent(event)
			end
		end

		GT_Output.Debug("GT_Event", "AddEvent", addon, event)
		GT_Event.EventCount[event] = GT_Event.EventCount[event] + 1
		GT_Event.EventTable[event][addon] = callback
	end,

	RemoveEvent = function(addon, event)
		if name == nil or event == nil then
			GT_Output.Error("GT_Event", "InvalidRemove", addon, event)
			return
		end

		if GT_Event.EventTable[event] == nil or GT_Event.EventTable[event][addon] == nil then
			GT_Output.Warn("GT_Event", "MissingRemove", addon, event)
			return
		end

		GT_Output.Debug("GT_Event", "RemoveEvent", addon, event)
		GT_Event.EventCount[event] = GT_Event.EventCount[event] - 1
		GT_Event.EventTable[event][addon] = nil

		if GT_Event.EventCount[event] == 0 then
			GT_Event.EventCount[event] = nil
			GT_Event.EventTable[event] = nil

			if (GT_Event.Ready) then
				GT_Output.Debug("GT_Event", "UnregisterEvent", event)
				GT_Event_TriggerFrame:UnregisterEvent(event)
			end
		end
	end,

	Trigger = function(event)
		if GT_Event.EventTable[event] == nil then
			if event ~= "Update" then
				GT_Output.Warn("GT_Event", "BadTrigger", event)
				GT_Event.EventCount[event] = nil
				GT_Event_TriggerFrame:UnregisterEvent(event)
			end

			return
		end

		for addon, func in GT_Event.EventTable[event] do
			-- Don't spam debug for Update!
			if event ~= "Update" then
				GT_Output.Debug("GT_Event", "Calling", event, addon)
			end

			func()
		end
	end,

	OnLoad = function()
		for event in GT_Event.EventTable do
			GT_Output.Debug("GT_Event", "RegisterEvent", event)
			GT_Event_TriggerFrame:RegisterEvent(event)
		end

		GT_Event.Ready = true
	end,
}
