-- =============================================
-- core.lua - WARCORE ULTIMATE
-- Todas as funções e lógica do menu
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Configurações globais
getgenv().SystemConfig = {
    MiraAtiva = false,
    FovRadius = 500,
    Smoothness = 0.35,
    TriggerBot = false,
    TriggerDelay = 100,
    SilentAim = false,
    AimPart = "Cabeça",
    AntiRecoil = false,
    RecoilReduction = 0.5,
    HighlightEnabled = false,
    HlDepthMode = "AlwaysOnTop",
    HlFillTransparency = 0.5,
    HlEnemyColor = Color3.fromRGB(255, 0, 0),
    DotEnabled = false,
    MicroHpEnabled = false,
    MicroDistEnabled = false,
    MicroTextSize = 8,
    MicroWidth = 35,
    ChamsEnabled = false,
    ChamsColor = Color3.fromRGB(0, 255, 0),
    ChamsRainbow = false,
    GrayMode = false,
    FlyEnabled = false,
    FlySpeed = 50,
    FlyInfinite = false,
    SpeedEnabled = false,
    SpeedValue = 50,
    JumpEnabled = false,
    JumpPower = 100,
    InfiniteJump = false,
    WallClimb = false,
    WallClimbSpeed = 20,
    AutoSprint = false,
    AntiAFK = false,
    AutoCollect = false,
    CollectRadius = 30,
    FullBright = false,
    ClarezaMod = false,
    ShowFPS = false,
    ShowPlayers = false,
}

-- Variáveis internas
local NoClipAtivo = false
local NoClipConnection = nil
local flyVelocity = nil
local flyConnection = nil
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalSettings = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    GlobalShadows = Lighting.GlobalShadows,
    Exposure = Lighting.ExposureCompensation
}
local rainbowHue = 0
local lastShotTime = 0
local isMousePressed = false

-- ====================
-- FUNÇÕES AUXILIARES
-- ====================
local function getTarget()
    local closest, shortest = nil, getgenv().SystemConfig.FovRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local isTeam = (p.Team == Player.Team and Player.Team ~= nil)
                if not (isTeam and getgenv().SystemConfig.TeamCheck) then
                    local pos, vis = Camera:WorldToViewportPoint(head.Position)
                    if vis and pos.Z > 0 then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function IsBehindWall(targetPart)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {Player.Character, targetPart.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), rayParams)
    return result ~= nil
end

-- ====================
-- FLY
-- ====================
local function stopFly()
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
    getgenv().SystemConfig.FlyEnabled = false
end

local function startFly()
    local char = Player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum.AutoRotate = true
    end

    if flyVelocity then flyVelocity:Destroy() end
    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.Name = "FlyVelocity"
    flyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    flyVelocity.Parent = hrp
    getgenv().SystemConfig.FlyEnabled = true

    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not getgenv().SystemConfig.FlyEnabled then stopFly(); return end
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if not flyVelocity then return end

        local speed = getgenv().SystemConfig.FlySpeed
        local targetVel = Vector3.zero

        if getgenv().SystemConfig.FlyInfinite then
            targetVel = Camera.CFrame.LookVector * speed
        else
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local flatLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
                if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
                local flatCamCFrame = CFrame.lookAt(Vector3.zero, flatLook)
                local rawInput = flatCamCFrame:VectorToObjectSpace(moveDir)
                targetVel = Camera.CFrame:VectorToWorldSpace(rawInput) * speed
            else
                targetVel = Vector3.zero
            end
        end
        flyVelocity.Velocity = targetVel
    end)
end

-- ====================
-- EXPORTA FUNÇÕES PARA A UI
-- ====================
_G.Warcore = {
    Config = getgenv().SystemConfig,

    ToggleFly = function(active)
        if active then startFly() else stopFly() end
    end,

    ToggleNoClip = function(active)
        NoClipAtivo = active
        if NoClipAtivo then
            if NoClipConnection then NoClipConnection:Disconnect() end
            NoClipConnection = RunService.Stepped:Connect(function()
                local char = Player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if NoClipConnection then NoClipConnection:Disconnect(); NoClipConnection = nil end
        end
    end,

    ToggleSpeed = function(active)
        getgenv().SystemConfig.SpeedEnabled = active
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = active and getgenv().SystemConfig.SpeedValue or OriginalWalkSpeed
        end
    end,

    ToggleJump = function(active)
        getgenv().SystemConfig.JumpEnabled = active
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = active and getgenv().SystemConfig.JumpPower or OriginalJumpPower
        end
    end,

    SetSpeedValue = function(val)
        getgenv().SystemConfig.SpeedValue = val
        if getgenv().SystemConfig.SpeedEnabled then
            local char = Player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end,

    SetJumpPower = function(val)
        getgenv().SystemConfig.JumpPower = val
        if getgenv().SystemConfig.JumpEnabled then
            local char = Player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end,

    GetTarget = getTarget,
    IsBehindWall = IsBehindWall,
}

-- ====================
-- LOOP PRINCIPAL
-- ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMousePressed = true
    end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        isMousePressed = false
    end
end)

RunService.RenderStepped:Connect(function(dt)
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cfg = getgenv().SystemConfig

    if cfg.ShowFPS or cfg.ShowPlayers then
        _G.Warcore.FPS = math.floor(1/dt)
        _G.Warcore.PlayerCount = #Players:GetPlayers()
    end

    if cfg.FullBright then
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = OriginalSettings.Ambient
        Lighting.OutdoorAmbient = OriginalSettings.OutdoorAmbient
        Lighting.ClockTime = OriginalSettings.ClockTime
    end

    if cfg.ClarezaMod then
        Lighting.Brightness = 3
        Lighting.ExposureCompensation = 0.5
    else
        if not cfg.FullBright then
            Lighting.Brightness = OriginalSettings.Brightness
            Lighting.ExposureCompensation = OriginalSettings.Exposure
        end
    end

    if cfg.AutoSprint and hum then
        hum.AutoRotate = true
    end

    if cfg.WallClimb and char and hum then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local ray = RaycastParams.new()
            ray.FilterDescendantsInstances = {char}
            local hit = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3, ray)
            if hit then
                local move = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
                local jump = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
                local climbVel = (hit.Normal * -1) * cfg.WallClimbSpeed * move
                climbVel = climbVel + Vector3.new(0, cfg.WallClimbSpeed * jump, 0)
                hrp.Velocity = climbVel
            end
        end
    end

    if cfg.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end

    if cfg.AutoCollect and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local radius = cfg.CollectRadius
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Tool") or (obj:IsA("Part") and obj:FindFirstChild("TouchInterest")) then
                    if (obj.Position - hrp.Position).Magnitude < radius then
                        firetouchinterest(hrp, obj, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, obj, 1)
                    end
                end
            end
        end
    end

    if cfg.MiraAtiva then
        local target = getTarget()
        if target then
            local goal = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(goal, cfg.Smoothness * math.clamp(60 * dt, 0, 1))
        end
    end

    if cfg.TriggerBot and char and isMousePressed then
        local target = getTarget()
        if target then
            local mouse = Player:GetMouse()
            local pos, vis = Camera:WorldToViewportPoint(target.Position)
            if vis and (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude < 50 then
                if tick() - lastShotTime >= cfg.TriggerDelay / 1000 then
                    mouse1click()
                    lastShotTime = tick()
                end
            end
        end
    end

    if cfg.ChamsEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local char = p.Character
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local cham = part:FindFirstChild("ChamEffect")
                        if not cham then
                            cham = Instance.new("BoxHandleAdornment", part)
                            cham.Name = "ChamEffect"
                            cham.Size = part.Size
                            cham.CFrame = part.CFrame
                            cham.AlwaysOnTop = true
                            cham.ZIndex = 0
                        end
                        local color = cfg.ChamsColor
                        if cfg.ChamsRainbow then
                            rainbowHue = (rainbowHue + dt * 0.5) % 1
                            color = Color3.fromHSV(rainbowHue, 1, 1)
                        end
                        cham.Color3 = color
                        cham.Adornee = part
                        cham.Visible = true
                    end
                end
            end
        end
    end

    if cfg.GrayMode then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Material ~= Enum.Material.Neon then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
    end

    -- ESP e Micro-HUD
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            if head then
                local isTeam = (p.Team == Player.Team and Player.Team ~= nil)
                local statusColor = isTeam and Color3.fromRGB(0, 255, 0) or cfg.HlEnemyColor

                local hl = char:FindFirstChild("System_HL") or Instance.new("Highlight", char)
                hl.Name = "System_HL"
                hl.Enabled = cfg.HighlightEnabled
                hl.FillColor = statusColor
                hl.OutlineColor = statusColor
                hl.FillTransparency = cfg.HlFillTransparency
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode[cfg.HlDepthMode]

                local dot = head:FindFirstChild("System_Dot")
                if cfg.DotEnabled then
                    if not dot then
                        local bill = Instance.new("BillboardGui", head)
                        bill.Name = "System_Dot"
                        bill.Size = UDim2.new(0, 10, 0, 10)
                        bill.AlwaysOnTop = true
                        bill.ExtentsOffset = Vector3.new(0, 1.5, 0)
                        local f = Instance.new("Frame", bill)
                        f.Size = UDim2.new(1,0,1,0)
                        Instance.new("UICorner", f).CornerRadius = UDim.new(1,0)
                        dot = bill
                    end
                    dot.Enabled = true
                    local behind = IsBehindWall(head)
                    local dotColor = isTeam and Color3.fromRGB(0, 255, 0) or (behind and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(255, 0, 0))
                    dot.Frame.BackgroundColor3 = dotColor
                elseif dot then
                    dot:Destroy()
                end

                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local hud = root:FindFirstChild("Aguia_MicroHUD")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and (cfg.MicroHpEnabled or cfg.MicroDistEnabled) and hum.Health > 0 then
                        local function CreateMicroDisplay(char)
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if not root then return nil end
                            local billboard = root:FindFirstChild("Aguia_MicroHUD")
                            if not billboard then
                                billboard = Instance.new("BillboardGui", root)
                                billboard.Name = "Aguia_MicroHUD"
                                billboard.AlwaysOnTop = true
                                billboard.ExtentsOffset = Vector3.new(0, -3.7, 0)
                                local bgBar = Instance.new("Frame", billboard)
                                bgBar.Name = "BackgroundBar"
                                bgBar.Size = UDim2.new(1, 0, 0, 2)
                                bgBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                                bgBar.BorderSizePixel = 0
                                local mainBar = Instance.new("Frame", bgBar)
                                mainBar.Name = "MainBar"
                                mainBar.Size = UDim2.new(1, 0, 1, 0)
                                mainBar.BorderSizePixel = 0
                                local label = Instance.new("TextLabel", billboard)
                                label.Name = "DistLabel"
                                label.BackgroundTransparency = 1
                                label.Font = Enum.Font.GothamBold
                                label.TextStrokeTransparency = 0.4
                            end
                            billboard.Size = UDim2.new(0, cfg.MicroWidth, 0, cfg.MicroTextSize + 4)
                            billboard.DistLabel.Size = UDim2.new(1, 0, 0, cfg.MicroTextSize)
                            billboard.DistLabel.TextSize = cfg.MicroTextSize
                            billboard.DistLabel.Position = UDim2.new(0, 0, 0, 3)
                            return billboard
                        end
                        local currentHud = CreateMicroDisplay(char)
                        if currentHud then
                            local teamColor = isTeam and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 50, 50)
                            if cfg.MicroHpEnabled then
                                local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                                currentHud.BackgroundBar.MainBar.Size = UDim2.new(healthRatio, 0, 1, 0)
                                currentHud.BackgroundBar.MainBar.BackgroundColor3 = teamColor
                                currentHud.BackgroundBar.Visible = true
                            else
                                currentHud.BackgroundBar.Visible = false
                            end
                            if cfg.MicroDistEnabled then
                                local distance = math.floor(Player:DistanceFromCharacter(root.Position))
                                currentHud.DistLabel.Text = string.format("%dm", distance)
                                currentHud.DistLabel.TextColor3 = teamColor
                                currentHud.DistLabel.Visible = true
                            else
                                currentHud.DistLabel.Visible = false
                            end
                            currentHud.Enabled = true
                        end
                    elseif hud then
                        hud.Enabled = false
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local cfg = getgenv().SystemConfig

    if cfg.SpeedEnabled then
        if hum.WalkSpeed ~= cfg.SpeedValue then
            hum.WalkSpeed = cfg.SpeedValue
        end
    else
        if hum.WalkSpeed ~= OriginalWalkSpeed then hum.WalkSpeed = OriginalWalkSpeed end
    end

    if cfg.JumpEnabled then
        if hum.JumpPower ~= cfg.JumpPower then
            hum.JumpPower = cfg.JumpPower
        end
    else
        if hum.JumpPower ~= OriginalJumpPower then hum.JumpPower = OriginalJumpPower end
    end

    if cfg.InfiniteJump then
        if hum:GetState() == Enum.HumanoidStateType.Freefall and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Player.CharacterAdded:Connect(function(char)
    task.wait(0.6)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        OriginalWalkSpeed = hum.WalkSpeed
        OriginalJumpPower = hum.JumpPower
    end
    if NoClipAtivo then
        if NoClipConnection then NoClipConnection:Disconnect() end
        NoClipConnection = RunService.Stepped:Connect(function()
            local chr = Player.Character
            if chr then
                for _, part in ipairs(chr:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
    if getgenv().SystemConfig.FlyEnabled then
        startFly()
    end
end)

print("[WARCORE] Core carregado com sucesso!")