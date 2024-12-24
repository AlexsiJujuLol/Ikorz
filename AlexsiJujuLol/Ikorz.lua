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

-- Create Auto Parry toggle
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
