--// AFNAN HUB - FISH IT (FINAL)

if getgenv().AFNAN_HUB_LOADED then return end
getgenv().AFNAN_HUB_LOADED = true

getgenv().AFNAN_VERSION = "1.0"

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- ================= SETTINGS =================
local Settings = {
    -- FARM
    AutoFish = true,
    InstantCatch = true,
    AutoSell = false,

    -- CHARACTER
    WalkSpeed = 16,
    JumpPower = 50,

    -- ESP
    PlayerESP = true,
    FishESP = true,
    RodESP = true
}

-- ================= ANTI AFK =================
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- ================= CHARACTER =================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = Settings.WalkSpeed
        hum.JumpPower = Settings.JumpPower
    end
end)

-- ================= AUTO FISH =================
task.spawn(function()
    while task.wait(0.4) do
        if Settings.AutoFish then
            for _,v in ipairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") and v.Name:lower():find("cast") then
                    v:FireServer()
                end
                if Settings.InstantCatch and v:IsA("RemoteEvent") and v.Name:lower():find("reel") then
                    v:FireServer(true)
                end
            end
        end
    end
end)

-- ================= ESP =================
local drawings = {}

local function newText()
    local t = Drawing.new("Text")
    t.Size = 14
    t.Center = true
    t.Outline = true
    t.Visible = false
    return t
end

local function clearESP()
    for _,d in ipairs(drawings) do
        d:Remove()
    end
    table.clear(drawings)
end

RunService.RenderStepped:Connect(function()
    clearESP()

    for _,obj in ipairs(workspace:GetDescendants()) do
        -- PLAYER ESP
        if Settings.PlayerESP and obj:IsA("Model") then
            local plr = Players:GetPlayerFromCharacter(obj)
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if plr and hrp and plr ~= LocalPlayer then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local t = newText()
                    t.Text = plr.Name
                    t.Position = Vector2.new(pos.X, pos.Y)
                    t.Visible = true
                    table.insert(drawings, t)
                end
            end
        end

        -- FISH ESP
        if Settings.FishESP and obj:IsA("Model") and obj.Name:lower():find("fish") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local t = newText()
                    t.Text = "🐟 Fish"
                    t.Position = Vector2.new(pos.X, pos.Y)
                    t.Visible = true
                    table.insert(drawings, t)
                end
            end
        end

        -- ROD ESP
        if Settings.RodESP and obj:IsA("Tool") and obj.Name:lower():find("rod") then
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local pos, onScreen = Camera:WorldToViewportPoint(handle.Position)
                if onScreen then
                    local t = newText()
                    t.Text = "🎣 Rod"
                    t.Position = Vector2.new(pos.X, pos.Y)
                    t.Visible = true
                    table.insert(drawings, t)
                end
            end
        end
    end
end)

print("AFNAN HUB Loaded | Version:", getgenv().AFNAN_VERSION)
