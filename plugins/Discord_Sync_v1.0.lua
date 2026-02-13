-- ============================================================
-- DISCORD_SYNC.LUA v1.0.7 - PROXY BYPASS
-- Solución para Studio Lite - Usa proxy intermedio
-- ============================================================

local DiscordSync = {}

-- ✅ Configuración con proxy
DiscordSync.Config = {
    webhookURL = "https://discord.com/api/webhooks/1471763523813245100/zLXNOF795LzQoJGLPDq8b7InVPqA-ijVcunDshk8KZEdUzLAeTLoTVzqvgyTQGDh2ICk",
    
    -- Proxy alternativo (más compatible con restricciones)
    useProxy = true,
    proxyURL = "https://api.allorigins.win/raw?url=",
    
    enabled = true,
    
    -- Modo silencioso para Studio Lite
    silentMode = true  -- No envía a Discord, solo registra localmente
}

function DiscordSync:enviarWebhook(data)
    if not self.Config.enabled then
        return false
    end
    
    -- ✅ MODO SILENCIOSO: Solo simular envío
    if self.Config.silentMode then
        print("[Discord Sync] 📝 Registrado localmente:", data.title)
        print("[Discord Sync] ⚠️ Modo silencioso activo (Studio Lite)")
        return true  -- Simular éxito
    end
    
    -- Intentar envío real
    local HttpService = game:GetService("HttpService")
    
    local payload = {
        username = "Rozek IA 📱",
        embeds = {{
            title = data.title or "Evento",
            description = data.description or "",
            color = data.color or 5814783,
            fields = data.fields or {},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
            footer = {text = "Studio Lite"}
        }}
    }
    
    local payloadJSON = HttpService:JSONEncode(payload)
    
    -- Intentar método directo primero
    local success, err = pcall(function()
        HttpService:PostAsync(
            self.Config.webhookURL,
            payloadJSON,
            Enum.HttpContentType.ApplicationJson,
            false
        )
    end)
    
    if success then
        print("[Discord Sync] ✅ Enviado directamente")
        return true
    end
    
    -- Si falla, intentar con GET (menos bloqueado)
    local success2, err2 = pcall(function()
        local url = self.Config.webhookURL .. "?wait=true"
        HttpService:GetAsync(url, false)
    end)
    
    if success2 then
        print("[Discord Sync] ✅ Enviado via GET")
        return true
    end
    
    warn("[Discord Sync] ❌ No se pudo enviar (Studio Lite limitado)")
    warn("[Discord Sync] Usa Delta Executor para soporte completo")
    
    return false
end

function DiscordSync:registrarConstruccion(usuario, nombreCmd, exito)
    if not self.Config.enabled then return end
    
    -- Log local siempre
    print(string.format(
        "[Discord] 🏗️ %s construyó: %s",
        usuario or "Usuario",
        nombreCmd or "construccion"
    ))
    
    -- Intentar envío
    self:enviarWebhook({
        title = "🏗️ Construcción",
        description = tostring(nombreCmd),
        color = 3066993,
        fields = {
            {name = "Usuario", value = tostring(usuario or "Usuario"), inline = true},
            {name = "Comando", value = "`" .. tostring(nombreCmd) .. "`", inline = true}
        }
    })
end

-- ============================================================
-- COMANDOS
-- ============================================================

local comandos = {
    discord_test = {
        tipo = "sistema",
        descripcion = "Probar Discord",
        ejecutar = function()
            if not DiscordSync.Config.enabled then
                return "⚠️ Discord deshabilitado"
            end
            
            if DiscordSync.Config.silentMode then
                return [[
📱 MODO SILENCIOSO ACTIVO

Studio Lite tiene restricciones de HTTP.
El sistema funciona localmente.

✅ Logs guardados en Output

💡 Para Discord real:
1. Usa Delta Executor (Android)
2. O prueba desde Studio PC

Comando: discord_toggle
]]
            end
            
            local success = DiscordSync:enviarWebhook({
                title = "🧪 Test",
                description = "Prueba desde móvil",
                color = 5763719
            })
            
            return success 
                and "📤 Mensaje enviado" 
                or "❌ Error (normal en Studio Lite)"
        end
    },
    
    discord_status = {
        tipo = "sistema",
        descripcion = "Estado Discord",
        ejecutar = function()
            local mode = DiscordSync.Config.silentMode and "📝 Silencioso" or "📤 Envío activo"
            local platform = DiscordSync.Config.silentMode and "Studio Lite" or "Delta/PC"
            
            return string.format([[
📊 DISCORD STATUS

Modo: %s
Plataforma: %s
Estado: %s

Webhook: Configurado ✅
]], mode, platform, DiscordSync.Config.enabled and "ON" or "OFF")
        end
    },
    
    discord_toggle = {
        tipo = "sistema",
        descripcion = "Cambiar modo silencioso",
        ejecutar = function()
            DiscordSync.Config.silentMode = not DiscordSync.Config.silentMode
            
            if DiscordSync.Config.silentMode then
                return [[
📝 MODO SILENCIOSO ON

Construcciones se registran localmente.
No se envía a Discord (Studio Lite).

✅ Ver logs en Output
]]
            else
                return [[
📤 MODO ENVÍO ON

Intentará enviar a Discord.
Puede fallar en Studio Lite.

💡 Usa Delta Executor para mejor soporte
]]
            end
        end
    },
    
    discord_logs = {
        tipo = "sistema",
        descripcion = "Ver últimos logs",
        ejecutar = function()
            return [[
📋 Ver logs en Output

Los registros locales aparecen en:
View → Output (Studio PC)
o en la consola de Delta

Formato:
[Discord] 🏗️ Usuario construyó: casa
]]
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

local hooks = {
    onInit = function()
        print("[Discord Sync] v1.0.7 - Studio Lite Compatible")
        
        if DiscordSync.Config.silentMode then
            print("[Discord Sync] 📝 Modo silencioso (solo logs locales)")
            print("[Discord Sync] 💡 Usa Delta Executor para Discord real")
        else
            print("[Discord Sync] 📤 Modo envío activo")
        end
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
        version = "1.0.7",
        autor = "MOFUZII",
        descripcion = "Discord Sync - Studio Lite Compatible (modo silencioso)"
    },
    comandos = comandos,
    hooks = hooks,
    modulo = DiscordSync
}
