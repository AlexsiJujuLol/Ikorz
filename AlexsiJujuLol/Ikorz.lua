utoParry()
    if not humanoidRootPart then
        warn("HumanoidRootPart is missing! Auto Parry cannot run.")
        return
    end
    for _, ball in ipairs(workspace:GetDescendants()) do
        if ball:IsA("Model") and ball.Name == "BladeBall" then
            local owner = ball:FindFirstChild("Owner")
            local ballPart = ball:FindFirstChildWhichIsA("BasePart")
            if owner and ballPart and owner.Value ~= player then
                local ballPosition = ballPart.Position
                local distance = (humanoidRootPart.Position - ballPosition).Magnitude
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
-- Connect auto parry to RunService
game:GetService("RunService").Stepped:Connect(function()
    if autoParryEnabled then
        local success, errorMessage = 
