--[[---------------------------------------------------------------------------

                        gName-Changer | CLIENT SIDE CODE
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
-- inQuad function, used for Derma_Anim (animations) see more here : https://wiki.garrysmod.com/page/Global/Derma_Anim
local function inQuad(fraction, beginning, change)
    return change * (fraction ^ 2) + beginning
end

-- Draw Blur function, used to draw blurred panels
local function DrawBlur(panel, amount)
    if gNameChanger.activeBlur then
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
end

local PANEL = {}

function PANEL:Init()
    local w, h = ScrW(), 230

    local a = 255

    if gNameChanger.activeBlur then a = gNameChanger.blurOpacity end

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

    local frameAnim = Derma_Anim("FadeIn", self, function(panel, anim, delta, data)
        function panel:Paint(w, h)
            DrawBlur(self, 10)
            surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, inQuad(delta, 0, a))
            surface.DrawRect(0, 0, w, h)
        end
    end)
    frameAnim:Start(0.25)
    self.Think = function(self)
        if frameAnim:Active() then
            frameAnim:Run()
        end
    end

    local title = vgui.Create("DLabel", self)
    title:SetText(gNameChanger.Language.changeName)
    title:SetColor(gNameChanger.dermaFontColor)
    title:SetFont("montserrat-medium")
    title:SetPos(15, 2)
    title:SizeToContents()

    local nameLab = vgui.Create("DLabel", self)
    nameLab:SetText(gNameChanger.Language.name)
    nameLab:SetFont("roboto-light")
    nameLab:SetPos(30, 40)
    nameLab:SizeToContents()

    local nameText = vgui.Create("DTextEntry", self)
    nameText:SetPos(30, 65)
    nameText:SetSize((w - 60) / 2 - 5, 40)
    nameText:SetFont("roboto-light")
    nameText:SetDrawLanguageID(false)
    function nameText.Paint(self)
        surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(gNameChanger.dermaFontColor, Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
    end

    local lastLab = vgui.Create("DLabel", self)
    lastLab:SetText(gNameChanger.Language.lastName)
    lastLab:SetFont("roboto-light")
    lastLab:SetPos(nameText:GetWide() + 30 + 10, 40)
    lastLab:SizeToContents()

    local lastText = vgui.Create("DTextEntry", self)
    lastText:SetPos(nameText:GetWide() + 30 + 10, 65)
    lastText:SetSize((w - 60) / 2, 40)
    lastText:SetFont("roboto-light")
    lastText:SetDrawLanguageID(false)
    function lastText.Paint(self)
        surface.SetDrawColor(gNameChanger.dermaColor.r + 40, gNameChanger.dermaColor.g + 70, gNameChanger.dermaColor.b + 70)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(gNameChanger.dermaFontColor, Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b), Color(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b))
    end

    local changeBut = vgui.Create("DButton", self)
    changeBut:SetText(gNameChanger:LangMatch(gNameChanger.Language.changeBut))
    changeBut:SetPos(10, h - 100)
    changeBut:SetSize(w - 20, 40)
    changeBut:SetColor(gNameChanger.dermaFontColor)
    changeBut:SetFont("roboto-light")
    function changeBut:Paint(w, h)
        surface.SetDrawColor(Color(123, 179, 90))
        surface.DrawRect(0, 0, w, h)
    end
    changeBut.DoClick = function()
        if (nameText:GetValue() == "") then
            return false
        elseif (lastText:GetValue() == "") then
            return false
        else
            -- Sending to the server the new name.
            net.Start("gNameChanger:NPC:Name")
                net.WriteString(nameText:GetValue())
                net.WriteString(lastText:GetValue())
            net.SendToServer()

            self:Close()
        end
    end
        
    local closeBut = vgui.Create("DButton", self)
    closeBut:SetText(gNameChanger.Language.sorry)
    closeBut:SetPos(10, h - 50)
    closeBut:SetSize(w - 20, 40)
    closeBut:SetColor(gNameChanger.dermaFontColor)
    closeBut:SetFont("roboto-light")
    function closeBut:Paint(w, h)
        surface.SetDrawColor(Color(230, 57, 70))
        surface.DrawRect(0, 0, w, h)
    end
    closeBut.DoClick = function()
        self:Close()
    end
end

function PANEL:Paint(w, h)
    DrawBlur(self, 10)
    surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, a - 100)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("gNameChanger:PANEL:NameChange", PANEL, 'DFrame')

PANEL = {}

function PANEL:Init()
    local buttonsCount = table.Count(gNameChanger.actions)
    local w, h, ply = ScrW(), 180 + (buttonsCount * 50), LocalPlayer()

    local a = 255

    if gNameChanger.activeBlur then a = gNameChanger.blurOpacity end

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
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:SetTitle("")
    self:Center()
    self:MakePopup()

    local frameAnim = Derma_Anim("FadeIn", self, function(panel, anim, delta, data)
        function panel:Paint(w, h)
            DrawBlur(self, 10)
            surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, inQuad(delta, 0, a))
            surface.DrawRect(0, 0, w, h)
        end
    end)
    frameAnim:Start(0.25)
    self.Think = function(self)
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
    local title = vgui.Create("DLabel", self)
    title:SetText(gNameChanger.Language.secretary)
    title:SetColor(gNameChanger.dermaFontColor)
    title:SetFont("montserrat-medium")
    title:SetPos(15, 2)
    title:SizeToContents()

    local welcome = vgui.Create("DLabel", self)
    welcome:SetText(gNameChanger:LangMatch(gNameChanger.Language.welcome))
    welcome:SetFont("roboto-light")
    welcome:SetPos(45, 45)
    welcome:SizeToContents()

    local changeBut = vgui.Create("DButton", self)
    changeBut:SetText(gNameChanger.Language.wantChange)
    changeBut:SetPos(10, h - (100 + buttonsCount * 50))
    changeBut:SetSize(w - 20, 40)
    changeBut:SetColor(gNameChanger.dermaFontColor)
    changeBut:SetFont("roboto-light")
    function changeBut:Paint(w, h)
        surface.SetDrawColor(Color(229, 111, 57))
        surface.DrawRect(0, 0, w, h)
    end
    changeBut.DoClick = function()
        self:Close()
        local nameFrame = vgui.Create("gNameChanger:PANEL:NameChange")
        nameFrame:MakePopup()
    end

    local buttonsTable = {}
    local i = buttonsCount
    -- Including customs buttons
    for k,v in pairs(gNameChanger.actions) do
        local button = buttonsTable[k]

        button = vgui.Create("DButton", self)
        button:SetText(v.buttonText)
        button:SetPos(10, h - ((100 + buttonsCount * 50)) + (50 * i))
        button:SetSize(w - 20, 40)
        button:SetColor(gNameChanger.dermaFontColor)
        button:SetFont("roboto-light")

        function button:Paint(w, h)
            surface.SetDrawColor(v.buttonColor)
            surface.DrawRect(0, 0, w, h)
        end

        button.DoClick = function()
            self:Close()
            v.action()
        end

        i = i - 1
    end

    local closeBut = vgui.Create("DButton", self)
    closeBut:SetText(gNameChanger.Language.wrongChoose)
    closeBut:SetPos(10, h - 50)
    closeBut:SetSize(w - 20, 40)
    closeBut:SetColor(gNameChanger.dermaFontColor)
    closeBut:SetFont("roboto-light")
    function closeBut:Paint(w, h)
        surface.SetDrawColor(Color(230, 57, 70))
        surface.DrawRect(0, 0, w, h)
    end
    closeBut.DoClick = function()
        self:Close()
    end
end

function PANEL:Paint(w, h)
    DrawBlur(self, 10)
    surface.SetDrawColor(gNameChanger.dermaColor.r, gNameChanger.dermaColor.g, gNameChanger.dermaColor.b, a - 100)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("gNameChanger:PANEL:MainPanel", PANEL, 'DFrame')

net.Receive("gNameChanger:NPC:Panel", function (len)
    local main = vgui.Create("gNameChanger:PANEL:MainPanel")
    main:MakePopup()
end)