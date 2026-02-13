-- ============================================================
-- TEACHING PLUGIN v1.0
-- Sistema de Enseñanza - Aprende de ti
-- ============================================================
-- PERMITE AL USUARIO ENSEÑARLE:
-- - Nuevas construcciones personalizadas
-- - Nuevos comandos con código Lua
-- - Alias para comandos existentes
-- - Correcciones y mejoras
-- ============================================================

local TeachingPlugin = {
    info = {
        nombre = "Teaching",
        version = "1.0.0",
        autor = "MOFUZII",
        descripcion = "Sistema para enseñarle cosas nuevas a la IA",
        dependencias = {},
        permisos = {}
    },
    
    comandos = {},
    construcciones = {},
    interceptores = {},
    hooks = {}
}

-- ============================================================
-- ALMACENAMIENTO DE CONOCIMIENTO
-- ============================================================

local ConocimientoAprendido = {
    comandosPersonalizados = {},
    construccionesPersonalizadas = {},
    aliasComandos = {},
    correcciones = {},
    totalEnseñanzas = 0
}

local ModoEnseñanza = {
    activo = false,
    esperandoTipo = nil, -- "comando", "construccion", "alias"
    esperandoNombre = nil,
    esperandoCodigo = nil,
    pasoActual = 1
}

-- ============================================================
-- FUNCIONES DE ENSEÑANZA
-- ============================================================

local function activarModoEnseñanza(tipo)
    ModoEnseñanza.activo = true
    ModoEnseñanza.esperandoTipo = tipo
    ModoEnseñanza.pasoActual = 1
    
    if tipo == "comando" then
        return "📚 MODO ENSEÑANZA: Nuevo Comando\n\n" ..
               "Paso 1/3: ¿Cómo se llamará el comando?\n" ..
               "Ejemplo: 'escultura', 'monumento', 'jardin'\n\n" ..
               "Escribe el nombre:"
    elseif tipo == "construccion" then
        return "📚 MODO ENSEÑANZA: Nueva Construcción\n\n" ..
               "Paso 1/4: ¿Cómo se llamará?\n" ..
               "Ejemplo: 'templo', 'faro', 'fuente'\n\n" ..
               "Escribe el nombre:"
    elseif tipo == "alias" then
        return "📚 MODO ENSEÑANZA: Nuevo Alias\n\n" ..
               "Paso 1/2: ¿Qué comando existente quieres renombrar?\n" ..
               "Ejemplo: 'casa' → 'hogar'\n\n" ..
               "Escribe el comando original:"
    end
end

local function procesarPasoEnseñanza(entrada)
    if not ModoEnseñanza.activo then
        return nil
    end
    
    if ModoEnseñanza.esperandoTipo == "comando" then
        if ModoEnseñanza.pasoActual == 1 then
            -- Guardar nombre
            ModoEnseñanza.esperandoNombre = entrada
            ModoEnseñanza.pasoActual = 2
            return "✅ Nombre: '" .. entrada .. "'\n\n" ..
                   "Paso 2/3: ¿Qué descripción tiene?\n" ..
                   "Ejemplo: 'Crea una escultura artística'\n\n" ..
                   "Escribe la descripción:"
        elseif ModoEnseñanza.pasoActual == 2 then
            -- Guardar descripción
            ModoEnseñanza.esperandoDescripcion = entrada
            ModoEnseñanza.pasoActual = 3
            return "✅ Descripción guardada\n\n" ..
                   "Paso 3/3: Escribe el código Lua\n" ..
                   "Puedes usar Instance.new, Vector3, etc.\n" ..
                   "Ejemplo:\n" ..
                   "local p = Instance.new('Part')\n" ..
                   "p.Size = Vector3.new(10,10,10)\n" ..
                   "p.Position = Vector3.new(0,5,0)\n" ..
                   "p.BrickColor = BrickColor.new('Bright red')\n" ..
                   "p.Anchored = true\n" ..
                   "p.Parent = workspace\n\n" ..
                   "Escribe el código:"
        elseif ModoEnseñanza.pasoActual == 3 then
            -- Guardar código y finalizar
            local nombre = ModoEnseñanza.esperandoNombre
            local descripcion = ModoEnseñanza.esperandoDescripcion
            local codigo = entrada
            
            -- Validar código
            local fn, err = loadstring(codigo)
            if not fn then
                return "❌ ERROR en el código:\n" .. tostring(err) .. "\n\n" ..
                       "Intenta de nuevo o escribe 'cancelar'"
            end
            
            -- Guardar comando
            ConocimientoAprendido.comandosPersonalizados[nombre] = {
                descripcion = descripcion,
                codigo = codigo,
                aprendidoEn = os.time()
            }
            ConocimientoAprendido.totalEnseñanzas = ConocimientoAprendido.totalEnseñanzas + 1
            
            -- Resetear modo
            ModoEnseñanza.activo = false
            ModoEnseñanza.esperandoNombre = nil
            ModoEnseñanza.esperandoDescripcion = nil
            ModoEnseñanza.pasoActual = 1
            
            return "🎉 ¡APRENDIDO!\n\n" ..
                   "Comando: '" .. nombre .. "'\n" ..
                   "Descripción: " .. descripcion .. "\n\n" ..
                   "Ahora puedes usar: " .. nombre .. "\n" ..
                   "Total enseñanzas: " .. ConocimientoAprendido.totalEnseñanzas
        end
        
    elseif ModoEnseñanza.esperandoTipo == "alias" then
        if ModoEnseñanza.pasoActual == 1 then
            -- Verificar que el comando existe
            -- (esto se hará en el Core)
            ModoEnseñanza.esperandoNombre = entrada
            ModoEnseñanza.pasoActual = 2
            return "✅ Comando original: '" .. entrada .. "'\n\n" ..
                   "Paso 2/2: ¿Cómo quieres llamarlo ahora?\n" ..
                   "Ejemplo: 'hogar', 'edificio', 'vivienda'\n\n" ..
                   "Escribe el nuevo nombre:"
        elseif ModoEnseñanza.pasoActual == 2 then
            local original = ModoEnseñanza.esperandoNombre
            local nuevoNombre = entrada
            
            ConocimientoAprendido.aliasComandos[nuevoNombre] = original
            ConocimientoAprendido.totalEnseñanzas = ConocimientoAprendido.totalEnseñanzas + 1
            
            ModoEnseñanza.activo = false
            ModoEnseñanza.esperandoNombre = nil
            ModoEnseñanza.pasoActual = 1
            
            return "🎉 ¡ALIAS CREADO!\n\n" ..
                   "'" .. nuevoNombre .. "' → '" .. original .. "'\n\n" ..
                   "Ahora puedes usar: " .. nuevoNombre
        end
    end
end

local function ejecutarComandoPersonalizado(nombre)
    local cmd = ConocimientoAprendido.comandosPersonalizados[nombre]
    if cmd then
        return cmd.codigo
    end
    return nil
end

local function resolverAlias(nombre)
    return ConocimientoAprendido.aliasComandos[nombre]
end

-- ============================================================
-- COMANDOS
-- ============================================================

TeachingPlugin.comandos = {
    
    ["enseñanza"] = {
        tipo = "sistema",
        descripcion = "Activar modo enseñanza",
        parametros = {"tipo"},
        ejemplos = {"enseñanza comando", "enseñanza alias"},
        categoria = "Sistema",
        ejecutar = function(params)
            if not params or #params == 0 then
                return "📚 MODO ENSEÑANZA\n\n" ..
                       "Puedes enseñarme:\n\n" ..
                       "• enseñanza comando - Crear nuevo comando\n" ..
                       "• enseñanza alias - Renombrar comando existente\n\n" ..
                       "Total de cosas aprendidas: " .. ConocimientoAprendido.totalEnseñanzas
            end
            
            local tipo = params[1]:lower()
            
            if tipo == "comando" or tipo == "cmd" then
                return activarModoEnseñanza("comando")
            elseif tipo == "alias" or tipo == "renombrar" then
                return activarModoEnseñanza("alias")
            else
                return "❌ Tipo no reconocido\n\n" ..
                       "Usa: enseñanza comando | enseñanza alias"
            end
        end
    },
    
    ["cancelar"] = {
        tipo = "sistema",
        descripcion = "Cancelar el modo enseñanza actual",
        parametros = {},
        ejemplos = {"cancelar"},
        categoria = "Sistema",
        ejecutar = function()
            if not ModoEnseñanza.activo then
                return "No hay nada que cancelar"
            end
            
            ModoEnseñanza.activo = false
            ModoEnseñanza.esperandoNombre = nil
            ModoEnseñanza.esperandoDescripcion = nil
            ModoEnseñanza.pasoActual = 1
            
            return "❌ Modo enseñanza cancelado"
        end
    },
    
    ["aprendido"] = {
        tipo = "sistema",
        descripcion = "Ver todo lo que has enseñado",
        parametros = {},
        ejemplos = {"aprendido", "mis enseñanzas"},
        categoria = "Sistema",
        ejecutar = function()
            local msg = "📚 LO QUE HE APRENDIDO\n"
            msg = msg .. "━━━━━━━━━━━━━━━━━━━━━━\n\n"
            
            -- Comandos personalizados
            local countCmds = 0
            for nombre, _ in pairs(ConocimientoAprendido.comandosPersonalizados) do
                countCmds = countCmds + 1
            end
            
            if countCmds > 0 then
                msg = msg .. "🔧 COMANDOS PERSONALIZADOS (" .. countCmds .. "):\n"
                for nombre, data in pairs(ConocimientoAprendido.comandosPersonalizados) do
                    msg = msg .. "  • " .. nombre .. " - " .. data.descripcion .. "\n"
                end
                msg = msg .. "\n"
            end
            
            -- Alias
            local countAlias = 0
            for _, _ in pairs(ConocimientoAprendido.aliasComandos) do
                countAlias = countAlias + 1
            end
            
            if countAlias > 0 then
                msg = msg .. "🔗 ALIAS (" .. countAlias .. "):\n"
                for nuevo, original in pairs(ConocimientoAprendido.aliasComandos) do
                    msg = msg .. "  • " .. nuevo .. " → " .. original .. "\n"
                end
                msg = msg .. "\n"
            end
            
            if countCmds == 0 and countAlias == 0 then
                msg = msg .. "Aún no me has enseñado nada.\n\n"
                msg = msg .. "Usa: enseñanza comando\n"
                msg = msg .. "O: enseñanza alias"
            else
                msg = msg .. "Total enseñanzas: " .. ConocimientoAprendido.totalEnseñanzas
            end
            
            return msg
        end
    },
    
    ["olvidar"] = {
        tipo = "sistema",
        descripcion = "Olvidar un comando o alias aprendido",
        parametros = {"nombre"},
        ejemplos = {"olvidar micomando"},
        categoria = "Sistema",
        ejecutar = function(params)
            if not params or #params == 0 then
                return "❌ Especifica qué olvidar\n\nUso: olvidar <nombre>"
            end
            
            local nombre = params[1]
            
            if ConocimientoAprendido.comandosPersonalizados[nombre] then
                ConocimientoAprendido.comandosPersonalizados[nombre] = nil
                return "🗑️ Comando '" .. nombre .. "' olvidado"
            elseif ConocimientoAprendido.aliasComandos[nombre] then
                ConocimientoAprendido.aliasComandos[nombre] = nil
                return "🗑️ Alias '" .. nombre .. "' olvidado"
            else
                return "❌ No encontré nada llamado '" .. nombre .. "'"
            end
        end
    }
}

-- ============================================================
-- INTERCEPTORES
-- ============================================================

TeachingPlugin.interceptores = {
    
    preEjecucion = function(nombreComando, parametros, Database)
        -- Si estamos en modo enseñanza, procesar el paso
        if ModoEnseñanza.activo then
            local mensaje = procesarPasoEnseñanza(nombreComando)
            if mensaje then
                return mensaje
            end
        end
        
        -- Resolver alias
        local comandoReal = resolverAlias(nombreComando)
        if comandoReal then
            -- Reemplazar comando con el original
            return nil, comandoReal
        end
        
        -- Ejecutar comando personalizado
        local codigo = ejecutarComandoPersonalizado(nombreComando)
        if codigo then
            return nil, nil, codigo
        end
        
        return nil
    end
}

-- ============================================================
-- HOOKS
-- ============================================================

TeachingPlugin.hooks = {
    
    onInit = function()
        print("[Teaching] 📚 Sistema de enseñanza iniciado")
        print("[Teaching] Puedes enseñarme con: enseñanza comando")
    end,
    
    onComandoEjecutado = function(nombre, params)
        -- Registrar uso de comandos aprendidos
        if ConocimientoAprendido.comandosPersonalizados[nombre] then
            print("[Teaching] ✅ Usando comando aprendido: " .. nombre)
        end
    end
}

-- ============================================================
-- FUNCIONES PÚBLICAS
-- ============================================================

TeachingPlugin.getModoEnseñanza = function()
    return ModoEnseñanza.activo
end

TeachingPlugin.getConocimiento = function()
    return ConocimientoAprendido
end

-- ============================================================
-- RETORNAR PLUGIN
-- ============================================================

return TeachingPlugin

