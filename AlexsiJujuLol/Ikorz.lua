local Debug = false -- Set this to true if you want debug output
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local Balls = Workspace:WaitForChild("Balls", 9e9)

-- Utility Functions
local function printDebug(...)
    if Debug then
        warn("[DEBUG]:", ...)
    end
end

-- Blade Ball Functions
local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true
end

local function VerifyDeathBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("deathBall") == true
end

local function IsTarget()
    return Player.Character and Player.Character:FindFirstChild("Highlight")
end

local function Parry()
    local ParryRemote = Remotes:FindFirstChild("ParryButtonPress")
    if ParryRemote then
        ParryRemote:Fire()
    else
        printDebug("Parry remote not found!")
    end
end

-- Auto Parry Function (with Spam Boost)
local auto_parry_enabled = false
local auto_parry_distance = 10
local spam_speed = 0.1
local auto_parry_task = nil

local function AutoParry()
    if auto_parry_task then return end  -- Prevent multiple tasks
    auto_parry_task = task.spawn(function()
        while auto_parry_enabled do
            if IsTarget() then
                for _, Ball in pairs(Balls:GetChildren()) do
                    if VerifyBall(Ball) or VerifyDeathBall(Ball) then
                        local Distance = (Ball.Position - Camera.CFrame.p).Magnitude
                        local Velocity = (Ball.Position - Camera.CFrame.p).Magnitude / spam_speed
                        local TimeToImpact = Distance / Velocity
                        printDebug(string.format("Ball Distance: %.2f, Velocity: %.2f, Time to Impact: %.2f", Distance, Velocity, TimeToImpact))

                        if Distance <= auto_parry_distance and TimeToImpact <= 1 then
                            Parry() -- Trigger auto parry
                        end
                    end
                end
            end
            task.wait(spam_speed)  -- This controls the rate at which balls are checked for parrying.
        end
        auto_parry_task = nil  -- Reset task after loop finishes
    end)
end

-- Humanoid Handling (For Death Balls or Parry Impact)
local function HandleHumanoidDeath()
    local Humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if Humanoid then
        Humanoid.Health = 0 -- Instantly kill the humanoid if needed (e.g., death ball impact)
    end
end

-- Visualize Death Ball (With Death Ball Handling)
local function VisualizeDeathBall(Ball)
    local marker = Instance.new("Part")
    marker.Shape = Enum.PartType.Ball
    marker.Size = Vector3.new(2, 2, 2)
    marker.Color = Color3.fromRGB(255, 0, 0) -- Red for death balls
    marker.Position = Ball.Position
    marker.Anchored = true
    marker.CanCollide = false
    marker.Parent = Workspace
    game:GetService("Debris"):AddItem(marker, 5) -- Auto-remove after 5 seconds
end

-- Ball Detection and Handling
Balls.ChildAdded:Connect(function(Ball)
    if not VerifyBall(Ball) and not VerifyDeathBall(Ball) then return end

    -- Handle Death Ball
    if VerifyDeathBall(Ball) then
        printDebug("Death Ball detected!")
        VisualizeDeathBall(Ball)
        HandleHumanoidDeath()
    end

    -- Track Regular Balls (auto parry logic)
    local PreviousPosition = Ball.Position
    local LastTick = tick()

    Ball:GetPropertyChangedSignal("Position"):Connect(function()
        if IsTarget() then
            local Distance = (Ball.Position - Camera.CFrame.p).Magnitude
            local Velocity = (Ball.Position - PreviousPosition).Magnitude / (tick() - LastTick)
            local TimeToImpact = Distance / Velocity

            printDebug(string.format("Distance: %.2f, Velocity: %.2f, Time: %.2f", Distance, Velocity, TimeToImpact))

            if TimeToImpact <= 1 then
                Parry()  -- Automatically parry based on calculated values
            end
        end

        -- Update position every frame
        if tick() - LastTick >= 1 / 60 then
            LastTick = tick()
            PreviousPosition = Ball.Position
        end
    end)
end)

-- UI Integration (Kavo Library)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    warn("Failed to load Kavo UI Library:", Library)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "UI library failed to load: " .. tostring(Library),
        Duration = 5
    })
    return
else
    printDebug("UI Library loaded successfully.")
end

-- UI Setup
local Window = Library.CreateLib("Arsenal + Blade Ball + Fish + Death Ball", "DarkTheme")

-- Arsenal Tab
local ArsenalTab = Window:NewTab("Arsenal Aimbot")
local ArsenalSection = ArsenalTab:NewSection("Aimbot Settings")
ArsenalSection:NewLabel("Automatically targets the closest enemy.")

ArsenalSection:NewToggle("Enable Silent Aim", "Enable silent aim for aimbot", function(state)
    silent_aim_enabled = state
    if silent_aim_enabled then
        task.spawn(Aimbot)
    end
end)

ArsenalSection:NewToggle("Enable ESP Wall Hack", "Show ESP of enemies through walls", function(state)
    esp_enabled = state
    ESPWallHack()  -- Refresh the ESP display when toggling
end)

-- Blade Ball Tab
local BladeBallTab = Window:NewTab("Blade Ball Auto Parry")
local BladeBallSection = BladeBallTab:NewSection("Auto Parry Settings")

BladeBallSection:NewToggle("Enable Auto Parry", "Toggle auto parry on or off", function(state)
    auto_parry_enabled = state
    if auto_parry_enabled then
        AutoParry()  -- Start the AutoParry loop
    end
end)

BladeBallSection:NewSlider("Auto Parry Distance", "Set the distance for auto parry", 1, 50, auto_parry_distance, function(value)
    auto_parry_distance = value
end)

BladeBallSection:NewSlider("Spam Speed", "Set the speed for spam delay (seconds)", 0.1, 1, spam_speed, function(value)
    spam_speed = value
end)
