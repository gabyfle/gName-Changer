--[[---------------------------------------------------------------------------

				        gName-Changer | SHARED CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
-- Server initialization code
if SERVER then
	include("gnamechanger/server/sv_rpname.lua")
	include("gnamechanger/shared/sh_rpname.lua")
	AddCSLuaFile("gnamechanger/shared/sh_rpname.lua")
	AddCSLuaFile("gnamechanger/client/cl_rpname.lua")
end

-- Client initialization code
if CLIENT then
	include("gnamechanger/shared/sh_rpname.lua")
	include("gnamechanger/client/cl_rpname.lua")
end

gNameChanger:Init()