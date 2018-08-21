--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
local path = "gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt"

function gNameChanger:Load()
	-- Checking if data folder of rpname exist
	if not file.IsDir("gabyfle-rpname", "DATA") then
		file.CreateDir("gabyfle-rpname") -- Create it if not
	end
	-- Now checking if npc_rpname_pos.txt (file with all NPCs pos) exists
	if not file.Exists(path, "DATA") then
		file.Write(path, "") -- Create it if not
	end

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

function gNameChanger:Save(ply, cmd, args)
	-- Checking if player has the apropriate rank
	if not gNameChanger.canUseCommands[ply:GetUserGroup()] then
		DarkRP.notify(ply, 1, 15, "Désolé ! Vous n'avez pas l'autorisation nécessaire pour utiliser cette commande.")

		return
	end

	local entities = ents.FindByClass("npc_gname_changer") -- All npc_gname_changer entities

	-- If there isn't any npc_gname_changer entity
	local number = #entities
	if number == 0 then
		DarkRP.notify(ply, 1, 15, "Il n'y a aucune entité à sauvegarder.")

		return
	end
	
	local data = {}
	-- Writing all npc_gname_changer positions to data table, and then convert into JSON to write it in data file
	for k, v in pairs(entities) do
		data[k] = { pos = v:GetPos(), angle = v:GetAngles() }
	end
	-- Write JSON converted table to data file
	file.Write(path, util.TableToJSON(data))

	DarkRP.notify(ply, 3, 15, "Tous les NPCs ont étés sauvegardés dans data/" .. path .. "")
end