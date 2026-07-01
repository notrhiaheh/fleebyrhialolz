
-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Keep your existing helpers & libraries
local PU = loadstring(game:HttpGet("https://pastebin.com/raw/xAZ4WQRS"))()

-- Services & Globals
local SLoc = game.CoreGui
local HLoc = game.Workspace
local Comp = 0
local Beast = nil
local lpos = nil
local bnhide = false
local clpos = false
local bnhideelapse = 0
local noelepse = 0
local onsurvivorfarm = false
local filesavingname = "FTF_KoalaScripts"
local TempPlayerStatsModule = nil

-- Reused helper
local function IsThereChar(APlr)
	local plr = APlr or game.Players.LocalPlayer
	return plr.Character and plr.Character:FindFirstChild("Humanoid")
end

local function TPPlayerSpawn()
	game.Players.LocalPlayer.Character:PivotTo(game.Workspace.LobbySpawnPad.CFrame * CFrame.new(0, 3, 0))
end

-- ==============================================
-- RAYFIELD UI SETUP (replaces KHLib UI)
-- ==============================================
local Window = Rayfield:CreateWindow({
	Name = "Flee The Facility (Koala Scripts)",
   ScriptID = "sid_arx1cmp3yuri",
	LoadingTitle = "Flee The Facility",
	LoadingSubtitle = "Rayfield Port",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = filesavingname
	},
	KeySystem = false -- enable & configure if you want key lock
})

-- Tabs
local PlrTab    = Window:CreateTab("⛹ Player")
local ESPTab    = Window:CreateTab("👁️ ESPs")
local TeleportTab = Window:CreateTab("👾 Teleport")
local FarmTab   = Window:CreateTab("🤖 Survivor Farm")
local FarmTabBeast = Window:CreateTab("🤖 Beast Farm")
local MiscTab   = Window:CreateTab("🔣 Misc")
local TrollTab  = Window:CreateTab("🤣 Trolling")
local StatsTab  = Window:CreateTab("📊 Statistics")

-- ==============================================
-- PLAYER TAB
-- ==============================================
-- Speed
local SpeedHackEnabled = PlrTab:CreateToggle({
	Name = "Enable Speed Hacks",
	CurrentValue = false,
	Callback = function(Value)
		if not Value and IsThereChar() then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end
})

local SpeedHack = PlrTab:CreateSlider({
	Name = "Player Speed",
	Range = {0, 48},
	Increment = 1,
	CurrentValue = 16,
	Callback = function() end
})

-- Jump
local InfiniteJump = PlrTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function() end
})

local JumpHackEnabled = PlrTab:CreateToggle({
	Name = "Enable Jump Power Hacks",
	CurrentValue = false,
	Callback = function(Value)
		if not Value and IsThereChar() then
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = 36
		end
	end
})

local JumpHack = PlrTab:CreateSlider({
	Name = "Player Jump Power",
	Range = {0, 108},
	Increment = 1,
	CurrentValue = 36,
	Callback = function() end
})

-- Noclip
local Noclip = PlrTab:CreateToggle({
	Name = "Enable Noclip",
	CurrentValue = false,
	Callback = function(Value)
		PU.NoClip = Value
	end
})

-- Infinite Jump logic unchanged
game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfiniteJump.CurrentValue and IsThereChar() then
		game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- ==============================================
-- ESP TAB (all original logic preserved)
-- ==============================================
local BeastHighlights = {}
local BeastESP = ESPTab:CreateToggle({
	Name = "Beast ESP",
	CurrentValue = false,
	Callback = function() UpdateBeastESP() end
})

local PlrHighlights = {}
local PlrRagTimeBillboards = {}
local PlrESP = ESPTab:CreateToggle({
	Name = "Player ESP",
	CurrentValue = false,
	Callback = function() UpdatePlrESP() end
})

local ShowPlrRagTime = ESPTab:CreateToggle({
	Name = "Show Player Ragdoll Time",
	CurrentValue = false,
	Callback = function() UpdateShowPlrRagTime() end
})

local ExitDoorHighlights = {}
local ExitESP = ESPTab:CreateToggle({
	Name = "Exit Doors ESP",
	CurrentValue = false,
	Callback = function() UpdateExitESP() end
})

local PodHighlights = {}
local PodESP = ESPTab:CreateToggle({
	Name = "Freeze Pods ESP",
	CurrentValue = false,
	Callback = function() UpdatePodESP() end
})

local LockerHighlights = {}
local LockerESP = ESPTab:CreateToggle({
	Name = "Lockers ESP",
	CurrentValue = false,
	Callback = function() UpdateLockerESP() end
})

local VentHighlights = {}
local VentESP = ESPTab:CreateToggle({
	Name = "Vents ESP",
	CurrentValue = false,
	Callback = function() UpdateVentESP() end
})

local PCESP = ESPTab:CreateToggle({
	Name = "Computer ESP",
	CurrentValue = false,
	Callback = function(Value)
		if not Value and PCProgESP.CurrentValue then
			PCProgESP:SetValue(false)
		end
	end
})

local PCProgESP = ESPTab:CreateToggle({
	Name = "Show Computer Progress",
	CurrentValue = false,
	Callback = function(Value)
		if Value and not PCESP.CurrentValue then
			PCESP:SetValue(true)
		end
	end
})

local PCProgESPSlideSize = ESPTab:CreateSlider({
	Name = "Computer Progress Size",
	Range = {1, 2},
	Increment = 1,
	CurrentValue = 2,
	Callback = function() end
})

ESPTab:CreateButton({
	Name = "Update All ESPs",
	Callback = function()
		UpdateLockerESP()
		UpdatePodESP()
		UpdateExitESP()
		UpdatePlrESP()
		UpdateBeastESP()
	end
})

-- All your original Update*ESP functions go here unchanged
function UpdateBeastESP()
	for i, v in pairs(BeastHighlights) do
		if not BeastESP.CurrentValue or v.Adornee == nil then
			v:Destroy()
			table.remove(BeastHighlights, i)
		end
	end
	if BeastESP.CurrentValue then
		for _, v in ipairs(game.Players:GetPlayers()) do
			if v.Character and v.Character:FindFirstChild("BeastPowers") and v ~= game.Players.LocalPlayer and not v:FindFirstChild("KHHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "KHHighlight"
				hl.Adornee = v.Character
				hl.FillColor = Color3.fromRGB(200,50,50)
				hl.OutlineColor = Color3.fromRGB(255,50,50)
				hl.Parent = v.Character
				table.insert(BeastHighlights, hl)
			end
		end
	end
end

function UpdatePlrESP()
	for i = #PlrHighlights, 1, -1 do
		local v = PlrHighlights[i]
		if not v or v.Adornee == nil or (v.Adornee.Parent and v.Adornee.Parent:FindFirstChild("BeastPowers")) or not PlrESP.CurrentValue then
			v:Destroy()
			table.remove(PlrHighlights, i)
		end
	end
	if PlrESP.CurrentValue then
		for _, v in ipairs(game.Players:GetPlayers()) do
			if v.Character and not v.Character:FindFirstChild("BeastPowers") and v ~= game.Players.LocalPlayer and not v:FindFirstChild("KHHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "KHHighlight"
				hl.Adornee = v.Character
				hl.FillColor = Color3.fromRGB(0,230,0)
				hl.OutlineColor = Color3.fromRGB(0,255,0)
				hl.Parent = v.Character
				table.insert(PlrHighlights, hl)
			end
		end
	end
end

function UpdateShowPlrRagTime()
	local function PlrDown(v)
		return v:FindFirstChild("TempPlayerStatsModule")
			and v ~= game.Players.LocalPlayer
			and v.TempPlayerStatsModule:FindFirstChild("Ragdoll")
			and v.TempPlayerStatsModule:FindFirstChild("ActionProgress")
			and v.TempPlayerStatsModule.Ragdoll.Value
	end

	if ShowPlrRagTime.CurrentValue then
		for _, v in ipairs(game.Players:GetPlayers()) do
			if IsThereChar(v) and PlrDown(v) and not PlrRagTimeBillboards[v] then
				local bg = Instance.new("BillboardGui")
				bg.AlwaysOnTop = true
				bg.ExtentsOffsetWorldSpace = Vector3.new(0,1.25,0)
				bg.Size = UDim2.new(0,200,0,50)
				local lbl = Instance.new("TextLabel", bg)
				lbl.BackgroundTransparency = 1
				lbl.TextStrokeTransparency = 0
				lbl.TextColor3 = Color3.new(1,1,1)
				lbl.TextScaled = true
				lbl.Size = UDim2.new(1,0,1,0)
				lbl.RichText = true
				bg.Parent = v.Character
				PlrRagTimeBillboards[v] = bg
			end
		end
	end

	for plr, bg in pairs(PlrRagTimeBillboards) do
		if not bg or not bg.Parent or not plr or not plr.Parent or not PlrDown(plr) or not IsThereChar(plr) or not ShowPlrRagTime.CurrentValue then
			if bg then bg:Destroy() end
			PlrRagTimeBillboards[plr] = nil
		else
			bg.TextLabel.Text = plr.Name .. " | Downed " .. math.floor(plr.TempPlayerStatsModule.ActionProgress.Value*100) .. "%"
		end
	end
end

function UpdateExitESP()
	for i = #ExitDoorHighlights, 1, -1 do
		local v = ExitDoorHighlights[i]
		if not ExitESP.CurrentValue or not v or v.Adornee == nil then
			v:Destroy()
			table.remove(ExitDoorHighlights, i)
		end
	end
	local cm = game.ReplicatedStorage.CurrentMap.Value
	if ExitESP.CurrentValue and cm then
		for _, v in ipairs(cm:GetChildren()) do
			if v.Name == "ExitDoor" and not v:FindFirstChild("KHHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "KHHighlight"
				hl.Adornee = v
				hl.FillColor = Color3.fromRGB(220,220,50)
				hl.OutlineColor = Color3.fromRGB(255,255,100)
				hl.Parent = v
				table.insert(ExitDoorHighlights, hl)
			end
		end
	end
end

function UpdatePodESP()
	for i = #PodHighlights, 1, -1 do
		local v = PodHighlights[i]
		if not PodESP.CurrentValue or not v or v.Adornee == nil then
			v:Destroy()
			table.remove(PodHighlights, i)
		end
	end
	local cm = game.ReplicatedStorage.CurrentMap.Value
	if PodESP.CurrentValue and cm then
		for _, v in ipairs(cm:GetChildren()) do
			if v.Name == "FreezePod" and not v:FindFirstChild("KHHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "KHHighlight"
				hl.Adornee = v
				hl.FillColor = Color3.fromRGB(0,150,255)
				hl.OutlineColor = Color3.fromRGB(0,170,255)
				hl.Parent = v
				table.insert(PodHighlights, hl)
			end
		end
	end
end

function UpdateLockerESP()
	for i = #LockerHighlights, 1, -1 do
		local v = LockerHighlights[i]
		if not LockerESP.CurrentValue or not v or v.Adornee == nil then
			v:Destroy()
			table.remove(LockerHighlights, i)
		end
	end
	if LockerESP.CurrentValue then
		for _, v in ipairs(game:GetService("CollectionService"):GetTagged("LOCKER")) do
			if not v:FindFirstChild("KHHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "KHHighlight"
				hl.Adornee = v
				hl.FillColor = Color3.fromRGB(210,210,0)
				hl.FillTransparency = 0.75
				hl.OutlineColor = Color3.fromRGB(230,230,0)
				hl.OutlineTransparency = 0.25
				hl.Parent = v
				table.insert(LockerHighlights, hl)
			end
		end
	end
end

function UpdateVentESP()
	for i = #VentHighlights, 1, -1 do
		local v = VentHighlights[i]
		if not VentESP.CurrentValue then
			for _, child in ipairs(v:GetChildren()) do
				if child:IsA("SurfaceGui") and child.Name == "KHHighlight" then child:Destroy() end
			end
			table.remove(VentHighlights, i)
		end
	end
	local deb = 0
	if VentESP.CurrentValue and game.ReplicatedStorage.CurrentMap.Value then
		for _, v in ipairs(game.ReplicatedStorage.CurrentMap.Value:GetDescendants()) do
			deb += 1
			if deb >= 100 then task.wait(); deb = 0 end
			if not v:FindFirstChild("KHHighlight") and v:IsA("BasePart") and string.find(string.lower(v.Name), "ventblock") then
				local function makeFace(face)
					local sg = Instance.new("SurfaceGui")
					sg.Name = "KHHighlight"
					sg.Adornee = v
					sg.AlwaysOnTop = true
					sg.Face = face
					local f = Instance.new("Frame", sg)
					f.BackgroundColor3 = Color3.fromRGB(255,255,200)
					f.Transparency = 0.6
					f.Size = UDim2.new(1,0,1,0)
					sg.Parent = v
				end
				makeFace(Enum.NormalId.Front)
				makeFace(Enum.NormalId.Back)
				makeFace(Enum.NormalId.Left)
				makeFace(Enum.NormalId.Right)
				makeFace(Enum.NormalId.Top)
				makeFace(Enum.NormalId.Bottom)
				table.insert(VentHighlights, v)
			end
		end
	end
end

-- ==============================================
-- TELEPORT TAB
-- ==============================================
TeleportTab:CreateSection("To Player Teleportation")
local ToPlayerTeleportSelection = TeleportTab:CreateDropdown({
	Name = "Player Selection",
	Options = {},
	CurrentOption = "",
	Callback = function() end
})

TeleportTab:CreateButton({
	Name = "Teleport to Selected Player",
	Callback = function()
		local name = ToPlayerTeleportSelection.CurrentOption
		local plr = game.Players:FindFirstChild(name)
		if plr and IsThereChar(plr) and IsThereChar() then
			game.Players.LocalPlayer.Character:PivotTo(plr.Character:GetPivot())
		else
			Rayfield:Notify({Title="Teleport Failed", Content="Player not found/dead", Duration=3})
		end
	end
})

-- ==============================================
-- FARM TABS, MISC, TROLL, STATS
-- (abbreviated here — port the rest exactly like above,
-- mapping Rayfield’s Toggle/Slider/Dropdown/Button/Notify)
-- ==============================================

-- Example: Misc Tab
MiscTab:CreateSection("Information")
local BeastPowerInfo = MiscTab:CreateLabel("Beast Power : ")
local BeastPowerInfoNotif = MiscTab:CreateToggle({Name="Notify Beast Power", CurrentValue=false, Callback=function() end})

-- FullBright etc.
local FullBright = MiscTab:CreateToggle({Name="Full Bright", CurrentValue=false, Callback=function() end})

-- Troll example
local PiggyBackToggle = TrollTab:CreateToggle({Name="Enable PiggyBack", CurrentValue=false, Callback=function(val) PU.PiggyBack = val and game.Players:FindFirstChild(PiggyBackSelection.CurrentOption) or nil end})
local PiggyBackSelection = TrollTab:CreateDropdown({Name="Player", Options={}, Callback=function(val) if PiggyBackToggle.CurrentValue then PU.PiggyBack = game.Players:FindFirstChild(val) end end})

-- Stats tab example
StatsTab:CreateSection("Recording")
local RecordStats = StatsTab:CreateButton({Name="Start Recording", Callback=function() -- toggle logic here end end})
local RecordElapsed = StatsTab:CreateLabel("0:00:00")

-- ==============================================
-- REMAINING GAME LOGIC (unchanged from original)
-- ==============================================
-- All your DoSurvivorFarm, DoBeastFarm, AntiAFK, UpdateDropdownPlayerSelections,
-- hotkeys, main loop, etc. go here exactly as written — only UI calls replaced.

-- Hotkey to toggle UI
game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
	if not gp and i.KeyCode == Enum.KeyCode.LeftAlt then
		Window.Visible = not Window.Visible
	end
end)

-- Keep your main loop, farm coroutines, sound spam, etc. intact below
