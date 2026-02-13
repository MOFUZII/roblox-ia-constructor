-- ============================================================
-- DISCORD_SYNC.LUA v1.0.6 - VERSIÓN MÓVIL STUDIO LITE
-- Webhook PRE-CONFIGURADO - No requiere setup
-- ============================================================

local DiscordSync = {}

-- ✅ WEBHOOK PRE-CONFIGURADO
-- Cambia esta URL por la tuya:
DiscordSync.Config = {
    webhookURL = "https://discord.com/api/webhooks/1471763523813245100/zLXNOF795LzQoJGLPDq8b7InVPqA-ijVcunDshk8KZEdUzLAeTLoTVzqvgyTQGDh2ICk",
    enabled = true  -- ✅ Ya activado por defecto
}

function DiscordSync:configurarWebhook(url)
    if not url or url == "" then
        return false, "URL vacía"
    end
    
    url = url:gsub("%s+", "")
    
    if not url:match("^https://discord%.com/api/webhooks/") then
        return false, "URL inválida"
    end
    
    self.Config.webhookURL = url
    self.Config.enabled = true
    
    print("[Discord Sync] ✅ Webhook actualizado")
    
    return true, "OK"
end

function DiscordSync:enviarWebhook(data)
    if not self.Config.enabled then
        print("[Discord Sync] ⚠️ Sistema deshabilitado")
        return false
    end
    
    if self.Config.webhookURL == "" then
        print("[Discord Sync] ❌ No hay webhook")
        return false
    end
    
    local HttpService = game:GetService("HttpService")
    
    local payload = {
        username = "Rozek IA 📱",
        avatar_url = "https://i.imgur.com/7WNv3tk.png",
        embeds = {{
            title = data.title or "Evento",
            description = data.description or "",
            color = data.color or 5814783,
            fields = data.fields or {},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
            footer = {
                text = "Rozek IA v3.3.1 | Studio Lite"
            }
        }}
    }
    
    local success, err = pcall(function()
        HttpService:PostAsync(
            self.Config.webhookURL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson,
            false
        )
    end)
    
    if success then
        print("[Discord Sync] ✅ Mensaje enviado")
    else
        warn("[Discord Sync] ❌ Error:", err)
    end
    
    return success
end

function DiscordSync:registrarConstruccion(usuario, nombreCmd, exito)
    if not self.Config.enabled then return end
    
    usuario = usuario or "Usuario Móvil"
    nombreCmd = nombreCmd or "construccion"
    
    self:enviarWebhook({
        title = "🏗️ Nueva Construcción",
        description = "Creada desde Studio Lite",
        color = exito and 3066993 or 15158332,
        fields = {
            {name = "👤 Usuario", value = tostring(usuario), inline = true},
            {name = "🏗️ Comando", value = "`" .. tostring(nombreCmd) .. "`", inline = true},
            {name = "📱 Plataforma", value = "Studio Lite", inline = true}
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
            
            local success = DiscordSync:enviarWebhook({
                title = "🧪 Test desde Móvil",
                description = "Sistema Rozek IA funcionando en Studio Lite",
                color = 5763719,
                fields = {
                    {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
                    {name = "📱 Dispositivo", value = "Android", inline = true},
                    {name = "✅ Estado", value = "Operativo", inline = true}
                }
            })
            
            if success then
                return "📤 Mensaje enviado\n\n✅ Revisa tu Discord"
            else
                return "❌ Error\n\n⚠️ Verifica:\n1. Internet estable\n2. HTTP Requests ON\n3. Webhook válido"
            end
        end
    },
    
    discord_status = {
        tipo = "sistema",
        descripcion = "Estado Discord",
        ejecutar = function()
            local status = DiscordSync.Config.enabled and "✅ Activo" or "❌ Inactivo"
            local url = DiscordSync.Config.webhookURL
            
            if url ~= "" then
                url = url:sub(1, 60) .. "..."
            else
                url = "No configurado"
            end
            
            return string.format([[
📊 DISCORD STATUS

Estado: %s
Webhook: %s
Plataforma: Studio Lite 📱
]], status, url)
        end
    },
    
    discord_disable = {
        tipo = "sistema",
        descripcion = "Desactivar Discord",
        ejecutar = function()
            DiscordSync.Config.enabled = false
            return "⚠️ Discord desactivado"
        end
    },
    
    discord_enable = {
        tipo = "sistema",
        descripcion = "Activar Discord",
        ejecutar = function()
            DiscordSync.Config.enabled = true
            return "✅ Discord activado"
        end
    },
    
    -- ✅ NUEVO: Cambiar webhook desde el chat (para móvil)
    discord_change = {
        tipo = "sistema",
        descripcion = "Cambiar webhook (solo última parte)",
        ejecutar = function(textoCompleto)
            return [[
📝 Para cambiar el webhook:

1. Edita el archivo Discord_Sync.lua en GitHub
2. Cambia la línea:
   webhookURL = "TU_URL_COMPLETA"
3. Guarda y recarga Rozek

🔗 Tu URL actual:
]] .. DiscordSync.Config.webhookURL:sub(1, 70) .. "..."
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

local hooks = {
    onInit = function()
        print("[Discord Sync] v1.0.6 - Studio Lite (Móvil)")
        
        if DiscordSync.Config.enabled then
            print("[Discord Sync] ✅ Pre-configurado y listo")
            print("[Discord Sync] 📱 Optimizado para Android")
        else
            print("[Discord Sync] ⚠️ Deshabilitado")
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
    end,
    
    onComandoEjecutado = function(comando)
        -- Solo log, no enviar cada comando
        if DiscordSync.Config.enabled and comando then
            -- Opcional: descomentar para log de cada comando
            -- print("[Discord] Comando:", comando)
        end
    end
}

-- ============================================================
-- RETORNO
-- ============================================================

return {
    info = {
        nombre = "Discord_Sync",
        version = "1.0.6",
        autor = "MOFUZII",
        descripcion = "Discord Sync - Studio Lite Mobile"
    },
    comandos = comandos,
    hooks = hooks,
    modulo = DiscordSync
}
