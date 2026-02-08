local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Players = game:GetService("Players")  
local Player = Players.LocalPlayer  
local GuiService = game:GetService("GuiService")  
local UserInputService = game:GetService("UserInputService")  
local ReplicatedStorage = game:GetService("ReplicatedStorage")  
local RunService = game:GetService("RunService")  
local TweenService = game:GetService("TweenService")

local LoadingScreen = Instance.new("ScreenGui")  
LoadingScreen.Parent = game.CoreGui  
LoadingScreen.Name = "SeraphinLoading"  
LoadingScreen.IgnoreGuiInset = true  
  
local Background = Instance.new("Frame")  
Background.Size = UDim2.new(1, 0, 1, 0)  
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
Background.Parent = LoadingScreen  
  
local Title = Instance.new("TextLabel")  
Title.Size = UDim2.new(0.5, 0, 0.1, 0)  
Title.Position = UDim2.new(0.25, 0, 0.4, 0)  
Title.BackgroundTransparency = 1  
Title.Text = "KirsiaSC artificial bypass"  
Title.TextColor3 = Color3.fromRGB(88, 108, 179)  
Title.TextScaled = true  
Title.Font = Enum.Font.SourceSansBold  
Title.Parent = Background  
  
local DiscordLink = Instance.new("TextLabel")  
DiscordLink.Size = UDim2.new(0.5, 0, 0.05, 0)  
DiscordLink.Position = UDim2.new(0.25, 0, 0.5, 0)  
DiscordLink.BackgroundTransparency = 1  
DiscordLink.Text = "discord.gg/getseraphin"  
DiscordLink.TextColor3 = Color3.fromRGB(255, 255, 255)  
DiscordLink.TextScaled = true  
DiscordLink.Font = Enum.Font.SourceSans  
DiscordLink.Parent = Background  
  
local function showLoading()  
    Background.BackgroundTransparency = 1  
    Title.TextTransparency = 1  
    DiscordLink.TextTransparency = 1  
    LoadingScreen.Enabled = true  
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In)  
    TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 0}):Play()  
    TweenService:Create(Title, tweenInfo, {TextTransparency = 0}):Play()  
    TweenService:Create(DiscordLink, tweenInfo, {TextTransparency = 0}):Play()  
    task.wait(3)  
    local fadeOut = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)  
    TweenService:Create(Background, fadeOut, {BackgroundTransparency = 1}):Play()  
    TweenService:Create(Title, fadeOut, {TextTransparency = 1}):Play()  
    TweenService:Create(DiscordLink, fadeOut, {TextTransparency = 1}):Play()  
    task.wait(1)  
    LoadingScreen.Enabled = false  
end  
  
showLoading()

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://135748028632686",
    Author = "KirsiaSC | Fisch",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.new(0, 280, 0, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(110, 130, 210)
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Fisch loaded successfully!",
    Duration = 3,
    Icon = "bell"
})

local Tab1 = Window:Tab({
    Title = "Information",
    Icon = "info"
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("discord.gg/getseraphin")
            WindUI:Notify({
                Title = "Copied!",
                Content = "Discord link copied to clipboard.",
                Duration = 2
            })
        end
    end
})

local Section = Tab1:Section({
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Fishing",
    Icon = "fish-symbol"
})

local Section = Tab2:Section({
    Title = "Auto Fishing",
    TextXAlignment = "Left",
    TextSize = 17
})

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

local isAutoCasting = false
local isAutoShaking = false
local isAutoReeling = false

local function checkRequirements()
    local level = Player:WaitForChild("PlayerGui"):WaitForChild("Stats"):WaitForChild("level").Value >= 25
    local hasAutoFishing = Player:GetAttribute("AB_AutoFishing")
    local autoFishRemote = script:WaitForChild("RE/AutoFishing/Toggle", 10)
    return level, hasAutoFishing, autoFishRemote
end

local function notify(title, content, duration)
    WindUI:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

Section:Toggle({
    Title = "Auto Cast",
    Desc = "Automatically casts the fishing rod",
    Default = false,
    Callback = function(Value)
        isAutoCasting = Value
        local level, hasAutoFishing, autoFishRemote = checkRequirements()
        if isAutoCasting and level and hasAutoFishing and autoFishRemote then
            notify("Auto Cast", "Auto casting started!")
            spawn(function()
                while isAutoCasting and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    task.wait(math.random(5, 10))
                end
            end)
        else
            if not level or not hasAutoFishing then
                notify("Auto Cast Failed", "Level 25 or AB_AutoFishing required!")
            elseif not autoFishRemote then
                notify("Auto Cast Failed", "AutoFishing/Toggle remote not found!")
            else
                notify("Auto Cast", "Auto casting stopped!")
            end
        end
    end
})

Section:Toggle({
    Title = "Auto Shake",
    Desc = "Automatically shakes during fishing mini-game",
    Default = false,
    Callback = function(Value)
        isAutoShaking = Value
        local level, hasAutoFishing, autoFishRemote = checkRequirements()
        if isAutoShaking and level and hasAutoFishing and autoFishRemote then
            notify("Auto Shake", "Auto shaking started!")
            spawn(function()
                while isAutoShaking and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") do
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    task.wait(0.05)
                end
            end)
        else
            if not level or not hasAutoFishing then
                notify("Auto Shake Failed", "Level 25 or AB_AutoFishing required!")
            elseif not autoFishRemote then
                notify("Auto Shake Failed", "AutoFishing/Toggle remote not found!")
            else
                notify("Auto Shake", "Auto shaking stopped!")
            end
        end
    end
})

Section:Toggle({
    Title = "Auto Reel",
    Desc = "Automatically reels in the fish",
    Default = false,
    Callback = function(Value)
        isAutoReeling = Value
        local level, hasAutoFishing, autoFishRemote = checkRequirements()
        if isAutoReeling and level and hasAutoFishing and autoFishRemote then
            notify("Auto Reel", "Auto reeling started!")
            spawn(function()
                while isAutoReeling and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") do
                    autoFishRemote:FireServer()
                    task.wait(math.random(2, 5))
                end
            end)
        else
            if not level or not hasAutoFishing then
                notify("Auto Reel Failed", "Level 25 or AB_AutoFishing required!")
            elseif not autoFishRemote then
                notify("Auto Reel Failed", "AutoFishing/Toggle remote not found!")
            else
                notify("Auto Reel", "Auto reeling stopped!")
            end
        end
    end
})

Players.PlayerRemoving:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.PlatformStand = false
    end
end)

local Tab3 = Window:Tab({
    Title = "Automatic",
    Icon = "play"
})

local Section = Tab3:Section({
    Title = "Auto Features",
    TextXAlignment = "Left",
    TextSize = 17
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local fx = require(ReplicatedStorage.shared.modules.fx)
local debris = require(ReplicatedStorage.shared.modules.fx.debris)

_G.Radar = _G.Radar or false
local radarCooldown = false

local function ToTime(sec)
	local h = math.floor(sec / 3600)
	local m = os.date("%M", sec)
	local s = os.date("%S", sec)
	if (tonumber(h) or 0) < 1 then
		return string.format("%s:%s", m, s)
	else
		return string.format("%s:%s:%s", h, m, s)
	end
end

local function ToggleRadar(state)
	if radarCooldown then return end
	radarCooldown = true
	_G.Radar = state

	local clone = Instance.new("TextLabel")
	clone.Size = UDim2.new(0, 200, 0, 30)
	clone.BackgroundTransparency = 1
	clone.TextScaled = true
	clone.TextColor3 = Color3.fromRGB(159, 255, 128)
	clone.Text = state and "[Radar Enabled]" or "[Radar Disabled]"
	local stroke = Instance.new("UIStroke", clone)
	stroke.Thickness = 2
	clone.Parent = LocalPlayer.PlayerGui:WaitForChild("hud")

	TweenService:Create(stroke, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		Transparency = 1
	}):Play()
	debris:AddItem(clone, 2)

	local colorFx = Instance.new("ColorCorrectionEffect")
	colorFx.Saturation = -1
	colorFx.TintColor = Color3.fromRGB(209, 255, 199)
	colorFx.Parent = Lighting

	TweenService:Create(colorFx, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		Saturation = 0,
		TintColor = Color3.fromRGB(255, 255, 255)
	}):Play()
	debris:AddItem(colorFx, 2)

	if state then
		fx:PlaySound(ReplicatedStorage.resources.sounds.sfx.item.RadarOn)
	else
		fx:PlaySound(ReplicatedStorage.resources.sounds.sfx.item.RadarOff)
	end

	for _, v in pairs(CollectionService:GetTagged("radarTag")) do
		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v.Enabled = state
		end
		if v:FindFirstChild("abundanceName") and v.abundanceName.Text == "Ancient Depth Serpent" then
			v.Enabled = false
		end
	end

	if state then
		task.spawn(function()
			while _G.Radar do
				for _, v in pairs(CollectionService:GetTagged("radarTagWithTimer")) do
					local parent = v.Parent
					if parent then
						local text = parent:GetAttribute("Text")
						local endClock = parent:GetAttribute("EndClock")
						if text and endClock then
							local remain = math.clamp(endClock - workspace:GetServerTimeNow(), 0, math.huge)
							if remain <= 0 then
								v.abundanceName.Text = "Disappearing Soon"
							else
								v.abundanceName.Text = string.format(text, ToTime(remain))
							end
						end
					end
				end
				task.wait(1)
			end
		end)
	end

	task.wait(2)
	radarCooldown = false
end

CollectionService:GetInstanceAddedSignal("radarTag"):Connect(function(v)
	if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
		v.Enabled = _G.Radar
	end
end)

CollectionService:GetInstanceAddedSignal("radarTagWithTimer"):Connect(function(v)
	if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
		v.Enabled = _G.Radar
	end
end)

Section:Toggle({
	Title = "Enable Fish Radar",
	Default = _G.Radar,
	Callback = function(value)
		ToggleRadar(value)
	end,
})

local Tab4 = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart"
})

local Section = Tab4:Section({
    Title = "Shop Features",
    TextXAlignment = "Left",
    TextSize = 17
})

Section:Button({
    Title = "Open Shop",
    Desc = "Teleport to shop location",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local shopPos = Vector3.new(-3160, -746, 1684)
            local targetPos = shopPos + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
            local distance = (Player.Character.HumanoidRootPart.Position - targetPos).Magnitude
            local tweenDuration = math.clamp(distance / 1000, 3, 6)
            local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
            tween:Play()
            WindUI:Notify({
                Title = "Teleporting",
                Content = "Moving to Shop",
                Duration = tweenDuration
            })
            task.wait(tweenDuration)
        else
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "Player character not found!",
                Duration = 3
            })
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Teleport",
    Icon = "map"
})

local Section = Tab5:Section({
    Title = "Location",
    TextXAlignment = "Left",
    TextSize = 17
})

local Locations = {
    ["Ancient"] = Vector3.new(6056, 195, 282),
    ["Angler Baby"] = Vector3.new(-13466, -11036, 175),
    ["Archive"] = Vector3.new(-3158, -755, 2214),
    ["Atlantis"] = Vector3.new(-4266, -604, 1830),
    ["Boss Arena"] = Vector3.new(-4356, -11093, 7153),
    ["Boss Queue"] = Vector3.new(-4351, -11187, 7405),
    ["Bosspool"] = Vector3.new(-2374, -11187, 7122),
    ["Bunker 2"] = Vector3.new(1792, -328, -2390),
    ["Crafting"] = Vector3.new(-3160, -746, 1684),
    ["Crook's Hallow"] = Vector3.new(24, 137, -11535),
    ["Ethereal Puzzle"] = Vector3.new(-4123, -603, 1820),
    ["GrandReef"] = Vector3.new(-3566, 150, 535),
    ["Moosewood"] = Vector3.new(381, 134, 243),
    ["Podium 1"] = Vector3.new(-3464, -2259, 3832),
    ["Podium 2"] = Vector3.new(-826, -3275, -710),
    ["Podium 3"] = Vector3.new(-13489, -11051, 134),
    ["Podium 4"] = Vector3.new(-4334, -11183, 3196),
    ["Poseindo Puzzle"] = Vector3.new(-3683, -547, 1012),
    ["Roslit Submarine"] = Vector3.new(-1365, 177, 432),
    ["Sunkenpanel"] = Vector3.new(-4616, -597, 1843),
    ["Zeus Puzzle"] = Vector3.new(-4297, -674, 2353)
}

local SelectedLocation = nil
local lastTeleportTime = 0
local teleportCooldown = 10

local LocationDropdown = Section:Dropdown({
    Title = "Select Location",
    Values = (function()
        local keys = {}
        for name in pairs(Locations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedLocation = Value
        print("Selected location: " .. tostring(Value))
    end
})

Section:Button({
    Title = "Teleport to Location",
    Callback = function()
        if os.time() - lastTeleportTime < teleportCooldown then
            WindUI:Notify({
                Title = "Teleport Cooldown",
                Content = "Please wait " .. tostring(teleportCooldown - (os.time() - lastTeleportTime)) .. " seconds!",
                Duration = 3
            })
            return
        end
        if not Player.Character then
            warn("Error: Player character not found!")
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "Player character not found!",
                Duration = 3
            })
            return
        end
        if not Player.Character:FindFirstChild("HumanoidRootPart") then
            warn("Error: HumanoidRootPart not found!")
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "HumanoidRootPart not found!",
                Duration = 3
            })
            return
        end
        if not SelectedLocation or not Locations[SelectedLocation] then
            warn("Error: No location selected or invalid location!")
            WindUI:Notify({
                Title = "Teleport Failed",
                Content = "No location selected or invalid location!",
                Duration = 3
            })
            return
        end
        local targetPos = Locations[SelectedLocation] + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
        local distance = (Player.Character.HumanoidRootPart.Position - targetPos).Magnitude
        local tweenDuration = math.clamp(distance / 1000, 3, 6)
        local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
        print("Teleporting to: " .. SelectedLocation .. " at " .. tostring(targetPos))
        tween:Play()
        WindUI:Notify({
            Title = "Teleporting",
            Content = "Moving to " .. SelectedLocation,
            Duration = tweenDuration
        })
        lastTeleportTime = os.time()
        task.wait(tweenDuration)
    end
})

local Tab6 = Window:Tab({
    Title = "Misc",
    Icon = "layout-grid"
})

local Section = Tab6:Section({
    Title = "Server",
    TextXAlignment = "Left",
    TextSize = 17
})

Section:Button({
    Title = "Rejoin",
    Desc = "Reconnect to current server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        TeleportService:Teleport(PlaceId, Player)
        WindUI:Notify({
            Title = "Rejoining",
            Content = "Reconnecting to current server...",
            Duration = 3
        })
    end
})

Section:Button({
    Title = "Server Hop",
    Desc = "Teleport to a different server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Servers = {}
        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success and response then
            local data = HttpService:JSONDecode(response)
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(Servers, v.id)
                end
            end
        end
        if #Servers > 0 then
            local randomServer = Servers[math.random(1, #Servers)]
            TeleportService:TeleportToPlaceInstance(PlaceId, randomServer, Player)
            WindUI:Notify({
                Title = "Server Hopping",
                Content = "Teleporting to a different server...",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Server Hop Failed",
                Content = "No available servers found!",
                Duration = 3
            })
        end
    end
})

local isAntiAFK = false
Section:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents being kicked for idling",
    Default = false,
    Callback = function(Value)
        isAntiAFK = Value
        if isAntiAFK then
            WindUI:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK enabled!",
                Duration = 3
            })
            spawn(function()
                while isAntiAFK and Player.Character do
                    UserInputService:SendMouseMovement(Vector2.new(math.random(-10, 10), math.random(-10, 10)))
                    task.wait(math.random(30, 60))
                end
            end)
        else
            WindUI:Notify({
                Title = "Anti-AFK",
                Content = "Anti-AFK disabled!",
                Duration = 3
            })
        end
    end
})

local isAutoReconnect = false
Section:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatically reconnects on disconnect",
    Default = false,
    Callback = function(Value)
        isAutoReconnect = Value
        if isAutoReconnect then
            WindUI:Notify({
                Title = "Auto Reconnect",
                Content = "Auto reconnect enabled!",
                Duration = 3
            })
            game:BindToClose(function()
                if isAutoReconnect then
                    local TeleportService = game:GetService("TeleportService")
                    local PlaceId = game.PlaceId
                    TeleportService:Teleport(PlaceId, Player)
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Reconnect",
                Content = "Auto reconnect disabled!",
                Duration = 3
            })
        end
    end
})
