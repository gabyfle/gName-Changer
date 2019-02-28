--[[---------------------------------------------------------------------------

                        gName-Changer | SHARED CODE
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
-- Server initialization code
if SERVER then
    -- Includes
    include("gnamechanger/sv_gnamechanger.lua")
    include("gnamechanger/sh_gnamechanger.lua")
    include("gnamechanger/admin/sv_admin_menu.lua")
    include("gnamechanger/name_system/sv_name_system.lua")
    include("gnamechanger/name_system/firstspawn/sv_firstspawn.lua")
    -- Client download files
    AddCSLuaFile("gnamechanger/sh_gnamechanger.lua")
    AddCSLuaFile("gnamechanger/cl_gnamechanger.lua")
    AddCSLuaFile("gnamechanger/admin/cl_admin_menu.lua")
    AddCSLuaFile("gnamechanger/name_system/cl_name_system.lua")
    AddCSLuaFile("gnamechanger/name_system/firstspawn/cl_firstspawn.lua")
end
-- Client initialization code
if CLIENT then
    include("gnamechanger/sh_gnamechanger.lua")
    include("gnamechanger/cl_gnamechanger.lua")
    include("gnamechanger/admin/cl_admin_menu.lua")
    include("gnamechanger/name_system/cl_name_system.lua")
    include("gnamechanger/name_system/firstspawn/cl_firstspawn.lua")
end

gNameChanger:Init()