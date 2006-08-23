-- $LastChangedBy$
-- $LastChangedRevision$
-- $LastChangedDate$
-- $HeadURL$

realm = GetCVar("realmName");

GHT_Roster = {};
GHT_Roster[realm] = {};

function GHTR_OnLoad()
	this:RegisterEvent("GUILD_ROSTER_UPDATE");
end

function GHTR_OnEvent()
	this:UnregisterEvent("GUILD_ROSTER_UPDATE");

	if not IsInGuild() then
		this:RegisterEvent("GUILD_ROSTER_UPDATE");
		return;
	end

	local guild = GetGuildInfo("player");
	local dummy, char, rank, rindex, level, class, note, onote, online, year, month, day, hour;

	local offline = GetGuildRosterShowOffline();
	if offline ~= 1 then
		SetGuildRosterShowOffline(true);
	end

	local count = GetNumGuildMembers();

	if GHT_Roster[realm] == nil then GHT_Roster[realm] = {} end
	GHT_Roster[realm][guild] = {};
	GHT_Roster[realm][guild]['count'] = count;
	GHT_Roster[realm][guild]['timestamp'] = date("%Y-%m-%d-%H-%M-%S");

	for i = 1, count do
		char, rank, rindex, level, class, dummy, note, onote, online, dummy = GetGuildRosterInfo(i);

		GHT_Roster[realm][guild][i] = {};
		GHT_Roster[realm][guild][i]["Class"] = class;
		GHT_Roster[realm][guild][i]["Level"] = level; 
		GHT_Roster[realm][guild][i]["Name"] = char; 
		GHT_Roster[realm][guild][i]["Note"] = note;
		GHT_Roster[realm][guild][i]["OfficerNote"] = onote;
		GHT_Roster[realm][guild][i]["Rank"] = rank; 
		GHT_Roster[realm][guild][i]["RankIndex"] = rindex;

		if online == 1 then
			GHT_Roster[realm][guild][i]["LastOn"] = "0-0-0-0";
		else
			year, month, day, hour = GetGuildRosterLastOnline(i);
			GHT_Roster[realm][guild][i]["LastOn"] = year .. "-" .. month .. "-" .. day .. "-" .. hour;
		end
	end

	if offline ~= 1 then
		SetGuildRosterShowOffline(false);
	end

	--DEFAULT_CHAT_FRAME:AddMessage("Saved roster info for " .. count .. " guild members", 0.3, 0.3, 1);

	this:RegisterEvent("GUILD_ROSTER_UPDATE");
end
