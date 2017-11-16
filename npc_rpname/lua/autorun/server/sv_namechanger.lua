--[[
	HandMade by Gaby
	Copyright - EnragedGamers - 2017

	RPName changer

	This addon require DarkRP to work well.
]]--
--[[
	Remove name command
]]--

hook.Add("PostGamemodeLoaded", "RPName:removeChatCommand", function()
	-- Modifying some DarkRP commands
	DarkRP.removeChatCommand("rpname") -- Deactivate /rpname
	DarkRP.removeChatCommand("name") -- Deactivate /name
end)
