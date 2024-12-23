-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer -- Get the LocalPlayer

-- Ensure LocalPlayer is valid
if not LocalPlayer then
    warn("LocalPlayer not found! Script execution halted.")
    return
end

-- Remote name
local RemoteName = "Channel" -- Replace with the actual name of the RemoteEvent or RemoteFunction

-- Function to find a RemoteEvent or RemoteFunction
local function findRemote(name)
    local remote = ReplicatedStorage:FindFirstChild(name)
    if remote then
        if remote:IsA("RemoteEvent") then
            print("Found RemoteEvent:", remote.Name)
            return remote, "RemoteEvent"
        elseif remote:IsA("RemoteFunction") then
            print("Found RemoteFunction:", remote.Name)
            return remote, "RemoteFunction"
        else
            warn("Found object is neither RemoteEvent nor RemoteFunction.")
            return nil, nil
        end
    else
        warn("No remote found with name:", name)
        return nil, nil
    end
end

-- Detect the remote
local remote, remoteType = findRemote(RemoteName)

-- Load Kavo UI Library (Ensure it loads correctly)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    warn("Failed to load Kavo UI Library. Script execution halted.")
    return
end

-- Initialize Kavo UI
local Window = Library.CreateLib("Blade Ball Auto-Parry", "DarkTheme")

-- Create UI Tabs
local MainTab = Window:NewTab("Main")
local SettingsTab = Window:NewTab("Settings")

-- Main Tab Content
local MainSection = MainTab:NewSection("Auto-Parry")

local auto_parry_enabled = false
local parry_distance = 5
local parry_delay = 0.1

-- Toggle for Auto-Parry
MainSection:NewToggle("Enable Auto-Parry", "Toggle automatic parry functionality", function(state)
    auto_parry_enabled = state
    print("Auto-Parry Enabled:", state)
end)

-- Slider for Parry Distance
MainSection:NewSlider("Parry Distance", "Set the distance for parrying threats", 10, 1, function(value)
    parry_distance = value
    print("Parry Distance Set To:", value)
end)

-- Slider for Parry Delay
MainSection:NewSlider("Parry Delay", "Set the delay before parrying threats", 1, 0.05, function(value)
    parry_delay = value
    print("Parry Delay Set To:", value)
end)

-- Settings Tab Content
local SettingsSection = SettingsTab:NewSection("Remote Interaction")

-- Fire Server Button
SettingsSection:NewButton("Fire RemoteEvent", "Send a test event to the server", function()
    if remoteType == "RemoteEvent" and remote then
        remote:FireServer("Message from " .. LocalPlayer.Name)
        print("RemoteEvent fired to server.")
    else
        warn("RemoteEvent not found or invalid.")
    end
end)

-- Invoke Server Button
SettingsSection:NewButton("Call RemoteFunction", "Send a request to the server and get a response", function()
    if remoteType == "RemoteFunction" and remote then
        local success, result = pcall(function()
            return remote:InvokeServer("Request from " .. LocalPlayer.Name)
        end)

        if success then
            print("Server Response:", result)
        else
            warn("Failed to invoke RemoteFunction:", result)
        end
    else
        warn("RemoteFunction not found or invalid.")
    end
end)

-- Auto-Parry Logic (Runs Continuously)
task.spawn(function()
    while true do
        if auto_parry_enabled then
            print("Checking threats for auto-parry...") -- Debugging message

            -- Replace this logic with actual detection of threats
            local dummyThreat = { Name = "Blade", Position = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart.Position or Vector3.new() }
            local distance = (dummyThreat.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude

            if distance <= parry_distance then
                task.wait(parry_delay)
                print("Auto-parried threat:", dummyThreat.Name)
            end
        end
        task.wait(0.1) -- Adjust the check interval as needed
    end
end)

-- Ensure the UI is visible after script runs
Window:Show()

-- Notify User
Library:MakeNotification({
    Title = "Blade Ball Auto-Parry Loaded",
    Text = "Customize your settings in the Kavo UI!",
    Duration = 5,
    Callback = function()
        print("Notification dismissed!")
    end
})
