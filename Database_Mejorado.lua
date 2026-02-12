-- ============================================================
-- DATABASE.LUA - Base de Conocimiento MEJORADA v2.0
-- Modulo 2: Sistema expandido con plugins y construcciones avanzadas
-- AUTOR: MOFUZII | FECHA: Febrero 2026
-- ============================================================

local Database = {}

-- ============================================================
-- SISTEMA DE PLUGINS (REVOLUCIONARIO)
-- ============================================================

Database.Plugins = {
    -- Sistema de gestion de plugins
    instalados = {},
    activos = {},
    
    -- Registro de APIs de Roblox que pueden ser interceptadas
    interceptores = {
        ["TweenService"] = nil,
        ["PathfindingService"] = nil,
        ["RunService"] = nil,
        ["UserInputService"] = nil,
        ["ReplicatedStorage"] = nil
    },
    
    -- Capacidades extendidas por plugins
    capacidades = {
        animaciones = false,
        pathfinding = false,
        particulas_avanzadas = false,
        sonido_3d = false,
        fisica_custom = false,
        networking = false,
        terreno = false
    }
}

-- Plantilla base para crear plugins
Database.PluginTemplate = {
    info = {
        nombre = "MiPlugin",
        version = "1.0.0",
        autor = "Usuario",
        descripcion = "Descripcion del plugin",
        dependencias = {}, -- otros plugins necesarios
        permisos = {} -- "workspace", "players", "lighting", etc
    },
    
    -- Comandos que agrega el plugin
    comandos = {
        -- ["nombre_comando"] = { tipo, descripcion, parametros, funcion }
    },
    
    -- Construcciones que agrega
    construcciones = {
        -- ["nombre"] = function(params) return "codigo lua" end
    },
    
    -- Interceptores de servicios
    interceptores = {
        -- ["NombreServicio"] = function(servicio) ... end
    },
    
    -- Hooks en eventos del sistema
    hooks = {
        onInit = function() end,
        onComandoEjecutado = function(comando) end,
        onConstruccionCreada = function(nombre) end,
        onError = function(error) end
    }
}

-- Funcion para instalar un plugin
function Database:instalarPlugin(plugin)
    if not plugin.info or not plugin.info.nombre then
        return false, "Plugin invalido: falta informacion basica"
    end
    
    local nombre = plugin.info.nombre
    
    -- Verificar dependencias
    if plugin.info.dependencias then
        for _, dep in ipairs(plugin.info.dependencias) do
            if not self.Plugins.instalados[dep] then
                return false, "Falta dependencia: " .. dep
            end
        end
    end
    
    -- Registrar plugin
    self.Plugins.instalados[nombre] = plugin
    self.Plugins.activos[nombre] = true
    
    -- Agregar comandos del plugin
    if plugin.comandos then
        for cmdNombre, cmdData in pairs(plugin.comandos) do
            self.Comandos[cmdNombre] = cmdData
        end
    end
    
    -- Agregar construcciones del plugin
    if plugin.construcciones then
        for constNombre, constFn in pairs(plugin.construcciones) do
            self.Construcciones[constNombre] = constFn
        end
    end
    
    -- Activar interceptores
    if plugin.interceptores then
        for serviceName, interceptor in pairs(plugin.interceptores) do
            self.Plugins.interceptores[serviceName] = interceptor
        end
    end
    
    -- Ejecutar hook de inicializacion
    if plugin.hooks and plugin.hooks.onInit then
        plugin.hooks.onInit()
    end
    
    return true, "Plugin '" .. nombre .. "' instalado correctamente"
end

-- ============================================================
-- COMANDOS PREDEFINIDOS (EXPANDIDOS)
-- ============================================================

Database.Comandos = {
    -- CONSTRUCCIONES BASICAS
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
    
    -- CONSTRUCCIONES AVANZADAS (NUEVAS)
    ["castillo"] = {
        tipo = "construccion",
        descripcion = "Construye un castillo medieval con torres y murallas",
        parametros = {"tamano", "color_piedra"},
        ejemplos = {"castillo grande", "castillo gris"},
        categoria = "construccion"
    },
    ["escaleras"] = {
        tipo = "construccion",
        descripcion = "Construye escaleras funcionales",
        parametros = {"altura", "ancho", "color"},
        ejemplos = {"escaleras 20", "escaleras anchas marron"},
        categoria = "construccion"
    },
    ["tunel"] = {
        tipo = "construccion",
        descripcion = "Construye un tunel atravesable",
        parametros = {"largo", "radio"},
        ejemplos = {"tunel 50", "tunel largo"},
        categoria = "construccion"
    },
    ["arco"] = {
        tipo = "construccion",
        descripcion = "Construye un arco decorativo",
        parametros = {"ancho", "altura", "color"},
        ejemplos = {"arco grande", "arco romano blanco"},
        categoria = "construccion"
    },
    ["cupula"] = {
        tipo = "construccion",
        descripcion = "Construye una cupula geodesica",
        parametros = {"radio", "detalle", "color"},
        ejemplos = {"cupula 15", "cupula cristal"},
        categoria = "construccion"
    },
    ["laberinto"] = {
        tipo = "construccion",
        descripcion = "Genera un laberinto aleatorio",
        parametros = {"tamano", "dificultad"},
        ejemplos = {"laberinto 20", "laberinto dificil"},
        categoria = "construccion"
    },
    ["estadio"] = {
        tipo = "construccion",
        descripcion = "Construye un estadio con gradas",
        parametros = {"tamano", "forma"},
        ejemplos = {"estadio grande", "estadio circular"},
        categoria = "construccion"
    },
    ["ciudad"] = {
        tipo = "construccion",
        descripcion = "Genera una ciudad procedural con edificios",
        parametros = {"tamano", "estilo"},
        ejemplos = {"ciudad moderna", "ciudad medieval"},
        categoria = "construccion"
    },
    
    -- OBJETOS BASICOS
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
    
    -- OBJETOS AVANZADOS (NUEVOS)
    ["cono"] = {
        tipo = "objeto",
        descripcion = "Crea un cono usando mesh",
        parametros = {"altura", "radio", "color"},
        ejemplos = {"cono rojo", "cono 10"},
        categoria = "objetos"
    },
    ["toroide"] = {
        tipo = "objeto",
        descripcion = "Crea un toroide (dona)",
        parametros = {"radio_mayor", "radio_menor"},
        ejemplos = {"toroide grande", "toroide"},
        categoria = "objetos"
    },
    ["espiral"] = {
        tipo = "objeto",
        descripcion = "Crea una espiral 3D",
        parametros = {"vueltas", "radio", "altura"},
        ejemplos = {"espiral 10", "espiral grande"},
        categoria = "objetos"
    },
    
    -- MODIFICADORES DE JUGADOR
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
    ["teletransportar"] = {
        tipo = "modificador",
        descripcion = "Teletransporta al jugador",
        parametros = {"x", "y", "z"},
        ejemplos = {"teletransportar 0 50 0", "tp torre"},
        categoria = "jugador"
    },
    ["invisible"] = {
        tipo = "modificador",
        descripcion = "Hace invisible al jugador",
        parametros = {},
        ejemplos = {"invisible", "invisibilidad"},
        categoria = "jugador"
    },
    
    -- CONTROL DE MUNDO
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
    ["clima"] = {
        tipo = "mundo",
        descripcion = "Cambia el clima (lluvia, nieve, etc)",
        parametros = {"tipo"},
        ejemplos = {"clima lluvia", "clima nieve"},
        categoria = "mundo"
    },
    ["niebla"] = {
        tipo = "mundo",
        descripcion = "Agrega niebla al ambiente",
        parametros = {"densidad", "color"},
        ejemplos = {"niebla densa", "niebla azul"},
        categoria = "mundo"
    },
    ["skybox"] = {
        tipo = "mundo",
        descripcion = "Cambia el skybox del cielo",
        parametros = {"estilo"},
        ejemplos = {"skybox espacial", "skybox atardecer"},
        categoria = "mundo"
    },
    
    -- EFECTOS Y PARTICULAS
    ["explosion"] = {
        tipo = "efecto",
        descripcion = "Crea una explosion",
        parametros = {"potencia"},
        ejemplos = {"explosion", "explosion 50"},
        categoria = "efectos"
    },
    ["fuego"] = {
        tipo = "efecto",
        descripcion = "Crea fuego en una posicion",
        parametros = {"intensidad"},
        ejemplos = {"fuego", "fuego intenso"},
        categoria = "efectos"
    },
    ["humo"] = {
        tipo = "efecto",
        descripcion = "Crea humo",
        parametros = {"color", "opacidad"},
        ejemplos = {"humo negro", "humo"},
        categoria = "efectos"
    },
    ["chispas"] = {
        tipo = "efecto",
        descripcion = "Emite chispas electricas",
        parametros = {},
        ejemplos = {"chispas", "electricidad"},
        categoria = "efectos"
    },
    ["portal"] = {
        tipo = "efecto",
        descripcion = "Crea un portal giratorio",
        parametros = {"color"},
        ejemplos = {"portal azul", "portal"},
        categoria = "efectos"
    },
    ["rayo"] = {
        tipo = "efecto",
        descripcion = "Crea un rayo entre dos puntos",
        parametros = {"desde", "hasta"},
        ejemplos = {"rayo", "rayo hacia torre"},
        categoria = "efectos"
    },
    
    -- ILUMINACION
    ["luz"] = {
        tipo = "iluminacion",
        descripcion = "Crea una fuente de luz",
        parametros = {"tipo", "color", "intensidad"},
        ejemplos = {"luz roja", "luz brillante"},
        categoria = "iluminacion"
    },
    ["foco"] = {
        tipo = "iluminacion",
        descripcion = "Crea un foco direccional",
        parametros = {"angulo", "color"},
        ejemplos = {"foco amplio", "foco azul"},
        categoria = "iluminacion"
    },
    
    -- ANIMACION
    ["animar"] = {
        tipo = "animacion",
        descripcion = "Anima un objeto creado",
        parametros = {"tipo_animacion", "duracion"},
        ejemplos = {"animar rotar", "animar flotar"},
        categoria = "animacion"
    },
    ["girar"] = {
        tipo = "animacion",
        descripcion = "Hace girar un objeto continuamente",
        parametros = {"velocidad"},
        ejemplos = {"girar rapido", "girar lento"},
        categoria = "animacion"
    },
    
    -- SISTEMA
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
    },
    ["guardar"] = {
        tipo = "sistema",
        descripcion = "Guarda la construccion actual",
        parametros = {"nombre"},
        ejemplos = {"guardar mi_castillo", "guardar construccion"},
        categoria = "sistema"
    },
    ["cargar"] = {
        tipo = "sistema",
        descripcion = "Carga una construccion guardada",
        parametros = {"nombre"},
        ejemplos = {"cargar mi_castillo"},
        categoria = "sistema"
    },
    ["plugin"] = {
        tipo = "sistema",
        descripcion = "Gestiona plugins (instalar, listar, activar)",
        parametros = {"accion", "nombre"},
        ejemplos = {"plugin listar", "plugin activar pathfinding"},
        categoria = "sistema"
    }
}

-- ============================================================
-- CONSTRUCCIONES (EXPANDIDAS)
-- ============================================================

Database.Construcciones = {
    -- CONSTRUCCIONES BASICAS (MEJORADAS CON TIMESTAMP)
    casa = function(colorPared, colorTecho)
        colorPared = colorPared or "Bright red"
        colorTecho = colorTecho or "Bright orange"
        return [[
local timestamp = os.time()
local function crearPared(tamano, posicion, color)
    local pared = Instance.new('Part')
    pared.Size = tamano
    pared.Position = posicion
    pared.BrickColor = BrickColor.new(color)
    pared.Anchored = true
    pared:SetAttribute("CreadoPorIA", true)
    pared:SetAttribute("CreacionTimestamp", timestamp)
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
local timestamp = os.time()
for i = 1, ]] .. altura .. [[ do
    local bloque = Instance.new('Part')
    bloque.Size = Vector3.new(4, 3, 4)
    bloque.Position = Vector3.new(0, i * 3, 0)
    bloque.BrickColor = BrickColor.new(']] .. color .. [[')
    bloque.Anchored = true
    bloque:SetAttribute("CreadoPorIA", true)
    bloque:SetAttribute("CreacionTimestamp", timestamp)
    bloque.Parent = workspace
end
]]
    end,

    piramide = function(niveles, color)
        niveles = niveles or 5
        color   = color   or "Bright yellow"
        return [[
local timestamp = os.time()
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
            bloque:SetAttribute("CreacionTimestamp", timestamp)
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
local timestamp = os.time()
for i = 0, ]] .. largo .. [[ do
    local tabla = Instance.new('Part')
    tabla.Size = Vector3.new(1, 0.5, 4)
    tabla.Position = Vector3.new(i - ]] .. largo .. [[/2, 5, 0)
    tabla.BrickColor = BrickColor.new(']] .. color .. [[')
    tabla.Anchored = true
    tabla:SetAttribute("CreadoPorIA", true)
    tabla:SetAttribute("CreacionTimestamp", timestamp)
    tabla.Parent = workspace
    if i % 4 == 0 then
        for j = 1, 3 do
            local pilar = Instance.new('Part')
            pilar.Size = Vector3.new(0.5, j*2, 0.5)
            pilar.Position = Vector3.new(i - ]] .. largo .. [[/2, 5 - j, 0)
            pilar.BrickColor = BrickColor.new('Dark stone grey')
            pilar.Anchored = true
            pilar:SetAttribute("CreadoPorIA", true)
            pilar:SetAttribute("CreacionTimestamp", timestamp)
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
local timestamp = os.time()
for x = 1, ]] .. ancho .. [[ do
    for y = 1, ]] .. alto .. [[ do
        local ladrillo = Instance.new('Part')
        ladrillo.Size = Vector3.new(1.5, 1.5, 1)
        ladrillo.Position = Vector3.new((x - ]] .. ancho .. [[/2)*1.5, y*1.5, 0)
        ladrillo.BrickColor = BrickColor.new(']] .. color .. [[')
        ladrillo.Anchored = true
        ladrillo:SetAttribute("CreadoPorIA", true)
        ladrillo:SetAttribute("CreacionTimestamp", timestamp)
        ladrillo.Parent = workspace
    end
end
]]
    end,
    
    -- NUEVAS CONSTRUCCIONES AVANZADAS
    castillo = function(tamano, colorPiedra)
        tamano = tamano or "mediano"
        colorPiedra = colorPiedra or "Dark stone grey"
        local escala = tamano == "grande" and 1.5 or (tamano == "pequeno" and 0.7 or 1)
        return [[
local timestamp = os.time()
local escala = ]] .. escala .. [[
local function crearBloque(pos, tam, col)
    local p = Instance.new('Part')
    p.Size = tam * escala
    p.Position = pos * escala
    p.BrickColor = BrickColor.new(col)
    p.Material = Enum.Material.Slate
    p.Anchored = true
    p:SetAttribute("CreadoPorIA", true)
    p:SetAttribute("CreacionTimestamp", timestamp)
    p.Parent = workspace
end
-- Murallas base (cuadrado)
for i = 0, 40, 2 do
    crearBloque(Vector3.new(i-20, 5, -20), Vector3.new(2, 10, 2), ']] .. colorPiedra .. [[')
    crearBloque(Vector3.new(i-20, 5, 20), Vector3.new(2, 10, 2), ']] .. colorPiedra .. [[')
    crearBloque(Vector3.new(-20, 5, i-20), Vector3.new(2, 10, 2), ']] .. colorPiedra .. [[')
    crearBloque(Vector3.new(20, 5, i-20), Vector3.new(2, 10, 2), ']] .. colorPiedra .. [[')
end
-- Torres en esquinas
local esquinas = {{-20,-20},{-20,20},{20,-20},{20,20}}
for _, esq in ipairs(esquinas) do
    for h = 1, 8 do
        crearBloque(Vector3.new(esq[1], h*3, esq[2]), Vector3.new(6, 3, 6), ']] .. colorPiedra .. [[')
    end
    -- Techo de torre
    for i = -1, 1 do
        for j = -1, 1 do
            crearBloque(Vector3.new(esq[1]+i*2, 26, esq[2]+j*2), Vector3.new(2, 1, 2), 'Bright red')
        end
    end
end
-- Torre central
for h = 1, 12 do
    crearBloque(Vector3.new(0, h*3, 0), Vector3.new(8, 3, 8), ']] .. colorPiedra .. [[')
end
]]
    end,
    
    escaleras = function(altura, ancho, color)
        altura = altura or 20
        ancho = ancho or "normal"
        color = color or "Reddish brown"
        local anchoNum = ancho == "ancho" and 6 or 4
        return [[
local timestamp = os.time()
local ancho = ]] .. anchoNum .. [[
for i = 1, ]] .. altura .. [[ do
    local escalon = Instance.new('Part')
    escalon.Size = Vector3.new(ancho, 1, 2)
    escalon.Position = Vector3.new(0, i, i*2)
    escalon.BrickColor = BrickColor.new(']] .. color .. [[')
    escalon.Material = Enum.Material.Wood
    escalon.Anchored = true
    escalon:SetAttribute("CreadoPorIA", true)
    escalon:SetAttribute("CreacionTimestamp", timestamp)
    escalon.Parent = workspace
end
]]
    end,
    
    tunel = function(largo, radio)
        largo = largo or 30
        radio = radio or 5
        return [[
local timestamp = os.time()
local largo = ]] .. largo .. [[
local radio = ]] .. radio .. [[
-- Crear segmentos del tunel
for z = 0, largo, 2 do
    for angulo = 0, 350, 30 do
        local rad = math.rad(angulo)
        local x = math.cos(rad) * radio
        local y = math.sin(rad) * radio
        local segmento = Instance.new('Part')
        segmento.Size = Vector3.new(1, 1, 2)
        segmento.Position = Vector3.new(x, y + radio, z)
        segmento.BrickColor = BrickColor.new('Dark stone grey')
        segmento.Material = Enum.Material.Brick
        segmento.Anchored = true
        segmento:SetAttribute("CreadoPorIA", true)
        segmento:SetAttribute("CreacionTimestamp", timestamp)
        segmento.Parent = workspace
    end
end
]]
    end,
    
    arco = function(ancho, altura, color)
        ancho = ancho or 10
        altura = altura or 15
        color = color or "White"
        return [[
local timestamp = os.time()
local ancho = ]] .. ancho .. [[
local altura = ]] .. altura .. [[
-- Columnas laterales
for y = 1, altura do
    local col1 = Instance.new('Part')
    col1.Size = Vector3.new(2, 2, 2)
    col1.Position = Vector3.new(-ancho/2, y*2, 0)
    col1.BrickColor = BrickColor.new(']] .. color .. [[')
    col1.Material = Enum.Material.Marble
    col1.Anchored = true
    col1:SetAttribute("CreadoPorIA", true)
    col1:SetAttribute("CreacionTimestamp", timestamp)
    col1.Parent = workspace
    local col2 = col1:Clone()
    col2.Position = Vector3.new(ancho/2, y*2, 0)
    col2.Parent = workspace
end
-- Arco superior (semicirculo)
for angulo = 0, 180, 15 do
    local rad = math.rad(angulo)
    local x = math.cos(rad) * (ancho/2)
    local y = math.sin(rad) * (ancho/2) + altura*2
    local bloque = Instance.new('Part')
    bloque.Size = Vector3.new(2, 2, 2)
    bloque.Position = Vector3.new(x, y, 0)
    bloque.BrickColor = BrickColor.new(']] .. color .. [[')
    bloque.Material = Enum.Material.Marble
    bloque.Anchored = true
    bloque:SetAttribute("CreadoPorIA", true)
    bloque:SetAttribute("CreacionTimestamp", timestamp)
    bloque.Parent = workspace
end
]]
    end,
    
    cupula = function(radio, detalle, color)
        radio = radio or 10
        detalle = detalle or "medio"
        color = color or "Cyan"
        local paso = detalle == "alto" and 10 or (detalle == "bajo" and 30 or 20)
        return [[
local timestamp = os.time()
local radio = ]] .. radio .. [[
local paso = ]] .. paso .. [[
-- Crear cupula geodesica
for theta = 0, 90, paso do
    for phi = 0, 360, paso do
        local radTheta = math.rad(theta)
        local radPhi = math.rad(phi)
        local x = radio * math.sin(radTheta) * math.cos(radPhi)
        local z = radio * math.sin(radTheta) * math.sin(radPhi)
        local y = radio * math.cos(radTheta)
        local bloque = Instance.new('Part')
        bloque.Size = Vector3.new(1, 1, 1)
        bloque.Position = Vector3.new(x, y, z)
        bloque.BrickColor = BrickColor.new(']] .. color .. [[')
        bloque.Material = Enum.Material.Glass
        bloque.Transparency = 0.3
        bloque.Anchored = true
        bloque:SetAttribute("CreadoPorIA", true)
        bloque:SetAttribute("CreacionTimestamp", timestamp)
        bloque.Parent = workspace
    end
end
]]
    end,
    
    laberinto = function(tamano, dificultad)
        tamano = tamano or 15
        dificultad = dificultad or "normal"
        return [[
local timestamp = os.time()
local tamano = ]] .. tamano .. [[
local seed = tick()
math.randomseed(seed)
-- Algoritmo de generacion de laberinto (DFS)
local grid = {}
for x = 1, tamano do
    grid[x] = {}
    for z = 1, tamano do
        grid[x][z] = 1 -- 1 = pared, 0 = camino
    end
end
-- DFS recursivo simple
local function carve(x, z)
    grid[x][z] = 0
    local dirs = {{2,0},{-2,0},{0,2},{0,-2}}
    for i = #dirs, 2, -1 do
        local j = math.random(i)
        dirs[i], dirs[j] = dirs[j], dirs[i]
    end
    for _, dir in ipairs(dirs) do
        local nx, nz = x + dir[1], z + dir[2]
        if nx > 0 and nx <= tamano and nz > 0 and nz <= tamano and grid[nx][nz] == 1 then
            grid[x + dir[1]/2][z + dir[2]/2] = 0
            carve(nx, nz)
        end
    end
end
carve(1, 1)
grid[tamano][tamano] = 0 -- salida
-- Construir paredes
for x = 1, tamano do
    for z = 1, tamano do
        if grid[x][z] == 1 then
            local pared = Instance.new('Part')
            pared.Size = Vector3.new(4, 6, 4)
            pared.Position = Vector3.new(x*4, 3, z*4)
            pared.BrickColor = BrickColor.new('Dark stone grey')
            pared.Anchored = true
            pared:SetAttribute("CreadoPorIA", true)
            pared:SetAttribute("CreacionTimestamp", timestamp)
            pared.Parent = workspace
        end
    end
end
]]
    end,
    
    estadio = function(tamano, forma)
        tamano = tamano or "mediano"
        forma = forma or "ovalado"
        local radio = tamano == "grande" and 50 or (tamano == "pequeno" and 25 or 35)
        return [[
local timestamp = os.time()
local radio = ]] .. radio .. [[
-- Campo central
local campo = Instance.new('Part')
campo.Size = Vector3.new(radio*2, 1, radio*1.5)
campo.Position = Vector3.new(0, 0, 0)
campo.BrickColor = BrickColor.new('Bright green')
campo.Material = Enum.Material.Grass
campo.Anchored = true
campo:SetAttribute("CreadoPorIA", true)
campo:SetAttribute("CreacionTimestamp", timestamp)
campo.Parent = workspace
-- Gradas en circulos concentricos
for nivel = 1, 8 do
    for angulo = 0, 360, 15 do
        local rad = math.rad(angulo)
        local dist = radio + nivel * 3
        local x = math.cos(rad) * dist
        local z = math.sin(rad) * dist
        local grada = Instance.new('Part')
        grada.Size = Vector3.new(3, 2, 3)
        grada.Position = Vector3.new(x, nivel * 2, z)
        grada.BrickColor = BrickColor.new('Medium stone grey')
        grada.Anchored = true
        grada:SetAttribute("CreadoPorIA", true)
        grada:SetAttribute("CreacionTimestamp", timestamp)
        grada.Parent = workspace
    end
end
]]
    end,
    
    ciudad = function(tamano, estilo)
        tamano = tamano or 10
        estilo = estilo or "moderno"
        return [[
local timestamp = os.time()
local tamano = ]] .. tamano .. [[
math.randomseed(tick())
-- Generar edificios en grid
for x = 1, tamano do
    for z = 1, tamano do
        if math.random() > 0.3 then -- 70% de probabilidad de edificio
            local altura = math.random(3, 15)
            local ancho = math.random(3, 6)
            local edificio = Instance.new('Part')
            edificio.Size = Vector3.new(ancho*2, altura*3, ancho*2)
            edificio.Position = Vector3.new(x*15, altura*1.5, z*15)
            edificio.BrickColor = BrickColor.new(({'Medium stone grey','Dark stone grey','White'})[math.random(3)])
            edificio.Material = Enum.Material.Concrete
            edificio.Anchored = true
            edificio:SetAttribute("CreadoPorIA", true)
            edificio:SetAttribute("CreacionTimestamp", timestamp)
            edificio.Parent = workspace
            -- Agregar ventanas (detalles)
            if ']] .. estilo .. [[' == 'moderno' then
                for piso = 1, altura, 2 do
                    local ventana = Instance.new('Part')
                    ventana.Size = Vector3.new(ancho*1.8, 1, 0.2)
                    ventana.Position = Vector3.new(x*15, piso*3, z*15 + ancho + 0.1)
                    ventana.BrickColor = BrickColor.new('Cyan')
                    ventana.Material = Enum.Material.Glass
                    ventana.Transparency = 0.5
                    ventana.Anchored = true
                    ventana:SetAttribute("CreadoPorIA", true)
                    ventana:SetAttribute("CreacionTimestamp", timestamp)
                    ventana.Parent = workspace
                end
            end
        end
    end
end
-- Calles
for x = 1, tamano*15, 15 do
    local calle = Instance.new('Part')
    calle.Size = Vector3.new(2, 0.1, tamano*15)
    calle.Position = Vector3.new(x, 0, tamano*7.5)
    calle.BrickColor = BrickColor.new('Black')
    calle.Material = Enum.Material.Asphalt
    calle.Anchored = true
    calle:SetAttribute("CreadoPorIA", true)
    calle:SetAttribute("CreacionTimestamp", timestamp)
    calle.Parent = workspace
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
        cesped   = "rbxasset://textures/grass.png",
        marmol   = "rbxasset://textures/marble.png",
        asfalto  = "rbxasset://textures/asphalt.png"
    },
    audios = {
        explosion     = "rbxassetid://165969964",
        click         = "rbxassetid://156785206",
        exito         = "rbxassetid://156286438",
        error         = "rbxassetid://156286380",
        construccion  = "rbxassetid://507863105",
        magia         = "rbxassetid://1843809278",
        laser         = "rbxassetid://130113322",
        teleport      = "rbxassetid://3194600974"
    },
    modelos = {
        arbol         = 0,
        carro         = 0,
        casa_moderna  = 0,
        lampara       = 0,
        fuente        = 0
    },
    skyboxes = {
        dia_claro = {
            bk = "rbxassetid://271042516",
            dn = "rbxassetid://271077243",
            ft = "rbxassetid://271042556",
            lf = "rbxassetid://271042310",
            rt = "rbxassetid://271042467",
            up = "rbxassetid://271077958"
        },
        noche_estrellada = {
            bk = "rbxassetid://159454286",
            dn = "rbxassetid://159454299",
            ft = "rbxassetid://159454296",
            lf = "rbxassetid://159454284",
            rt = "rbxassetid://159454293",
            up = "rbxassetid://159454288"
        },
        espacial = {
            bk = "rbxassetid://149397692",
            dn = "rbxassetid://149397686",
            ft = "rbxassetid://149397697",
            lf = "rbxassetid://149397684",
            rt = "rbxassetid://149397688",
            up = "rbxassetid://149397702"
        }
    },
    particulas = {
        fuego = {
            textura = "rbxasset://textures/particles/fire_main.dds",
            color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
        },
        humo = {
            textura = "rbxasset://textures/particles/smoke_main.dds",
            color = ColorSequence.new(Color3.fromRGB(100, 100, 100))
        },
        chispas = {
            textura = "rbxasset://textures/particles/sparkles_main.dds",
            color = ColorSequence.new(Color3.fromRGB(255, 255, 100))
        }
    }
}

-- ============================================================
-- COLORES (EXPANDIDOS)
-- ============================================================

Database.Colores = {
    {palabras = {"azul",    "blue"},                    brick = "Bright blue",   rgb = Color3.fromRGB(13,  105, 172)},
    {palabras = {"rojo",    "red"},                     brick = "Bright red",    rgb = Color3.fromRGB(196, 40,  28)},
    {palabras = {"verde",   "green"},                   brick = "Bright green",  rgb = Color3.fromRGB(75,  151, 75)},
    {palabras = {"amarillo","yellow"},                  brick = "Bright yellow", rgb = Color3.fromRGB(245, 205, 48)},
    {palabras = {"negro",   "black"},                   brick = "Black",         rgb = Color3.fromRGB(27,  42,  53)},
    {palabras = {"blanco",  "white"},                   brick = "White",         rgb = Color3.fromRGB(248, 248, 248)},
    {palabras = {"morado",  "purple", "violeta"},       brick = "Bright violet", rgb = Color3.fromRGB(107, 50,  124)},
    {palabras = {"naranja", "orange"},                  brick = "Bright orange", rgb = Color3.fromRGB(218, 133, 65)},
    {palabras = {"rosa",    "pink"},                    brick = "Hot pink",      rgb = Color3.fromRGB(255, 102, 204)},
    {palabras = {"gris",    "gray"},                    brick = "Mid gray",      rgb = Color3.fromRGB(163, 162, 165)},
    {palabras = {"marron",  "brown", "cafe"},           brick = "Reddish brown", rgb = Color3.fromRGB(105, 64,  40)},
    {palabras = {"cian",    "cyan",  "celeste"},        brick = "Cyan",          rgb = Color3.fromRGB(0,   255, 255)},
    {palabras = {"turquesa","turquoise"},               brick = "Teal",          rgb = Color3.fromRGB(18,  238, 212)},
    {palabras = {"dorado",  "gold", "oro"},             brick = "Gold",          rgb = Color3.fromRGB(255, 215, 0)},
    {palabras = {"plata",   "silver", "plateado"},      brick = "Silver",        rgb = Color3.fromRGB(192, 192, 192)},
    {palabras = {"bronce",  "bronze"},                  brick = "Bronze",        rgb = Color3.fromRGB(205, 127, 50)},
    {palabras = {"magenta"},                            brick = "Magenta",       rgb = Color3.fromRGB(255, 0,   255)},
    {palabras = {"lima",    "lime"},                    brick = "Lime green",    rgb = Color3.fromRGB(0,   255, 0)},
    {palabras = {"indigo"},                             brick = "Navy blue",     rgb = Color3.fromRGB(75,  0,   130)},
    {palabras = {"coral"},                              brick = "Salmon",        rgb = Color3.fromRGB(255, 127, 80)}
}

-- ============================================================
-- MATERIALES (EXPANDIDOS)
-- ============================================================

Database.Materiales = {
    {palabras = {"madera",   "wood"},                   material = "Wood"},
    {palabras = {"piedra",   "stone", "roca"},          material = "Slate"},
    {palabras = {"metal"},                              material = "Metal"},
    {palabras = {"vidrio",   "glass", "cristal"},       material = "Glass"},
    {palabras = {"neon"},                               material = "Neon"},
    {palabras = {"plastico", "plastic"},                material = "SmoothPlastic"},
    {palabras = {"ladrillo", "brick"},                  material = "Brick"},
    {palabras = {"marmol",   "marble"},                 material = "Marble"},
    {palabras = {"granito",  "granite"},                material = "Granite"},
    {palabras = {"concreto", "concrete", "cemento"},    material = "Concrete"},
    {palabras = {"asfalto",  "asphalt"},                material = "Asphalt"},
    {palabras = {"arena",    "sand"},                   material = "Sand"},
    {palabras = {"tela",     "fabric", "cloth"},        material = "Fabric"},
    {palabras = {"hielo",    "ice"},                    material = "Ice"},
    {palabras = {"lava"},                               material = "Basalt"},
    {palabras = {"esponja",  "foam"},                   material = "Foil"},
    {palabras = {"corcho",   "cork"},                   material = "WoodPlanks"},
    {palabras = {"pasto",    "grass", "cesped"},        material = "Grass"}
}

-- ============================================================
-- EXPLICACIONES (EXPANDIDAS)
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
    },
    ["que son plugins"] = {
        titulo   = "Sistema de Plugins",
        contenido = "Los plugins extienden mis capacidades. Pueden agregar comandos, construcciones, efectos y mas. Usa 'plugin listar' para ver los disponibles.",
        categoria = "plugins"
    },
    ["como crear plugin"] = {
        titulo   = "Como crear un plugin",
        contenido = "Los plugins son tablas Lua con estructura especifica. Incluyen info, comandos, construcciones y hooks. Consulta Database.PluginTemplate para la estructura.",
        categoria = "plugins"
    },
    ["que es tween"] = {
        titulo   = "Que es TweenService",
        contenido = "TweenService anima propiedades de objetos suavemente. Por ejemplo: mover una parte de A a B en 2 segundos.",
        categoria = "programacion"
    }
}

-- ============================================================
-- ESTADISTICAS (EXPANDIDAS)
-- ============================================================

Database.Estadisticas = {
    totalComandos         = 0,
    comandosExitosos      = 0,
    comandosFallidos      = 0,
    construccionesCreadas = 0,
    objetosCreados        = 0,
    efectosCreados        = 0,
    pluginsInstalados     = 0,
    tiempoTotal           = 0,
    fechaInstalacion      = os.time(),
    comandoMasUsado       = "",
    construccionFavorita  = ""
}

-- ============================================================
-- CONFIG (EXPANDIDA)
-- ============================================================

Database.Config = {
    version      = "2.0.0",
    autor        = "MOFUZII",
    github       = "https://github.com/MOFUZII/roblox-ia-constructor",
    actualizacion = "2026-02-12",
    comportamiento = {
        autoGuardar           = true,
        mostrarNotificaciones = true,
        usarSonidos           = true,
        modoDebug             = false,
        previewTransparente   = true,
        usarLevenshtein       = true,
        permitirPlugins       = true,
        autoOptimizar         = true
    },
    limites = {
        maxHistorial              = 100,
        maxConstruccionesPorVez   = 50,
        maxPartesTotal            = 1000,
        maxPluginsActivos         = 10,
        maxMemoriaPlugin          = 5000000, -- 5MB por plugin
        timeoutEjecucion          = 30 -- segundos
    },
    optimizacion = {
        usarInstanciadoMasivo     = true,
        agruparPorMaterial        = true,
        usarRegionParenting       = true,
        limitarRenderDistance     = true
    }
}

-- ============================================================
-- PATRONES DE LENGUAJE NATURAL (NUEVO)
-- ============================================================

Database.Patrones = {
    -- Patrones para interpretar comandos complejos
    preposiciones = {"en", "sobre", "bajo", "dentro", "fuera", "cerca", "lejos", "alrededor"},
    conectores = {"y", "con", "sin", "que", "de"},
    modificadores = {
        tamano = {"grande", "pequeno", "mediano", "enorme", "diminuto", "gigante"},
        velocidad = {"rapido", "lento", "normal", "muy rapido", "super lento"},
        cantidad = {"mucho", "poco", "varios", "algunos", "todos"}
    },
    -- Sinonimos comunes
    sinonimos = {
        crear = {"hacer", "construir", "generar", "fabricar", "edificar"},
        borrar = {"eliminar", "quitar", "destruir", "limpiar", "remover"},
        cambiar = {"modificar", "alterar", "transformar", "ajustar"},
        ver = {"mostrar", "visualizar", "display", "ensenar"}
    }
}

-- ============================================================
-- FUNCIONES (EXPANDIDAS)
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

-- NUEVAS FUNCIONES

function Database:buscarComandoSimilar(texto)
    -- Busca el comando mas similar usando distancia de Levenshtein
    local minDist = math.huge
    local mejorMatch = nil
    
    for nombre, _ in pairs(self.Comandos) do
        local dist = self:levenshtein(texto:lower(), nombre:lower())
        if dist < minDist and dist <= 3 then -- max 3 caracteres de diferencia
            minDist = dist
            mejorMatch = nombre
        end
    end
    
    return mejorMatch, minDist
end

function Database:levenshtein(s1, s2)
    local len1, len2 = #s1, #s2
    if len1 == 0 then return len2 end
    if len2 == 0 then return len1 end
    
    local matrix = {}
    for i = 0, len1 do matrix[i] = {[0] = i} end
    for j = 0, len2 do matrix[0][j] = j end
    
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (s1:sub(i,i) == s2:sub(j,j)) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i-1][j] + 1,
                matrix[i][j-1] + 1,
                matrix[i-1][j-1] + cost
            )
        end
    end
    
    return matrix[len1][len2]
end

function Database:obtenerPlugin(nombre)
    return self.Plugins.instalados[nombre]
end

function Database:listarPlugins()
    local lista = "PLUGINS INSTALADOS:\n\n"
    for nombre, plugin in pairs(self.Plugins.instalados) do
        local estado = self.Plugins.activos[nombre] and "[ACTIVO]" or "[INACTIVO]"
        lista = lista .. estado .. " " .. nombre .. " v" .. plugin.info.version .. "\n"
        lista = lista .. "  " .. plugin.info.descripcion .. "\n\n"
    end
    return lista
end

function Database:activarPlugin(nombre)
    if self.Plugins.instalados[nombre] then
        self.Plugins.activos[nombre] = true
        return true
    end
    return false
end

function Database:desactivarPlugin(nombre)
    if self.Plugins.instalados[nombre] then
        self.Plugins.activos[nombre] = false
        return true
    end
    return false
end

function Database:ejecutarHookPlugin(hookNombre, ...)
    for nombre, plugin in pairs(self.Plugins.instalados) do
        if self.Plugins.activos[nombre] and plugin.hooks and plugin.hooks[hookNombre] then
            local success, result = pcall(plugin.hooks[hookNombre], ...)
            if not success then
                warn("Error en hook '" .. hookNombre .. "' del plugin '" .. nombre .. "': " .. tostring(result))
            end
        end
    end
end

function Database:validarPermisos(plugin, permiso)
    if not plugin.info or not plugin.info.permisos then return false end
    for _, p in ipairs(plugin.info.permisos) do
        if p == permiso or p == "all" then return true end
    end
    return false
end

return Database
