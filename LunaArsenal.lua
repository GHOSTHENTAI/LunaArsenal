-- LunaHub v1.1 | Made for Кира 💜
-- Solara Ready | Auto HWID | Dark+Pink Rayfield

-- 🛡️ HWID-авторизация с автосохранением
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local filePath = "LunaHub/hwid.txt"

if not isfolder("LunaHub") then makefolder("LunaHub") end

if not isfile(filePath) then
    writefile(filePath, hwid)
    print("🌸 HWID сохранён: " .. hwid)
else
    local saved = readfile(filePath)
    if saved ~= hwid then
        game.Players.LocalPlayer:Kick("❌ LunaHub | HWID не совпадает.\nSaved: "..saved.."\nNow: "..hwid)
        return
    end
end

-- 🌐 Rayfield UI
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "LunaHub 💖 | Arsenal",
    LoadingTitle = "LunaHub",
    LoadingSubtitle = "by Кира 😈",
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

-- ⚔️ Combat
local Combat = Window:CreateTab("Combat", 4483362458)
local AimbotToggle = false
local SilentAimToggle = false

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

-- 🎯 Aimbot Logic
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function GetClosestTarget()
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
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
    local target = GetClosestTarget()
    if AimbotToggle and target and target.Character and target.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
    end
end)

-- 🧠 Silent Aim Hook
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

-- ⚙️ Misc
local Misc = Window:CreateTab("Misc", 4483345998)
local NoclipActive = false

Misc:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

Misc:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value) NoclipActive = Value end
})

RunService.Stepped:Connect(function()
    if NoclipActive then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ✨ Glow ESP
Misc:CreateButton({
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

Rayfield:Notify({
    Title = "LunaHub Запущен 💜",
    Content = "Добро пожаловать, Кира 🌸",
    Duration = 6
})
