-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurations for auto parry
local auto_parry_enabled = false
local parry_distance = 10
local parry_delay = 0.3
local parry_duration = 0.8
local cooldown = false

-- Function to detect balls within range
local function detectBalls()
    local balls = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name == "Ball" then
            local distance = (obj.Position - rootPart.Position).Magnitude
            if distance <= parry_distance then
                table.insert(balls, obj)
            end
        end
    end
    return balls
end

-- Function to perform parry
local function performParry()
    if cooldown then return end
    cooldown = true
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Create a new animation instance for the parry action
        local parryAnimation = Instance.new("Animation")
        -- Set this to your animation ID (the default here is a block animation)
        parryAnimation.AnimationId = "rbxassetid://6377993410"  -- Example Block animation ID
        local animTrack = humanoid:LoadAnimation(parryAnimation)
        
        -- Play the animation
        animTrack:Play()
        
        -- Wait for the animation duration before stopping it
        task.wait(parry_duration)
        animTrack:Stop()
    end
    cooldown = false
end

-- Function to enable auto parry
local function autoParry()
    while auto_parry_enabled do
        local balls = detectBalls()
        if #balls > 0 then
            performParry()
        end
        task.wait(parry_delay)  -- Add a slight delay to prevent it from constantly checking
    end
end

-- UI and interface with Kavo UI Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    warn("Error loading Kavo UI Library: " .. tostring(Library))
    return
else
    print("Kavo UI Library loaded successfully")
end

-- Create UI
local Window = Library.CreateLib("Blade Ball Auto-Parry", "DarkTheme")
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto-Parry")

-- Toggle for enabling auto parry
MainSection:NewToggle("Enable Auto-Parry", "Toggle automatic parry functionality", function(state)
    auto_parry_enabled = state
    if auto_parry_enabled then
        task.spawn(autoParry)  -- Start the auto parry loop
    end
end)

-- Slider to adjust parry distance
MainSection:NewSlider("Parry Distance", "Set the distance for parrying threats", 20, 1, function(value)
    parry_distance = value
end)

-- Slider to adjust parry delay
MainSection:NewSlider("Parry Delay", "Set the delay before parrying threats", 2, 0.1, function(value)
    parry_delay = value
end)

-- Slider to adjust parry duration (how long the parry animation lasts)
MainSection:NewSlider("Parry Duration", "Set the duration of the parry animation", 2, 0.1, function(value)
    parry_duration = value
end)

-- Notification after loading the script
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blade Ball Auto-Parry Loaded",
    Text = "Customize your settings in the Kavo UI!",
    Duration = 5
})

print("Script executed successfully")
