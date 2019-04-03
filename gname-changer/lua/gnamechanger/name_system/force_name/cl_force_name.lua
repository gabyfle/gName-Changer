--[[---------------------------------------------------------------------------

                        gName-Changer | CLIENT SIDE CODE
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
local function mainDerma() 
    local w, h = ScrW(), 180

    local function DrawBlur(panel, amount)
        local blur = Material("pp/blurscreen")
        local x, y = panel:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
        for i = 1, 3 do
            blur:SetFloat("$blur", (i / 3) * (amount or 6))
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end

    if w < 480 then
        w = 380
    elseif w < 768 then
        w = 450
    elseif w < 1024 then
        w = 500
    else
        w = 600
    end

    local background = vgui.Create("DPanel")
          background:SetSize(ScrW(), ScrH())
          background:Center()
          background:SetZPos(-1)
          function background:Paint(w, h)
                DrawBlur(self, 10)
                surface.SetDrawColor(0, 0, 0, 180)
                surface.DrawRect(0, 0, w, h)
          end

    local communityName = vgui.Create("DLabel", background)
          communityName:SetText(gNameChanger.communityName)
          communityName:SetColor(gNameChanger.dermaFontColor)
          communityName:SetFont(gNameChanger.communityFont)
          communityName:SizeToContents()
          communityName:SetPos(background:GetWide() / 2 - communityName:GetWide() / 2, background:GetTall() / 2 - 200)

    local communityDesc = vgui.Create("DLabel", background)
          communityDesc:SetText(gNameChanger.communityDesc)
          communityDesc:SetColor(gNameChanger.dermaFontColor)
          communityDesc:SetFont("roboto-light")
          communityDesc:SizeToContents()
          communityDesc:SetPos(background:GetWide() / 2 - communityDesc:GetWide() / 2, background:GetTall() / 2 - 140)

    local frame = vgui.Create("DFrame", background)
          frame:SetSize(w, h)
          frame:SetTitle("")
          frame:SetDraggable(false)
          frame:ShowCloseButton(false)
          frame:Center()
          frame:MakePopup()
          function frame:Paint(w, h)
                if gNameChanger.activeBlur then DrawBlur(self, 10) end
                surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, 200)
                surface.DrawRect(0, 0, w, h)
          end
    --[[---------------------------------------------------------------------------------
            Frame elements (mainDerma)
                title     : Displayed on top left, it's the main title of the frame
                nameLab   : The name text entry label
                lastLab   : The lastname text entry label
                nameText  : The name text entry
                lastText  : The lastname text entry
                chooseBut : Choose the current name to play
    -----------------------------------------------------------------------------------]]
        local title = vgui.Create("DLabel", frame)
              title:SetText(gNameChanger.Language.chooseName)
              title:SetColor(gNameChanger.dermaFontColor)
              title:SetFont("montserrat-medium")
              title:SetPos(15, 2)
              title:SizeToContents()

        local nameLab = vgui.Create("DLabel", frame)
              nameLab:SetText(gNameChanger.Language.name)
              nameLab:SetFont("roboto-light")
              nameLab:SetPos(30, 40)
              nameLab:SizeToContents()

        local nameText = vgui.Create("DTextEntry", frame)
              nameText:SetPos(30, 65)
              nameText:SetSize((w - 60) / 2 - 5, 40)
              nameText:SetFont("roboto-light")
              nameText:SetDrawLanguageID(false)
              function nameText.Paint(self)
                    surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
                    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
                    self:DrawTextEntryText(gNameChanger.dermaFontColor, Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
              end

        local lastLab = vgui.Create("DLabel", frame)
              lastLab:SetText(gNameChanger.Language.lastName)
              lastLab:SetFont("roboto-light")
              lastLab:SetPos(nameText:GetWide() + 30 + 10, 40)
              lastLab:SizeToContents()

        local lastText = vgui.Create("DTextEntry", frame)
              lastText:SetPos(nameText:GetWide() + 30 + 10, 65)
              lastText:SetSize((w - 60) / 2, 40)
              lastText:SetFont("roboto-light")
              lastText:SetDrawLanguageID(false)
              function lastText.Paint(self)
                    surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
                    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
                    self:DrawTextEntryText(gNameChanger.dermaFontColor, Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
              end

        local chooseBut = vgui.Create("DButton", frame)
              chooseBut:SetText(gNameChanger:LangMatch(gNameChanger.Language.chooseBut))
              chooseBut:SetPos(10, h - 50)
              chooseBut:SetSize(w - 20, 40)
              chooseBut:SetColor(gNameChanger.dermaFontColor)
              chooseBut:SetFont("roboto-light")
              function chooseBut:Paint(w, h)
                    surface.SetDrawColor(Color(123, 179, 90))
                    surface.DrawRect(0, 0, w, h)
              end
              chooseBut.DoClick = function()
                    if (nameText:GetValue() == "") then
                        return false
                    elseif (lastText:GetValue() == "") then
                        return false
                    else
                        -- Sending to the server the new name.
                        net.Start("gNameChanger:SPAWN:Name")
                            net.WriteString(nameText:GetValue())
                            net.WriteString(lastText:GetValue())
                        net.SendToServer()

                        frame:Close()
                        background:Remove()
                    end
              end
    if IsValid(LocalPlayer()) and LocalPlayer():Health() <= 0 then -- Doesn't work if player use "kill" command
        local _, framePosY = frame:GetPos()
        local killed = vgui.Create("DPanel", background)
              killed:SetSize(w, 50)
              killed:SetPos(0, framePosY + h)
              killed:CenterHorizontal() 
              function killed:Paint(w, h)
                    surface.SetDrawColor(Color(230, 57, 70)) 
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(Material(gNameChanger.infoIcon))
                    surface.DrawTexturedRect(5, 5, 40, 40)
              end
        local killedText = vgui.Create("DLabel", killed)
              killedText:SetText(gNameChanger.Language.killed)
              killedText:SetColor(gNameChanger.dermaFontColor)
              killedText:SetFont("roboto-light")
              killedText:SizeToContents()
              killedText:Center()
    end
end

net.Receive("gNameChanger:SPAWN:Panel", mainDerma)