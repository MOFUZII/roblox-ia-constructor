-- ============================================================
-- DISCORD_SYNC.LUA v1.0.5 - SOLUCIÓN SIMPLE
-- Usa variable global ROZEK_DISCORD_WEBHOOK
-- ============================================================
-- INSTRUCCIONES DE USO:
-- 1. Pega este código en Discord_Sync.lua
-- 2. En Roblox Studio, ANTES de ejecutar el sistema, ejecuta:
--    _G.ROZEK_DISCORD_WEBHOOK = "https://discord.com/api/webhooks/TU_URL"
-- 3. Luego ejecuta CORE_IA normalmente
-- ============================================================

local DiscordSync = {}

-- ✅ Buscar webhook en variable global primero
DiscordSync.Config = {
    webhookURL = _G.ROZEK_DISCORD_WEBHOOK or "",
    enabled = (_G.ROZEK_DISCORD_WEBHOOK ~= nil and _G.ROZEK_DISCORD_WEBHOOK ~= "")
}

function DiscordSync:configurarWebhook(url)
    if not url or url == "" then
        return false, "URL vacía"
    end
    
    -- Limpiar URL (remover espacios, saltos de línea)
    url = url:gsub("%s+", "")
    
    if not url:match("^https://discord%.com/api/webhooks/") then
        return false, "URL inválida - debe empezar con https://discord.com/api/webhooks/"
    end
    
    self.Config.webhookURL = url
    self.Config.enabled = true
    _G.ROZEK_DISCORD_WEBHOOK = url  -- Guardar en global
    
    print("[Discord Sync] ✅ Webhook configurado")
    print("[Discord Sync] URL:", url:sub(1, 60) .. "...")
    
    return true, "OK"
end

function DiscordSync:enviarWebhook(data)
    if not self.Config.enabled then
        print("[Discord Sync] ⚠️ Sistema deshabilitado")
        return false
    end
    
    if self.Config.webhookURL == "" then
        print("[Discord Sync] ❌ No hay webhook configurado")
        return false
    end
    
    local HttpService = game:GetService("HttpService")
    
    local payload = {
        username = "Rozek IA",
        embeds = {{
            title = data.title or "Evento",
            description = data.description or "",
            color = data.color or 5814783,
            fields = data.fields or {},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }
    
    local success, err = pcall(function()
        local response = HttpService:PostAsync(
            self.Config.webhookURL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson,
            false
        )
        print("[Discord Sync] Response:", response)
    end)
    
    if success then
        print("[Discord Sync] ✅ Mensaje enviado correctamente")
    else
        print("[Discord Sync] ❌ Error al enviar:", tostring(err))
    end
    
    return success
end

function DiscordSync:registrarConstruccion(usuario, nombreCmd, exito)
    if not self.Config.enabled then return end
    
    usuario = usuario or "Desconocido"
    nombreCmd = nombreCmd or "construccion"
    
    self:enviarWebhook({
        title = "🏗️ Nueva Construcción",
        description = "Se ha creado una construcción en Rozek IA",
        color = exito and 3066993 or 15158332,
        fields = {
            {name = "👤 Usuario", value = tostring(usuario), inline = true},
            {name = "🏗️ Comando", value = "`" .. tostring(nombreCmd) .. "`", inline = true},
            {name = "✅ Estado", value = exito and "Exitoso" or "Error", inline = true}
        }
    })
end

-- ============================================================
-- COMANDOS
-- ============================================================

local comandos = {
    -- ✅ MÉTODO 1: Setup con URL completa pegada
    discord_setup = {
        tipo = "sistema",
        descripcion = "Configurar Discord webhook",
        ejecutar = function(textoCompleto, palabras)
            -- Intentar extraer URL del texto
            local url = textoCompleto:match("discord_setup%s+(.+)")
            
            if not url then
                return [[
❌ Uso incorrecto

📋 MÉTODO RECOMENDADO:
1. Ejecuta esto ANTES de cargar Rozek:

_G.ROZEK_DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1471763523813245100/zLXNOF795LzQoJGLPDq8b7InVPqA-ijVcunDshk8KZEdUzLAeTLoTVzqvgyTQGDh2ICk"

2. Luego ejecuta CORE_IA normalmente
3. Discord estará pre-configurado

📋 MÉTODO ALTERNATIVO:
Usa: discord_setup_manual
]]
            end
            
            local ok, msg = DiscordSync:configurarWebhook(url)
            
            if ok then
                return "✅ Discord configurado\n\n📤 Prueba con: discord_test"
            else
                return "❌ Error: " .. msg
            end
        end
    },
    
    -- ✅ MÉTODO 2: Setup manual con prompt
    discord_setup_manual = {
        tipo = "sistema",
        descripcion = "Configurar Discord (método manual)",
        ejecutar = function()
            return [[
📋 CONFIGURACIÓN MANUAL DE DISCORD

Ejecuta este código en la consola de Roblox:

_G.ROZEK_DISCORD_WEBHOOK = "TU_URL_COMPLETA_AQUI"

Luego recarga Rozek IA.

🔗 Tu URL:
https://discord.com/api/webhooks/1471763523813245100/zLXNOF795LzQoJGLPDq8b7InVPqA-ijVcunDshk8KZEdUzLAeTLoTVzqvgyTQGDh2ICk
]]
        end
    },
    
    discord_test = {
        tipo = "sistema",
        descripcion = "Probar conexión Discord",
        ejecutar = function()
            if not DiscordSync.Config.enabled then
                return [[
⚠️ Discord no configurado

Ejecuta primero:
_G.ROZEK_DISCORD_WEBHOOK = "TU_URL"

O usa: discord_setup_manual
]]
            end
            
            local success = DiscordSync:enviarWebhook({
                title = "🧪 Test de Conexión",
                description = "Sistema Rozek IA funcionando correctamente",
                color = 5763719,
                fields = {
                    {name = "⏰ Timestamp", value = os.date("%H:%M:%S"), inline = true},
                    {name = "📊 Estado", value = "✅ Operativo", inline = true}
                }
            })
            
            return success 
                and "📤 Mensaje enviado\n\n✅ Revisa Discord" 
                or "❌ Error al enviar\n\n⚠️ Verifica HTTP Requests en Settings"
        end
    },
    
    discord_status = {
        tipo = "sistema",
        descripcion = "Ver estado Discord",
        ejecutar = function()
            local status = DiscordSync.Config.enabled and "✅ Activo" or "❌ Inactivo"
            local url = DiscordSync.Config.webhookURL
            
            if url ~= "" then
                url = url:sub(1, 70) .. "..."
            else
                url = "No configurado"
            end
            
            return string.format([[
📊 DISCORD SYNC STATUS

Estado: %s
Webhook: %s

_G variable: %s
]], status, url, _G.ROZEK_DISCORD_WEBHOOK and "✅ Definida" or "❌ No definida")
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

local hooks = {
    onInit = function()
        print("[Discord Sync] v1.0.5 - Método de variable global")
        
        if DiscordSync.Config.enabled then
            print("[Discord Sync] ✅ Webhook pre-configurado desde _G")
        else
            print("[Discord Sync] ⚠️ Sin configurar - usa _G.ROZEK_DISCORD_WEBHOOK")
        end
    end,
    
    onConstruccionCreada = function(nombreCmd, usuario)
        pcall(function()
            DiscordSync:registrarConstruccion(usuario or "Usuario", nombreCmd or "construccion", true)
        end)
    end
}

-- ============================================================
-- RETORNO
-- ============================================================

return {
    info = {
        nombre = "Discord_Sync",
        version = "1.0.5",
        autor = "MOFUZII",
        descripcion = "Discord Sync con variable global _G"
    },
    comandos = comandos,
    hooks = hooks,
    modulo = DiscordSync
}
