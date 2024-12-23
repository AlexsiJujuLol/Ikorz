-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Variables for Auto-Parry Configuration
local parry_distance = 5 -- Default parry distance
local parry_delay = 0.1 -- Default parry delay
local auto_parry_enabled = false -- Auto-parry toggle
local Score = 0 -- Score variable to track points

-- Create Kavo Window
local Window = Library.CreateLib("Blade Ball Auto-Parry", "DarkTheme")

-- Create Auto-Parry Tab
local AutoParryTab = Window:NewTab("Auto-Parry Settings")

-- Create Settings Section
local SettingsSection = AutoParryTab:NewSection("Settings")

-- Add Slider for Parry Distance
SettingsSection:NewSlider("Parry Distance", "Adjust the range for auto-parry detection", 10, 1, function(value)
    parry_distance = value
end)

-- Add Slider for Parry Delay
SettingsSection:NewSlider("Parry Delay", "Adjust the delay for auto-parry", 1, 0.05, function(value)
    parry_delay = value
end)

-- Add Toggle for Auto-Parry
SettingsSection:NewToggle("Enable Auto-Parry", "Toggle the auto-parry feature", function(state)
    auto_parry_enabled = state
end)

-- Add a Button to Test Parry
SettingsSection:NewButton("Test Parry", "Simulate a parry event", function()
    print("Testing Parry with Distance:", parry_distance, "and Delay:", parry_delay)
end)

-- Create Score Section
local ScoreSection = AutoParryTab:NewSection("Score")

-- Add a Button to Reset Score
ScoreSection:NewButton("Reset Score", "Reset the score to 0", function()
    Score = 0
    print("Score has been reset!")
end)

-- Functions for Auto-Parry and Threat Detection

-- Detect Local Player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = nil

-- Update Character and RootPart
local function UpdateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    RootPart = Character:WaitForChild("HumanoidRootPart", 5)
end

-- Listen for Character Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    UpdateCharacter()
end)

-- Initialize Character
UpdateCharacter()

-- Function to Detect Threats (Blades or Balls)
function GetThreatsInRange(range)
    local threats_in_range = {}
    if not RootPart then return threats_in_range end

    -- Adjust the loop for threats based on your game's structure
    for _, threat in pairs(workspace:GetDescendants()) do
        if threat:IsA("BasePart") and threat.Name == "Blade" then -- Replace "Blade" with the actual threat name
            local distance = (threat.Position - RootPart.Position).Magnitude
            if distance <= range then
                table.insert(threats_in_range, threat)
            end
        end
    end
    return threats_in_range
end

-- Function to Perform Parry
function PerformParry(threat, delay)
    task.wait(delay)
    if threat and threat.Parent then
        print("Parried threat:", threat.Name)
        -- Replace with actual parry logic, such as triggering animations or effects
        UpdateScore(10) -- Add score for parrying a threat
    end
end

-- Function to Update Score
function UpdateScore(amount)
    Score = Score + amount
    print("Current Score:", Score)
    -- You can add code to display the score on a GUI here
end

-- Auto-Parry Logic (Runs Continuously)
task.spawn(function()
    while true do
        if auto_parry_enabled and RootPart then
            local threats = GetThreatsInRange(parry_distance)
            for _, threat in pairs(threats) do
                PerformParry(threat, parry_delay)
            end
        end
        task.wait(0.1) -- Adjust the check interval as needed
    end
end)
