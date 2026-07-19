-- ui.lua
-- Interface visual completa sem Rayfield

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Verifica se o core foi carregado
if not _G.Warcore then
    error("[WARCORE] Core não encontrado! Carregue o core.lua primeiro.")
end

local cfg = _G.Warcore.Config

-- ==================== CRIAR GUI PRINCIPAL ====================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "WarcoreUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fundo escuro (quando o menu está aberto, opcional)
local Background = Instance.new("Frame", ScreenGui)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.7
Background.Visible = false
Background.ZIndex = 0

-- Janela principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 580)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.ClipsDescendants = true

-- Bordas arredondadas
local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 16)

-- Sombra (stroke)
local Shadow = Instance.new("UIStroke", MainFrame)
Shadow.Thickness = 6
Shadow.Color = Color3.fromRGB(0, 0, 0)
Shadow.Transparency = 0.6

local Border = Instance.new("UIStroke", MainFrame)
Border.Thickness = 1.5
Border.Color = Color3.fromRGB(0, 200, 255)
Border.Transparency = 0.3

-- ==================== BARRA DE TÍTULO ====================

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 28, 42)
TitleBar.BorderSizePixel = 0
local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 16)

-- Título
local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👑 WARCORE ULTIMATE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Fechar (X)
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -44, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.ZIndex = 11

CloseBtn.MouseButton1Click:Connect(function()
    ToggleMenu(false)
end)

-- Botão Minimizar (opcional)
local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(1, -88, 0, 2)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 22
MinBtn.ZIndex = 11
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Background.Visible = false
    -- Mostrar botão flutuante para reabrir
    FloatBtn.Visible = true
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
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(FrameStart.X.Scale, FrameStart.X.Offset + delta.X, FrameStart.Y.Scale, FrameStart.Y.Offset + delta.Y)
    end
end)

-- ==================== SISTEMA DE ABAS ====================

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, 0, 0, 44)
TabContainer.Position = UDim2.new(0, 0, 0, 44)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
TabContainer.BorderSizePixel = 0
TabContainer.ClipsDescendants = true

local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 2)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Lista de abas
local tabs = {}
local currentTab = nil

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0, 70, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    btn.ZIndex = 12

    -- Estado
    local active = false

    -- Conteúdo da aba (será preenchido depois)
    local content = Instance.new("ScrollingFrame", MainFrame)
    content.Size = UDim2.new(1, -12, 1, -100)
    content.Position = UDim2.new(0, 6, 0, 94)
    content.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
    content.BackgroundTransparency = 0.3
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    content.Visible = false
    content.ZIndex = 12
    local contentCorner = Instance.new("UICorner", content)
    contentCorner.CornerRadius = UDim.new(0, 8)

    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Função para mostrar esta aba
    local function show()
        if currentTab then
            currentTab.content.Visible = false
            currentTab.btn.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
            currentTab.btn.BackgroundTransparency = 0.3
            currentTab.btn.TextColor3 = Color3.fromRGB(180, 190, 210)
        end
        active = true
        content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        btn.BackgroundTransparency = 0.1
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = {btn = btn, content = content}
        -- Atualiza tamanho do canvas
        content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end

    btn.MouseButton1Click:Connect(show)

    -- Salvar referência
    table.insert(tabs, {btn = btn, content = content, show = show, name = name})

    return {
        btn = btn,
        content = content,
        layout = contentLayout,
        show = show,
        AddSection = function(title)
            local section = Instance.new("Frame", content)
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
        end,
        AddToggle = function(labelText, defaultValue, callback)
            local frame = Instance.new("Frame", content)
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
        end,
        AddSlider = function(labelText, min, max, default, callback)
            local frame = Instance.new("Frame", content)
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
        end,
        AddDropdown = function(labelText, options, default, callback)
            local frame = Instance.new("Frame", content)
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
        end,
        AddColorPicker = function(labelText, defaultColor, callback)
            local frame = Instance.new("Frame", content)
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

            -- Simples seletor de cores (abre um painel com botões)
            colorBtn.MouseButton1Click:Connect(function()
                -- Cria um painel simples com cores pré-definidas
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
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(255, 165, 0),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 200, 255),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(200, 0, 255),
                    Color3.fromRGB(255, 0, 200),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(100, 100, 100),
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
                -- Botão fechar
                local closePicker = Instance.new("TextButton", picker)
                closePicker.Size = UDim2.new(0, 30, 0, 30)
                closePicker.Position = UDim2.new(1, -36, 0, 4)
                closePicker.BackgroundTransparency = 1
                closePicker.Text = "✕"
                closePicker.TextColor3 = Color3.fromRGB(255, 200, 200)
                closePicker.Font = Enum.Font.GothamBold
                closePicker.TextSize = 16
                closePicker.ZIndex = 21
                closePicker.MouseButton1Click:Connect(function()
                    picker:Destroy()
                end)
            end)

            return {SetValue = function(c) colorBtn.BackgroundColor3 = c end}
        end
    }
end

-- ==================== CRIAR ABAS ====================

local tabDefs = {
    {icon = "🔫", name = "Combate"},
    {icon = "👁️", name = "Visual"},
    {icon = "🛸", name = "RX"},
    {icon = "💡", name = "Luz"},
    {icon = "🧱", name = "Movimento"},
    {icon = "🗺️", name = "Navegação"},
    {icon = "🎨", name = "Estilo"},
    {icon = "🛡️", name = "Utilidades"},
    {icon = "📊", name = "Monitor"},
}

local tabObjects = {}
for _, def in ipairs(tabDefs) do
    local tab = CreateTab(def.name, def.icon)
    tabObjects[def.name] = tab
end

-- ==================== PREENCHER ABAS ====================

-- Aba Combate
local combate = tabObjects["Combate"]
combate:AddSection("🎯 Mira Assistida")
combate:AddToggle("Mira Assistida", false, function(v) cfg.MiraAtiva = v end)
combate:AddSlider("Suavidade", 0.1, 1, 0.35, function(v) cfg.Smoothness = v end)
combate:AddSlider("FOV", 100, 1000, 500, function(v) cfg.FovRadius = v end)

combate:AddSection("🔫 TriggerBot")
combate:AddToggle("TriggerBot", false, function(v) cfg.TriggerBot = v end)
combate:AddSlider("Delay (ms)", 0, 500, 100, function(v) cfg.TriggerDelay = v end)

combate:AddSection("🎯 Silent Aim")
combate:AddToggle("Silent Aim", false, function(v) cfg.SilentAim = v end)
combate:AddDropdown("Parte do Corpo", {"Cabeça", "Tórax", "Aleatório"}, "Cabeça", function(v) cfg.AimPart = v end)

combate:AddSection("🔧 Anti-Recoil")
combate:AddToggle("Anti-Recoil", false, function(v) cfg.AntiRecoil = v end)
combate:AddSlider("Redução", 0.1, 1, 0.5, function(v) cfg.RecoilReduction = v end)

-- Aba Visual
local visual = tabObjects["Visual"]
visual:AddSection("ESP")
visual:AddToggle("Raio-X (Highlight)", false, function(v) cfg.HighlightEnabled = v end)
visual:AddToggle("Ponto na Cabeça", false, function(v) cfg.DotEnabled = v end)
visual:AddToggle("Micro-HUD Vida", false, function(v) cfg.MicroHpEnabled = v end)
visual:AddToggle("Micro-HUD Distância", false, function(v) cfg.MicroDistEnabled = v end)
visual:AddSection("Tamanhos")
visual:AddSlider("Texto Distância", 6, 24, 8, function(v) cfg.MicroTextSize = v end)
visual:AddSlider("Largura Barra Vida", 20, 100, 35, function(v) cfg.MicroWidth = v end)

-- Aba RX
local rx = tabObjects["RX"]
rx:AddSection("Configurações Avançadas")
rx:AddDropdown("Modo Visibilidade", {"AlwaysOnTop", "Occluded"}, "AlwaysOnTop", function(v) cfg.HlDepthMode = v end)
rx:AddSlider("Transparência Fill", 0, 1, 0.5, function(v) cfg.HlFillTransparency = v end)
rx:AddColorPicker("Cor Inimigos", Color3.fromRGB(255,0,0), function(v) cfg.HlEnemyColor = v end)

-- Aba Luz
local luz = tabObjects["Luz"]
luz:AddToggle("FullBright", false, function(v) cfg.FullBright = v end)
luz:AddToggle("Clareza Aprimorada", false, function(v) cfg.ClarezaMod = v end)
luz:AddToggle("Remover Sombras", false, function(v) game:GetService("Lighting").GlobalShadows = not v end)

-- Aba Movimento
local mov = tabObjects["Movimento"]
mov:AddSection("🕊️ Fly")
mov:AddToggle("Fly", false, function(v) _G.Warcore.ToggleFly(v) end)
mov:AddToggle("Modo Infinito", false, function(v) cfg.FlyInfinite = v end)
mov:AddSlider("Velocidade Fly", 1, 500, 50, function(v) cfg.FlySpeed = v end)

mov:AddSection("🧱 No-Clip")
mov:AddToggle("No-Clip", false, function(v) _G.Warcore.ToggleNoClip(v) end)

mov:AddSection("⚡ Speed")
mov:AddToggle("Speed Hack", false, function(v) _G.Warcore.ToggleSpeed(v) end)
mov:AddSlider("Velocidade", 16, 200, 50, function(v) _G.Warcore.SetSpeedValue(v) end)

mov:AddSection("🦘 Pulo")
mov:AddToggle("Super Pulo", false, function(v) _G.Warcore.ToggleJump(v) end)
mov:AddSlider("Altura", 50, 300, 100, function(v) _G.Warcore.SetJumpPower(v) end)
mov:AddToggle("Pulo Infinito", false, function(v) cfg.InfiniteJump = v end)

mov:AddSection("🧗 Wall-Climb")
mov:AddToggle("Escalar Paredes", false, function(v) cfg.WallClimb = v end)
mov:AddSlider("Velocidade Escalada", 5, 50, 20, function(v) cfg.WallClimbSpeed = v end)

mov:AddSection("🏃 Auto-Sprint")
mov:AddToggle("Auto-Sprint", false, function(v) cfg.AutoSprint = v end)

-- Aba Navegação
local nav = tabObjects["Navegação"]
nav:AddSection("📍 Indicadores")
nav:AddToggle("Distância no HUD", false, function(v) cfg.ShowDistanceHUD = v end)
nav:AddToggle("Seta Direcional", false, function(v) cfg.ShowDirectionArrow = v end)
nav:AddSection("🗺️ Radar")
nav:AddToggle("Radar", false, function(v) cfg.RadarEnabled = v end)
nav:AddSlider("Tamanho Radar", 80, 300, 150, function(v) cfg.RadarSize = v end)

-- Aba Estilo
local estilo = tabObjects["Estilo"]
estilo:AddSection("🌈 Chams")
estilo:AddToggle("Chams", false, function(v) cfg.ChamsEnabled = v end)
estilo:AddColorPicker("Cor Chams", Color3.fromRGB(0,255,0), function(v) cfg.ChamsColor = v end)
estilo:AddToggle("Modo Arco-Íris", false, function(v) cfg.ChamsRainbow = v end)
estilo:AddSection("🎨 Modo Cinza")
estilo:AddToggle("Modo Cinza", false, function(v) cfg.GrayMode = v end)

-- Aba Utilidades
local util = tabObjects["Utilidades"]
util:AddSection("🛡️ Anti-AFK")
util:AddToggle("Anti-AFK", false, function(v) cfg.AntiAFK = v end)
util:AddSection("📦 Auto-Collect")
util:AddToggle("Auto-Collect", false, function(v) cfg.AutoCollect = v end)
util:AddSlider("Raio Coleta", 10, 100, 30, function(v) cfg.CollectRadius = v end)

-- Aba Monitor
local monitor = tabObjects["Monitor"]
monitor:AddSection("📊 Monitor")
monitor:AddToggle("Mostrar FPS", false, function(v)
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
monitor:AddToggle("Mostrar Players", false, function(v)
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

-- ==================== BOTÃO FLUTUANTE PARA ABRIR MENU ====================

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

FloatBtn.MouseButton1Click:Connect(function()
    ToggleMenu(true)
end)

-- ==================== FUNÇÃO PARA ABRIR/FECHAR MENU ====================

function ToggleMenu(show)
    if show then
        MainFrame.Visible = true
        Background.Visible = true
        FloatBtn.Visible = false
        -- Mostra a primeira aba
        if tabs and #tabs > 0 then
            tabs[1].show()
        end
        -- Animação de entrada
        MainFrame.Size = UDim2.new(0, 0, 0, 580)
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 420, 0, 580),
            BackgroundTransparency = 0.1
        }):Play()
    else
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 580),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            MainFrame.Visible = false
            Background.Visible = false
            FloatBtn.Visible = true
        end)
    end
end

-- ==================== INICIALIZAR ====================

-- Abre o menu automaticamente ao carregar
task.wait(0.5)
ToggleMenu(true)

print("[WARCORE] UI carregada com sucesso!")