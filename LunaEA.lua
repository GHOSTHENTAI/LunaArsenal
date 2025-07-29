-- LunaHub EA Fix | Автор: Кира 💖

-- 🔁 Очистка старой версии
if getgenv().LunaHubLoaded then
    getgenv().LunaHubShutdown()
end

-- 🔐 HWID
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local filePath = "LunaHub/hwid.txt"

if not isfolder("LunaHub") then makefolder("LunaHub") end
if not isfile(filePath) then writefile(filePath, hwid)
else
    local saved = readfile(filePath)
    if saved ~= hwid then
        game.Players.LocalPlayer:Kick("HWID не совпадает.")
        return
    end
end

-- 📦 UI
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
end)

if not success then
    warn("❌ Rayfield UI не загрузился")
    return
end

local Window = Rayfield:CreateWindow({
    Name = "LunaHub 💖 | Energy Assault",
    LoadingTitle = "Загрузка LunaHub",
    LoadingSubtitle = "Привет, Кира <3",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- ✅ UI Toggle
local UIS = game:GetService("UserInputService")
local isOpen = true
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        isOpen = not isOpen
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui.Name == "Rayfield" then
                gui.Enabled = isOpen
            end
        end
    end
end)

-- 🧠 Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

local function GetTarget()
    local shortest = math.huge
    local closest = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onscreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
            if onscreen and dist < shortest then
                shortest = dist
                closest = plr
            end
        end
    end
    return closest
end

-- ⚔️ Combat
local Combat = Window:CreateTab("Combat", 4483362458)
local aimbot, silent = false, false

Combat:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(state) aimbot = state end
})

Combat:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(state) silent = state end
})

RunService.RenderStepped:Connect(function()
    if aimbot then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Character.Head.Position),
                0.1
            )
        end
    end
end)

-- 🔫 Silent Aim
pcall(function()
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        if silent and tostring(self) == "FireServer" and tostring(args[1]) == "HitPart" then
            local t = GetTarget()
            if t and t.Character and t.Character:FindFirstChild("Head") then
                args[2] = t.Character.Head
                args[3] = t.Character.Head.Position
                return old(self, unpack(args))
            end
        end
        return old(self, ...)
    end)
end)

-- ✨ ESP
local Visual = Window:CreateTab("Visual", 4483345998)

Visual:CreateButton({
    Name = "Glow ESP",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local h = Instance.new("Highlight")
                h.Parent = plr.Character
                h.FillColor = Color3.fromRGB(255, 105, 180)
                h.OutlineColor = Color3.fromRGB(255,255,255)
                h.FillTransparency = 0.2
                h.OutlineTransparency = 0
            end
        end
    end
})

-- 🚀 Speed / Noclip
local Misc = Window:CreateTab("Misc", 4483345998)
local noclip = false

Misc:CreateSlider({
    Name = "SpeedHack",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        if LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

Misc:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(val) noclip = val end
})

RunService.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 📢 Гарантированное уведомление
Rayfield:Notify({
    Title = "LunaHub Готова",
    Content = "Добро пожаловать, Кира 💖",
    Duration = 5
})
print("✅ LunaHub EA успешно загружена")

-- 🧹 Выгрузка
getgenv().LunaHubShutdown = function()
    for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "Rayfield" then v:Destroy() end
    end
    getgenv().LunaHubLoaded = false
end

getgenv().LunaHubLoaded = true
