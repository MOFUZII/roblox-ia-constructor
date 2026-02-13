-- ============================================================
-- HYBRID LEARNING PLUGIN v1.0 - FIXED
-- Sistema de Aprendizaje con Servidor Externo
-- ============================================================
-- VERSIÓN CORREGIDA: Persistencia deshabilitada temporalmente
-- El sistema funciona perfectamente en modo "solo sesión"
-- ============================================================

local HybridLearning = {
    info = {
        nombre = "HybridLearning",
        version = "1.0.1-FIXED",
        autor = "MOFUZII",
        descripcion = "Aprendizaje con persistencia via servidor externo",
        dependencias = {},
        permisos = {}
    },
    
    comandos = {},
    construcciones = {},
    interceptores = {},
    hooks = {}
}

-- ============================================================
-- CONFIGURACIÓN DEL SERVIDOR
-- ============================================================

local CONFIG = {
    -- ⚠️ DESHABILITADO TEMPORALMENTE - HTTP 401 en Roblox
    -- Para habilitar: conseguir nuevas credenciales de JSONBin
    USAR_JSONBIN = false,  -- ⬅️ CAMBIADO A FALSE
    JSONBIN_API_KEY = "$2a$10$esTdhf2XnVpz6u062Id43eXk7ef4PQnCiNT0YQCHWf.NVYc31IqP6",
    JSONBIN_BIN_ID = "698e7696d0ea881f40b62afe",
    
    USAR_SERVIDOR_PROPIO = false,
    SERVIDOR_URL = "https://tuservidor.com/api/stats",
    
    USAR_PASTEBIN = false,
    PASTEBIN_API_KEY = "TU_API_KEY",
    PASTEBIN_PASTE_KEY = "TU_PASTE_KEY",
    
    AUTO_SYNC = false,  -- ⬅️ TAMBIÉN DESHABILITADO
    SYNC_INTERVAL = 300,
    TIMEOUT = 10
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ============================================================
-- ESTRUCTURA DE DATOS
-- ============================================================

local GlobalData = {
    version = "1.0",
    ultimaActualizacion = 0,
    totalUsuarios = 0,
    totalSesiones = 0,
    
    stats = {
        totalComandos = 0,
        totalConstrucciones = 0,
        comandosMasUsados = {},
        construccionesMasCreadas = {},
        coloresMasUsados = {},
        materialesMasUsados = {}
    },
    
    trending = {
        ultimaActualizacion = 0,
        comandos = {},
        construcciones = {}
    },
    
    usuarios = {}
}

local LocalData = {
    userId = 0,
    username = "",
    sesionInicio = os.time(),
    
    comandosEjecutados = 0,
    construccionesCreadas = 0,
    
    comandos = {},
    colores = {},
    materiales = {},
    
    historico = {
        totalSesiones = 0,
        totalComandos = 0,
        comandosFavoritos = {},
        colorFavorito = nil,
        primeraVez = true
    }
}

-- ============================================================
-- FUNCIONES DE SINCRONIZACIÓN (DESHABILITADAS)
-- ============================================================

local function encodearData(data)
    return HttpService:JSONEncode(data)
end

local function decodearData(json)
    local success, result = pcall(function()
        return HttpService:JSONDecode(json)
    end)
    return success and result or nil
end

local function guardarEnJSONBin()
    -- Deshabilitado temporalmente
    return false
end

local function cargarDeJSONBin()
    -- Deshabilitado temporalmente
    return false
end

local function guardarEnServidor()
    return false
end

local function cargarDeServidor()
    return false
end

local function sincronizarDatos(direccion)
    -- Sistema de persistencia deshabilitado
    -- Funciona perfectamente en modo "solo sesión"
    return false
end

-- ============================================================
-- FUNCIONES DE TRACKING (FUNCIONAN PERFECTAMENTE)
-- ============================================================

local function incrementar(tabla, clave)
    tabla[clave] = (tabla[clave] or 0) + 1
end

local function trackComando(nombre, params)
    LocalData.comandosEjecutados = LocalData.comandosEjecutados + 1
    incrementar(LocalData.comandos, nombre)
    
    if params.color then
        incrementar(LocalData.colores, params.color)
    end
    if params.material then
        incrementar(LocalData.materiales, params.material)
    end
    
    GlobalData.stats.totalComandos = GlobalData.stats.totalComandos + 1
    incrementar(GlobalData.stats.comandosMasUsados, nombre)
    incrementar(GlobalData.trending.comandos, nombre)
    
    if params.color then
        incrementar(GlobalData.stats.coloresMasUsados, params.color)
    end
    if params.material then
        incrementar(GlobalData.stats.materialesMasUsados, params.material)
    end
end

local function trackConstruccion(nombre)
    LocalData.construccionesCreadas = LocalData.construccionesCreadas + 1
    GlobalData.stats.totalConstrucciones = GlobalData.stats.totalConstrucciones + 1
    incrementar(GlobalData.stats.construccionesMasCreadas, nombre)
    incrementar(GlobalData.trending.construcciones, nombre)
end

local function obtenerTop(tabla, limite)
    limite = limite or 10
    local arr = {}
    for k, v in pairs(tabla) do
        table.insert(arr, {nombre = k, valor = v})
    end
    table.sort(arr, function(a, b) return a.valor > b.valor end)
    
    local resultado = {}
    for i = 1, math.min(limite, #arr) do
        table.insert(resultado, arr[i])
    end
    return resultado
end

-- ============================================================
-- COMANDOS (FUNCIONAN PERFECTAMENTE)
-- ============================================================

HybridLearning.comandos = {
    
    ["stats"] = {
        tipo = "sistema",
        descripcion = "Tus estadísticas de esta sesión",
        parametros = {},
        ejemplos = {"stats"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "📊 TUS ESTADÍSTICAS (SESIÓN)\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n"
            msg = msg .. "👤 " .. LocalData.username .. "\n\n"
            
            msg = msg .. "🎮 Comandos ejecutados: " .. LocalData.comandosEjecutados .. "\n"
            msg = msg .. "🏗️ Construcciones: " .. LocalData.construccionesCreadas .. "\n\n"
            
            -- Top comandos de la sesión
            local topCmds = obtenerTop(LocalData.comandos, 5)
            if #topCmds > 0 then
                msg = msg .. "🏆 TUS TOP COMANDOS:\n"
                for i, cmd in ipairs(topCmds) do
                    msg = msg .. i .. ". " .. cmd.nombre .. " (" .. cmd.valor .. " veces)\n"
                end
            end
            
            return msg
        end
    },
    
    ["globalstats"] = {
        tipo = "sistema",
        descripcion = "Estadísticas globales de esta sesión",
        parametros = {},
        ejemplos = {"globalstats"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "🌍 ESTADÍSTICAS GLOBALES (SESIÓN)\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n"
            msg = msg .. "🎮 Comandos totales: " .. GlobalData.stats.totalComandos .. "\n"
            msg = msg .. "🏗️ Construcciones totales: " .. GlobalData.stats.totalConstrucciones .. "\n\n"
            
            local topCmds = obtenerTop(GlobalData.stats.comandosMasUsados, 5)
            if #topCmds > 0 then
                msg = msg .. "🏆 TOP COMANDOS GLOBALES:\n"
                for i, cmd in ipairs(topCmds) do
                    msg = msg .. i .. ". " .. cmd.nombre .. " (" .. cmd.valor .. ")\n"
                end
            end
            
            local topColores = obtenerTop(GlobalData.stats.coloresMasUsados, 3)
            if #topColores > 0 then
                msg = msg .. "\n🎨 COLORES MÁS USADOS:\n"
                for i, color in ipairs(topColores) do
                    msg = msg .. i .. ". " .. color.nombre .. " (" .. color.valor .. ")\n"
                end
            end
            
            msg = msg .. "\n⚠️ Modo: Solo sesión actual\n"
            msg = msg .. "(Persistencia deshabilitada)\n"
            
            return msg
        end
    },
    
    ["trending"] = {
        tipo = "sistema",
        descripcion = "Comandos en tendencia (sesión actual)",
        parametros = {},
        ejemplos = {"trending"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "🔥 TRENDING (SESIÓN ACTUAL)\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n"
            
            local trending = obtenerTop(GlobalData.trending.comandos, 10)
            if #trending == 0 then
                return "No hay datos de tendencias aún.\nUsa algunos comandos primero!"
            end
            
            for i, cmd in ipairs(trending) do
                msg = msg .. i .. ". " .. cmd.nombre .. " (" .. cmd.valor .. " usos)\n"
            end
            
            msg = msg .. "\n⚠️ Solo datos de esta sesión\n"
            
            return msg
        end
    },
    
    ["sync"] = {
        tipo = "sistema",
        descripcion = "Estado de sincronización",
        parametros = {},
        ejemplos = {"sync"},
        categoria = "Sistema",
        ejecutar = function()
            return "⚠️ SINCRONIZACIÓN DESHABILITADA\n\n" ..
                   "El sistema funciona perfectamente en modo 'solo sesión'.\n" ..
                   "Tus estadísticas se mantienen durante esta sesión.\n\n" ..
                   "Para habilitar persistencia:\n" ..
                   "1. Configurar nuevas credenciales JSONBin\n" ..
                   "2. O usar Pastebin (más compatible)\n" ..
                   "3. Actualizar CONFIG en HybridLearning_Plugin.lua"
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

HybridLearning.hooks = {
    
    onInit = function()
        print("[HybridLearning] Inicializando en modo SOLO SESIÓN...")
        
        local player = Players.LocalPlayer
        if player then
            LocalData.userId = player.UserId
            LocalData.username = player.Name
        end
        
        -- Registrar usuario en datos de sesión
        local userKey = tostring(LocalData.userId)
        GlobalData.totalUsuarios = 1
        GlobalData.usuarios[userKey] = {
            username = LocalData.username,
            primeraVez = os.time(),
            ultimaConexion = os.time(),
            totalComandos = 0
        }
        
        GlobalData.totalSesiones = 1
        
        print("[HybridLearning] ✅ Sistema listo (modo sesión)")
        print("[HybridLearning] Usuario: " .. LocalData.username)
        print("[HybridLearning] ⚠️ Persistencia deshabilitada - datos solo en memoria")
    end,
    
    onComandoEjecutado = function(nombre, params)
        trackComando(nombre, params or {})
    end,
    
    onConstruccionCreada = function(nombre)
        trackConstruccion(nombre)
    end
}

-- ============================================================
-- RETORNAR PLUGIN
-- ============================================================

return HybridLearning
