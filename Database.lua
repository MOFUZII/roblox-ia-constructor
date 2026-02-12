-- ============================================================
-- DATABASE.LUA - Base de Conocimiento
-- Modulo 2: Toda la informacion que la IA necesita
-- ============================================================

local Database = {}

-- ============================================================
-- COMANDOS PREDEFINIDOS
-- ============================================================

Database.Comandos = {
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
    ["explosion"] = {
        tipo = "efecto",
        descripcion = "Crea una explosion",
        parametros = {"potencia"},
        ejemplos = {"explosion", "explosion 50"},
        categoria = "efectos"
    },
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
-- CONSTRUCCIONES
-- ============================================================

Database.Construcciones = {
    casa = function(colorPared, colorTecho)
        colorPared = colorPared or "Bright red"
        colorTecho = colorTecho or "Bright orange"
        return [[
local function crearPared(tamano, posicion, color)
    local pared = Instance.new('Part')
    pared.Size = tamano
    pared.Position = posicion
    pared.BrickColor = BrickColor.new(color)
    pared.Anchored = true
    pared:SetAttribute("CreadoPorIA", true)
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

    torre = function(altura, color)
        altura = altura or 10
        color  = color  or "Bright blue"
        return [[
for i = 1, ]] .. altura .. [[ do
    local bloque = Instance.new('Part')
    bloque.Size = Vector3.new(4, 3, 4)
    bloque.Position = Vector3.new(0, i * 3, 0)
    bloque.BrickColor = BrickColor.new(']] .. color .. [[')
    bloque.Anchored = true
    bloque:SetAttribute("CreadoPorIA", true)
    bloque.Parent = workspace
end
]]
    end,

    piramide = function(niveles, color)
        niveles = niveles or 5
        color   = color   or "Bright yellow"
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
            bloque.Parent = workspace
        end
    end
end
]]
    end,

    puente = function(largo, color)
        largo = largo or 20
        color = color or "Reddish brown"
        return [[
for i = 0, ]] .. largo .. [[ do
    local tabla = Instance.new('Part')
    tabla.Size = Vector3.new(1, 0.5, 4)
    tabla.Position = Vector3.new(i - ]] .. largo .. [[, 5, 0)
    tabla.BrickColor = BrickColor.new(']] .. color .. [[')
    tabla.Anchored = true
    tabla:SetAttribute("CreadoPorIA", true)
    tabla.Parent = workspace
    if i % 4 == 0 then
        for j = 1, 3 do
            local pilar = Instance.new('Part')
            pilar.Size = Vector3.new(0.5, j*2, 0.5)
            pilar.Position = Vector3.new(i - ]] .. largo .. [[, 5 - j, 0)
            pilar.BrickColor = BrickColor.new('Dark stone grey')
            pilar.Anchored = true
            pilar:SetAttribute("CreadoPorIA", true)
            pilar.Parent = workspace
        end
    end
end
]]
    end,

    muro = function(ancho, alto, color)
        ancho = ancho or 20
        alto  = alto  or 5
        color = color or "Dark stone grey"
        return [[
for x = 1, ]] .. ancho .. [[ do
    for y = 1, ]] .. alto .. [[ do
        local ladrillo = Instance.new('Part')
        ladrillo.Size = Vector3.new(1.5, 1.5, 1)
        ladrillo.Position = Vector3.new((x - ]] .. ancho .. [[)*1.5, y*1.5, 0)
        ladrillo.BrickColor = BrickColor.new(']] .. color .. [[')
        ladrillo.Anchored = true
        ladrillo:SetAttribute("CreadoPorIA", true)
        ladrillo.Parent = workspace
    end
end
]]
    end
}

-- ============================================================
-- ASSETS
-- ============================================================

Database.Assets = {
    texturas = {
        madera   = "rbxasset://textures/wood.png",
        piedra   = "rbxasset://textures/slate.png",
        metal    = "rbxasset://textures/metal.png",
        ladrillo = "rbxasset://textures/brick.png",
        cesped   = "rbxasset://textures/grass.png"
    },
    audios = {
        explosion   = "rbxassetid://165969964",
        click       = "rbxassetid://156785206",
        exito       = "rbxassetid://156286438",
        error       = "rbxassetid://156286380",
        construccion = "rbxassetid://507863105"
    },
    modelos = {
        arbol       = 0,
        carro       = 0,
        casa_moderna = 0
    },
    skyboxes = {
        dia_claro = {
            bk = "rbxassetid://271042516",
            dn = "rbxassetid://271077243",
            ft = "rbxassetid://271042556",
            lf = "rbxassetid://271042310",
            rt = "rbxassetid://271042467",
            up = "rbxassetid://271077958"
        }
    }
}

-- ============================================================
-- COLORES
-- ============================================================

Database.Colores = {
    {palabras = {"azul",    "blue"},              brick = "Bright blue",   rgb = Color3.fromRGB(13,  105, 172)},
    {palabras = {"rojo",    "red"},               brick = "Bright red",    rgb = Color3.fromRGB(196, 40,  28)},
    {palabras = {"verde",   "green"},             brick = "Bright green",  rgb = Color3.fromRGB(75,  151, 75)},
    {palabras = {"amarillo","yellow"},            brick = "Bright yellow", rgb = Color3.fromRGB(245, 205, 48)},
    {palabras = {"negro",   "black"},             brick = "Black",         rgb = Color3.fromRGB(27,  42,  53)},
    {palabras = {"blanco",  "white"},             brick = "White",         rgb = Color3.fromRGB(248, 248, 248)},
    {palabras = {"morado",  "purple", "violeta"}, brick = "Bright violet", rgb = Color3.fromRGB(107, 50,  124)},
    {palabras = {"naranja", "orange"},            brick = "Bright orange", rgb = Color3.fromRGB(218, 133, 65)},
    {palabras = {"rosa",    "pink"},              brick = "Hot pink",      rgb = Color3.fromRGB(255, 102, 204)},
    {palabras = {"gris",    "gray"},              brick = "Mid gray",      rgb = Color3.fromRGB(163, 162, 165)},
    {palabras = {"marron",  "brown", "cafe"},     brick = "Reddish brown", rgb = Color3.fromRGB(105, 64,  40)},
    {palabras = {"cian",    "cyan",  "celeste"},  brick = "Cyan",          rgb = Color3.fromRGB(0,   255, 255)},
}

-- ============================================================
-- MATERIALES
-- ============================================================

Database.Materiales = {
    {palabras = {"madera",   "wood"},             material = "Wood"},
    {palabras = {"piedra",   "stone", "roca"},    material = "Slate"},
    {palabras = {"metal"},                        material = "Metal"},
    {palabras = {"vidrio",   "glass", "cristal"}, material = "Glass"},
    {palabras = {"neon"},                         material = "Neon"},
    {palabras = {"plastico", "plastic"},          material = "SmoothPlastic"},
    {palabras = {"ladrillo", "brick"},            material = "Brick"},
    {palabras = {"marmol",   "marble"},           material = "Marble"},
    {palabras = {"granito",  "granite"},          material = "Granite"},
}

-- ============================================================
-- EXPLICACIONES
-- ============================================================

Database.Explicaciones = {
    ["que es roblox"] = {
        titulo   = "Que es Roblox",
        contenido = "Roblox es una plataforma de creacion de juegos donde puedes crear y jugar experiencias de otros usuarios.",
        categoria = "general"
    },
    ["que es lua"] = {
        titulo   = "Que es Lua",
        contenido = "Lua es el lenguaje de programacion usado en Roblox. Es simple, potente y perfecto para principiantes.",
        categoria = "programacion"
    },
    ["como funciono"] = {
        titulo   = "Como funciona esta IA",
        contenido = "Proceso lenguaje natural para entender tus comandos y genero codigo Lua que ejecuto en el workspace.",
        categoria = "ia"
    },
    ["que es instance"] = {
        titulo   = "Que es Instance",
        contenido = "Instance.new() crea objetos en Roblox. Por ejemplo: Instance.new('Part') crea una parte.",
        categoria = "programacion"
    },
    ["que es vector3"] = {
        titulo   = "Que es Vector3",
        contenido = "Vector3 representa posiciones en 3D (X, Y, Z). Por ejemplo: Vector3.new(0, 10, 0) es el centro a 10 studs de altura.",
        categoria = "programacion"
    }
}

-- ============================================================
-- ESTADISTICAS
-- ============================================================

Database.Estadisticas = {
    totalComandos        = 0,
    comandosExitosos     = 0,
    comandosFallidos     = 0,
    construccionesCreadas = 0,
    fechaInstalacion     = os.time()
}

-- ============================================================
-- CONFIG
-- ============================================================

Database.Config = {
    version      = "1.0.0",
    autor        = "MOFUZII",
    github       = "https://github.com/MOFUZII/roblox-ia-constructor",
    actualizacion = "2026-02-12",
    comportamiento = {
        autoGuardar           = true,
        mostrarNotificaciones = true,
        usarSonidos           = true,
        modoDebug             = false
    },
    limites = {
        maxHistorial           = 100,
        maxConstruccionesPorVez = 50,
        maxPartesTotal         = 1000
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

function Database:buscarExplicacion(texto)
    for clave, explicacion in pairs(self.Explicaciones) do
        if texto:find(clave) then
            return explicacion
        end
    end
    return nil
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
        for _, nombre in ipairs(comandos) do
            lista = lista .. "  " .. nombre .. "\n"
        end
        lista = lista .. "\n"
    end
    return lista
end

return Database
