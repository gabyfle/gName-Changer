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

    return false
end

--[[-------------------------------------------------------------------------
    void forceNameSendPanel(Player ply) : 
        Send the net : gNameChanger:SPAWN:Panel to the player
---------------------------------------------------------------------------]]
function gNameChanger:forceNameSendPanel(ply)
    net.Start("gNameChanger:SPAWN:Panel")

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
        if ply.gNameLastNameChange then return end
    end

    local success = self:rpNameChange(len, ply, true, false)
    if not success then
        self:forceNameSendPanel(ply)
    else
        if ply.gNameChangerForce then ply.gNameChangerForce = false return end
        if ply.gNameLastNameChange then file.Append("gabyfle-rpname/players_name.txt", ply:SteamID() .. ";") end
    end
end
--[[-------------------------------------------------------------------------
    bool isAttackerPlayer(Player attacker) : 
        true   | if the player is dead because of another player
        false  | if not
---------------------------------------------------------------------------]]
function gNameChanger:isAttackerPlayer(attacker)
    return IsValid(attacker) and attacker:IsPlayer()
end

--[[-------------------------------------------------------------------------
    void onDeathCheck(Player victim, Entity inflictor, Player attacker) : 
        Check if the player is dead because of another player, if yes, launch gNameChanger:forceNameSendPanel
---------------------------------------------------------------------------]]
function gNameChanger:onDeathCheck(victim, _, attacker)
    if not gNameChanger.reSpawn then return end
    if not IsValid(victim) and victim:IsPlayer() then return end

    if self:isAttackerPlayer(attacker) then
        self:forceNameSendPanel(victim)
    end
end

net.Receive("gNameChanger:SPAWN:Name", function(len, ply)
    gNameChanger:firstSpawnCheck(len, ply)
end)

hook.Add("PlayerInitialSpawn", "gNameChanger:SPAWN:Hook", function(ply)
    if gNameChanger.firstSpawn and not gNameChanger:alreadyChanged(ply) then
        gNameChanger:forceNameSendPanel(ply)
    end
end)

hook.Add("PlayerDeath", "gNameChanger:DEATH:Hook", function(victim, inflictor, attacker)
    gNameChanger:onDeathCheck(victim, inflictor, attacker)
end)