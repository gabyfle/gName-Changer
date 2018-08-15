--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("gName_NPC_Changer_panel")
util.AddNetworkString("gName_NPC_Changer_name")
-- Adding the custom font, named Monserrat Medium
resource.AddFile("resource/fonts/monserrat-medium.ttf")
-- Adding a second custom font, named Roboto Light
resource.AddFile("resource/fonts/roboto-light.ttf")

-- When entity spawn
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

-- When player use the "USE" button on NPC
function ENT:AcceptInput(inputName, activator, caller, data)
	if inputName == "Use" and IsValid(caller) and caller:IsPlayer() then
		net.Start("gName_NPC_Changer_panel")
		net.Send(caller)
	end
end

local function canChange(ply)
	if ply.gNameLastNameChange == nil then return true end

	local possible = ply.gNameLastNameChange + gNameChanger.delay

	if CurTime() > possible then
		return false
	end

	return true
end

-- Player change RPNAME function
local function rpNameChange(len, ply)
	local complete_name = net.ReadString()

	if canChange(ply) then
		DarkRP.notify(ply, 1, 15, "Vous devez attendre " .. gNameChanger.delay .. " secondes entre chaque changements de nom.")

		return
	end

	if !ply:canAfford(gNameChanger.price) then
		DarkRP.notify(ply, 1, 15, "Désolé ! Vous n'avez pas assez d'argent pour changer votre nom !")
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

	ply.gNameLastNameChange = CurTime()

	-- Re-open the frame
	net.Start("gName_NPC_Changer_panel")
	net.Send(ply)

end

net.Receive("gName_NPC_Changer_name", rpNameChange)