-- Ronix-Style Android Executor UI (with realtime ScriptBlox search)
-- Author: adapted for you
-- Features: Search (ScriptBlox), Editor, Folder (save/load), Config, Console

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local parentGui = player:WaitForChild("PlayerGui")

-- CONFIG: set ScriptBlox API endpoint (change if needed)
local SCRIPTBLOX_API = "https://scriptblox.com/api/script/search?q=" -- append query

-- UTIL helpers
local function safeHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok then return true, res else return false, res end
end

local function safeJsonDecode(str)
    local ok, res = pcall(function() return HttpService:JSONDecode(str) end)
    if ok then return true, res else return false, res end
end

local function safeLoadString(code)
    local ok, fn = pcall(function() return loadstring(code) end)
    if ok and fn then
        local ok2, res = pcall(fn)
        return ok2, res
    end
    return false, "compile failed"
end

local hasFileApi = (type(writefile) == "function" and type(readfile) == "function" and type(listfiles) == "function")

-- UI creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RonixAndroidExecutor"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0,840,0,480)
Main.Position = UDim2.new(0.5,-420,0.5,-240)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0,12)

-- glow shadow
local Glow = Instance.new("ImageLabel", Main)
Glow.Size = UDim2.new(1,120,1,120)
Glow.Position = UDim2.new(0,-60,0,-60)
Glow.ZIndex = 0
Glow.Image = "rbxassetid://5028857084"
Glow.ImageTransparency = 0.7
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(24,24,276,276)
Glow.BackgroundTransparency = 1

-- Left sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,240,1,0)
Sidebar.Position = UDim2.new(0,0,0,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12,12,15)
local SidebarCorner = Instance.new("UICorner", Sidebar); SidebarCorner.CornerRadius = UDim.new(0,10)

local logo = Instance.new("TextLabel", Sidebar)
logo.Position = UDim2.new(0,12,0,12)
logo.Size = UDim2.new(1,-24,0,72)
logo.BackgroundTransparency = 1
logo.Text = "RONIX\nANDROID"
logo.TextColor3 = Color3.fromRGB(235,235,235)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 18
logo.TextXAlignment = Enum.TextXAlignment.Left

-- sidebar buttons helper
local function createSidebarButton(parent, text, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-30,0,44)
    b.Position = UDim2.new(0,15,0,y)
    b.BackgroundColor3 = Color3.fromRGB(22,22,28)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 15
    b.TextColor3 = Color3.fromRGB(210,210,210)
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,8)
    return b
end

local btnSearch = createSidebarButton(Sidebar, "Search", 100)
local btnEditor = createSidebarButton(Sidebar, "Editor", 160)
local btnFolder = createSidebarButton(Sidebar, "Folder", 220)
local btnConfig = createSidebarButton(Sidebar, "Config", 280)
local btnClose  = createSidebarButton(Sidebar, "Close", 380)

-- Right large panel
local Panel = Instance.new("Frame", Main)
Panel.Size = UDim2.new(1,-260,1,-20)
Panel.Position = UDim2.new(0,250,0,10)
Panel.BackgroundColor3 = Color3.fromRGB(22,22,30)
local PanelCorner = Instance.new("UICorner", Panel); PanelCorner.CornerRadius = UDim.new(0,10)

-- Top tab bar
local Tabbar = Instance.new("Frame", Panel)
Tabbar.Size = UDim2.new(1,-40,0,48)
Tabbar.Position = UDim2.new(0,20,0,12)
Tabbar.BackgroundTransparency = 1

local function createTabButton(parent, text, x)
    local tb = Instance.new("TextButton", parent)
    tb.Size = UDim2.new(0,120,1,0)
    tb.Position = UDim2.new(0,x,0,0)
    tb.BackgroundColor3 = Color3.fromRGB(45,40,58)
    tb.Text = text
    tb.Font = Enum.Font.GothamSemibold
    tb.TextSize = 14
    tb.TextColor3 = Color3.fromRGB(230,230,240)
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,8)
    return tb
end

local tabServer = createTabButton(Tabbar, "Server", 0)
local tabAuto   = createTabButton(Tabbar, "Auto Execute", 140)
local tabConsole= createTabButton(Tabbar, "Console", 280)

-- Content frames per tab
local contentFrame = Instance.new("Frame", Panel)
contentFrame.Size = UDim2.new(1,-40,1,-80)
contentFrame.Position = UDim2.new(0,20,0,70)
contentFrame.BackgroundTransparency = 1

local frameSearch = Instance.new("Frame", contentFrame)
frameSearch.Size = UDim2.new(1,0,1,0)
frameSearch.BackgroundTransparency = 1
frameSearch.Visible = true

local frameAuto = frameSearch:Clone()
frameAuto.Parent = contentFrame
frameAuto.Visible = false

local frameConsole = frameSearch:Clone()
frameConsole.Parent = contentFrame
frameConsole.Visible = false

-- ===== SEARCH tab UI =====
local searchBox = Instance.new("TextBox", frameSearch)
searchBox.Size = UDim2.new(1,-160,0,40)
searchBox.Position = UDim2.new(0,0,0,0)
searchBox.PlaceholderText = "Search scripts (ScriptBlox)"
searchBox.Text = ""
searchBox.Font = Enum.Font.Code
searchBox.TextSize = 14
searchBox.BackgroundColor3 = Color3.fromRGB(18,18,22)
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)

local searchBtn = Instance.new("TextButton", frameSearch)
searchBtn.Size = UDim2.new(0,120,0,40)
searchBtn.Position = UDim2.new(1,-120,0,0)
searchBtn.Text = "Search"
searchBtn.Font = Enum.Font.GothamBold
searchBtn.TextSize = 14
searchBtn.BackgroundColor3 = Color3.fromRGB(88,72,150)
Instance.new("UICorner", searchBtn).CornerRadius = UDim.new(0,6)

local resultScroll = Instance.new("ScrollingFrame", frameSearch)
resultScroll.Size = UDim2.new(1,0,1,-60)
resultScroll.Position = UDim2.new(0,0,0,60)
resultScroll.CanvasSize = UDim2.new(0,0,0,0)
resultScroll.ScrollBarThickness = 8
resultScroll.BackgroundTransparency = 1
local listLayout = Instance.new("UIListLayout", resultScroll)
listLayout.Padding = UDim.new(0,8)

-- create one result item
local function createResultItem(parent, title, summary, codeStr)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1,-20,0,80)
    card.BackgroundColor3 = Color3.fromRGB(24,24,30)
    local c = Instance.new("UICorner", card); c.CornerRadius = UDim.new(0,8)

    local t = Instance.new("TextLabel", card)
    t.Position = UDim2.new(0,12,0,8)
    t.Size = UDim2.new(1,-140,0,24)
    t.BackgroundTransparency = 1
    t.Text = title
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextColor3 = Color3.new(1,1,1)
    t.TextXAlignment = Enum.TextXAlignment.Left

    local s = Instance.new("TextLabel", card)
    s.Position = UDim2.new(0,12,0,32)
    s.Size = UDim2.new(1,-140,0,34)
    s.BackgroundTransparency = 1
    s.Text = summary or ""
    s.Font = Enum.Font.Gotham
    s.TextSize = 12
    s.TextColor3 = Color3.fromRGB(190,190,190)
    s.TextWrapped = true
    s.TextXAlignment = Enum.TextXAlignment.Left

    local btnExec = Instance.new("TextButton", card)
    btnExec.Size = UDim2.new(0,92,0,32)
    btnExec.Position = UDim2.new(1,-100,0,24)
    btnExec.Text = "Execute"
    btnExec.Font = Enum.Font.GothamBold
    btnExec.TextSize = 13
    btnExec.BackgroundColor3 = Color3.fromRGB(40,130,100)
    Instance.new("UICorner", btnExec).CornerRadius = UDim.new(0,6)

    local btnCopy = btnExec:Clone()
    btnCopy.Parent = card
    btnCopy.Position = UDim2.new(1,-100,0,52)
    btnCopy.Text = "Copy"

    btnExec.MouseButton1Click:Connect(function()
        if codeStr and codeStr ~= "" then
            local ok, res = safeLoadString(codeStr)
            if ok then
                StarterGui:SetCore("SendNotification",{Title="Execute",Text="Executed successfully",Duration=3})
            else
                StarterGui:SetCore("SendNotification",{Title="Execute Error",Text=tostring(res),Duration=4})
            end
        else
            StarterGui:SetCore("SendNotification",{Title="Execute",Text="No code available",Duration=2})
        end
    end)

    btnCopy.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(codeStr or "")
        end)
        StarterGui:SetCore("SendNotification",{Title="Copy",Text="Code copied to clipboard (if available)",Duration=2})
    end)
end

-- Search logic (real-time HttpGet -> ScriptBlox)
local function performSearch(query)
    query = query:match("^%s*(.-)%s*$") or ""
    if query == "" then
        StarterGui:SetCore("SendNotification",{Title="Search",Text="Type something to search",Duration=2})
        return
    end
    resultScroll:ClearAllChildren()
    local loading = Instance.new("TextLabel", resultScroll)
    loading.Text = "Searching..."
    loading.Size = UDim2.new(1,0,0,24)
    loading.BackgroundTransparency = 1

    -- build url
    local url = SCRIPTBLOX_API .. game:GetService("HttpService"):UrlEncode(query)
    local ok, res = safeHttpGet(url)
    loading:Destroy()
    if not ok then
        local err = Instance.new("TextLabel", resultScroll)
        err.Text = "HTTP error: "..tostring(res)
        err.Size = UDim2.new(1,0,0,40)
        err.BackgroundTransparency = 1
        return
    end

    local ok2, json = safeJsonDecode(res)
    if not ok2 then
        local err = Instance.new("TextLabel", resultScroll)
        err.Text = "JSON parse failed"
        err.Size = UDim2.new(1,0,0,40)
        err.BackgroundTransparency = 1
        return
    end

    -- expected format: array of scripts; adapt if ScriptBlox uses different structure
    local scripts = {}
    if type(json) == "table" then
        -- try common keys
        if json.scripts then scripts = json.scripts
        elseif json.data then scripts = json.data
        else scripts = json end
    end

    for i, item in ipairs(scripts) do
        local title = tostring(item.name or item.title or ("Script "..i))
        local summary = tostring(item.description or item.summary or "")
        local codeStr = tostring(item.code or item.script or "")
        createResultItem(resultScroll, title, summary, codeStr)
    end

    -- update canvas size
    local total = #scripts
    local h = total * 88
    resultScroll.CanvasSize = UDim2.new(0,0,0, math.max(h,1))
end

searchBtn.MouseButton1Click:Connect(function()
    performSearch(searchBox.Text)
end)
searchBox.FocusLost:Connect(function(enter)
    if enter then performSearch(searchBox.Text) end
end)

-- ===== EDITOR tab UI =====
local editorBox = Instance.new("TextBox", frameAuto)
editorBox.Size = UDim2.new(1,0,1,-100)
editorBox.Position = UDim2.new(0,0,0,0)
editorBox.MultiLine = true
editorBox.TextWrapped = true
editorBox.ClearTextOnFocus = false
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 14
editorBox.Text = "-- Editor: write your script here"

local execBtn = Instance.new("TextButton", frameAuto)
execBtn.Size = UDim2.new(0,120,0,36)
execBtn.Position = UDim2.new(1,-140,1,-48)
execBtn.Text = "Execute"
execBtn.Font = Enum.Font.GothamBold
execBtn.BackgroundColor3 = Color3.fromRGB(60,150,120)
Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0,8)

local clearBtn = execBtn:Clone()
clearBtn.Parent = frameAuto
clearBtn.Position = UDim2.new(1,-280,1,-48)
clearBtn.Text = "Clear"
clearBtn.BackgroundColor3 = Color3.fromRGB(150,60,60)

local saveBtn = execBtn:Clone()
saveBtn.Parent = frameAuto
saveBtn.Position = UDim2.new(1,-20,1,-48)
saveBtn.Text = "Save"

execBtn.MouseButton1Click:Connect(function()
    local code = editorBox.Text
    if code == "" then
        StarterGui:SetCore("SendNotification",{Title="Execute",Text="Editor kosong",Duration=2})
        return
    end
    local ok, res = safeLoadString(code)
    if ok then
        StarterGui:SetCore("SendNotification",{Title="Execute",Text="Script executed",Duration=2})
    else
        StarterGui:SetCore("SendNotification",{Title="Execute Error",Text=tostring(res),Duration=4})
    end
end)

clearBtn.MouseButton1Click:Connect(function() editorBox.Text = "" end)

saveBtn.MouseButton1Click:Connect(function()
    if not hasFileApi then
        StarterGui:SetCore("SendNotification",{Title="Save",Text="Executor tidak mendukung writefile/readfile",Duration=3})
        return
    end
    local filename = "stree_scripts/"..tostring(os.date("%Y%m%d%H%M%S"))..".lua"
    pcall(function()
        -- ensure folder: for many exploits writefile auto-creates paths; if not, just write filename directly
        writefile(filename, editorBox.Text)
    end)
    StarterGui:SetCore("SendNotification",{Title="Save",Text="Tersimpan: "..filename,Duration=3})
end)

-- ===== FOLDER tab logic (uses listfiles/readfile) =====
local folderFrame = frameSearch -- reuse for folder content area
local folderList = Instance.new("ScrollingFrame", frameSearch)
folderList.Size = UDim2.new(1,0,1,-60)
folderList.Position = UDim2.new(0,0,0,60)
folderList.BackgroundTransparency = 1
folderList.Visible = false
local folderLayout = Instance.new("UIListLayout", folderList)
folderLayout.Padding = UDim.new(0,8)

local function refreshFolderList()
    folderList:ClearAllChildren()
    if not hasFileApi then
        local err = Instance.new("TextLabel", folderList)
        err.Text = "Folder/save tidak tersedia pada executor ini."
        err.Size = UDim2.new(1,0,0,30)
        err.BackgroundTransparency = 1
        return
    end
    local ok, files = pcall(function() return listfiles("stree_scripts") end)
    if not ok or type(files) ~= "table" then
        -- try listfiles root
        ok, files = pcall(function() return listfiles("") end)
    end
    if not ok or type(files) ~= "table" then
        local n = Instance.new("TextLabel", folderList)
        n.Text = "Tidak ada file atau listfiles gagal."
        n.Size = UDim2.new(1,0,0,30)
        n.BackgroundTransparency = 1
        return
    end
    for _, f in ipairs(files) do
        if f:lower():find(".lua") or f:lower():find(".txt") then
            local item = Instance.new("Frame", folderList)
            item.Size = UDim2.new(1,-20,0,40)
            item.BackgroundColor3 = Color3.fromRGB(20,20,26)
            local ic = Instance.new("UICorner", item); ic.CornerRadius = UDim.new(0,6)
            local lbl = Instance.new("TextLabel", item)
            lbl.Size = UDim2.new(0.6,0,1,0)
            lbl.Position = UDim2.new(0,10,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = f
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.TextColor3 = Color3.fromRGB(230,230,230)
            local btnRun = Instance.new("TextButton", item)
            btnRun.Size = UDim2.new(0,80,0,28)
            btnRun.Position = UDim2.new(1,-90,0,6)
            btnRun.Text = "Run"
            btnRun.Font = Enum.Font.GothamBold
            btnRun.BackgroundColor3 = Color3.fromRGB(60,150,120)
            Instance.new("UICorner", btnRun).CornerRadius = UDim.new(0,6)
            btnRun.MouseButton1Click:Connect(function()
                local ok2, content = pcall(function() return readfile(f) end)
                if ok2 and content then
                    local ok3, res = safeLoadString(content)
                    StarterGui:SetCore("SendNotification",{Title="Run file",Text=(ok3 and "Executed" or tostring(res)),Duration=3})
                else
                    StarterGui:SetCore("SendNotification",{Title="Run file",Text="Failed readfile",Duration=3})
                end
            end)
            local btnDel = btnRun:Clone()
            btnDel.Parent = item
            btnDel.Position = UDim2.new(1,-180,0,6)
            btnDel.Text = "Delete"
            btnDel.BackgroundColor3 = Color3.fromRGB(150,60,60)
            btnDel.MouseButton1Click:Connect(function()
                pcall(function() writefile(f, "") end) -- some exploits don't have delete, so overwrite
                StarterGui:SetCore("SendNotification",{Title="Delete",Text="Overwrote file (delete may not be available)",Duration=3})
                refreshFolderList()
            end)
        end
    end
    folderList.CanvasSize = UDim2.new(0,0,0, (#folderList:GetChildren()-1) * 48)
end

-- ===== Config tab (simple) =====
local autoExecute = false
local configLabel = Instance.new("TextLabel", frameSearch)
configLabel.Size = UDim2.new(1,0,0,24)
configLabel.Position = UDim2.new(0,0,0,0)
configLabel.BackgroundTransparency = 1
configLabel.Text = "Config"
configLabel.Font = Enum.Font.GothamBold
configLabel.TextSize = 16
configLabel.TextColor3 = Color3.fromRGB(240,240,240)

local toggleBtn = Instance.new("TextButton", frameSearch)
toggleBtn.Size = UDim2.new(0,140,0,36)
toggleBtn.Position = UDim2.new(0,0,0,40)
toggleBtn.Text = "Auto Execute: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)
toggleBtn.MouseButton1Click:Connect(function()
    autoExecute = not autoExecute
    toggleBtn.Text = "Auto Execute: " .. (autoExecute and "ON" or "OFF")
    StarterGui:SetCore("SendNotification",{Title="Config",Text="Auto Execute "..(autoExecute and "enabled" or "disabled"),Duration=2})
end)

-- ===== Console tab logic =====
tabConsole.MouseButton1Click:Connect(function()
    -- show console frame UI
    frameSearch.Visible = false
    frameAuto.Visible = false
    frameConsole.Visible = true
    -- open Roblox dev console
    pcall(function()
        StarterGui:SetCore("DevConsoleVisible", true)
    end)
end)

-- Tab switching wiring
tabServer.MouseButton1Click:Connect(function()
    frameSearch.Visible = true
    frameAuto.Visible = false
    frameConsole.Visible = false
end)
tabAuto.MouseButton1Click:Connect(function()
    frameSearch.Visible = false
    frameAuto.Visible = true
    frameConsole.Visible = false
end)

-- Sidebar nav wiring: switch to appropriate tab
btnSearch.MouseButton1Click:Connect(function()
    frameSearch.Visible = true
    frameAuto.Visible = false
    frameConsole.Visible = false
end)
btnEditor.MouseButton1Click:Connect(function()
    frameSearch.Visible = false
    frameAuto.Visible = true
    frameConsole.Visible = false
end)
btnFolder.MouseButton1Click:Connect(function()
    frameSearch.Visible = false
    frameAuto.Visible = false
    frameConsole.Visible = false
    folderList.Visible = true
    frameSearch.Visible = false
    frameAuto.Visible = false
    frameConsole.Visible = false
    refreshFolderList()
end)
btnConfig.MouseButton1Click:Connect(function()
    frameSearch.Visible = true
    frameAuto.Visible = false
    frameConsole.Visible = false
    -- scroll content to top to show config
end)
btnClose.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- DRAG main (simple)
local dragging = false
local dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
Main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- initial defaults
frameSearch.Visible = true
frameAuto.Visible = false
frameConsole.Visible = false

-- Notification on load
StarterGui:SetCore("SendNotification",{Title="Ronix UI",Text="Loaded. Use Search tab to fetch ScriptBlox results.",Duration=4})

print("Ronix-style UI loaded (search realtime: "..tostring(SCRIPTBLOX_API)..")")
