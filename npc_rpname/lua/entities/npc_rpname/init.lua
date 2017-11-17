--[[
	HandMade by Gaby

	RPName changer

	This addon require DarkRP to work well.
]]--
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("gName_Changer_panel")
util.AddNetworkString("gName_Changer_name")
-- Adding the custom font, named Monserrat Medium
resource.AddFile("resource/fonts/monserrat-medium.ttf")
-- Adding a second custom font, named Roboto Light
resource.AddFile("resource/fonts/roboto-light.ttf")

function ENT:SpawnFunction(ply, tr, ClassName) -- The spawnning informations for the ENT
	if !tr.Hit then
		return ""
	end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local ent = ents.Create(ClassName)
		ent:SetPos(SpawnPos)
		ent:SetUseType(SIMPLE_USE)
		ent:Spawn()
		ent:Activate()
	return ent
end
--[[
	THE USE FUNCTION
]]--
function ENT:Use(act, ply)
	if IsValid(ply) and ply:IsPlayer() then -- Check if it's a valid player and if it's a player.
		net.Start("gName_Changer_panel")
		net.Send(ply)
	end
end

--[[
	CHANGE RPNAME FUNCTION
]]--
net.Receive("gName_Changer_name", function(len, ply)
	local complete_name = net.ReadString()
	if ply:canAfford(gNameChanger.price) then
		DarkRP.notify(ply, 2, 15, "Désolé ! Vous n'avez pas assez d'argent pour changer votre nom !")
	else
		DarkRP.retrieveRPNames(complete_name, function(taken)
			if taken then
				DarkRP.notify(ply, 1, 5, "Ce nom est déjà pris ! Désolé !")
			else
				ply:addMoney(-gNameChanger.price)
				ply:setRPName(complete_name, false)
			end
		end)
	end
end)