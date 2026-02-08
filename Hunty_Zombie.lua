local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Hunty Zombie",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(280, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(180, 0, 255)
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Hunty Zombie Script Activated!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Information",
    Icon = "info",
})

Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy invite discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
            WindUI:Notify({
                Title = "Discord",
                Content = "Copied to clipboard!",
                Duration = 3,
                Icon = "clipboard",
            })
        end
    end
})

Tab1:Section({
    Title = "Game: Hunty Zombie",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab1:Section({
    Title = "If you encounter any issues, please report them on our Discord server.",
    TextXAlignment = "Left",
    TextSize = 12,
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

Tab2:Section({
    Title = "Lobby",
    TextXAlignment = "Left",
    TextSize = 14,
})

local PlayersList = { "1", "2", "3", "4", "5", "6" }
local MapsList = { "School", "Sewers", "Carnival" }
local ModesList = { "Normal", "Hard", "Nightmare" }

_G.SelectedPlayers = "5"
_G.SelectedMap = "School"
_G.SelectedMode = "Normal"

Tab2:Dropdown({
    Title = "Players",
    Values = PlayersList,
    Value = "5",
    Callback = function(option)
        _G.SelectedPlayers = option
    end
})

Tab2:Dropdown({
    Title = "Select Map",
    Values = MapsList,
    Value = "School",
    Callback = function(option)
        _G.SelectedMap = option
    end
})

Tab2:Dropdown({
    Title = "Select Mode",
    Values = ModesList,
    Value = "Normal",
    Callback = function(option)
        _G.SelectedMode = option
    end
})

Tab2:Button({
    Title = "Auto Create Room",
    Desc = "Create room with selected settings",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        local remotes = rs:FindFirstChild("Remotes")
        
        if remotes then
            local createRoom = remotes:FindFirstChild("CreateRoom") or remotes:FindFirstChild("CreateLobby")
            if createRoom then
                pcall(function()
                    createRoom:FireServer(_G.SelectedMap, _G.SelectedMode, tonumber(_G.SelectedPlayers), false)
                    WindUI:Notify({
                        Title = "Room Created",
                        Content = "Map: ".._G.SelectedMap.." | Mode: ".._G.SelectedMode,
                        Duration = 5,
                        Icon = "check-circle",
                    })
                end)
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "CreateRoom function not found!",
                    Duration = 5,
                    Icon = "x-circle",
                })
            end
        end
    end
})

Tab2:Section({
    Title = "Gameplay",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab2:Section({
    Title = "Auto Farm",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab2:Toggle({
    Title = "Auto Farm Coins",
    Default = false,
    Callback = function(state)
        _G.AutoFarmCoins = state
        
        if state then
            WindUI:Notify({
                Title = "Auto Farm",
                Content = "Coin farming enabled",
                Duration = 3,
                Icon = "coins",
            })
            
            spawn(function()
                while _G.AutoFarmCoins do
                    pcall(function()
                        local enemies = workspace:FindFirstChild("Zombies") or workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Mobs")
                        local character = game.Players.LocalPlayer.Character
                        
                        if enemies and character then
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            
                            if humanoidRootPart then
                                for _, enemy in pairs(enemies:GetChildren()) do
                                    if not _G.AutoFarmCoins then break end
                                    
                                    if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Head")
                                        
                                        if enemyRoot then
                                            humanoidRootPart.CFrame = CFrame.new(enemyRoot.Position + Vector3.new(0, 3, 0))
                                            task.wait(0.2)
                                            
                                            local args = {
                                                [1] = enemy,
                                                [2] = enemy:FindFirstChild("Head") or enemyRoot,
                                                [3] = 100,
                                                [4] = game.Players.LocalPlayer
                                            }
                                            
                                            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                            if remote then
                                                local damageRemote = remote:FindFirstChild("Damage") or remote:FindFirstChild("Hit") or remote:FindFirstChild("Attack")
                                                if damageRemote then
                                                    damageRemote:FireServer(unpack(args))
                                                end
                                            end
                                            
                                            task.wait(0.3)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Farm",
                Content = "Disabled",
                Duration = 3,
                Icon = "coins",
            })
        end
    end
})

Tab2:Toggle({
    Title = "Auto Complete Objectives",
    Default = false,
    Callback = function(state)
        _G.AutoComplete = state
        
        if state then
            WindUI:Notify({
                Title = "Auto Complete",
                Content = "Enabled",
                Duration = 3,
                Icon = "check-circle",
            })
            
            spawn(function()
                while _G.AutoComplete do
                    pcall(function()
                        local rs = game:GetService("ReplicatedStorage")
                        local remotes = rs:FindFirstChild("Remotes")
                        
                        if remotes then
                            local completeRemote = remotes:FindFirstChild("CompleteQuest") or 
                                                  remotes:FindFirstChild("FinishObjective") or
                                                  remotes:FindFirstChild("CompleteObjective") or
                                                  remotes:FindFirstChild("Complete")
                            
                            if completeRemote then
                                completeRemote:FireServer()
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Complete",
                Content = "Disabled",
                Duration = 3,
                Icon = "check-circle",
            })
        end
    end
})

Tab2:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(state)
        _G.KillAura = state
        
        if state then
            WindUI:Notify({
                Title = "Kill Aura",
                Content = "Enabled",
                Duration = 3,
                Icon = "zap",
            })
            
            spawn(function()
                while _G.KillAura do
                    pcall(function()
                        local enemies = workspace:FindFirstChild("Zombies") or workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("Mobs")
                        
                        if enemies then
                            for _, enemy in pairs(enemies:GetChildren()) do
                                if not _G.KillAura then break end
                                
                                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                    local args = {
                                        [1] = enemy,
                                        [2] = enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart"),
                                        [3] = 9999,
                                        [4] = game.Players.LocalPlayer
                                    }
                                    
                                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                    if remote then
                                        local damageRemote = remote:FindFirstChild("Damage") or remote:FindFirstChild("Hit") or remote:FindFirstChild("Attack")
                                        if damageRemote then
                                            damageRemote:FireServer(unpack(args))
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            WindUI:Notify({
                Title = "Kill Aura",
                Content = "Disabled",
                Duration = 3,
                Icon = "zap",
            })
        end
    end
})

Tab2:Section({
    Title = "Player Modifications",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab2:Toggle({
    Title = "God Mode",
    Default = false,
    Callback = function(state)
        _G.GodMode = state
        
        if state then
            WindUI:Notify({
                Title = "God Mode",
                Content = "Enabled - You're invincible!",
                Duration = 3,
                Icon = "shield",
            })
            
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.MaxHealth = math.huge
                        humanoid.Health = math.huge
                    end
                end
            end)
        else
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.MaxHealth = 100
                        humanoid.Health = 100
                    end
                end
            end)
        end
    end
})

Tab2:Toggle({
    Title = "Infinite Ammo",
    Default = false,
    Callback = function(state)
        _G.InfiniteAmmo = state
        
        if state then
            WindUI:Notify({
                Title = "Infinite Ammo",
                Content = "Enabled",
                Duration = 3,
                Icon = "crosshair",
            })
            
            spawn(function()
                while _G.InfiniteAmmo do
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character
                        
                        if character then
                            local tool = character:FindFirstChildOfClass("Tool")
                            if tool then
                                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip") or tool:FindFirstChild("Bullets")
                                if ammo and ammo:IsA("IntValue") then
                                    ammo.Value = math.huge
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        else
            WindUI:Notify({
                Title = "Infinite Ammo",
                Content = "Disabled",
                Duration = 3,
                Icon = "crosshair",
            })
        end
    end
})

Tab2:Toggle({
    Title = "No Recoil",
    Default = false,
    Callback = function(state)
        _G.NoRecoil = state
        
        if state then
            WindUI:Notify({
                Title = "No Recoil",
                Content = "Enabled",
                Duration = 3,
                Icon = "target",
            })
        else
            WindUI:Notify({
                Title = "No Recoil",
                Content = "Disabled",
                Duration = 3,
                Icon = "target",
            })
        end
    end
})

Tab2:Slider({
    Title = "Walk Speed",
    Desc = "Adjust your movement speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        pcall(function()
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
        end)
    end
})

Tab2:Slider({
    Title = "Jump Power",
    Desc = "Adjust your jump height",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(value)
        pcall(function()
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = value
                end
            end
        end)
    end
})

local Tab3 = Window:Tab({
    Title = "Utility",
    Icon = "wrench",
})

Tab3:Section({
    Title = "Player Utilities",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab3:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        
        if state then
            WindUI:Notify({
                Title = "Noclip",
                Content = "Enabled - Walk through walls",
                Duration = 3,
                Icon = "git-commit",
            })
        else
            WindUI:Notify({
                Title = "Noclip",
                Content = "Disabled",
                Duration = 3,
                Icon = "git-commit",
            })
        end
    end
})

Tab3:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
        
        if state then
            WindUI:Notify({
                Title = "Infinite Jump",
                Content = "Enabled - Jump in mid-air",
                Duration = 3,
                Icon = "arrow-up",
            })
            
            local player = game:GetService("Players").LocalPlayer
            local mouse = player:GetMouse()
            
            _G.InfiniteJumpConnection = mouse.KeyDown:Connect(function(key)
                if key == " " and _G.InfiniteJump then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState("Jumping")
                    end
                end
            end)
        else
            if _G.InfiniteJumpConnection then
                _G.InfiniteJumpConnection:Disconnect()
            end
            WindUI:Notify({
                Title = "Infinite Jump",
                Content = "Disabled",
                Duration = 3,
                Icon = "arrow-up",
            })
        end
    end
})

Tab3:Section({
    Title = "Game Utilities",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab3:Button({
    Title = "Rejoin Server",
    Desc = "Reconnect to the current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
})

Tab3:Button({
    Title = "Server Hop",
    Desc = "Join a different server",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local API = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s"
        local _limit = 100
        local gameId = game.PlaceId

        local servers = Http:JSONDecode(game:HttpGet(API:format(gameId, "Desc", _limit), true))
        for _, server in next, servers.data do
            if server.playing ~= server.maxPlayers and server.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(gameId, server.id)
                break
            end
        end
    end
})

Tab3:Button({
    Title = "Collect All Items",
    Desc = "Try to collect nearby items",
    Callback = function()
        pcall(function()
            local items = workspace:FindFirstChild("Items") or workspace:FindFirstChild("Drops")
            if items then
                for _, item in pairs(items:GetChildren()) do
                    if item:IsA("BasePart") then
                        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(item.Position))
                        task.wait(0.2)
                    end
                end
            end
        end)
    end
})

local Tab4 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

Tab4:Section({
    Title = "UI Settings",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab4:Toggle({
    Title = "UI Visibility",
    Desc = "Toggle UI visibility",
    Icon = "eye",
    Default = true,
    Callback = function(state)
        Window:SetVisibility(state)
    end
})

Tab4:Button({
    Title = "Destroy UI",
    Desc = "Completely remove the UI",
    Icon = "trash-2",
    Callback = function()
        WindUI:Destroy()
        WindUI:Notify({
            Title = "UI Destroyed",
            Content = "UI has been removed",
            Duration = 3,
            Icon = "trash",
        })
    end
})

Tab4:Section({
    Title = "System",
    TextXAlignment = "Left",
    TextSize = 14,
})

Tab4:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Icon = "shield",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        
        if state then
            WindUI:Notify({
                Title = "AntiAFK",
                Content = "Enabled",
                Duration = 3,
                Icon = "check-circle",
            })
            
            local VirtualUser = game:GetService("VirtualUser")
            _G.AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            if _G.AntiAFKConnection then
                _G.AntiAFKConnection:Disconnect()
            end
            WindUI:Notify({
                Title = "AntiAFK",
                Content = "Disabled",
                Duration = 3,
                Icon = "check-circle",
            })
        end
    end
})

Tab4:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = "plug-zap",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        
        if state then
            WindUI:Notify({
                Title = "Auto Reconnect",
                Content = "Enabled",
                Duration = 3,
                Icon = "check-circle",
            })
            
            _G.ReconnectLoop = game:GetService("RunService").Heartbeat:Connect(function()
                local gui = game:GetService("CoreGui")
                local prompt = gui:FindFirstChild("RobloxPromptGui")
                if prompt then
                    local overlay = prompt:FindFirstChild("promptOverlay")
                    if overlay then
                        local errorPrompt = overlay:FindFirstChild("ErrorPrompt")
                        if errorPrompt and errorPrompt.Visible then
                            local button = errorPrompt:FindFirstChild("MessageArea"):FindFirstChild("ButtonArea")
                            if button then
                                for _, child in pairs(button:GetChildren()) do
                                    if child:IsA("TextButton") and child.Text == "Reconnect" then
                                        child:Activate()
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if _G.ReconnectLoop then
                _G.ReconnectLoop:Disconnect()
            end
            WindUI:Notify({
                Title = "Auto Reconnect",
                Content = "Disabled",
                Duration = 3,
                Icon = "check-circle",
            })
        end
    end
})

_G.AutoFarmCoins = false
_G.AutoComplete = false
_G.KillAura = false
_G.GodMode = false
_G.InfiniteAmmo = false
_G.NoRecoil = false
_G.Noclip = false
_G.InfiniteJump = false
_G.AntiAFK = false
_G.AutoReconnect = false

print("Seraphin Hub for Hunty Zombie initialized successfully!")

game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip and game.Players.LocalPlayer.Character then
        pcall(function()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)
