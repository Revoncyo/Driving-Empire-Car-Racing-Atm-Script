--[[
    █     █░ ▄▄▄       ███▄    █   ██████ 
   ▓█░ █ ░█░▒████▄     ██ ▀█   █ ▒██    ▒ 
   ▒█░ █ ░█░▒██  ▀█▄  ▓██  ▀█ ██▒░ ▓██▄   
   ░█░ █ ░█░░██▄▄▄▄██ ▓██▒  ▐▌██▒  ▒   ██▒
   ░░██▒██▓  ▓█   ▓██▒▒██░   ▓██░▒██████▒▒
   ░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░
   
   Project: Wans Studios Hub (Ultimate Edition)
   Game: Driving Empire
   Version: 29.4 (Race Float Fix + Instant Torque + Nitro)
   Developer: Wans Studios
]]

-- =============================================================================
-- 🛡️ BAŞLANGIÇ KONTROLLERİ (Singleton)
-- =============================================================================
if getgenv().WansLoaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wans Studios";
        Text = "Script already running! / Script zaten çalışıyor!";
        Duration = 5;
    })
    return
end
getgenv().WansLoaded = true

-- =============================================================================
-- ⚙️ SERVİSLER VE AYARLAR
-- =============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Global Değişkenler
local TrackingConnection = nil 
local CurrentTargetPlayer = nil

-- Config
local KeyLink = "https://revohubkey.wuaze.com/?pass=RevoSecretPass2026" 
local LogoID = "rbxassetid://76940090310301"

-- UI Renk Paleti (NEON RED THEME)
local Theme = {
    Background = Color3.fromRGB(15, 5, 5), 
    Sidebar = Color3.fromRGB(20, 8, 8),
    Accent = Color3.fromRGB(255, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    ElementBg = Color3.fromRGB(25, 10, 10),
    Hover = Color3.fromRGB(40, 20, 20),
    Red = Color3.fromRGB(255, 50, 50),
    Blue = Color3.fromRGB(80, 150, 255)
}

-- =============================================================================
-- 🔐 KEY ALGORİTMASI
-- =============================================================================
local function GetCorrectKey()
    local TurkiyeZamani = os.time() + (3 * 3600)
    local Gun = tonumber(os.date("!%d", TurkiyeZamani))
    local Ay = tonumber(os.date("!%m", TurkiyeZamani))
    local Yil = tonumber(os.date("!%Y", TurkiyeZamani))
    local Saat = tonumber(os.date("!%H", TurkiyeZamani))
    local Hesap = (Gun * Ay * Yil) + (Saat * 99) + 1453
    return "REVO-" .. tostring(Hesap)
end

-- =============================================================================
-- 🌍 DİL SİSTEMİ (GÜNCELLENDİ)
-- =============================================================================
local CurrentLang = "English"
local TextRegistry = {} 

local Lang = {
    English = {
        Title = "Driving Empire", HubTitle = "REVO HUB",
        KeyTitle = "Authentication", KeySub = "Enter Access Key", Enter = "Login", GetKey = "Get Key",
        Success = "Access Granted", Fail = "Invalid Key",
        Home = "Home", Player = "Player", Vehicle = "Vehicle", Farm = "Auto Farm", Race = "Race Bot", Visuals = "Visuals", Settings = "Settings", AutoPolice = "Auto Police",
        Speed = "Speed Hack", Fly = "Fly Mode", Rainbow = "Rainbow Car",
        AutoFarm = "Auto ATM Farm", AutoArrest = "Auto Arrest (GOD MODE)",
        ESP = "Player ESP", VehESP = "Vehicle ESP",
        Discord = "Copy Discord", Copied = "Link Copied!",
        Status = "Status: %s",
        SelectCrim = "Select Criminal", Refresh = "Refresh List",
        Target = "Target: %s", NoTarget = "Target: None",
        JobSet = "Job set to Police", JobError = "Could not set Job",
        Dev = "Developer: Revoncy",
        AntiAfk = "Anti-AFK", ServerHop = "Server Hop", HopMsg = "Searching for server...",
        VehFly = "Vehicle Fly", VehFlySpeed = "Vehicle Fly Speed",
        AutoRace = "Auto Race Bot", CheckDelay = "Checkpoint Delay",
        RaceStart = "Race Started (%d CPs)", RaceFinish = "Race Finished!", RaceActive = "Waiting for start...", NoVeh = "No Vehicle Found!",
        -- New Translations
        Robbing = "Robbing ATM...", Cooldown = "Finishing...", Scanning = "Scanning ATMs...",
        Walking = "Walking to Seller...", Running = "Running...",
        Selling = "Bag Full! Selling...", Sold = "Sold! Returning...",
        GodModeActive = "GOD MODE TRACKING ACTIVE",
        SelectTargetFirst = "Select a target first!",
        AutoArrestStopped = "Auto Arrest Stopped",
        SystemTitle = "System",
        Waiting = "Waiting...",
        RaceFlying = "Flying to Checkpoint...",
        InfNitro = "Infinite Nitro", CarSpeed = "Super Torque & Speed",
        RaceWait = "Drive to start Auto Race!"
    },
    Turkish = {
        Title = "Driving Empire", HubTitle = "REVO HUB",
        KeyTitle = "Doğrulama", KeySub = "Anahtarı Giriniz", Enter = "Giriş Yap", GetKey = "Key Al",
        Success = "Giriş Başarılı", Fail = "Hatalı Anahtar",
        Home = "Ana Sayfa", Player = "Oyuncu", Vehicle = "Araç", Farm = "Oto Farm", Race = "Oto Yarış", Visuals = "Görsel", Settings = "Ayarlar", AutoPolice = "Oto Polis",
        Speed = "Hız Hilesi", Fly = "Uçma Modu", Rainbow = "Gökkuşağı Araç",
        AutoFarm = "Oto ATM Farm", AutoArrest = "Oto Yakala (GOD MODU)",
        ESP = "Oyuncu ESP", VehESP = "Araç ESP",
        Discord = "Discord Kopyala", Copied = "Link Kopyalandı!",
        Status = "Durum: %s",
        SelectCrim = "Hırsız Seç", Refresh = "Listeyi Yenile",
        Target = "Hedef: %s", NoTarget = "Hedef: Yok",
        JobSet = "Meslek Polis Yapıldı", JobError = "Meslek Seçilemedi",
        LangChange = "Dil Değiştirildi!", BagLimit = "Çanta Limiti",
        SpeedVal = "Hız Değeri", FlySpeed = "Uçuş Hızı",
        Dev = "Geliştirici: Revoncy",
        AntiAfk = "Anti-AFK", ServerHop = "Sunucu Değiştir", HopMsg = "Sunucu aranıyor...",
        VehFly = "Araç Uçurma", VehFlySpeed = "Araç Uçuş Hızı",
        AutoRace = "Oto Yarış Botu", CheckDelay = "Checkpoint Gecikmesi",
        RaceStart = "Yarış Başladı (%d CP)", RaceFinish = "Yarış Bitti!", RaceActive = "Başlangıç bekleniyor...", NoVeh = "Araç Bulunamadı!",
        -- Eksik Kelimeler Eklendi
        Robbing = "ATM Soyuluyor...", Cooldown = "Bitiriliyor...", Scanning = "ATM Aranıyor...",
        Walking = "Satıcıya Gidiliyor...", Running = "Çalışıyor...",
        Selling = "Çanta Dolu! Satılıyor...", Sold = "Satıldı! Dönülüyor...",
        GodModeActive = "SÜPER TAKİP AKTİF (GOD MODE)",
        SelectTargetFirst = "Önce bir hedef seçin!",
        AutoArrestStopped = "Oto Yakala Durduruldu",
        SystemTitle = "Sistem",
        Waiting = "Bekleniyor...",
        RaceFlying = "Uçuluyor... (Yüksek İrtifa)",
        InfNitro = "Sınırsız Nitro", CarSpeed = "Süper Tork (Ani Hız) & Hız",
        RaceWait = "Yarışı başlatmak için sürün!"
    }
}

local function T(key) return Lang[CurrentLang][key] or key end

local function UpdateLanguage()
    for _, item in pairs(TextRegistry) do
        if item.Obj and item.Obj.Parent then
            if item.Type == "Simple" then
                item.Obj.Text = T(item.Key)
            elseif item.Type == "Slider" then
                local currentVal = item.Obj:GetAttribute("CurrentValue") or 0
                item.Obj.Text = T(item.Key) .. ": " .. currentVal
            elseif item.Type == "Dropdown" then
                 item.Obj.Text = T(item.Key)
            end
        end
    end
end

-- =============================================================================
-- 🎨 UI KÜTÜPHANESİ
-- =============================================================================
local Library = {}

function Library:RegisterText(obj, key, type)
    table.insert(TextRegistry, {Obj = obj, Key = key, Type = type or "Simple"})
end

function Library:MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.15), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

function Library:CreateNotification(title, text, duration)
    local NotifGui = CoreGui:FindFirstChild("WansNotifs") or Instance.new("ScreenGui", CoreGui)
    NotifGui.Name = "WansNotifs"
    local Frame = Instance.new("Frame", NotifGui)
    Frame.Size = UDim2.new(0, 250, 0, 70)
    Frame.Position = UDim2.new(1, 20, 0.85, 0)
    Frame.BackgroundColor3 = Theme.Background
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1.5
    
    local TitleLbl = Instance.new("TextLabel", Frame)
    TitleLbl.Text = title
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextColor3 = Theme.Accent
    TitleLbl.TextSize = 14
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Position = UDim2.new(0, 10, 0, 5)
    TitleLbl.Size = UDim2.new(1, -20, 0, 20)
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local DescLbl = Instance.new("TextLabel", Frame)
    DescLbl.Text = text
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.TextColor3 = Theme.Text
    DescLbl.TextSize = 12
    DescLbl.BackgroundTransparency = 1
    DescLbl.Position = UDim2.new(0, 10, 0, 25)
    DescLbl.Size = UDim2.new(1, -20, 0, 40)
    DescLbl.TextXAlignment = Enum.TextXAlignment.Left
    DescLbl.TextWrapped = true
    
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -270, 0.85, 0)}):Play()
    for _, child in pairs(NotifGui:GetChildren()) do 
        if child ~= Frame then 
            TweenService:Create(child, TweenInfo.new(0.3), {Position = child.Position - UDim2.new(0, 0, 0, 80)}):Play() 
        end 
    end
    task.delay(duration or 3, function() 
        TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, Frame.Position.Y.Scale, Frame.Position.Y.Offset)}):Play()
        task.wait(0.5)
        Frame:Destroy() 
    end)
end

function Library:Init() 
    if CoreGui:FindFirstChild("WansHubPro") then 
        CoreGui.WansHubPro:Destroy() 
    end
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "WansHubPro"
    ScreenGui.IgnoreGuiInset = true
    return ScreenGui 
end

function Library:CreateWindow(screenGui)
    local MainFrame = Instance.new("Frame", screenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Theme.Accent
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0 
    
    local Shadow = Instance.new("ImageLabel", MainFrame)
    Shadow.ZIndex = 0
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.5
    
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 10 
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
    
    local SidebarCover = Instance.new("Frame", Sidebar)
    SidebarCover.Size = UDim2.new(0, 20, 1, 0)
    SidebarCover.Position = UDim2.new(1, -10, 0, 0)
    SidebarCover.BackgroundColor3 = Theme.Sidebar
    SidebarCover.BorderSizePixel = 0
    SidebarCover.ZIndex = 10 
    
    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.BackgroundTransparency = 1
    Logo.Text = "REVO HUB"
    Logo.Font = Enum.Font.FredokaOne
    Logo.TextColor3 = Theme.Accent
    Logo.TextSize = 18
    Logo.ZIndex = 12 
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.ZIndex = 11 
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y 
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 8)
    
    local MainLogo = Instance.new("ImageLabel", MainFrame)
    MainLogo.Name = "BackgroundLogo"
    MainLogo.Image = LogoID
    MainLogo.BackgroundTransparency = 1
    MainLogo.Position = UDim2.new(0, 150, 0, 0)
    MainLogo.Size = UDim2.new(1, -150, 1, 0)
    MainLogo.ImageTransparency = 0.30 
    MainLogo.ImageColor3 = Color3.fromRGB(255, 200, 200) 
    MainLogo.ScaleType = Enum.ScaleType.Stretch 
    MainLogo.ZIndex = 1 

    local PagesContainer = Instance.new("Frame", MainFrame)
    PagesContainer.Position = UDim2.new(0, 160, 0, 10)
    PagesContainer.Size = UDim2.new(1, -170, 1, -20)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.ZIndex = 5 
    
    Library:MakeDraggable(MainFrame)
    
    local ToggleBtn = Instance.new("TextButton", screenGui)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0.9, -60, 0.1, 0)
    ToggleBtn.BackgroundColor3 = Theme.Background
    ToggleBtn.Text = "" 
    ToggleBtn.AutoButtonColor = true
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)
    local Stroke = Instance.new("UIStroke", ToggleBtn)
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 2
    
    local ToggleIcon = Instance.new("ImageLabel", ToggleBtn)
    ToggleIcon.Image = LogoID
    ToggleIcon.Size = UDim2.new(1, 0, 1, 0) 
    ToggleIcon.Position = UDim2.new(0, 0, 0, 0)
    ToggleIcon.BackgroundTransparency = 1
    ToggleIcon.ScaleType = Enum.ScaleType.Fit
    Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1,0)
    
    Library:MakeDraggable(ToggleBtn)
    
    ToggleBtn.MouseButton1Click:Connect(function() 
        MainFrame.Visible = not MainFrame.Visible 
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp) 
        if not gp and input.KeyCode == Enum.KeyCode.K then 
            MainFrame.Visible = not MainFrame.Visible 
        end 
    end)
    
    local Window = {Frame = MainFrame, TabContainer = TabContainer, PagesContainer = PagesContainer, ActiveTab = nil, Tabs = {}}
    
    function Window:AddTab(nameKey)
        local Page = Instance.new("ScrollingFrame", PagesContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Accent
        Page.Visible = false
        Page.ZIndex = 5 
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 10)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        
        local Pad = Instance.new("UIPadding", Page)
        Pad.PaddingTop = UDim.new(0,5)
        Pad.PaddingLeft = UDim.new(0,5)
        
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Theme.Background
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = T(nameKey)
        TabBtn.TextColor3 = Theme.TextDim
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 14
        TabBtn.ZIndex = 12 
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        Library:RegisterText(TabBtn, nameKey, "Simple")
        
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 0.6, 0)
        Indicator.Position = UDim2.new(0, 0, 0.2, 0)
        Indicator.BackgroundColor3 = Theme.Accent
        Indicator.BackgroundTransparency = 1
        Indicator.ZIndex = 13 
        
        local function UpdateTab() 
            for _, t in pairs(Window.Tabs) do 
                TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TweenService:Create(t.Btn, TweenInfo.new(0.3), {TextColor3 = Theme.TextDim}):Play()
                TweenService:Create(t.Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                t.Page.Visible = false 
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {TextColor3 = Theme.Text}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            Page.Visible = true 
        end
        
        TabBtn.MouseButton1Click:Connect(UpdateTab)
        if #Window.Tabs == 0 then 
            Window.ActiveTab = TabBtn; UpdateTab() 
        end
        table.insert(Window.Tabs, {Btn = TabBtn, Page = Page, Indicator = Indicator, Key = nameKey})
        
        local Elements = {}
        
        function Elements:AddLabel(textKey) 
            local Lab = Instance.new("TextLabel", Page)
            Lab.Size = UDim2.new(0.98, 0, 0, 25)
            Lab.BackgroundTransparency = 1
            Lab.Text = T(textKey)
            Lab.TextColor3 = Theme.Accent
            Lab.Font = Enum.Font.GothamBold
            Lab.TextSize = 14
            Lab.TextXAlignment = Enum.TextXAlignment.Left
            Lab.ZIndex = 6 
            Library:RegisterText(Lab, textKey, "Simple")
            return Lab 
        end
        
        function Elements:AddButton(textKey, callback) 
            local BtnFrame = Instance.new("TextButton", Page)
            BtnFrame.Size = UDim2.new(0.98, 0, 0, 35)
            BtnFrame.BackgroundColor3 = Theme.ElementBg
            BtnFrame.Text = ""
            BtnFrame.AutoButtonColor = false
            BtnFrame.ZIndex = 6 
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
            
            local BtnStroke = Instance.new("UIStroke", BtnFrame)
            BtnStroke.Color = Theme.Accent
            BtnStroke.Thickness = 1
            BtnStroke.Transparency = 0.3
            
            local Title = Instance.new("TextLabel", BtnFrame)
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.BackgroundTransparency = 1
            Title.Text = T(textKey)
            Title.TextColor3 = Theme.Text
            Title.Font = Enum.Font.GothamMedium
            Title.TextSize = 13
            Title.ZIndex = 7 
            Library:RegisterText(Title, textKey, "Simple")
            
            BtnFrame.MouseButton1Click:Connect(function() 
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
                task.delay(0.1, function() TweenService:Create(BtnFrame, TweenInfo.new(0.3), {BackgroundColor3 = Theme.ElementBg}):Play() end)
                pcall(callback) 
            end) 
        end
        
        function Elements:AddToggle(textKey, default, callback) 
            local ToggleFrame = Instance.new("TextButton", Page)
            ToggleFrame.Size = UDim2.new(0.98, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Theme.ElementBg
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.ZIndex = 6 
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
            
            local TStroke = Instance.new("UIStroke", ToggleFrame)
            TStroke.Color = Theme.Accent
            TStroke.Thickness = 1
            TStroke.Transparency = 0.3
            
            local Title = Instance.new("TextLabel", ToggleFrame)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.BackgroundTransparency = 1
            Title.Text = T(textKey)
            Title.TextColor3 = Theme.Text
            Title.Font = Enum.Font.GothamMedium
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.ZIndex = 7 
            Library:RegisterText(Title, textKey, "Simple")
            
            local SwitchBg = Instance.new("Frame", ToggleFrame)
            SwitchBg.Size = UDim2.new(0, 40, 0, 20)
            SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
            SwitchBg.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(80,80,80)
            SwitchBg.ZIndex = 7 
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
            
            local Circle = Instance.new("Frame", SwitchBg)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.new(1,1,1)
            Circle.ZIndex = 8 
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
            
            local Enabled = default
            ToggleFrame.MouseButton1Click:Connect(function() 
                Enabled = not Enabled
                local targetColor = Enabled and Theme.Accent or Color3.fromRGB(80,80,80)
                local targetPos = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                pcall(callback, Enabled) 
            end) 
        end
        
        function Elements:AddSlider(textKey, min, max, default, callback) 
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(0.98, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Theme.ElementBg
            SliderFrame.ZIndex = 6 
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
            
            local SStroke = Instance.new("UIStroke", SliderFrame)
            SStroke.Color = Theme.Accent
            SStroke.Thickness = 1
            SStroke.Transparency = 0.3
            
            local Title = Instance.new("TextLabel", SliderFrame)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -20, 0, 20)
            Title.BackgroundTransparency = 1
            Title.Text = T(textKey) .. ": " .. default
            Title.TextColor3 = Theme.Text
            Title.Font = Enum.Font.GothamMedium
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.ZIndex = 7 
            Title:SetAttribute("CurrentValue", default)
            Library:RegisterText(Title, textKey, "Slider")
            
            local BarBg = Instance.new("Frame", SliderFrame)
            BarBg.Size = UDim2.new(1, -20, 0, 6)
            BarBg.Position = UDim2.new(0, 10, 0, 35)
            BarBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
            BarBg.ZIndex = 7 
            Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1,0)
            
            local Fill = Instance.new("Frame", BarBg)
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.ZIndex = 8 
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)
            
            local Trigger = Instance.new("TextButton", BarBg)
            Trigger.Size = UDim2.new(1,0,1,0)
            Trigger.BackgroundTransparency = 1
            Trigger.Text = ""
            Trigger.ZIndex = 9 
            
            local dragging = false
            local Val = default
            
            Trigger.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) 
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
                    local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
                    local newVal = math.floor(min + ((max - min) * pos))
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    Title.Text = T(textKey) .. ": " .. newVal
                    Title:SetAttribute("CurrentValue", newVal)
                    if newVal ~= Val then Val = newVal; pcall(callback, Val) end 
                end 
            end) 
        end
        
        function Elements:AddDropdown(textKey, options, default, callback) 
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(0.98, 0, 0, 35)
            DropFrame.BackgroundColor3 = Theme.ElementBg
            DropFrame.ZIndex = 6 
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
            
            local DStroke = Instance.new("UIStroke", DropFrame)
            DStroke.Color = Theme.Accent
            DStroke.Thickness = 1
            DStroke.Transparency = 0.3
            
            local Label = Instance.new("TextLabel", DropFrame)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = T(textKey)
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 7 
            Library:RegisterText(Label, textKey, "Dropdown")
            
            local Button = Instance.new("TextButton", DropFrame)
            Button.Size = UDim2.new(0.5, 0, 0.8, 0)
            Button.Position = UDim2.new(0.48, 0, 0.1, 0)
            Button.BackgroundColor3 = Theme.Background
            Button.Text = default .. " >"
            Button.TextColor3 = Theme.Accent
            Button.Font = Enum.Font.Code
            Button.TextSize = 12
            Button.ZIndex = 7 
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
            
            local isOpen = false
            local ListFrame = Instance.new("ScrollingFrame", Page)
            ListFrame.Size = UDim2.new(0.98, 0, 0, 0)
            ListFrame.Visible = false
            ListFrame.BackgroundColor3 = Theme.Sidebar
            ListFrame.BorderSizePixel = 0
            ListFrame.ZIndex = 20 
            Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 6)
            
            local Layout = Instance.new("UIListLayout", ListFrame)
            Layout.Padding = UDim.new(0,2)
            
            Button.MouseButton1Click:Connect(function() 
                isOpen = not isOpen
                ListFrame.Visible = isOpen
                ListFrame.Size = isOpen and UDim2.new(0.98, 0, 0, 100) or UDim2.new(0.98, 0, 0, 0) 
            end)
            
            local function Refresh() 
                for _,v in pairs(ListFrame:GetChildren()) do 
                    if v:IsA("TextButton") then v:Destroy() end 
                end
                
                local opts = type(options) == "function" and options() or options
                
                for _, opt in ipairs(opts) do 
                    local OptBtn = Instance.new("TextButton", ListFrame)
                    OptBtn.Size = UDim2.new(1,0,0,25)
                    OptBtn.BackgroundColor3 = Theme.Background
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = Theme.Text
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextSize = 12
                    OptBtn.ZIndex = 21 
                    OptBtn.MouseButton1Click:Connect(function() 
                        Button.Text = opt .. " >"
                        isOpen = false
                        ListFrame.Visible = false
                        callback(opt) 
                    end) 
                end 
            end
            
            Refresh()
            return {Refresh = Refresh}
        end
        return Elements
    end
    return Window
end

-- =============================================================================
-- 🔒 KEY SİSTEMİ ARAYÜZÜ
-- =============================================================================
local function InitKeySystem(OnSuccess)
    local Screen = Library:Init()
    local Frame = Instance.new("Frame", Screen)
    Frame.Size = UDim2.new(0, 400, 0, 250)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    Frame.BackgroundColor3 = Theme.Background
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Frame).Color = Theme.Accent
    Frame.UIStroke.Thickness = 1.5
    Library:MakeDraggable(Frame)
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Text = T("KeyTitle")
    Title.Position = UDim2.new(0, 0, 0.1, 0)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.FredokaOne
    Title.TextColor3 = Theme.Accent
    Title.TextSize = 24
    Title.BackgroundTransparency = 1
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.8, 0, 0, 40)
    Box.Position = UDim2.new(0.1, 0, 0.35, 0)
    Box.BackgroundColor3 = Theme.ElementBg
    Box.PlaceholderText = T("KeySub")
    Box.Text = ""
    Box.TextColor3 = Theme.Text
    Box.Font = Enum.Font.Code
    Box.TextSize = 14
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    
    local EnterBtn = Instance.new("TextButton", Frame)
    EnterBtn.Size = UDim2.new(0.35, 0, 0, 40)
    EnterBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    EnterBtn.BackgroundColor3 = Theme.Accent
    EnterBtn.Text = T("Enter")
    EnterBtn.TextColor3 = Color3.new(0,0,0)
    EnterBtn.Font = Enum.Font.GothamBold
    EnterBtn.TextSize = 18 
    Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 6)
    
    local GetBtn = Instance.new("TextButton", Frame)
    GetBtn.Size = UDim2.new(0.35, 0, 0, 40)
    GetBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
    GetBtn.BackgroundColor3 = Theme.Sidebar
    GetBtn.Text = T("GetKey")
    GetBtn.TextColor3 = Theme.Text
    GetBtn.Font = Enum.Font.GothamBold
    GetBtn.TextSize = 18 
    Instance.new("UICorner", GetBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", GetBtn).Color = Theme.Accent
    GetBtn.UIStroke.Thickness = 1
    
    GetBtn.MouseButton1Click:Connect(function() 
        setclipboard(KeyLink)
        GetBtn.Text = T("Copied")
        task.wait(2)
        GetBtn.Text = T("GetKey") 
    end)
    
    EnterBtn.MouseButton1Click:Connect(function()
        local Input = Box.Text:gsub("%s+", "")
        local Correct = GetCorrectKey()
        Box.Text = T("Waiting")
        task.wait(0.5)
        if Input == Correct or Input == "WANS-DEV" then 
            Box.TextColor3 = Color3.fromRGB(0, 255, 0)
            Box.Text = T("Success")
            task.wait(1)
            Screen:Destroy()
            OnSuccess() 
        else 
            Box.TextColor3 = Theme.Red
            Box.Text = T("Fail")
            task.wait(1.5)
            Box.Text = Input
            Box.TextColor3 = Theme.Text 
        end
    end)
end

-- =============================================================================
-- 🚀 ANA SCRIPT MANTIĞI
-- =============================================================================
local function MainLogic()
    local ScreenGui = Library:Init()
    local Win = Library:CreateWindow(ScreenGui)
    
    local function Notify(t, m) Library:CreateNotification(t, m) end
    
    local Remotes, RemoteEvents = nil, {}
    pcall(function() 
        Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
        if Remotes then 
            RemoteEvents.BustStart = Remotes:FindFirstChild("AttemptATMBustStart")
            RemoteEvents.BustEnd = Remotes:FindFirstChild("AttemptATMBustComplete")
            RemoteEvents.JobStart = Remotes:FindFirstChild("RequestStartJobSession")
            RemoteEvents.JobEnd = Remotes:FindFirstChild("RequestEndJobSession") 
        end 
    end)

    local function TP(pos) 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local targetCFrame = nil
            
            if typeof(pos) == "Vector3" then 
                targetCFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) 
            elseif typeof(pos) == "CFrame" then 
                targetCFrame = pos 
            end 
            
            if targetCFrame then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = targetCFrame
                LocalPlayer.Character:PivotTo(targetCFrame)
            end
        end 
    end
    
    local noclipConnection = nil
    local function SetNoclip(state) 
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end 
        if state then 
            noclipConnection = RunService.Stepped:Connect(function() 
                if LocalPlayer.Character then 
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do 
                        if part:IsA("BasePart") then part.CanCollide = false end 
                    end 
                end 
            end) 
        end 
    end
    
    local function setWeight(isHeavy) 
        local char = LocalPlayer.Character 
        if char then 
            for _, part in ipairs(char:GetDescendants()) do 
                if part:IsA("BasePart") then 
                    part.CustomPhysicalProperties = isHeavy and PhysicalProperties.new(100, 0.3, 0.5) or nil 
                end 
            end 
        end 
    end
    
    local platformPositions = {
        Vector3.new(-978.88, 800, 313.34), 
        Vector3.new(-484.32, 800, -1226.45), 
        Vector3.new(220.62, 800, 137.81), 
        Vector3.new(-94.29, 800, 2340.52), 
        Vector3.new(-866.12, 800, 3189.41), 
        Vector3.new(-2068.16, 800, 4206.78)
    }
    local sellPos1 = Vector3.new(-2520.49, 15.11, 4035.56)
    local sellPos2 = Vector3.new(-2542.12, 15.11, 4030.91)
    local spawnPos = Vector3.new(-315.45, 17.59, -1660.68)
    
    local function createAllPlatforms() 
        for _, pos in ipairs(platformPositions) do 
            local platform = Instance.new("Part")
            platform.Name = "WansPlatform"
            platform.Parent = Workspace
            platform.Position = pos
            platform.Size = Vector3.new(20, 1, 20)
            platform.Color = Color3.fromRGB(0, 0, 0)
            platform.Anchored = true 
            platform.Transparency = 0.5 
        end 
    end
    
    local function removeAllPlatforms() 
        for _, obj in ipairs(Workspace:GetChildren()) do 
            if obj.Name == "WansPlatform" then obj:Destroy() end 
        end 
    end
    
    local Settings = {
        Speed=false, SpeedVal=16, Fly=false, FlySpeed=50, 
        RainbowCar=false, CarFly=false, CarFlySpeed=100,
        AutoFarm=false, BagLimit=25, AutoArrest=false, 
        ESP=false, VehESP=false, 
        RaceBot=false, CheckpointDelay=0.5,
        InfNitro=false, CarSpeedHack=false, CarSpeedVal=500
    }

    local function SimpleGoTo(destination, timeout) 
        local char = LocalPlayer.Character
        local human = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not human then return end
        local startT = tick()
        timeout = timeout or 2
        while (root.Position - destination).Magnitude > 3 do 
            if not Settings.AutoFarm or (tick() - startT) > timeout then break end
            human:MoveTo(destination)
            if root.AssemblyLinearVelocity.Magnitude < 0.5 then human.Jump = true end
            task.wait(0.1) 
        end 
    end
    
    local function CheckBagLimit(StatusLabel) 
        if not Settings.AutoFarm then return false end
        local currentCrimes = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0
        if StatusLabel then 
            local statusText = StatusLabel.Text:split("|")[1] or T("Running")
            StatusLabel.Text = statusText .. " | [" .. currentCrimes .. "/" .. Settings.BagLimit .. "]" 
        end
        if currentCrimes >= Settings.BagLimit then 
            if StatusLabel then StatusLabel.Text = T("Selling") end
            while currentCrimes >= Settings.BagLimit and Settings.AutoFarm do 
                SetNoclip(true)
                TP(sellPos1)
                task.wait(0.5)
                if StatusLabel then StatusLabel.Text = T("Walking") end
                SimpleGoTo(sellPos2, 2)
                task.wait(2.0)
                currentCrimes = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0 
            end
            if StatusLabel then StatusLabel.Text = T("Sold") end
            return true 
        end
        return false 
    end
    
    local function GetAvailableATM() 
        local spawners = Workspace.Game.Jobs.CriminalATMSpawners
        for _, spawner in ipairs(spawners:GetChildren()) do 
            local atm = spawner:FindFirstChild("CriminalATM")
            if atm and atm:GetAttribute("State") == "Normal" then return spawner, atm end 
        end
        return nil, nil 
    end
    
    local function SmartBust(targetSpawner, atmModel, StatusLabel) 
        if not Settings.AutoFarm then return end
        local safePos = platformPositions[math.random(1, #platformPositions)]
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if StatusLabel then StatusLabel.Text = string.format(T("Status"), T("Robbing")) end
        
        if LocalPlayer.Character then
            local currentCF = LocalPlayer.Character:GetPivot()
            LocalPlayer.Character:PivotTo(currentCF + Vector3.new(0, 5, 0))
            task.wait() 
        end
        
        TP(targetSpawner.Position)
        task.wait(0.25) 
        RemoteEvents.BustStart:InvokeServer(atmModel)
        
        if StatusLabel then StatusLabel.Text = string.format(T("Status"), T("Cooldown")) end
        TP(safePos)
        task.wait(5.3) 
        
        if LocalPlayer.Character then
            local currentCF = LocalPlayer.Character:GetPivot()
            LocalPlayer.Character:PivotTo(currentCF + Vector3.new(0, 5, 0))
            task.wait()
        end
        
        if StatusLabel then StatusLabel.Text = string.format(T("Status"), T("Cooldown")) end
        TP(targetSpawner.Position)
        task.wait(0.25) 
        RemoteEvents.BustEnd:InvokeServer(atmModel)
        
        task.wait(0.8) 
        
        TP(safePos)
        CheckBagLimit(StatusLabel) 
    end
    
    local function GetVehicle() 
        local f = Workspace:FindFirstChild("Vehicles")
        if not f then return nil end
        for _, v in pairs(f:GetChildren()) do 
            if v:FindFirstChild("Owner") and v.Owner.Value == LocalPlayer.Name then return v end 
        end
        return nil 
    end

    -- [GOD MODE TRACKING SYSTEM - v29.0]
    local function GetTargetPosition(target)
        if not target then return nil end
        
        local targetCFrame, targetVel, targetType = nil, Vector3.zero, "None"
        
        local char = target.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.SeatPart then
                return hum.SeatPart.CFrame, hum.SeatPart.AssemblyLinearVelocity, "Seat"
            end
        end

        local vehicles = Workspace:FindFirstChild("Vehicles")
        if vehicles then
            for _, veh in pairs(vehicles:GetChildren()) do
                local owner = veh:FindFirstChild("Owner")
                if owner and owner.Value == target.Name then
                    local primary = veh.PrimaryPart or veh:FindFirstChild("VehicleSeat") or veh:FindFirstChildWhichIsA("BasePart", true)
                    if primary then
                        return primary.CFrame, primary.AssemblyLinearVelocity, "Vehicle_Owner"
                    end
                end
            end
        end

        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                return root.CFrame, root.AssemblyLinearVelocity, "Root"
            end
            return char:GetPivot(), Vector3.zero, "Pivot"
        end

        return nil
    end

    local function StartTracking(targetPlayer)
        if TrackingConnection then TrackingConnection:Disconnect() TrackingConnection = nil end
        
        Notify(T("SystemTitle"), T("GodModeActive"))
        
        TrackingConnection = RunService.Stepped:Connect(function()
            if not Settings.AutoArrest then 
                if TrackingConnection then TrackingConnection:Disconnect() TrackingConnection = nil end
                return 
            end
            
            if not targetPlayer then return end
            
            local targetCFrame, targetVel, trackType = GetTargetPosition(targetPlayer)
            
            if not targetCFrame then return end

            local myChar = LocalPlayer.Character
            if not myChar then return end
            
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar:FindFirstChild("Humanoid")
            local mySeat = myHum and myHum.SeatPart
            
            local speed = targetVel.Magnitude
            local destCFrame
            
            if speed > 200 then
                local futurePos = targetCFrame.Position + (targetVel * 0.5) + (targetVel.Unit * 40)
                destCFrame = CFrame.new(futurePos, futurePos + targetVel.Unit) * CFrame.new(0, 3, 0)
            else
                destCFrame = targetCFrame * CFrame.new(0, 5, 0)
            end

            if mySeat and mySeat.Parent then
                local vehModel = mySeat.Parent
                if not vehModel:IsA("Model") then vehModel = vehModel.Parent end
                
                if vehModel and vehModel:IsA("Model") then
                    for _, p in pairs(vehModel:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.AssemblyLinearVelocity = Vector3.zero
                            p.AssemblyAngularVelocity = Vector3.zero
                            p.CanCollide = false
                        end
                    end
                    vehModel:PivotTo(destCFrame)
                end
            elseif myRoot then
                myChar:PivotTo(destCFrame)
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
                if myRoot.CanCollide then myRoot.CanCollide = false end
            end
        end)
    end

    -- TABS
    local HomeTab = Win:AddTab("Home")
    local PlayerTab = Win:AddTab("Player")
    local VehTab = Win:AddTab("Vehicle")
    local RaceTab = Win:AddTab("Race") 
    local PoliceTab = Win:AddTab("AutoPolice")
    local FarmTab = Win:AddTab("Farm")
    local VisualTab = Win:AddTab("Visuals")
    
    -- Home
    HomeTab:AddLabel("HubTitle")
    HomeTab:AddLabel("Dev")
    HomeTab:AddButton("Discord", function() setclipboard("https://discord.gg/vSuMKmCqHU"); Notify("Discord", T("Copied")) end)
    HomeTab:AddDropdown("Language / Dil", {"English", "Turkish"}, CurrentLang, function(opt) CurrentLang = opt; UpdateLanguage(); Notify("WANS", T("LangChange")) end)
    HomeTab:AddButton("ServerHop", function() 
        Notify("Info", T("HopMsg"))
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local function ListServers(cursor) return Http:JSONDecode(game:HttpGet(Api .. ((cursor and "&cursor="..cursor) or ""))) end
        local Server
        repeat local Servers = ListServers(Next); Server = Servers.data[1]; Next = Servers.nextPageCursor until Server
        TPS:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer) 
    end)

    -- Player
    PlayerTab:AddToggle("Speed", false, function(v) Settings.Speed = v end)
    PlayerTab:AddSlider("SpeedVal", 16, 200, 16, function(v) Settings.SpeedVal = v end)
    PlayerTab:AddToggle("Fly", false, function(v) 
        Settings.Fly = v
        if not v then 
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("HumanoidRootPart") and c.HumanoidRootPart:FindFirstChild("WansFlyV") then 
                c.HumanoidRootPart.WansFlyV:Destroy()
                c.HumanoidRootPart.WansFlyG:Destroy()
                c.Humanoid.PlatformStand = false 
            end 
        end 
    end)
    PlayerTab:AddSlider("FlySpeed", 20, 300, 50, function(v) Settings.FlySpeed = v end)
    
    local AntiAfkConn = nil
    PlayerTab:AddToggle("AntiAfk", false, function(v) 
        if v then 
            AntiAfkConn = LocalPlayer.Idled:Connect(function() 
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(), Camera.CFrame) 
            end)
            Notify("AntiAfk", "Active") 
        else 
            if AntiAfkConn then AntiAfkConn:Disconnect() AntiAfkConn = nil end
            Notify("AntiAfk", "Disabled") 
        end 
    end)

    -- Vehicle
    VehTab:AddToggle("Rainbow", false, function(v) Settings.RainbowCar = v end)
    VehTab:AddToggle("VehFly", false, function(v) Settings.CarFly = v end)
    VehTab:AddSlider("VehFlySpeed", 50, 800, 100, function(v) Settings.CarFlySpeed = v end)
    
    -- [NEW FEATURES: NITRO & SPEED]
    VehTab:AddToggle("InfNitro", false, function(v) Settings.InfNitro = v end)
    VehTab:AddToggle("CarSpeed", false, function(v) Settings.CarSpeedHack = v end)
    VehTab:AddSlider("CarSpeed", 500, 10000, 800, function(v) Settings.CarSpeedVal = v end)

    -- Race
    local RaceStatus = RaceTab:AddLabel("RaceActive")
    RaceTab:AddToggle("AutoRace", false, function(v) 
        Settings.RaceBot = v; 
        RaceStatus.Text = v and T("RaceWait") or T("Stopped") 
        if not v then
             local car = GetVehicle()
             if car and car.PrimaryPart then
                -- Cleanup physics movers if disabled
                if car.PrimaryPart:FindFirstChild("WansBodyPos") then car.PrimaryPart.WansBodyPos:Destroy() end
                if car.PrimaryPart:FindFirstChild("WansBodyGyro") then car.PrimaryPart.WansBodyGyro:Destroy() end
                
                -- Restore collision
                for _, p in pairs(car:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
             end
        end
    end)
    RaceTab:AddSlider("CheckDelay", 0, 2, 0.5, function(v) Settings.CheckpointDelay = v end)

    -- Police
    local PoliceTarget = nil
    local PStatus = PoliceTab:AddLabel("Status")
    PoliceTab:AddButton("Set Job: Police", function() pcall(function() RemoteEvents.JobStart:FireServer("Security", "jobPad") end); Notify("Info", T("JobSet")) end)
    
    local function GetCriminals()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do 
            if p ~= LocalPlayer and (p:GetAttribute("Wanted") or p:GetAttribute("JobId") == "Criminal") then 
                table.insert(list, p.Name) 
            end 
        end
        return list
    end

    local Drop = PoliceTab:AddDropdown("SelectCrim", GetCriminals, "None", function(pName) 
        CurrentTargetPlayer = Players:FindFirstChild(pName)
        if CurrentTargetPlayer then 
            PStatus.Text = string.format(T("Target"), pName) 
            if Settings.AutoArrest then
                 StartTracking(CurrentTargetPlayer)
            end
        else 
            PStatus.Text = T("NoTarget") 
            if TrackingConnection then TrackingConnection:Disconnect() TrackingConnection = nil end
        end 
    end)
    
    PoliceTab:AddButton("Refresh", function() 
        Drop.Refresh() 
    end)
    
    PoliceTab:AddToggle("AutoArrest", false, function(v) 
        Settings.AutoArrest = v
        if v then 
            if CurrentTargetPlayer then
                StartTracking(CurrentTargetPlayer)
            else
                Notify(T("SystemTitle"), T("SelectTargetFirst"))
            end
        else
            if TrackingConnection then TrackingConnection:Disconnect() TrackingConnection = nil end
            Notify(T("SystemTitle"), T("AutoArrestStopped"))
        end 
    end)
    
    -- Farm
    local FStatus = FarmTab:AddLabel("Status")
    FarmTab:AddSlider("BagLimit", 5, 100, 25, function(v) Settings.BagLimit = v end)
    FarmTab:AddToggle("AutoFarm", false, function(v) 
        Settings.AutoFarm = v
        if v then 
            FStatus.Text = string.format(T("Status"), T("Running"))
            pcall(function() RemoteEvents.JobStart:FireServer("Criminal", "jobPad") end)
            task.wait(0.5)
            removeAllPlatforms()
            createAllPlatforms()
            SetNoclip(true)
            setWeight(true)
            task.spawn(function() 
                while Settings.AutoFarm do 
                    CheckBagLimit(FStatus)
                    for _, platformPos in ipairs(platformPositions) do 
                        if not Settings.AutoFarm then break end
                        if CheckBagLimit(FStatus) then TP(platformPos) end
                        SetNoclip(true)
                        setWeight(true)
                        local currentBags = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0
                        FStatus.Text = string.format(T("Status"), T("Scanning")) .. " | [" .. currentBags .. "/" .. Settings.BagLimit .. "]"
                        TP(platformPos)
                        task.wait(5.0)
                        local spawner, atm = GetAvailableATM()
                        if spawner and atm then 
                            SmartBust(spawner, atm, FStatus)
                            currentBags = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CrimesCommitted") or 0
                            FStatus.Text = string.format(T("Status"), T("Cooldown")) .. " | [" .. currentBags .. "/" .. Settings.BagLimit .. "]"
                        end 
                    end
                    task.wait(0.1) 
                end
                FStatus.Text = string.format(T("Status"), T("Stopped"))
                TP(spawnPos)
                pcall(function() RemoteEvents.JobEnd:FireServer("jobPad") end)
                SetNoclip(false)
                setWeight(false)
                removeAllPlatforms() 
            end) 
        else 
            FStatus.Text = string.format(T("Status"), T("Stopped")) 
        end 
    end)
    
    -- Visuals
    VisualTab:AddToggle("ESP", false, function(v) Settings.ESP = v end)
    VisualTab:AddToggle("VehESP", false, function(v) Settings.VehESP = v end)
    
    -- LOOPS
    RunService.RenderStepped:Connect(function()
        local car = GetVehicle()

        -- Infinite Nitro Logic (Attribute + Value Scan)
        if Settings.InfNitro and car then
             -- 1. Scan Attributes on Car
             if car:GetAttribute("Nitro") then car:SetAttribute("Nitro", 200) end
             
             -- 2. Scan Attributes on Player (Sometimes stored here)
             if LocalPlayer:GetAttribute("Nitro") then LocalPlayer:SetAttribute("Nitro", 200) end

             -- 3. Scan Value Objects (Old systems)
            for _, v in pairs(car:GetDescendants()) do
                if v.Name == "Nitro" or v.Name == "NitroFuel" then
                    if v:IsA("NumberValue") or v:IsA("DoubleConstrainedValue") then
                        v.Value = 9999
                    end
                end
            end
        end

        -- Car Speed/Torque Logic (INSTANT POWER)
        if Settings.CarSpeedHack and car then
            local seat = car:FindFirstChild("VehicleSeat")
            if seat then
                -- Force Maximum Torque
                seat.Torque = math.huge -- Infinite Torque
                seat.MaxSpeed = Settings.CarSpeedVal
                seat.TurnSpeed = 2 -- Better handling at high speed
                
                -- Extra Kick (BodyThrust) if needed
                if seat.Throttle > 0 then
                    car.PrimaryPart.AssemblyLinearVelocity = car.PrimaryPart.AssemblyLinearVelocity + (car.PrimaryPart.CFrame.LookVector * 2)
                end
            end
        end

        if Settings.Speed and LocalPlayer.Character then 
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.MoveDirection.Magnitude > 0 then 
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * Settings.SpeedVal, hrp.Velocity.Y, hum.MoveDirection.Z * Settings.SpeedVal) 
            end 
        end
        if Settings.Fly and LocalPlayer.Character then 
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hrp and hum then 
                hum.PlatformStand = true
                local bv = hrp:FindFirstChild("WansFlyV") or Instance.new("BodyVelocity", hrp)
                bv.Name = "WansFlyV"
                bv.MaxForce = Vector3.new(9e9,9e9,9e9)
                local bg = hrp:FindFirstChild("WansFlyG") or Instance.new("BodyGyro", hrp)
                bg.Name = "WansFlyG"
                bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
                local cam = Camera.CFrame
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                bg.CFrame = cam
                bv.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.new() 
            end 
        end
        
        -- Car Fly Logic
        if car and Settings.RainbowCar then 
            local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            for _, p in pairs(car:GetDescendants()) do 
                if p:IsA("BasePart") then p.Color = c end 
            end 
        end
        if car and Settings.CarFly and car.PrimaryPart then 
            local pp=car.PrimaryPart
            local vFly=pp:FindFirstChild("CarFlyVel") or Instance.new("BodyVelocity", pp)
            vFly.Name="CarFlyVel"
            vFly.MaxForce=Vector3.new(9e9,9e9,9e9)
            local vGyro=pp:FindFirstChild("CarFlyGyro") or Instance.new("BodyGyro", pp)
            vGyro.Name="CarFlyGyro"
            vGyro.MaxTorque=Vector3.new(9e9,9e9,9e9)
            vGyro.P=1000
            vGyro.D=50
            local cam=Workspace.CurrentCamera.CFrame
            local dir=Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            vGyro.CFrame=cam
            vFly.Velocity=dir.Magnitude>0 and dir.Unit*Settings.CarFlySpeed or Vector3.new() 
        else 
            if car and car.PrimaryPart then 
                if car.PrimaryPart:FindFirstChild("CarFlyVel") then car.PrimaryPart.CarFlyVel:Destroy() end
                if car.PrimaryPart:FindFirstChild("CarFlyGyro") then car.PrimaryPart.CarFlyGyro:Destroy() end 
            end 
        end
        
        -- ESP Logic
        if Settings.ESP then 
            for _, p in pairs(Players:GetPlayers()) do 
                if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("WansESP") then 
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "WansESP"
                    h.FillColor = Theme.Red
                    h.OutlineColor = Color3.new(1,1,1)
                    h.FillTransparency = 0.5 
                end 
            end 
        else 
            for _, p in pairs(Players:GetPlayers()) do 
                if p.Character and p.Character:FindFirstChild("WansESP") then p.Character.WansESP:Destroy() end 
            end 
        end
        if Settings.VehESP then 
            local vf = Workspace:FindFirstChild("Vehicles")
            if vf then 
                for _, v in pairs(vf:GetChildren()) do 
                    if v:FindFirstChild("Owner") and not v:FindFirstChild("WansVehESP") then 
                        local h = Instance.new("Highlight", v)
                        h.Name = "WansVehESP"
                        h.FillColor = Theme.Blue; h.OutlineColor = Color3.new(1,1,1)
                        h.FillTransparency = 0.5 
                    end 
                end 
            end 
        else 
            local vf = Workspace:FindFirstChild("Vehicles")
            if vf then 
                for _, v in pairs(vf:GetChildren()) do 
                    if v:FindFirstChild("WansVehESP") then v.WansVehESP:Destroy() end 
                end 
            end 
        end
    end)
    
    -- =============================================================================
    -- 🏁 OTO YARIŞ SİSTEMİ (v29.4 Fix - Air Mode)
    -- =============================================================================
    task.spawn(function()
        while task.wait(0.1) do
            if Settings.RaceBot then
                local car = GetVehicle()
                
                -- Checkpoints Setup
                if car and car.PrimaryPart and car.PrimaryPart.AssemblyLinearVelocity.Magnitude > 5 then
                    
                    local raceFolder = Workspace:FindFirstChild("Races") or Workspace:FindFirstChild("Race") or Workspace:FindFirstChild("ActiveRace")
                    local checkpoints = {}

                    if raceFolder then
                        for _, desc in pairs(raceFolder:GetDescendants()) do
                            if desc:IsA("BasePart") and desc.Transparency < 1 then
                                if tonumber(desc.Name) then
                                    table.insert(checkpoints, desc)
                                elseif desc.Name:lower():find("finish") then
                                    table.insert(checkpoints, desc)
                                elseif desc.Name:lower():find("checkpoint") then
                                    table.insert(checkpoints, desc)
                                end
                            end
                        end
                    end

                    table.sort(checkpoints, function(a, b)
                        local nA = tonumber(a.Name) or (a.Name:lower():find("finish") and 9999 or 0)
                        local nB = tonumber(b.Name) or (b.Name:lower():find("finish") and 9999 or 0)
                        return nA < nB
                    end)

                    local nextCP = nil
                    local minDst = math.huge
                    
                    for _, cp in ipairs(checkpoints) do
                        local dist = (car.PrimaryPart.Position - cp.Position).Magnitude
                        local vecToCp = (cp.Position - car.PrimaryPart.Position).Unit
                        local dotProd = car.PrimaryPart.CFrame.LookVector:Dot(vecToCp)
                        
                        if dotProd > 0 then
                             if dist < minDst then
                                minDst = dist
                                nextCP = cp
                            end
                        end
                    end

                    if nextCP then
                        RaceStatus.Text = T("RaceFlying")

                        local bp = car.PrimaryPart:FindFirstChild("WansBodyPos") or Instance.new("BodyPosition", car.PrimaryPart)
                        bp.Name = "WansBodyPos"
                        bp.MaxForce = Vector3.new(9e9, 9e9, 9e9) 
                        bp.D = 500
                        bp.P = 10000
                        
                        local bg = car.PrimaryPart:FindFirstChild("WansBodyGyro") or Instance.new("BodyGyro", car.PrimaryPart)
                        bg.Name = "WansBodyGyro"
                        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                        bg.D = 100
                        bg.P = 5000
                        
                        -- [CRITICAL FIX] Fly High Above Ground (Y + 20)
                        local targetPos = nextCP.Position
                        targetPos = Vector3.new(targetPos.X, math.max(targetPos.Y, car.PrimaryPart.Position.Y) + 20, targetPos.Z)

                        bp.Position = targetPos
                        bg.CFrame = CFrame.lookAt(car.PrimaryPart.Position, targetPos)

                        -- [CRITICAL FIX] Disable ALL Collisions (Ghost Mode)
                        for _, p in pairs(car:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    else
                         if car.PrimaryPart:FindFirstChild("WansBodyPos") then car.PrimaryPart.WansBodyPos:Destroy() end
                         if car.PrimaryPart:FindFirstChild("WansBodyGyro") then car.PrimaryPart.WansBodyGyro:Destroy() end
                    end
                else 
                    RaceStatus.Text = T("RaceWait") 
                    if car and car.PrimaryPart then
                         if car.PrimaryPart:FindFirstChild("WansBodyPos") then car.PrimaryPart.WansBodyPos:Destroy() end
                         if car.PrimaryPart:FindFirstChild("WansBodyGyro") then car.PrimaryPart.WansBodyGyro:Destroy() end
                    end
                end
            end
        end
    end)
    
    Notify("WANS", T("Success"))
    UpdateLanguage()
end

-- =============================================================================
-- ▶️ BAŞLAT
-- =============================================================================
InitKeySystem(MainLogic)
