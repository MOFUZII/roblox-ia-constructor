-- ============================================================
-- HYBRID LEARNING PLUGIN v1.0
-- Sistema de Aprendizaje con Servidor Externo
-- ============================================================
-- CÓMO FUNCIONA:
-- 
-- 1. Durante la sesión: Aprende en memoria (como antes)
-- 2. Al salir: Intenta enviar datos a un servidor externo vía HTTP
-- 3. Al iniciar: Intenta descargar datos del servidor
-- 
-- OPCIONES:
-- A) CON SERVIDOR: Persistencia real entre sesiones
-- B) SIN SERVIDOR: Solo aprendizaje de sesión
-- 
-- SERVIDOR NECESARIO:
-- - API REST simple que acepte POST/GET
-- - Ejemplos: Replit, Glitch, Railway, Vercel
-- - O usa un servicio como Pastebin/JSONBin
-- ============================================================

local HybridLearning = {
    info = {
        nombre = "HybridLearning",
        version = "1.0.0-HYBRID",
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
    -- OPCIÓN 1: JSONBin.io (GRATIS, NO REQUIERE SERVIDOR PROPIO)
    -- ✅ CONFIGURADO CON TUS CREDENCIALES REALES
    USAR_JSONBIN = true,
    JSONBIN_API_KEY = "$2a$10$esTdhf2XnVpz6u062Id43eXk7ef4PQnCiNT0YQCHWf.NVYc31IqP6",
    JSONBIN_BIN_ID = "698e7696d0ea881f40b62afe"
    
    -- OPCIÓN 2: Tu propio servidor
    USAR_SERVIDOR_PROPIO = false,
    SERVIDOR_URL = "https://tuservidor.com/api/stats",
    
    -- OPCIÓN 3: Pastebin (SIMPLE pero limitado)
    USAR_PASTEBIN = false,
    PASTEBIN_API_KEY = "TU_API_KEY",
    PASTEBIN_PASTE_KEY = "TU_PASTE_KEY",
    
    -- Configuración general
    AUTO_SYNC = true, -- Auto-guardar cada X minutos
    SYNC_INTERVAL = 300, -- 5 minutos
    TIMEOUT = 10 -- Timeout de requests HTTP
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ============================================================
-- ESTRUCTURA DE DATOS
-- ============================================================

-- Datos GLOBALES (compartidos entre TODOS los usuarios)
local GlobalData = {
    version = "1.0",
    ultimaActualizacion = 0,
    totalUsuarios = 0,
    totalSesiones = 0,
    
    -- Estadísticas globales
    stats = {
        totalComandos = 0,
        totalConstrucciones = 0,
        comandosMasUsados = {}, -- {["torre"] = 150, ["casa"] = 120}
        construccionesMasCreadas = {},
        coloresMasUsados = {},
        materialesMasUsados = {}
    },
    
    -- Trending (últimas 24h)
    trending = {
        ultimaActualizacion = 0,
        comandos = {}, -- Reset cada 24h
        construcciones = {}
    },
    
    -- Usuarios registrados
    usuarios = {} -- {["USER_ID"] = {username, totalComandos, ultimaConexion}}
}

-- Datos LOCALES (solo de este usuario, esta sesión)
local LocalData = {
    userId = 0,
    username = "",
    sesionInicio = os.time(),
    
    -- Stats de sesión
    comandosEjecutados = 0,
    construccionesCreadas = 0,
    
    -- Historial
    comandos = {},
    colores = {},
    materiales = {},
    
    -- Persistente (se carga del servidor)
    historico = {
        totalSesiones = 0,
        totalComandos = 0,
        comandosFavoritos = {},
        colorFavorito = nil,
        primeraVez = true
    }
}

-- ============================================================
-- FUNCIONES DE SINCRONIZACIÓN
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

-- Guardar datos en JSONBin
local function guardarEnJSONBin()
    if not CONFIG.USAR_JSONBIN then return false end
    
    local url = "https://api.jsonbin.io/v3/b/" .. CONFIG.JSONBIN_BIN_ID
    
    local data = encodearData(GlobalData)
    
    local success, response = pcall(function()
        return game:HttpPostAsync(url, data, Enum.HttpContentType.ApplicationJson, false, {
            ["Content-Type"] = "application/json",
            ["X-Master-Key"] = CONFIG.JSONBIN_API_KEY,
            ["X-Bin-Versioning"] = "false"
        })
    end)
    
    if success then
        print("[HybridLearning] ✅ Datos guardados en JSONBin")
        return true
    else
        warn("[HybridLearning] ❌ Error guardando: " .. tostring(response))
        return false
    end
end

-- Cargar datos desde JSONBin
local function cargarDeJSONBin()
    if not CONFIG.USAR_JSONBIN then return false end
    
    local url = "https://api.jsonbin.io/v3/b/" .. CONFIG.JSONBIN_BIN_ID .. "/latest"
    
    local success, response = pcall(function()
        return game:HttpGetAsync(url, false, {
            ["X-Master-Key"] = CONFIG.JSONBIN_API_KEY
        })
    end)
    
    if success then
        local decoded = decodearData(response)
        if decoded and decoded.record then
            -- Mergear datos descargados con estructura local
            for key, value in pairs(decoded.record) do
                if GlobalData[key] ~= nil then
                    GlobalData[key] = value
                end
            end
            print("[HybridLearning] ✅ Datos cargados desde JSONBin")
            print("[HybridLearning] Total usuarios: " .. GlobalData.totalUsuarios)
            print("[HybridLearning] Total comandos globales: " .. GlobalData.stats.totalComandos)
            return true
        end
    else
        warn("[HybridLearning] ❌ Error cargando: " .. tostring(response))
    end
    
    return false
end

-- Guardar en servidor propio
local function guardarEnServidor()
    if not CONFIG.USAR_SERVIDOR_PROPIO then return false end
    
    local data = encodearData(GlobalData)
    
    local success, response = pcall(function()
        return game:HttpPostAsync(CONFIG.SERVIDOR_URL, data, Enum.HttpContentType.ApplicationJson)
    end)
    
    return success
end

-- Cargar de servidor propio
local function cargarDeServidor()
    if not CONFIG.USAR_SERVIDOR_PROPIO then return false end
    
    local success, response = pcall(function()
        return game:HttpGetAsync(CONFIG.SERVIDOR_URL)
    end)
    
    if success then
        local decoded = decodearData(response)
        if decoded then
            for key, value in pairs(decoded) do
                if GlobalData[key] ~= nil then
                    GlobalData[key] = value
                end
            end
            return true
        end
    end
    
    return false
end

-- Función principal de guardado
local function sincronizarDatos(direccion)
    if direccion == "guardar" then
        -- Actualizar timestamp
        GlobalData.ultimaActualizacion = os.time()
        
        -- Intentar guardar en orden de preferencia
        if CONFIG.USAR_JSONBIN then
            return guardarEnJSONBin()
        elseif CONFIG.USAR_SERVIDOR_PROPIO then
            return guardarEnServidor()
        end
        
    elseif direccion == "cargar" then
        -- Intentar cargar en orden de preferencia
        if CONFIG.USAR_JSONBIN then
            return cargarDeJSONBin()
        elseif CONFIG.USAR_SERVIDOR_PROPIO then
            return cargarDeServidor()
        end
    end
    
    return false
end

-- ============================================================
-- TRACKING Y ANÁLISIS
-- ============================================================

local function incrementar(tabla, clave, valor)
    tabla[clave] = (tabla[clave] or 0) + (valor or 1)
end

local function trackComando(nombre, params)
    params = params or {}
    
    -- Actualizar local
    LocalData.comandosEjecutados = LocalData.comandosEjecutados + 1
    incrementar(LocalData.comandos, nombre)
    
    if params.color then
        incrementar(LocalData.colores, params.color)
    end
    if params.material then
        incrementar(LocalData.materiales, params.material)
    end
    
    -- Actualizar global
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
-- COMANDOS
-- ============================================================

HybridLearning.comandos = {
    
    ["stats"] = {
        tipo = "sistema",
        descripcion = "Tus estadísticas (sesión + históricas)",
        parametros = {},
        ejemplos = {"stats"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "📊 TUS ESTADÍSTICAS\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n"
            msg = msg .. "👤 " .. LocalData.username .. "\n"
            
            -- Sesión actual
            msg = msg .. "\n📱 SESIÓN ACTUAL:\n"
            msg = msg .. "🎮 Comandos: " .. LocalData.comandosEjecutados .. "\n"
            msg = msg .. "🏗️ Construcciones: " .. LocalData.construccionesCreadas .. "\n"
            
            -- Histórico (si hay)
            if LocalData.historico.totalSesiones > 0 then
                msg = msg .. "\n📚 HISTÓRICO:\n"
                msg = msg .. "🔢 Total sesiones: " .. LocalData.historico.totalSesiones .. "\n"
                msg = msg .. "🎮 Total comandos: " .. LocalData.historico.totalComandos .. "\n"
                
                if LocalData.historico.colorFavorito then
                    msg = msg .. "🎨 Color favorito: " .. LocalData.historico.colorFavorito .. "\n"
                end
            end
            
            return msg
        end
    },
    
    ["globalstats"] = {
        tipo = "sistema",
        descripcion = "Estadísticas globales de TODOS los usuarios",
        parametros = {},
        ejemplos = {"globalstats"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "🌍 ESTADÍSTICAS GLOBALES\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n"
            msg = msg .. "👥 Usuarios totales: " .. GlobalData.totalUsuarios .. "\n"
            msg = msg .. "🎮 Comandos ejecutados: " .. GlobalData.stats.totalComandos .. "\n"
            msg = msg .. "🏗️ Construcciones creadas: " .. GlobalData.stats.totalConstrucciones .. "\n"
            
            -- Top comandos
            local topCmds = obtenerTop(GlobalData.stats.comandosMasUsados, 5)
            if #topCmds > 0 then
                msg = msg .. "\n🏆 TOP COMANDOS:\n"
                for i, cmd in ipairs(topCmds) do
                    msg = msg .. i .. ". " .. cmd.nombre .. " (" .. cmd.valor .. ")\n"
                end
            end
            
            -- Top colores
            local topColores = obtenerTop(GlobalData.stats.coloresMasUsados, 3)
            if #topColores > 0 then
                msg = msg .. "\n🎨 COLORES MÁS USADOS:\n"
                for i, color in ipairs(topColores) do
                    msg = msg .. i .. ". " .. color.nombre .. " (" .. color.valor .. ")\n"
                end
            end
            
            return msg
        end
    },
    
    ["trending"] = {
        tipo = "sistema",
        descripcion = "Comandos en tendencia (24h)",
        parametros = {},
        ejemplos = {"trending"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "🔥 TRENDING (24H)\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n"
            
            local trending = obtenerTop(GlobalData.trending.comandos, 10)
            if #trending == 0 then
                return "No hay datos de tendencias aún"
            end
            
            for i, cmd in ipairs(trending) do
                msg = msg .. i .. ". " .. cmd.nombre .. " (" .. cmd.valor .. " usos)\n"
            end
            
            return msg
        end
    },
    
    ["sync"] = {
        tipo = "sistema",
        descripcion = "Sincronizar datos manualmente con servidor",
        parametros = {},
        ejemplos = {"sync"},
        categoria = "Sistema",
        ejecutar = function()
            local success = sincronizarDatos("guardar")
            if success then
                return "✅ Datos sincronizados correctamente"
            else
                return "❌ Error al sincronizar (verifica configuración del servidor)"
            end
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

HybridLearning.hooks = {
    
    onInit = function()
        print("[HybridLearning] Inicializando...")
        
        -- Obtener info del jugador
        local player = Players.LocalPlayer
        if player then
            LocalData.userId = player.UserId
            LocalData.username = player.Name
        end
        
        -- Cargar datos globales
        local cargado = sincronizarDatos("cargar")
        
        -- Registrar usuario
        local userKey = tostring(LocalData.userId)
        if not GlobalData.usuarios[userKey] then
            GlobalData.totalUsuarios = GlobalData.totalUsuarios + 1
            GlobalData.usuarios[userKey] = {
                username = LocalData.username,
                primeraVez = os.time(),
                ultimaConexion = os.time(),
                totalComandos = 0
            }
            LocalData.historico.primeraVez = true
            print("[HybridLearning] ¡Bienvenido nuevo usuario #" .. GlobalData.totalUsuarios .. "!")
        else
            GlobalData.usuarios[userKey].ultimaConexion = os.time()
            LocalData.historico = {
                totalSesiones = (GlobalData.usuarios[userKey].totalSesiones or 0) + 1,
                totalComandos = GlobalData.usuarios[userKey].totalComandos or 0,
                primeraVez = false
            }
            print("[HybridLearning] ¡Bienvenido de vuelta " .. LocalData.username .. "!")
        end
        
        GlobalData.totalSesiones = GlobalData.totalSesiones + 1
        
        -- Auto-sync
        if CONFIG.AUTO_SYNC then
            spawn(function()
                while true do
                    wait(CONFIG.SYNC_INTERVAL)
                    sincronizarDatos("guardar")
                end
            end)
        end
        
        print("[HybridLearning] Sistema listo")
        if not cargado then
            print("[HybridLearning] ⚠️ No se pudieron cargar datos remotos - usando modo offline")
        end
    end,
    
    onComandoEjecutado = function(nombre, params)
        trackComando(nombre, params or {})
    end,
    
    onConstruccionCreada = function(nombre)
        trackConstruccion(nombre)
    end
}

-- Al salir, guardar datos
Players.PlayerRemoving:Connect(function(player)
    if player == Players.LocalPlayer then
        print("[HybridLearning] Guardando datos antes de salir...")
        
        -- Actualizar datos del usuario
        local userKey = tostring(LocalData.userId)
        if GlobalData.usuarios[userKey] then
            GlobalData.usuarios[userKey].totalComandos = (GlobalData.usuarios[userKey].totalComandos or 0) + LocalData.comandosEjecutados
            GlobalData.usuarios[userKey].totalSesiones = (GlobalData.usuarios[userKey].totalSesiones or 0) + 1
        end
        
        sincronizarDatos("guardar")
    end
end)

-- ============================================================
-- RETORNAR PLUGIN
-- ============================================================

return HybridLearning
