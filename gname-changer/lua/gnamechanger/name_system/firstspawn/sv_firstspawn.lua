--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
util.AddNetworkString("gNameChanger:SPAWN:Panel")
util.AddNetworkString("gNameChanger:SPAWN:Name")

function gNameChanger:sendPanel(ply)
	net.Start("gNameChanger:SPAWN:Panel")
		--
	net.Send(ply)
end

function gNameChanger:checkName(len, ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not self.firstSpawn then return end
	if ply.gNameLastNameChange then return end -- Already used a name change

	local success = self:rpNameChange(len, ply, true, false)
	if not success then
		self:sendPanel(ply)
	end
end

net.Receive("gNameChanger:SPAWN:Name", function(len, ply)
	gNameChanger:checkName(len, ply)
end)

hook.Add("PlayerInitialSpawn", "gNameChanger:SPAWN:Hook", function(ply)
	if gNameChanger.firstSpawn then
		gNameChanger:sendPanel(ply)
	end
end)