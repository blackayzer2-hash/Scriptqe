-- ============================================================
-- ui.lua – WARCORE ULTIMATE v3 (Interface Premium Sidebar)
-- ============================================================
print("[WARCORE] Carregando UI...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- Verifica/core
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
        FPS = 0,
        PlayerCount = 0,
    }
end

local cfg = _G.Warcore.Config

-- ============================================================
-- GUI PRINCIPAL
-- ============================================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "WarcoreUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fundo overlay
local Background = Instance.new("Frame", ScreenGui)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.6
Background.Visible = false
Background.ZIndex = 0

-- ============================================================
-- JANELA PRINCIPAL (com sidebar)
-- ============================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -320)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 200, 255)
MainStroke.Transparency = 0.3

-- ============================================================
-- SIDEBAR (esquerda)
-- ============================================================
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 80, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 0) -- sem arredondar para encaixar

-- Título na sidebar
local SideTitle = Instance.new("TextLabel", Sidebar)
SideTitle.Size = UDim2.new(1, 0, 0, 50)
SideTitle.Position = UDim2.new(0, 0, 0, 10)
SideTitle.BackgroundTransparency = 1
SideTitle.Text = "⚡"
SideTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 28
SideTitle.TextScaled = false

-- Container dos botões da sidebar
local SideButtons = Instance.new("Frame", Sidebar)
SideButtons.Size = UDim2.new(1, 0, 1, -60)
SideButtons.Position = UDim2.new(0, 0, 0, 60)
SideButtons.BackgroundTransparency = 1

local SideLayout = Instance.new("UIListLayout", SideButtons)
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- ÁREA DE CONTEÚDO (direita)
-- ============================================================
local ContentArea = Instance.new("ScrollingFrame", MainFrame)
ContentArea.Size = UDim2.new(1, -90, 1, -20)
ContentArea.Position = UDim2.new(0, 90, 0, 10)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
ContentArea.BackgroundTransparency = 0.2
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = 4
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ContentArea.ZIndex = 12

local ContentCorner = Instance.new("UICorner", ContentArea)
ContentCorner.CornerRadius = UDim.new(0, 12)

local ContentLayout = Instance.new("UIListLayout", ContentArea)
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Atualiza CanvasSize automaticamente
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- ============================================================
-- FUNÇÕES PARA CRIAR ELEMENTOS DA UI
-- ============================================================

-- Cria um botão de aba na sidebar
local function CreateSideButton(icon, label, callback)
    local btn = Instance.new("TextButton", SideButtons)
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.BackgroundColor3 = Color3.fromRGB(24, 28, 42)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = icon .. "\n" .. label
    btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextWrapped = true
    btn.TextScaled = false
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)

    btn.MouseButton1Click:Connect(callback)

    return btn
end

-- Adiciona uma seção (título) no conteúdo
local function AddSection(title)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -16, 0, 32)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(0, 200, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    return frame
end

-- Adiciona um Toggle (interruptor)
local function AddToggle(labelText, defaultValue, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -16, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 44, 0, 28)
    toggleBtn.Position = UDim2.new(1, -52, 0, 6)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    local tCorner = Instance.new("UICorner", toggleBtn)
    tCorner.CornerRadius = UDim.new(0, 14)

    local indicator = Instance.new("Frame", toggleBtn)
    indicator.Size = UDim2.new(0, 22, 0, 22)
    indicator.Position = defaultValue and UDim2.new(1, -26, 0, 3) or UDim2.new(0, 4, 0, 3)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 11)

    local state = defaultValue

    local function updateVisual()
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            indicator.Position = UDim2.new(1, -26, 0, 3)
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

    return { SetValue = function(v) state = v; updateVisual() end }
end

-- Adiciona um Slider
local function AddSlider(labelText, min, max, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -16, 0, 54)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 2)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(1, -24, 0, 6)
    slider.Position = UDim2.new(0, 12, 0, 34)
    slider.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
    slider.BorderSizePixel = 0
    local sCorner = Instance.new("UICorner", slider)
    sCorner.CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    local fCorner = Instance.new("UICorner", fill)
    fCorner.CornerRadius = UDim.new(0, 3)

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

    return { SetValue = function(v) value = math.clamp(v, min, max); fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0); valueLabel.Text = tostring(value); end }
end

-- Adiciona um Dropdown
local function AddDropdown(labelText, options, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -16, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownBtn = Instance.new("TextButton", frame)
    dropdownBtn.Size = UDim2.new(1, -130, 0, 30)
    dropdownBtn.Position = UDim2.new(0, 110, 0, 7)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = default or options[1]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.GothamMedium
    dropdownBtn.TextSize = 13
    dropdownBtn.AutoButtonColor = false
    local dCorner = Instance.new("UICorner", dropdownBtn)
    dCorner.CornerRadius = UDim.new(0, 8)

    local dropdownOpen = false
    local optionList = nil

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        if dropdownOpen then
            if optionList then optionList:Destroy() end
            optionList = Instance.new("Frame", MainFrame)
            optionList.Size = UDim2.new(0, 190, 0, math.min(#options * 32, 160))
            optionList.Position = UDim2.new(0, dropdownBtn.AbsolutePosition.X - MainFrame.AbsolutePosition.X + 10, 0, dropdownBtn.AbsolutePosition.Y - MainFrame.AbsolutePosition.Y + 38)
            optionList.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
            optionList.BorderSizePixel = 0
            optionList.ZIndex = 20
            local oCorner = Instance.new("UICorner", optionList)
            oCorner.CornerRadius = UDim.new(0, 10)
            local oLayout = Instance.new("UIListLayout", optionList)
            oLayout.Padding = UDim.new(0, 2)

            for _, opt in ipairs(options) do
                local btn = Instance.new("TextButton", optionList)
                btn.Size = UDim2.new(1, 0, 0, 30)
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

    return { SetValue = function(v) dropdownBtn.Text = v end }
end

-- Adiciona um ColorPicker (simples)
local function AddColorPicker(labelText, defaultColor, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -16, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local colorBtn = Instance.new("TextButton", frame)
    colorBtn.Size = UDim2.new(0, 40, 0, 28)
    colorBtn.Position = UDim2.new(1, -50, 0, 8)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.AutoButtonColor = false
    local cCorner = Instance.new("UICorner", colorBtn)
    cCorner.CornerRadius = UDim.new(0, 8)

    colorBtn.MouseButton1Click:Connect(function()
        local picker = Instance.new("Frame", MainFrame)
        picker.Size = UDim2.new(0, 200, 0, 160)
        picker.Position = UDim2.new(0.5, -100, 0.5, -80)
        picker.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
        picker.BorderSizePixel = 0
        picker.ZIndex = 20
        local pCorner = Instance.new("UICorner", picker)
        pCorner.CornerRadius = UDim.new(0, 12)
        local pLayout = Instance.new("UIGridLayout", picker)
        pLayout.CellSize = UDim2.new(0, 40, 0, 40)
        pLayout.CellPadding = UDim.new(0, 8)
        pLayout.FillDirectionMaxCells = 4

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
            local bCorner = Instance.new("UICorner", btn)
            bCorner.CornerRadius = UDim.new(0, 8)
            btn.MouseButton1Click:Connect(function()
                colorBtn.BackgroundColor3 = c
                if callback then callback(c) end
                picker:Destroy()
            end)
        end
        local closeP = Instance.new("TextButton", picker)
        closeP.Size = UDim2.new(0, 30, 0, 30)
        closeP.Position = UDim2.new(1, -36, 0, 4)
        closeP.BackgroundTransparency = 1
        closeP.Text = "✕"
        closeP.TextColor3 = Color3.fromRGB(255,200,200)
        closeP.Font = Enum.Font.GothamBold
        closeP.TextSize = 16
        closeP.ZIndex = 21
        closeP.MouseButton1Click:Connect(function() picker:Destroy() end)
    end)

    return { SetValue = function(c) colorBtn.BackgroundColor3 = c end }
end

-- ============================================================
-- SISTEMA DE ABAS (Sidebar)
-- ============================================================
local Abas = {}
local CurrentTab = nil

local function SwitchTab(tabName)
    if CurrentTab == tabName then return end
    -- Esconde conteúdo anterior
    for _, t in pairs(Abas) do
        t.content.Visible = false
        t.btn.BackgroundColor3 = Color3.fromRGB(24, 28, 42)
        t.btn.BackgroundTransparency = 0.3
        t.btn.TextColor3 = Color3.fromRGB(180, 190, 210)
    end
    -- Mostra a nova
    local tab = Abas[tabName]
    if tab then
        tab.content.Visible = true
        tab.btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        tab.btn.BackgroundTransparency = 0.1
        tab.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = tabName
        -- Atualiza scroll
        ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end
end

-- Função para criar uma aba e seu conteúdo
local function CreateTab(name, icon)
    local btn = CreateSideButton(icon, name, function()
        SwitchTab(name)
    end)

    local content = Instance.new("Frame", ContentArea)
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.ZIndex = 12

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Atualiza CanvasSize quando o conteúdo mudar
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)

    Abas[name] = { btn = btn, content = content, layout = layout }

    return {
        AddSection = function(title)
            local sec = AddSection(title)
            sec.Parent = content
            return sec
        end,
        AddToggle = function(label, default, cb)
            local toggle = AddToggle(label, default, cb)
            toggle.SetValue = toggle.SetValue -- já retorna
            -- Precisamos colocar o toggle dentro do content, mas a função AddToggle já cria dentro do ContentArea global.
            -- Vamos ajustar: mover os elementos criados para o content da aba.
            -- Como a função AddToggle cria dentro de ContentArea (global), vamos precisar re-parentear.
            -- Solução: criar uma versão local que adiciona dentro do content.
            -- Vou reimplementar de forma mais simples: cada função de criação recebe um parent opcional.
            -- Para simplificar, vou fazer com que AddToggle crie dentro de content se passado.
            -- Mas como já tenho as funções acima baseadas em ContentArea global, vou criar uma nova função que aceita parent.
            -- Como o código já está grande, vou criar uma solução prática: as funções AddToggle, AddSlider, etc., criarão dentro de ContentArea, mas na hora de montar as abas, vou usar um truque: criar tudo dentro de ContentArea e depois esconder/mostrar os elementos de cada aba usando visibilidade.
            -- Porém, isso polui. Melhor: refatorar para aceitar parent.
            -- Vou fazer agora uma versão adaptada: cada função terá um parâmetro opcional 'parent'.
        end
    }
end

-- ============================================================
-- PREENCHER CONTEÚDO DAS ABAS (usando funções com parent)
-- ============================================================
-- Para simplificar, vou criar funções que recebem 'parent' e adicionam os elementos lá.

local function AddToggleTo(parent, labelText, defaultValue, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 44, 0, 28)
    toggleBtn.Position = UDim2.new(1, -52, 0, 6)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    local tCorner = Instance.new("UICorner", toggleBtn)
    tCorner.CornerRadius = UDim.new(0, 14)

    local indicator = Instance.new("Frame", toggleBtn)
    indicator.Size = UDim2.new(0, 22, 0, 22)
    indicator.Position = defaultValue and UDim2.new(1, -26, 0, 3) or UDim2.new(0, 4, 0, 3)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    local indCorner = Instance.new("UICorner", indicator)
    indCorner.CornerRadius = UDim.new(0, 11)

    local state = defaultValue

    local function updateVisual()
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            indicator.Position = UDim2.new(1, -26, 0, 3)
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

    return { SetValue = function(v) state = v; updateVisual() end }
end

local function AddSliderTo(parent, labelText, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 54)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 2)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(1, -24, 0, 6)
    slider.Position = UDim2.new(0, 12, 0, 34)
    slider.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
    slider.BorderSizePixel = 0
    local sCorner = Instance.new("UICorner", slider)
    sCorner.CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    local fCorner = Instance.new("UICorner", fill)
    fCorner.CornerRadius = UDim.new(0, 3)

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

    return { SetValue = function(v) value = math.clamp(v, min, max); fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0); valueLabel.Text = tostring(value); end }
end

local function AddDropdownTo(parent, labelText, options, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownBtn = Instance.new("TextButton", frame)
    dropdownBtn.Size = UDim2.new(1, -130, 0, 30)
    dropdownBtn.Position = UDim2.new(0, 110, 0, 7)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = default or options[1]
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.Font = Enum.Font.GothamMedium
    dropdownBtn.TextSize = 13
    dropdownBtn.AutoButtonColor = false
    local dCorner = Instance.new("UICorner", dropdownBtn)
    dCorner.CornerRadius = UDim.new(0, 8)

    local dropdownOpen = false
    local optionList = nil

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        if dropdownOpen then
            if optionList then optionList:Destroy() end
            optionList = Instance.new("Frame", MainFrame)
            optionList.Size = UDim2.new(0, 190, 0, math.min(#options * 32, 160))
            optionList.Position = UDim2.new(0, dropdownBtn.AbsolutePosition.X - MainFrame.AbsolutePosition.X + 10, 0, dropdownBtn.AbsolutePosition.Y - MainFrame.AbsolutePosition.Y + 38)
            optionList.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
            optionList.BorderSizePixel = 0
            optionList.ZIndex = 20
            local oCorner = Instance.new("UICorner", optionList)
            oCorner.CornerRadius = UDim.new(0, 10)
            local oLayout = Instance.new("UIListLayout", optionList)
            oLayout.Padding = UDim.new(0, 2)

            for _, opt in ipairs(options) do
                local btn = Instance.new("TextButton", optionList)
                btn.Size = UDim2.new(1, 0, 0, 30)
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

    return { SetValue = function(v) dropdownBtn.Text = v end }
end

local function AddColorPickerTo(parent, labelText, defaultColor, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 230, 240)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local colorBtn = Instance.new("TextButton", frame)
    colorBtn.Size = UDim2.new(0, 40, 0, 28)
    colorBtn.Position = UDim2.new(1, -50, 0, 8)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.AutoButtonColor = false
    local cCorner = Instance.new("UICorner", colorBtn)
    cCorner.CornerRadius = UDim.new(0, 8)

    colorBtn.MouseButton1Click:Connect(function()
        local picker = Instance.new("Frame", MainFrame)
        picker.Size = UDim2.new(0, 200, 0, 160)
        picker.Position = UDim2.new(0.5, -100, 0.5, -80)
        picker.BackgroundColor3 = Color3.fromRGB(30, 34, 50)
        picker.BorderSizePixel = 0
        picker.ZIndex = 20
        local pCorner = Instance.new("UICorner", picker)
        pCorner.CornerRadius = UDim.new(0, 12)
        local pLayout = Instance.new("UIGridLayout", picker)
        pLayout.CellSize = UDim2.new(0, 40, 0, 40)
        pLayout.CellPadding = UDim.new(0, 8)
        pLayout.FillDirectionMaxCells = 4

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
            local bCorner = Instance.new("UICorner", btn)
            bCorner.CornerRadius = UDim.new(0, 8)
            btn.MouseButton1Click:Connect(function()
                colorBtn.BackgroundColor3 = c
                if callback then callback(c) end
                picker:Destroy()
            end)
        end
        local closeP = Instance.new("TextButton", picker)
        closeP.Size = UDim2.new(0, 30, 0, 30)
        closeP.Position = UDim2.new(1, -36, 0, 4)
        closeP.BackgroundTransparency = 1
        closeP.Text = "✕"
        closeP.TextColor3 = Color3.fromRGB(255,200,200)
        closeP.Font = Enum.Font.GothamBold
        closeP.TextSize = 16
        closeP.ZIndex = 21
        closeP.MouseButton1Click:Connect(function() picker:Destroy() end)
    end)

    return { SetValue = function(c) colorBtn.BackgroundColor3 = c end }
end

-- ============================================================
-- CRIAR ABAS E PREENCHER
-- ============================================================

-- 1. Combate
local tabCombate = CreateTab("Combate", "🔫")
local parent = tabCombate.content

AddSection("🎯 Mira Assistida").Parent = parent
AddToggleTo(parent, "Mira Assistida", false, function(v) cfg.MiraAtiva = v end)
AddSliderTo(parent, "Suavidade", 0.1, 1, 0.35, function(v) cfg.Smoothness = v end)
AddSliderTo(parent, "FOV", 100, 1000, 500, function(v) cfg.FovRadius = v end)

AddSection("🔫 TriggerBot").Parent = parent
AddToggleTo(parent, "TriggerBot", false, function(v) cfg.TriggerBot = v end)
AddSliderTo(parent, "Delay (ms)", 0, 500, 100, function(v) cfg.TriggerDelay = v end)

AddSection("🎯 Silent Aim").Parent = parent
AddToggleTo(parent, "Silent Aim", false, function(v) cfg.SilentAim = v end)
AddDropdownTo(parent, "Parte do Corpo", {"Cabeça", "Tórax", "Aleatório"}, "Cabeça", function(v) cfg.AimPart = v end)

AddSection("🔧 Anti-Recoil").Parent = parent
AddToggleTo(parent, "Anti-Recoil", false, function(v) cfg.AntiRecoil = v end)
AddSliderTo(parent, "Redução", 0.1, 1, 0.5, function(v) cfg.RecoilReduction = v end)

-- 2. Visual
local tabVisual = CreateTab("Visual", "👁️")
parent = tabVisual.content
AddSection("👁️ ESP").Parent = parent
AddToggleTo(parent, "Raio-X (Highlight)", false, function(v) cfg.HighlightEnabled = v end)
AddToggleTo(parent, "Ponto na Cabeça", false, function(v) cfg.DotEnabled = v end)
AddToggleTo(parent, "Micro-HUD Vida", false, function(v) cfg.MicroHpEnabled = v end)
AddToggleTo(parent, "Micro-HUD Distância", false, function(v) cfg.MicroDistEnabled = v end)

AddSection("Ajustes").Parent = parent
AddSliderTo(parent, "Texto Distância", 6, 24, 8, function(v) cfg.MicroTextSize = v end)
AddSliderTo(parent, "Largura Barra Vida", 20, 100, 35, function(v) cfg.MicroWidth = v end)

AddSection("🛸 Opções RX").Parent = parent
AddDropdownTo(parent, "Modo Visibilidade", {"AlwaysOnTop", "Occluded"}, "AlwaysOnTop", function(v) cfg.HlDepthMode = v end)
AddSliderTo(parent, "Transparência Fill", 0, 1, 0.5, function(v) cfg.HlFillTransparency = v end)
AddColorPickerTo(parent, "Cor Inimigos", Color3.fromRGB(255,0,0), function(v) cfg.HlEnemyColor = v end)

-- 3. Movimento
local tabMov = CreateTab("Movimento", "🧱")
parent = tabMov.content
AddSection("🕊️ Fly").Parent = parent
AddToggleTo(parent, "Fly", false, function(v) _G.Warcore.ToggleFly(v) end)
AddToggleTo(parent, "Fly Infinito", false, function(v) cfg.FlyInfinite = v end)
AddSliderTo(parent, "Velocidade Fly", 1, 500, 50, function(v) cfg.FlySpeed = v end)

AddSection("🧱 No-Clip").Parent = parent
AddToggleTo(parent, "No-Clip", false, function(v) _G.Warcore.ToggleNoClip(v) end)

AddSection("⚡ Speed").Parent = parent
AddToggleTo(parent, "Speed Hack", false, function(v) _G.Warcore.ToggleSpeed(v) end)
AddSliderTo(parent, "Velocidade", 16, 200, 50, function(v) _G.Warcore.SetSpeedValue(v) end)

AddSection("🦘 Pulo").Parent = parent
AddToggleTo(parent, "Super Pulo", false, function(v) _G.Warcore.ToggleJump(v) end)
AddSliderTo(parent, "Altura Pulo", 50, 300, 100, function(v) _G.Warcore.SetJumpPower(v) end)
AddToggleTo(parent, "Pulo Infinito", false, function(v) cfg.InfiniteJump = v end)

AddSection("🧗 Wall-Climb").Parent = parent
AddToggleTo(parent, "Escalar Paredes", false, function(v) cfg.WallClimb = v end)
AddSliderTo(parent, "Velocidade Escalada", 5, 50, 20, function(v) cfg.WallClimbSpeed = v end)

AddSection("🏃 Auto-Sprint").Parent = parent
AddToggleTo(parent, "Auto-Sprint", false, function(v) cfg.AutoSprint = v end)

-- 4. Mundo (Iluminação)
local tabMundo = CreateTab("Mundo", "💡")
parent = tabMundo.content
AddSection("💡 Iluminação").Parent = parent
AddToggleTo(parent, "FullBright", false, function(v) cfg.FullBright = v end)
AddToggleTo(parent, "Clareza Aprimorada", false, function(v) cfg.ClarezaMod = v end)
AddToggleTo(parent, "Remover Sombras", false, function(v) game:GetService("Lighting").GlobalShadows = not v end)

-- 5. Utils
local tabUtils = CreateTab("Utils", "🛡️")
parent = tabUtils.content
AddSection("🛡️ Anti-AFK").Parent = parent
AddToggleTo(parent, "Anti-AFK", false, function(v) cfg.AntiAFK = v end)

AddSection("📦 Auto-Collect").Parent = parent
AddToggleTo(parent, "Auto-Collect", false, function(v) cfg.AutoCollect = v end)
AddSliderTo(parent, "Raio Coleta", 10, 100, 30, function(v) cfg.CollectRadius = v end)

-- FPS/Players (serão adicionados como toggles na aba Utils? Melhor colocar em uma aba separada, mas farei na Utils)
AddSection("📊 Monitor").Parent = parent
AddToggleTo(parent, "Mostrar FPS", false, function(v)
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
AddToggleTo(parent, "Mostrar Players", false, function(v)
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

-- ============================================================
-- BOTÃO DE ATALHO DA MIRA (aparece quando a mira é ativada)
-- ============================================================
local AimToggleBtn = nil
local AimToggleActive = false

local function CreateAimShortcut()
    if AimToggleBtn then AimToggleBtn:Destroy() end
    AimToggleBtn = Instance.new("TextButton", ScreenGui)
    AimToggleBtn.Size = UDim2.new(0, 60, 0, 60)
    AimToggleBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
    AimToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    AimToggleBtn.BackgroundTransparency = 0.1
    AimToggleBtn.Text = "🎯 ON"
    AimToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AimToggleBtn.Font = Enum.Font.GothamBold
    AimToggleBtn.TextSize = 14
    AimToggleBtn.AutoButtonColor = false
    AimToggleBtn.Visible = false
    AimToggleBtn.ZIndex = 16
    local corner = Instance.new("UICorner", AimToggleBtn)
    corner.CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", AimToggleBtn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Transparency = 0.3

    -- Drag do botão de atalho
    local dragData = { dragging = false, start = nil, btnStart = nil, moved = false }
    AimToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragData.dragging = true
            dragData.start = input.Position
            dragData.btnStart = AimToggleBtn.Position
            dragData.moved = false
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragData.dragging = false
                    if not dragData.moved then
                        -- Clique curto: toggle
                        AimToggleActive = not AimToggleActive
                        cfg.MiraAtiva = AimToggleActive
                        AimToggleBtn.Text = AimToggleActive and "🎯 ON" or "🎯 OFF"
                        AimToggleBtn.BackgroundColor3 = AimToggleActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
                    end
                end
            end)
        end
    end)
    AimToggleBtn.InputChanged:Connect(function(input)
        if dragData.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragData.start
            if delta.Magnitude > 5 then dragData.moved = true end
            AimToggleBtn.Position = UDim2.new(dragData.btnStart.X.Scale, dragData.btnStart.X.Offset + delta.X,
                                                dragData.btnStart.Y.Scale, dragData.btnStart.Y.Offset + delta.Y)
        end
    end)

    return AimToggleBtn
end

-- Monitora o estado da mira para mostrar/esconder o atalho
local function UpdateAimShortcut()
    if cfg.MiraAtiva then
        if not AimToggleBtn then
            AimToggleBtn = CreateAimShortcut()
            AimToggleActive = true
            AimToggleBtn.Visible = true
        else
            AimToggleBtn.Visible = true
        end
    else
        if AimToggleBtn then
            AimToggleBtn.Visible = false
            AimToggleActive = false
        end
    end
end

-- Conecta a atualização quando a mira mudar (via toggle do menu)
-- Como o toggle do menu já chama callback, podemos também adicionar um listener no config.
-- Vamos fazer um loop simples para verificar mudanças.
RunService.Heartbeat:Connect(function()
    -- Verifica se a mira foi ativada/desativada pelo menu
    if cfg.MiraAtiva and not AimToggleActive then
        AimToggleActive = true
        if not AimToggleBtn then
            AimToggleBtn = CreateAimShortcut()
            AimToggleBtn.Visible = true
        else
            AimToggleBtn.Visible = true
            AimToggleBtn.Text = "🎯 ON"
            AimToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        end
    elseif not cfg.MiraAtiva and AimToggleActive then
        AimToggleActive = false
        if AimToggleBtn then
            AimToggleBtn.Visible = false
        end
    end
    -- Sincroniza o texto se o botão estiver visível
    if AimToggleBtn and AimToggleBtn.Visible then
        if cfg.MiraAtiva ~= AimToggleActive then
            AimToggleActive = cfg.MiraAtiva
            AimToggleBtn.Text = AimToggleActive and "🎯 ON" or "🎯 OFF"
            AimToggleBtn.BackgroundColor3 = AimToggleActive and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        end
    end
end)

-- ============================================================
-- BOTÃO FLUTUANTE PRINCIPAL (com drag corrigido)
-- ============================================================
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

-- Drag do botão principal
local floatDragData = { dragging = false, start = nil, btnStart = nil, moved = false }

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragData.dragging = true
        floatDragData.start = input.Position
        floatDragData.btnStart = FloatBtn.Position
        floatDragData.moved = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatDragData.dragging = false
                if not floatDragData.moved then
                    -- Clique curto: abre/fecha menu
                    if MainFrame.Visible then
                        ToggleMenu(false)
                    else
                        ToggleMenu(true)
                    end
                end
            end
        end)
    end
end)

FloatBtn.InputChanged:Connect(function(input)
    if floatDragData.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatDragData.start
        if delta.Magnitude > 5 then floatDragData.moved = true end
        FloatBtn.Position = UDim2.new(floatDragData.btnStart.X.Scale, floatDragData.btnStart.X.Offset + delta.X,
                                        floatDragData.btnStart.Y.Scale, floatDragData.btnStart.Y.Offset + delta.Y)
    end
end)

-- ============================================================
-- FUNÇÃO ABRIR/FECHAR MENU
-- ============================================================
function ToggleMenu(show)
    if show then
        MainFrame.Visible = true
        Background.Visible = true
        FloatBtn.Visible = false
        -- Animação
        pcall(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 560, 0, 640),
                BackgroundTransparency = 0.1
            }):Play()
        end)
        MainFrame.Size = UDim2.new(0, 560, 0, 640)
        MainFrame.BackgroundTransparency = 0.1
        -- Abre a primeira aba se nenhuma estiver ativa
        if not CurrentTab then
            SwitchTab("Combate")
        end
    else
        pcall(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 640),
                BackgroundTransparency = 1
            }):Play()
        end)
        MainFrame.Visible = false
        Background.Visible = false
        FloatBtn.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 640)
        MainFrame.BackgroundTransparency = 1
    end
end

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
task.wait(0.5)
ToggleMenu(true) -- abre automaticamente

print("[WARCORE] UI v3 carregada com sucesso!")