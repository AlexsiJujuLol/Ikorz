-- Server-Side Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Create RemoteEvent if it doesn't already exist
local RemoteEvent = ReplicatedStorage:FindFirstChild("TestRemoteEvent")
if not RemoteEvent then
    RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = "TestRemoteEvent"
    RemoteEvent.Parent = ReplicatedStorage
end

-- Function to handle the parry logic
local function handleParry(player)
    -- Check if the player exists and has a character
    if player and player.Character then
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            -- Print to indicate the parry has occurred
            print(player.Name .. " performed a parry!")

            -- Add particle effects to simulate the parry action
            local effect = Instance.new("ParticleEmitter")
            effect.Texture = "rbxassetid://your_particle_texture_id"  -- Add your own particle texture here
            effect.Lifetime = NumberRange.new(0.5, 1)
            effect.Rate = 100
            effect.Parent = humanoidRootPart

            -- Check for nearby BladeBall and deflect it
            for _, ball in pairs(Workspace:GetChildren()) do
                if ball:IsA("Model") and ball.Name == "BladeBall" then
                    local ballPart = ball:FindFirstChild("BallPart")
                    if ballPart then
                        local distance = (humanoidRootPart.Position - ballPart.Position).Magnitude
                        if distance <= 10 then  -- Adjust distance for your game
                            -- Apply force to deflect the ball
                            local direction = (ballPart.Position - humanoidRootPart.Position).unit
                            local velocity = ballPart.Velocity.magnitude
                            ballPart.Velocity = direction * velocity * 1.5  -- Deflect with force
                            print("BladeBall deflected!")
                        end
                    end
                end
            end
        end
    end
end

-- Listen for RemoteEvent from client to trigger parry
RemoteEvent.OnServerEvent:Connect(function(player, action)
    print(player.Name .. " triggered action: " .. action)

    -- Handle specific actions
    if action == "Parry" then
        handleParry(player)
    end
end)

-- Function to create and throw a BladeBall
local function createBladeBall(player)
    -- Create a BladeBall model
    local bladeBall = Instance.new("Model")
    bladeBall.Name = "BladeBall"
    
    -- Create the BasePart (the ball)
    local ballPart = Instance.new("Part")
    ballPart.Name = "BallPart"
    ballPart.Shape = Enum.PartType.Ball
    ballPart.Size = Vector3.new(2, 2, 2)
    ballPart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0) -- Spawn it above the player
    ballPart.Anchored = false
    ballPart.CanCollide = true
    ballPart.Parent = bladeBall

    -- Add the owner of the ball
    local owner = Instance.new("StringValue")
    owner.Name = "Owner"
    owner.Value = player.Name
    owner.Parent = bladeBall
    
    -- Parent the BladeBall to the workspace
    bladeBall.Parent = Workspace

    -- Apply an initial velocity to the ball to simulate throwing
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)  -- Allow high velocity
    bodyVelocity.Velocity = player.Character.HumanoidRootPart.CFrame.LookVector * 50  -- Forward velocity
    bodyVelocity.Parent = ballPart
end

-- Example of creating and throwing a BladeBall every 5 seconds for a player
game:GetService("Players").PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)  -- Give time for the character to load
        createBladeBall(player)  -- Create and throw the BladeBall
    end)
end)

-- AI Player that throws BladeBalls periodically
local function createAIBladeBall()
    local aiPlayer = Instance.new("Model")
    aiPlayer.Name = "AIPlayer"
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = aiPlayer
    aiPlayer.Parent = Workspace

    local function aiThrow()
        createBladeBall(aiPlayer)
    end

    while true do
        aiThrow()
        wait(5)  -- Throw a new BladeBall every 5 seconds
    end
end

-- Start the AI blade ball throw
createAIBladeBall()
