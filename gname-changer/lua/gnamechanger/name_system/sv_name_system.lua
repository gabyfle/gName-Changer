--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]

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
	bool canChange(Player ply) : 
		Returns true if the user can change his RPName, false if not
---------------------------------------------------------------------------]]
function gNameChanger:canChange(ply)
	-- Player is launching derma without using entity (or player is too far from entity)
	if not ply.usedNPC or not (ply.usedNPC:GetPos():DistToSqr(ply:GetPos()) < self.distance^2) then
		return false
	end

	-- The countdown isn't finished
	if not ply.gNameLastNameChange then return true end
	local possible = ply.gNameLastNameChange + self.delay
	if CurTime() < possible then 
		DarkRP.notify(ply, 1, 15, self:LangMatch(self.Language.needWait))
		return false
	end

	return true
end

--[[-------------------------------------------------------------------------
	void rpNameChange(number len, Player ply) : 
		Changes the darkrp Name of a player given in arg
---------------------------------------------------------------------------]]
function gNameChanger:rpNameChange(len, ply)
	if not self:canChange(ply) then
		return
	end
	
	local firstname = net.ReadString()
	local lastname = net.ReadString()

	if self:isBlacklisted(firstname, lastname) then
		DarkRP.notify(ply, 1, 15, self.Language.nameBlacklist)
		return
	end

	local name = firstname .. " " .. lastname

	if not ply:canAfford(self.price) then
		DarkRP.notify(ply, 1, 15, self:LangMatch(self.Language.needMoney))
		return
	else		
		DarkRP.retrieveRPNames(name, function(taken)
			if taken then
				DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("unable", "RPname", DarkRP.getPhrase("already_taken")))
			else
				ply:addMoney(-self.price)

				DarkRP.storeRPName(ply, name)
				ply:setDarkRPVar("rpname", name)
				DarkRP.notifyAll(2, 6, DarkRP.getPhrase("rpname_changed", ply:SteamName(), name))
			end
		end)
	end

	ply.gNameLastNameChange = CurTime()
end