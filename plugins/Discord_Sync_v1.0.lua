-- ============================================================
-- DISCORD_SYNC.LUA v1.0.8 - DELTA EXECUTOR OPTIMIZADO
-- Versión mejorada con diagnóstico de errores
-- ============================================================

local DiscordSync = {}

-- ✅ Configuración
DiscordSync.Config = {
    webhookURL = "https://discord.com/api/webhooks/1471763523813245100/zLXNOF795LzQoJGLPDq8b7InVPqA-ijVcunDshk8KZEdUzLAeTLoTVzqvgyTQGDh2ICk",
    enabled = true,
    silentMode = false,  -- Desactivado por defecto para Delta
    debug = true  -- Mostrar info de debug
}

-- ✅ Detectar executor
local function detectarExecutor()
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok then return name end
    end
    
    if KRNL_LOADED then return "KRNL" end
    if syn then return "Synapse X" end
    if SENTINEL_LOADED then return "Sentinel" end
    if getexecutorname then
        local ok, name = pcall(getexecutorname)
        if ok then return name end
    end
    
    return "Delta/Desconocido"
end

local executor = detectarExecutor()

function DiscordSync:enviarWebhook(data)
    if not self.Config.enabled then
        print("[Discord Sync] ⚠️ Sistema deshabilitado")
        return false
    end
    
    if self.Config.silentMode then
        print("[Discord Sync] 📝 Modo silencioso:", data.title)
        return true
    end
    
    local HttpService = game:GetService("HttpService")
    
    -- Verificar si HttpService está habilitado
    local httpEnabled = pcall(function()
        HttpService:GetAsync("https://httpbin.org/get", true)
    end)
    
    if not httpEnabled then
        warn("[Discord Sync] ❌ HTTP Requests está DESHABILITADO")
        warn("[Discord Sync] 💡 Solución:")
        warn("[Discord Sync]    1. Menú → Game Settings")
        warn("[Discord Sync]    2. Security → Allow HTTP Requests ON")
        return false
    end
    
    local payload = {
        username = "Rozek IA 🎮",
        avatar_url = "https://i.imgur.com/7WNv3tk.png",
        embeds = {{
            title = data.title or "Evento",
            description = data.description or "",
            color = data.color or 5814783,
            fields = data.fields or {},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
            footer = {
                text = "Executor: " .. executor
            }
        }}
    }
    
    local payloadJSON = HttpService:JSONEncode(payload)
    
    if self.Config.debug then
        print("[Discord Sync] 🔍 Intentando enviar a Discord...")
        print("[Discord Sync] Executor:", executor)
        print("[Discord Sync] Webhook:", self.Config.webhookURL:sub(1, 60) .. "...")
    end
    
    -- Intentar envío
    local success, err = pcall(function()
        local response = HttpService:PostAsync(
            self.Config.webhookURL,
            payloadJSON,
            Enum.HttpContentType.ApplicationJson,
            false
        )
        
        if self.Config.debug then
            print("[Discord Sync] Response:", response)
        end
    end)
    
    if success then
        print("[Discord Sync] ✅ Mensaje enviado exitosamente")
        return true
    else
        warn("[Discord Sync] ❌ Error al enviar:", tostring(err))
        
        -- Diagnóstico del error
        local errorStr = tostring(err)
        
        if errorStr:match("Http requests are not enabled") then
            warn("[Discord Sync] 💡 HTTP Requests deshabilitado")
            warn("[Discord Sync] Actívalo en Game Settings → Security")
        elseif errorStr:match("403") or errorStr:match("Forbidden") then
            warn("[Discord Sync] 💡 Webhook inválido o bloqueado")
        elseif errorStr:match("404") then
            warn("[Discord Sync] 💡 Webhook no encontrado (revisa la URL)")
        elseif errorStr:match("429") then
            warn("[Discord Sync] 💡 Límite de mensajes alcanzado (espera 1 minuto)")
        else
            warn("[Discord Sync] 💡 Error desconocido")
        end
        
        return false
    end
end

function DiscordSync:testConexion()
    print("[Discord Sync] 🧪 Iniciando test de conexión...")
    
    local HttpService = game:GetService("HttpService")
    
    -- Test 1: Verificar HttpService
    print("[Discord Sync] Test 1/3: Verificando HttpService...")
    local test1 = pcall(function()
        HttpService:JSONEncode({test = true})
    end)
    print("[Discord Sync] HttpService:", test1 and "✅ OK" or "❌ Error")
    
    -- Test 2: Verificar HTTP habilitado
    print("[Discord Sync] Test 2/3: Verificando HTTP Requests...")
    local test2 = pcall(function()
        HttpService:GetAsync("https://httpbin.org/get", true)
    end)
    print("[Discord Sync] HTTP Requests:", test2 and "✅ Habilitado" or "❌ Deshabilitado")
    
    if not test2 then
        warn("[Discord Sync] ⚠️ HTTP Requests está deshabilitado")
        warn("[Discord Sync] Actívalo en: Game Settings → Security")
        return false
    end
    
    -- Test 3: Enviar a Discord
    print("[Discord Sync] Test 3/3: Enviando a Discord...")
    local test3 = self:enviarWebhook({
        title = "🧪 Test de Conexión",
        description = "Sistema Rozek IA funcionando desde " .. executor,
        color = 3447003,
        fields = {
            {name = "Executor", value = executor, inline = true},
            {name = "Hora", value = os.date("%H:%M:%S"), inline = true},
            {name = "Estado", value = "✅ Operativo", inline = true}
        }
    })
    
    if test3 then
        print("[Discord Sync] ✅ TODOS LOS TESTS PASADOS")
        return true
    else
        warn("[Discord Sync] ❌ Test de Discord falló")
        return false
    end
end

function DiscordSync:registrarConstruccion(usuario, nombreCmd, exito)
    if not self.Config.enabled then return end
    
    usuario = usuario or "Usuario"
    nombreCmd = nombreCmd or "construccion"
    
    -- Log local siempre
    print(string.format("[Discord] 🏗️ %s → %s", usuario, nombreCmd))
    
    -- Intentar envío
    self:enviarWebhook({
        title = "🏗️ Nueva Construcción",
        description = "Se ha creado: **" .. nombreCmd .. "**",
        color = exito and 3066993 or 15158332,
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "🏗️ Comando", value = "`" .. nombreCmd .. "`", inline = true},
            {name = "⚙️ Executor", value = executor, inline = true}
        }
    })
end

-- ============================================================
-- COMANDOS
-- ============================================================

local comandos = {
    discord_test = {
        tipo = "sistema",
        descripcion = "Probar Discord con diagnóstico",
        ejecutar = function()
            if not DiscordSync.Config.enabled then
                return "⚠️ Discord deshabilitado"
            end
            
            local resultado = DiscordSync:testConexion()
            
            if resultado then
                return "✅ TEST EXITOSO\n\nRevisa Discord, debe aparecer un mensaje.\n\nExecutor: " .. executor
            else
                return "❌ TEST FALLIDO\n\nRevisa Output para ver el error.\n\n💡 Soluciones:\n1. Habilitar HTTP Requests\n2. Verificar webhook URL\n3. Revisar internet"
            end
        end
    },
    
    discord_status = {
        tipo = "sistema",
        descripcion = "Estado Discord",
        ejecutar = function()
            local HttpService = game:GetService("HttpService")
            local httpEnabled = pcall(function()
                HttpService:GetAsync("https://httpbin.org/get", true)
            end)
            
            return string.format([[
📊 DISCORD STATUS

Estado: %s
Modo: %s
HTTP Requests: %s
Executor: %s
Debug: %s

Webhook: %s
]], 
                DiscordSync.Config.enabled and "✅ Activo" or "❌ Inactivo",
                DiscordSync.Config.silentMode and "📝 Silencioso" or "📤 Envío",
                httpEnabled and "✅ ON" or "❌ OFF",
                executor,
                DiscordSync.Config.debug and "ON" or "OFF",
                DiscordSync.Config.webhookURL:sub(1, 60) .. "..."
            )
        end
    },
    
    discord_toggle = {
        tipo = "sistema",
        descripcion = "Cambiar modo",
        ejecutar = function()
            DiscordSync.Config.silentMode = not DiscordSync.Config.silentMode
            
            return DiscordSync.Config.silentMode 
                and "📝 Modo silencioso ON" 
                or "📤 Modo envío ON\n\nUsa discord_test para verificar"
        end
    },
    
    discord_debug = {
        tipo = "sistema",
        descripcion = "Toggle debug mode",
        ejecutar = function()
            DiscordSync.Config.debug = not DiscordSync.Config.debug
            return "🔍 Debug: " .. (DiscordSync.Config.debug and "ON" or "OFF")
        end
    },
    
    discord_help = {
        tipo = "sistema",
        descripcion = "Ayuda Discord",
        ejecutar = function()
            return [[
📖 AYUDA DISCORD SYNC

🧪 discord_test
   Test completo con diagnóstico

📊 discord_status
   Ver estado del sistema

🔄 discord_toggle
   Cambiar entre silencioso/envío

🔍 discord_debug
   Activar/desactivar debug

💡 SI NO FUNCIONA:
1. Game Settings → Security
2. Allow HTTP Requests → ON
3. discord_test para verificar
]]
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

local hooks = {
    onInit = function()
        print("[Discord Sync] v1.0.8 - Delta Executor Optimizado")
        print("[Discord Sync] Executor detectado:", executor)
        
        -- Auto-test al iniciar
        task.spawn(function()
            wait(2)
            if not DiscordSync.Config.silentMode then
                print("[Discord Sync] Ejecutando auto-test...")
                DiscordSync:testConexion()
            end
        end)
    end,
    
    onConstruccionCreada = function(nombreCmd, usuario)
        pcall(function()
            DiscordSync:registrarConstruccion(
                usuario or "Usuario",
                nombreCmd or "construccion",
                true
            )
        end)
    end
}

-- ============================================================
-- RETORNO
-- ============================================================

return {
    info = {
        nombre = "Discord_Sync",
        version = "1.0.8",
        autor = "MOFUZII",
        descripcion = "Discord Sync - Delta Executor Optimizado"
    },
    comandos = comandos,
    hooks = hooks,
    modulo = DiscordSync
}
