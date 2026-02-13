-- ============================================================
-- SMART_RESPONSES.LUA - Motor de IA Simulada
-- Sistema de respuestas inteligentes SIN necesidad de API externa
-- Versión 1.0.1 - CORRECCIÓN: Manejo seguro de nil
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
    if not texto then return "comando" end
    texto = tostring(texto):lower()
    
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
    
    return "comando"
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
    
    -- ⚠️ CORRECCIÓN: Manejo seguro de variables que pueden ser nil
    if contexto.emoji then
        respuesta = respuesta:gsub("{emoji}", tostring(contexto.emoji))
    end
    
    if contexto.color and contexto.color ~= "" then
        respuesta = respuesta:gsub("{color_msg}", tostring(contexto.color))
    else
        respuesta = respuesta:gsub("{color_msg}", "")
    end
    
    if contexto.count then
        respuesta = respuesta:gsub("{count}", tostring(contexto.count))
    end
    
    if contexto.tipo then
        respuesta = respuesta:gsub("{tipo}", tostring(contexto.tipo))
    end
    
    if contexto.sugerencia then
        respuesta = respuesta:gsub("{sugerencia}", tostring(contexto.sugerencia))
    end
    
    if contexto.ejemplo then
        respuesta = respuesta:gsub("{ejemplo}", tostring(contexto.ejemplo))
    end
    
    if contexto.comando then
        respuesta = respuesta:gsub("{comando}", tostring(contexto.comando))
    end
    
    return respuesta
end

-- ============================================================
-- RESPUESTA PARA CONSTRUCCIÓN
-- ============================================================

function SmartResponses:respuestaConstruccion(nombreCmd, parametros, estadisticas)
    -- ⚠️ CORRECCIÓN: Validar que los parámetros existan
    nombreCmd = nombreCmd or "construccion"
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
    
    -- ⚠️ CORRECCIÓN: Verificar que respuesta no sea nil
    if not respuesta then
        return "🏗️ ¡Construcción completada!"
    end
    
    -- Agregar mensaje contextual si es relevante
    if estadisticas.construccionesCreadas == 1 then
        respuesta = respuesta .. "\n" .. self.Plantillas.contexto.primera_construccion[1]
    elseif estadisticas.construccionesCreadas and estadisticas.construccionesCreadas % 10 == 0 then
        local msg = self.Plantillas.contexto.muchas_construcciones[1]
        msg = msg:gsub("{count}", tostring(estadisticas.construccionesCreadas))
        respuesta = respuesta .. "\n" .. msg
    end
    
    return respuesta
end

-- ============================================================
-- RESPUESTA PARA ANIMACIÓN
-- ============================================================

function SmartResponses:respuestaAnimacion(nombreCmd)
    nombreCmd = nombreCmd or "animacion"
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
    
    -- ⚠️ CORRECCIÓN: Manejo seguro de variables
    if contexto.sugerencia then
        respuesta = respuesta:gsub("{sugerencia}", tostring(contexto.sugerencia))
    end
    if contexto.ejemplo then
        respuesta = respuesta:gsub("{ejemplo}", tostring(contexto.ejemplo))
    end
    if contexto.comando then
        respuesta = respuesta:gsub("{comando}", tostring(contexto.comando))
    end
    
    return respuesta
end

-- ============================================================
-- RESPUESTA INTELIGENTE PRINCIPAL
-- ============================================================

function SmartResponses:obtenerRespuesta(texto, tipoAccion, metadata)
    -- ⚠️ CORRECCIÓN: Validar entrada
    texto = texto or ""
    metadata = metadata or {}
    
    -- Detectar intención
    local intencion = self:detectarIntencion(texto)
    
    -- Si es un saludo, despedida, etc
    if intencion ~= "comando" then
        return self:generar(intencion, metadata) or "✅ Entendido"
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
    -- ⚠️ CORRECCIÓN: Validar entrada
    if not texto then return end
    texto = tostring(texto)
    
    -- Detectar uso de emojis (simplificado para evitar errores de regex)
    if texto:match("[😀-🙏]") or texto:match("[🌀-🗿]") then
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
    -- ⚠️ CORRECCIÓN: Validar que respuesta no sea nil
    if not respuesta then return "✅ Listo" end
    respuesta = tostring(respuesta)
    
    -- Si el usuario no usa emojis, removerlos (simplificado)
    if not self.Aprendizaje.patronesDetectados.usaEmojis then
        respuesta = respuesta:gsub("[😀-🙏]", ""):gsub("[🌀-🗿]", "")
        respuesta = respuesta:gsub("%s+", " "):match("^%s*(.-)%s*$") or respuesta
    end
    
    -- Si el usuario es formal, agregar cortesía
    if self.Aprendizaje.patronesDetectados.esFormal then
        if respuesta:sub(1, 1) ~= "¡" then
            respuesta = "Por supuesto. " .. respuesta
        end
    end
    
    -- Si prefiere brevedad, acortar
    if self.Aprendizaje.patronesDetectados.prefiereBrevedad then
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
