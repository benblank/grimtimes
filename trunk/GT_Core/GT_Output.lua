GT_Output_Config = {
	fallback = "enUS",
	level = 2, -- GT_Output.Levels.Warn
}

GT_Output = {
	Levels = {
		Debug    = 0,
		Info     = 1,
		Warn     = 2,
		Error    = 3,
	},
	Strings = {},

	Debug = function(addon, key, ...) GT_Output.Output("Debug", 0.75, 0.75, 0.75, addon, key, unpack(arg)) end,
	Info  = function(addon, key, ...) GT_Output.Output("Info",  1.0,  1.0,  1.0,  addon, key, unpack(arg)) end,
	Warn  = function(addon, key, ...) GT_Output.Output("Warn",  1.0,  1.0,  0.0,  addon, key, unpack(arg)) end,
	Error = function(addon, key, ...) GT_Output.Output("Error", 1.0,  0.25, 0.25, addon, key, unpack(arg)) end,

	Output = function(level, r, g, b, addon, key, ...)
		if type(GT_Output_Config)       ~= "table"  then GT_Output_Config       = {}                    end
		if type(GT_Output_Config.level) ~= "number" then GT_Output_Config.level = GT_Output.Levels.Warn end

		if GT_Output_Config.level > GT_Output.Levels[level] then
			return
		end

		DEFAULT_CHAT_FRAME:AddMessage(GT_Output.Localize("GT_Output", level, addon, GT_Output.Localize(addon, key, unpack(arg))), r, g, b)
	end,

	Emerg = function(str)
		DEFAULT_CHAT_FRAME:AddMessage("Recursion error in GT_Output: " .. str, 1.0, 0.5, 0.5)
	end,

	ShowLocale = function()
		DEFAULT_CHAT_FRAME:AddMessage("Current locale is \"" .. GetLocale() .. "\".", 0.5, 0.5, 1.0)
	end,

	AddString = function(addon, lang, key, value)
		if GT_Output.Strings[addon] == nil then
			GT_Output.Strings[addon] = {}
		end

		if GT_Output.Strings[addon][lang] == nil then
			GT_Output.Strings[addon][lang] = {}
		end

		if GT_Output.Strings[addon][lang][key] ~= nil then
			if addon == "GT_Output" then
				GT_Output.Emerg("Defined duplicate key \"" .. key .. "\" for addon \"GT_Output\".")
			else
				GT_Output.Warn("GT_Output", "DuplicateKey", key, addon)
			end
		end

		GT_Output.Strings[addon][lang][key] = value
	end,

	Localize = function(addon, key, ...)
		local locale

		if GT_Output.Strings[addon] == nil then
			if addon == "GT_Output" then
				GT_Output.Emerg("Could not find addon \"" .. addon .. "\".")
			else
				GT_Output.Error("GT_Output", "MissingAddon", addon)
			end

			return ""
		end

		if type(GT_Output_Config)          ~= "table"  then GT_Output_Config          = {}     end
		if type(GT_Output_Config.fallback) ~= "string" then GT_Output_Config.fallback = "enUS" end

		if GT_Output.Strings[addon][GetLocale()] ~= nil then
			locale = GetLocale()
		elseif GT_Output.Strings[addon][GT_Output_Config.fallback] ~= nil then
			locale = GT_Output_Config.fallback
		elseif GT_Output.Strings[addon]["enUS"] ~= nil then
			locale = "enUS"
		else
			if addon == "GT_Output" then
				GT_Output.Emerg("Could not find locale \"" .. GetLocale() .. "\" for addon \"" .. addon .. "\".  (Fallback locale \"" .. GT_Output_Config.fallback .. "\" also missing.)")
			else
				GT_Output.Error("GT_Output", "MissingLocale", GetLocale(), addon, GT_Output_Config.fallback)
			end

			return ""
		end

		if GT_Output.Strings[addon][locale][key] == nil then
			if addon == "GT_Output" then
				GT_Output.Emerg("Could not find key \"" .. key .. "\" for addon \"" .. addon .. "\".")
			else
				GT_Output.Error("GT_Output", "MissingKey", key, addon)
			end

			return ""
		end

		if not arg or arg.n == 0 then
			return GT_Output.Strings[addon][locale][key]
		end

		return string.format(GT_Output.Strings[addon][locale][key], unpack(arg))
	end,
}
