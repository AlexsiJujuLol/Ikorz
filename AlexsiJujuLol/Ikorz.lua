-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurations for auto parry
local auto_parry_enabled = false
local parry_distance = 10
local parry_delay = 0.5
local parry_duration = 1
local cooldown = false

-- Function to detect enemies within range
local function detectEnemies()
    local enemies = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            local distance = (obj.HumanoidRootPart.Position - rootPart.Position).Magnitude
            if distance <= parry_distance then
                table.insert(enemies, obj)
            end
        end
    end
    return enemies
end

-- Function to perform parry
local function performParry()
    if cooldown then return end
    cooldown = true
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local parryAnimation = Instance.new("Animation")
        parryAnimation.AnimationId = "rbxassetid://1234567890"
        local animTrack = humanoid:LoadAnimation(parryAnimation)
        animTrack:Play()
        task.wait(parry_duration)
        cooldown = false
    end
end

-- Function to enable auto parry
local function autoParry()
    while auto_parry_enabled do
        local enemies = detectEnemies()
        if #enemies > 0 then
            print("Enemies detected, performing parry...")
            performParry()
        end
        print("Waiting for parry delay: " .. parry_delay)
        task.wait(parry_delay)
    end
end

-- UI and interface with Kavo UI Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    warn("Errore nel caricare la libreria Kavo UI: " .. tostring(Library))
    return
else
    print("Kavo UI Library caricata con successo")
end

local Window = Library.CreateLib("Blade Ball Auto-Parry", "DarkTheme")
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto-Parry")

MainSection:NewToggle("Enable Auto-Parry", "Toggle automatic parry functionality", function(state)
    auto_parry_enabled = state
    if auto_parry_enabled then
        print("Auto-Parry Enabled")
        task.spawn(autoParry)
    else
        print("Auto-Parry Disabled")
    end
end)

MainSection:NewSlider("Parry Distance", "Set the distance for parrying threats", 20, 1, function(value)
    parry_distance = value
    print("Parry Distance Set To:", value)
end)

MainSection:NewSlider("Parry Delay", "Set the delay before parrying threats", 2, 0.1, function(value)
    parry_delay = value
    print("Parry Delay Set To:", value)
end)

if Window then
    print("UI Created Successfully.")
else
    warn("La finestra UI non è stata creata correttamente.")
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blade Ball Auto-Parry Loaded",
    Text = "Customize your settings in the Kavo UI!",
    Duration = 5
})
