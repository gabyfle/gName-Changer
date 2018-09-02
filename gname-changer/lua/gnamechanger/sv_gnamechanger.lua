--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
local path = "gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt"

--[[-------------------------------------------------------------------------
	table<string> getArgs(string command) : 
		Helper function
		Returns the arguments of a given command in a table
---------------------------------------------------------------------------]]
function gNameChanger:getArgs(text)
	local arguments = string.Split(text, " ")
	-- Removing the command string
	table.remove(arguments, 1)

	return arguments
end
--[[-------------------------------------------------------------------------
	bool getRights(Player ply) : 
		Returns false if the user does not have administration rights, true if he has them.
---------------------------------------------------------------------------]]
function gNameChanger:getRights(ply)
	-- Checking if player has the apropriate rank
	if not self.canUseCommands[ply:GetUserGroup()] then
		DarkRP.notify(ply, 1, 15, self:LangMatch(self.Language.needRight))
		return false
	end

	return true
end

--[[-------------------------------------------------------------------------
	void BlacklistLoad(void) : 
		Loads the blacklist.txt file and setup Blacklist vars
---------------------------------------------------------------------------]]
function gNameChanger:BlacklistLoad()
	local blacklist = "gabyfle-rpname/blacklist.txt"

	local data = file.Read(blacklist)	
	local tb = util.JSONToTable(data)

	if not tb then
		self.blacklisted = ""
		self.blacklist_active = false
		return
	end

	self.blacklisted = tb.names
	self.blacklist_active = tb.active
end

--[[-------------------------------------------------------------------------
	void Load(void) : 
		Create data folder, data files, and load entities pos data files.
---------------------------------------------------------------------------]]
function gNameChanger:Load()
	-- Checking if data folder of rpname exist
	if not file.IsDir("gabyfle-rpname", "DATA") then
		file.CreateDir("gabyfle-rpname") -- Create it if not
	end
	-- Now checking if npc_rpname_pos.txt (file with all NPCs pos) exists
	if not file.Exists(path, "DATA") then
		file.Write(path, "") -- Create it if not
	end
	-- Checking if blacklist.txt exists
	if not file.Exists("gabyfle-rpname/blacklist.txt", "DATA") then
		file.Write("gabyfle-rpname/blacklist.txt", "{\"names\":\"\",\"active\":false}") -- Create it if not
	end

	-- Loading blacklist configuration
	self:BlacklistLoad()

	-- Loading entities
	local data = file.Read(path)	
	local tb = util.JSONToTable(data)

	if not tb then return end -- If JSONToTable fails or if there isn't saved npcs

	-- Loading and spawning NPCs
	for _, v in pairs(tb) do
		local ent = ents.Create("npc_gname_changer")

		ent:SetPos(v.pos)
		ent:SetAngles(v.angle)
		ent:Spawn()
	end
end

--[[-------------------------------------------------------------------------
	void Load(Player ply) : 
		Save the current NPCs locations to npc_pos_map data file.
---------------------------------------------------------------------------]]
function gNameChanger:Save(ply)
	if not self:getRights(ply) then return end

	local entities = ents.FindByClass("npc_gname_changer") -- All npc_gname_changer entities

	-- If there isn't any npc_gname_changer entity
	local number = #entities
	if number == 0 then
		DarkRP.notify(ply, 1, 15, self:LangMatch(self.Language.noEnts))

		return
	end
	
	local data = {}
	-- Writing all npc_gname_changer positions to data table, and then convert into JSON to write it in data file
	for k, v in pairs(entities) do
		data[k] = { pos = v:GetPos(), angle = v:GetAngles() }
	end
	-- Write JSON converted table to data file
	file.Write(path, util.TableToJSON(data))

	DarkRP.notify(ply, 3, 15, self:LangMatch(self.Language.entsSaved))
end