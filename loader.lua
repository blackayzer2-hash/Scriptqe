-- ========================================================
-- loader.lua - WARCORE ULTIMATE
-- DESTINADO AO DELTA EXECUTOR E OUTROS
-- ========================================================

-- COLE OS LINKS "RAW" DO GITHUB AQUI DENTRO DAS ASPAS:
local LINK_DO_CORE = "https://raw.githubusercontent.com/blackayzer2-hash/Scriptqe/refs/heads/main/core.lua"
local LINK_DA_UI   = "https://raw.githubusercontent.com/blackayzer2-hash/Scriptqe/refs/heads/main/ui0.lua"

-- ========================================================
-- SISTEMA DE CARREGAMENTO (Não precisa mexer abaixo)
-- ========================================================

-- 1. Carrega o core (funções) primeiro
local coreSuccess, coreErr = pcall(function()
    return loadstring(game:HttpGet(LINK_DO_CORE))()
end)

if not coreSuccess then
    warn("[WARCORE] Erro ao carregar o arquivo Core: " .. tostring(coreErr))
    return
end

-- 2. Carrega a UI (menu) em seguida
local uiSuccess, uiErr = pcall(function()
    return loadstring(game:HttpGet(LINK_DA_UI))()
end)

if not uiSuccess then
    warn("[WARCORE] Erro ao carregar o arquivo UI: " .. tostring(uiErr))
    return
end

print("[WARCORE] Core pronto.")
