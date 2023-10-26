local Options = {
	Reset = true; -- Reset and teleport back to your original position
}

-- Skid
local Service = game.GetService
local format = string.format
-- Services
local AvatarEditorService = Service(game, "AvatarEditorService")
local StarterGui = Service(game, "StarterGui")
local Players = Service(game, "Players")
-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
if (not Humanoid) then
	return
end

local BecomeRigType
if Humanoid.RigType == Enum.HumanoidRigType.R15 then
	BecomeRigType = Enum.HumanoidRigType.R6
else
	BecomeRigType = Enum.HumanoidRigType.R15
end

local Notify = function(Args)
	StarterGui:SetCore("SendNotification", Args)
end
	
AvatarEditorService:PromptSaveAvatar(Humanoid.HumanoidDescription, BecomeRigType)
local Result = AvatarEditorService:PromptSaveCompleted:Wait()
if Result ~= Enum.AvatarPromptResult.Success then
	Notify({
		Title = "Failed to switch";
		Text = "Cancelled or an error has occured";
		Duration = 3;
	})
	return
end

Notify({
	Title = "Turned user into";
	Text = BecomeRigType.Name;
	Duration = 3;
})

if (Options["Reset"]) then
	local RootPart = Character:FindFirstChild("HumanoidRootPart") or chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
	local OriginalCFrame = RootPart.CFrame
	Character:BreakJoints()
	local NewChar = plr.CharacterAdded:Wait()
	local NewRootPart = NewChar:WaitForChild("HumanoidRootPart")
	NewRootPart.CFrame = OriginalCFrame
	Notify({
		Title = "Success!";
		Text = format("Your character has become %s", BecomeRigType.Name);
		Duration = 3;
	})
end