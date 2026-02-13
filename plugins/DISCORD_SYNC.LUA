-- ============================================================
-- DISCORD_SYNC.LUA v1.0
-- Sistema de sincronización de datos con Discord
-- ============================================================

local DiscordSync = {}

-- ============================================================
-- CONFIGURACIÓN
-- ============================================================

DiscordSync.Config = {
    webhookURL = "", -- URL del webhook de Discord (configurar por usuario)
    enabled = false, -- Se activa cuando hay webhook configurado
    queueInterval = 5, -- Segundos entre envíos
    maxBatchSize = 10, -- Máximo de eventos por lote
    retryAttempts = 3,
    channels = {
        stats = "📊-estadisticas",
        logs = "📝-logs",
        constructions = "🏗️-construcciones",
        errors = "❌-errores",
        users = "👥-usuarios"
    }
}

-- ============================================================
-- COLA DE EVENTOS
-- ============================================================

DiscordSync.Queue = {
    pending = {},
    processing = false
}

-- ============================================================
-- FUNCIÓN: Configurar Webhook
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

-- ============================================================
-- FUNCIÓN: Crear Embed para Discord
-- ============================================================

function DiscordSync:crearEmbed(config)
    local embed = {
        title = config.title or "Evento IA Constructor",
        description = config.description or "",
        color = config.color or 5814783, -- Azul por defecto
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
    
    if config.thumbnail then
        embed.thumbnail = { url = config.thumbnail }
    end
    
    return embed
end

-- ============================================================
-- FUNCIÓN: Enviar a Discord
-- ============================================================

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

-- ============================================================
-- FUNCIÓN: Agregar a Cola
-- ============================================================

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

-- ============================================================
-- FUNCIÓN: Procesar Cola
-- ============================================================

function DiscordSync:procesarCola()
    if self.Queue.processing or #self.Queue.pending == 0 then
        return
    end
    
    self.Queue.processing = true
    
    task.spawn(function()
        while #self.Queue.pending > 0 do
            local lote = {}
            
            -- Tomar hasta maxBatchSize eventos
            for i = 1, math.min(self.Config.maxBatchSize, #self.Queue.pending) do
                table.insert(lote, table.remove(self.Queue.pending, 1))
            end
            
            -- Enviar lote
            for _, item in ipairs(lote) do
                self:enviarWebhook(item.evento, function(success, error)
                    if not success and item.intentos < self.Config.retryAttempts then
                        item.intentos = item.intentos + 1
                        table.insert(self.Queue.pending, item)
                    end
                end)
                
                task.wait(0.5) -- Evitar rate limit
            end
            
            task.wait(self.Config.queueInterval)
        end
        
        self.Queue.processing = false
    end)
end

-- ============================================================
-- EVENTOS ESPECÍFICOS
-- ============================================================

-- Registrar nueva sesión
function DiscordSync:registrarSesion(usuario, stats)
    local embed = self:crearEmbed({
        title = "🎮 Nueva Sesión Iniciada",
        description = "Un usuario ha iniciado Rozek IA",
        color = 3066993, -- Verde
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
            {name = "📊 Total Comandos", value = tostring(stats.totalComandos or 0), inline = true},
            {name = "✅ Exitosos", value = tostring(stats.comandosExitosos or 0), inline = true},
            {name = "❌ Fallidos", value = tostring(stats.comandosFallidos or 0), inline = true},
        }
    })
    
    self:agregarACola(embed)
end

-- Registrar construcción
function DiscordSync:registrarConstruccion(usuario, nombreCmd, parametros, exito)
    local color = exito and 3066993 or 15158332 -- Verde/Rojo
    
    local embed = self:crearEmbed({
        title = exito and "🏗️ Construcción Creada" or "❌ Error en Construcción",
        description = "Comando: `" .. nombreCmd .. "`",
        color = color,
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
            {name = "📝 Parámetros", value = table.concat(parametros, ", ") or "Ninguno", inline = false},
        }
    })
    
    self:agregarACola(embed)
end

-- Registrar estadísticas
function DiscordSync:registrarEstadisticas(stats)
    local embed = self:crearEmbed({
        title = "📊 Estadísticas Actualizadas",
        color = 5814783, -- Azul
        fields = {
            {name = "📈 Total Comandos", value = tostring(stats.totalComandos), inline = true},
            {name = "✅ Exitosos", value = tostring(stats.comandosExitosos), inline = true},
            {name = "❌ Fallidos", value = tostring(stats.comandosFallidos), inline = true},
            {name = "🏗️ Construcciones", value = tostring(stats.construccionesCreadas or 0), inline = true},
            {name = "📅 Desde", value = os.date("%d/%m/%Y", stats.fechaInstalacion), inline = true},
        }
    })
    
    self:agregarACola(embed)
end

-- Registrar error
function DiscordSync:registrarError(usuario, comando, error)
    local embed = self:crearEmbed({
        title = "❌ Error Reportado",
        description = "```\n" .. tostring(error) .. "\n```",
        color = 15158332, -- Rojo
        fields = {
            {name = "👤 Usuario", value = usuario, inline = true},
            {name = "⏰ Hora", value = os.date("%H:%M:%S"), inline = true},
            {name = "📝 Comando", value = comando, inline = false},
        }
    })
    
    self:agregarACola(embed)
end

-- Registrar comando
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

-- ============================================================
-- FUNCIONES DE UTILIDAD
-- ============================================================

function DiscordSync:limpiarCola()
    self.Queue.pending = {}
    print("[Discord Sync] Cola limpiada")
end

function DiscordSync:obtenerEstadoCola()
    return {
        pendientes = #self.Queue.pending,
        procesando = self.Queue.processing,
        habilitado = self.Config.enabled
    }
end

function DiscordSync:desactivar()
    self.Config.enabled = false
    self:limpiarCola()
    print("[Discord Sync] Sincronización desactivada")
end

-- ============================================================
-- COMANDOS PARA INTEGRAR EN DATABASE
-- ============================================================

DiscordSync.Comandos = {
    ["discord_setup"] = {
        tipo = "sistema",
        descripcion = "Configurar webhook de Discord",
        parametros = {"url"},
        ejecutar = function(params)
            if not params or #params == 0 then
                return "Uso: discord_setup [URL_WEBHOOK]"
            end
            
            local url = params[1]
            local exito = DiscordSync:configurarWebhook(url)
            
            if exito then
                return "✅ Discord configurado correctamente. Los datos se sincronizarán automáticamente."
            else
                return "❌ URL de webhook inválida. Obtén una desde: Configuración del servidor > Integraciones > Webhooks"
            end
        end
    },
    
    ["discord_test"] = {
        tipo = "sistema",
        descripcion = "Enviar mensaje de prueba a Discord",
        parametros = {},
        ejecutar = function()
            if not DiscordSync.Config.enabled then
                return "⚠️ Discord no configurado. Usa: discord_setup [URL]"
            end
            
            DiscordSync:enviarWebhook({
                title = "🧪 Mensaje de Prueba",
                description = "Si ves esto, ¡la conexión funciona correctamente!",
                color = 3066993
            }, function(success, msg)
                if success then
                    print("✅ Prueba exitosa")
                else
                    warn("❌ Error: " .. tostring(msg))
                end
            end)
            
            return "📤 Mensaje de prueba enviado. Revisa tu canal de Discord."
        end
    },
    
    ["discord_status"] = {
        tipo = "sistema",
        descripcion = "Ver estado de la sincronización con Discord",
        parametros = {},
        ejecutar = function()
            local estado = DiscordSync:obtenerEstadoCola()
            
            local msg = "📊 ESTADO DE DISCORD SYNC\n\n"
            msg = msg .. "Estado: " .. (estado.habilitado and "✅ Activo" or "❌ Desactivado") .. "\n"
            msg = msg .. "Eventos pendientes: " .. estado.pendientes .. "\n"
            msg = msg .. "Procesando: " .. (estado.procesando and "Sí" or "No") .. "\n"
            
            return msg
        end
    },
    
    ["discord_disable"] = {
        tipo = "sistema",
        descripcion = "Desactivar sincronización con Discord",
        parametros = {},
        ejecutar = function()
            DiscordSync:desactivar()
            return "🔴 Sincronización con Discord desactivada"
        end
    }
}

-- ============================================================
-- HOOKS PARA INTEGRACIÓN
-- ============================================================

DiscordSync.Hooks = {
    onInit = function()
        print("[Discord Sync] Sistema de sincronización cargado")
        print("[Discord Sync] Usa 'discord_setup [URL]' para configurar")
    end,
    
    onConstruccionCreada = function(nombreCmd, usuario, parametros, exito)
        if DiscordSync.Config.enabled then
            DiscordSync:registrarConstruccion(
                usuario or "Desconocido",
                nombreCmd,
                parametros or {},
                exito
            )
        end
    end,
    
    onComandoEjecutado = function(usuario, comando, tipo, exito)
        if DiscordSync.Config.enabled then
            DiscordSync:registrarComando(usuario, comando, tipo, exito)
        end
    end,
    
    onError = function(usuario, comando, error)
        if DiscordSync.Config.enabled then
            DiscordSync:registrarError(usuario, comando, error)
        end
    end,
    
    onEstadisticasActualizadas = function(stats)
        if DiscordSync.Config.enabled and stats.totalComandos % 10 == 0 then
            DiscordSync:registrarEstadisticas(stats)
        end
    end
}

-- ============================================================
-- PLUGIN INFO
-- ============================================================

DiscordSync.info = {
    nombre = "Discord_Sync",
    version = "1.0.0",
    autor = "MOFUZII",
    descripcion = "Sistema de sincronización de datos con Discord",
    comandos = DiscordSync.Comandos,
    hooks = DiscordSync.Hooks
}

return DiscordSync
