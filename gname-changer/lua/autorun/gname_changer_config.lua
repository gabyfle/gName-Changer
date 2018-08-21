--[[---------------------------------------------------------------------------

                        gName-Changer | CONFIGURATION
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]

gNameChanger = gNameChanger or {}

----------------------------
--[[ NPC General Settings ]]--
----------------------------

-- Permission to access to the command
gNameChanger.canUseCommands = {
    "superadmin",
    "admin",
    "user"
}
-- The command to save 
gNameChanger.saveCommand = "gname_save_all" -- WARNING : using same command has an other addon may causes conflicts


----------------------------
--[[ NPC Theme Settings ]]--
----------------------------

-- Model of the NPC
gNameChanger.model = "models/gman.mdl" -- Default GMAN model
-- Derma color
gNameChanger.dermaColor = Color(29, 53, 87) -- Got a color in hexagonal form? http://www.color-hex.com
-- 3D2D CAM Color
gNameChanger.camColor = Color(29, 53, 87, 230) -- Got a color in hexagonal form? http://www.color-hex.com

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
-- The price players will pay to change their name
gNameChanger.price = 1000
-- Minimum delay between two name change (in seconds)
gNameChanger.delay = 120 -- Obviously, 0 cancels the delay
-- Maximum distance to access to the NPC (in units)
gNameChanger.distance = 300