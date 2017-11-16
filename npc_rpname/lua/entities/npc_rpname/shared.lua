--[[
	HandMade by Gaby

	RPName changer

	This addon require DarkRP to work well.
]]--

-- ENT Configuration
ENT.Base = "base_ai"
ENT.Type = "anim"
ENT.PrintName = "RPName Changer"
ENT.Category = "EnragedCity | EnragedGamers"
ENT.Instructions = "Appuyez sur E pour changer votre nom RP ( moyennant de l'argent )"
ENT.Spawnable = true

-- Initialization of the ENT ( set the model )
function ENT:Initialize()
	self:SetModel(gNameChanger.model or "models/gman.mdl")
	self:SetSolid(SOLID_BBOX)
	if SERVER then
		self:SetUseType(SIMPLE_USE) -- Press USE to interact with
		self:DropToFloor()
	end

end