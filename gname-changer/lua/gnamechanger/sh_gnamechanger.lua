--[[---------------------------------------------------------------------------

				        gName-Changer | SHARED CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
	void Init(void) : 
		Initialize the addon with language files, launch Load() func, remove darkrp name commands
		and add Console commands
---------------------------------------------------------------------------]]
function gNameChanger:Init()
	local default = nil
	if SERVER then
		-- Loading language file
		if not file.Exists("gnamechanger/lang/" .. self.lang .. ".lua", "LUA") then
			-- Default language is English
			include("gnamechanger/lang/en.lua")
			AddCSLuaFile("gnamechanger/lang/en.lua")

			default = 1
		else
			include("gnamechanger/lang/" .. self.lang .. ".lua")
			AddCSLuaFile("gnamechanger/lang/" .. self.lang .. ".lua")
		end
	end
	if CLIENT then -- Including language file on clientside
		if not default then
			include("gnamechanger/lang/" .. self.lang .. ".lua")
		else
			include("gnamechanger/lang/en.lua")
		end
	end
	if SERVER then
		-- Loading entities & stuff
		hook.Add("InitPostEntity", "gNameChanger:loadingServerSide", function()
			self:Load()
		end)
		-- Remove name command
		hook.Add("PostGamemodeLoaded", "gNameChanger:removeChatCommand", function()
			-- Modifying some DarkRP commands
			DarkRP.removeChatCommand("rpname") -- Deactivate /rpname
			DarkRP.removeChatCommand("name") -- Deactivate /name
		end)
		
		print(" *=======================* ")
		print("|   RPName Changer Addon  |")
		print("|===-->  Eat broccoli     |")
		print("|   Created by Gabyfle    |")
		print(" *=======================* ")
	end
	-- Save NPCs command
	concommand.Add(self.saveCommand, function(ply, cmd, args)
		if SERVER then
			self:Save(ply)
		end
	end)
	-- Admin menu command
	concommand.Add(self.adminMenu, function(ply, cmd, args)
		if SERVER then
			self:AdminPanel(ply)
		end
	end)
	-- Admin force name change command
	concommand.Add(self.adminForce, function(ply, cmd, args)
		if SERVER then
			self:AdminForce(ply, args)
		end
	end)
end

--[[-------------------------------------------------------------------------
	string LangMatch(string stringLang) :
		Return a readable language string
		[change languages vars (e.g {{path}}) to readable vars]
---------------------------------------------------------------------------]]
function gNameChanger:LangMatch(stringLang)
	-- Used vars
	local path = "gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt"
	
	local vars = {
		["delay"] = self.delay,
		["path"] = path,
		["key_use"] = IN_USE,
		["price"] = self.price,
		["device"] = self.device
	}
	if CLIENT then
		ply = LocalPlayer()
		vars["plyname"] = ply:Nick()
	end
	
	local pattern = "{{(.-)}}"

	return string.gsub(stringLang, pattern, vars)
end