--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
util.AddNetworkString("gNameChanger:SPAWN:Panel")
util.AddNetworkString("gNameChanger:SPAWN:Name")

--[[-------------------------------------------------------------------------
	void alreadyChanged(Player ply) : 
		Loads the first name change system
---------------------------------------------------------------------------]]
function gNameChanger:alreadyChanged(ply)
	local filename = "gabyfle-rpname/players_name.txt"
	local steamid = ply:SteamID()
	local pattern = "[^;]+"

	local data = file.Read(filename) -- Getting SteamIDs lists

	for id in string.gmatch(data, pattern) do
		if steamid == id then
			return true
		end
	end


	file.Append(filename, steamid .. ";") -- Writing the new player in the file
	return false
end

--[[-------------------------------------------------------------------------
	void firstSpawnSendPanel(Player ply) : 
		Send the net : gNameChanger:SPAWN:Panel to the player
---------------------------------------------------------------------------]]
function gNameChanger:firstSpawnSendPanel(ply)
	net.Start("gNameChanger:SPAWN:Panel")
		--
	net.Send(ply)
end

--[[-------------------------------------------------------------------------
	void firstSpawnCheck(len, Player ply) : 
		Check if the player succeeded to change his name
---------------------------------------------------------------------------]]
function gNameChanger:firstSpawnCheck(len, ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not ply.gNameChangerForce then
		if not self.firstSpawn then return end
		if ply.gNameLastNameChange then return end -- Already used a name change
	end

	local success = self:rpNameChange(len, ply, true, false)
	if not success then
		self:firstSpawnSendPanel(ply)
	else
		if ply.gNameChangerForce then ply.gNameChangerForce = false	end
	end	
end

net.Receive("gNameChanger:SPAWN:Name", function(len, ply)
	gNameChanger:firstSpawnCheck(len, ply)
end)

hook.Add("PlayerInitialSpawn", "gNameChanger:SPAWN:Hook", function(ply)
	if gNameChanger.firstSpawn and not gNameChanger:alreadyChanged(ply) then
		gNameChanger:firstSpawnSendPanel(ply)
	end
end)