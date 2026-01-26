--[[
    █     █░ ▄▄▄       ███▄    █   ██████ 
   ▓█░ █ ░█░▒████▄     ██ ▀█   █ ▒██    ▒ 
   ▒█░ █ ░█░▒██  ▀█▄  ▓██  ▀█ ██▒░ ▓██▄   
   ░█░ █ ░█░░██▄▄▄▄██ ▓██▒  ▐▌██▒  ▒   ██▒
   ░░██▒██▓  ▓█   ▓██▒▒██░   ▓██░▒██████▒▒
   ░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░
   
   Project: Wans Studios Hub (System Fixed)
   Developer: Wans Studios
]]

-- =============================================================================
-- 🔒 AYARLAR (DÜZELTİLDİ)
-- =============================================================================
-- Script bu linke "Bu key doğru mu?" diye soracak:
local VerifyLink = "https://wansstudioskeyal.wuaze.com/key.php?action=check&k="

-- Kullanıcı "Key Al" butonuna basınca kopyalanacak link (Linkvertise):
local GetKeyLink = "https://linkvertise.com/3041148/6gmLZTgCNaVc?o=sharing" 

local ArkaPlanGorseli = "rbxassetid://135213223432744" 

-- =============================================================================
-- DEĞİŞKENLER VE SERVİSLER
-- =============================================================================
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local IsMobile = UserInputService.TouchEnabled
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Global UI Referansı
local MainFrameRef = nil 

-- =============================================================================
-- DİL SİSTEMİ
-- =============================================================================
local CurrentLang = "English" 
local UIElements = {} 

local Lang = {
    English = {
        Title = "Driving Empire", Dev = "Developer: Wans Studios", Ver = "Version: 12.9 (Key Fix)",
        CloseKey = "Toggle: 'K' or Button", 
        DiscordBtn = "Copy Discord Link", Copied = "Copied!", DiscordMsg = "Discord link copied.",
        LangSel = "Language / Dil",
        Info = "Info", Player = "Player", Vehicle = "Vehicle", Race = "Race Bot", Farm = "ATM Farm", Police = "Police", Visuals = "Visuals",
        
        PoliceStatus = "Status: Passive", AutoPolice = "Become Police (Auto)",
        CrimList = "Select Criminal", Refresh = "Refresh List",
        AutoArrest = "Auto Arrest (Loop TP)",
        Target = "Target: None", Catching = "Catching %s...", NoCrim = "Target not found!",
        Refreshed = "List Refreshed! (%d found)",

        AntiAfk = "Anti-AFK", Speed = "Speed Hack", Fly = "Character Fly",
        VehRGB = "Vehicle RGB", VehFly = "Vehicle Fly",
        RaceToggle = "Auto Race Bot", FarmStart = "Safe ATM Farm",
        ESP = "Player ESP", VehESP = "Vehicle ESP",
        
        KeyTitle = "Wans Security", KeySub = "Enter Key", KeyPlace = "Paste Key Here...", KeyBtn = "Login", KeyGet = "Get Key",
        KeyCheck = "Checking...", KeySuccess = "SUCCESS!", KeyFail = "INVALID!", KeyErr = "Error!"
    },
    Turkish = {
        Title = "Driving Empire", Dev = "Geliştirici: Wans Studios", Ver = "Sürüm: 12.9 (Key Düzeltme)",
        CloseKey = "Gizleme: 'K' veya Buton", 
        DiscordBtn = "Discord Kopyala", Copied = "Kopyalandı!", DiscordMsg = "Discord kopyalandı.",
        LangSel = "Language / Dil",
        Info = "Bilgi", Player = "Oyuncu", Vehicle = "Araç", Race = "Yarış", Farm = "ATM Farm", Police = "Polis", Visuals = "Görseller",
        
        PoliceStatus = "Durum: Pasif", AutoPolice = "Otomatik Polis Ol",
        CrimList = "Hırsız Seç", Refresh = "Listeyi Yenile",
        AutoArrest = "Otomatik Yakala (Işınlan)",
        Target = "Hedef: Yok", Catching = "%s Yakalanıyor...", NoCrim = "Hedef Bulunamadı!",
        Refreshed = "Liste Yenilendi! (%d kişi)",

        AntiAfk = "Anti-AFK", Speed = "Hız Hilesi", Fly = "Karakter Uçurma",
        VehRGB = "Araç RGB", VehFly = "Araç Uçurma",
        RaceToggle = "Oto Yarış", FarmStart = "Güvenli ATM Farm",
        ESP = "Oyuncu ESP", VehESP = "Araç ESP",
        
        KeyTitle = "Wans Güvenlik", KeySub = "Key Giriniz", KeyPlace = "Key...", KeyBtn = "Giriş", KeyGet = "Key Al",
        KeyCheck = "Kontrol...", KeySuccess = "BAŞARILI!", KeyFail = "HATALI!", KeyErr = "Hata!"
    }
}

local function GetText(key) return Lang[CurrentLang][key] or key end

local function UpdateLanguage()
    for _, item in ipairs(UIElements) do
        if item.Obj and item.Obj.Parent then
            if item.Type == "Label" or item.Type == "Button" or item.Type == "Tab" or item.Type == "Toggle" then
                item.Obj.Text = GetText(item.Key)
            elseif item.Type == "Slider" then
                item.Obj.Text = GetText(item.Key) .. ": " .. (item.Val or 0)
            end
        end
    end
end

local function ToggleUI()
    if MainFrameRef and MainFrameRef.Parent then
        MainFrameRef.Visible = not MainFrameRef.Visible
    end
end

local function MakeDraggable(Frame, OnClick)
    local dragging, dragInput, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        local delta = input.Position - dragStart
                        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
                end
            end)
            local endCon
            endCon = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                    endCon:Disconnect()
                    if (input.Position - dragStart).Magnitude < 5 then
                        if OnClick then OnClick() end
                    end
                end
            end)
        end
    end)
end

if _G.WansUI_Loaded then
    if CoreGui:FindFirstChild("WansMainGui") then CoreGui.WansMainGui:Destroy() end
    if CoreGui:FindFirstChild("WansIntro") then CoreGui.WansIntro:Destroy() end
    if CoreGui:FindFirstChild("WansKeySystem") then CoreGui.WansKeySystem:Destroy() end
    if CoreGui:FindFirstChild("WansMobileButton") then CoreGui.WansMobileButton:Destroy() end
end
_G.WansUI_Loaded = true

local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")

local function CreateUniversalButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WansMobileButton"
    ScreenGui.Parent = CoreGui
    local Button = Instance.new("TextButton")
    Button.Parent = ScreenGui
    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Button.BackgroundTransparency = 0.5
    Button.Position = UDim2.new(0.9, -60, 0.1, 0)
    Button.Size = UDim2.new(0, 50, 0, 50)
    Button.Font = Enum.Font.FredokaOne
    Button.Text = "WANS"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(1, 0); UICorner.Parent = Button
    local UIStroke = Instance.new("UIStroke"); UIStroke.Parent = Button; UIStroke.Color = Color3.fromRGB(255, 255, 255); UIStroke.Thickness = 2
    MakeDraggable(Button, ToggleUI)
end

-- =============================================================================
-- KEY SİSTEMİ (BURASI DÜZELTİLDİ)
-- =============================================================================
local function StartKeySystem(OnSuccess)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "WansKeySystem"
    KeyGui.Parent = CoreGui
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "KeyFrame"
    MainFrame.Parent = KeyGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    if IsMobile then MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100); MainFrame.Size = UDim2.new(0, 300, 0, 200) else MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125); MainFrame.Size = UDim2.new(0, 400, 0, 250) end
    MainFrame.BorderSizePixel = 0
    
    local Bg = Instance.new("ImageLabel", MainFrame); Bg.Size = UDim2.new(1,0,1,0); Bg.Image = ArkaPlanGorseli; Bg.ImageTransparency = 0.6; Bg.ScaleType = Enum.ScaleType.Slice; Bg.SliceCenter = Rect.new(100,100,100,100)
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = Color3.new(0,0,0); Stroke.Thickness = 3
    MakeDraggable(MainFrame, nil)
    
    local Title = Instance.new("TextLabel", MainFrame); Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 5); Title.Size = UDim2.new(1, 0, 0, 30); Title.Font = Enum.Font.FredokaOne; Title.Text = GetText("KeyTitle"); Title.TextColor3 = Color3.new(0,0,0); Title.TextSize = IsMobile and 18 or 24
    
    local KeyBox = Instance.new("TextBox", MainFrame); KeyBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240); KeyBox.Position = UDim2.new(0.1, 0, 0.3, 0); KeyBox.Size = UDim2.new(0.8, 0, 0, 35); KeyBox.Font = Enum.Font.Code; KeyBox.PlaceholderText = GetText("KeyPlace"); KeyBox.Text = ""; KeyBox.TextColor3 = Color3.new(0,0,0); KeyBox.TextSize = 14
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
    
    local function CreateBtn(TextKey, Pos, Callback)
        local Btn = Instance.new("TextButton", MainFrame); Btn.BackgroundColor3 = Color3.new(0,0,0); Btn.Position = Pos; Btn.Size = UDim2.new(0.38, 0, 0, 35); Btn.Font = Enum.Font.GothamBold; Btn.Text = GetText(TextKey); Btn.TextColor3 = Color3.new(1,1,1); Btn.TextSize = 12
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6); Btn.MouseButton1Click:Connect(Callback); return Btn
    end

    local EnterBtn = CreateBtn("KeyBtn", UDim2.new(0.1, 0, 0.55, 0), function()
        local InputKey = KeyBox.Text
        -- Boşlukları temizle
        InputKey = string.gsub(InputKey, "^%s*(.-)%s*$", "%1")
        
        if InputKey == "" then 
            KeyBox.PlaceholderText = "Empty!" 
            return 
        end
        
        KeyBox.Text = GetText("KeyCheck")
        KeyBox.TextColor3 = Color3.new(0,0,0)

        -- Backup Key (Yedek)
        if InputKey == "WANS-DEV-ACCESS" then
            KeyBox.Text = GetText("KeySuccess")
            KeyBox.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(1)
            KeyGui:Destroy()
            OnSuccess()
            return
        end

        -- Siteye Kontrol İsteği Gönder (YENİ MANTIK)
        task.spawn(function()
            -- CACHE SORUNUNU ÇÖZMEK İÇİN SONUNA RASTGELE SAYI EKLİYORUZ (&_ra=...)
            -- Böylece Roblox her seferinde sunucuya gitmek zorunda kalıyor.
            local RequestUrl = VerifyLink .. InputKey .. "&_ra=" .. math.random(1, 100000)
            
            local Success, Response = pcall(function() 
                return game:HttpGet(RequestUrl, true) 
            end)

            if Success then
                -- Gelen cevapta boşluk varsa temizle
                Response = string.gsub(Response, "^%s*(.-)%s*$", "%1")
                
                -- Debug için konsola yazdıralım (F9)
                print("WansHub Server Response: ", Response)
                
                if Response == "valid" then
                    -- BAŞARILI
                    KeyBox.Text = GetText("KeySuccess")
                    KeyBox.TextColor3 = Color3.fromRGB(0, 255, 0)
                    task.wait(1)
                    KeyGui:Destroy()
                    OnSuccess()
                else
                    -- HATALI
                    KeyBox.Text = ""
                    KeyBox.PlaceholderText = GetText("KeyFail")
                    task.wait(1)
                    KeyBox.PlaceholderText = GetText("KeyPlace")
                end
            else
                -- İNTERNET HATASI
                KeyBox.Text = GetText("KeyErr")
                print("HTTP Error:", Response)
            end
        end)
    end)

    CreateBtn("KeyGet", UDim2.new(0.52, 0, 0.55, 0), function()
        setclipboard(GetKeyLink)
        KeyBox.Text = ""
        KeyBox.PlaceholderText = GetText("Copied")
    end)
end

local function LoadMainScript()
    local function PlayIntro()
        local IntroGui = Instance.new("ScreenGui", CoreGui); IntroGui.Name = "WansIntro"; IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local BlackScreen = Instance.new("Frame", IntroGui); BlackScreen.Size = UDim2.new(1,0,1,0); BlackScreen.BackgroundColor3 = Color3.new(1,1,1); BlackScreen.BorderSizePixel = 0
        local MainLabel = Instance.new("TextLabel", IntroGui); MainLabel.AnchorPoint = Vector2.new(0.5, 0.5); MainLabel.Position = UDim2.new(0.5, 0, 0.5, 0); MainLabel.Size = UDim2.new(0, 400, 0, 100); MainLabel.BackgroundTransparency = 1; MainLabel.Text = "Wans Studios"; MainLabel.Font = Enum.Font.FredokaOne; MainLabel.TextSize = 0; MainLabel.TextColor3 = Color3.new(0,0,0); MainLabel.TextTransparency = 1
        TweenService:Create(MainLabel, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {TextSize = 36, TextTransparency = 0}):Play()
        task.wait(2.5); TweenService:Create(BlackScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play(); TweenService:Create(MainLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.5); IntroGui:Destroy()
    end
    PlayIntro()

    local Settings = {Speed=false, SpeedVal=16, Fly=false, FlySpeed=50, CarFly=false, CarFlySpeed=100, RainbowCar=false, RaceBot=false, CheckpointDelay=0.5, ATMFarm=false, BagLimit=25}
    local WansConfig = {task1=0.5, task2=2.0, task3=0.15, task4=5.0, task5=0.15, task6=0.0, task7=5.0, task8=0.0}

    -- UI LIBRARY
    local WansLib = {}
    local UIConfig = {MainColor=Color3.fromRGB(255, 255, 255), AccentColor=Color3.fromRGB(0, 0, 0), TextColor=Color3.fromRGB(0, 0, 0), ItemColor=Color3.fromRGB(255, 255, 255), Transparency=1, Font=Enum.Font.FredokaOne}

    function WansLib:CreateWindow(TitleKey)
        local WansGui = Instance.new("ScreenGui", CoreGui); WansGui.Name = "WansMainGui"; WansGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        local MainFrame = Instance.new("Frame", WansGui); MainFrame.Name = "MainFrame"; MainFrame.BackgroundColor3 = UIConfig.MainColor; MainFrame.BackgroundTransparency = 1
        MainFrameRef = MainFrame 
        if IsMobile then MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150); MainFrame.Size = UDim2.new(0, 400, 0, 300) else MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225); MainFrame.Size = UDim2.new(0, 650, 0, 450) end
        MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true 
        local BgImage = Instance.new("ImageLabel", MainFrame); BgImage.Size = UDim2.new(1, 0, 1, 0); BgImage.Image = ArkaPlanGorseli; BgImage.ScaleType = Enum.ScaleType.Slice; BgImage.SliceCenter = Rect.new(100,100,100,100); BgImage.ImageTransparency = 0; BgImage.ZIndex = 0
        local LightOverlay = Instance.new("Frame", MainFrame); LightOverlay.Size = UDim2.new(1, 0, 1, 0); LightOverlay.BackgroundColor3 = Color3.new(1,1,1); LightOverlay.BackgroundTransparency = 0.9; LightOverlay.ZIndex = 0
        local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Color = Color3.new(0,0,0); UIStroke.Thickness = 3
        MakeDraggable(MainFrame, nil)
        local Title = Instance.new("TextLabel", MainFrame); Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 20, 0, 0); Title.Size = UDim2.new(1, -40, 0, 50); Title.Font = UIConfig.Font; Title.Text = GetText(TitleKey) .. "  //  Wans"; Title.TextColor3 = Color3.new(0,0,0); Title.TextSize = IsMobile and 18 or 24; Title.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(UIElements, {Obj = Title, Key = TitleKey, Type = "Label"})
        local Line = Instance.new("Frame", MainFrame); Line.BackgroundColor3 = Color3.new(0,0,0); Line.BorderSizePixel = 0; Line.Position = UDim2.new(0, 0, 0, 50); Line.Size = UDim2.new(1, 0, 0, 3)
        local CloseBtn = Instance.new("TextButton", MainFrame); CloseBtn.BackgroundTransparency = 1; CloseBtn.Position = UDim2.new(1, -40, 0, 10); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Font = UIConfig.Font; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(0,0,0); CloseBtn.TextSize = 16
        CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
        local TabW = IsMobile and 100 or 160
        local TabContainer = Instance.new("ScrollingFrame", MainFrame); TabContainer.BackgroundColor3 = Color3.new(1,1,1); TabContainer.BackgroundTransparency = 0.9; TabContainer.BorderSizePixel = 2; TabContainer.BorderColor3 = Color3.new(0,0,0); TabContainer.Position = UDim2.new(0, 10, 0, 60); TabContainer.Size = UDim2.new(0, TabW, 1, -70); TabContainer.ScrollBarThickness = 2
        local TabListLayout = Instance.new("UIListLayout", TabContainer); TabListLayout.Padding = UDim.new(0, 5); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local TabPadding = Instance.new("UIPadding", TabContainer); TabPadding.PaddingTop = UDim.new(0, 5)
        local PageContainer = Instance.new("Frame", MainFrame); PageContainer.BackgroundTransparency = 1; PageContainer.Position = UDim2.new(0, TabW + 20, 0, 60); PageContainer.Size = UDim2.new(1, -(TabW + 30), 1, -70)
        local Window = {Gui = WansGui, Main = MainFrame, Tabs = TabContainer, Pages = PageContainer, ActiveTab = nil}
        CreateUniversalButton() 
        function Window:Notify(TitleKey, TextKey, Duration)
            local NFrame = Instance.new("Frame", WansGui); NFrame.BackgroundColor3 = Color3.new(1,1,1); NFrame.Position = UDim2.new(1, 0, 0.8, 0); NFrame.Size = UDim2.new(0, 200, 0, 60); Instance.new("UIStroke", NFrame).Color = Color3.new(0,0,0); NFrame.UIStroke.Thickness = 2
            local NText = Instance.new("TextLabel", NFrame); NText.BackgroundTransparency = 1; NText.Size = UDim2.new(1,0,1,0); NText.Text = GetText(TextKey); NText.TextColor3 = Color3.new(0,0,0); NText.Font = UIConfig.Font; NText.TextSize = 12; NText.TextWrapped = true
            NFrame:TweenPosition(UDim2.new(1, -210, 0.8, 0), "Out", "Back", 0.5); task.delay(Duration or 2, function() NFrame:TweenPosition(UDim2.new(1, 0, 0.8, 0), "In", "Quad", 0.5); task.wait(0.5); NFrame:Destroy() end)
        end
        return Window
    end

    function WansLib:CreateTab(Window, NameKey)
        local TabButton = Instance.new("TextButton", Window.Tabs); TabButton.BackgroundColor3 = Color3.new(1,1,1); TabButton.BackgroundTransparency = 0.5; TabButton.BorderSizePixel = 2; TabButton.BorderColor3 = Color3.new(0,0,0); TabButton.Size = UDim2.new(0, IsMobile and 90 or 140, 0, 30); TabButton.Font = UIConfig.Font; TabButton.Text = GetText(NameKey); TabButton.TextColor3 = Color3.new(0,0,0); TabButton.TextSize = 12
        table.insert(UIElements, {Obj = TabButton, Key = NameKey, Type = "Tab"})
        local PageFrame = Instance.new("ScrollingFrame", Window.Pages); PageFrame.BackgroundTransparency = 1; PageFrame.Size = UDim2.new(1, 0, 1, 0); PageFrame.Visible = false; PageFrame.ScrollBarThickness = 2; local PageLayout = Instance.new("UIListLayout", PageFrame); PageLayout.Padding = UDim.new(0, 5)
        TabButton.MouseButton1Click:Connect(function() for _, obj in pairs(Window.Pages:GetChildren()) do obj.Visible = false end; for _, btn in pairs(Window.Tabs:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.new(1,1,1); btn.BackgroundTransparency = 0.5; btn.TextColor3 = Color3.new(0,0,0) end end; TabButton.BackgroundColor3 = Color3.new(0,0,0); TabButton.BackgroundTransparency = 0; TabButton.TextColor3 = Color3.new(1,1,1); PageFrame.Visible = true end)
        if not Window.ActiveTab then Window.ActiveTab = TabButton; PageFrame.Visible = true; TabButton.BackgroundColor3 = Color3.new(0,0,0); TabButton.BackgroundTransparency = 0; TabButton.TextColor3 = Color3.new(1,1,1) end
        local Elements = {}
        function Elements:CreateButton(TextKey, Callback)
            local Btn = Instance.new("TextButton", PageFrame); Btn.BackgroundColor3 = Color3.new(1,1,1); Btn.BackgroundTransparency = 0.6; Btn.BorderSizePixel = 2; Btn.BorderColor3 = Color3.new(0,0,0); Btn.Size = UDim2.new(1, -5, 0, 35); Btn.Font = UIConfig.Font; Btn.Text = GetText(TextKey); Btn.TextColor3 = Color3.new(0,0,0); Btn.TextSize = 12
            table.insert(UIElements, {Obj = Btn, Key = TextKey, Type = "Button"})
            Btn.MouseButton1Up:Connect(function() pcall(Callback) end)
        end
        function Elements:CreateToggle(TextKey, Default, Callback)
            local Enabled = Default or false
            local ToggleFrame = Instance.new("Frame", PageFrame); ToggleFrame.BackgroundColor3 = Color3.new(1,1,1); ToggleFrame.BackgroundTransparency = 0.6; ToggleFrame.BorderSizePixel = 2; ToggleFrame.BorderColor3 = Color3.new(0,0,0); ToggleFrame.Size = UDim2.new(1, -5, 0, 35)
            local Label = Instance.new("TextLabel", ToggleFrame); Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 5, 0, 0); Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Font = UIConfig.Font; Label.Text = GetText(TextKey); Label.TextColor3 = Color3.new(0,0,0); Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(UIElements, {Obj = Label, Key = TextKey, Type = "Toggle"})
            local Indicator = Instance.new("TextButton", ToggleFrame); Indicator.Position = UDim2.new(0.85, 0, 0.5, -10); Indicator.Size = UDim2.new(0, 20, 0, 20); Indicator.Text = Enabled and "X" or ""; Indicator.TextColor3 = Color3.new(0,0,0); Indicator.TextSize = 14; Indicator.Font = Enum.Font.FredokaOne; Indicator.BackgroundColor3 = Color3.new(1,1,1); Indicator.BackgroundTransparency = 0.2; Indicator.BorderSizePixel = 2; Indicator.BorderColor3 = Color3.new(0,0,0)
            local function Update() Enabled = not Enabled; Indicator.Text = Enabled and "X" or ""; pcall(Callback, Enabled) end; Indicator.MouseButton1Click:Connect(Update)
        end
        function Elements:CreateLabel(TextKey)
            local Lbl = Instance.new("TextLabel", PageFrame); Lbl.BackgroundColor3 = Color3.new(1,1,1); Lbl.BackgroundTransparency = 0.7; Lbl.BorderSizePixel = 1; Lbl.BorderColor3 = Color3.new(0,0,0); Lbl.Size = UDim2.new(1, -5, 0, 25); Lbl.Font = Enum.Font.Code; Lbl.Text = "  " .. GetText(TextKey); Lbl.TextColor3 = Color3.new(0,0,0); Lbl.TextSize = 11; Lbl.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(UIElements, {Obj = Lbl, Key = TextKey, Type = "Label"}); return Lbl
        end
        function Elements:CreateSlider(TextKey, Min, Max, Default, Callback)
            local Value = Default
            local SliderFrame = Instance.new("Frame", PageFrame); SliderFrame.BackgroundColor3 = Color3.new(1,1,1); SliderFrame.BackgroundTransparency = 0.6; SliderFrame.BorderSizePixel = 2; SliderFrame.BorderColor3 = Color3.new(0,0,0); SliderFrame.Size = UDim2.new(1, -5, 0, 45)
            local Label = Instance.new("TextLabel", SliderFrame); Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0,5,0,2); Label.Size = UDim2.new(1,-10,0,15); Label.Text = GetText(TextKey) .. ": " .. Value; Label.TextColor3 = Color3.new(0,0,0); Label.Font = UIConfig.Font; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(UIElements, {Obj = Label, Key = TextKey, Type = "Slider", Val = Value})
            local SlideBg = Instance.new("TextButton", SliderFrame); SlideBg.BackgroundColor3 = Color3.new(1,1,1); SlideBg.BackgroundTransparency = 0.5; SlideBg.BorderColor3 = Color3.new(0,0,0); SlideBg.BorderSizePixel = 2; SlideBg.Position = UDim2.new(0, 5, 0, 25); SlideBg.Size = UDim2.new(1, -10, 0, 10); SlideBg.Text = ""; SlideBg.AutoButtonColor = false
            local Fill = Instance.new("Frame", SlideBg); Fill.BackgroundColor3 = Color3.new(0,0,0); Fill.BorderSizePixel = 0; Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            local dragging = false; SlideBg.MouseButton1Down:Connect(function() dragging = true end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local pos = math.clamp((input.Position.X - SlideBg.AbsolutePosition.X) / SlideBg.AbsoluteSize.X, 0, 1); local newValue = math.floor(Min + (Max - Min) * pos); if newValue ~= Value then Value = newValue; Fill.Size = UDim2.new(pos, 0, 1, 0); Label.Text = GetText(TextKey) .. ": " .. Value; for _, e in ipairs(UIElements) do if e.Obj == Label then e.Val = Value end end; pcall(Callback, Value) end end end)
        end
        function Elements:CreateDropdown(Text, Options, Default, Callback)
            local DropFrame = Instance.new("Frame", PageFrame); DropFrame.BackgroundColor3 = Color3.new(1,1,1); DropFrame.BackgroundTransparency = 0.6; DropFrame.BorderSizePixel = 2; DropFrame.BorderColor3 = Color3.new(0,0,0); DropFrame.Size = UDim2.new(1, -5, 0, 35); DropFrame.ClipsDescendants = true
            local Label = Instance.new("TextLabel", DropFrame); Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0,5,0,0); Label.Size = UDim2.new(0.6,0,0,35); Label.Text = Text; Label.TextColor3 = Color3.new(0,0,0); Label.Font = UIConfig.Font; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left
            local CurrentOption = Instance.new("TextButton", DropFrame); CurrentOption.Position = UDim2.new(0.6, 0, 0, 5); CurrentOption.Size = UDim2.new(0.38, 0, 0, 25); CurrentOption.BackgroundColor3 = Color3.new(1,1,1); CurrentOption.BorderColor3 = Color3.new(0,0,0); CurrentOption.BorderSizePixel = 2; CurrentOption.Font = Enum.Font.Code; CurrentOption.Text = Default; CurrentOption.TextColor3 = Color3.new(0,0,0); CurrentOption.TextSize = 11
            local ListFrame = Instance.new("ScrollingFrame", DropFrame); ListFrame.Position = UDim2.new(0, 0, 0, 40); ListFrame.Size = UDim2.new(1, 0, 0, 100); ListFrame.BackgroundTransparency = 1; ListFrame.BorderSizePixel = 0; ListFrame.ScrollBarThickness = 2; local ListLayout = Instance.new("UIListLayout", ListFrame); ListLayout.Padding = UDim.new(0, 2)
            local Expanded = false; CurrentOption.MouseButton1Click:Connect(function() Expanded = not Expanded; DropFrame:TweenSize(Expanded and UDim2.new(1, -5, 0, 150) or UDim2.new(1, -5, 0, 35), "Out", "Quad", 0.2) end)
            local function RefreshList()
                 for _, child in ipairs(ListFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
                 local currentOptions = type(Options) == "function" and Options() or Options
                 for _, opt in ipairs(currentOptions) do 
                    local Btn = Instance.new("TextButton", ListFrame); Btn.Size = UDim2.new(1, -10, 0, 25); Btn.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9); Btn.Text = opt; Btn.TextColor3 = Color3.new(0,0,0); Btn.Font = UIConfig.Font; Btn.TextSize = 11
                    Btn.MouseButton1Click:Connect(function() CurrentOption.Text = opt; Expanded = false; DropFrame:TweenSize(UDim2.new(1, -5, 0, 35), "Out", "Quad", 0.2); pcall(Callback, opt) end) 
                 end
            end
            RefreshList()
            return {Refresh = RefreshList}
        end
        return Elements
    end

    local Remotes, RemoteEvents = nil, {}
    task.spawn(function() local s, r = pcall(function() return ReplicatedStorage:WaitForChild("Remotes", 5) end); if s and r then Remotes = r; RemoteEvents.BustStart = Remotes:FindFirstChild("AttemptATMBustStart"); RemoteEvents.BustEnd = Remotes:FindFirstChild("AttemptATMBustComplete"); RemoteEvents.JobStart = Remotes:FindFirstChild("RequestStartJobSession"); RemoteEvents.JobEnd = Remotes:FindFirstChild("RequestEndJobSession") end end)
    local function TP(pos) if LocalPlayer.Character then if typeof(pos) == "Vector3" then LocalPlayer.Character:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0))) elseif typeof(pos) == "CFrame" then LocalPlayer.Character:PivotTo(pos) end end end
    local noclipConnection = nil; local function SetNoclip(state) if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end if state then noclipConnection = RunService.Stepped:Connect(function() if LocalPlayer.Character then for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end) end end
    local function setWeight(isHeavy) local char = LocalPlayer.Character if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CustomPhysicalProperties = isHeavy and PhysicalProperties.new(100, 0.3, 0.5) or nil end end end end
    local platformPositions = {Vector3.new(-978.88, -166, 313.34), Vector3.new(-484.32, -166, -1226.45), Vector3.new(220.62, -166, 137.81), Vector3.new(-94.29, -166, 2340.52), Vector3.new(-866.12, -166, 3189.41), Vector3.new(-2068.16, -166, 4206.78)}
    local sellPos1 = Vector3.new(-2520.49, 15.11, 4035.56); local sellPos2 = Vector3.new(-2542.12, 15.11, 4030.91); local spawnPos = Vector3.new(-315.45, 17.59, -1660.68)
    local function createAllPlatforms() for _, pos in ipairs(platformPositions) do local platform = Instance.new("Part"); platform.Name = "WansPlatform"; platform.Parent = Workspace; platform.Position = pos; platform.Size = Vector3.new(50000, 3, 50000); platform.Color = Color3.fromRGB(0, 0, 0); platform.Anchored = true end end
    local function removeAllPlatforms() for _, obj in ipairs(Workspace:GetChildren()) do if obj.Name == "WansPlatform" then obj:Destroy() end end end
    local function SimpleGoTo(destination, timeout) local char = LocalPlayer.Character; local human = char and char:FindFirstChildOfClass("Humanoid"); local root = char and char:FindFirstChild("HumanoidRootPart"); if not root or not human then return end; local startT = tick(); timeout = timeout or 2; while (root.Position - destination).Magnitude > 3 do if not Settings.ATMFarm or (tick() - startT) > timeout then break end; human:MoveTo(destination); if root.AssemblyLinearVelocity.Magnitude < 0.5 then human.Jump = true end; task.wait(0.1) end end
    local function CheckBagLimit(StatusLabel) if not Settings.ATMFarm then return false end; local currentCrimes = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0; if currentCrimes >= Settings.BagLimit then if StatusLabel then StatusLabel.Text = string.format(GetText("FullBag"), currentCrimes) end; while currentCrimes >= Settings.BagLimit and Settings.ATMFarm do SetNoclip(true); TP(sellPos1); task.wait(WansConfig.task1); if StatusLabel then StatusLabel.Text = GetText("Walking") end; SimpleGoTo(sellPos2, 2); task.wait(WansConfig.task2); currentCrimes = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0 end; if StatusLabel then StatusLabel.Text = GetText("Sold") end; return true end; return false end
    local function GetAvailableATM() local spawners = Workspace.Game.Jobs.CriminalATMSpawners; for _, spawner in ipairs(spawners:GetChildren()) do local atm = spawner:FindFirstChild("CriminalATM"); if atm and atm:GetAttribute("State") == "Normal" then return spawner, atm end end; return nil, nil end
    local function SmartBust(targetSpawner, atmModel, StatusLabel) if not Settings.ATMFarm then return end; local safePos = platformPositions[math.random(1, #platformPositions)]; local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if StatusLabel then StatusLabel.Text = GetText("Robbing") end; if root then root.AssemblyLinearVelocity = Vector3.new(0,0,0) end; TP(targetSpawner.Position); task.wait(WansConfig.task3); RemoteEvents.BustStart:InvokeServer(atmModel); if StatusLabel then StatusLabel.Text = GetText("Waiting") end; TP(safePos); task.wait(WansConfig.task4); if StatusLabel then StatusLabel.Text = GetText("Robbing") end; if root then root.AssemblyLinearVelocity = Vector3.new(0,0,0) end; TP(targetSpawner.Position); task.wait(WansConfig.task5); RemoteEvents.BustEnd:InvokeServer(atmModel); task.wait(WansConfig.task6); TP(safePos); CheckBagLimit(StatusLabel) end
    local function GetVehicle() local f = Workspace:FindFirstChild("Vehicles"); if not f then return nil end; for _, v in pairs(f:GetChildren()) do local o = v:FindFirstChild("Owner"); if o and o.Value == LocalPlayer.Name then return v end end; return nil end

    local MainWindow = WansLib:CreateWindow("Title")
    local Notify = function(t, c) MainWindow:Notify(t, c, 3) end
    local TabInfo = WansLib:CreateTab(MainWindow, "Info")
    local TabPlayer = WansLib:CreateTab(MainWindow, "Player")
    local TabPolice = WansLib:CreateTab(MainWindow, "Police")
    local TabCar = WansLib:CreateTab(MainWindow, "Vehicle")
    local TabRace = WansLib:CreateTab(MainWindow, "Race")
    local TabFarm = WansLib:CreateTab(MainWindow, "Farm")
    local TabVisuals = WansLib:CreateTab(MainWindow, "Visuals")

    TabInfo:CreateDropdown("Language / Dil", {"English", "Turkish"}, "English", function(Option) if Option ~= CurrentLang then CurrentLang = Option; UpdateLanguage(); Notify("Info", GetText("Copied") == "Kopyalandı!" and "Dil Değiştirildi!" or "Language Changed!") end end)
    TabInfo:CreateLabel("Dev"); TabInfo:CreateLabel("Ver"); TabInfo:CreateLabel("CloseKey")
    TabInfo:CreateButton("DiscordCopy", function() setclipboard("https://discord.gg/mX4EngC6pw"); Notify("Copied", "DiscordMsg") end)

    local AntiAfkConn = nil
    TabPlayer:CreateToggle("AntiAfk", false, function(v) if v then AntiAfkConn = LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame) end); Notify("AntiAfk", "AntiAfkOn") else if AntiAfkConn then AntiAfkConn:Disconnect() AntiAfkConn = nil end; Notify("AntiAfk", "AntiAfkOff") end end)
    TabPlayer:CreateToggle("Speed", false, function(v) Settings.Speed = v; if not v and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = 16 end end)
    TabPlayer:CreateSlider("SpeedVal", 16, 300, 16, function(v) Settings.SpeedVal = v end)
    TabPlayer:CreateToggle("Fly", false, function(v) Settings.Fly = v; if v then local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid"); if hrp and hum then hum.PlatformStand = true; local bv = Instance.new("BodyVelocity", hrp); bv.Name = "WansFlyV"; bv.MaxForce = Vector3.new(9e9,9e9,9e9); local bg = Instance.new("BodyGyro", hrp); bg.Name = "WansFlyG"; bg.MaxTorque = Vector3.new(9e9,9e9,9e9); task.spawn(function() while Settings.Fly and char.Parent do local cam = Workspace.CurrentCamera.CFrame; local dir = Vector3.new(); if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end; bg.CFrame = cam; bv.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.new(); task.wait() end; bv:Destroy(); bg:Destroy(); hum.PlatformStand = false end) end else pcall(function() LocalPlayer.Character.HumanoidRootPart.WansFlyV:Destroy(); LocalPlayer.Character.Humanoid.PlatformStand = false end) end end)
    TabPlayer:CreateSlider("FlySpeed", 10, 500, 50, function(v) Settings.FlySpeed = v end)
    TabPlayer:CreateButton("ServerHop", function() Notify("Info", "Searching"); local Http = game:GetService("HttpService"); local TPS = game:GetService("TeleportService"); local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"; local function ListServers(cursor) return Http:JSONDecode(game:HttpGet(Api .. ((cursor and "&cursor="..cursor) or ""))) end; local Server; repeat local Servers = ListServers(Next); Server = Servers.data[1]; Next = Servers.nextPageCursor until Server; TPS:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer) end)

    local PoliceStatus = TabPolice:CreateLabel("PoliceStatus")
    local TargetPlayer = nil
    TabPolice:CreateToggle("AutoPolice", false, function(v) if v then pcall(function() RemoteEvents.JobStart:FireServer("Security", "jobPad") end); Notify("Info", "Job: Security") end end)
    local function RefreshCriminals() local crims = {}; for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then local jobId = p:GetAttribute("JobId"); local wanted = p:GetAttribute("Wanted"); if jobId == "Criminal" or wanted == true then table.insert(crims, p.Name) end end end; return crims end
    local CrimDropdownObj = TabPolice:CreateDropdown("CrimList", RefreshCriminals, "Select...", function(Selected) TargetPlayer = Players:FindFirstChild(Selected); if TargetPlayer then PoliceStatus.Text = string.format(GetText("Target")..": %s", Selected) else PoliceStatus.Text = GetText("Target")..": None" end end)
    TabPolice:CreateButton("Refresh", function() if CrimDropdownObj and CrimDropdownObj.Refresh then CrimDropdownObj.Refresh(); local c = RefreshCriminals(); Notify("Info", string.format(GetText("Refreshed"), #c)) end end)
    local AutoArrestActive = false
    TabPolice:CreateToggle("AutoArrest", false, function(v) AutoArrestActive = v; if v then if not TargetPlayer then Notify("Error", GetText("NoCrim")); AutoArrestActive = false; return end; task.spawn(function() while AutoArrestActive and TargetPlayer do if not TargetPlayer.Parent or not TargetPlayer.Character or not TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then Notify("Info", "Target Lost / Escaped"); break end; local tRoot = TargetPlayer.Character.HumanoidRootPart; local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if myRoot and tRoot then PoliceStatus.Text = string.format(GetText("Catching"), TargetPlayer.Name); myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1) end; task.wait() end; PoliceStatus.Text = GetText("PoliceStatus") end) end end)

    TabCar:CreateToggle("VehRGB", false, function(v) Settings.RainbowCar = v end)
    TabCar:CreateToggle("VehFly", false, function(v) Settings.CarFly = v end)
    TabCar:CreateSlider("VehSpeed", 50, 800, 100, function(v) Settings.CarFlySpeed = v end)

    local RaceStatus = TabRace:CreateLabel("RaceStatus")
    TabRace:CreateToggle("RaceToggle", false, function(v) Settings.RaceBot = v; RaceStatus.Text = v and "  "..GetText("RaceActive") or "  "..GetText("RaceStatus") end)
    TabRace:CreateSlider("CheckDelay", 0, 2, 0.5, function(v) Settings.CheckpointDelay = v end)

    local FarmStatus = TabFarm:CreateLabel("FarmStatus"); local BagStatus = TabFarm:CreateLabel("BagStatus")
    TabFarm:CreateToggle("FarmStart", false, function(v) Settings.ATMFarm = v; if v then FarmStatus.Text = "  "..GetText("Preparing"); pcall(function() RemoteEvents.JobStart:FireServer("Criminal", "jobPad") end); task.wait(0.5); removeAllPlatforms(); createAllPlatforms(); SetNoclip(true); setWeight(true); task.spawn(function() while Settings.ATMFarm do CheckBagLimit(FarmStatus); for _, platformPos in ipairs(platformPositions) do if not Settings.ATMFarm then break end; if CheckBagLimit(FarmStatus) then TP(platformPos) end; SetNoclip(true); setWeight(true); FarmStatus.Text = "  "..GetText("Scanning"); TP(platformPos); task.wait(WansConfig.task7); local spawner, atm = GetAvailableATM(); if spawner and atm then SmartBust(spawner, atm, FarmStatus); FarmStatus.Text = "  "..GetText("Cooldown"); task.wait(WansConfig.task8) end end; task.wait(0.1) end; FarmStatus.Text = "  "..GetText("Stopped"); TP(spawnPos); pcall(function() RemoteEvents.JobEnd:FireServer("jobPad") end); SetNoclip(false); setWeight(false); removeAllPlatforms() end) else FarmStatus.Text = "  "..GetText("Stopping") end end)
    TabFarm:CreateSlider("BagLimit", 5, 100, 25, function(v) Settings.BagLimit = v end)

    local ESP = {Enabled = false, Veh = false}
    TabVisuals:CreateToggle("ESP", false, function(v) ESP.Enabled = v end)
    TabVisuals:CreateToggle("VehESP", false, function(v) ESP.Veh = v end)

    RunService.RenderStepped:Connect(function()
        if Settings.ATMFarm and LocalPlayer.Character then local cb = LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0; BagStatus.Text = (CurrentLang=="English" and "  Bag: " or "  Çanta: ")..cb.." / "..Settings.BagLimit end
        if Settings.Speed and LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChild("Humanoid"); local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if hum and hrp and hum.MoveDirection.Magnitude > 0 then hrp.Velocity = Vector3.new(hum.MoveDirection.X * Settings.SpeedVal, hrp.Velocity.Y, hum.MoveDirection.Z * Settings.SpeedVal) end end
        local car = GetVehicle()
        if car and Settings.RainbowCar then local c = Color3.fromHSV(tick() % 5 / 5, 1, 1); for _, p in pairs(car:GetDescendants()) do if p:IsA("BasePart") then p.Color = c end end end
        if car and Settings.CarFly and car.PrimaryPart then local pp=car.PrimaryPart; local vFly=pp:FindFirstChild("CarFlyVel") or Instance.new("BodyVelocity", pp); vFly.Name="CarFlyVel"; vFly.MaxForce=Vector3.new(9e9,9e9,9e9); local vGyro=pp:FindFirstChild("CarFlyGyro") or Instance.new("BodyGyro", pp); vGyro.Name="CarFlyGyro"; vGyro.MaxTorque=Vector3.new(9e9,9e9,9e9); vGyro.P=1000; vGyro.D=50; local cam=Workspace.CurrentCamera.CFrame; local dir=Vector3.new(); if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end; vGyro.CFrame=cam; vFly.Velocity=dir.Magnitude>0 and dir.Unit*Settings.CarFlySpeed or Vector3.new() end
        if ESP.Enabled then for _, p in pairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character and not p.Character:FindFirstChild("WansHighlight") then local h=Instance.new("Highlight", p.Character); h.Name="WansHighlight"; h.FillColor=Color3.fromRGB(255,0,0); h.OutlineColor=Color3.new(1,1,1) end end else for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("WansHighlight") then p.Character.WansHighlight:Destroy() end end end
        if ESP.Veh then local vehFolder = Workspace:FindFirstChild("Vehicles"); if vehFolder then for _, veh in pairs(vehFolder:GetChildren()) do if veh:FindFirstChild("Owner") and not veh:FindFirstChild("WansVehHighlight") then local h = Instance.new("Highlight", veh); h.Name = "WansVehHighlight"; h.FillColor = Color3.fromRGB(0, 0, 255); h.OutlineColor = Color3.new(1,1,1) end end end else local vehFolder = Workspace:FindFirstChild("Vehicles"); if vehFolder then for _, veh in pairs(vehFolder:GetChildren()) do if veh:FindFirstChild("WansVehHighlight") then veh.WansVehHighlight:Destroy() end end end end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if Settings.RaceBot then
                local car = GetVehicle()
                if car and car:FindFirstChild("VehicleSeat") then
                    local cp = {}; local fl = nil
                    local folders = {Workspace}; if Workspace:FindFirstChild("Game") then table.insert(folders, Workspace.Game) end; if Workspace:FindFirstChild("Races") then table.insert(folders, Workspace.Races) end
                    for _, f in pairs(folders) do for _, o in pairs(f:GetDescendants()) do if o:IsA("BasePart") and o.Transparency < 1 then if tonumber(o.Name) then table.insert(cp, o) elseif o.Name:lower():find("finish") then fl = o end end end end
                    table.sort(cp, function(a,b) return tonumber(a.Name) < tonumber(b.Name) end); if fl then table.insert(cp, fl) end
                    if #cp > 0 then RaceStatus.Text = string.format("  "..GetText("RaceStart"), #cp); for _, p in ipairs(cp) do if not Settings.RaceBot then break; end; if (car.PrimaryPart.Position - p.Position).Magnitude > 20 then car:PivotTo(p.CFrame * CFrame.new(0, 2, 0)); if car.VehicleSeat then car.VehicleSeat.AssemblyLinearVelocity = car.VehicleSeat.CFrame.LookVector * 150 end; task.wait(Settings.CheckpointDelay) end end; RaceStatus.Text = "  "..GetText("RaceFinish"); task.wait(2) else RaceStatus.Text = "  "..GetText("RaceActive") end
                else RaceStatus.Text = "  "..GetText("NoVeh") end
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp) if gp then return end; if input.KeyCode == Enum.KeyCode.K then ToggleUI() end end)
end

StartKeySystem(LoadMainScript)
