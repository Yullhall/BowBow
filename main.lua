-- BERRY AVENUE - OUTFIT COPIER TEST
-- Local appearance copying only. No anti-kick or server bypass.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SelectedPlayer = nil

-- Remove old GUI
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("BerryOutfitCopier"):Destroy()
end)

local GUI = Instance.new("ScreenGui")
GUI.Name = "BerryOutfitCopier"
GUI.ResetOnSpawn = false

pcall(function()
    GUI.Parent = game:GetService("CoreGui")
end)

if not GUI.Parent then
    GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(330, 390)
Main.Position = UDim2.new(0.5, -165, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(255, 225, 238)
Main.BorderSizePixel = 0
Main.Parent = GUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "♡ Berry Avenue Outfit Copier ♡"
Title.TextColor3 = Color3.fromRGB(160, 75, 110)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Position = UDim2.fromOffset(10, 48)
SelectedLabel.Size = UDim2.new(1, -20, 0, 25)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Text = "Select a player"
SelectedLabel.TextColor3 = Color3.fromRGB(130, 70, 100)
SelectedLabel.TextSize = 13
SelectedLabel.Font = Enum.Font.Gotham
SelectedLabel.Parent = Main

local List = Instance.new("ScrollingFrame")
List.Position = UDim2.fromOffset(10, 80)
List.Size = UDim2.new(1, -20, 0, 205)
List.BackgroundColor3 = Color3.fromRGB(255, 240, 247)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new()
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 9)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = List

local function refreshCanvas()
    List.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 8)
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)

local function makeButton(text, position, size, parent)
    local button = Instance.new("TextButton")
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = Color3.fromRGB(255, 190, 215)
    button.TextColor3 = Color3.fromRGB(120, 55, 85)
    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

local function refreshPlayers()
    for _, child in ipairs(List:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    SelectedPlayer = nil
    SelectedLabel.Text = "Select a player"

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = makeButton(
                player.DisplayName .. "  (@" .. player.Name .. ")",
                UDim2.new(),
                UDim2.new(1, -8, 0, 35),
                List
            )

            button.MouseButton1Click:Connect(function()
                SelectedPlayer = player
                SelectedLabel.Text = "Selected: " .. player.DisplayName
            end)
        end
    end

    refreshCanvas()
end

local Refresh = makeButton(
    "Refresh Player List",
    UDim2.fromOffset(10, 295),
    UDim2.new(1, -20, 0, 32),
    Main
)

local Copy = makeButton(
    "♡ COPY OUTFIT ♡",
    UDim2.fromOffset(10, 335),
    UDim2.new(1, -20, 0, 40),
    Main
)

Refresh.MouseButton1Click:Connect(refreshPlayers)

Copy.MouseButton1Click:Connect(function()
    if not SelectedPlayer then
        SelectedLabel.Text = "Please select a player first!"
        return
    end

    local targetCharacter = SelectedPlayer.Character
    local myCharacter = LocalPlayer.Character

    if not targetCharacter or not myCharacter then
        SelectedLabel.Text = "Character not loaded!"
        return
    end

    local targetHumanoid =
        targetCharacter:FindFirstChildOfClass("Humanoid")

    local myHumanoid =
        myCharacter:FindFirstChildOfClass("Humanoid")

    if not targetHumanoid or not myHumanoid then
        SelectedLabel.Text = "Humanoid not found!"
        return
    end

    local success, description = pcall(function()
        return targetHumanoid:GetAppliedDescription()
    end)

    if not success or not description then
        SelectedLabel.Text = "Couldn't read their appearance."
        return
    end

    local applied, errorMessage = pcall(function()
        myHumanoid:ApplyDescription(description)
    end)

    if applied then
        SelectedLabel.Text = "Appearance applied! ♡"
    else
        SelectedLabel.Text = "Couldn't apply: " .. tostring(errorMessage)
    end
end)

refreshPlayers()

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

print("Berry Avenue Outfit Copier loaded!")
