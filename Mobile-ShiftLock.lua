local Service = game.GetService
-- Services
local Players = Service(game, "Players")
local RunService = Service(game, "RunService")
local CAS = Service(game, "ContextActionService")
local CoreGui = Service(game, "CoreGui")
-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
-- UI
local ShiftLockGui = Instance.new("ScreenGui", CoreGui)
local ShiftLockButton = Instance.new("ImageButton", ShiftLockGui)
ShiftLockGui.Name = "SyncLock"
ShiftLockGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ShiftLockButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShiftLockButton.BackgroundTransparency = 1.000
ShiftLockButton.Position = UDim2.new(0.921914339, 0, 0.552375436, 0)
ShiftLockButton.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
ShiftLockButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftLockButton.Image = "http://www.roblox.com/asset/?id=182223762"

-- Function
local function ShiftLock()
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local RootPart = Character:WaitForChild("HumanoidRootPart")
	local States = {
		Disabled = "rbxasset://textures/ui/mouseLock_off@2x.png";
		Enabled = "rbxasset://textures/ui/mouseLock_on@2x.png";
	}
	local MaxLength = 900000
	local EnableOffset = CFrame.new(1.7, 0, 0)
	local DisableOffset = CFrame.new(-1.7, 0, 0)
	local Connections, IsActive = {}
	local UpdateImage = function(state)
		ShiftLockButton.Image = States[state]
	end
	local GetUpdatedCameraCFrame = function(root, camera)
		return CFrame.new(root.Position, Vector3.new(camera.CFrame.LookVector.X * MaxLength, root.Position.Y, camera.CFrame.LookVector.Z * MaxLength))
	end
	local Enable = function()
		Humanoid.AutoRotate = false
		UpdateImage("Enabled")
		RootPart.CFrame = GetUpdatedCameraCFrame(RootPart, Camera)
		Camera.CFrame = Camera.CFrame * EnableOffset
	end
	local Disable = function()
		Humanoid.AutoRotate = true
		UpdateImage("Disabled")
		Camera.CFrame = Camera.CFrame * DisableOffset
		pcall(function()
			IsActive:Disconnect()
			IsActive = nil
		end)
	end
	UpdateImage("Disabled")
	IsActive = false
	Connections[#Connections + 1] = ShiftLockButton.MouseButton1Click:Connect(function()
		if not IsActive then
			IsActive = RunService.RenderStepped:Connect(function()
				Enable()
			end)
		else
			Disable()
		end
	end)
	Connections[#Connections + 1] = Humanoid.Died:Connect(function()
		Disable()
		for i, v in next, Connections do
			v:Disconnect()
		end
		LocalPlayer.CharacterAdded:Wait()
		coroutine.wrap(ShiftLock)()
	end)
end
coroutine.wrap(ShiftLock)()