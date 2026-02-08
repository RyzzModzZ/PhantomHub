if not game:IsLoaded() then game.Loaded:Wait() end
if game.GameId ~= 6035872082 then return end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Seraphin | Rivals",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 360),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Fluent:Notify({
    Title = "Seraphin Loaded",
    Content = "Rivals Ready",
    Duration = 3
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tabs = {
    Combat = Window:AddTab({ Title = "| Combat", Icon = "crosshair" }),
    Visual = Window:AddTab({ Title = "| Visual", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" })
}

local AutoAim = false
local SilentAim = false
local ShowFOV = false
local AimSmooth = 0.2
local FOVRadius = 150

local function IsEnemy(p)
    if not p.Team or not LocalPlayer.Team then
        return true
    end
    return p.Team ~= LocalPlayer.Team
end

local function Alive(p)
    return p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local function GetTarget()
    local t, d = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsEnemy(p) and Alive(p) and p.Character:FindFirstChild("Head") then
            local pos, v = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if v then
                local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if m < d and m <= FOVRadius then
                    d = m
                    t = p
                end
            end
        end
    end
    return t
end

local FOV = Drawing.new("Circle")
FOV.Thickness = 2
FOV.Filled = false
FOV.Color = Color3.fromRGB(255,255,255)
FOV.Visible = false

RunService.RenderStepped:Connect(function()
    FOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOV.Radius = FOVRadius
    FOV.Visible = ShowFOV
end)

RunService.RenderStepped:Connect(function()
    if AutoAim then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, t.Character.Head.Position),
                AimSmooth
            )
        end
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local m = getnamecallmethod()
    if SilentAim and m == "FireServer" and typeof(args[1]) == "Vector3" then
        local t = GetTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            args[1] = t.Character.Head.Position
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

setreadonly(mt, true)

local function AntiSpectate()
    if Camera.CameraSubject ~= LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    end
end

RunService.RenderStepped:Connect(AntiSpectate)

Tabs.Combat:AddToggle("AA", {
    Title = "Auto Aim",
    Default = false,
    Callback = function(v) AutoAim = v end
})

Tabs.Combat:AddToggle("SA", {
    Title = "Silent Aim",
    Default = false,
    Callback = function(v) SilentAim = v end
})

Tabs.Combat:AddSlider("Smooth", {
    Title = "Aim Smooth",
    Min = 0.05,
    Max = 0.4,
    Default = AimSmooth,
    Rounding = 2,
    Callback = function(v) AimSmooth = v end
})

Tabs.Visual:AddToggle("FOV", {
    Title = "Show FOV",
    Default = false,
    Callback = function(v) ShowFOV = v end
})

Tabs.Visual:AddSlider("FOVSize", {
    Title = "FOV Radius",
    Min = 50,
    Max = 400,
    Default = FOVRadius,
    Rounding = 0,
    Callback = function(v) FOVRadius = v end
})

Tabs.Settings:AddButton({
    Title = "Unload",
    Callback = function()
        FOV:Remove()
        Window:Destroy()
    end
})