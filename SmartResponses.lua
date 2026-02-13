-- ============================================================
-- SMART_RESPONSES.LUA - Motor de IA Simulada
-- Sistema de respuestas inteligentes SIN necesidad de API externa
-- ============================================================
-- CARACTERÍSTICAS:
-- ✅ Procesamiento de lenguaje natural básico
-- ✅ Respuestas contextuales dinámicas
-- ✅ Aprendizaje del estilo del usuario
-- ✅ Sistema de plantillas inteligentes
-- ✅ Detección de intención
-- ============================================================

local SmartResponses = {}

-- ============================================================
-- BASE DE CONOCIMIENTO
-- ============================================================

SmartResponses.Plantillas = {
    
    -- Saludos
    saludos = {
        entrada = {"hola", "hey", "buenas", "qué tal", "como estas", "hi", "hello"},
        respuestas = {
            "¡Hola! 👋 ¿En qué puedo ayudarte hoy?",
            "¡Hey! Listo para construir algo increíble 🏗️",
            "¡Buenas! ¿Qué vamos a crear?",
            "¡Hola! Aquí estoy para ayudarte ✨",
        }
    },
    
    -- Despedidas
    despedidas = {
        entrada = {"adios", "bye", "chao", "hasta luego", "nos vemos"},
        respuestas = {
            "¡Hasta luego! Fue un placer ayudarte 👋",
            "¡Nos vemos! Vuelve pronto 😊",
            "¡Adiós! Que tengas un buen día ✨",
        }
    },
    
    -- Agradecimientos
    gracias = {
        entrada = {"gracias", "thank you", "thanks", "muchas gracias", "genial", "perfecto"},
        respuestas = {
            "¡De nada! Para eso estoy 😊",
            "¡Un placer ayudarte! ✨",
            "¡Cuando quieras! 👍",
            "¡Siempre a tu servicio! 🎯",
        }
    },
    
    -- Ayuda
    ayuda = {
        entrada = {"ayuda", "help", "que puedes hacer", "comandos", "como funciona"},
        respuestas = {
            "Puedo ayudarte a construir! Prueba:\n• casa roja\n• torre 15 azul\n• castillo\n• rotar rapido\n\nEscribe 'ayuda' para ver todos los comandos disponibles.",
        }
    },
    
    -- Confirmaciones
    confirmacion = {
        entrada = {"ok", "vale", "entendido", "si", "yes", "correcto"},
        respuestas = {
            "Perfecto! ¿Algo más? 😊",
            "Genial! Aquí estoy si necesitas algo más 👍",
            "Listo! ¿Continuamos? ✨",
        }
    },
    
    -- Construcción exitosa
    construccion_exitosa = {
        emojis = {
            casa = "🏠",
            torre = "🗼",
            piramide = "🔺",
            puente = "🌉",
            castillo = "🏰",
            estadio = "🏟️",
            cupula = "⛪",
            default = "🏗️"
        },
        respuestas = {
            "{emoji} ¡Construcción completada!",
            "{emoji} ¡Listo! {color_msg}",
            "{emoji} ¡Hecho! Quedó genial ✨",
            "{emoji} ¡Perfecto! {color_msg}",
        }
    },
    
    -- Colores
    colores = {
        rojo = "🔴 Color rojo aplicado",
        azul = "🔵 Color azul aplicado",
        verde = "🟢 Color verde aplicado",
        amarillo = "🟡 Color amarillo aplicado",
        morado = "🟣 Color morado aplicado",
        default = "Color aplicado"
    },
    
    -- Animaciones
    animaciones = {
        rotar = "🔄 Rotación activada",
        flotar = "☁️ Efecto de flotación activado",
        pulsar = "💓 Pulsación activada",
        orbitar = "🪐 Órbita en marcha",
        arcoiris = "🌈 Efecto arcoiris activado",
    },
    
    -- Errores amigables
    errores = {
        comando_no_encontrado = {
            "🤔 No reconocí ese comando. ¿Quisiste decir '{sugerencia}'?",
            "Hmm, no tengo ese comando. Prueba con 'ayuda' para ver la lista completa.",
            "No encontré '{comando}'. ¿Quizás querías decir '{sugerencia}'?",
        },
        parametro_faltante = {
            "⚠️ Necesito más información. Ejemplo: '{ejemplo}'",
            "Me falta un dato. Prueba así: '{ejemplo}'",
        },
        error_generico = {
            "Ups, algo salió mal 😅 Intenta de nuevo",
            "Error inesperado. ¿Probamos otra vez?",
        }
    },
    
    -- Respuestas contextuales
    contexto = {
        primera_construccion = {
            "¡Excelente primera construcción! 🎉",
            "¡Gran comienzo! Sigue así ⭐",
        },
        muchas_construcciones = {
            "¡Wow! Ya llevas {count} construcciones 🔥",
            "¡Estás en racha! {count} creaciones ✨",
        },
        mismo_tipo = {
            "Veo que te gustan las {tipo} 😊",
            "Otra {tipo} más! Te están quedando geniales",
        }
    }
}

-- ============================================================
-- ANÁLISIS DE INTENCIÓN
-- ============================================================

function SmartResponses:detectarIntencion(texto)
    texto = texto:lower()
    
    -- Saludos
    for _, palabra in ipairs(self.Plantillas.saludos.entrada) do
        if texto:find(palabra) then
            return "saludo"
        end
    end
    
    -- Despedidas
    for _, palabra in ipairs(self.Plantillas.despedidas.entrada) do
        if texto:find(palabra) then
            return "despedida"
        end
    end
    
    -- Gracias
    for _, palabra in ipairs(self.Plantillas.gracias.entrada) do
        if texto:find(palabra) then
            return "agradecimiento"
        end
    end
    
    -- Ayuda
    for _, palabra in ipairs(self.Plantillas.ayuda.entrada) do
        if texto:find(palabra) then
            return "ayuda"
        end
    end
    
    -- Confirmación
    for _, palabra in ipairs(self.Plantillas.confirmacion.entrada) do
        if texto == palabra then
            return "confirmacion"
        end
    end
    
    return "comando" -- Por defecto es un comando
end

-- ============================================================
-- GENERADOR DE RESPUESTAS
-- ============================================================

function SmartResponses:generar(intencion, contexto)
    contexto = contexto or {}
    
    local plantillas = self.Plantillas[intencion]
    if not plantillas or not plantillas.respuestas then
        return nil
    end
    
    -- Seleccionar respuesta aleatoria
    local respuesta = plantillas.respuestas[math.random(#plantillas.respuestas)]
    
    -- Reemplazar variables
    if contexto.emoji then
        respuesta = respuesta:gsub("{emoji}", contexto.emoji)
    end
    if contexto.color then
        respuesta = respuesta:gsub("{color_msg}", contexto.color)
    else
        respuesta = respuesta:gsub("{color_msg}", "")
    end
    if contexto.count then
        respuesta = respuesta:gsub("{count}", tostring(contexto.count))
    end
    if contexto.tipo then
        respuesta = respuesta:gsub("{tipo}", contexto.tipo)
    end
    if contexto.sugerencia then
        respuesta = respuesta:gsub("{sugerencia}", contexto.sugerencia)
    end
    if contexto.ejemplo then
        respuesta = respuesta:gsub("{ejemplo}", contexto.ejemplo)
    end
    if contexto.comando then
        respuesta = respuesta:gsub("{comando}", contexto.comando)
    end
    
    return respuesta
end

-- ============================================================
-- RESPUESTA PARA CONSTRUCCIÓN
-- ============================================================

function SmartResponses:respuestaConstruccion(nombreCmd, parametros, estadisticas)
    parametros = parametros or {}
    estadisticas = estadisticas or {}
    
    local emoji = self.Plantillas.construccion_exitosa.emojis[nombreCmd] 
                 or self.Plantillas.construccion_exitosa.emojis.default
    
    local colorMsg = ""
    if parametros.color then
        colorMsg = self.Plantillas.colores[parametros.color] or self.Plantillas.colores.default
    end
    
    local contexto = {
        emoji = emoji,
        color = colorMsg
    }
    
    local respuesta = self:generar("construccion_exitosa", contexto)
    
    -- Agregar mensaje contextual si es relevante
    if estadisticas.construccionesCreadas == 1 then
        respuesta = respuesta .. "\n" .. self.Plantillas.contexto.primera_construccion[1]
    elseif estadisticas.construccionesCreadas and estadisticas.construccionesCreadas % 10 == 0 then
        local ctx = {count = estadisticas.construccionesCreadas}
        respuesta = respuesta .. "\n" .. self:generar("contexto", ctx)
    end
    
    return respuesta
end

-- ============================================================
-- RESPUESTA PARA ANIMACIÓN
-- ============================================================

function SmartResponses:respuestaAnimacion(nombreCmd)
    return self.Plantillas.animaciones[nombreCmd] or "✨ Animación activada"
end

-- ============================================================
-- RESPUESTA PARA ERROR
-- ============================================================

function SmartResponses:respuestaError(tipoError, contexto)
    contexto = contexto or {}
    
    local plantillas = self.Plantillas.errores[tipoError]
    if not plantillas then
        plantillas = self.Plantillas.errores.error_generico
    end
    
    local respuesta = plantillas[math.random(#plantillas)]
    
    -- Reemplazar variables
    if contexto.sugerencia then
        respuesta = respuesta:gsub("{sugerencia}", contexto.sugerencia)
    end
    if contexto.ejemplo then
        respuesta = respuesta:gsub("{ejemplo}", contexto.ejemplo)
    end
    if contexto.comando then
        respuesta = respuesta:gsub("{comando}", contexto.comando)
    end
    
    return respuesta
end

-- ============================================================
-- RESPUESTA INTELIGENTE PRINCIPAL
-- ============================================================

function SmartResponses:obtenerRespuesta(texto, tipoAccion, metadata)
    metadata = metadata or {}
    
    -- Detectar intención
    local intencion = self:detectarIntencion(texto)
    
    -- Si es un saludo, despedida, etc
    if intencion ~= "comando" then
        return self:generar(intencion, metadata)
    end
    
    -- Si es una construcción
    if tipoAccion == "construccion" then
        return self:respuestaConstruccion(metadata.comando, metadata.parametros, metadata.estadisticas)
    end
    
    -- Si es una animación
    if tipoAccion == "animacion" then
        return self:respuestaAnimacion(metadata.comando)
    end
    
    -- Si es un error
    if tipoAccion == "error" then
        return self:respuestaError(metadata.tipoError, metadata)
    end
    
    -- Respuesta genérica por defecto
    return "✅ Comando ejecutado"
end

-- ============================================================
-- SISTEMA DE APRENDIZAJE SIMPLE
-- ============================================================

SmartResponses.Aprendizaje = {
    comandosMasUsados = {},
    coloresFavoritos = {},
    patronesDetectados = {
        usaEmojis = false,
        esFormal = false,
        prefiereBrevedad = false,
    }
}

function SmartResponses:aprenderDeUsuario(texto)
    -- Detectar uso de emojis
    if texto:match("[\u{1F300}-\u{1F9FF}]") then
        self.Aprendizaje.patronesDetectados.usaEmojis = true
    end
    
    -- Detectar formalidad
    if texto:find("por favor") or texto:find("gracias") or texto:find("usted") then
        self.Aprendizaje.patronesDetectados.esFormal = true
    end
    
    -- Detectar brevedad
    if #texto < 15 then
        self.Aprendizaje.patronesDetectados.prefiereBrevedad = true
    end
end

function SmartResponses:adaptarRespuesta(respuesta)
    -- Si el usuario no usa emojis, removerlos
    if not self.Aprendizaje.patronesDetectados.usaEmojis then
        respuesta = respuesta:gsub("[\u{1F300}-\u{1F9FF}]", ""):gsub("%s+", " "):match("^%s*(.-)%s*$")
    end
    
    -- Si el usuario es formal, agregar cortesía
    if self.Aprendizaje.patronesDetectados.esFormal then
        if respuesta:sub(1, 1) ~= "¡" then
            respuesta = "Por supuesto. " .. respuesta
        end
    end
    
    -- Si prefiere brevedad, acortar
    if self.Aprendizaje.patronesDetectados.prefiereBrevedad then
        -- Remover explicaciones extra
        local lineas = {}
        for linea in respuesta:gmatch("[^\n]+") do
            table.insert(lineas, linea)
            if #lineas >= 2 then break end
        end
        respuesta = table.concat(lineas, "\n")
    end
    
    return respuesta
end

-- ============================================================
-- RETORNAR MÓDULO
-- ============================================================

return SmartResponses
