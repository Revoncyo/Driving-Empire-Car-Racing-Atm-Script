--[[
    █     █░ ▄▄▄       ███▄    █   ██████ 
   ▓█░ █ ░█░▒████▄     ██ ▀█   █ ▒██    ▒ 
   ▒█░ █ ░█░▒██  ▀█▄  ▓██  ▀█ ██▒░ ▓██▄   
   ░█░ █ ░█░░██▄▄▄▄██ ▓██▒  ▐▌██▒  ▒   ██▒
   ░░██▒██▓  ▓█   ▓██▒▒██░   ▓██░▒██████▒▒
   ░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░
   
   Project: Wans Studios Hub (HTTP Request Fix)
   Developer: Wans Studios
   Version: 13.1 (Anti-Bot Bypass)
]]

-- =============================================================================
-- 🔒 AYARLAR
-- =============================================================================
local VerifyLink = "https://wansstudioskeyal.wuaze.com/key.php?action=check&k="
local GetKeyLink = "https://linkvertise.com/3041148/6gmLZTgCNaVc?o=sharing" 
local ArkaPlanGorseli = "rbxassetid://135213223432744" 

-- =============================================================================
-- GEREKLİ SERVİSLER
-- =============================================================================
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local IsMobile = UserInputService.TouchEnabled
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- EXPLOIT HTTP REQUEST FONKSİYONU BELİRLEME
-- (Standart game:HttpGet yerine header ekleyebileceğimiz özel fonksiyonu buluyoruz)
local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local MainFrameRef = nil 

-- =============================================================================
-- DİL SİSTEMİ
-- =============================================================================
local CurrentLang = "English" 
local UIElements = {} 

local Lang = {
    English = {
        Title = "Driving Empire", Dev = "Developer: Wans Studios", Ver = "Version: 13.1 (HTTP Fix)",
        KeyTitle = "Wans Security", KeySub = "Enter Key", KeyPlace = "Paste Key Here...", KeyBtn = "Login", KeyGet = "Get Key",
        KeyCheck = "Bypassing Security...", KeySuccess = "ACCESS GRANTED!", KeyFail = "INVALID KEY!", KeyErr = "Site Blocked Request!"
    },
    Turkish = {
        Title = "Driving Empire", Dev = "Geliştirici: Wans Studios", Ver = "Sürüm: 13.1 (HTTP Düzeltme)",
        KeyTitle = "Wans Güvenlik", KeySub = "Key Giriniz", KeyPlace = "Keyi Buraya Yapıştır...", KeyBtn = "Giriş Yap", KeyGet = "Key Al",
        KeyCheck = "Güvenlik Aşılıyor...", KeySuccess = "GİRİŞ ONAYLANDI!", KeyFail = "HATALI KEY!", KeyErr = "Site İsteği Reddetti!"
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
-- KEY SİSTEMİ (HEADER SPOOFING İLE)
-- =============================================================================
local function StartKeySystem(OnSuccess)
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "WansKeySystem"
    KeyGui.Parent = CoreGui
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "KeyFrame"
    MainFrame.Parent = KeyGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    if IsMobile then MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100); MainFrame.Size = UDim2.new(0, 300, 0, 200) else MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125); MainFrame.Size = UDim2.new(0, 400, 0, 250) end
    MainFrame.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", MainFrame); Stroke.Color = Color3.fromRGB(255, 0, 0); Stroke.Thickness = 2
    MakeDraggable(MainFrame, nil)
    
    local Title = Instance.new("TextLabel", MainFrame); Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 10); Title.Size = UDim2.new(1, 0, 0, 30); Title.Font = Enum.Font.FredokaOne; Title.Text = GetText("KeyTitle"); Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 24
    
    local KeyBox = Instance.new("TextBox", MainFrame); KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30); KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0); KeyBox.Size = UDim2.new(0.8, 0, 0, 40); KeyBox.Font = Enum.Font.Code; KeyBox.PlaceholderText = GetText("KeyPlace"); KeyBox.Text = ""; KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255); KeyBox.TextSize = 16
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
    
    local function CreateBtn(TextKey, Pos, Color, Callback)
        local Btn = Instance.new("TextButton", MainFrame); Btn.BackgroundColor3 = Color; Btn.Position = Pos; Btn.Size = UDim2.new(0.38, 0, 0, 35); Btn.Font = Enum.Font.GothamBold; Btn.Text = GetText(TextKey); Btn.TextColor3 = Color3.new(1,1,1); Btn.TextSize = 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6); Btn.MouseButton1Click:Connect(Callback); return Btn
    end

    -- GİRİŞ BUTONU
    CreateBtn("KeyBtn", UDim2.new(0.1, 0, 0.65, 0), Color3.fromRGB(0, 120, 255), function()
        local InputKey = KeyBox.Text
        InputKey = string.gsub(InputKey, "^%s*(.-)%s*$", "%1") -- Boşluk temizle
        
        if #InputKey < 5 then KeyBox.Text = "Short Key!"; task.wait(1); KeyBox.Text = InputKey; return end
        
        KeyBox.Text = GetText("KeyCheck")
        KeyBox.TextColor3 = Color3.fromRGB(255, 255, 0) -- Sarı (İşlem sürüyor)

        -- BACKUP KEY (SİTE ÇÖKERSE KULLAN)
        if InputKey == "WANS-DEV-ACCESS" then
            KeyBox.Text = GetText("KeySuccess"); KeyBox.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(1); KeyGui:Destroy(); OnSuccess(); return
        end

        task.spawn(function()
            -- BYPASS MANTIĞI:
            -- request fonksiyonu ile tarayıcı gibi davranıyoruz.
            -- User-Agent: Chrome olduğunu söylüyoruz.
            -- Referer: Sitenin kendisinden geldiğimizi söylüyoruz (PHP korumasını geçmek için).
            
            local TargetURL = VerifyLink .. InputKey .. "&nocache=" .. math.random(1,99999)
            
            if request then
                local Response = request({
                    Url = TargetURL,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                        ["Referer"] = "https://wansstudioskeyal.wuaze.com/",
                        ["Origin"] = "https://wansstudioskeyal.wuaze.com"
                    }
                })
                
                print("WANS DEBUG: Status=" .. tostring(Response.StatusCode))
                print("WANS DEBUG: Body=" .. tostring(Response.Body))

                if Response.StatusCode == 200 and Response.Body then
                    if string.find(Response.Body, "valid") then
                        KeyBox.Text = GetText("KeySuccess")
                        KeyBox.TextColor3 = Color3.fromRGB(0, 255, 0)
                        task.wait(1); KeyGui:Destroy(); OnSuccess()
                    else
                        KeyBox.Text = GetText("KeyFail")
                        KeyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
                        task.wait(1.5); KeyBox.Text = InputKey; KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                else
                    KeyBox.Text = "Hosting Blocked!" -- Hosting engelledi
                    print("Error: Status " .. tostring(Response.StatusCode))
                end
            else
                -- Eğer exploit 'request' desteklemiyorsa mecburen game:HttpGet deneriz
                -- (Ama bu muhtemelen 403 hatası alır)
                local s, r = pcall(function() return game:HttpGet(TargetURL, true) end)
                if s and string.find(r, "valid") then
                    KeyBox.Text = GetText("KeySuccess")
                    KeyBox.TextColor3 = Color3.fromRGB(0, 255, 0)
                    task.wait(1); KeyGui:Destroy(); OnSuccess()
                else
                    KeyBox.Text = "Exploit Not Supported"
                end
            end
        end)
    end)

    CreateBtn("KeyGet", UDim2.new(0.52, 0, 0.65, 0), Color3.fromRGB(80, 80, 80), function()
        setclipboard(GetKeyLink)
        KeyBox.Text = "Link Copied"
        task.wait(1)
        KeyBox.Text = ""
    end)
end

-- =============================================================================
-- ANA SCRİPT (ASIL HİLE KODLARI)
-- =============================================================================
local function LoadMainScript()
    -- !!! BURASI ÇOK ÖNEMLİ !!!
    -- Key doğrulandıktan sonra çalışacak asıl hile kodların burada olmalı.
    -- Şimdilik boş, kendi kodlarını buraya yapıştırabilirsin.
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wans Studios";
        Text = "HOŞGELDİN! Script Aktif.";
        Duration = 5;
    })
    
    print("WANS: SCRIPT YUKLENDI!")
    
    -- ÖRNEK: UI KÜTÜPHANENİ BURADA BAŞLAT
    -- loadstring(game:HttpGet("..."))()
end

StartKeySystem(LoadMainScript)
