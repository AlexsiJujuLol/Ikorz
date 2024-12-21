-- Blade Ball Script with Fluent UI
-- Created by Ikorz

-- Load Fluent UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/main.lua"))()
local window = library.new("Ikorz - Blade Ball")

-- Main Tab and Features Section
local mainTab = window:addPage("Main Features", 5012544693)
local section = mainTab:addSection("Auto Features")

-- Toggles for Features
local aimbotEnabled = false
local wallHackEnabled = false
local silentAimEnabled = false
local autoParryEnabled = false
local autoSpamEnabled = false
local aiPlayEnabled = false
local sensitivity = 0.5

section:addToggle("Aimbot", nil, function(state)
    aimbotEnabled = state
end)

section:addToggle("Wall Hack", nil, function(state)
    wallHackEnabled = state
end)

section:addToggle("Silent Aim", nil, function(state)
    silentAimEnabled = state
end)

section:addToggle("Auto Parry", nil, function(state)
    autoParryEnabled = state
end)

section:addToggle("Auto Spam", nil, function(state)
    autoSpamEnabled = state
end)

section:addToggle("AI Play", nil, function(state)
    aiPlayEnabled = state
end)

section:addSlider("Sensitivity", 0, 1, sensitivity, function(value)
    sensitivity = value
end)

-- Variables and Player Info
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10) -- Wait for 10 seconds

-- Ensure humanoidRootPart exists
if not humanoidRootPart then
    warn("HumanoidRootPart not found")
    return
end

-- Aimbot Function
local function aimbot()
    -- Implement aimbot logic here
end

-- Wall Hack Function
local function wallHack()
    -- Implement wall hack logic here
end

-- Silent Aim Function
local function silentAim()
    -- Implement silent aim logic here
end

-- Auto Parry Function
local function autoParry()
    -- Implement auto parry logic here
end

-- Auto Spam Function
local function autoSpam()
    -- Implement auto spam logic here
end

-- AI Play Function
local function aiPlay()
    -- Implement AI play logic here
end

-- Connect functions to RunService
game:GetService("RunService").Stepped:Connect(function()
    if aimbotEnabled then
        aimbot()
    end
    if wallHackEnabled then
        wallHack()
    end
    if silentAimEnabled then
        silentAim()
    end
    if autoParryEnabled then
        autoParry()
    end
    if autoSpamEnabled then
        autoSpam()
    end
    if aiPlayEnabled then
        aiPlay()
    end
end)
    sensitivity = value
end)

-- Variables and Player Info
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10) -- Wait for 10 seconds

-- Ensure humanoidRootPart exists
if not humanoidRootPart then
    warn("HumanoidRootPart not found")
    return
end

-- Aimbot Function
local function aimbot()
    -- Implement aimbot logic here
end

-- Wall Hack Function
local function wallHack()
    -- Implement wall hack logic here
end

-- Silent Aim Function
local function silentAim()
    -- Implement silent aim logic here
end

-- Connect functions to RunService
game:GetService("RunService").Stepped:Connect(function()
    if aimbotEnabled then
        aimbot()
    end
    if wallHackEnabled then
        wallHack()
    end
    if silentAimEnabled then
        silentAim()
    end
end)
