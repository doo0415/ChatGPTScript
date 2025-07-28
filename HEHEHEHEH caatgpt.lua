-- LocalScript in StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Setup (creating the UI in Arsenal with "stupid menu" design)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Player.PlayerGui
screenGui.Name = "StupidMenu"

-- Background
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 0.7
background.Parent = screenGui

-- Create a title for the menu
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 500, 0, 100)
titleLabel.Position = UDim2.new(0.5, -250, 0, 10)
titleLabel.Text = "STUPID MENU"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 48
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.BackgroundTransparency = 1
titleLabel.TextStrokeTransparency = 0.8
titleLabel.Parent = screenGui

-- Fun Button (Aimbot)
local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0, 300, 0, 80)
aimbotButton.Position = UDim2.new(0.5, -150, 0, 150)
aimbotButton.Text = "Aimbot"
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextSize = 36
aimbotButton.Font = Enum.Font.SourceSans
aimbotButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red
aimbotButton.BorderSizePixel = 5
aimbotButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
aimbotButton.Parent = screenGui

-- Fun Button (ESP)
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 300, 0, 80)
espButton.Position = UDim2.new(0.5, -150, 0, 250)
espButton.Text = "ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 36
espButton.Font = Enum.Font.SourceSans
espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
espButton.BorderSizePixel = 5
espButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
espButton.Parent = screenGui

-- Fun Button (Infinite Jump)
local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 300, 0, 80)
jumpButton.Position = UDim2.new(0.5, -150, 0, 350)
jumpButton.Text = "Infinite Jump"
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.TextSize = 36
jumpButton.Font = Enum.Font.SourceSans
jumpButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Blue
jumpButton.BorderSizePixel = 5
jumpButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
jumpButton.Parent = screenGui

-- Variables for toggling features
local aimbotActive = false
local espActive = true  -- Start with ESP active
local infiniteJumpActive = false
local jumpPower = 50

-- Aimbot Functionality
local function updateAimbot()
    if not Player.Character then return end

    local closestEnemy = nil
    local shortestDistance = math.huge

    -- Find the closest enemy player
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= Player and targetPlayer.Team ~= Player.Team and targetPlayer.Character then
            local targetCharacter = targetPlayer.Character
            local targetHead = targetCharacter:FindFirstChild("Head")
            if targetHead then
                local distance = (Camera.CFrame.Position - targetHead.Position).Magnitude
                if distance < shortestDistance then
                    closestEnemy = targetHead
                    shortestDistance = distance
                end
            end
        end
    end

    -- If there's an enemy, aim at their head
    if closestEnemy then
        local targetPosition = closestEnemy.Position
        local cameraPosition = Camera.CFrame.Position
        local direction = (targetPosition - cameraPosition).unit
        local newCameraPosition = cameraPosition + direction * 10
        Camera.CFrame = CFrame.new(newCameraPosition, targetPosition)
    end
end

-- Right-click to hold aimbot (MouseButton2)
local aimbotActive = false
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotActive = true  -- Activate aimbot when right-click is pressed
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotActive = false  -- Deactivate aimbot when right-click is released
    end
end)

-- Update Aimbot continuously if active (when right-click is held down)
RunService.Heartbeat:Connect(function()
    if aimbotActive then
        updateAimbot()
    end
end)

-- ESP Functionality with TextBox
local function createHighlight(player)
    if player == Player or player.Team == Player.Team then return end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Create the ESP box
    local box = Instance.new("Part")
    box.Name = "HighlightBox"
    box.Size = Vector3.new(4, 6, 4)
    box.Position = humanoidRootPart.Position
    box.Anchored = true
    box.CanCollide = false
    box.Material = Enum.Material.Neon
    box.BrickColor = BrickColor.new("Bright red")
    box.Transparency = 0.5
    box.Parent = workspace

    -- Create the ESP BillboardGui
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Parent = character.Head
    billboardGui.Adornee = character.Head
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true

    -- Create the TextLabel (name)
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansBold

    -- Create the TextLabel for health
    local healthTextBox = Instance.new("TextLabel")
    healthTextBox.Parent = billboardGui
    healthTextBox.Text = "Health: " .. math.floor(character:FindFirstChild("Humanoid").Health)
    healthTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthTextBox.BackgroundTransparency = 1
    healthTextBox.TextSize = 14
    healthTextBox.Font = Enum.Font.SourceSans
    healthTextBox.Position = UDim2.new(0, 0, 0, 20)  -- Position below the name

    -- Update health every frame
    RunService.Heartbeat:Connect(function()
        if character and character:FindFirstChild("Humanoid") then
            healthTextBox.Text = "Health: " .. math.floor(character.Humanoid.Health)
        end
    end)

    -- Clean up when player leaves or respawns
    player.CharacterRemoving:Connect(function()
        box:Destroy()
        billboardGui:Destroy()
    end)
end

-- Toggle ESP
espButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        espButton.Text = "ESP: ON"
        -- Create highlights for all players
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                createHighlight(player)
            end
        end
    else
        espButton.Text = "ESP: OFF"
        -- Remove all highlights
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "HighlightBox" then
                obj:Destroy()
            end
        end
    end
end)

-- Infinite Jump Toggle
jumpButton.MouseButton1Click:Connect(function()
    infiniteJumpActive = not infiniteJumpActive
    if infiniteJumpActive then
        jumpButton.Text = "Infinite Jump: ON"
        enableInfiniteJump()
    else
        jumpButton.Text = "Infinite Jump: OFF"
    end
end)

-- Infinite Jump Functionality
local function enableInfiniteJump()
    local character = Player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid.JumpHeight = 0

        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
                if humanoid:GetState() == Enum.HumanoidStateType.Physics or humanoid:GetState() == Enum.HumanoidStateType.Seated then
                    return
                end
                humanoid:Move(Vector3.new(0, jumpPower, 0))
            end
        end)
    end
end

-- Initialize ESP for all players
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espActive then
            createHighlight(player)
        end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        createHighlight(player)
    end
end
