--[[
	HandMade by Gaby

	RPName changer

	This addon require DarkRP to work well.
]]--
include("shared.lua")

--[[
	CUSTOM FONTS
]]--
surface.CreateFont("roboto-light", {
	font = "Roboto Light",
	extended = false,
	size = 20,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont( "montserrat-medium", {
	font = "Montserrat Medium",
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
function ENT:Draw() -- Draw the ENT to the client
	-- the hex2rgb function wasn't done by myself. It has be found on GithubGist : https://gist.github.com/jasonbradley/4357406
	local hexCam = RPName_cam_color
	hexCam = hexCam:gsub("#","")
	if(string.len(hexCam) == 3) then
		redCam = tonumber("0x"..hexCam:sub(1,1)) * 17
		greenCam = tonumber("0x"..hexCam:sub(2,2)) * 17
		blueCam = tonumber("0x"..hexCam:sub(3,3)) * 17
	elseif(string.len(hexCam) == 6) then
		redCam = tonumber("0x"..hexCam:sub(1,2))
		greenCam = tonumber("0x"..hexCam:sub(3,4))
		blueCam = tonumber("0x"..hexCam:sub(5,6))
	end
	-- end of hex2rgb function
	local pos = self:GetPos()+ Vector(0, 0, 75)
	local ang = self:GetAngles()
	local angles = LocalPlayer():EyeAngles()
	self:DrawModel()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 300 then
		cam.Start3D2D(pos + ang:Up(), Angle(0, angles.y - 90, 90), 0.1) -- The 3d2dcam will always face the player
			draw.RoundedBox(5, -80, -49, 163, 40 , Color(redCam, greenCam, blueCam, 230))
			draw.DrawText("Secrétaire", "montserrat-medium", 0, -42, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
local function DermaPanel()
	-- Derma animation func
	local function inQuad(fraction, beginning, change)
		return change * (fraction ^ 1) + beginning
	end
	local ply = LocalPlayer() -- Define the ply var to the LocalPlayer entity
	local lerp = 75 -- Var is going to be used to change opacity
	local lerp_name = 75 -- Var is going to be used to change opacity
	-- the hex2rgb function wasn't done by myself. It has be found on GithubGist : https://gist.github.com/jasonbradley/4357406
	local hex = RPName_color
	hex = hex:gsub("#","")
	if(string.len(hex) == 3) then
		red = tonumber("0x"..hex:sub(1,1)) * 17
		green = tonumber("0x"..hex:sub(2,2)) * 17
		blue = tonumber("0x"..hex:sub(3,3)) * 17
	elseif(string.len(hex) == 6) then
		red = tonumber("0x"..hex:sub(1,2))
		green = tonumber("0x"..hex:sub(3,4))
		blue = tonumber("0x"..hex:sub(5,6))
	end
	-- end of hex2rgb function
	--[[
		THE DERMA PANEL
		frame = the panel
		title = title of the frame
		intro_sent = sentence show on in the middle top of the frame
		rpname_button = button for changing the rp name
	]]--
	frame_height = ScrH() / 3
	frame_width = ScrW() / 4
	local frame = vgui.Create("DFrame")
	frame:SetSize(frame_width, frame_height)
	frame:SetTitle("")
	frame:SetDraggable(false) -- Player can't move the window
	frame:ShowCloseButton(false) -- Disable the default close button
	frame:Center() -- Center of the screen
	frame:MakePopup()
	function frame:Paint(w, h)
		lerp = Lerp(FrameTime() * 5, lerp, 250)
		draw.RoundedBox(0, 0, 0, w, h, Color(red, green, blue, lerp))
	end
	local anim = Derma_Anim("EaseOutCirc", frame, function(pnl, anim, delta, data)
		pnl:SetPos((ScrW() / 2) - (frame_width / 2), inQuad(delta, ((ScrH() / 2) - (frame_height / 2)) - 10, 10))
	end)
	anim:Start(0.5) -- Launch the animation for 0.5 secs
	frame.Think = function(self)
		if anim:Active() then
			anim:Run()
		end
	end
	local title = vgui.Create("DLabel", frame) -- Title of the frame. This is show in the top left of the frame.
	title:SetText("SECRÉTAIRE")
	title:SetColor(Color(241, 250, 238))
	title:SetFont("montserrat-medium")
	title:SetPos(15, 2)
	title:SizeToContents()
	local label_actions = vgui.Create("DLabel", frame) -- Title of the frame. This is show in the top left of the frame.
	label_actions:SetText("Actions disponibles :")
	label_actions:SetColor(Color(241, 250, 238))
	label_actions:SetFont("roboto-light")
	label_actions:SetPos(frame_width / 15, frame_height / 3.5)
	label_actions:SizeToContents()
	local intro_sent = vgui.Create("DLabel", frame)
	intro_sent:SetText("Bonjour " .. ply:Nick() .. ". Que puis-je pour vous ?")
	intro_sent:SetFont("roboto-light")
	intro_sent:SetPos(frame_width / 8, frame_height / 8)
	intro_sent:SizeToContents()
	local rpname_button = vgui.Create("DButton", frame)
	rpname_button:SetText("Je souhaite changer de nom ! Et que ça saute !")
	rpname_button:SetPos(frame_width / 50, frame_height / 2.8)
	rpname_button:SetSize(frame_width - 20, 40)
	rpname_button:SetColor(Color(241, 250, 238))
	rpname_button:SetFont("roboto-light")
	function rpname_button:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(229, 111, 57))
	end
	rpname_button.DoClick = function()
		frame:Close()
		--[[
			RPNameChanger Derma panel
		]]--
		frame_height_little = frame_height / 1.5
		local rpname_frame = vgui.Create("DFrame")
		rpname_frame:SetSize(frame_width, frame_height_little)
		rpname_frame:SetTitle("")
		rpname_frame:SetDraggable(false) -- Player can't move the window
		rpname_frame:ShowCloseButton(false) -- Disable the default close button
		rpname_frame:Center() -- Center of the screen
		rpname_frame:MakePopup()
		function rpname_frame:Paint(w, h)
			lerp_name = Lerp(FrameTime() * 5, lerp_name, 250)
			draw.RoundedBox(0, 0, 0, w, h, Color(red, green, blue, lerp_name))
		end
		local anim = Derma_Anim("EaseOutCirc", rpname_frame, function(pnl, anim, delta, data)
			pnl:SetPos((ScrW() / 2) - (frame_width / 2), inQuad(delta, ((ScrH() / 2) - (frame_height_little / 2)) - 10, 10))
		end)
		anim:Start(0.5) -- Launch the animation for 0.5 secs
		rpname_frame.Think = function(self)
			if anim:Active() then
				anim:Run()
			end
		end
		local rpname_title = vgui.Create("DLabel", rpname_frame) -- Title of the frame. This is show in the top left of the frame.
		rpname_title:SetText("CHANGER DE NOM")
		rpname_title:SetColor(Color(241, 250, 238))
		rpname_title:SetFont("montserrat-medium")
		rpname_title:SetPos(15, 2)
		rpname_title:SizeToContents()
		local rpname_close_button = vgui.Create("DButton", rpname_frame)
		rpname_close_button:SetText("Je divague, pardonnez-moi...")
		rpname_close_button:SetPos(frame_width / 50, frame_height_little / 1.25)
		rpname_close_button:SetSize(frame_width - 20, 40)
		rpname_close_button:SetColor(Color(241, 250, 238))
		rpname_close_button:SetFont("roboto-light")
		function rpname_close_button:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(230, 57, 70))
		end
		rpname_close_button.DoClick = function()
			-- Close the current frame
			rpname_frame:Close()
			-- ReOpen the principal frame ( call the function to create the frame )
			DermaPanel()
		end
		rpname_textentry_firstname = vgui.Create("DTextEntry", rpname_frame)
		rpname_textentry_firstname:SetPos(frame_width / 50, frame_height_little / 2.5)
		rpname_textentry_firstname:SetSize(frame_width / 2 - 20, 40)
		rpname_textentry_firstname:SetFont("roboto-light")
		function rpname_textentry_firstname.Paint(self)
			surface.SetDrawColor(red + 40, green + 70, blue + 70)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(241, 250, 238), Color(red, green, blue), Color(red, green, blue))
		end
		rpname_textentry_surname = vgui.Create("DTextEntry", rpname_frame)
		rpname_textentry_surname:SetPos(frame_width / 1.93, frame_height_little / 2.5)
		rpname_textentry_surname:SetSize(frame_width / 2 - 20, 40)
		rpname_textentry_surname:SetFont("roboto-light")
		function rpname_textentry_surname.Paint(self)
			surface.SetDrawColor(red + 40, green + 70, blue + 70)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(241, 250, 238), Color(red, green, blue), Color(red, green, blue))
		end
		local rpname_label_firstname = vgui.Create("DLabel", rpname_frame)
		rpname_label_firstname:SetText("Prénom :")
		rpname_label_firstname:SetFont("roboto-light")
		rpname_label_firstname:SetPos(frame_width / 50, frame_height_little / 3.5)
		rpname_label_firstname:SizeToContents()
		local rpname_label_surname = vgui.Create("DLabel", rpname_frame)
		rpname_label_surname:SetText("Patronyme :")
		rpname_label_surname:SetFont("roboto-light")
		rpname_label_surname:SetPos(frame_width / 1.93, frame_height_little / 3.5)
		rpname_label_surname:SizeToContents()
		rpname_change_button = vgui.Create("DButton", rpname_frame)
		rpname_change_button:SetText("Changer mon nom ! Viiite ! ( " .. RPName_price .. "€ )")
		rpname_change_button:SetPos(frame_width / 50, frame_height_little / 1.6)
		rpname_change_button:SetSize(frame_width - 20, 40)
		rpname_change_button:SetColor(Color(241, 250, 238))
		rpname_change_button:SetFont("roboto-light")
		function rpname_change_button:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(79, 229, 54))
		end
		rpname_change_button.DoClick = function()
			if (rpname_textentry_firstname:GetValue() == "") then
				return false
			elseif (rpname_textentry_surname:GetValue() == "") then
				return false
			else
				-- Sending to the server the new name.
				net.Start("rpnamechange")
					net.WriteString(rpname_textentry_firstname:GetValue())
					net.WriteString(rpname_textentry_surname:GetValue())
					net.WriteInt(LocalPlayer():getDarkRPVar("money"), 16)
				net.SendToServer()
				rpname_frame:Close()
				DermaPanel()
			end
		end
	end
	local close_button = vgui.Create("DButton", frame)
	close_button:SetText("Veuillez m'excuser, je me suis trompé. Au revoir !")
	close_button:SetPos(frame_width / 50, frame_height / 1.15)
	close_button:SetSize(frame_width - 20, 40)
	close_button:SetColor(Color(241, 250, 238))
	close_button:SetFont("roboto-light")
	function close_button:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(230, 57, 70))
	end
	-- The close function
	close_button.DoClick = function()
		frame:Close()
	end
end

net.Receive("dermapanel", DermaPanel)