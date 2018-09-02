--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
util.AddNetworkString("gNameChanger:SPAWN:Panel")
util.AddNetworkString("gNameChanger:SPAWN:Name")

function gNameChanger:firstSpawnSendPanel(ply)
	net.Start("gNameChanger:SPAWN:Panel")
		--
	net.Send(ply)
end

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
	if gNameChanger.firstSpawn then
		gNameChanger:firstSpawnSendPanel(ply)
	end
end)