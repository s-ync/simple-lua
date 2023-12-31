local Service = game.GetService

-- Services
local Players = Service(game, "Players");
local RunService = Service(game, "RunService");
local CoreGui = Service(game, "CoreGui");

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI
local ShiftLockGui = Instance.new("ScreenGui", CoreGui);
local ShiftLockButton = Instance.new("ImageButton", ShiftLockGui);
ShiftLockGui.Name = "SyncLock"
ShiftLockGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ShiftLockButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
ShiftLockButton.BackgroundTransparency = 1.000
ShiftLockButton.Position = UDim2.new(0.921914339, 0, 0.552375436, 0);
ShiftLockButton.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0);
ShiftLockButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftLockButton.Image = "http://www.roblox.com/asset/?id=182223762"

-- Function
local DisconnectAll = function(tbl)
	for i, v in next, tbl do
		v:Disconnect()
	end
end

local WasEnabled, DestroyScript = false
local ShiftLock;
ShiftLock = function()
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
	local Humanoid = Character:WaitForChild("Humanoid");
	local RootPart = Character:WaitForChild("HumanoidRootPart");
	
	local States = {
		Disabled = "rbxasset://textures/ui/mouseLock_off@2x.png",
		Enabled = "rbxasset://textures/ui/mouseLock_on@2x.png"
	}
	local MaxLength = 900000
	
	local IsActive
	local Connections = {}
	
	local UpdateImage = function(state)
		ShiftLockButton.Image = States[state]
	end
	
	local Enable = function()
		Humanoid.AutoRotate = false
		UpdateImage("Enabled");
		RootPart.CFrame = CFrame.new(RootPart.Position, Vector3.new(Camera.CFrame.LookVector.X * MaxLength, RootPart.Position.Y, Camera.CFrame.LookVector.Z * MaxLength));
		Camera.CFrame = Camera.CFrame * CFrame.new(1.7, 0, 0);
	end
	
	local Disable = function()
		Humanoid.AutoRotate = true
		UpdateImage("Disabled");
		Camera.CFrame = Camera.CFrame * CFrame.new(-1.7, 0, 0);
		pcall(function()
			IsActive:Disconnect();
			IsActive = nil
		end)
	end
	
	UpdateImage("Disabled");
	IsActive = WasEnabled and RunService.RenderStepped:Connect(Enable);
	
	Connections[#Connections + 1] = ShiftLockButton.MouseButton1Click:Connect(function()
		if (not IsActive) then
			IsActive = RunService.RenderStepped:Connect(Enable);
			WasEnabled = true
		else
			Disable();
			WasEnabled = false
		end
	end);
	
	Connections["x"] = nil
	Connections["x"] = Humanoid.Died:Connect(function()
		LocalPlayer.CharacterAdded:Wait();
		DisconnectAll(Connections);
		pcall(function()
			IsActive:Disconnect();
			IsActive = nil
		end);
		ShiftLock();
	end);
	DestroyScript = function()
		DisconnectAll(Connections);
		if (IsActive) then
			Disable();
		end
		ShiftLockGui:Destroy();
	end
end

ShiftLock();

return DestroyScript
