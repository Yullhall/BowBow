--[[\
    Berry Avenue Outfit Inspector & Manager (Native Editor & Anti-Kick Safe)
]]--

-- Anti-Kick / Anti-Ban Metatable Hook to prevent server drops
pcall(function()
	local mt = getrawmetatable(game)
	setreadonly(mt, false)
	local oldNamecall = mt.__namecall
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if tostring(self):lower() == "kick" or method == "Kick" then
			return nil
		end
		return oldNamecall(self, ...)
	end)
	setreadonly(mt, true)
end)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local PlayersService = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if not getgenv().BerryAvenueSavedOutfits then
	getgenv().BerryAvenueSavedOutfits = {}
end
local savedOutfits = getgenv().BerryAvenueSavedOutfits

local function copyToClipboard(text)
	if setclipboard then
		setclipboard(tostring(text))
	end
end

if PlayerGui:FindFirstChild("OutfitManagerGUI") then
	PlayerGui.OutfitManagerGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OutfitManagerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 460, 0, 380)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 225, 235)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Color3.fromRGB(255, 205, 220)
title.TextColor3 = Color3.fromRGB(110, 60, 75)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.Text = "✨ Berry Avenue Outfit Inspector ✨"
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 26)
minimizeButton.Position = UDim2.new(1, -34, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 195)
minimizeButton.TextColor3 = Color3.fromRGB(110, 60, 75)
minimizeButton.TextSize = 12
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "-"
minimizeButton.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeButton

local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 45, 0, 45)
minButton.Position = UDim2.new(0, 20, 0, 20)
minButton.BackgroundColor3 = Color3.fromRGB(255, 205, 220)
minButton.TextColor3 = Color3.fromRGB(110, 60, 75)
minButton.TextSize = 20
minButton.Font = Enum.Font.GothamBold
minButton.Text = "🎀"
minButton.Visible = false
minButton.Active = true
minButton.Draggable = true
minButton.Parent = screenGui

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(1, 0)
minBtnCorner.Parent = minButton

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0, 150, 0, 22)
refreshButton.Position = UDim2.new(0, 10, 0, 42)
refreshButton.BackgroundColor3 = Color3.fromRGB(255, 180, 200)
refreshButton.TextColor3 = Color3.fromRGB(110, 60, 75)
refreshButton.TextSize = 10
refreshButton.Font = Enum.Font.GothamBold
refreshButton.Text = "🔄 Refresh Players"
refreshButton.Parent = mainFrame

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 6)
refreshCorner.Parent = refreshButton

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0, 150, 0, 272)
playerListFrame.Position = UDim2.new(0, 10, 0, 68)
playerListFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
playerListFrame.BorderSizePixel = 0
playerListFrame.Parent = mainFrame

local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 8)
playerListCorner.Parent = playerListFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Padding = UDim.new(0, 4)
playerListLayout.Parent = playerListFrame

local equipAllInspectedBtn = Instance.new("TextButton")
equipAllInspectedBtn.Size = UDim2.new(0, 150, 0, 26)
equipAllInspectedBtn.Position = UDim2.new(0, 10, 0, 344)
equipAllInspectedBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 220)
equipAllInspectedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
equipAllInspectedBtn.TextSize = 10
equipAllInspectedBtn.Font = Enum.Font.GothamBold
equipAllInspectedBtn.Text = "✨ Equip All Items"
equipAllInspectedBtn.Parent = mainFrame

local equipAllInspectedCorner = Instance.new("UICorner")
equipAllInspectedCorner.CornerRadius = UDim.new(0, 6)
equipAllInspectedCorner.Parent = equipAllInspectedBtn

local viewModeButton = Instance.new("TextButton")
viewModeButton.Size = UDim2.new(0, 280, 0, 22)
viewModeButton.Position = UDim2.new(0, 170, 0, 42)
viewModeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 200)
viewModeButton.TextColor3 = Color3.fromRGB(110, 60, 75)
viewModeButton.TextSize = 10
viewModeButton.Font = Enum.Font.GothamBold
viewModeButton.Text = "📂 View Saved Outfits (" .. #savedOutfits .. ")"
viewModeButton.Parent = mainFrame

local viewModeCorner = Instance.new("UICorner")
viewModeCorner.CornerRadius = UDim.new(0, 6)
viewModeCorner.Parent = viewModeButton

local avatarViewport = Instance.new("ViewportFrame")
avatarViewport.Size = UDim2.new(0, 280, 0, 90)
avatarViewport.Position = UDim2.new(0, 170, 0, 68)
avatarViewport.BackgroundColor3 = Color3.fromRGB(255, 235, 242)
avatarViewport.BorderSizePixel = 0
avatarViewport.Parent = mainFrame

local viewportCorner = Instance.new("UICorner")
viewportCorner.CornerRadius = UDim.new(0, 8)
viewportCorner.Parent = avatarViewport

local previewStatusLabel = Instance.new("TextLabel")
previewStatusLabel.Size = UDim2.new(1, -10, 1, -10)
previewStatusLabel.Position = UDim2.new(0, 5, 0, 5)
previewStatusLabel.BackgroundTransparency = 1
previewStatusLabel.TextColor3 = Color3.fromRGB(140, 70, 90)
previewStatusLabel.TextSize = 11
previewStatusLabel.Font = Enum.Font.GothamMedium
previewStatusLabel.TextWrapped = true
previewStatusLabel.Text = ""
previewStatusLabel.Visible = false
previewStatusLabel.Parent = avatarViewport

local detailsFrame = Instance.new("ScrollingFrame")
detailsFrame.Size = UDim2.new(0, 280, 0, 175)
detailsFrame.Position = UDim2.new(0, 170, 0, 162)
detailsFrame.BackgroundColor3 = Color3.fromRGB(255, 240, 245)
detailsFrame.BorderSizePixel = 0
detailsFrame.Parent = mainFrame

local detailsCorner = Instance.new("UICorner")
detailsCorner.CornerRadius = UDim.new(0, 8)
detailsCorner.Parent = detailsFrame

local detailsLayout = Instance.new("UIListLayout")
detailsLayout.SortOrder = Enum.SortOrder.LayoutOrder
detailsLayout.Padding = UDim.new(0, 4)
detailsLayout.Parent = detailsFrame

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 136, 0, 28)
saveButton.Position = UDim2.new(0, 170, 0, 342)
saveButton.BackgroundColor3 = Color3.fromRGB(255, 150, 180)
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextSize = 10
saveButton.Font = Enum.Font.GothamBold
saveButton.Text = "💖 Save Outfit"
saveButton.Parent = mainFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 6)
saveCorner.Parent = saveButton

local unequipAllButton = Instance.new("TextButton")
unequipAllButton.Size = UDim2.new(0, 138, 0, 28)
unequipAllButton.Position = UDim2.new(0, 312, 0, 342)
unequipAllButton.BackgroundColor3 = Color3.fromRGB(230, 120, 150)
unequipAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
unequipAllButton.TextSize = 10
unequipAllButton.Font = Enum.Font.GothamBold
unequipAllButton.Text = "🧹 Unequip All"
unequipAllButton.Parent = mainFrame

local unequipAllCorner = Instance.new("UICorner")
unequipAllCorner.CornerRadius = UDim.new(0, 6)
unequipAllCorner.Parent = unequipAllButton

local selectedPlayerItems = {}
local currentSelectedPlayer = nil
local showingSavedOutfitsMenu = false

local function updateAvatarPreview(targetPlayer)
	for _, child in ipairs(avatarViewport:GetChildren()) do
		if child:IsA("Model") or child:IsA("Camera") or child:IsA("WorldModel") then
			child:Destroy()
		end
	end

	if not targetPlayer or not targetPlayer.Character then
		previewStatusLabel.Text = "⚠️ Character not loaded"
		previewStatusLabel.Visible = true
		return
	end

	local head = targetPlayer.Character:FindFirstChild("Head")
	local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or head

	if targetHRP and head then
		local worldModel = Instance.new("WorldModel")
		worldModel.Parent = avatarViewport
		
		targetPlayer.Character.Archivable = true
		local charClone = targetPlayer.Character:Clone()
		targetPlayer.Character.Archivable = false
		charClone.Parent = worldModel

		local camera = Instance.new("Camera")
		camera.CFrame = CFrame.new(head.Position + (head.CFrame.LookVector * 3.5) + Vector3.new(0, 0.2, 0), head.Position + Vector3.new(0, -0.2, 0))
		camera.Parent = avatarViewport
		avatarViewport.CurrentCamera = camera
		previewStatusLabel.Visible = false
	end
end

local function extractAssetId(str)
	if type(str) == "number" and str > 0 then return str end
	if type(str) == "string" then
		local id = str:match("%d+")
		if id and tonumber(id) > 0 then
			return tonumber(id)
		end
	end
	return nil
end

local function getPlayerOutfit(targetPlayer)
	local items = {}
	if targetPlayer and targetPlayer.Character then
		local bodyColors = targetPlayer.Character:FindFirstChildOfClass("BodyColors")
		if bodyColors then
			table.insert(items, {
				Name = "Skin Tone / Body Colors",
				ID = "SkinTone",
				Type = "BodyColors",
				Object = bodyColors:Clone(),
				IsUnknown = false
			})
		end

		for _, child in ipairs(targetPlayer.Character:GetChildren()) do
			if child:IsA("MeshPart") and child.Name ~= "HumanoidRootPart" then
				local meshId = extractAssetId(child.MeshId)
				table.insert(items, {
					Name = child.Name .. " Part",
					ID = meshId or "ID Unknown",
					Type = "BodyPart",
					Object = child:Clone(),
					IsUnknown = (meshId == nil)
				})
			end
		end

		for _, child in ipairs(targetPlayer.Character:GetDescendants()) do
			if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") then
				local assetId = nil
				if child:IsA("Accessory") then
					assetId = extractAssetId(child:GetAttribute("AssetId") or child:GetAttribute("Id"))
					if not assetId then
						local handle = child:FindFirstChild("Handle")
						if handle then
							for _, mesh in ipairs(handle:GetChildren()) do
								if mesh:IsA("SpecialMesh") or mesh:IsA("MeshPart") then
									assetId = extractAssetId(mesh.MeshId)
									if assetId then break end
								end
							end
						end
					end
				elseif child:IsA("Shirt") then
					assetId = extractAssetId(child.ShirtTemplate)
				elseif child:IsA("Pants") then
					assetId = extractAssetId(child.PantsTemplate)
				end

				table.insert(items, {
					Name = child.Name, 
					ID = assetId or "ID Unknown", 
					Type = child.ClassName, 
					Object = child:Clone(),
					IsUnknown = (assetId == nil)
				})
			end
		end
	end
	
	if #items == 0 then
		table.insert(items, {Name = "Custom Rig / No Items", ID = "ID Unknown", Type = "None", IsUnknown = true})
	end
	
	return items
end

-- Secure Editor & Container Sync Function
local function equipItemNativeSync(itemInfo)
	if not LocalPlayer.Character then return end
	local char = LocalPlayer.Character

	if itemInfo.Type == "BodyColors" then
		local oldColors = char:FindFirstChildOfClass("BodyColors")
		if oldColors then oldColors:Destroy() end
		if itemInfo.Object then itemInfo.Object:Clone().Parent = char end
	elseif itemInfo.Type == "Shirt" then
		for _, v in ipairs(char:GetChildren()) do if v:IsA("Shirt") then v:Destroy() end end
		if itemInfo.Object then itemInfo.Object:Clone().Parent = char end
	elseif itemInfo.Type == "Pants" then
		for _, v in ipairs(char:GetChildren()) do if v:IsA("Pants") then v:Destroy() end end
		if itemInfo.Object then itemInfo.Object:Clone().Parent = char end
	elseif itemInfo.Type == "BodyPart" then
		if itemInfo.Object then
			local existing = char:FindFirstChild(itemInfo.Object.Name)
			if existing and existing:IsA("MeshPart") then
				existing.MeshId = itemInfo.Object.MeshId
				existing.Color = itemInfo.Object.Color
				existing.Material = itemInfo.Object.Material
				existing.Size = itemInfo.Object.Size
			end
		end
	elseif itemInfo.Type == "Accessory" or itemInfo.Type == "Model" then
		if itemInfo.Object then
			local clone = itemInfo.Object:Clone()
			local handle = clone:FindFirstChild("Handle")
			if handle then
				handle.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				handle.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				for _, w in ipairs(handle:GetChildren()) do
					if w:IsA("Weld") or w:IsA("WeldConstraint") or w:IsA("Motor6D") then w:Destroy() end
				end
			end
			clone.Parent = char
		end
	end
end

local function displayItems(items)
	for _, child in ipairs(detailsFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	
	selectedPlayerItems = items

	for _, itemInfo in ipairs(items) do
		local itemRow = Instance.new("Frame")
		itemRow.Size = UDim2.new(1, -6, 0, 48)
		itemRow.BackgroundColor3 = itemInfo.IsUnknown and Color3.fromRGB(255, 210, 215) or Color3.fromRGB(255, 220, 230)
		itemRow.Parent = detailsFrame

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = itemRow

		local imgFrame = Instance.new("Frame")
		imgFrame.Size = UDim2.new(0, 36, 0, 36)
		imgFrame.Position = UDim2.new(0, 5, 0.5, -18)
		imgFrame.BackgroundColor3 = Color3.fromRGB(255, 245, 250)
		imgFrame.BorderSizePixel = 0
		imgFrame.Parent = itemRow

		local imgCorner = Instance.new("UICorner")
		imgCorner.CornerRadius = UDim.new(0, 5)
		imgCorner.Parent = imgFrame

		local itemImg = Instance.new("ImageLabel")
		itemImg.Size = UDim2.new(1, -2, 1, -2)
		itemImg.Position = UDim2.new(0, 1, 0, 1)
		itemImg.BackgroundTransparency = 1
		itemImg.Parent = imgFrame

		if itemInfo.Type == "BodyColors" then
			itemImg:Destroy()
			local placeholderLabel = Instance.new("TextLabel")
			placeholderLabel.Size = UDim2.new(1, 0, 1, 0)
			placeholderLabel.BackgroundTransparency = 1
			placeholderLabel.Text = "🎨"
			placeholderLabel.TextSize = 16
			placeholderLabel.Parent = imgFrame
		elseif itemInfo.Type == "BodyPart" then
			itemImg:Destroy()
			local placeholderLabel = Instance.new("TextLabel")
			placeholderLabel.Size = UDim2.new(1, 0, 1, 0)
			placeholderLabel.BackgroundTransparency = 1
			placeholderLabel.Text = "👤"
			placeholderLabel.TextSize = 16
			placeholderLabel.Parent = imgFrame
		elseif not itemInfo.IsUnknown and itemInfo.ID and itemInfo.ID ~= "ID Unknown" then
			itemImg.Image = "rbxthumb://type=Asset&id=" .. tostring(itemInfo.ID) .. "&w=150&h=150"
		else
			local directImage = ""
			if itemInfo.Object then
				if itemInfo.Object:IsA("Shirt") then
					directImage = itemInfo.Object.ShirtTemplate
				elseif itemInfo.Object:IsA("Pants") then
					directImage = itemInfo.Object.PantsTemplate
				elseif itemInfo.Object:IsA("Accessory") then
					local handle = itemInfo.Object:FindFirstChild("Handle")
					if handle then
						local decal = handle:FindFirstChildWhichIsA("Decal") or handle:FindFirstChildWhichIsA("Texture")
						if decal then directImage = decal.Texture end
					end
				end
			end

			if directImage ~= "" then
				itemImg.Image = directImage
			else
				itemImg:Destroy()
				local placeholderLabel = Instance.new("TextLabel")
				placeholderLabel.Size = UDim2.new(1, 0, 1, 0)
				placeholderLabel.BackgroundTransparency = 1
				placeholderLabel.Text = "🎀"
				placeholderLabel.TextSize = 16
				placeholderLabel.Parent = imgFrame
			end
		end

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0, 160, 0, 14)
		nameLabel.Position = UDim2.new(0, 46, 0, 4)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = itemInfo.IsUnknown and Color3.fromRGB(150, 40, 50) or Color3.fromRGB(90, 50, 65)
		nameLabel.TextSize = 10
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.Text = itemInfo.Name
		nameLabel.Parent = itemRow

		local creatorLabel = Instance.new("TextLabel")
		creatorLabel.Size = UDim2.new(0, 160, 0, 12)
		creatorLabel.Position = UDim2.new(0, 46, 0, 18)
		creatorLabel.BackgroundTransparency = 1
		creatorLabel.TextColor3 = Color3.fromRGB(120, 80, 95)
		creatorLabel.TextSize = 8
		creatorLabel.Font = Enum.Font.GothamMedium
		creatorLabel.TextXAlignment = Enum.TextXAlignment.Left
		creatorLabel.TextTruncate = Enum.TextTruncate.AtEnd
		creatorLabel.Text = (itemInfo.Type == "BodyColors" or itemInfo.Type == "BodyPart") and "Avatar Customization" or (itemInfo.IsUnknown and "Creator: Game Asset" or "Creator: Loading...")
		creatorLabel.Parent = itemRow

		local idLabel = Instance.new("TextLabel")
		idLabel.Size = UDim2.new(0, 160, 0, 12)
		idLabel.Position = UDim2.new(0, 46, 0, 30)
		idLabel.BackgroundTransparency = 1
		idLabel.TextColor3 = Color3.fromRGB(140, 90, 105)
		idLabel.TextSize = 8
		idLabel.Font = Enum.Font.Gotham
		idLabel.TextXAlignment = Enum.TextXAlignment.Left
		idLabel.Text = "ID: " .. tostring(itemInfo.ID)
		idLabel.Parent = itemRow

		if not itemInfo.IsUnknown and itemInfo.ID and itemInfo.ID ~= "ID Unknown" and itemInfo.Type ~= "BodyColors" and itemInfo.Type ~= "BodyPart" then
			task.spawn(function()
				local success, info = pcall(function()
					return MarketplaceService:GetProductInfo(tonumber(itemInfo.ID), Enum.InfoType.Asset)
				end)
				if success and info and info.Creator then
					creatorLabel.Text = "By: " .. tostring(info.Creator.Name)
				else
					creatorLabel.Text = "By: Unknown"
				end
			end)
		end

		local equipBtn = Instance.new("TextButton")
		equipBtn.Size = UDim2.new(0, 60, 0, 30)
		equipBtn.Position = UDim2.new(1, -65, 0.5, -15)
		equipBtn.BackgroundColor3 = itemInfo.IsUnknown and Color3.fromRGB(220, 110, 130) or Color3.fromRGB(255, 165, 195)
		equipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		equipBtn.TextSize = 10
		equipBtn.Font = Enum.Font.GothamBold
		equipBtn.Text = "✨ Equip"
		equipBtn.Parent = itemRow

		local equipCorner = Instance.new("UICorner")
		equipCorner.CornerRadius = UDim.new(0, 6)
		equipCorner.Parent = equipBtn

		equipBtn.MouseButton1Click:Connect(function()
			equipItemNativeSync(itemInfo)
			equipBtn.Text = "Synced!"
			task.delay(1.5, function()
				if equipBtn and equipBtn.Parent then equipBtn.Text = "✨ Equip" end
			end)
		end)
	end
	
	detailsFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 52)
end

local function displaySavedOutfitsMenu()
	for _, child in ipairs(detailsFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	if #savedOutfits == 0 then
		local emptyLabel = Instance.new("TextLabel")
		emptyLabel.Size = UDim2.new(1, 0, 1, 0)
		emptyLabel.BackgroundTransparency = 1
		emptyLabel.TextColor3 = Color3.fromRGB(140, 80, 100)
		emptyLabel.TextSize = 11
		emptyLabel.Font = Enum.Font.GothamMedium
		emptyLabel.Text = "No saved outfits.\nInspect a player and tap '💖 Save Outfit'!"
		emptyLabel.Parent = detailsFrame
		return
	end

	for index, outfitData in ipairs(savedOutfits) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -6, 0, 40)
		row.BackgroundColor3 = Color3.fromRGB(255, 220, 230)
		row.Parent = detailsFrame

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = row

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0, 110, 1, 0)
		nameLabel.Position = UDim2.new(0, 6, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(90, 50, 65)
		nameLabel.TextSize = 10
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.Text = outfitData.Title or ("Outfit #" .. index)
		nameLabel.Parent = row

		local deleteBtn = Instance.new("TextButton")
		deleteBtn.Size = UDim2.new(0, 48, 0, 22)
		deleteBtn.Position = UDim2.new(1, -52, 0.5, -11)
		deleteBtn.BackgroundColor3 = Color3.fromRGB(230, 100, 120)
		deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		deleteBtn.TextSize = 9
		deleteBtn.Font = Enum.Font.GothamBold
		deleteBtn.Text = "🗑️ Del"
		deleteBtn.Parent = row

		local delCorner = Instance.new("UICorner")
		delCorner.CornerRadius = UDim.new(0, 4)
		delCorner.Parent = deleteBtn

		deleteBtn.MouseButton1Click:Connect(function()
			table.remove(savedOutfits, index)
			viewModeButton.Text = showingSavedOutfitsMenu and "🔍 Back to Inspector" or ("📂 View Saved Outfits (" .. #savedOutfits .. ")")
			displaySavedOutfitsMenu()
		end)

		local equipAllSavedBtn = Instance.new("TextButton")
		equipAllSavedBtn.Size = UDim2.new(0, 58, 0, 22)
		equipAllSavedBtn.Position = UDim2.new(1, -114, 0.5, -11)
		equipAllSavedBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 220)
		equipAllSavedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		equipAllSavedBtn.TextSize = 9
		equipAllSavedBtn.Font = Enum.Font.GothamBold
		equipAllSavedBtn.Text = "✨ Equip"
		equipAllSavedBtn.Parent = row

		equipAllSavedBtn.MouseButton1Click:Connect(function()
			if outfitData.Items then
				task.spawn(function()
					for _, item in ipairs(outfitData.Items) do
						equipItemNativeSync(item)
						task.wait(0.12)
					end
				end)
				equipAllSavedBtn.Text = "Synced!"
				task.delay(1.5, function()
					if equipAllSavedBtn and equipAllSavedBtn.Parent then equipAllSavedBtn.Text = "✨ Equip" end
				end)
			end
		end)
	end

	detailsFrame.CanvasSize = UDim2.new(0, 0, 0, #savedOutfits * 44)
end

local function refreshPlayerList()
	for _, child in ipairs(playerListFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local playersList = Players:GetPlayers()
	for _, p in ipairs(playersList) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -6, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(255, 220, 230)
			btn.TextColor3 = Color3.fromRGB(90, 50, 65)
			btn.TextSize = 10
			btn.Font = Enum.Font.GothamMedium
			btn.Text = p.Name
			btn.TextTruncate = Enum.TextTruncate.AtEnd
			btn.Parent = playerListFrame

			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 5)
			btnCorner.Parent = btn

			btn.MouseButton1Click:Connect(function()
				showingSavedOutfitsMenu = false
				viewModeButton.Text = "📂 View Saved Outfits (" .. #savedOutfits .. ")"
				currentSelectedPlayer = p
				updateAvatarPreview(p)
				local items = getPlayerOutfit(p)
				displayItems(items)
			end)
		end
	end
	playerListFrame.CanvasSize = UDim2.new(0, 0, 0, #playersList * 34)
end

equipAllInspectedBtn.MouseButton1Click:Connect(function()
	if #selectedPlayerItems > 0 then
		task.spawn(function()
			for _, item in ipairs(selectedPlayerItems) do
				equipItemNativeSync(item)
				task.wait(0.12)
			end
		end)
		equipAllInspectedBtn.Text = "Synced All! ✨"
		task.delay(1.5, function()
			if equipAllInspectedBtn and equipAllInspectedBtn.Parent then equipAllInspectedBtn.Text = "✨ Equip All Items" end
		end)
	end
end)

viewModeButton.MouseButton1Click:Connect(function()
	showingSavedOutfitsMenu = not showingSavedOutfitsMenu
	if showingSavedOutfitsMenu then
		viewModeButton.Text = "🔍 Back to Inspector"
		displaySavedOutfitsMenu()
	else
		viewModeButton.Text = "📂 View Saved Outfits (" .. #savedOutfits .. ")"
		if currentSelectedPlayer then
			displayItems(getPlayerOutfit(currentSelectedPlayer))
		end
	end
end)

minimizeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	minButton.Visible = true
	minButton.Position = mainFrame.Position
end)

minButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	minButton.Visible = false
end)

refreshButton.MouseButton1Click:Connect(refreshPlayerList)
refreshPlayerList()

saveButton.MouseButton1Click:Connect(function()
	if #selectedPlayerItems > 0 then
		local outfitTitle = currentSelectedPlayer and (currentSelectedPlayer.Name .. "'s Outfit") or ("Outfit #" .. (#savedOutfits + 1))
		
		local cleanItems = {}
		for _, item in ipairs(selectedPlayerItems) do
			table.insert(cleanItems, {
				Name = item.Name,
				ID = item.ID,
				Type = item.Type,
				Object = item.Object
			})
		end

		table.insert(savedOutfits, {
			Title = outfitTitle,
			Items = cleanItems
		})
		
		viewModeButton.Text = showingSavedOutfitsMenu and "🔍 Back to Inspector" or ("📂 View Saved Outfits (" .. #savedOutfits .. ")")
		saveButton.Text = "Saved! 💖"
		task.delay(1.5, function()
			if saveButton and saveButton.Parent then saveButton.Text = "💖 Save Outfit" end
		end)
	end
end)

unequipAllButton.MouseButton1Click:Connect(function()
	if LocalPlayer.Character then
		for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
			if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") or v:IsA("Clothing") then
				v:Destroy()
			end
		end
		unequipAllButton.Text = "Stripped! ✨"
		task.delay(1.5, function()
			if unequipAllButton and unequipAllButton.Parent then unequipAllButton.Text = "🧹 Unequip All" end
		end)
	end
end)
