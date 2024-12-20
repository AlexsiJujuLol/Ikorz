-- Blade Ball Script with Fluent UI
-- Created by Ikorz

-- Load Fluent UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/main.lua"))()
local window = library.new("Ikorz - Blade Ball")

-- Main Tab and Features Section
local mainTab = window:addPage("Main Features", 5012544693)
local section = mainTab:addSection("Auto Features")

-- Toggles for Features
local autoParryEnabled = false

section:addToggle("Auto Parry", nil, function(state)
    autoParryEnabled = state
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

-- Auto Parry Function
local function autoParry()
    for _, ball in pairs(workspace:GetChildren()) do
        if ball:IsA("Model") and ball.Name == "BladeBall" then
            local owner = ball:FindFirstChild("Owner")
            if owner and owner.Value ~= player then
                local ballPosition = ball.Position
                local distance = (humanoidRootPart.Position - ballPosition).magnitude

                if distance <= 10 then -- Adjust range for parry
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
                    task.wait(0.1)
                    game:GetService("VirtualUser"):Button1Up(Vector2.new(0, 0))
                    print("Parry triggered!")
                end
            end
        end
    end
end

-- Connect auto parry function to RunService
game:GetService("RunService").Stepped:Connect(function()
    if autoParryEnabled then
        autoParry()
    end
end)
