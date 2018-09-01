--[[---------------------------------------------------------------------------

                        gName-Changer | CONFIGURATION
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]

gNameChanger = gNameChanger or {}

--------------------------]]--
--[[ General Informations ]]--
--[[--------------------------

	--[ About License ]--

This addon  has  been  released  totally  for  free,  for  DarkRP  servers  owners.
In  case  of any  reuse,  reloading of  the source code  of  this addon,  I  kindly
ask you to  credit  me,  as  specified  in  the  license  under  which  this  addon
is distributed (see: https://github.com/Gabyfle/gName-Changer/blob/master/LICENSE).

	--[ Commiting an Issue ]--

If you find a bug or an  exploit while  using gNameChanger, please let us  know  at
https://github.com/Gabyfle/gName-Changer/issues, we will be very happy to help you.

--------------------------
--[[ General Settings ]]--
--------------------------
-- Your community name
gNameChanger.communityName = "Gabyfle's Addons"
-- Comminity name font familly
gNameChanger.communityFont = "viksi-script" -- WARNING : To change that, you have to install a custom font on your server
-- Your community description
gNameChanger.communityDesc = "Welcome to our biggest DarkRP server. Have fun and enjoy playing!"

-- Permission to access to the command
gNameChanger.canUseCommands = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["user"] = true
}
-- The command to save NPCs
gNameChanger.saveCommand = "gname_save_all" -- WARNING : using same command has an other addon may causes conflicts
-- The command to open admin menu
gNameChanger.adminMenu = "gname_admin" -- WARNING : using same command has an other addon may causes conflicts

-- Language setting
gNameChanger.lang = "en" -- Available languages : "fr", "en", "ru"
-- Device
gNameChanger.device = "$"

-- Force good caligraphy
gNameChanger.caligraphy = true -- If true, names like géRaRD, gérard or GérArD will be changed to Gérard

--------------------------------
--[[ Windows Theme Settings ]]--
--------------------------------
	--[[ GUI ]]--
-- Main colors (brackground)
gNameChanger.dermaColor = Color(29, 53, 87) -- Got a color in hexagonal form? http://www.color-hex.com
-- Font color
gNameChanger.dermaFontColor = Color(241, 250, 238) -- Got a color in hexagonal form? http://www.color-hex.com
	--[[ 3D2D ]]--
-- 3D2D CAM Background color
gNameChanger.camColor = Color(29, 53, 87, 230) -- Got a color in hexagonal form? http://www.color-hex.com
-- Font color
gNameChanger.camFontColor = Color(241, 250, 238) -- Got a color in hexagonal form? http://www.color-hex.com

---------------------------
--[[ SOME FUNNY COLORS ]]--
--[[    CYAN #40A497   ]]--
--[[    PINK #FF358B   ]]--
--[[   PURPLE #551A8B  ]]--
--[[    RED #FF030D    ]]--
---------------------------

----------------------
--[[ NPC Settings ]]--
----------------------
-- Model of the NPC
gNameChanger.model = "models/gman.mdl" -- Default GMAN model
-- The price players will pay to change their name
gNameChanger.price = 1000
-- Minimum delay between two name change (in seconds)
gNameChanger.delay = 120 -- Obviously, 0 cancels the delay
-- Maximum distance to access to the NPC (in units)
gNameChanger.distance = 300