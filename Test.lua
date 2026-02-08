local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Seraphin | Developer",
    TabWidth = 160,
    Size = UDim2.fromOffset(550, 350),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

Fluent:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Rivals script loaded!",
    Duration = 3
})

local Tabs = {
    Info = Window:AddTab({ Title = "| Info", Icon = "info" }),
    Main = Window:AddTab({ Title = "| Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" })
}

Tabs.Info:AddSection("Support Community")

Tabs.Info:AddButton({
    Title = "Discord",
    Description = "Click to copy Discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

Tabs.Info:AddParagraph({
    Title = "Update Information",
    Content = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tabs.Main:AddSection("Automatic")
