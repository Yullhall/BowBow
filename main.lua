-- Berry Avenue Outfit Copy Test
-- Local appearance test only

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- CHANGE THIS to your main account's username
local TARGET_NAME = "YOUR_MAIN_USERNAME"

local function findTarget()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower() == TARGET_NAME:lower() then
            return player
        end
    end
end

local function copyAppearance()
    local target = findTarget()

    if not target then
        warn("Target player not found!")
        return
    end

    local targetCharacter = target.Character
    local myCharacter = LocalPlayer.Character

    if not targetCharacter or not myCharacter then
        warn("One of the characters hasn't loaded.")
        return
    end

    local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local myHumanoid = myCharacter:FindFirstChildOfClass("Humanoid")

    if not targetHumanoid or not myHumanoid then
        warn("Humanoid not found.")
        return
    end

    local success, description = pcall(function()
        return targetHumanoid:GetAppliedDescription()
    end)

    if not success or not description then
        warn("Couldn't retrieve the target's appearance.")
        return
    end

    local applied, err = pcall(function()
        myHumanoid:ApplyDescription(description)
    end)

    if applied then
        print("Appearance applied locally!")
    else
        warn("Couldn't apply appearance:", err)
    end
end

copyAppearance()
