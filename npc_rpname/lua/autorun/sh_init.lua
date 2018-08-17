--[[---------------------------------------------------------------------------

				        gName-Changer | SHARED CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
-- Server initialization code
if SERVER then
	include("rpname/server/sv_rpname.lua")
	include("rpname/shared/sh_rpname.lua")
	AddCSLuaFile("rpname/shared/sh_rpname.lua")
end

-- Client initialization code
if CLIENT then
	include("rpname/shared/sh_rpname.lua")
end

gNameChanger:Init()