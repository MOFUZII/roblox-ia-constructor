-- ============================================================
-- DISCORD_SYNC.LUA v1.0.1 - CORREGIDO
-- Sistema de sincronización de datos con Discord
-- ============================================================

local DiscordSync = {}

-- ============================================================
-- CONFIGURACIÓN
-- ============================================================

DiscordSync.Config = {
    webhookURL = "",
    enabled = false,
    queueInterval = 5,
    maxBatchSize = 10,
    retryAttempts = 3,
}

DiscordSync.Queue = {
    pending = {},
    processing = false
}

-- ============================================================
-- FUNCIONES PRINCIPALES
-- ============================================================

function DiscordSync:configurarWebhook(url)
    if not url or url == "" then
        warn("[Discord Sync] URL de webhook vacía")
        return false
    end
    
    if not url:match("^https://discord%.com/api/webhooks/") and 
       not url:match("^https://discordapp%.com/api/webhooks/") then
        warn("[Discord Sync] URL de webhook inválida")
        return false
    end
    
    self.Config.webhookURL = url
    self.Config.enabled = true
    print("[Discord Sync] ✅ Webhook configurado correctamente")
    return true
end

function DiscordSync:crearEmbed(config)
    local embed = {
        title = config.title or "Evento IA Constructor",
        description = config.description or "",
        color = config.color or 5814783,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
        footer = {
            text = "Rozek IA v3.3"
        },
        fields = {}
    }
    
    if config.fields then
        for _, field in ipairs(config.fields) do
            table.insert(embed.fields, {
                name = field.name,
                value = field.value,
                inline = field.inline or false
            })
        end
    end
    
    return embed
end

function DiscordSync:enviarWebhook(data, callback)
    if not self.Config.enabled then
        if callback then callback(false, "Webhook no configurado") end
        return
    end
    
    local HttpService = game:GetService("HttpService")
    
    local payload = {
        username = "Rozek IA",
        avatar_url = "https://via.placeholder.com/128/7c68ff/ffffff?text=R",
        embeds = type(data.embeds) == "table" and data.embeds or {data}
    }
    
    local success, result = pcall(function()
        return HttpService:PostAsync(
            self.Config.webhookURL,
            HttpService:JSONEncode(payload),
            Enum.HttpContentType.ApplicationJson,
            false
        )
    end)
    
    if success then
        print("[Discord Sync] ✅ Datos enviados a Discord")
        if callback then callback(true, result) end
    else
        warn("[Discord Sync] ❌ Error al enviar: " .. tostring(result))
        if callback then callback(false, result) end
    end
end

function DiscordSync:agregarACola(evento)
    table.insert(self.Queue.pending, {
        evento = evento,
        timestamp = tick(),
        intentos = 0
    })
    
    if not self.Queue.processing then
        self:procesarCola()
    end
end

function DiscordSync:procesarCola()
    if self.Queue.processing or #self.Queue.pending == 0 then
        return
    end
    
    self.Queue.processing = true
    
    task.spawn(function()
        while #self.Queue.pending > 0 do
            local lote = {}
            
            for i = 1, math.min(self.Config.maxBatchSize, #self.Queue.pending) do
                table.insert(lote, table.remove(self.Queue.pending, 1))
            end
            
            for _, item in ipairs(lote) do
                self:enviarWebhook(item.evento, function(success, error)
                    if not success and item.intentos < self.Config.retryAttempts then
                        item.intentos = item.intentos + 1
                        table.insert(self.Queue.pending, item)
                    end
                end)
                
                task.wait(0.5)
            end
            
            task.wait(self.Config.queueInterval)
        end
        
        self.Queue.processing = false
    end)
end

function DiscordSync:registrarConstruccion(usuario, nombreCmd, parametros, exito)
    local color = exito and 3066993 or 15158332
    
    local embed = self:crearEmbed({
        title = exito and "🏗️ Construcción Creada" or "❌ Error en Construcción",
        description = "Comando: `" .. nombreCmd .. "`",
        color = color,
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
            {name = "📝 Parámetros", value = #parametros > 0 and table.concat(parametros, ", ") or "Ninguno", inline = false},
        }
    })
    
    self:agregarACola(embed)
end

function DiscordSync:registrarComando(usuario, comando, tipoComando, exito)
    local embed = self:crearEmbed({
        title = "📝 Comando Ejecutado",
        description = "`" .. comando .. "`",
        color = exito and 3066993 or 15158332,
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "🔖 Tipo", value = tipoComando, inline = true},
            {name = "✅ Estado", value = exito and "Exitoso" or "Fallido", inline = true},
        }
    })
    
    self:agregarACola(embed)
end

function DiscordSync:registrarError(usuario, comando, error)
    local embed = self:crearEmbed({
        title = "❌ Error Reportado",
        description = "```\n" .. tostring(error) .. "\n```",
        color = 15158332,
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
            {name = "📝 Comando", value = comando, inline = false},
        }
    })
    
    self:agregarACola(embed)
end

-- ============================================================
-- COMANDOS DEL PLUGIN
-- ============================================================

local comandos = {
    discord_setup = {
        tipo = "sistema",
        descripcion = "Configurar webhook de Discord",
        parametros = {"url"},
        categoria = "discord",
        ejecutar = function(params)
            if not params or #params < 2 then
                return "Uso: discord_setup [URL_WEBHOOK]"
            end
            
            local url = params[2]
            local exito = DiscordSync:configurarWebhook(url)
            
            if exito then
                return "✅ Discord configurado. Los datos se sincronizarán automáticamente."
            else
                return "❌ URL inválida. Obtén una desde: Servidor > Integraciones > Webhooks"
            end
        end
    },
    
    discord_test = {
        tipo = "sistema",
        descripcion = "Enviar mensaje de prueba a Discord",
        parametros = {},
        categoria = "discord",
        ejecutar = function()
            if not DiscordSync.Config.enabled then
                return "⚠️ Discord no configurado. Usa: discord_setup [URL]"
            end
            
            DiscordSync:enviarWebhook({
                title = "🧪 Mensaje de Prueba",
                description = "¡La conexión funciona correctamente!",
                color = 3066993
            })
            
            return "📤 Mensaje enviado. Revisa Discord."
        end
    },
    
    discord_status = {
        tipo = "sistema",
        descripcion = "Ver estado de Discord Sync",
        parametros = {},
        categoria = "discord",
        ejecutar = function()
            local msg = "📊 DISCORD SYNC\n\n"
            msg = msg .. "Estado: " .. (DiscordSync.Config.enabled and "✅ Activo" or "❌ Desactivado") .. "\n"
            msg = msg .. "Eventos pendientes: " .. #DiscordSync.Queue.pending .. "\n"
            msg = msg .. "Procesando: " .. (DiscordSync.Queue.processing and "Sí" or "No")
            
            return msg
        end
    },
    
    discord_disable = {
        tipo = "sistema",
        descripcion = "Desactivar Discord Sync",
        parametros = {},
        categoria = "discord",
        ejecutar = function()
            DiscordSync.Config.enabled = false
            DiscordSync.Queue.pending = {}
            return "🔴 Discord Sync desactivado"
        end
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

local hooks = {
    onInit = function()
        print("[Discord Sync] ✅ Sistema cargado")
        print("[Discord Sync] Usa 'discord_setup [URL]' para configurar")
    end,
    
    onConstruccionCreada = function(nombreCmd, usuario, parametros, exito)
        if DiscordSync.Config.enabled then
            DiscordSync:registrarConstruccion(
                usuario or "Desconocido",
                nombreCmd,
                parametros or {},
                exito or true
            )
        end
    end,
    
    onComandoEjecutado = function(usuario, comando, tipo, exito)
        if DiscordSync.Config.enabled then
            DiscordSync:registrarComando(
                usuario or "Desconocido",
                comando,
                tipo or "sistema",
                exito or false
            )
        end
    end,
    
    onError = function(usuario, comando, error)
        if DiscordSync.Config.enabled then
            DiscordSync:registrarError(
                usuario or "Desconocido",
                comando or "desconocido",
                error
            )
        end
    end
}

-- ============================================================
-- RETORNAR PLUGIN
-- ============================================================

return {
    info = {
        nombre = "Discord_Sync",
        version = "1.0.1",
        autor = "MOFUZII",
        descripcion = "Sincronización con Discord"
    },
    comandos = comandos,
    hooks = hooks
}
