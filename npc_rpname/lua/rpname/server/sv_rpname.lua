--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
function gNameChanger:CheckData()
	-- Checking if data folder of rpname exist
	if not file.Exists("gabyfle-rpname.txt", "DATA") then
		file.CreateDir("gabyfle-rpname.txt") -- Create it if not
	end
end

function gNameChanger:Save(ply, cmd, args)
	print("Still in work")
end