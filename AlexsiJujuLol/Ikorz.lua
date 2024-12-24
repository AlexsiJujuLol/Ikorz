local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/LuauCloud/Byte/refs/heads/main/Utils/Library.lua'))()

-- Create the main window
local Library_Window = Library.Add_Window('Acceptions')

-- Create a Tab for "Blatant"
local Blatant_Tab = Library_Window.Create_Tab({
    name = 'Blatant',
    icon = 'rbxassetid://'
})

-- Create a Section for the "Blatant" Tab
local Blatant_Section = Blatant_Tab.Create_Section()

-- Create Auto Parry toggle in Blatant tab
local Auto_Parry = Blatant_Section.Create_DropToggle({
    name = 'Auto Parry',
    section = 'left',
    flag = 'Auto_Parry',
    options = {'Custom', 'Random', 'Backwards'},
    callback = function(state)
        if state then
            print('Auto Parry Enabled')
            -- Add logic for enabling Auto Parry feature here
        else
            print('Auto Parry Disabled')
            -- Add logic for disabling Auto Parry feature here
        end
    end,
    callback2 = function(selected)
        print('Selected Auto Parry option:', selected)
    end
})

-- Create a Tab for "Blox Fruit"
local BloxFruit_Tab = Library_Window.Create_Tab({
    name = 'Blox Fruit',
    icon = 'rbxassetid://'
})

-- Create a Section for the "Blox Fruit" Tab
local BloxFruit_Section = BloxFruit_Tab.Create_Section()

-- Create a Toggle for enabling/disabling Auto Fruit in Blox Fruit
local Auto_Fruit_Toggle = BloxFruit_Section.Create_Toggle({
    name = 'Enable Auto Fruit',
    flag = 'Enable_Auto_Fruit',
    callback = function(state)
        if state then
            print('Auto Fruit Enabled')
            -- Add logic for enabling Auto Fruit here
        else
            print('Auto Fruit Disabled')
            -- Add logic for disabling Auto Fruit here
        end
    end
})

-- Example of a Slider in "Blox Fruit" tab for fruit level
local BloxFruit_Slider = BloxFruit_Section.Create_Slider({
    name = 'Fruit Level',
    flag = 'Fruit_Level',
    min = 1,
    max = 100,
    default = 1,
    callback = function(value)
        print('Fruit Level:', value)
    end
})

-- Create a Tab for "Blade Ball"
local BladeBall_Tab = Library_Window.Create_Tab({
    name = 'Blade Ball',
    icon = 'rbxassetid://'
})

-- Create a Section for the "Blade Ball" Tab
local BladeBall_Section = BladeBall_Tab.Create_Section()

-- Create Auto Parry toggle in Blade Ball tab
local BladeBall_Auto_Parry = BladeBall_Section.Create_Toggle({
    name = 'Enable Auto Parry',
    flag = 'BladeBall_Enable_Auto_Parry',
    callback = function(state)
        if state then
            print('Blade Ball Auto Parry Enabled')
            -- Start the Auto Parry feature when enabled
            auto_parry_enabled = true
            AutoParry()  -- Start checking for balls to parry
        else
            print('Blade Ball Auto Parry Disabled')
            -- Stop the Auto Parry feature when disabled
            auto_parry_enabled = false
        end
    end
})

-- Slider to adjust the auto parry distance for Blade Ball
local BladeBall_Parry_Distance = BladeBall_Section.Create_Slider({
    name = 'Auto Parry Distance',
    flag = 'BladeBall_Parry_Distance',
    min = 1,
    max = 50,
    default = 10,
    callback = function(value)
        print('Auto Parry Distance:', value)
        auto_parry_distance = value  -- Update the distance based on the slider
    end
})

-- Slider for controlling parry spam speed
local BladeBall_Spam_Speed = BladeBall_Section.Create_Slider({
    name = 'Parry Spam Speed',
    flag = 'BladeBall_Spam_Speed',
    min = 0.1,
    max = 1,
    default = 0.5,
    callback = function(value)
        print('Parry Spam Speed:', value)
        spam_speed = value  -- Update the spam speed based on the slider
    end
})

-- Blade Ball Auto Parry Logic
local auto_parry_enabled = false
local auto_parry_distance = 10
local spam_speed = 0.5
local Balls = game:GetService("Workspace"):WaitForChild("Balls")
local Camera = game:GetService("Workspace").CurrentCamera

-- Function to trigger the parry (can be customized based on your game mechanics)
local function Parry()
    local ParryRemote = game.ReplicatedStorage:FindFirstChild("ParryButtonPress")
    if ParryRemote then
        ParryRemote:Fire()
    else
        print("Parry remote not found!")
    end
end

-- Auto Parry Function (called when auto_parry_enabled is true)
local function AutoParry()
    while auto_parry_enabled do
        for _, Ball in pairs(Balls:GetChildren()) do
            -- Check if the ball is valid for parrying
            if Ball:IsA("BasePart") and Ball:GetAttribute("realBall") == true then
                local Distance = (Ball.Position - Camera.CFrame.p).Magnitude
                local Velocity = (Ball.Position - Camera.CFrame.p).Magnitude / spam_speed
                local TimeToImpact = Distance / Velocity

                if Distance <= auto_parry_distance and TimeToImpact <= 1 then
                    Parry() -- Trigger the auto parry action
                end
            end
        end
        task.wait(spam_speed)  -- Control how often we check for balls to parry
    end
end

-- Create a Tab for "Arsenal"
local Arsenal_Tab = Library_Window.Create_Tab({
    name = 'Arsenal',
    icon = 'rbxassetid://'
})

-- Create a Section for the "Arsenal" Tab
local Arsenal_Section = Arsenal_Tab.Create_Section()

-- Silent Aim Toggle in Arsenal tab
local silent_aim_enabled = false

local function Aimbot()
    while silent_aim_enabled do
        local closestEnemy = nil
        local closestDistance = math.huge
        for _, enemy in ipairs(game.Players:GetPlayers()) do
            if enemy.Character and enemy ~= game.Players.LocalPlayer then
                local humanoidRootPart = enemy.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestEnemy = enemy
                    end
                end
            end
        end

        if closestEnemy then
            local targetPosition = closestEnemy.Character.HumanoidRootPart.Position
            local camera = workspace.CurrentCamera
            local direction = (targetPosition - camera.CFrame.p).unit
            local newCFrame = camera.CFrame * CFrame.new(direction * 100) -- silent aim adjustment
            camera.CFrame = CFrame.lookAt(camera.CFrame.p, newCFrame.p)
        end

        wait(0.1)
    end
end

-- Silent Aim Toggle UI
local SilentAim_Toggle = Arsenal_Section.Create_Toggle({
    name = 'Enable Silent Aim',
    flag = 'Enable_Silent_Aim',
    callback = function(state)
        silent_aim_enabled = state
        if silent_aim_enabled then
            print('Silent Aim Enabled')
            -- Start the Aimbot loop
            task.spawn(Aimbot)
        else
            print('Silent Aim Disabled')
        end
    end
})
