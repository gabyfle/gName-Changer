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
    if not self:getRights(ply) then return end

    local tb = {
        active = self.blacklist_active,
        names = self.blacklisted
    }

    net.Start("gNameChanger:Admin:Panel")
        net.WriteTable(tb)
    net.Send(ply)
end

--[[-------------------------------------------------------------------------
    void AdminForce(Player ply, table<string> steamid) : 
        Force a player to change his rp name
---------------------------------------------------------------------------]]
function gNameChanger:AdminForce(ply, steamid)
    if not self:getRights(ply) then return end
    if #steamid > 1 or steamid[1] == nil then
        ply:ChatPrint("Usage : !<command> <steamid>")
        DarkRP.notify(ply, 1, 15, "Bad usage of the command.")
        return
    end

    target = player.GetBySteamID(steamid[1])

    if not target then
        DarkRP.notify(ply, 1, 15, "There isn't any player with the SteamID : " .. steamid[1] .. ".")
        return      
    end

    target.gNameChangerForce = true
    target:ChatPrint("An administrator forced you to change your RPName.")

    self:firstSpawnSendPanel(target)
end
--[[-------------------------------------------------------------------------
    string AdminChat(Player ply, string text) : 
        Return empty string
        [If player get rights, launch the right function]
---------------------------------------------------------------------------]]
function gNameChanger:AdminChat(ply, text)
    if (string.find(text, "!" .. self.adminMenu)) then
        if not self:getRights(ply) then return "" end

        self:AdminPanel(ply)

        return ""
    elseif (string.find(text, "!" .. self.adminForce)) then
        if not self:getRights(ply) then return "" end

        local steamid = self:getArgs(text)
        self:AdminForce(ply, steamid)

        return ""
    end
end

--[[-------------------------------------------------------------------------
    void AdminSave(Player ply) : 
        Save the new configuration to blacklist.txt
        Load the new configuration
---------------------------------------------------------------------------]]
function gNameChanger:AdminSave(ply)
    if not self:getRights(ply) then return end

    local config = { }
        config.active = net.ReadBool()
        config.names = net.ReadString()

    file.Write("gabyfle-rpname/blacklist.txt", util.TableToJSON(config))

    -- Loading new configuration
    self:BlacklistLoad()

    DarkRP.notify(ply, 3, 15, self.Language.configSaved)
end

hook.Add("PlayerSay", "gNameChanger:Admin:Menu", function(ply, text, team)
    text = gNameChanger:AdminChat(ply, text)

    return text
end)

net.Receive("gNameChanger:Admin:Save", function(len, ply)
    gNameChanger:AdminSave(ply)
end)