--[[
    AntiGodHubUI
    Simple, compact Roblox UI library.

    Features:
    - Title
    - Section
    - Toggle
    - Button
    - Divider
    - Footer
    - Value/TextBox
    - Slider with editable value at the TOP RIGHT
    - Dropdown
    - Draggable window
    - Minimize button

    This library only provides UI controls and callbacks.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

local DEFAULTS = {
    Width = 210,
    Height = 285,

    Background = Color3.fromRGB(12, 12, 12),
    Section = Color3.fromRGB(20, 20, 20),
    SectionHover = Color3.fromRGB(27, 27, 27),

    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(170, 170, 170),
    Border = Color3.fromRGB(70, 70, 70),
    White = Color3.fromRGB(255, 255, 255),

    Radius = 6,
}

local function merge(defaults, custom)
    local result = {}
    for k, v in pairs(defaults) do
        result[k] = v
    end
    for k, v in pairs(custom or {}) do
        result[k] = v
    end
    return result
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

function Library.new(options)
    local self = setmetatable({}, Library)
    self.Config = merge(DEFAULTS, options)
    self.Minimized = false
    self._connections = {}
    self._destroyed = false

    local gui = Instance.new("ScreenGui")
    gui.Name = "AntiGodHubUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.Gui = gui

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(self.Config.Width, self.Config.Height)
    main.Position = UDim2.new(
        0.5, -self.Config.Width / 2,
        0.5, -self.Config.Height / 2
    )
    main.BackgroundColor3 = self.Config.Background
    main.BorderSizePixel = 1
    main.BorderColor3 = self.Config.Border
    main.ClipsDescendants = true
    main.Parent = gui
    corner(main, self.Config.Radius)
    self.Main = main

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.Parent = main
    self.Header = header

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -38, 1, 0)
    title.Position = UDim2.fromOffset(3, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Config.Title or "AntiGodHub"
    title.TextColor3 = self.Config.Text
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = header
    self.TitleLabel = title

    local minimize = Instance.new("TextButton")
    minimize.Name = "Minimize"
    minimize.Size = UDim2.fromOffset(24, 24)
    minimize.Position = UDim2.new(1, -28, 0, 6)
    minimize.BackgroundColor3 = self.Config.Section
    minimize.BorderSizePixel = 1
    minimize.BorderColor3 = self.Config.Border
    minimize.Text = "−"
    minimize.TextColor3 = self.Config.Text
    minimize.TextSize = 15
    minimize.Font = Enum.Font.GothamBold
    minimize.AutoButtonColor = false
    minimize.Parent = header
    corner(minimize, 5)
    self.MinimizeButton = minimize

    local headerDivider = Instance.new("Frame")
    headerDivider.Name = "HeaderDivider"
    headerDivider.Size = UDim2.new(1, 0, 0, 1)
    headerDivider.Position = UDim2.fromOffset(0, 35)
    headerDivider.BackgroundColor3 = self.Config.Border
    headerDivider.BorderSizePixel = 0
    headerDivider.Parent = main

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -12, 1, -42)
    content.Position = UDim2.fromOffset(6, 41)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 2
    content.ScrollBarImageColor3 = self.Config.Border
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.CanvasSize = UDim2.new()
    content.Parent = main
    self.Content = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 6)
    padding.Parent = content

    self:_connect(minimize.MouseButton1Click, function()
        self:SetMinimized(not self.Minimized)
    end)

    self:_makeDraggable()

    return self
end

function Library:_connect(signal, callback)
    local c = signal:Connect(callback)
    table.insert(self._connections, c)
    return c
end

function Library:_makeDraggable()
    local dragging = false
    local dragStart
    local startPosition

    self:_connect(self.Header.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = self.Main.Position
        end
    end)

    self:_connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    self:_connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Library:SetMinimized(value)
    self.Minimized = value

    if value then
        self.MinimizeButton.Text = "+"
        self.Content.Visible = false
        TweenService:Create(
            self.Main,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.fromOffset(self.Config.Width, 36)}
        ):Play()
    else
        self.MinimizeButton.Text = "−"
        TweenService:Create(
            self.Main,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.fromOffset(self.Config.Width, self.Config.Height)}
        ):Play()
        task.delay(0.12, function()
            if not self.Minimized and not self._destroyed then
                self.Content.Visible = true
            end
        end)
    end
end

function Library:SetTitle(text)
    self.TitleLabel.Text = tostring(text)
end

function Library:Title(text)
    return self:SetTitle(text)
end

function Library:Section(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 22)
    label.BackgroundTransparency = 1
    label.Text = tostring(text)
    label.TextColor3 = self.Config.Text
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Content
    return label
end

function Library:Divider()
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BackgroundColor3 = self.Config.Border
    divider.BorderSizePixel = 0
    divider.Parent = self.Content
    return divider
end

function Library:Footer(text)
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 20)
    footer.BackgroundTransparency = 1
    footer.Text = tostring(text)
    footer.TextColor3 = self.Config.Text
    footer.TextSize = 9
    footer.Font = Enum.Font.GothamBold
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = self.Content
    return footer
end

function Library:Button(options)
    options = options or {}

    local button = Instance.new("TextButton")
    button.Name = options.Name or "Button"
    button.Size = UDim2.new(1, 0, 0, options.Height or 34)
    button.BackgroundColor3 = self.Config.Section
    button.BorderSizePixel = 1
    button.BorderColor3 = options.OutlineColor or self.Config.White
    button.Text = options.Text or options.Name or "Button"
    button.TextColor3 = self.Config.Text
    button.TextSize = options.TextSize or 10
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = self.Content
    corner(button, 5)

    self:_connect(button.MouseEnter, function()
        button.BackgroundColor3 = self.Config.SectionHover
    end)

    self:_connect(button.MouseLeave, function()
        button.BackgroundColor3 = self.Config.Section
    end)

    self:_connect(button.MouseButton1Click, function()
        if typeof(options.Callback) == "function" then
            options.Callback()
        end
    end)

    return button
end

function Library:Toggle(options)
    options = options or {}

    local button = Instance.new("TextButton")
    button.Name = options.Name or "Toggle"
    button.Size = UDim2.new(1, 0, 0, 31)
    button.BackgroundColor3 = self.Config.Section
    button.BorderSizePixel = 1
    button.BorderColor3 = self.Config.Border
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = self.Content
    corner(button, 5)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.fromOffset(9, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Text or options.Name or "Toggle"
    label.TextColor3 = self.Config.Text
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button

    local box = Instance.new("Frame")
    box.Size = UDim2.fromOffset(15, 15)
    box.Position = UDim2.new(1, -23, 0.5, -7)
    box.BackgroundColor3 = self.Config.Background
    box.BorderSizePixel = 1
    box.BorderColor3 = self.Config.Border
    box.Parent = button
    corner(box, 3)

    local check = Instance.new("TextLabel")
    check.Size = UDim2.fromScale(1, 1)
    check.BackgroundTransparency = 1
    check.Text = "✓"
    check.TextColor3 = self.Config.Text
    check.TextSize = 10
    check.Font = Enum.Font.GothamBold
    check.Parent = box

    local state = options.Default == true
    check.Visible = state

    local object = {}

    function object:Set(value)
        state = value == true
        check.Visible = state
        if typeof(options.Callback) == "function" then
            options.Callback(state)
        end
    end

    function object:Get()
        return state
    end

    self:_connect(button.MouseEnter, function()
        button.BackgroundColor3 = self.Config.SectionHover
    end)

    self:_connect(button.MouseLeave, function()
        button.BackgroundColor3 = self.Config.Section
    end)

    self:_connect(button.MouseButton1Click, function()
        object:Set(not state)
    end)

    object.Instance = button
    object.Check = check
    object.Label = label

    return object
end

function Library:Value(options)
    options = options or {}

    local frame = Instance.new("Frame")
    frame.Name = options.Name or "Value"
    frame.Size = UDim2.new(1, 0, 0, options.Height or 30)
    frame.BackgroundColor3 = self.Config.Section
    frame.BorderSizePixel = 1
    frame.BorderColor3 = self.Config.Border
    frame.Parent = self.Content
    corner(frame, 5)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.fromOffset(9, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Text or options.Name or "Value"
    label.TextColor3 = self.Config.Text
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.fromOffset(45, 20)
    input.Position = UDim2.new(1, -51, 0.5, -10)
    input.BackgroundTransparency = 1
    input.Text = tostring(options.Default or "")
    input.PlaceholderText = options.Placeholder or ""
    input.TextColor3 = self.Config.Text
    input.TextSize = 10
    input.Font = Enum.Font.GothamBold
    input.TextXAlignment = Enum.TextXAlignment.Right
    input.ClearTextOnFocus = false
    input.Parent = frame

    local object = {}

    function object:Set(value)
        input.Text = tostring(value)
        if typeof(options.Callback) == "function" then
            options.Callback(value)
        end
    end

    function object:Get()
        return input.Text
    end

    self:_connect(input.FocusLost, function()
        if typeof(options.Callback) == "function" then
            options.Callback(input.Text)
        end
    end)

    object.Instance = frame
    object.Input = input
    object.Label = label

    return object
end

function Library:Slider(options)
    options = options or {}

    local min = tonumber(options.Min) or 0
    local max = tonumber(options.Max) or 100
    local value = tonumber(options.Default) or min

    local frame = Instance.new("Frame")
    frame.Name = options.Name or "Slider"
    frame.Size = UDim2.new(1, 0, 0, options.Height or 67)
    frame.BackgroundColor3 = self.Config.Section
    frame.BorderSizePixel = 1
    frame.BorderColor3 = self.Config.Border
    frame.Parent = self.Content
    corner(frame, 5)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.fromOffset(9, 3)
    label.BackgroundTransparency = 1
    label.Text = options.Text or options.Name or "Slider"
    label.TextColor3 = self.Config.Text
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    -- Editable value is at the TOP RIGHT.
    -- There is intentionally NO custom value box below the slider.
    local valueInput = Instance.new("TextBox")
    valueInput.Size = UDim2.fromOffset(43, 20)
    valueInput.Position = UDim2.new(1, -51, 0, 3)
    valueInput.BackgroundTransparency = 1
    valueInput.Text = tostring(value)
    valueInput.TextColor3 = self.Config.Text
    valueInput.TextSize = 10
    valueInput.Font = Enum.Font.GothamBold
    valueInput.TextXAlignment = Enum.TextXAlignment.Right
    valueInput.ClearTextOnFocus = false
    valueInput.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -18, 0, 3)
    bar.Position = UDim2.fromOffset(9, 29)
    bar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    corner(bar, 3)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = self.Config.Text
    fill.BorderSizePixel = 0
    fill.Parent = bar
    corner(fill, 3)

    local object = {}
    local dragging = false

    local function apply(newValue, callback)
        newValue = tonumber(newValue)
        if not newValue then
            valueInput.Text = tostring(value)
            return
        end

        if options.Clamp ~= false then
            newValue = math.clamp(newValue, min, max)
        end

        newValue = math.floor(newValue)
        value = newValue
        valueInput.Text = tostring(newValue)

        local percent = math.clamp(
            (newValue - min) / math.max(max - min, 1),
            0,
            1
        )
        fill.Size = UDim2.new(percent, 0, 1, 0)

        if callback ~= false and typeof(options.Callback) == "function" then
            options.Callback(newValue)
        end
    end

    function object:Set(newValue)
        apply(newValue)
    end

    function object:Get()
        return value
    end

    local function updateFromInput(input)
        local percent = math.clamp(
            (input.Position.X - bar.AbsolutePosition.X)
                / math.max(bar.AbsoluteSize.X, 1),
            0,
            1
        )

        local newValue = min + ((max - min) * percent)
        apply(newValue)
    end

    self:_connect(bar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)

    self:_connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            updateFromInput(input)
        end
    end)

    self:_connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    self:_connect(valueInput.FocusLost, function()
        apply(valueInput.Text)
    end)

    apply(value, false)

    object.Instance = frame
    object.Input = valueInput
    object.Label = label
    object.Bar = bar
    object.Fill = fill

    return object
end

function Library:Dropdown(options)
    options = options or {}

    local values = options.Values or {}
    local selected = options.Default or values[1]

    local holder = Instance.new("Frame")
    holder.Name = options.Name or "Dropdown"
    holder.Size = UDim2.new(1, 0, 0, 32)
    holder.BackgroundColor3 = self.Config.Section
    holder.BorderSizePixel = 1
    holder.BorderColor3 = self.Config.Border
    holder.ClipsDescendants = false
    holder.ZIndex = 10
    holder.Parent = self.Content
    corner(holder, 5)

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromScale(1, 1)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 11
    button.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.fromOffset(9, 0)
    label.BackgroundTransparency = 1
    label.Text = tostring(selected or options.Text or options.Name or "Dropdown")
    label.TextColor3 = self.Config.Text
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    label.Parent = holder

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(20, 1)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.Config.SubText
    arrow.TextSize = 8
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 12
    arrow.Parent = holder

    local list = Instance.new("Frame")
    list.Name = "List"
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.fromOffset(0, 34)
    list.BackgroundColor3 = self.Config.Section
    list.BorderSizePixel = 1
    list.BorderColor3 = self.Config.Border
    list.Visible = false
    list.ZIndex = 50
    list.Parent = holder
    corner(list, 5)

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = list

    local object = {}

    local function choose(option)
        selected = option
        label.Text = tostring(option)
        list.Visible = false
        arrow.Text = "▼"

        if typeof(options.Callback) == "function" then
            options.Callback(option)
        end
    end

    for _, option in ipairs(values) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, 0, 0, 28)
        item.BackgroundColor3 = self.Config.Section
        item.BorderSizePixel = 0
        item.Text = tostring(option)
        item.TextColor3 = self.Config.Text
        item.TextSize = 9
        item.Font = Enum.Font.GothamBold
        item.AutoButtonColor = false
        item.ZIndex = 51
        item.Parent = list

        self:_connect(item.MouseEnter, function()
            item.BackgroundColor3 = self.Config.SectionHover
        end)

        self:_connect(item.MouseLeave, function()
            item.BackgroundColor3 = self.Config.Section
        end)

        self:_connect(item.MouseButton1Click, function()
            choose(option)
        end)
    end

    list.Size = UDim2.new(1, 0, 0, #values * 28)

    self:_connect(button.MouseButton1Click, function()
        list.Visible = not list.Visible
        arrow.Text = list.Visible and "▲" or "▼"
    end)

    function object:Set(option)
        for _, valueOption in ipairs(values) do
            if valueOption == option then
                choose(option)
                return
            end
        end
    end

    function object:Get()
        return selected
    end

    object.Instance = holder
    object.Label = label
    object.List = list

    return object
end

function Library:Destroy()
    self._destroyed = true

    for _, connection in ipairs(self._connections) do
        if connection then
            connection:Disconnect()
        end
    end

    self._connections = {}

    if self.Gui then
        self.Gui:Destroy()
    end
end

return Library
