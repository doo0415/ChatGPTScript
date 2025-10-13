-- SERVICES
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- WAIT FOR PLAYERGUI
repeat wait() until Player:FindFirstChild("PlayerGui")

-- CLEANUP OLD GUI IF EXISTS
local existing = Player.PlayerGui:FindFirstChild("ArsenalMenu")
if existing then existing:Destroy() end

-- PARENT GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ArsenalMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = Player:WaitForChild("PlayerGui")
screenGui.Enabled = true

-- MAIN FRAME (centered card)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 360)
mainFrame.Position = UDim2.new(0.5, -210, 0, 60)
mainFrame.BackgroundTransparency = 0
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(45,45,48)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.6

-- TOP GRADIENT
local g = Instance.new("UIGradient", mainFrame)
g.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,44)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24,24,26))
}
g.Rotation = 270

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, -28, 0, 64)
titleLabel.Position = UDim2.new(0, 14, 0, 12)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Arsenal Menu"
titleLabel.TextColor3 = Color3.fromRGB(230,230,230)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel")
subtitle.Parent = mainFrame
subtitle.Size = UDim2.new(1, -28, 0, 20)
subtitle.Position = UDim2.new(0, 14, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Supports Arsenal and Rivals • Better UI"
subtitle.TextColor3 = Color3.fromRGB(180,180,180)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- BUTTON CONTAINER
local container = Instance.new("Frame")
container.Parent = mainFrame
container.Size = UDim2.new(1, -28, 1, -92)
container.Position = UDim2.new(0, 14, 0, 80)
container.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", container)
listLayout.Padding = UDim.new(0, 10)
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUTTON FACTORY (styled)
local function makeButton(name, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -20, 0, 56)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 52)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Parent = container

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(40,40,40)
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    -- simple hover animation
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(62,62,64)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(50,50,52)}):Play()
    end)

    return btn
end

-- Buttons
local aimbotButton = makeButton("AimbotButton", "Aimbot: OFF (Toggle E)")
local espButton = makeButton("ESPButton", "ESP: ON")
local jumpButton = makeButton("JumpButton", "Infinite Jump: OFF")
local speedInfoLabel = Instance.new("TextLabel", container)
speedInfoLabel.Size = UDim2.new(1, -20, 0, 28)
speedInfoLabel.BackgroundTransparency = 1
speedInfoLabel.Text = "Walkspeed: 16 (Use ← → to change)"
speedInfoLabel.Font = Enum.Font.Gotham
speedInfoLabel.TextSize = 14
speedInfoLabel.TextColor3 = Color3.fromRGB(190,190,190)
speedInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- STATES
local aimbotEnabled = false
local espEnabled = true
local infiniteJump = false
local walkspeed = 16
local maxSpeed = 500

-- UPDATE UI TEXT
local function updateAimbotStatus()
    aimbotButton.Text = aimbotEnabled and "Aimbot: ON (Toggle E)" or "Aimbot: OFF (Toggle E)"
    aimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(50,50,52)
end

local function updateESPStatus()
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(50,50,52)
end

local function updateJumpStatus()
    jumpButton.Text = infiniteJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
    jumpButton.BackgroundColor3 = infiniteJump and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(50,50,52)
end

local function updateSpeedLabel()
    speedInfoLabel.Text = "Walkspeed: "..tostring(walkspeed).." (Use ← → to change)"
end

updateAimbotStatus()
updateESPStatus()
updateJumpStatus()
updateSpeedLabel()

-- KEY BINDS
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if input.KeyCode == Enum.KeyCode.E then
        aimbotEnabled = not aimbotEnabled
        updateAimbotStatus()
    elseif input.KeyCode == Enum.KeyCode.Left then
        walkspeed = math.clamp(walkspeed - 10, 16, maxSpeed)
        if Humanoid then Humanoid.WalkSpeed = walkspeed end
        updateSpeedLabel()
    elseif input.KeyCode == Enum.KeyCode.Right then
        walkspeed = math.clamp(walkspeed + 10, 16, maxSpeed)
        if Humanoid then Humanoid.WalkSpeed = walkspeed end
        updateSpeedLabel()
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if infiniteJump and Humanoid and Humanoid.Health > 0 then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
