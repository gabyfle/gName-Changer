--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
function gNameChanger:CheckData()
	-- Checking if data folder of rpname exist
	if not file.Exists("gabyfle-rpname", "DATA") then
		file.CreateDir("gabyfle-rpname") -- Create it if not
	end
	-- Now checking if npc_rpname_pos.txt (file with all NPCs pos) exists
	if not file.Exists("gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt", "DATA") then
		file.Write("gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt", "") -- Create it if not
	end
end

function gNameChanger:Load()
	local data = file.Read("gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt")	
	local tb = util.JSONToTable(data)

	if not tb then return end -- If JSONToTable fails or if there isn't saved npcs

	-- Loading and spawning NPCs
	for _, v in pairs(tb) do
		local ent = ents.Create("npc_rpname")
		if (!IsValid(ent)) then 
			print("ERROR WHILE CREATING ENTITIES -- ABANDON")
			return
		end
		ent:SetPos(v.pos)
		ent:SetAngles(v.angle)
		ent:SetModel(gNameChanger.model)
		ent:Spawn()
	end
end

function gNameChanger:Save(ply, cmd, args)
	-- Checking if player has the apropriate rank
	if not table.HasValue(gNameChanger.canUseCommands, ply:GetUserGroup()) then
		DarkRP.notify(ply, 1, 15, "Désolé ! Vous n'avez pas l'autorisation nécessaire pour utiliser cette commande.")

		return
	end

	local entities = ents.FindByClass("npc_rpname") -- All npc_rpname entities

	-- If there isn't any npc_rpname entity
	local number = table.Count(entities)
	if number == 0 then
		DarkRP.notify(ply, 1, 15, "Il n'y a aucune entité à sauvegarder.")

		return
	end
	
	local data = {}
	-- Writing all npc_rpname positions to data table, and then convert into JSON to write it in data file
	for k, v in pairs(entities) do
		data[k] = { pos = v:GetPos(), angle = v:GetAngles() }
	end
	-- Write JSON converted table to data file
	file.Write("gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt", util.TableToJSON(data))

	DarkRP.notify(ply, 3, 15, "Tous les NPCs ont étés sauvegardés dans data/gabyfle-rpname/npc_rpname_pos_" .. game.GetMap() .. ".txt")
end