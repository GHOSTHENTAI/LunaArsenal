-- LunaHub | OrionLib Edition | by Кира 💖

-- 📦 Загрузка библиотеки
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexx/orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "LunaHub 💖 | Orion UI",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Добро пожаловать, Кира 💻",
    ConfigFolder = "LunaHub"
})

-- 🧠 Переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

local Aimbot = false
local SilentAim = false
local Noclip = false

-- 🎯 Функция поиска цели
local function GetTarget()
    local shortest = math.huge
    local closest = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
            if onScreen and dist < shortest then
                shortest = dist
                closest = plr
            end
        end
    end
    return closest
end

-- ⚔️ Aimbot
RunService.RenderStepped:Connect(function()
    if Aimbot then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.1)
        end
    end
end)

-- 🔫 Silent Aim
pcall(function()
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        if SilentAim and tostring(self) == "FireServer" and tostring(args[1]) == "HitPart" then
            local target = GetTarget()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                args[2] = target.Character.Head
                args[3] = target.Character.Head.Position
                return old(self, unpack(args))
            end
        end
        return old(self, ...)
    end)
end)

-- 📂 Вкладки
local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 🧱 Combat
CombatTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(state)
        Aimbot = state
    end
})

CombatTab:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(state)
        SilentAim = state
    end
})

-- ✨ ESP
VisualTab:AddButton({
    Name = "Glow ESP",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local esp = Instance.new("Highlight", plr.Character)
                esp.FillColor = Color3.fromRGB(255, 105, 180)
                esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                esp.FillTransparency = 0.2
                esp.OutlineTransparency = 0
            end
        end
    end
})

-- 🚀 Speed
MiscTab:AddSlider({
    Name = "SpeedHack",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        if LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- 👻 Noclip
MiscTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(val)
        Noclip = val
    end
})

RunService.Stepped:Connect(function()
    if Noclip then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- 🛠 Завершение
OrionLib:Init()
