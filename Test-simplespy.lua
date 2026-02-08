-- SimpleSpy v3.0 dengan Anti-Cheat Detection untuk Fisch Game
if _G.SimpleSpyExecuted and type(_G.SimpleSpyShutdown) == "function" then 
    pcall(_G.SimpleSpyShutdown)
end 

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local Highlight = loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/highlight.lua"))()

local FischAntiCheat = {
    Enabled = true,
    SafeMode = false,
    DetectionFlags = {},
    BypassActive = false
}

local function HookNamecall()
    local originalNamecall
    if hookmetamethod then
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if method == "FindFirstChild" and tostring(self):find("Spy") then
                return nil
            end
            
            if method == "GetFocusedTextBox" and checkcaller then
                if not checkcaller() then
                    return nil
                end
            end
            
            if tostring(self) == "AntiCheat" or tostring(self):find("Detection") then
                return nil
            end
            
            return originalNamecall(self, ...)
        end)
    end
end

local function FakeEnvironment()
    if setidentity then
        setidentity(8)
    end
    
    if getgenv then
        getgenv().GameId = game.GameId
        getgenv().PlaceId = game.PlaceId
        getgenv().ScriptContext = nil
    end
end

local function StealthMode()
    if getconnections then
        for _, conn in pairs(getconnections(game:GetService("ScriptContext").Error)) do
            pcall(function() conn:Disable() end)
        end
    end
end

local function HookGC()
    if hookfunction then
        local oldGC = getgc or function() return {} end
        hookfunction(getgc, function(...)
            local results = oldGC(...)
            local filtered = {}
            for _, obj in pairs(results) do
                if type(obj) == "function" then
                    local info = getinfo(obj)
                    if not info.source:find("SimpleSpy") and not info.source:find("Fisch") then
                        table.insert(filtered, obj)
                    end
                else
                    table.insert(filtered, obj)
                end
            end
            return filtered
        end)
    end
end

local FischProtections = {
    AntiTeleport = function(args)
        for _, arg in pairs(args) do
            if type(arg) == "string" and (arg:find("Teleport") or arg:find("TP")) then
                return true
            end
        end
        return false
    end,
    
    AntiSpeed = function(args)
        for _, arg in pairs(args) do
            if type(arg) == "number" and arg > 50 then
                return true
            end
        end
        return false
    end,
    
    AntiFly = function(args)
        for _, arg in pairs(args) do
            if type(arg) == "string" and (arg:find("Fly") or arg:find("Float") or arg:find("CFrame")) then
                return true
            end
        end
        return false
    end,
    
    AntiNoclip = function(args)
        for _, arg in pairs(args) do
            if type(arg) == "boolean" and arg == false then
                return true
            end
        end
        return false
    end,
    
    SafeRemoteCalls = function(remote, args)
        if FischProtections.AntiTeleport(args) then
            return true
        end
        
        if FischProtections.AntiSpeed(args) then
            return true
        end
        
        if FischProtections.AntiFly(args) then
            return true
        end
        
        if FischProtections.AntiNoclip(args) then
            return true
        end
        
        return false
    end
}

pcall(HookNamecall)
pcall(FakeEnvironment)
pcall(StealthMode)
pcall(HookGC)

local SimpleSpy2 = Instance.new("ScreenGui")
SimpleSpy2.Name = "SimpleSpy2"
SimpleSpy2.ResetOnSpawn = false
SimpleSpy2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local SpyFind = CoreGui:FindFirstChild(SimpleSpy2.Name)
if SpyFind and SpyFind ~= SimpleSpy2 then 
    SpyFind:Destroy() 
end

SimpleSpy2.Parent = CoreGui

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Parent = SimpleSpy2
Background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Background.BackgroundTransparency = 0.1
Background.BorderSizePixel = 0
Background.Position = UDim2.new(0, math.random(100, 300), 0, math.random(100, 200))
Background.Size = UDim2.new(0, 500, 0, 350)
Background.Active = true
Background.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Background

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Background
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.Gotham
Title.Text = "SimpleSpy v3.0 - Fisch Mode"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

CloseButton.MouseButton1Click:Connect(function()
    SimpleSpy2:Destroy()
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14

local LogsFrame = Instance.new("ScrollingFrame")
LogsFrame.Name = "LogsFrame"
LogsFrame.Parent = Background
LogsFrame.Position = UDim2.new(0, 10, 0, 40)
LogsFrame.Size = UDim2.new(1, -20, 1, -50)
LogsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LogsFrame.BorderSizePixel = 0
LogsFrame.ScrollBarThickness = 8
LogsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LogsLayout = Instance.new("UIListLayout")
LogsLayout.Parent = LogsFrame
LogsLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogsLayout.Padding = UDim.new(0, 5)

local LogsPadding = Instance.new("UIPadding")
LogsPadding.Parent = LogsFrame
LogsPadding.PaddingLeft = UDim.new(0, 5)
LogsPadding.PaddingTop = UDim.new(0, 5)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = SimpleSpy2
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "SPY"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.ZIndex = 100

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

MinimizeButton.MouseButton1Click:Connect(function()
    Background.Visible = not Background.Visible
end)

ToggleButton.MouseButton1Click:Connect(function()
    Background.Visible = not Background.Visible
end)

local remoteSignals = {}
local hookedRemotes = {}

local function createLogEntry(remote, args, script)
    local logFrame = Instance.new("Frame")
    logFrame.Name = "LogEntry"
    logFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    logFrame.BorderSizePixel = 0
    logFrame.Size = UDim2.new(1, -10, 0, 80)
    
    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 6)
    logCorner.Parent = logFrame
    
    local remoteName = Instance.new("TextLabel")
    remoteName.Name = "RemoteName"
    remoteName.Parent = logFrame
    remoteName.BackgroundTransparency = 1
    remoteName.Position = UDim2.new(0, 10, 0, 5)
    remoteName.Size = UDim2.new(1, -20, 0, 20)
    remoteName.Font = Enum.Font.Gotham
    remoteName.Text = "Remote: " .. tostring(remote.Name)
    remoteName.TextColor3 = Color3.fromRGB(255, 255, 255)
    remoteName.TextSize = 12
    remoteName.TextXAlignment = Enum.TextXAlignment.Left
    
    local scriptName = Instance.new("TextLabel")
    scriptName.Name = "ScriptName"
    scriptName.Parent = logFrame
    scriptName.BackgroundTransparency = 1
    scriptName.Position = UDim2.new(0, 10, 0, 25)
    scriptName.Size = UDim2.new(1, -20, 0, 15)
    scriptName.Font = Enum.Font.Gotham
    scriptName.Text = "From: " .. (script and tostring(script:GetFullName()) or "Unknown")
    scriptName.TextColor3 = Color3.fromRGB(200, 200, 200)
    scriptName.TextSize = 10
    scriptName.TextXAlignment = Enum.TextXAlignment.Left
    
    local argsText = Instance.new("TextLabel")
    argsText.Name = "ArgsText"
    argsText.Parent = logFrame
    argsText.BackgroundTransparency = 1
    argsText.Position = UDim2.new(0, 10, 0, 45)
    argsText.Size = UDim2.new(1, -20, 0, 30)
    argsText.Font = Enum.Font.Gotham
    argsText.Text = "Args: " .. HttpService:JSONEncode(args)
    argsText.TextColor3 = Color3.fromRGB(150, 150, 255)
    argsText.TextSize = 10
    argsText.TextXAlignment = Enum.TextXAlignment.Left
    argsText.TextWrapped = true
    
    logFrame.Parent = LogsFrame
end

function hookRemote(remote)
    if hookedRemotes[remote] then return end
    
    if remote:IsA("RemoteEvent") then
        local oldFireServer = remote.FireServer
        remote.FireServer = function(self, ...)
            local args = {...}
            
            if FischProtections.SafeRemoteCalls(remote, args) then
                warn("[FISCH BLOCKED] " .. remote.Name)
                return
            end
            
            createLogEntry(remote, args, getcallingscript())
            return oldFireServer(self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        local oldInvokeServer = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            local args = {...}
            
            if FischProtections.SafeRemoteCalls(remote, args) then
                warn("[FISCH BLOCKED] " .. remote.Name)
                return nil
            end
            
            createLogEntry(remote, args, getcallingscript())
            return oldInvokeServer(self, ...)
        end
    end
    
    hookedRemotes[remote] = true
end

local function scanForRemotes()
    while FischAntiCheat.Enabled do
        for _, obj in pairs(game:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not hookedRemotes[obj] then
                pcall(function() hookRemote(obj) end)
            end
        end
        task.wait(1)
    end
end

local function ExecuteStealth()
    repeat task.wait() until game:IsLoaded()
    
    local isFischGame = game.PlaceId == 1234567890
    if isFischGame then
        warn("[FISCH PROTECTION] Activated")
        FischAntiCheat.Enabled = true
    else
        FischAntiCheat.Enabled = false
    end
    
    task.wait(math.random(2, 5))
    
    local success, err = pcall(function()
        if not RunService:IsClient() then
            error("Cannot run on server!")
        end
        
        task.spawn(scanForRemotes)
        
        if isFischGame then
            task.spawn(function()
                task.wait(3)
                Background.Visible = false
            end)
        end
    end)
    
    if not success then
        warn("Stealth failed: " .. tostring(err))
    end
end

local AntiDetection = {
    RandomizeGUI = function()
        while task.wait(30) do
            if Background.Visible then
                Background.Position = UDim2.new(
                    0, math.random(50, 500),
                    0, math.random(50, 300)
                )
            end
        end
    end,
    
    MonitorSuspiciousActivity = function()
        game:GetService("ScriptContext").Error:Connect(function(message, trace, script)
            if string.find(message:lower(), "cheat") or string.find(message:lower(), "exploit") or string.find(message:lower(), "inject") then
                warn("[ANTI-CHEAT DETECTED] " .. message)
                FischAntiCheat.SafeMode = true
            end
        end)
    end,
    
    FakeStats = function()
        if stats then
            pcall(function()
                stats:SetMemoryStatsBucketSize(0)
            end)
        end
    end
}

task.spawn(AntiDetection.RandomizeGUI)
task.spawn(AntiDetection.MonitorSuspiciousActivity)
task.spawn(AntiDetection.FakeStats)

local function ClearLogs()
    for _, child in pairs(LogsFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Parent = TopBar
ClearButton.BackgroundTransparency = 1
ClearButton.Position = UDim2.new(1, -90, 0, 0)
ClearButton.Size = UDim2.new(0, 30, 1, 0)
ClearButton.Font = Enum.Font.Gotham
ClearButton.Text = "C"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 14

ClearButton.MouseButton1Click:Connect(ClearLogs)

if not _G.SimpleSpyExecuted then
    _G.SimpleSpyExecuted = true
    task.spawn(ExecuteStealth)
else
    SimpleSpy2:Destroy()
    return
end

local EmergencyShutdown = function()
    if FischAntiCheat.SafeMode then
        warn("[EMERGENCY] Shutting down...")
        SimpleSpy2:Destroy()
        return true
    end
    return false
end

_G.SimpleSpyShutdown = function()
    SimpleSpy2:Destroy()
    _G.SimpleSpyExecuted = false
end

task.spawn(function()
    while task.wait(5) do
        if EmergencyShutdown() then
            break
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "SimpleSpy v3.0",
    Text = "Fisch Anti-Cheat Protection Active",
    Duration = 5,
    Icon = "rbxassetid://0"
})

warn("SimpleSpy v3.0 loaded with Fisch Anti-Cheat Protection")
