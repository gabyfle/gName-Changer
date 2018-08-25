--[[---------------------------------------------------------------------------
				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby
-----------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("gNameChanger:NPC:Panel")
util.AddNetworkString("gNameChanger:NPC:Name")
-- Adding the custom font, named Monserrat Medium
resource.AddFile("resource/fonts/monserrat-medium.ttf")
-- Adding a second custom font, named Roboto Light
resource.AddFile("resource/fonts/roboto-light.ttf")

-- When entity spawn
function ENT:SpawnFunction(ply, tr, ClassName) -- The spawnning informations for the ENT
	if not tr.Hit then return "" end

	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
		ent:SetPos(SpawnPos)
		ent:SetUseType(SIMPLE_USE)
		ent:Spawn()
		ent:Activate()
	return ent
end

-- When player use the "USE" button on NPC
function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(caller) and caller:IsPlayer() then
		caller.usedNPC = self
		net.Start("gNameChanger:NPC:Panel")
			-- Nothing to write there
		net.Send(caller)
	end
end

net.Receive("gNameChanger:NPC:Name", function(len,ply) 
	gNameChanger:rpNameChange(len, ply)
end)