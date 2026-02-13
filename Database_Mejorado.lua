-- ============================================================
-- DATABASE_MEJORADO.LUA - Base de Conocimiento COMPLETA
-- Versión 2.1 - Con TODAS las construcciones implementadas
-- ============================================================

local Database = {}

-- ============================================================
-- COMANDOS PREDEFINIDOS
-- ============================================================

Database.Comandos = {
    -- Construcciones básicas
    ["casa"] = {
        tipo = "construccion",
        descripcion = "Construye una casa con paredes, techo y puerta",
        parametros = {"color_pared", "color_techo"},
        ejemplos = {"casa roja", "casa azul con techo naranja"},
        categoria = "construccion"
    },
    ["torre"] = {
        tipo = "construccion",
        descripcion = "Construye una torre de bloques apilados",
        parametros = {"altura", "color"},
        ejemplos = {"torre 15", "torre 20 azul"},
        categoria = "construccion"
    },
    ["piramide"] = {
        tipo = "construccion",
        descripcion = "Construye una piramide escalonada",
        parametros = {"niveles", "color"},
        ejemplos = {"piramide 5", "piramide 8 amarilla"},
        categoria = "construccion"
    },
    ["puente"] = {
        tipo = "construccion",
        descripcion = "Construye un puente con pilares",
        parametros = {"largo", "color"},
        ejemplos = {"puente 30", "puente 50 marron"},
        categoria = "construccion"
    },
    ["muro"] = {
        tipo = "construccion",
        descripcion = "Construye una muralla o pared grande",
        parametros = {"ancho", "alto", "color"},
        ejemplos = {"muro 20", "muro 15 gris"},
        categoria = "construccion"
    },
    
    -- Construcciones avanzadas
    ["castillo"] = {
        tipo = "construccion",
        descripcion = "Construye un castillo con torres y murallas",
        parametros = {"color"},
        ejemplos = {"castillo", "castillo gris"},
        categoria = "construccion"
    },
    ["laberinto"] = {
        tipo = "construccion",
        descripcion = "Construye un laberinto aleatorio",
        parametros = {"tamaño"},
        ejemplos = {"laberinto", "laberinto 10"},
        categoria = "construccion"
    },
    ["estadio"] = {
        tipo = "construccion",
        descripcion = "Construye un estadio con gradas",
        parametros = {"color"},
        ejemplos = {"estadio", "estadio verde"},
        categoria = "construccion"
    },
    ["cupula"] = {
        tipo = "construccion",
        descripcion = "Construye una cupula geodesica",
        parametros = {"radio", "color"},
        ejemplos = {"cupula", "cupula 15 azul"},
        categoria = "construccion"
    },
    ["escaleras"] = {
        tipo = "construccion",
        descripcion = "Construye escaleras",
        parametros = {"altura", "color"},
        ejemplos = {"escaleras 10", "escaleras 15 marron"},
        categoria = "construccion"
    },
    ["arco"] = {
        tipo = "construccion",
        descripcion = "Construye un arco triunfal",
        parametros = {"altura", "color"},
        ejemplos = {"arco", "arco 20 blanco"},
        categoria = "construccion"
    },
    ["tunel"] = {
        tipo = "construccion",
        descripcion = "Construye un tunel",
        parametros = {"largo", "color"},
        ejemplos = {"tunel 30", "tunel 50 gris"},
        categoria = "construccion"
    },
    
    -- Objetos
    ["parte"] = {
        tipo = "objeto",
        descripcion = "Crea una parte/bloque basico",
        parametros = {"tamano", "color", "material"},
        ejemplos = {"parte azul", "parte roja"},
        categoria = "objetos"
    },
    ["esfera"] = {
        tipo = "objeto",
        descripcion = "Crea una esfera/bola",
        parametros = {"radio", "color"},
        ejemplos = {"esfera roja", "esfera 10 azul"},
        categoria = "objetos"
    },
    ["cilindro"] = {
        tipo = "objeto",
        descripcion = "Crea un cilindro",
        parametros = {"altura", "color"},
        ejemplos = {"cilindro verde", "cilindro 8 gris"},
        categoria = "objetos"
    },
    ["cono"] = {
        tipo = "objeto",
        descripcion = "Crea un cono",
        parametros = {"altura", "color"},
        ejemplos = {"cono", "cono 10 amarillo"},
        categoria = "objetos"
    },
    ["cubo"] = {
        tipo = "objeto",
        descripcion = "Crea un cubo perfecto",
        parametros = {"tamano", "color"},
        ejemplos = {"cubo", "cubo 5 rojo"},
        categoria = "objetos"
    },
    
    -- Modificadores
    ["velocidad"] = {
        tipo = "modificador",
        descripcion = "Cambia la velocidad de movimiento",
        parametros = {"valor"},
        ejemplos = {"velocidad 50", "velocidad 100"},
        categoria = "jugador"
    },
    ["salto"] = {
        tipo = "modificador",
        descripcion = "Cambia el poder de salto",
        parametros = {"valor"},
        ejemplos = {"salto 100", "salto 200"},
        categoria = "jugador"
    },
    ["volar"] = {
        tipo = "modificador",
        descripcion = "Activa modo vuelo",
        parametros = {},
        ejemplos = {"volar", "activar vuelo"},
        categoria = "jugador"
    },
    
    -- Mundo
    ["dia"] = {
        tipo = "mundo",
        descripcion = "Cambia la hora del dia",
        parametros = {"hora"},
        ejemplos = {"dia", "noche", "atardecer"},
        categoria = "mundo"
    },
    ["gravedad"] = {
        tipo = "mundo",
        descripcion = "Cambia la gravedad del mundo",
        parametros = {"valor"},
        ejemplos = {"gravedad 50", "gravedad 0"},
        categoria = "mundo"
    },
    
    -- Efectos
    ["explosion"] = {
        tipo = "efecto",
        descripcion = "Crea una explosion",
        parametros = {"potencia"},
        ejemplos = {"explosion", "explosion 50"},
        categoria = "efectos"
    },
    
    -- Sistema
    ["ayuda"] = {
        tipo = "sistema",
        descripcion = "Muestra lista de comandos disponibles",
        parametros = {},
        ejemplos = {"ayuda", "comandos", "help"},
        categoria = "sistema"
    },
    ["limpiar"] = {
        tipo = "sistema",
        descripcion = "Limpia todas las construcciones",
        parametros = {},
        ejemplos = {"limpiar", "borrar todo", "clear"},
        categoria = "sistema"
    }
}

-- ============================================================
-- CONSTRUCCIONES - FUNCIONES GENERADORAS DE CÓDIGO
-- ============================================================

Database.Construcciones = {
    
    -- CASA
    casa = function(params)
        local colorPared = "Bright red"
        local colorTecho = "Bright orange"
        
        -- Extraer colores de params si existen
        if params and #params > 0 then
            for _, param in ipairs(params) do
                if param:find("roj") then colorPared = "Bright red"
                elseif param:find("azul") then colorPared = "Bright blue"
                elseif param:find("verde") then colorPared = "Bright green"
                elseif param:find("amar") then colorPared = "Bright yellow"
                elseif param:find("gris") then colorPared = "Medium stone grey"
                elseif param:find("blanc") then colorPared = "White"
                end
            end
        end
        
        return [[
local function crearPared(tamano, posicion, color)
    local pared = Instance.new('Part')
    pared.Size = tamano
    pared.Position = posicion
    pared.BrickColor = BrickColor.new(color)
    pared.Anchored = true
    pared:SetAttribute("CreadoPorIA", true)
    pared:SetAttribute("CreacionTimestamp", os.time())
    pared.Parent = workspace
    return pared
end
crearPared(Vector3.new(20, 1, 20), Vector3.new(0, 0, 0), 'Bright green')
crearPared(Vector3.new(20, 10, 1), Vector3.new(0, 5, 10), ']] .. colorPared .. [[')
crearPared(Vector3.new(20, 10, 1), Vector3.new(0, 5, -10), ']] .. colorPared .. [[')
crearPared(Vector3.new(1, 10, 20), Vector3.new(10, 5, 0), ']] .. colorPared .. [[')
crearPared(Vector3.new(1, 10, 20), Vector3.new(-10, 5, 0), ']] .. colorPared .. [[')
crearPared(Vector3.new(20, 1, 20), Vector3.new(0, 10, 0), ']] .. colorTecho .. [[')
crearPared(Vector3.new(4, 7, 1), Vector3.new(0, 3, -10), 'Reddish brown')
]]
    end,

    -- TORRE
    torre = function(params)
        local altura = 10
        local color = "Bright blue"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then altura = num end
                
                if param:find("roj") then color = "Bright red"
                elseif param:find("azul") then color = "Bright blue"
                elseif param:find("verde") then color = "Bright green"
                elseif param:find("amar") then color = "Bright yellow"
                end
            end
        end
        
        return [[
for i = 1, ]] .. altura .. [[ do
    local bloque = Instance.new('Part')
    bloque.Size = Vector3.new(4, 3, 4)
    bloque.Position = Vector3.new(0, i * 3, 0)
    bloque.BrickColor = BrickColor.new(']] .. color .. [[')
    bloque.Anchored = true
    bloque:SetAttribute("CreadoPorIA", true)
    bloque:SetAttribute("CreacionTimestamp", os.time())
    bloque.Parent = workspace
end
]]
    end,

    -- PIRAMIDE
    piramide = function(params)
        local niveles = 5
        local color = "Bright yellow"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then niveles = num end
                
                if param:find("roj") then color = "Bright red"
                elseif param:find("azul") then color = "Bright blue"
                elseif param:find("verde") then color = "Bright green"
                elseif param:find("amar") then color = "Bright yellow"
                end
            end
        end
        
        return [[
for nivel = 1, ]] .. niveles .. [[ do
    local tamano = ]] .. niveles .. [[ - nivel + 1
    for x = 1, tamano do
        for z = 1, tamano do
            local bloque = Instance.new('Part')
            bloque.Size = Vector3.new(2, 2, 2)
            bloque.Position = Vector3.new((x - tamano/2)*2, nivel*2, (z - tamano/2)*2)
            bloque.BrickColor = BrickColor.new(']] .. color .. [[')
            bloque.Anchored = true
            bloque:SetAttribute("CreadoPorIA", true)
            bloque:SetAttribute("CreacionTimestamp", os.time())
            bloque.Parent = workspace
        end
    end
end
]]
    end,

    -- PUENTE
    puente = function(params)
        local largo = 20
        local color = "Reddish brown"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then largo = num end
                
                if param:find("marr") or param:find("cafe") then color = "Reddish brown"
                elseif param:find("gris") then color = "Medium stone grey"
                end
            end
        end
        
        return [[
for i = 0, ]] .. largo .. [[ do
    local tabla = Instance.new('Part')
    tabla.Size = Vector3.new(1, 0.5, 4)
    tabla.Position = Vector3.new(i - ]] .. (largo/2) .. [[, 5, 0)
    tabla.BrickColor = BrickColor.new(']] .. color .. [[')
    tabla.Anchored = true
    tabla:SetAttribute("CreadoPorIA", true)
    tabla:SetAttribute("CreacionTimestamp", os.time())
    tabla.Parent = workspace
    if i % 4 == 0 then
        for j = 1, 3 do
            local pilar = Instance.new('Part')
            pilar.Size = Vector3.new(0.5, j*2, 0.5)
            pilar.Position = Vector3.new(i - ]] .. (largo/2) .. [[, 5 - j, 0)
            pilar.BrickColor = BrickColor.new('Dark stone grey')
            pilar.Anchored = true
            pilar:SetAttribute("CreadoPorIA", true)
            pilar:SetAttribute("CreacionTimestamp", os.time())
            pilar.Parent = workspace
        end
    end
end
]]
    end,

    -- MURO
    muro = function(params)
        local ancho = 20
        local alto = 5
        local color = "Dark stone grey"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then
                    if num < 10 then alto = num
                    else ancho = num end
                end
                
                if param:find("gris") then color = "Medium stone grey"
                elseif param:find("marr") then color = "Reddish brown"
                end
            end
        end
        
        return [[
for x = 1, ]] .. ancho .. [[ do
    for y = 1, ]] .. alto .. [[ do
        local ladrillo = Instance.new('Part')
        ladrillo.Size = Vector3.new(1.5, 1.5, 1)
        ladrillo.Position = Vector3.new((x - ]] .. (ancho/2) .. [[)*1.5, y*1.5, 0)
        ladrillo.BrickColor = BrickColor.new(']] .. color .. [[')
        ladrillo.Anchored = true
        ladrillo:SetAttribute("CreadoPorIA", true)
        ladrillo:SetAttribute("CreacionTimestamp", os.time())
        ladrillo.Parent = workspace
    end
end
]]
    end,
    
    -- CASTILLO ⭐ NUEVA
    castillo = function(params)
        local color = "Medium stone grey"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                if param:find("gris") then color = "Medium stone grey"
                elseif param:find("marr") then color = "Reddish brown"
                elseif param:find("blanc") then color = "White"
                end
            end
        end
        
        return [[
local function crearParte(tamano, posicion, color, nombre)
    local parte = Instance.new('Part')
    parte.Size = tamano
    parte.Position = posicion
    parte.BrickColor = BrickColor.new(color)
    parte.Anchored = true
    parte.Name = nombre or "Castillo"
    parte:SetAttribute("CreadoPorIA", true)
    parte:SetAttribute("CreacionTimestamp", os.time())
    parte.Parent = workspace
    return parte
end

-- Base
crearParte(Vector3.new(30, 2, 30), Vector3.new(0, 1, 0), ']] .. color .. [[', "Base")

-- Torres esquinas
local posiciones = {
    {-12, 10, -12}, {12, 10, -12}, {-12, 10, 12}, {12, 10, 12}
}
for i, pos in ipairs(posiciones) do
    crearParte(Vector3.new(6, 20, 6), Vector3.new(pos[1], pos[2], pos[3]), ']] .. color .. [[', "Torre"..i)
    crearParte(Vector3.new(8, 2, 8), Vector3.new(pos[1], pos[2] + 10, pos[3]), 'Bright red', "Techo"..i)
end

-- Murallas
crearParte(Vector3.new(24, 8, 2), Vector3.new(0, 5, -14), ']] .. color .. [[', "Muro1")
crearParte(Vector3.new(24, 8, 2), Vector3.new(0, 5, 14), ']] .. color .. [[', "Muro2")
crearParte(Vector3.new(2, 8, 24), Vector3.new(-14, 5, 0), ']] .. color .. [[', "Muro3")
crearParte(Vector3.new(2, 8, 24), Vector3.new(14, 5, 0), ']] .. color .. [[', "Muro4")

-- Puerta
crearParte(Vector3.new(6, 6, 1), Vector3.new(0, 4, -14), 'Reddish brown', "Puerta")
]]
    end,
    
    -- LABERINTO ⭐ NUEVA
    laberinto = function(params)
        local tamano = 8
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then tamano = math.min(num, 15) end
            end
        end
        
        return [[
local tamano = ]] .. tamano .. [[
local semilla = tick()
math.randomseed(semilla)

for x = 1, tamano do
    for z = 1, tamano do
        if math.random() > 0.6 then
            local muro = Instance.new('Part')
            muro.Size = Vector3.new(4, 6, 4)
            muro.Position = Vector3.new(x * 5, 3, z * 5)
            muro.BrickColor = BrickColor.new('Dark stone grey')
            muro.Anchored = true
            muro:SetAttribute("CreadoPorIA", true)
            muro:SetAttribute("CreacionTimestamp", os.time())
            muro.Parent = workspace
        end
    end
end
]]
    end,
    
    -- ESTADIO ⭐ NUEVA
    estadio = function(params)
        local color = "Bright green"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                if param:find("verde") then color = "Bright green"
                elseif param:find("azul") then color = "Bright blue"
                end
            end
        end
        
        return [[
-- Campo
local campo = Instance.new('Part')
campo.Size = Vector3.new(60, 1, 40)
campo.Position = Vector3.new(0, 0, 0)
campo.BrickColor = BrickColor.new(']] .. color .. [[')
campo.Anchored = true
campo:SetAttribute("CreadoPorIA", true)
campo:SetAttribute("CreacionTimestamp", os.time())
campo.Parent = workspace

-- Gradas
for lado = -1, 1, 2 do
    for nivel = 1, 8 do
        local grada = Instance.new('Part')
        grada.Size = Vector3.new(60, 2, 3)
        grada.Position = Vector3.new(0, nivel * 2, (22 + nivel * 3) * lado)
        grada.BrickColor = BrickColor.new('Medium stone grey')
        grada.Anchored = true
        grada:SetAttribute("CreadoPorIA", true)
        grada:SetAttribute("CreacionTimestamp", os.time())
        grada.Parent = workspace
    end
end
]]
    end,
    
    -- CUPULA ⭐ NUEVA
    cupula = function(params)
        local radio = 10
        local color = "Bright blue"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then radio = num end
                
                if param:find("azul") then color = "Bright blue"
                elseif param:find("blanc") then color = "White"
                end
            end
        end
        
        return [[
local radio = ]] .. radio .. [[
local segmentos = 16

for i = 0, segmentos do
    for j = 0, segmentos/2 do
        local theta = (i / segmentos) * math.pi * 2
        local phi = (j / (segmentos/2)) * math.pi / 2
        
        local x = radio * math.sin(phi) * math.cos(theta)
        local y = radio * math.cos(phi)
        local z = radio * math.sin(phi) * math.sin(theta)
        
        if y > 0 then
            local bloque = Instance.new('Part')
            bloque.Size = Vector3.new(2, 2, 2)
            bloque.Position = Vector3.new(x, y, z)
            bloque.BrickColor = BrickColor.new(']] .. color .. [[')
            bloque.Anchored = true
            bloque:SetAttribute("CreadoPorIA", true)
            bloque:SetAttribute("CreacionTimestamp", os.time())
            bloque.Parent = workspace
        end
    end
end
]]
    end,
    
    -- ESCALERAS ⭐ NUEVA
    escaleras = function(params)
        local altura = 10
        local color = "Reddish brown"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then altura = num end
                
                if param:find("marr") or param:find("cafe") then color = "Reddish brown"
                elseif param:find("gris") then color = "Medium stone grey"
                end
            end
        end
        
        return [[
for i = 1, ]] .. altura .. [[ do
    local escalon = Instance.new('Part')
    escalon.Size = Vector3.new(6, 1, 3)
    escalon.Position = Vector3.new(0, i, i * 3)
    escalon.BrickColor = BrickColor.new(']] .. color .. [[')
    escalon.Anchored = true
    escalon:SetAttribute("CreadoPorIA", true)
    escalon:SetAttribute("CreacionTimestamp", os.time())
    escalon.Parent = workspace
end
]]
    end,
    
    -- ARCO ⭐ NUEVA
    arco = function(params)
        local altura = 15
        local color = "White"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then altura = num end
                
                if param:find("blanc") then color = "White"
                elseif param:find("gris") then color = "Medium stone grey"
                end
            end
        end
        
        return [[
local altura = ]] .. altura .. [[
local ancho = altura * 0.8

-- Pilares
for lado = -1, 1, 2 do
    local pilar = Instance.new('Part')
    pilar.Size = Vector3.new(4, altura, 4)
    pilar.Position = Vector3.new((ancho/2) * lado, altura/2, 0)
    pilar.BrickColor = BrickColor.new(']] .. color .. [[')
    pilar.Anchored = true
    pilar:SetAttribute("CreadoPorIA", true)
    pilar:SetAttribute("CreacionTimestamp", os.time())
    pilar.Parent = workspace
end

-- Arco superior
for i = 0, 10 do
    local angulo = (i / 10) * math.pi
    local x = (ancho/2) * math.cos(angulo)
    local y = altura + (ancho/4) * math.sin(angulo)
    
    local bloque = Instance.new('Part')
    bloque.Size = Vector3.new(3, 3, 4)
    bloque.Position = Vector3.new(x, y, 0)
    bloque.BrickColor = BrickColor.new(']] .. color .. [[')
    bloque.Anchored = true
    bloque:SetAttribute("CreadoPorIA", true)
    bloque:SetAttribute("CreacionTimestamp", os.time())
    bloque.Parent = workspace
end
]]
    end,
    
    -- TUNEL ⭐ NUEVA
    tunel = function(params)
        local largo = 30
        local color = "Dark stone grey"
        
        if params and #params > 0 then
            for _, param in ipairs(params) do
                local num = tonumber(param)
                if num then largo = num end
                
                if param:find("gris") then color = "Medium stone grey"
                elseif param:find("marr") then color = "Reddish brown"
                end
            end
        end
        
        return [[
local largo = ]] .. largo .. [[

for i = 0, largo do
    -- Paredes
    for lado = -1, 1, 2 do
        local pared = Instance.new('Part')
        pared.Size = Vector3.new(1, 8, 1)
        pared.Position = Vector3.new(i, 4, 5 * lado)
        pared.BrickColor = BrickColor.new(']] .. color .. [[')
        pared.Anchored = true
        pared:SetAttribute("CreadoPorIA", true)
        pared:SetAttribute("CreacionTimestamp", os.time())
        pared.Parent = workspace
    end
    
    -- Techo
    local techo = Instance.new('Part')
    techo.Size = Vector3.new(1, 1, 11)
    techo.Position = Vector3.new(i, 8, 0)
    techo.BrickColor = BrickColor.new(']] .. color .. [[')
    techo.Anchored = true
    techo:SetAttribute("CreadoPorIA", true)
    techo:SetAttribute("CreacionTimestamp", os.time())
    techo.Parent = workspace
end
]]
    end
}

-- ============================================================
-- SISTEMA DE PLUGINS
-- ============================================================

Database.Plugins = {
    instalados = {},
    activos = {}
}

function Database:instalarPlugin(plugin)
    if not plugin or not plugin.info or not plugin.info.nombre then
        return false, "Plugin invalido"
    end
    
    local nombre = plugin.info.nombre
    
    -- Verificar si ya existe
    if self.Plugins.instalados[nombre] then
        return false, "Plugin ya instalado"
    end
    
    -- Registrar comandos del plugin
    if plugin.comandos then
        for cmdNombre, cmdData in pairs(plugin.comandos) do
            if not self.Comandos[cmdNombre] then
                self.Comandos[cmdNombre] = cmdData
            end
        end
    end
    
    -- Registrar construcciones del plugin
    if plugin.construcciones then
        for consNombre, consFunc in pairs(plugin.construcciones) do
            if not self.Construcciones[consNombre] then
                self.Construcciones[consNombre] = consFunc
            end
        end
    end
    
    -- Guardar plugin
    self.Plugins.instalados[nombre] = plugin
    self.Plugins.activos[nombre] = true
    
    -- Ejecutar hook onInit si existe
    if plugin.hooks and plugin.hooks.onInit then
        pcall(plugin.hooks.onInit)
    end
    
    return true, "Plugin instalado correctamente"
end

function Database:ejecutarHookPlugin(hookNombre, ...)
    -- Desactivado temporalmente para evitar error de atributos
    -- Discord Sync funciona sin necesidad de hooks desde CORE_IA
    return
end

-- ============================================================
-- COLORES
-- ============================================================

Database.Colores = {
    {palabras = {"azul", "blue"}, brick = "Bright blue", rgb = Color3.fromRGB(13, 105, 172)},
    {palabras = {"rojo", "red"}, brick = "Bright red", rgb = Color3.fromRGB(196, 40, 28)},
    {palabras = {"verde", "green"}, brick = "Bright green", rgb = Color3.fromRGB(75, 151, 75)},
    {palabras = {"amarillo", "yellow"}, brick = "Bright yellow", rgb = Color3.fromRGB(245, 205, 48)},
    {palabras = {"negro", "black"}, brick = "Black", rgb = Color3.fromRGB(27, 42, 53)},
    {palabras = {"blanco", "white"}, brick = "White", rgb = Color3.fromRGB(248, 248, 248)},
    {palabras = {"morado", "purple", "violeta"}, brick = "Bright violet", rgb = Color3.fromRGB(107, 50, 124)},
    {palabras = {"naranja", "orange"}, brick = "Bright orange", rgb = Color3.fromRGB(218, 133, 65)},
    {palabras = {"rosa", "pink"}, brick = "Hot pink", rgb = Color3.fromRGB(255, 102, 204)},
    {palabras = {"gris", "gray"}, brick = "Medium stone grey", rgb = Color3.fromRGB(163, 162, 165)},
    {palabras = {"marron", "brown", "cafe"}, brick = "Reddish brown", rgb = Color3.fromRGB(105, 64, 40)},
    {palabras = {"cian", "cyan", "celeste"}, brick = "Cyan", rgb = Color3.fromRGB(0, 255, 255)},
}

-- ============================================================
-- MATERIALES
-- ============================================================

Database.Materiales = {
    {palabras = {"madera", "wood"}, material = "Wood"},
    {palabras = {"piedra", "stone", "roca"}, material = "Slate"},
    {palabras = {"metal"}, material = "Metal"},
    {palabras = {"vidrio", "glass", "cristal"}, material = "Glass"},
    {palabras = {"neon"}, material = "Neon"},
    {palabras = {"plastico", "plastic"}, material = "SmoothPlastic"},
    {palabras = {"ladrillo", "brick"}, material = "Brick"},
    {palabras = {"marmol", "marble"}, material = "Marble"},
    {palabras = {"granito", "granite"}, material = "Granite"},
}

-- ============================================================
-- ESTADISTICAS
-- ============================================================

Database.Estadisticas = {
    totalComandos = 0,
    comandosExitosos = 0,
    comandosFallidos = 0,
    construccionesCreadas = 0,
    fechaInstalacion = os.time()
}

-- ============================================================
-- CONFIG
-- ============================================================

Database.Config = {
    version = "2.1.0",
    autor = "MOFUZII",
    github = "https://github.com/MOFUZII/roblox-ia-constructor",
    actualizacion = "2026-02-12",
    comportamiento = {
        autoGuardar = true,
        mostrarNotificaciones = true,
        usarSonidos = true,
        modoDebug = false
    },
    limites = {
        maxHistorial = 100,
        maxConstruccionesPorVez = 50,
        maxPartesTotal = 1000
    }
}

-- ============================================================
-- FUNCIONES
-- ============================================================

function Database:obtenerComando(nombre)
    return self.Comandos[nombre]
end

function Database:obtenerConstruccion(nombre)
    return self.Construcciones[nombre]
end

function Database:obtenerColor(nombre)
    for _, colorData in ipairs(self.Colores) do
        for _, palabra in ipairs(colorData.palabras) do
            if palabra == nombre then
                return colorData.brick, colorData.rgb
            end
        end
    end
    return "Bright red", Color3.fromRGB(196, 40, 28)
end

function Database:obtenerMaterial(nombre)
    for _, matData in ipairs(self.Materiales) do
        for _, palabra in ipairs(matData.palabras) do
            if palabra == nombre then
                return matData.material
            end
        end
    end
    return "SmoothPlastic"
end

function Database:obtenerEstadisticas()
    return self.Estadisticas
end

function Database:actualizarEstadistica(tipo, incremento)
    incremento = incremento or 1
    if self.Estadisticas[tipo] then
        self.Estadisticas[tipo] = self.Estadisticas[tipo] + incremento
    end
end

function Database:listarComandos()
    local lista = "COMANDOS DISPONIBLES:\n\n"
    local categorias = {}
    for nombre, cmd in pairs(self.Comandos) do
        local cat = cmd.categoria or "otros"
        if not categorias[cat] then categorias[cat] = {} end
        table.insert(categorias[cat], nombre)
    end
    for categoria, comandos in pairs(categorias) do
        lista = lista .. "[ " .. categoria:upper() .. " ]\n"
        table.sort(comandos)
        for _, nombre in ipairs(comandos) do
            lista = lista .. "  " .. nombre .. "\n"
        end
        lista = lista .. "\n"
    end
    return lista
end

return Database
