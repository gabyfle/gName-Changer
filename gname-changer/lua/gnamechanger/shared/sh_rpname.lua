--[[---------------------------------------------------------------------------

				        gName-Changer | SHARED CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]

function gNameChanger:Init()
	if SERVER then
		-- Loading entities & stuff
		hook.Add("InitPostEntity", "RPName:loadingServerSide", function()
			self:Load()
		end)
		-- Remove name command
		hook.Add("PostGamemodeLoaded", "RPName:removeChatCommand", function()
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

	concommand.Add(gNameChanger.saveCommand, function(ply, cmd, args)
		if SERVER then
			self:Save(ply, cmd, args)
		end
	end)
end
