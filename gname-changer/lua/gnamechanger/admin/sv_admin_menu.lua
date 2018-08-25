--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
util.AddNetworkString("gNameChanger:Admin:Panel")
util.AddNetworkString("gNameChanger:Admin:Save")


--[[-------------------------------------------------------------------------
	void AdminPanel(Player ply) : 
		Send configuration table to the client
---------------------------------------------------------------------------]]
function gNameChanger:AdminPanel(ply)
	if not gNameChanger:getRights(ply) then return end

	local tb = {
		active = gNameChanger.blacklist_active,
		names = gNameChanger.blacklisted
	}

	net.Start("gNameChanger:Admin:Panel")
		net.WriteTable(tb)
	net.Send(ply)
end

--[[-------------------------------------------------------------------------
	string AdminChat(Player ply, string text) : 
		Return empty string
		[If player get rights, launch AdminPanel() func]
---------------------------------------------------------------------------]]
function gNameChanger:AdminChat(ply, text)
	if (string.lower(text) == "!" .. gNameChanger.adminMenu) then
		if not gNameChanger:getRights(ply) then return "" end

		self:AdminPanel(ply)

		return ""
	end
end

--[[-------------------------------------------------------------------------
	void AdminSave(Player ply) : 
		Save the new configuration to blacklist.txt
		Load the new configuration
---------------------------------------------------------------------------]]
function gNameChanger:AdminSave(ply)
	if not gNameChanger:getRights(ply) then return end

	local config = { }
		config.active = net.ReadBool()
		config.names = net.ReadString()

	file.Write("gabyfle-rpname/blacklist.txt", util.TableToJSON(config))

	-- Loading new configuration
	self:BlacklistLoad()

	DarkRP.notify(ply, 3, 15, gNameChanger.Language.configSaved)
end

hook.Add("PlayerSay", "gNameChanger:AdminMenu", function(ply, text, team)
	text = gNameChanger:AdminChat(ply, text)

	return text
end)

net.Receive("gNameChanger:Admin:Save", function(len, ply)
	gNameChanger:AdminSave(ply)
end)