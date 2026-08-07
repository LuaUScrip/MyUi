local UILib = {}
UILib.__index = UILib

function UILib.new(title, position, footerText)
	local self = setmetatable({}, UILib)
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILib_" .. title
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Size = UDim2.new(0, 250, 0, 50)
	MainFrame.Position = position or UDim2.new(0.5, -125, 0.5, -25)
	MainFrame.Parent = ScreenGui
	
	local TitleFrame = Instance.new("Frame")
	TitleFrame.Name = "TitleBar"
	TitleFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	TitleFrame.BorderSizePixel = 0
	TitleFrame.Size = UDim2.new(1, 0, 0, 30)
	TitleFrame.Position = UDim2.new(0, 0, 0, 0)
	TitleFrame.Parent = MainFrame
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.BorderSizePixel = 0
	TitleLabel.Size = UDim2.new(1, -40, 1, 0)
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 18
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = title
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Center -- Changed to center
	TitleLabel.Parent = TitleFrame
	
	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "MinimizeBtn"
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
	MinimizeButton.Position = UDim2.new(1, -35, 0, 0)
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.TextSize = 14
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = "−"
	MinimizeButton.Parent = TitleFrame
	
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "Content"
	ContentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ContentFrame.BorderSizePixel = 0
	ContentFrame.Size = UDim2.new(1, 0, 1, -60)
	ContentFrame.Position = UDim2.new(0, 0, 0, 30)
	ContentFrame.Parent = MainFrame
	
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = ContentFrame
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	
	-- Footer Frame
	local FooterFrame = Instance.new("Frame")
	FooterFrame.Name = "Footer"
	FooterFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	FooterFrame.BorderSizePixel = 1
	FooterFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
	FooterFrame.Size = UDim2.new(1, 0, 0, 30)
	FooterFrame.Position = UDim2.new(0, 0, 1, -30)
	FooterFrame.Parent = MainFrame
	
	local FooterLabel = Instance.new("TextLabel")
	FooterLabel.Name = "FooterText"
	FooterLabel.BackgroundTransparency = 1
	FooterLabel.BorderSizePixel = 0
	FooterLabel.Size = UDim2.new(1, 0, 1, 0)
	FooterLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	FooterLabel.TextSize = 12
	FooterLabel.Font = Enum.Font.Gotham
	FooterLabel.Text = footerText or "YouTube:AntiGodHub"
	FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
	FooterLabel.Parent = FooterFrame
	
	self.ScreenGui = ScreenGui
	self.MainFrame = MainFrame
	self.TitleBar = TitleFrame
	self.ContentFrame = ContentFrame
	self.FooterFrame = FooterFrame
	self.Title = title
	self.ItemCount = 0
	self.IsMinimized = false
	self.OriginalSize = MainFrame.Size
	
	-- Drag functionality
	local dragging = false
	local dragInput
	local dragStart
	local startPos
	
	TitleFrame.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)
	
	TitleFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	-- Minimize functionality
	MinimizeButton.MouseButton1Click:Connect(function()
		if self.IsMinimized then
			ContentFrame.Visible = true
			FooterFrame.Visible = true
			MainFrame.Size = self.OriginalSize
			MinimizeButton.Text = "−"
			self.IsMinimized = false
		else
			ContentFrame.Visible = false
			FooterFrame.Visible = false
			MainFrame.Size = UDim2.new(0, 250, 0, 30)
			MinimizeButton.Text = "□"
			self.IsMinimized = true
		end
	end)
	
	return self
end

function UILib:AddLabel(text, subtext)
	self.ItemCount = self.ItemCount + 1
	
	local Container = Instance.new("Frame")
	Container.Name = "Label_" .. self.ItemCount
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, -10, 0, subtext and 35 or 25)
	Container.Parent = self.ContentFrame
	
	if subtext then
		local SubtextLabel = Instance.new("TextLabel")
		SubtextLabel.BackgroundTransparency = 1
		SubtextLabel.BorderSizePixel = 0
		SubtextLabel.Size = UDim2.new(1, 0, 0, 15)
		SubtextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		SubtextLabel.TextSize = 12
		SubtextLabel.Font = Enum.Font.Gotham
		SubtextLabel.Text = subtext
		SubtextLabel.TextXAlignment = Enum.TextXAlignment.Left
		SubtextLabel.Parent = Container
	end
	
	local MainLabel = Instance.new("TextLabel")
	MainLabel.BackgroundTransparency = 1
	MainLabel.BorderSizePixel = 0
	MainLabel.Size = UDim2.new(1, 0, 0, 20)
	MainLabel.Position = UDim2.new(0, 0, subtext and 0.5 or 0, 0)
	MainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	MainLabel.TextSize = 14
	MainLabel.Font = Enum.Font.Gotham
	MainLabel.Text = text
	MainLabel.TextXAlignment = Enum.TextXAlignment.Left
	MainLabel.Parent = Container
	
	return Container
end

function UILib:AddButton(text, subtext, callback)
	self.ItemCount = self.ItemCount + 1
	
	local Container = Instance.new("Frame")
	Container.Name = "Button_" .. self.ItemCount
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, -10, 0, subtext and 35 or 25)
	Container.Parent = self.ContentFrame
	
	if subtext then
		local SubtextLabel = Instance.new("TextLabel")
		SubtextLabel.BackgroundTransparency = 1
		SubtextLabel.BorderSizePixel = 0
		SubtextLabel.Size = UDim2.new(1, 0, 0, 15)
		SubtextLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		SubtextLabel.TextSize = 12
		SubtextLabel.Font = Enum.Font.Gotham
		SubtextLabel.Text = subtext
		SubtextLabel.TextXAlignment = Enum.TextXAlignment.Left
		SubtextLabel.Parent = Container
	end
	
	local MainButton = Instance.new("TextButton")
	MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	MainButton.BorderSizePixel = 1
	MainButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
	MainButton.Size = UDim2.new(1, 0, 0, 20)
	MainButton.Position = UDim2.new(0, 0, subtext and 0.5 or 0, 0)
	MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MainButton.TextSize = 14
	MainButton.Font = Enum.Font.Gotham
	MainButton.Text = text
	MainButton.TextXAlignment = Enum.TextXAlignment.Center
	MainButton.Parent = Container
	
	-- Hover effect
	MainButton.MouseEnter:Connect(function()
		MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)
	
	MainButton.MouseLeave:Connect(function()
		MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	end)
	
	MainButton.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
	
	return Container
end

function UILib:AddToggle(text, callback)
	self.ItemCount = self.ItemCount + 1
	
	local Container = Instance.new("Frame")
	Container.Name = "Toggle_" .. self.ItemCount
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, -10, 0, 25)
	Container.Parent = self.ContentFrame
	
	local TextLabel = Instance.new("TextLabel")
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, -30, 1, 0)
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 14
	TextLabel.Font = Enum.Font.Gotham
	TextLabel.Text = text
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Container
	
	local CheckBox = Instance.new("Frame")
	CheckBox.Name = "CheckBox"
	CheckBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	CheckBox.BorderSizePixel = 1
	CheckBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
	CheckBox.Size = UDim2.new(0, 20, 0, 20)
	CheckBox.Position = UDim2.new(1, -20, 0, 2)
	CheckBox.Parent = Container
	
	local Check = Instance.new("TextLabel")
	Check.BackgroundTransparency = 1
	Check.BorderSizePixel = 0
	Check.Size = UDim2.new(1, 0, 1, 0)
	Check.TextColor3 = Color3.fromRGB(0, 255, 100)
	Check.TextSize = 14
	Check.Font = Enum.Font.GothamBold
	Check.Text = ""
	Check.Parent = CheckBox
	
	local toggled = false
	
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.BackgroundTransparency = 1
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Size = UDim2.new(1, 0, 1, 0)
	ToggleButton.Text = ""
	ToggleButton.Parent = Container
	
	ToggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		Check.Text = toggled and "✓" or ""
		if toggled then
			CheckBox.BorderColor3 = Color3.fromRGB(0, 255, 100)
		else
			CheckBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
		end
		if callback then callback(toggled) end
	end)
	
	return Container, function() return toggled end
end

function UILib:AddTextBox(label, placeholder, callback)
	self.ItemCount = self.ItemCount + 1
	
	local Container = Instance.new("Frame")
	Container.Name = "TextBox_" .. self.ItemCount
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, -10, 0, 40)
	Container.Parent = self.ContentFrame
	
	local LabelText = Instance.new("TextLabel")
	LabelText.BackgroundTransparency = 1
	LabelText.BorderSizePixel = 0
	LabelText.Size = UDim2.new(1, 0, 0, 15)
	LabelText.TextColor3 = Color3.fromRGB(200, 200, 200)
	LabelText.TextSize = 12
	LabelText.Font = Enum.Font.Gotham
	LabelText.Text = label or "Input"
	LabelText.TextXAlignment = Enum.TextXAlignment.Left
	LabelText.Parent = Container
	
	local InputBox = Instance.new("TextBox")
	InputBox.Name = "InputField"
	InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	InputBox.BorderSizePixel = 1
	InputBox.BorderColor3 = Color3.fromRGB(80, 80, 80)
	InputBox.Size = UDim2.new(1, 0, 0, 20)
	InputBox.Position = UDim2.new(0, 0, 0, 18)
	InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	InputBox.TextSize = 13
	InputBox.Font = Enum.Font.Gotham
	InputBox.PlaceholderText = placeholder or "Enter value..."
	InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	InputBox.Parent = Container
	
	-- Hover effect
	InputBox.MouseEnter:Connect(function()
		InputBox.BorderColor3 = Color3.fromRGB(120, 120, 120)
	end)
	
	InputBox.MouseLeave:Connect(function()
		InputBox.BorderColor3 = Color3.fromRGB(80, 80, 80)
	end)
	
	-- Focus effect
	InputBox.Focused:Connect(function()
		InputBox.BorderColor3 = Color3.fromRGB(0, 150, 255)
	end)
	
	InputBox.FocusLost:Connect(function(enterPressed)
		InputBox.BorderColor3 = Color3.fromRGB(80, 80, 80)
		if callback then
			callback(InputBox.Text, enterPressed)
		end
	end)
	
	return Container, function() return InputBox.Text end
end

function UILib:AddSlider(label, minValue, maxValue, defaultValue, callback)
	self.ItemCount = self.ItemCount + 1
	
	local Container = Instance.new("Frame")
	Container.Name = "Slider_" .. self.ItemCount
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, -10, 0, 50)
	Container.Parent = self.ContentFrame
	
	local LabelText = Instance.new("TextLabel")
	LabelText.BackgroundTransparency = 1
	LabelText.BorderSizePixel = 0
	LabelText.Size = UDim2.new(0.7, 0, 0, 15)
	LabelText.TextColor3 = Color3.fromRGB(200, 200, 200)
	LabelText.TextSize = 12
	LabelText.Font = Enum.Font.Gotham
	LabelText.Text = label or "Slider"
	LabelText.TextXAlignment = Enum.TextXAlignment.Left
	LabelText.Parent = Container
	
	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.BorderSizePixel = 0
	ValueLabel.Size = UDim2.new(0.3, 0, 0, 15)
	ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
	ValueLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
	ValueLabel.TextSize = 12
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.Text = tostring(defaultValue or minValue)
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = Container
	
	local SliderBackground = Instance.new("Frame")
	SliderBackground.Name = "SliderBG"
	SliderBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	SliderBackground.BorderSizePixel = 1
	SliderBackground.BorderColor3 = Color3.fromRGB(80, 80, 80)
	SliderBackground.Size = UDim2.new(1, 0, 0, 5)
	SliderBackground.Position = UDim2.new(0, 0, 0, 25)
	SliderBackground.Parent = Container
	
	local SliderFill = Instance.new("Frame")
	SliderFill.Name = "SliderFill"
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	SliderFill.BorderSizePixel = 0
	SliderFill.Size = UDim2.new(0, 0, 1, 0)
	SliderFill.Parent = SliderBackground
	
	local SliderButton = Instance.new("TextButton")
	SliderButton.Name = "SliderButton"
	SliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	SliderButton.BorderSizePixel = 0
	SliderButton.Size = UDim2.new(0, 12, 0, 20)
	SliderButton.Position = UDim2.new(0, -6, 0.5, -10)
	SliderButton.Text = ""
	SliderButton.Parent = SliderBackground
	
	local currentValue = defaultValue or minValue
	local dragging = false
	
	local function updateSlider(input)
		local mouse = game:GetService("Players").LocalPlayer:GetMouse()
		local relativeX = math.clamp(mouse.X - SliderBackground.AbsolutePosition.X, 0, SliderBackground.AbsoluteSize.X)
		local percentage = relativeX / SliderBackground.AbsoluteSize.X
		currentValue = math.floor(minValue + (maxValue - minValue) * percentage)
		
		SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		SliderButton.Position = UDim2.new(percentage, -6, 0.5, -10)
		ValueLabel.Text = tostring(currentValue)
		
		if callback then callback(currentValue) end
	end
	
	SliderButton.MouseButton1Down:Connect(function()
		dragging = true
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)
	
	SliderBackground.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input)
		end
	end)
	
	return Container, function() return currentValue end
end

function UILib:AddDropdown(label, options, defaultOption, callback)
	self.ItemCount = self.ItemCount + 1
	
	local Container = Instance.new("Frame")
	Container.Name = "Dropdown_" .. self.ItemCount
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Size = UDim2.new(1, -10, 0, 25)
	Container.Parent = self.ContentFrame
	
	local LabelText = Instance.new("TextLabel")
	LabelText.BackgroundTransparency = 1
	LabelText.BorderSizePixel = 0
	LabelText.Size = UDim2.new(0.4, 0, 1, 0)
	LabelText.TextColor3 = Color3.fromRGB(200, 200, 200)
	LabelText.TextSize = 12
	LabelText.Font = Enum.Font.Gotham
	LabelText.Text = label or "Select"
	LabelText.TextXAlignment = Enum.TextXAlignment.Left
	LabelText.Parent = Container
	
	local DropdownButton = Instance.new("TextButton")
	DropdownButton.Name = "DropdownButton"
	DropdownButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	DropdownButton.BorderSizePixel = 1
	DropdownButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
	DropdownButton.Size = UDim2.new(0.55, 0, 1, 0)
	DropdownButton.Position = UDim2.new(0.4, 5, 0, 0)
	DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	DropdownButton.TextSize = 12
	DropdownButton.Font = Enum.Font.Gotham
	DropdownButton.Text = defaultOption or options[1] or "Choose..."
	DropdownButton.Parent = Container
	
	local DropdownList = Instance.new("Frame")
	DropdownList.Name = "DropdownList"
	DropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	DropdownList.BorderSizePixel = 1
	DropdownList.BorderColor3 = Color3.fromRGB(80, 80, 80)
	DropdownList.Size = UDim2.new(0.55, 0, 0, #options * 25)
	DropdownList.Position = UDim2.new(0.4, 5, 1, 2)
	DropdownList.Visible = false
	DropdownList.ZIndex = 10
	DropdownList.Parent = Container
	
	local ListLayout = Instance.new("UIListLayout")
	ListLayout.Parent = DropdownList
	ListLayout.FillDirection = Enum.FillDirection.Vertical
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Padding = UDim.new(0, 0)
	
	local selectedValue = defaultOption or options[1]
	local isOpen = false
	
	-- Create dropdown options
	for i, option in ipairs(options) do
		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = "Option_" .. i
		OptionButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		OptionButton.BorderSizePixel = 0
		OptionButton.Size = UDim2.new(1, 0, 0, 25)
		OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		OptionButton.TextSize = 12
		OptionButton.Font = Enum.Font.Gotham
		OptionButton.Text = option
		OptionButton.LayoutOrder = i
		OptionButton.Parent = DropdownList
		
		OptionButton.MouseEnter:Connect(function()
			OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end)
		
		OptionButton.MouseLeave:Connect(function()
			OptionButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		end)
		
		OptionButton.MouseButton1Click:Connect(function()
			selectedValue = option
			DropdownButton.Text = option
			DropdownList.Visible = false
			isOpen = false
			if callback then callback(option) end
		end)
	end
	
	-- Toggle dropdown
	DropdownButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		DropdownList.Visible = isOpen
		if isOpen then
			DropdownButton.BorderColor3 = Color3.fromRGB(0, 150, 255)
		else
			DropdownButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
		end
	end)
	
	-- Close dropdown when clicking outside
	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if isOpen then
				local mouse = game:GetService("Players").LocalPlayer:GetMouse()
				local mousePos = Vector2.new(mouse.X, mouse.Y)
				local dropdownPos = DropdownList.AbsolutePosition
				local dropdownSize = DropdownList.AbsoluteSize
				
				if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
					mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) then
					DropdownList.Visible = false
					DropdownButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
					isOpen = false
				end
			end
		end
	end)
	
	return Container, function() return selectedValue end
end

function UILib:SetSize(width, height)
	self.OriginalSize = UDim2.new(0, width, 0, height + 30)
	if not self.IsMinimized then
		self.MainFrame.Size = self.OriginalSize
	end
end

function UILib:SetPosition(position)
	self.MainFrame.Position = position
end

function UILib:SetFooter(text)
	self.FooterFrame:FindFirstChild("FooterText").Text = text
end

function UILib:Minimize()
	if not self.IsMinimized then
		self.ContentFrame.Visible = false
		self.FooterFrame.Visible = false
		self.MainFrame.Size = UDim2.new(0, 250, 0, 30)
		self.MainFrame:FindFirstChild("TitleBar").MinimizeBtn.Text = "□"
		self.IsMinimized = true
	end
end

function UILib:Maximize()
	if self.IsMinimized then
		self.ContentFrame.Visible = true
		self.FooterFrame.Visible = true
		self.MainFrame.Size = self.OriginalSize
		self.MainFrame:FindFirstChild("TitleBar").MinimizeBtn.Text = "−"
		self.IsMinimized = false
	end
end

return UILib
