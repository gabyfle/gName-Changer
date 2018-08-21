--[[---------------------------------------------------------------------------

				        gName-Changer | CLIENT SIDE CODE
				This addon has been created & released for free
								   by Gaby
				Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
surface.CreateFont("roboto-light", {
	font = "Roboto Light",
	extended = false,
	size = 20,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true
})
surface.CreateFont("montserrat-medium", {
	font = "Montserrat Medium",
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

-- inQuad function, used for Derma_Anim (animations) see more here : https://wiki.garrysmod.com/page/Global/Derma_Anim
local function inQuad(fraction, beginning, change)
	return change * (fraction ^ 2) + beginning
end

local function nameDerma(panel, ply, npc)
	local w, h = ScrW(), 230

	if w < 480 then
		w = 380
	elseif w < 768 then
		w = 450
	elseif w < 1024 then
		w = 500
	else
		w = 600
	end

	local frame = vgui.Create("DFrame")
		  frame:SetSize(w, h)
		  frame:SetTitle("")
		  frame:SetDraggable(false)
		  frame:ShowCloseButton(false)
		  frame:Center()
		  frame:MakePopup()
		  function frame:Paint(w, h)
		  		surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, 200)
		  		surface.DrawRect(0, 0, w, h)
		  end
		  local frameAnim = Derma_Anim("FadeIn", frame, function(panel, anim, delta, data)
		  		function panel:Paint(w, h)
					surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, inQuad(delta, 200, 255))
					surface.DrawRect(0, 0, w, h)
				end
		  end)
		  frameAnim:Start(0.25)
		  frame.Think = function(self)
		  		if frameAnim:Active() then
					frameAnim:Run()
				end
		  end
	--[[---------------------------------------------------------------------------------
			Secondary frame elements (nameframe)
				title     : Displayed on top left, it's the main title of the frame
				nameLab   : The name text entry label
				lastLab   : The lastname text entry label
				nameText  : The name text entry
				lastText  : The lastname text entry
				changeBut : RPName's changing button
				closeBut  : A big red button to close the frame, at the bottom
	-----------------------------------------------------------------------------------]]
		local title = vgui.Create("DLabel", frame)
			  title:SetText("CHANGER DE NOM")
			  title:SetColor(Color(241, 250, 238))
			  title:SetFont("montserrat-medium")
			  title:SetPos(15, 2)
			  title:SizeToContents()

		local nameLab = vgui.Create("DLabel", frame)
			  nameLab:SetText("Prénom :")
			  nameLab:SetFont("roboto-light")
			  nameLab:SetPos(30, 40)
			  nameLab:SizeToContents()

		local nameText = vgui.Create("DTextEntry", frame)
			  nameText:SetPos(30, 65)
			  nameText:SetSize((w - 60) / 2 - 5, 40)
			  nameText:SetFont("roboto-light")
			  function nameText.Paint(self)
					surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
					surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
					self:DrawTextEntryText(Color(241, 250, 238), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
			  end

		local lastLab = vgui.Create("DLabel", frame)
			  lastLab:SetText("Patronyme :")
			  lastLab:SetFont("roboto-light")
			  lastLab:SetPos(nameText:GetWide() + 30 + 10, 40)
			  lastLab:SizeToContents()

		local lastText = vgui.Create("DTextEntry", frame)
			  lastText:SetPos(nameText:GetWide() + 30 + 10, 65)
			  lastText:SetSize((w - 60) / 2, 40)
			  lastText:SetFont("roboto-light")
			  function lastText.Paint(self)
					surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
					surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
					self:DrawTextEntryText(Color(241, 250, 238), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
			  end

		local changeBut = vgui.Create("DButton", frame)
			  changeBut:SetText("Changer mon nom ! Viiite ! ( " .. gNameChanger.price .. "€ )")
			  changeBut:SetPos(10, h - 100)
			  changeBut:SetSize(w - 20, 40)
			  changeBut:SetColor(Color(241, 250, 238))
			  changeBut:SetFont("roboto-light")
			  function changeBut:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(123, 179, 90))
			  end
			  changeBut.DoClick = function()
					if (nameText:GetValue() == "") then
						return false
					elseif (lastText:GetValue() == "") then
						return false
					else
						-- Sending to the server the new name.
						net.Start("gName_NPC_Changer_name")
							net.WriteString(nameText:GetValue() .. " " .. lastText:GetValue())
							--net.WriteEntity(npc)
						net.SendToServer()

						-- Updating the name
						local childs = panel:GetChildren()
						childs[6]:SetText("HELLO")
						childs[6]:SizeToContents()

						panel:SetVisible(true)
						frame:Close()
					end
			  end
			  
		local closeBut = vgui.Create("DButton", frame)
			  closeBut:SetText("Je divague, pardonnez-moi...")
			  closeBut:SetPos(10, h - 50)
			  closeBut:SetSize(w - 20, 40)
			  closeBut:SetColor(Color(241, 250, 238))
			  closeBut:SetFont("roboto-light")
			  function closeBut:Paint(w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(230, 57, 70))
			  end
			  closeBut.DoClick = function()
			  		panel:SetVisible(true)
					frame:Close()
			  end
end

local function mainDerma()
	local w, h, ply = ScrW(), 250, LocalPlayer()
	local npc = 1--net.ReadEntity()

	if w < 480 then
		w = 380
	elseif w < 768 then
		w = 450
	elseif w < 1024 then
		w = 500
	else
		w = 600
	end

	local frame = vgui.Create("DFrame")
		  frame:SetSize(w, h)
		  frame:SetDraggable(false)
		  frame:ShowCloseButton(false)
		  frame:SetTitle("")
		  frame:Center()
		  frame:MakePopup()
		  function frame:Paint(w, h)
		  		surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, 0)
		  		surface.DrawRect(0, 0, w, h)
		  end
		  local frameAnim = Derma_Anim("FadeIn", frame, function(panel, anim, delta, data)
		  		function panel:Paint(w, h)
					surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, inQuad(delta, 0, 255))
					surface.DrawRect(0, 0, w, h)
				end
		  end)
		  frameAnim:Start(0.25)
		  frame.Think = function(self)
		  		if frameAnim:Active() then
					frameAnim:Run()
				end
		  end
	--[[---------------------------------------------------------------------------------
			Main frame elements
				title     : Displayed on top left, it's the main title of the frame
				welcome   : It's the introduction text for the name changer NPC
				changeBut : RPName's changing button
				closeBut  : A big red button to close the main frame
	-----------------------------------------------------------------------------------]]
	local title = vgui.Create("DLabel", frame)
		  title:SetText("SECRÉTAIRE")
		  title:SetColor(Color(241, 250, 238))
		  title:SetFont("montserrat-medium")
		  title:SetPos(15, 2)
		  title:SizeToContents()

	local welcome = vgui.Create("DLabel", frame)
		  welcome:SetText("Bonjour " .. ply:getDarkRPVar("rpname") .. ". Que puis-je pour vous ?")
		  welcome:SetFont("roboto-light")
		  welcome:SetPos(45, 45)
		  welcome:SizeToContents()

	local changeBut = vgui.Create("DButton", frame)
		  changeBut:SetText("Je souhaite changer de nom ! Et que ça saute !")
		  changeBut:SetPos(w / 50, h / 2.8)
		  changeBut:SetSize(w - 20, 40)
		  changeBut:SetColor(Color(241, 250, 238))
		  changeBut:SetFont("roboto-light")
		  function changeBut:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(229, 111, 57))
		  end
		  changeBut.DoClick = function()
		  		frame:SetVisible(false)
		  		nameDerma(frame, ply, npc)
		  end

	local closeBut = vgui.Create("DButton", frame)
		  closeBut:SetText("Veuillez m'excuser, je me suis trompé. Au revoir !")
		  closeBut:SetPos(10, h - 40 - 10)
		  closeBut:SetSize(w - 20, 40)
		  closeBut:SetColor(Color(241, 250, 238))
		  closeBut:SetFont("roboto-light")
		  function closeBut:Paint(w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(230, 57, 70))
		  end
		  closeBut.DoClick = function()
		  		frame:Close()
		  end
end
net.Receive("gName_NPC_Changer_panel", mainDerma)