--[[---------------------------------------------------------------------------

                        gName-Changer | CLIENT SIDE CODE
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()
    local w, h, ply = ScrW(), 300, LocalPlayer()

    local config = ply.gNConfig

    if w < 480 then
        w = 380
    elseif w < 768 then
        w = 450
    elseif w < 1024 then
        w = 500
    else
        w = 600
    end

    self:SetSize(w, h)
    self:SetTitle("")
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:Center()
    self:MakePopup()

    local title = vgui.Create("DLabel", self)
        title:SetText("gNameChanger - " .. gNameChanger.Language.administration)
        title:SetColor(gNameChanger.dermaFontColor)
        title:SetFont("montserrat-medium")
        title:SetPos(15, 2)
        title:SizeToContents()

    local closeBut = vgui.Create("DButton", self)
        closeBut:SetText("X")
        closeBut:SetPos(w - 35, 5)
        closeBut:SetSize(30, 20)
        closeBut:SetColor(gNameChanger.dermaFontColor)
        closeBut:SetFont("roboto-light")
        function closeBut:Paint(w, h)
                surface.SetDrawColor(Color(230, 57, 70))
                surface.DrawRect(0, 0, w, h)
        end
        closeBut.DoClick = function()
                self:Close()
        end
    local namesLab = vgui.Create("DLabel", self)
        namesLab:SetText(gNameChanger.Language.blacklist .. " :")
        namesLab:SetFont("roboto-light")
        namesLab:SetPos(30, 40)
        namesLab:SizeToContents()

    local namesText = vgui.Create("DTextEntry", self)
        namesText:SetPos(30, 65)
        namesText:SetSize((w - 60), 100)
        namesText:SetText(config.names)
        namesText:SetMultiline(true)
        namesText:SetFont("roboto-light")
        namesText:SetDrawLanguageID(false)
        function namesText.Paint(self)
                surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
                surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
                self:DrawTextEntryText(gNameChanger.dermaFontColor, Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
        end
    local activeCheck = vgui.Create("DCheckBox", self)
        activeCheck:SetPos(30, namesText:GetTall() + 85)
        activeCheck:SetValue(config.active)
        function activeCheck.Paint(self)
            surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
            surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
            if self:GetChecked() then
                surface.SetDrawColor(Color(123, 179, 90))
                surface.DrawRect(self:GetWide() - 12.5, self:GetTall() - 12.5, self:GetWide() - 5, self:GetTall() - 5)
            end
        end
    local activeLabel = vgui.Create("DLabel", self)
        activeLabel:SetText(gNameChanger.Language.activeList)
        activeLabel:SetFont("roboto-light")
        activeLabel:SetPos(50, namesText:GetTall() + 82.5)
        activeLabel:SetMouseInputEnabled(true)
        activeLabel:SizeToContents()
        activeLabel.DoClick = function() activeCheck:Toggle() end

    local saveBut = vgui.Create("DButton", self)
        saveBut:SetText(gNameChanger.Language.saveConfig)
        saveBut:SetPos(10, h - 50)
        saveBut:SetSize(w - 20, 40)
        saveBut:SetColor(gNameChanger.dermaFontColor)
        saveBut:SetFont("roboto-light")
        function saveBut:Paint(w, h)
                surface.SetDrawColor(Color(123, 179, 90))
                surface.DrawRect(0, 0, w, h)
        end
        saveBut.DoClick = function()
                local active, names = activeCheck:GetChecked(), namesText:GetText()
                net.Start("gNameChanger:Admin:Save")
                    net.WriteBool(active)
                    net.WriteString(names)
                net.SendToServer()
                self:Close()
        end
end

function PANEL:Paint(w, h)
      surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, 255)
      surface.DrawRect(0, 0, w, h)
end

vgui.Register("gNameChanger:PANEL:Administration", PANEL, "DFrame")

net.Receive("gNameChanger:Admin:Panel", function(len)
    local ply = LocalPlayer()
    ply.gNConfig = net.ReadTable()
    local adminPanel = vgui.Create("gNameChanger:PANEL:Administration")
    adminPanel:MakePopup()
end)