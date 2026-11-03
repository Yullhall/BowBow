-- BERRY AVENUE PLAYER OUTFIT TEST
-- Local-only test; does not bypass server restrictions.

local Players = game:GetService("Players")
local me = Players.LocalPlayer

local old = me.PlayerGui:FindFirstChild("BerryTest")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "BerryTest"
gui.ResetOnSpawn = false
gui.Parent = me:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(320, 350)
frame.Position = UDim2.new(0.5, -160, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local function label(text, pos, size, parent)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.Position = pos
    l.Size = size
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(130, 55, 90)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 15
    l.Parent = parent
    return l
end

label("♡ OUTFIT COPIER ♡", UDim2.fromOffset(5, 5),
    UDim2.new(1, -10, 0, 35), frame)

local status = label("Choose a player", UDim2.fromOffset(10, 40),
    UDim2.new(1, -20, 0, 25), frame)

local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(10, 75)
list.Size = UDim2.new(1, -20, 0, 190)
list.BackgroundColor3 = Color3.fromRGB(255, 240, 247)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = list

local selected

local function button(text, pos, size)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(255, 180, 210)
    b.TextColor3 = Color3.fromRGB(110, 45, 75)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local function refresh()
    selected = nil
    status.Text = "Choose a player"

    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= me then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -5, 0, 32)
            b.BackgroundColor3 = Color3.fromRGB(255, 210, 230)
            b.TextColor3 = Color3.fromRGB(110, 45, 75)
            b.Font = Enum.Font.Gotham
            b.TextSize = 13
            b.Text = player.DisplayName .. "  (@" .. player.Name .. ")"
            b.Parent = list

            b.MouseButton1Click:Connect(function()
                selected = player
                status.Text = "Selected: " .. player.Name
            end)
        end
    end

    task.wait()
    list.CanvasSize = UDim2.fromOffset(
        0, layout.AbsoluteContentSize.Y + 5
    )
end

local refreshButton = button(
    "REFRESH PLAYERS",
    UDim2.fromOffset(10, 275),
    UDim2.new(1, -20, 0, 28)
)

local copyButton = button(
    "♡ COPY OUTFIT ♡",
    UDim2.fromOffset(10, 310),
    UDim2.new(1, -20, 0, 32)
)

refreshButton.MouseButton1Click:Connect(refresh)

copyButton.MouseButton1Click:Connect(function()
    if not selected then
        status.Text = "Select someone first!"
        return
    end

    local target = selected.Character
    local mine = me.Character

    if not target or not mine then
        status.Text = "Character not loaded!"
        return
    end

    local th = target:FindFirstChildOfClass("Humanoid")
    local mh = mine:FindFirstChildOfClass("Humanoid")

    if not th or not mh then
        status.Text = "Humanoid missing!"
        return
    end

    local ok, result = pcall(function()
        local description = th:GetAppliedDescription()
        mh:ApplyDescription(description)
    end)

    if ok then
        status.Text = "Applied locally! ♡"
    else
        status.Text = "Error: " .. tostring(result)
        warn(result)
    end
end)

refresh()
