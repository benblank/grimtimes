function hasKey(haystack, needle)
	table.foreach(haystack, function(key, value)
		if key == needle then return true end
	end)
	return false
end

function hasKeyI(haystack, needle)
	table.foreachi(haystack, function(key, value)
		if key == needle then return true end
	end)
	return false
end

function hasVal(haystack, needle)
	table.foreach(haystack, function(key, value)
		if value == needle then return true end
	end)
	return false
end

function hasValI(haystack, needle)
	table.foreachi(haystack, function(key, value)
		if value == needle then return true end
	end)
	return false
end

function isBuffed(unit, buff)
	return GT_MacroKit.CheckUnitBuffs(UnitBuff, unit, buff)
end

function isDebuffed(unit, debuff)
	return GT_MacroKit.CheckUnitBuffs(UnitDebuff, unit, debuff)
end

function isReady(name)
end

function tri(test, onTrue, onFalse)
	if test then return onTrue end
	return onFalse
end

GT_MacroKit = {
	SpellIndexes = {},

	CheckUnitBuffs = function(func, unit, name)
		local texture
		local dummy
		local i = 1

		while i < 17 do
			texture, dummy, dummy = func(unit, i)

			if nil == texture then
				return false
			end

			if string.find(texture, name) then
				return true
			end

			i = i + 1
		end

		return false
	end,

	DumpBuffs = function(unit)
		local i

		for i = 1, MAX_TARGET_BUFFS do
			if UnitBuff(unit, i) then
				GT_MacroKit_Tip:ClearLines()
				GT_MacroKit_Tip:SetUnitBuff(unit, i)
				GT_Output.Emerg(GT_MacroKit_TipTextLeft1:GetText())
			end
		end

		for i = 1, MAX_TARGET_DEBUFFS do
			if UnitDebuff(unit, i) then
				GT_MacroKit_Tip:ClearLines()
				GT_MacroKit_Tip:SetUnitDebuff(unit, i)
				GT_Output.Emerg(GT_MacroKit_TipTextLeft1:GetText())
			end
		end
	end,

	DumpBook = function()
		for k, v in pairs(GT_MacroKit.SpellIndexes) do
			if type(v) == "table" then
				for l, w in pairs(v) do
					GT_Output.Emerg("\"" .. k .. "(" .. l .. ")\": " .. w)
				end
			else
				GT_Output.Emerg("\"" .. k .. "\": " .. v)
			end
		end
	end,

	ReadBook = function()
		local name
		local rank
		local i = 0

		while true do
			i = i + 1
			name, rank = GetSpellName(i, BOOKTYPE_SPELL)
			if not name then break end

			if not rank or rank == "" then
				GT_MacroKit.SpellIndexes[name] = i
			else
				if not GT_MacroKit.SpellIndexes[name] then
					GT_MacroKit.SpellIndexes[name] = {}
				end
				GT_MacroKit.SpellIndexes[name][rank] = i
			end
		end
	end,
}

GT_Event.AddEvent("GT_MacroKit", "PLAYER_LOGIN", GT_MacroKit.ReadBook)
