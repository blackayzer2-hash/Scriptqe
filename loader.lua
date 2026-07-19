-- =============================================
-- loader.lua - WARCORE ULTIMATE
-- Ponto de entrada do menu
-- =============================================

local repo = "https://raw.githubusercontent.com/SEU_USUARIO/warcore/main/"

-- Carrega o core (funções) primeiro
local coreSuccess, coreErr = pcall(function()
    loadstring(game:HttpGet(repo .. "core.lua"))()
end)

if not coreSuccess then
    warn("[WARCORE] Erro ao carregar core.lua: " .. tostring(coreErr))
    return
end

-- Carrega a UI (menu)
local uiSuccess, uiErr = pcall(function()
    loadstring(game:HttpGet(repo .. "ui.lua"))()
end)

if not uiSuccess then
    warn("[WARCORE] Erro ao carregar ui.lua: " .. tostring(uiErr))
    return
end

print("[WARCORE] Menu carregado com sucesso!")