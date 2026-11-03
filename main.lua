print("DELTA TEST WORKING!")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaTest"
gui.ResetOnSpawn = false

local label = Instance.new("TextLabel")
label.Size = UDim2.fromOffset(300, 80)
label.Position = UDim2.new(0.5, -150, 0.5, -40)
label.BackgroundColor3 = Color3.fromRGB(255, 180, 210)
label.Text = "DELTA IS WORKING! ♡"
label.TextSize = 22
label.Parent = gui

gui.Parent = player:WaitForChild("PlayerGui")
