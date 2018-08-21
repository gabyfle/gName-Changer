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
		net.Start("gName_NPC_Changer_panel")
			--net.WriteEntity(self)
		net.Send(caller)
	end
end

local function canChange(ply, npc)
	-- Player is launching derma without calling entity	
	--if not IsValid(npc) then return false
	--else
		--local distance = npc:GetPos():DistToSqr(ply:GetPos())

		--if distance < 900 then return false end
	--end

	-- The countdown isn't finished
	if not ply.gNameLastNameChange then return true end

	local possible = ply.gNameLastNameChange + gNameChanger.delay
	if CurTime() < possible then return false end

	return true
end

-- Player change RPNAME function
local function rpNameChange(len, ply)
	local npc = 1 --net.ReadEntity()

	if not canChange(ply, npc) then
		DarkRP.notify(ply, 1, 15, "Vous devez attendre " .. gNameChanger.delay .. " secondes entre chaque changements de nom.")
		return
	end
	
	local name = net.ReadString()

	if not ply:canAfford(gNameChanger.price) then
		DarkRP.notify(ply, 1, 15, "Désolé ! Vous n'avez pas assez d'argent pour changer votre nom !")
		return
	else		
		DarkRP.retrieveRPNames(name, function(taken)
			if taken then
				DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("unable", "RPname", DarkRP.getPhrase("already_taken")))
			else
				ply:addMoney(-gNameChanger.price)

				DarkRP.storeRPName(ply, name)
				ply:setDarkRPVar("rpname", name)
				DarkRP.notifyAll(2, 6, DarkRP.getPhrase("rpname_changed", ply:SteamName(), name))
			end
		end)
	end

	ply.gNameLastNameChange = CurTime()
end

net.Receive("gName_NPC_Changer_name", rpNameChange)