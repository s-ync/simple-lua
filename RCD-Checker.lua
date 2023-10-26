-- // RejectCharacterDeletions // --
local Service = game.GetService
local RCD = gethiddenproperty(Service(game, "Workspace"), "RejectCharacterDeletions")
local Message = RDC and "Enabled, simple FE doesn't work" or "Disabled, simple FE does work"
-- I just wanna make it 10 lines long lol
local StarterGui = Service(game, "StarterGui") 
StarterGui:SetCore("SendNotification", {
	Title = "RejectCharacterDeletions is";
	Text = Message;
})