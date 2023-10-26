-- // RejectCharacterDeletions // --
local Service = game.GetService
local RCD = gethiddenproperty(Service(game, "Workspace"), "RejectCharacterDeletions")
local Message = RCD and "Enabled, simple FE doesn't work" or "Disabled, simple FE does work"
-- //
local StarterGui = Service(game, "StarterGui") 
StarterGui:SetCore("SendNotification", {
	Title = "RejectCharacterDeletions is";
	Text = Message;
})
