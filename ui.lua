-- =============================================
-- ui.lua - WARCORE ULTIMATE
-- Interface visual do menu (mobile otimizado)
-- =============================================

if not _G.Warcore then
    error("[WARCORE] Core não carregado! Execute o loader.")
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "👑 WARCORE ULTIMATE",
    LoadingTitle = "WARCORE ULTIMATE",
    LoadingSubtitle = "Mobile Otimizado",
    ConfigurationSaving = { Enabled = false },
    Theme = "Custom"
})
Window.BackgroundColor = Color3.fromRGB(11, 13, 23)

-- Ajusta janela para mobile
task.wait(0.1)
for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
    if gui:IsA("ScreenGui") and gui.Name == "Rayfield" then
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("Frame") and child.Name == "Main" then
                child.Position = UDim2.new(0.5, -220, 0.5, -280)
                child.Size = UDim2.new(0, 440, 0, 560)
                break
            end
        end
        break
    end
end

local cfg = _G.Warcore.Config

-- ========== ABAS ==========
local CombatTab = Window:CreateTab("🔫 Combate", 10734950020)
local VisualTab = Window:CreateTab("👁️ Visual", 10734951477)
local RxTab = Window:CreateTab("🛸 Opções RX", 10734951477)
local LightTab = Window:CreateTab("💡 Iluminação", 10734951477)
local MovimentTab = Window:CreateTab("🧱 Movimento", 4483362458)
local NavTab = Window:CreateTab("🗺️ Navegação", 10734951477)
local StyleTab = Window:CreateTab("🎨 Estilo", 10734951477)
local UtilTab = Window:CreateTab("🛡️ Utilidades", 4483362458)
local StatusTab = Window:CreateTab("📊 Monitor", 4483362458)

-- ========== COMBATE ==========
CombatTab:CreateSection("🎯 Mira")
CombatTab:CreateToggle({
    Name = "Mira Assistida",
    CurrentValue = false,
    Callback = function(v) cfg.MiraAtiva = v end
})
CombatTab:CreateSlider({
    Name = "Suavidade",
    Range = {0.1, 1},
    Increment = 0.05,
    CurrentValue = 0.35,
    Callback = function(v) cfg.Smoothness = v end
})
CombatTab:CreateSlider({
    Name = "FOV",
    Range = {100, 1000},
    Increment = 10,
    CurrentValue = 500,
    Callback = function(v) cfg.FovRadius = v end
})

CombatTab:CreateSection("🔫 Trigger")
CombatTab:CreateToggle({
    Name = "TriggerBot",
    CurrentValue = false,
    Callback = function(v) cfg.TriggerBot = v end
})
CombatTab:CreateSlider({
    Name = "Delay (ms)",
    Range = {0, 500},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(v) cfg.TriggerDelay = v end
})

CombatTab:CreateSection("🎯 Silent Aim")
CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(v) cfg.SilentAim = v end
})
CombatTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Cabeça", "Tórax", "Aleatório"},
    CurrentOption = "Cabeça",
    MultipleOptions = false,
    Callback = function(opt) cfg.AimPart = opt end
})

CombatTab:CreateSection("🔧 Anti-Recoil")
CombatTab:CreateToggle({
    Name = "Anti-Recoil",
    CurrentValue = false,
    Callback = function(v) cfg.AntiRecoil = v end
})
CombatTab:CreateSlider({
    Name = "Redução",
    Range = {0.1, 1},
    Increment = 0.05,
    CurrentValue = 0.5,
    Callback = function(v) cfg.RecoilReduction = v end
})

-- ========== VISUAL ==========
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({
    Name = "Raio-X (Highlight)",
    CurrentValue = false,
    Callback = function(v) cfg.HighlightEnabled = v end
})
VisualTab:CreateToggle({
    Name = "Ponto na Cabeça",
    CurrentValue = false,
    Callback = function(v) cfg.DotEnabled = v end
})
VisualTab:CreateToggle({
    Name = "Micro-HUD Vida",
    CurrentValue = false,
    Callback = function(v) cfg.MicroHpEnabled = v end
})
VisualTab:CreateToggle({
    Name = "Micro-HUD Distância",
    CurrentValue = false,
    Callback = function(v) cfg.MicroDistEnabled = v end
})

VisualTab:CreateSection("Tamanhos")
VisualTab:CreateSlider({
    Name = "Texto Distância",
    Range = {6, 24},
    Increment = 1,
    CurrentValue = 8,
    Callback = function(v) cfg.MicroTextSize = v end
})
VisualTab:CreateSlider({
    Name = "Largura Barra Vida",
    Range = {20, 100},
    Increment = 5,
    CurrentValue = 35,
    Callback = function(v) cfg.MicroWidth = v end
})

-- ========== RX ==========
RxTab:CreateSection("Configurações Avançadas")
RxTab:CreateDropdown({
    Name = "Modo Visibilidade",
    Options = {"AlwaysOnTop", "Occluded"},
    CurrentOption = "AlwaysOnTop",
    MultipleOptions = false,
    Callback = function(opt) cfg.HlDepthMode = opt end
})
RxTab:CreateSlider({
    Name = "Transparência Fill",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.5,
    Callback = function(v) cfg.HlFillTransparency = v end
})
RxTab:CreateColorPicker({
    Name = "Cor Inimigos",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(v) cfg.HlEnemyColor = v end
})

-- ========== ILUMINAÇÃO ==========
LightTab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Callback = function(v) cfg.FullBright = v end
})
LightTab:CreateToggle({
    Name = "Clareza Aprimorada",
    CurrentValue = false,
    Callback = function(v) cfg.ClarezaMod = v end
})
LightTab:CreateToggle({
    Name = "Remover Sombras",
    CurrentValue = false,
    Callback = function(v) game:GetService("Lighting").GlobalShadows = not v end
})

-- ========== MOVIMENTO ==========
MovimentTab:CreateSection("🕊️ Fly")
MovimentTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        cfg.FlyEnabled = v
        _G.Warcore.ToggleFly(v)
    end
})
MovimentTab:CreateToggle({
    Name = "Modo Infinito",
    CurrentValue = false,
    Callback = function(v) cfg.FlyInfinite = v end
})
MovimentTab:CreateSlider({
    Name = "Velocidade Fly",
    Range = {1, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v) cfg.FlySpeed = v end
})

MovimentTab:CreateSection("🧱 No-Clip")
MovimentTab:CreateToggle({
    Name = "No-Clip",
    CurrentValue = false,
    Callback = function(v) _G.Warcore.ToggleNoClip(v) end
})

MovimentTab:CreateSection("⚡ Speed")
MovimentTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(v) _G.Warcore.ToggleSpeed(v) end
})
MovimentTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        cfg.SpeedValue = v
        _G.Warcore.SetSpeedValue(v)
    end
})

MovimentTab:CreateSection("🦘 Pulo")
MovimentTab:CreateToggle({
    Name = "Super Pulo",
    CurrentValue = false,
    Callback = function(v) _G.Warcore.ToggleJump(v) end
})
MovimentTab:CreateSlider({
    Name = "Altura",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 100,
    Callback = function(v)
        cfg.JumpPower = v
        _G.Warcore.SetJumpPower(v)
    end
})
MovimentTab:CreateToggle({
    Name = "Pulo Infinito",
    CurrentValue = false,
    Callback = function(v) cfg.InfiniteJump = v end
})

MovimentTab:CreateSection("🧗 Wall-Climb")
MovimentTab:CreateToggle({
    Name = "Escalar Paredes",
    CurrentValue = false,
    Callback = function(v) cfg.WallClimb = v end
})
MovimentTab:CreateSlider({
    Name = "Velocidade Escalada",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = 20,
    Callback = function(v) cfg.WallClimbSpeed = v end
})

MovimentTab:CreateSection("🏃 Auto-Sprint")
MovimentTab:CreateToggle({
    Name = "Auto-Sprint",
    CurrentValue = false,
    Callback = function(v) cfg.AutoSprint = v end
})

-- ========== NAVEGAÇÃO ==========
NavTab:CreateSection("📍 Indicadores")
NavTab:CreateToggle({
    Name = "Distância no HUD",
    CurrentValue = false,
    Callback = function(v) cfg.ShowDistanceHUD = v end
})
NavTab:CreateToggle({
    Name = "Seta Direcional",
    CurrentValue = false,
    Callback = function(v) cfg.ShowDirectionArrow = v end
})
NavTab:CreateSection("🗺️ Radar")
NavTab:CreateToggle({
    Name = "Radar",
    CurrentValue = false,
    Callback = function(v) cfg.RadarEnabled = v end
})
NavTab:CreateSlider({
    Name = "Tamanho Radar",
    Range = {80, 300},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(v) cfg.RadarSize = v end
})

-- ========== ESTILO ==========
StyleTab:CreateSection("🌈 Chams")
StyleTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Callback = function(v) cfg.ChamsEnabled = v end
})
StyleTab:CreateColorPicker({
    Name = "Cor Chams",
    Color = Color3.fromRGB(0, 255, 0),
    Callback = function(v) cfg.ChamsColor = v end
})
StyleTab:CreateToggle({
    Name = "Modo Arco-Íris",
    CurrentValue = false,
    Callback = function(v) cfg.ChamsRainbow = v end
})

StyleTab:CreateSection("🎨 Modo Cinza")
StyleTab:CreateToggle({
    Name = "Modo Cinza",
    CurrentValue = false,
    Callback = function(v) cfg.GrayMode = v end
})

-- ========== UTILIDADES ==========
UtilTab:CreateSection("🛡️ Anti-AFK")
UtilTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(v) cfg.AntiAFK = v end
})

UtilTab:CreateSection("📦 Auto-Collect")
UtilTab:CreateToggle({
    Name = "Auto-Collect",
    CurrentValue = false,
    Callback = function(v) cfg.AutoCollect = v end
})
UtilTab:CreateSlider({
    Name = "Raio Coleta",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = 30,
    Callback = function(v) cfg.CollectRadius = v end
})

-- ========== MONITOR ==========
StatusTab:CreateSection("📊 Monitor")
StatusTab:CreateToggle({
    Name = "Mostrar FPS",
    CurrentValue = false,
    Callback = function(v)
        cfg.ShowFPS = v
        if v then
            local tag = Instance.new("TextLabel", game:GetService("CoreGui"))
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
            local tag = game:GetService("CoreGui"):FindFirstChild("WarcoreFPS")
            if tag then tag:Destroy() end
        end
    end
})
StatusTab:CreateToggle({
    Name = "Mostrar Players",
    CurrentValue = false,
    Callback = function(v)
        cfg.ShowPlayers = v
        if v then
            local tag = Instance.new("TextLabel", game:GetService("CoreGui"))
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
            local tag = game:GetService("CoreGui"):FindFirstChild("WarcorePlayers")
            if tag then tag:Destroy() end
        end
    end
})

-- Atualiza labels
game:GetService("RunService").RenderStepped:Connect(function()
    if cfg.ShowFPS and _G.Warcore.FPSLabel then
        _G.Warcore.FPSLabel.Text = "⚡ FPS: " .. (_G.Warcore.FPS or 0)
    end
    if cfg.ShowPlayers and _G.Warcore.PlayersLabel then
        _G.Warcore.PlayersLabel.Text = "👥 Players: " .. (_G.Warcore.PlayerCount or 0)
    end
end)

print("[WARCORE] UI carregada com sucesso!")