-- Load Kavo UI Library
local Kavo = loadstring(game:HttpGet('https://raw.githubusercontent.com/Kavo-UI/KavoUI/main/KavoUI'))()

-- Ensure Kavo UI has loaded
if not Kavo or type(Kavo) ~= "table" then
    warn("Kavo UI did not load correctly.")
    return
end

-- Variables for Auto-Parry Configuration
local parry_distance = 5 -- Default parry distance
local parry_delay = 0.1 -- Default parry delay
local auto_parry_enabled = false -- Auto-parry toggle

-- Initialize Kavo UI Window
local Window = Kavo:CreateWindow({
    Name = "Blade Ball Auto-Parry",
    LoadingTitle = "Initializing...",
    LoadingSubtitle = "Kavo UI Loaded",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BladeBallConfig", -- Change this to your desired folder name
        FileName = "Settings"
    }
})

-- Create Auto-Parry Tab
local Tab = Window:CreateTab("Auto-Parry Settings", 1234567890) -- Replace with your desired icon ID

-- Add a Slider for Parry Distance
Tab:CreateSlider({
    Name = "Parry Distance",
    Range = {1, 10}, -- Adjust range if needed
    Increment = 1,
    Suffix = "Units",
    Default = 5,
    Callback = function(Value)
        parry_distance = Value
    end
})

-- Add a Slider for Parry Delay
Tab:CreateSlider({
    Name = "Parry Delay",
    Range = {0.05, 1}, -- Adjust range if needed
    Increment = 0.05,
    Suffix = "Seconds",
    Default = 0.1,
    Callback = function(Value)
        parry_delay = Value
    end
})

-- Add a Toggle for Auto-Parry
Tab:CreateToggle({
    Name = "Enable Auto-Parry",
    CurrentValue = false,
    Callback = function(Value)
        auto_parry_enabled = Value
    end
})

-- Add a Button to Test Parry Functionality
Tab:CreateButton({
    Name = "Test Parry",
    Callback = function()
        print("Testing Parry with Distance:", parry_distance, "and Delay:", parry_delay)
    end
})

-- Ensure LocalPlayer and Character are initialized
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = Character:WaitForChild("HumanoidRootPart") -- Make sure HumanoidRootPart exists

-- Function to Detect Threats (Blades or Balls)
function GetThreatsInRange(range)
    local threats_in_range = {}
    if not rootPart then return threats_in_range end

    -- Ensure we are getting objects from the correct location
    local EndureModel = workspace:FindFirstChild("Endure")
    if EndureModel then
        for _, threat in pairs(EndureModel:GetChildren()) do
            if threat:IsA("BasePart") then
                local distance = (threat.Position - rootPart.Position).Magnitude
                if distance <= range then
                    table.insert(threats_in_range, threat)
                end
            end
        end
    else
        print("No 'Endure' model found in workspace.")
    end
    return threats_in_range
end

-- Function to Perform Parry
function PerformParry(threat, delay)
    task.wait(delay)
    print("Parried threat:", threat.Name)
    -- Replace with actual parry logic, such as triggering a parry animation or effect
end

-- Auto-Parry Logic (Runs Continuously)
task.spawn(function()
    while true do
        if auto_parry_enabled then
            local threats = GetThreatsInRange(parry_distance)
            for _, threat in pairs(threats) do
                PerformParry(threat, parry_delay)
            end
        end
        task.wait(0.05) -- Adjust the check interval as needed
    end
end)

-- Notify User
Kavo:Notify({
    Title = "Blade Ball Auto-Parry Loaded",
    Content = "Customize your settings in the UI!",
    Duration = 5,
    Image = 1234567890, -- Replace with your desired icon ID
    Actions = { -- Optional actions
        Okay = {
            Name = "Okay",
            Callback = function()
                print("UI Loaded Successfully!")
            end
        }
    }
})
