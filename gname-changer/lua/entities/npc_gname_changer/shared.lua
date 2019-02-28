--[[---------------------------------------------------------------------------

                        gName-Changer | SHARED CODE
                This addon has been created & released for free
                                   by Gaby
                Steam : https://steamcommunity.com/id/EpicGaby

-----------------------------------------------------------------------------]]
ENT.Base = "base_ai"
ENT.Type = "ai"
 
ENT.PrintName       = "gNameChanger - NPC"
ENT.Author          = "Gabyfle"
ENT.Contact         = "Don't"
ENT.Category        = "Gabyfle's Addons"
ENT.Instructions    = "gNameChanger:LangMatch(gNameChanger.Language.entHint)"

ENT.SetAutomaticFrameAdvance = true
ENT.Spawnable = true

-- Initialization of the ENT ( set the model )
function ENT:Initialize()
    self:SetModel(gNameChanger.model or "models/gman.mdl")

    if SERVER then
        self:SetHullType(HULL_HUMAN)
        self:SetHullSizeNormal()
        self:SetNPCState(NPC_STATE_SCRIPT)
        self:SetSolid(SOLID_BBOX)
        self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE , CAP_TURN_HEAD))
        self:SetUseType(SIMPLE_USE) -- Press "USE" to interact with
        self:DropToFloor()
    end

end