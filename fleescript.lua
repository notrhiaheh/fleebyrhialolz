local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

local Window = Luna:CreateWindow({
    Name = "FleeTheFanny", -- This Is Title Of Your Window
    Subtitle = nil, -- A Gray Subtitle next To the main title.
    LogoID = "82795327169782", -- The Asset ID of your logo. Set to nil if you do not have a logo for Luna to use.
    LoadingEnabled = true, -- Whether to enable the loading animation. Set to false if you do not want the loading screen or have your own custom one.
    LoadingTitle = "FleeTheFanny", -- Header for loading screen
    LoadingSubtitle = "by MoreWorks", -- Subtitle for loading screen

    ConfigSettings = {
        RootFolder = nil, -- The Root Folder Is Only If You Have A Hub With Multiple Game Scripts and u may remove it. DO NOT ADD A SLASH
        ConfigFolder = "Big Hub" -- The Name Of The Folder Where Luna Will Store Configs For This Script. DO NOT ADD A SLASH
    },

    KeySystem = false, -- As Of Beta 6, Luna Has officially Implemented A Key System!
    KeySettings = {
        Title = "Luna Example Key",
        Subtitle = "Key System",
        Note = "Best Key System Ever! Also, Please Use A HWID Keysystem like Pelican, Luarmor etc. that provide key strings based on your HWID since putting a simple string is very easy to bypass",
        SaveInRoot = false, -- Enabling will save the key in your RootFolder (YOU MUST HAVE ONE BEFORE ENABLING THIS OPTION)
        SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
        Key = {"Example Key"}, -- List of keys that will be accepted by the system, please use a system like Pelican or Luarmor that provide key strings based on your HWID since putting a simple string is very easy to bypass
        SecondAction = {
            Enabled = true, -- Set to false if you do not want a second action,
            Type = "Link", -- Link / Discord.
            Parameter = "" -- If Type is Discord, then put your invite link (DO NOT PUT DISCORD.GG/). Else, put the full link of your key system here.
        }
    }
})
local Tab = Window:CreateTab({
    Name = "Player",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true -- This will determine whether the big header text in the tab will show
})
function IsThereChar(APlr) 	local plr = APlr or game.Players.LocalPlayer 	if plr.Character and plr.Character:FindFirstChild("Humanoid") then 		return true 	end 	return false end function TPPlayerSpawn() 	game.Players.LocalPlayer.Character:PivotTo(game.Workspace.LobbySpawnPad.CFrame * CFrame.new(0, 3, 0)) end

local Toggle = Tab:CreateToggle({
    Name = "Speed Hacks",
    Description = Enable Speed Hacks,
    CurrentValue = false,
    Callback = function(Value)
        -- The function that takes place when the toggle is switched
        -- The variable (Value) is a boolean on whether the toggle is true or false
    end
}, "Toggle") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps

local Toggle = Tab:CreateToggle({
    Name = "Speed",
    Description = nil,
    CurrentValue = 16,
    Callback = function(Value)
        -- The function that takes place when the toggle is switched
        -- The variable (Value) is a boolean on whether the toggle is true or false
    end
}, "Toggle") -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
