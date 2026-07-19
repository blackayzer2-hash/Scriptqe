-- ui.lua – Interface corrigida (sem Rayfield)
print("[WARCORE] Iniciando UI...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- Verifica se o core existe, se não, cria um config vazio para não quebrar
if not _G.Warcore then
    warn("[WARCORE] Core não encontrado! Criando config temporária.")
    _G.Warcore = {
        Config = {},
        ToggleFly = function() end,
        ToggleNoClip = function() end,
        ToggleSpeed = function() end,
        ToggleJump = function() end,
        SetSpeedValue = function() end,
        SetJumpPower = function() end,
        GetTarget = function() end,
        IsBehindWall = function() end,
        FPS = 0,
        PlayerCount = 0,
    }
end

local cfg = _G.Warcore.Config

-- Cria a GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "WarcoreUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fundo escuro (overlay)
local Background = Instance.new("Frame", ScreenGui)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.6
Background.Visible = false
Background.ZIndex = 0

-- Janela principal do menu
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- começa invisível
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 16)

local Shadow = Instance.new("UIStroke", MainFrame)
Shadow.Thickness = 6
Shadow.Color = Color3.fromRGB(0, 0, 0)
Shadow.Transparency = 0.6

local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 1.5
Border.Color = Color3.fromRGB(0, 200, 255)
Border.Transparency = 0.3

-- Barra de título
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 28, 42)
TitleBar.BorderSizePixel = 0
local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 16)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👑 WARCORE ULTIMATE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -44, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.ZIndex = 11

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(1, -88, 0, 2)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.ZIndex = 11

-- Conteúdo das abas (ScrollingFrame)
local ContentArea = Instance.new("ScrollingFrame", MainFrame)
ContentArea.Size = UDim2.new(1, -12, 1, -100)
ContentArea.Position = UDim2.new(0, 6, 0, 94)
ContentArea.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
ContentArea.BackgroundTransparency = 0.3
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = 4
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ContentArea.Visible = true
ContentArea.ZIndex = 12
local contentCorner = Instance.new("UICorner", ContentArea)
contentCorner.CornerRadius = UDim.new(0, 8)

local ContentLayout = Instance.new("UIListLayout", ContentArea)
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Barra de abas (simplificada, sem navegação por abas para evitar complexidade)
-- Vou criar uma única lista de controles com seções, sem abas, para garantir funcionamento.
-- Mas se quiser abas, posso adicionar depois.

-- Função auxiliar para adicionar seção
local function AddSection(title)
    local section = Instance.new("Frame", ContentArea)
    section.Size = UDim2.new(1, -12, 0, 30)
    section.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(0, 200, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    return section
end

-- Função para adicionar Toggle
local function AddToggle(labelText, defaultValue, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -12, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -56, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 40, 0, 26)
    toggleBtn.Position = UDim2.new(1, -48, 0, 5)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local indicator = Instance.new("Frame", toggleBtn)
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = defaultValue and UDim2.new(1, -24, 0, 3) or UDim2.new(0, 4, 0, 3)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 10)

    local state = defaultValue

    local function updateVisual()
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            indicator.Position = UDim2.new(1, -24, 0, 3)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            indicator.Position = UDim2.new(0, 4, 0, 3)
        end
    end
    updateVisual()

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if callback then callback(state) end
    end)

    return {SetValue = function(v) state = v; updateVisual() end}
end

-- Função para adicionar Slider
local function AddSlider(labelText, min, max, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -12, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 40, 0, 18)
    valueLabel.Position = UDim2.new(1, -50, 0, 2)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(1, -20, 0, 6)
    slider.Position = UDim2.new(0, 10, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
    slider.BorderSizePixel = 0
    local sliderCorner = Instance.new("UICorner", slider)
    sliderCorner.CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 4)

    local dragging = false
    local value = default

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * pos
        value = math.round(value / (max - min < 1 and 0.01 or 1)) * (max - min < 1 and 0.01 or 1)
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {SetValue = function(v) value = math.clamp(v, min, max); fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0); valueLabel.Text = tostring(value); end}
end

-- Função para adicionar Dropdown (simplificada)
local function AddDropdown(labelText, options, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -12, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownBtn = Instance.new("TextButton", frame)
    dropdownBtn.Size = UDim2.new(1, -120, 0, 28)
    dropdownBtn.Position = UDim2.new(0, 110, 0, 6)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = default or options[1]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.GothamMedium
    dropdownBtn.TextSize = 13
    dropdownBtn.AutoButtonColor = false
    local ddCorner = Instance.new("UICorner", dropdownBtn)
    ddCorner.CornerRadius = UDim.new(0, 6)

    local dropdownOpen = false
    local optionList = nil

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        if dropdownOpen then
            if optionList then optionList:Destroy() end
            optionList = Instance.new("Frame", MainFrame)
            optionList.Size = UDim2.new(0, 180, 0, math.min(#options * 30, 150))
            optionList.Position = UDim2.new(0, dropdownBtn.AbsolutePosition.X - MainFrame.AbsolutePosition.X, 0, dropdownBtn.AbsolutePosition.Y - MainFrame.AbsolutePosition.Y + 34)
            optionList.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
            optionList.BorderSizePixel = 0
            optionList.ZIndex = 20
            local listCorner = Instance.new("UICorner", optionList)
            listCorner.CornerRadius = UDim.new(0, 8)
            local listLayout = Instance.new("UIListLayout", optionList)
            listLayout.Padding = UDim.new(0, 2)

            for _, opt in ipairs(options) do
                local btn = Instance.new("TextButton", optionList)
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
                btn.BackgroundTransparency = 0.5
                btn.BorderSizePixel = 0
                btn.Text = opt
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamMedium
                btn.TextSize = 13
                btn.AutoButtonColor = false
                btn.ZIndex = 21
                btn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = opt
                    if callback then callback(opt) end
                    dropdownOpen = false
                    if optionList then optionList:Destroy(); optionList = nil end
                end)
            end
        else
            if optionList then optionList:Destroy(); optionList = nil end
        end
    end)

    return {SetValue = function(v) dropdownBtn.Text = v end}
end

-- Função para adicionar Color Picker (simplificada)
local function AddColorPicker(labelText, defaultColor, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -12, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local colorBtn = Instance.new("TextButton", frame)
    colorBtn.Size = UDim2.new(0, 40, 0, 26)
    colorBtn.Position = UDim2.new(1, -48, 0, 7)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.AutoButtonColor = false
    local colorCorner = Instance.new("UICorner", colorBtn)
    colorCorner.CornerRadius = UDim.new(0, 8)

    colorBtn.MouseButton1Click:Connect(function()
        local picker = Instance.new("Frame", MainFrame)
        picker.Size = UDim2.new(0, 200, 0, 160)
        picker.Position = UDim2.new(0.5, -100, 0.5, -80)
        picker.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
        picker.BorderSizePixel = 0
        picker.ZIndex = 20
        local pickerCorner = Instance.new("UICorner", picker)
        pickerCorner.CornerRadius = UDim.new(0, 12)
        local pickerLayout = Instance.new("UIGridLayout", picker)
        pickerLayout.CellSize = UDim2.new(0, 40, 0, 40)
        pickerLayout.CellPadding = UDim.new(0, 8)
        pickerLayout.FillDirectionMaxCells = 4

        local colors = {
            Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0), Color3.fromRGB(0,255,0),
            Color3.fromRGB(0,200,255), Color3.fromRGB(0,0,255), Color3.fromRGB(200,0,255), Color3.fromRGB(255,0,200),
            Color3.fromRGB(255,255,255), Color3.fromRGB(100,100,100),
        }
        for _, c in ipairs(colors) do
            local btn = Instance.new("TextButton", picker)
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = c
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 8)
            btn.MouseButton1Click:Connect(function()
                colorBtn.BackgroundColor3 = c
                if callback then callback(c) end
                picker:Destroy()
            end)
        end
        local closePicker = Instance.new("TextButton", picker)
        closePicker.Size = UDim2.new(0, 30, 0, 30)
        closePicker.Position = UDim2.new(1, -36, 0, 4)
        closePicker.BackgroundTransparency = 1
        closePicker.Text = "✕"
        closePicker.TextColor3 = Color3.fromRGB(255,200,200)
        closePicker.Font = Enum.Font.GothamBold
        closePicker.TextSize = 16
        closePicker.ZIndex = 21
        closePicker.MouseButton1Click:Connect(function() picker:Destroy() end)
    end)

    return {SetValue = function(c) colorBtn.BackgroundColor3 = c end}
end

-- ==================== PREENCHER O MENU ====================

-- Seção Combate
AddSection("🎯 Mira Assistida")
AddToggle("Mira Assistida", false, function(v) cfg.MiraAtiva = v end)
AddSlider("Suavidade", 0.1, 1, 0.35, function(v) cfg.Smoothness = v end)
AddSlider("FOV", 100, 1000, 500, function(v) cfg.FovRadius = v end)

AddSection("🔫 TriggerBot")
AddToggle("TriggerBot", false, function(v) cfg.TriggerBot = v end)
AddSlider("Delay (ms)", 0, 500, 100, function(v) cfg.TriggerDelay = v end)

AddSection("🎯 Silent Aim")
AddToggle("Silent Aim", false, function(v) cfg.SilentAim = v end)
AddDropdown("Parte do Corpo", {"Cabeça", "Tórax", "Aleatório"}, "Cabeça", function(v) cfg.AimPart = v end)

AddSection("🔧 Anti-Recoil")
AddToggle("Anti-Recoil", false, function(v) cfg.AntiRecoil = v end)
AddSlider("Redução", 0.1, 1, 0.5, function(v) cfg.RecoilReduction = v end)

-- Visual
AddSection("👁️ Visual (ESP)")
AddToggle("Raio-X (Highlight)", false, function(v) cfg.HighlightEnabled = v end)
AddToggle("Ponto na Cabeça", false, function(v) cfg.DotEnabled = v end)
AddToggle("Micro-HUD Vida", false, function(v) cfg.MicroHpEnabled = v end)
AddToggle("Micro-HUD Distância", false, function(v) cfg.MicroDistEnabled = v end)
AddSlider("Texto Distância", 6, 24, 8, function(v) cfg.MicroTextSize = v end)
AddSlider("Largura Barra Vida", 20, 100, 35, function(v) cfg.MicroWidth = v end)

-- RX
AddSection("🛸 Opções RX")
AddDropdown("Modo Visibilidade", {"AlwaysOnTop", "Occluded"}, "AlwaysOnTop", function(v) cfg.HlDepthMode = v end)
AddSlider("Transparência Fill", 0, 1, 0.5, function(v) cfg.HlFillTransparency = v end)
AddColorPicker("Cor Inimigos", Color3.fromRGB(255,0,0), function(v) cfg.HlEnemyColor = v end)

-- Iluminação
AddSection("💡 Iluminação")
AddToggle("FullBright", false, function(v) cfg.FullBright = v end)
AddToggle("Clareza Aprimorada", false, function(v) cfg.ClarezaMod = v end)
AddToggle("Remover Sombras", false, function(v) game:GetService("Lighting").GlobalShadows = not v end)

-- Movimento
AddSection("🧱 Movimento")
AddToggle("Fly", false, function(v) _G.Warcore.ToggleFly(v) end)
AddToggle("Fly Infinito", false, function(v) cfg.FlyInfinite = v end)
AddSlider("Velocidade Fly", 1, 500, 50, function(v) cfg.FlySpeed = v end)

AddToggle("No-Clip", false, function(v) _G.Warcore.ToggleNoClip(v) end)

AddToggle("Speed Hack", false, function(v) _G.Warcore.ToggleSpeed(v) end)
AddSlider("Velocidade", 16, 200, 50, function(v) _G.Warcore.SetSpeedValue(v) end)

AddToggle("Super Pulo", false, function(v) _G.Warcore.ToggleJump(v) end)
AddSlider("Altura Pulo", 50, 300, 100, function(v) _G.Warcore.SetJumpPower(v) end)
AddToggle("Pulo Infinito", false, function(v) cfg.InfiniteJump = v end)

AddToggle("Escalar Paredes", false, function(v) cfg.WallClimb = v end)
AddSlider("Velocidade Escalada", 5, 50, 20, function(v) cfg.WallClimbSpeed = v end)

AddToggle("Auto-Sprint", false, function(v) cfg.AutoSprint = v end)

-- Navegação
AddSection("🗺️ Navegação")
AddToggle("Distância no HUD", false, function(v) cfg.ShowDistanceHUD = v end)
AddToggle("Seta Direcional", false, function(v) cfg.ShowDirectionArrow = v end)
AddToggle("Radar", false, function(v) cfg.RadarEnabled = v end)
AddSlider("Tamanho Radar", 80, 300, 150, function(v) cfg.RadarSize = v end)

-- Estilo
AddSection("🎨 Estilo")
AddToggle("Chams", false, function(v) cfg.ChamsEnabled = v end)
AddColorPicker("Cor Chams", Color3.fromRGB(0,255,0), function(v) cfg.ChamsColor = v end)
AddToggle("Modo Arco-Íris", false, function(v) cfg.ChamsRainbow = v end)
AddToggle("Modo Cinza", false, function(v) cfg.GrayMode = v end)

-- Utilidades
AddSection("🛡️ Utilidades")
AddToggle("Anti-AFK", false, function(v) cfg.AntiAFK = v end)
AddToggle("Auto-Collect", false, function(v) cfg.AutoCollect = v end)
AddSlider("Raio Coleta", 10, 100, 30, function(v) cfg.CollectRadius = v end)

-- Monitor
AddSection("📊 Monitor")
AddToggle("Mostrar FPS", false, function(v)
    cfg.ShowFPS = v
    if v then
        local tag = Instance.new("TextLabel", CoreGui)
        tag.Name = "WarcoreFPS"
        tag.Size = UDim2.new(0, 80, 0, 20)
        tag.Position = UDim2.new(0, 10, 0, 50)
        tag.BackgroundTransparency = 1
        tag.TextColor3 = Color3.fromRGB(0, 240, 255)
        tag.Font = Enum.Font.GothamBold
        tag.TextSize = 14
        tag.Text = "FPS: 0"
        _G.Warcore.FPSLabel = tag
    else
        local tag = CoreGui:FindFirstChild("WarcoreFPS")
        if tag then tag:Destroy() end
    end
end)
AddToggle("Mostrar Players", false, function(v)
    cfg.ShowPlayers = v
    if v then
        local tag = Instance.new("TextLabel", CoreGui)
        tag.Name = "WarcorePlayers"
        tag.Size = UDim2.new(0, 80, 0, 20)
        tag.Position = UDim2.new(0, 10, 0, 75)
        tag.BackgroundTransparency = 1
        tag.TextColor3 = Color3.fromRGB(255, 0, 120)
        tag.Font = Enum.Font.GothamBold
        tag.TextSize = 14
        tag.Text = "Players: 0"
        _G.Warcore.PlayersLabel = tag
    else
        local tag = CoreGui:FindFirstChild("WarcorePlayers")
        if tag then tag:Destroy() end
    end
end)

-- Atualiza labels de FPS/Players
RunService.RenderStepped:Connect(function()
    if cfg.ShowFPS and _G.Warcore.FPSLabel then
        _G.Warcore.FPSLabel.Text = "⚡ FPS: " .. (_G.Warcore.FPS or 0)
    end
    if cfg.ShowPlayers and _G.Warcore.PlayersLabel then
        _G.Warcore.PlayersLabel.Text = "👥 Players: " .. (_G.Warcore.PlayerCount or 0)
    end
end)

-- ==================== BOTÃO FLUTUANTE ====================

local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 56, 0, 56)
FloatBtn.Position = UDim2.new(0.85, 0, 0.85, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
FloatBtn.BackgroundTransparency = 0.1
FloatBtn.Text = "⚡"
FloatBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 28
FloatBtn.AutoButtonColor = false
FloatBtn.Visible = true
FloatBtn.ZIndex = 15
local floatCorner = Instance.new("UICorner", FloatBtn)
floatCorner.CornerRadius = UDim.new(0, 16)
local floatStroke = Instance.new("UIStroke", FloatBtn)
floatStroke.Thickness = 1.5
floatStroke.Color = Color3.fromRGB(0, 200, 255)
floatStroke.Transparency = 0.4

-- Drag do botão flutuante
local floatDrag = false
local floatStart = nil
local floatBtnStart = nil

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDrag = true
        floatStart = input.Position
        floatBtnStart = FloatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then floatDrag = false end
        end)
    end
end)

FloatBtn.InputChanged:Connect(function(input)
    if floatDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatStart
        FloatBtn.Position = UDim2.new(floatBtnStart.X.Scale, floatBtnStart.X.Offset + delta.X, floatBtnStart.Y.Scale, floatBtnStart.Y.Offset + delta.Y)
    end
end)

-- ==================== FUNÇÃO ABRIR/FECHAR ====================

function ToggleMenu(show)
    if show then
        MainFrame.Visible = true
        Background.Visible = true
        FloatBtn.Visible = false
        -- Animação suave (se TweenService estiver disponível)
        pcall(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 420, 0, 580),
                BackgroundTransparency = 0.1
            }):Play()
        end)
        -- Fallback se Tween falhar
        MainFrame.Size = UDim2.new(0, 420, 0, 580)
        MainFrame.BackgroundTransparency = 0.1
    else
        pcall(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 580),
                BackgroundTransparency = 1
            }):Play()
        end)
        MainFrame.Visible = false
        Background.Visible = false
        FloatBtn.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 580)
        MainFrame.BackgroundTransparency = 1
    end
end

-- ==================== EVENTOS DOS BOTÕES ====================

CloseBtn.MouseButton1Click:Connect(function()
    ToggleMenu(false)
end)

MinBtn.MouseButton1Click:Connect(function()
    ToggleMenu(false)
end)

FloatBtn.MouseButton1Click:Connect(function()
    ToggleMenu(true)
end)

-- ==================== DRAG DA JANELA ====================

local Dragging = false
local DragStart = nil
local FrameStart = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        FrameStart = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(FrameStart.X.Scale, FrameStart.X.Offset + delta.X, FrameStart.Y.Scale, FrameStart.Y.Offset + delta.Y)
    end
end)

-- ==================== ABRIR MENU AUTOMATICAMENTE ====================

task.wait(1) -- dá tempo para o core carregar
ToggleMenu(true)

print("[WARCORE] UI carregada e menu aberto!")