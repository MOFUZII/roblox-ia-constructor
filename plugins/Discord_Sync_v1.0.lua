-- ============================================================
-- DISCORD_SYNC.LUA v1.0.2 - ULTRA SIMPLIFICADO
-- Sistema de sincronización de datos con Discord
-- ============================================================

local DiscordSync = {}

DiscordSync.Config = {
    webhookURL = "",
    enabled = false
}

function DiscordSync:configurarWebhook(url)
    if not url or url == "" then
        return false, "URL vacía"
    end
    
    if not url:match("^https://discord") then
        return false, "URL inválida"
    end
    
    self.Config.webhookURL = url
    self.Config.enabled = true
    return true, "OK"
end

function DiscordSync:enviarWebhook(data)
    if not self.Config.enabled then
        return false
    end
    
    local HttpService = game:GetService("HttpService")
    
    local payload = {
        username = "Rozek IA",
        embeds = {{
            title = data.title or "Evento",
            description = data.description or "",
            color = data.color or 5814783,
            fields = data.fields or {}
        }}
    }
    
    pcall(function()
        HttpService:PostAsync(
            self.Config.webhookURL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson,
            false
        )
    end)
    
    return true
end

function DiscordSync:registrarConstruccion(usuario, nombreCmd, exito)
    if not self.Config.enabled then return end
    
    self:enviarWebhook({
        title = "🏗️ Construcción Creada",
        description = "Comando: " .. nombreCmd,
        color = 3066993,
        fields = {
            {name = "Usuario", value = usuario, inline = true},
            {name = "Comando", value = nombreCmd, inline = true}
        }
    })
end

-- ============================================================
-- COMANDOS
-- ============================================================

local comandos = {
    discord_setup = {
        tipo = "sistema",
        descripcion = "Configurar Discord",
        ejecutar = function(palabras)
            -- Reconstruir URL desde las palabras
            local url = ""
            for i = 2, #palabras do
                url = url .. palabras[i]
            end
            
            if url == "" then
                return "Uso: discord_setup [URL_WEBHOOK]"
            end
            
            local ok, msg = DiscordSync:configurarWebhook(url)
            
            if ok then
                return "✅ Discord configurado correctamente"
            else
                return "❌ Error: " .. msg
            end
        end
    },
    
    discord_test = {
        tipo = "sistema",
        descripcion = "Probar Discord",
        ejecutar = function()
            if not DiscordSync.Config.enabled then
                return "⚠️ Discord no configurado"
            end
            
            DiscordSync:enviarWebhook({
                title = "🧪 Prueba",
                description = "¡Funciona!",
                color = 3066993
            })
            
            return "📤 Mensaje enviado a Discord"
        end
    },
    
    discord_status = {
        tipo = "sistema",
        descripcion = "Estado de Discord",
        ejecutar = function()
            return "Estado: " .. (DiscordSync.Config.enabled and "✅ Activo" or "❌ Desactivado")
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

local hooks = {
    onInit = function()
        print("[Discord Sync] Sistema cargado")
    end,
    
    onConstruccionCreada = function(nombreCmd, usuario)
        DiscordSync:registrarConstruccion(usuario or "Usuario", nombreCmd, true)
    end
}

-- ============================================================
-- RETORNO
-- ============================================================

return {
    info = {
        nombre = "Discord_Sync",
        version = "1.0.2",
        autor = "MOFUZII",
        descripcion = "Discord Sync"
    },
    comandos = comandos,
    hooks = hooks
}
