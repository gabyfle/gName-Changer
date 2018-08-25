--[[---------------------------------------------------------------------------

				        gName-Changer | SERVER SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------
	bool canChange(Player ply) : 
		Returns true if the user can change his RPName, false if not
---------------------------------------------------------------------------]]
function gNameChanger:canChange(ply)
	-- Player is launching derma without using entity (or player is too far from entity)
	if not ply.usedNPC or not (ply.usedNPC:GetPos():DistToSqr(ply:GetPos()) < gNameChanger.distance^2) then
		return false
	end

	-- The countdown isn't finished
	if not ply.gNameLastNameChange then return true end
	local possible = ply.gNameLastNameChange + gNameChanger.delay
	if CurTime() < possible then 
		DarkRP.notify(ply, 1, 15, gNameChanger:LangMatch(gNameChanger.Language.needWait))
		return false
	end

	return true
end

--[[-------------------------------------------------------------------------
	void rpNameChange(number len, Player ply) : 
		Changes the darkrp Name of a player given in arg
---------------------------------------------------------------------------]]
function gNameChanger:rpNameChange(len, ply)
	if not gNameChanger:canChange(ply) then
		return
	end
	
	local firstname = net.ReadString()
	local lastname = net.ReadString()

	-- Player use a forbidden name
	if gNameChanger.blacklist_active then
		if string.find(gNameChanger.blacklisted, firstname) or string.find(gNameChanger.blacklisted, lastname) then
			DarkRP.notify(ply, 1, 5, gNameChanger.Language.nameBlacklist)
			return
		end
	end

	local name = firstname .. " " .. lastname

	if not ply:canAfford(gNameChanger.price) then
		DarkRP.notify(ply, 1, 15, gNameChanger:LangMatch(gNameChanger.Language.needMoney))
		return
	else		
		DarkRP.retrieveRPNames(name, function(taken)
			if taken then
				DarkRP.notify(ply, 1, 5, DarkRP.getPhrase("unable", "RPname", DarkRP.getPhrase("already_taken")))
			else
				ply:addMoney(-gNameChanger.price)

				DarkRP.storeRPName(ply, name)
				ply:setDarkRPVar("rpname", name)
				DarkRP.notifyAll(2, 6, DarkRP.getPhrase("rpname_changed", ply:SteamName(), name))
			end
		end)
	end

	ply.gNameLastNameChange = CurTime()
end