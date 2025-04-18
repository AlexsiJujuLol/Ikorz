--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
Y'all better thank me or I cry XD
]]--
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Balls = workspace:WaitForChild("Balls", 9e9)

local function get_player()
    return Players.LocalPlayer
end

local function get_character()
    local player = get_player()
    return player and player.Character
end

local function get_humanoid_root_part()
    local char = get_character()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function get_humanoid()
    local char = get_character()
    return char and char:FindFirstChild("Humanoid")
end

local function get_ball()
    local ballContainer = workspace:FindFirstChild("Balls")
    if not ballContainer then return nil end

    for _, v in pairs(ballContainer:GetChildren()) do
        if not v.Anchored then
            return v
        end
    end
    return nil
end

local function calculate_parry_distance()
    local ball = get_ball()
    if ball then
        local ping = get_player():GetNetworkPing() * 20
        return math.clamp(ball.Velocity.Magnitude / 2.4 + ping, 15, 200)
    end
    return 15
end

local visualise = true 

local function create_visualizer()
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.CastShadow = false
    sphere.Transparency = 1 
    sphere.Material = Enum.Material.ForceField
    sphere.Parent = workspace

    local hue = 0

    local function update_visualizer()
        if not visualise then
            sphere.Transparency = 1
            return
        end

        local humanoidRootPart = get_humanoid_root_part()
        if not humanoidRootPart then
            sphere.Transparency = 1
            return
        end

        sphere.Transparency = 0.5
        local parryDistance = calculate_parry_distance()
        sphere.Size = Vector3.new(parryDistance * 2, parryDistance * 2, parryDistance * 2)
        sphere.Position = humanoidRootPart.Position

        hue = (hue + 0.01) % 1
        sphere.Color = Color3.fromHSV(hue, 1, 1)
    end

    local function is_ball_within_visualizer(ball)
        local humanoidRootPart = get_humanoid_root_part()
        if not humanoidRootPart or not ball then
            return false
        end

        local distance = (humanoidRootPart.Position - ball.Position).Magnitude
        return distance <= sphere.Size.X / 2
    end

-- Parry ahh fixed function XD
    local function parry_if_valid(ball)
        if ball and is_ball_within_visualizer(ball) and Player.Character:FindFirstChild("Highlight") then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end

    local function monitor_visualizer()
        RunService.RenderStepped:Connect(function()
            update_visualizer()
         
            local ball = get_ball()
            parry_if_valid(ball)
        end)

        local player = get_player()
        if player then
            player.CharacterAdded:Connect(function()
                wait(0.1)
                if visualise then
                    update_visualizer()
                end
            end)
        end
    end

    monitor_visualizer()
end
                    
create_visualizer()
