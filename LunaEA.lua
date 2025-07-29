-- LunaHub v1.2 | Energy Assault Edition 💜
-- Автор: Кира 😈 | Для инжектора: Solara

-- 🔁 Удаление предыдущей копии
if getgenv().LunaHubLoaded then
    getgenv().LunaHubShutdown()
end

-- 🔐 HWID авторизация (с автосохранением)
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local filePath = "LunaHub/hwid.txt"
if not isfolder("LunaHub") then makefolder("LunaHub") end
if not isfile(filePath) then writefile(filePath, hwid)
else
    local saved = readfile(filePath)
    if saved ~= hwid then
        game.Players.LocalPlayer:Kick("❌ LunaHub | HWID не совпадает")
        return
    end
end

-- 📦 Rayfield UI
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "LunaHub 💖 | Energy Assault",
    LoadingTitle = "LunaHub",
    LoadingSubtitle = "Energy Assault Edition",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

Rayfield:LoadConfiguration({
    Theme = {
        Background = Color3.fromRGB(15, 15, 15),
        Topbar = Color3.fromRGB(30, 30, 30),
        TextColor = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 105, 180),
        Outline = Color3.fromRGB(255, 105, 180),
        Font = Enum.Font.GothamSemibold
    }
})

-- 🎛 UI Toggle
local UIS = game:GetService("UserInputService")
local isOpen = true
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.RightControl then
        isOpen = not isOpen
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui.Name == "Rayfield" then
                gui.Enabled = isOpen
            end
        end
    end
end)

-- 📁 Modules
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 🎯 Aimbot / Silent
local AimbotToggle = false
local SilentAimToggle = false
local NoclipActive = false

local function GetClosestTarget()
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, visible = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
            if visible and dist < shortest then
                shortest, closest = dist, plr
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotToggle then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Character.Head.Position),
                0.15
            )
        end
    end
end)

-- 🔫 Silent Aim Hook
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if SilentAimToggle and tostring(self) == "FireServer" and tostring(args[1]) == "HitPart" then
        local t = GetClosestTarget()
        if t and t.Character and t.Character:FindFirstChild("Head") then
            args[2] = t.Character.Head
            args[3] = t.Character.Head.Position
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- 💜 UI Tabs
local Combat = Window:CreateTab("Combat", 4483362458)
local Visual = Window:CreateTab("Visuals", 4483345998)
local Misc = Window:CreateTab("Misc", 4483345998)

-- ☑️ UI Toggles
Combat:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(val) AimbotToggle = val end
})

Combat:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(val) SilentAimToggle = val end
})

-- ✨ Glow ESP
Visual:CreateButton({
    Name = "Glow ESP",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local esp = Instance.new("Highlight")
                esp.FillColor = Color3.fromRGB(255, 105, 180)
                esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                esp.FillTransparency = 0.2
                esp.OutlineTransparency = 0
                esp.Parent = plr.Character
            end
        end
    end
})

-- 🚀 SpeedHack
Misc:CreateSlider({
    Name = "Speed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        if LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

-- 👻 Noclip
Misc:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(val) NoclipActive = val end
})

RunService.Stepped:Connect(function()
    if NoclipActive then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- ✅ Визуальное уведомление
Rayfield:Notify({
    Title = "LunaHub запущен",
    Content = "Добро пожаловать в Energy Assault, Кира 💖",
    Duration = 5
})

-- 🧹 Завершение
getgenv().LunaHubShutdown = function()
    if Rayfield and Rayfield.Destroy then Rayfield:Destroy() end
    getgenv().LunaHubLoaded = false
end
getgenv().LunaHubLoaded = true
