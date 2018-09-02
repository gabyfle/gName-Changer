--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
	string, string goodCaligraphy(string firstname, string lastname) : 
		Returns the character strings entered in parameter under a 
		good caligraphy (first letter in upper case, then in lower case)
---------------------------------------------------------------------------]]
function gNameChanger:goodCaligraphy(firstname, lastname)
	-- First, be sure that everything is lower-cased
	firstname, lastname = firstname:lower(), lastname:lower()
	-- Now uppercase only first letter
	firstname = firstname:gsub("%a", string.upper, 1)
	lastname = lastname:gsub("%a", string.upper, 1)

	return firstname, lastname
end

--[[-------------------------------------------------------------------------
	bool isBlacklisted(string firstname, string lastname) : 
		Returns false if string isn't blacklisted, true if
---------------------------------------------------------------------------]]
function gNameChanger:isBlacklisted(firstname, lastname)
	if not self.blacklist_active then return false end
	if not firstname or not lastname then return true end

	local blacklist = {}
	local _first, _last = string.lower(firstname), string.lower(lastname)

	for _string in string.gmatch(string.lower(self.blacklisted), "[^;]+") do
		blacklist[_string] = true
	end

	-- The string is blacklisted
	if blacklist[_first] or blacklist[_last] then
		return true
	end

	return false
end

--[[-------------------------------------------------------------------------
	bool canChange(Player ply, bool npc = true) : 
		Returns true if the user can change his RPName, false if not
---------------------------------------------------------------------------]]
function gNameChanger:canChange(ply, npc)
	if npc == nil then npc = true end

	-- Player is launching derma without using entity (or player is too far from entity)
	if npc == true then
		if not ply.usedNPC or not (ply.usedNPC:GetPos():DistToSqr(ply:GetPos()) < self.distance^2) then
			return false
		end
	end

	-- The countdown isn't finished
	if not ply.gNameLastNameChange then return true end
	local possible = ply.gNameLastNameChange + self.delay

	if CurTime() < possible then 
		DarkRP.notify(ply, 1, 6, self:LangMatch(self.Language.needWait))
		return false
	end

	return true
end

--[[-------------------------------------------------------------------------
	bool rpNameChange(number len, Player ply, bool first = false, bool npc = true) : 
		Changes the darkrp Name of a player given in arg
		return true if name was changed succesfully, false if not
---------------------------------------------------------------------------]]
function gNameChanger:rpNameChange(len, ply, first, npc)
	if first == nil then first = false end
	if npc == nil then npc = true end

	if not self:canChange(ply, npc) then return false end
	
	local firstname = net.ReadString()
	local lastname = net.ReadString()

	local canChangeName, reason = hook.Call("CanChangeRPName", GAMEMODE, ply, firstname .. " " .. lastname)
	if canChangeName == false then
		DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("unable", "RPname", reason or ""))
		return false
	end

	if self:isBlacklisted(firstname, lastname) then
		DarkRP.notify(ply, 1, 6, self.Language.nameBlacklist)
		return false
	end

	if self.caligraphy then
		firstname, lastname = self:goodCaligraphy(firstname, lastname)
	end

	local name = firstname .. " " .. lastname

	if first == true then
		local success = false
		DarkRP.retrieveRPNames(name, function(taken)
			if taken then
				DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("unable", "RPname", DarkRP.getPhrase("already_taken")))
				return false
			else
				DarkRP.storeRPName(ply, name)
				ply:setDarkRPVar("rpname", name)
				if gNameChanger.globalNotify then
					DarkRP.notifyAll(2, 6, DarkRP.getPhrase("rpname_changed", ply:SteamName(), name))
				end
				success = true
				return true
			end
		end)

		return success
	else
		if not ply:canAfford(self.price) then
			DarkRP.notify(ply, 1, 6, self:LangMatch(self.Language.needMoney))
			return false
		else
			DarkRP.retrieveRPNames(name, function(taken)
				if taken then
					DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("unable", "RPname", DarkRP.getPhrase("already_taken")))
					return false
				else
					ply:addMoney(-self.price)

					DarkRP.storeRPName(ply, name)
					ply:setDarkRPVar("rpname", name)
					if gNameChanger.globalNotify then
						DarkRP.notifyAll(2, 6, DarkRP.getPhrase("rpname_changed", ply:SteamName(), name))
					end
					return true
				end
			end)
		end
	end

	ply.gNameLastNameChange = CurTime()
end