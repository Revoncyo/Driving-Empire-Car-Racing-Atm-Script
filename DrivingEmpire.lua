--[[
    █     █░ ▄▄▄       ███▄    █   ██████ 
   ▓█░ █ ░█░▒████▄     ██ ▀█   █ ▒██    ▒ 
   ▒█░ █ ░█░▒██  ▀█▄  ▓██  ▀█ ██▒░ ▓██▄   
   ░█░ █ ░█░░██▄▄▄▄██ ▓██▒  ▐▌██▒  ▒   ██▒
   ░░██▒██▓  ▓█   ▓██▒▒██░   ▓██░▒██████▒▒
   ░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░
   
   Project: Wans Studios Hub (Key System Logic Fix)
   Developer: Wans Studios
]]

-- =============================================================================
-- 🔒 AYARLAR
-- =============================================================================
-- Scriptin sorgu yapacağı adres (Burası KESİN DOĞRU):
local VerifyLink = "https://wansstudioskeyal.wuaze.com/key.php?action=check&k="

-- Kullanıcının key alacağı adres:
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

local MainFrameRef = nil 

-- =============================================================================
-- DİL SİSTEMİ
-- =============================================================================
local CurrentLang = "English" 
local UIElements = {} 

local Lang = {
    English = {
        Title = "Driving Empire", Dev = "Developer: Wans Studios", Ver = "Version: 13.0 (Logic Fix)",
        KeyTitle = "Wans Security", KeySub = "Enter Key", KeyPlace = "Paste Key Here...", KeyBtn = "Login", KeyGet = "Get Key",
        KeyCheck = "Connecting...", KeySuccess = "KEY CONFIRMED!", KeyFail = "INVALID KEY!", KeyErr = "Connection Error!"
    },
    Turkish = {
        Title = "Driving Empire", Dev = "Geliştirici: Wans Studios", Ver = "Sürüm: 13.0 (Mantık Düzeltme)",
        KeyTitle = "Wans Güvenlik", KeySub = "Key Giriniz", KeyPlace = "Keyi Buraya Yapıştır...", KeyBtn = "Giriş Yap", KeyGet = "Key Al",
        KeyCheck = "Bağlanıyor...", KeySuccess = "KEY ONAYLANDI!", KeyFail = "HATALI KEY!", KeyErr = "Bağlantı Hatası!"
    }
}

local function GetText(key) return Lang[CurrentLang][key] or key end

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
                end
            end)
        end
    end)
end

if _G.WansUI_Loaded then
    if CoreGui:FindFirstChild("WansKeySystem") then CoreGui.WansKeySystem:Destroy() end
end
_G.WansUI_Loaded = true

-- =============================================================================
-- KEY SİSTEMİ (GÜNCELLENMİŞ MANTIK)
-- =============================================================================
local function StartKeySystem(OnSuccess)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "WansKeySystem"
    KeyGui.Parent = CoreGui
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "KeyFrame"
    MainFrame.Parent = KeyGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    if IsMobile then MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100); MainFrame.Size = UDim2.new(0, 300, 0, 200) else MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125); MainFrame.Size = UDim2.new(0, 400, 0, 250) end
    MainFrame.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = Color3.fromRGB(255, 50, 50); Stroke.Thickness = 2
    MakeDraggable(MainFrame, nil)
    
    local Title = Instance.new("TextLabel", MainFrame); Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 10); Title.Size = UDim2.new(1, 0, 0, 30); Title.Font = Enum.Font.FredokaOne; Title.Text = GetText("KeyTitle"); Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 24
    
    local KeyBox = Instance.new("TextBox", MainFrame); KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40); KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0); KeyBox.Size = UDim2.new(0.8, 0, 0, 40); KeyBox.Font = Enum.Font.Code; KeyBox.PlaceholderText = GetText("KeyPlace"); KeyBox.Text = ""; KeyBox.TextColor3 = Color3.fromRGB(0, 255, 150); KeyBox.TextSize = 16
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
    
    local function CreateBtn(TextKey, Pos, Color, Callback)
        local Btn = Instance.new("TextButton", MainFrame); Btn.BackgroundColor3 = Color; Btn.Position = Pos; Btn.Size = UDim2.new(0.38, 0, 0, 35); Btn.Font = Enum.Font.GothamBold; Btn.Text = GetText(TextKey); Btn.TextColor3 = Color3.new(1,1,1); Btn.TextSize = 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6); Btn.MouseButton1Click:Connect(Callback); return Btn
    end

    -- GİRİŞ BUTONU MANTIĞI
    CreateBtn("KeyBtn", UDim2.new(0.1, 0, 0.65, 0), Color3.fromRGB(0, 120, 255), function()
        local InputKey = KeyBox.Text
        
        -- 1. ADIM: Boşlukları ve görünmez karakterleri temizle
        InputKey = string.gsub(InputKey, "\n", "")
        InputKey = string.gsub(InputKey, " ", "")
        
        if #InputKey < 5 then 
            KeyBox.Text = "Key Too Short / Key Çok Kısa"
            task.wait(1)
            KeyBox.Text = InputKey
            return 
        end
        
        KeyBox.Text = GetText("KeyCheck")
        KeyBox.TextColor3 = Color3.new(1,1,1)

        -- 2. ADIM: Siteye Sor (Cache Önlemek için rastgele sayı ekle)
        task.spawn(function()
            -- Linkin sonuna &nocache=randomsayi ekliyoruz ki Roblox hafızadan okumasın
            local RequestUrl = VerifyLink .. InputKey .. "&nocache=" .. math.random(1, 999999)
            
            print("WANS DEBUG: Giden İstek -> " .. RequestUrl) -- F9'da görünür

            local Success, Response = pcall(function() 
                return game:HttpGet(RequestUrl, true) 
            end)

            if Success then
                print("WANS DEBUG: Gelen Cevap -> [" .. tostring(Response) .. "]") -- F9'da görünür
                
                -- 3. ADIM: Gelen cevabın içinde "valid" kelimesi var mı?
                -- string.find kullanıyoruz, böylece "valid ", " valid" veya "valid\n" olsa bile kabul eder.
                if string.find(tostring(Response), "valid") then
                    -- BAŞARILI
                    KeyBox.Text = GetText("KeySuccess")
                    KeyBox.TextColor3 = Color3.fromRGB(0, 255, 0)
                    task.wait(1)
                    KeyGui:Destroy()
                    OnSuccess()
                else
                    -- GEÇERSİZ
                    KeyBox.Text = GetText("KeyFail")
                    KeyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
                    task.wait(1.5)
                    KeyBox.Text = InputKey
                    KeyBox.TextColor3 = Color3.fromRGB(0, 255, 150)
                end
            else
                -- İNTERNET/SİTE HATASI
                KeyBox.Text = "HTTP Error: " .. tostring(Response)
                print("WANS DEBUG ERROR: " .. tostring(Response))
            end
        end)
    end)

    CreateBtn("KeyGet", UDim2.new(0.52, 0, 0.65, 0), Color3.fromRGB(80, 80, 80), function()
        setclipboard(GetKeyLink)
        KeyBox.Text = "Link Copied / Kopyalandı"
        task.wait(1)
        KeyBox.Text = ""
    end)
end

-- =============================================================================
-- ANA SCRİPT (Sadece Key Geçilince Çalışır)
-- =============================================================================
local function LoadMainScript()
    -- Buraya senin asıl oyun hile kodların gelecek.
    -- Şimdilik çalıştığını anlaman için bir uyarı veriyorum.
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wans Studios";
        Text = "Giriş Başarılı! Script Yükleniyor...";
        Duration = 5;
    })
    
    print("WANS STUDIOS: SCRİPT BAŞARIYLA YÜKLENDİ!")
    
    -- Örnek UI Açılışı (Senin eski kodlarını buraya entegre edebilirsin)
    -- Ben sadece key sistemini test etmen için burayı boş bırakıyorum.
end

StartKeySystem(LoadMainScript)
