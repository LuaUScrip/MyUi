-- Load the UILib
local UILib = require(game.ServerScriptService:WaitForChild("UILib_Fixed")) -- Adjust path as needed

-- Create UI with custom title, centered position, and footer
local UI = UILib.new("SPEED VS GIANT", UDim2.new(0.5, -125, 0.5, -100), "YouTube:AntiGodHub")

-- Set custom size (width, height)
UI:SetSize(250, 200)

-- Add buttons like in the image
UI:AddButton("Give Cash", nil, function()
	print("Give Cash clicked")
	-- Add your code here
end)

UI:AddButton("Inf Wins", nil, function()
	print("Inf Wins clicked")
	-- Add your code here
end)

-- Add toggles
local speedUpgradeContainer, getSpeedUpgradeState = UI:AddToggle("Speed Upgrade", function(state)
	print("Speed Upgrade toggled:", state)
	-- Add your code here
end)

-- Add text input box for custom values
local cashInputContainer, getCashInput = UI:AddTextBox("Cash Amount", "Enter amount...", function(value, enterPressed)
	if enterPressed then
		print("Cash input entered:", value)
		-- Add your code here to use the value
	end
end)

-- Add another text input
local multInputContainer, getMultInput = UI:AddTextBox("Multiplier", "e.g. 2.5", function(value, enterPressed)
	if enterPressed then
		print("Multiplier entered:", value)
		-- Add your code here
	end
end)

-- Add label with YouTube credit
UI:AddLabel("YouTuber: Tera IsMe", "Custom Script")

-- Get input values anytime
-- local currentCash = getCashInput()
-- local currentMult = getMultInput()

-- Optional: Update footer dynamically
-- UI:SetFooter("YouTube:AntiGodHub - Updated")

return UI
