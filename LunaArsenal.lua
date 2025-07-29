-- LunaHub | Arsenal Edition | by Кира 💖

-- UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexx/orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "LunaHub 💖 | Arsenal",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Добро пожаловать, Кира 😈",
    ConfigFolder = "LunaHub"
})

-- Vars
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- Toggles
local Aimbot = false
local SilentAim = false
local Noclip = false
local HitPart = "Head"
local FOV_Radius = 250

-- Combat Functions
local function GetTarget()
    local closest = nil
    local shortest = FOV_Radius
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, visible = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
            if visible and dist < shortest then
                closest = plr
                shortest = dist
            end
        end
    end
    return closest
end

local function GetHitPart(char)
    if HitPart == "Head" then return char:FindFirstChild("Head")
    elseif HitPart == "Torso" then return char:FindFirstChild("HumanoidRootPart")
    else
        local parts = {"Head", "HumanoidRootPart", "UpperTorso"}
        return char:FindFirstChild(parts[math.random(1, #parts)])
    end
end

-- Aimbot
RunService.RenderStepped:Connect(function()
    if Aimbot then
        local target = GetTarget()
        if target and target.Character then
            local part = GetHitPart(target.Character)
            if part then
                Camera.CFrame = Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position, part.Position),
                    0.15
                )
            end
        end
    end
end)

-- Silent Aim
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if SilentAim and tostring(self) == "FireServer" and tostring(args[1]) == "HitPart" then
        local target = GetTarget()
        if target and target.Character then
            local part = GetHitPart(target.Character)
            if part then
                args[2] = part
                args[3] = part.Position
                return old(self, unpack(args))
            end
        end
    end
    return old(self, ...)
end)

-- UI Tabs
local Combat = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://4483362458", PremiumOnly = false })
local Visual = Window:MakeTab({ Name = "Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false })
local Misc = Window:MakeTab({ Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false })

-- Combat Controls
Combat:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(state) Aimbot = state end
})

Combat:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(state) SilentAim = state end
})

Combat:AddDropdown({
    Name = "Цель Aimbot/Silent",
    Options = {"Head", "Torso", "Random"},
    Default = "Head",
    Callback = function(option)
        HitPart = option
    end
})

Combat:AddSlider({
    Name = "FOV Радиус",
    Min = 50,
    Max = 500,
    Default = 250,
    Increment = 10,
    ValueName = "px",
    Callback = function(value)
        FOV_Radius = value
    end
})

-- Glow ESP
Visual:AddButton({
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

-- Speed & Noclip
Misc:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

Misc:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(val) Noclip = val end
})

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Finish
OrionLib:Init()
