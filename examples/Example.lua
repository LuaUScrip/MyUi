local AntiGodHub = require(path.to.Library)

local UI = AntiGodHub.new({
    Title = "AntiGodHub",
    Width = 210,
    Height = 285,
})

UI:Toggle({
    Name = "Dupo Cash (all)",
    Default = false,
    Callback = function(enabled)
        print("Dupo Cash (all):", enabled)
    end,
})

UI:Toggle({
    Name = "Dupo Cash (nearest)",
    Default = false,
    Callback = function(enabled)
        print("Dupo Cash (nearest):", enabled)
    end,
})

UI:Toggle({
    Name = "Noclip",
    Default = false,
    Callback = function(enabled)
        print("Noclip:", enabled)
    end,
})

UI:Slider({
    Name = "Walk Speed",
    Min = 0,
    Max = 1000,
    Default = 100,

    -- The value shown at the top-right of the slider
    -- is directly editable. No extra custom-value box
    -- appears underneath the slider.
    Callback = function(value)
        print("Walk Speed:", value)
    end,
})

UI:Button({
    Name = "InfJump",
    Text = "Inf Jump",
    Callback = function()
        print("Inf Jump clicked")
    end,
})

UI:Divider()

UI:Footer("YouTube: AntiGodHub")

-- Example standalone controls:
-- UI:Section("Extra")
-- UI:Value({
--     Name = "Custom Value",
--     Default = "100",
--     Callback = function(value)
--         print("Custom value:", value)
--     end,
-- })
-- UI:Dropdown({
--     Name = "Dropdown",
--     Values = {"Option 1", "Option 2", "Option 3"},
--     Default = "Option 1",
--     Callback = function(value)
--         print("Selected:", value)
--     end,
-- })
