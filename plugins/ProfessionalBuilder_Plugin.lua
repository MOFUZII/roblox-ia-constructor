-- ============================================================
-- PROFESSIONAL BUILDER PLUGIN v1.0
-- Construcciones de Alta Calidad
-- ============================================================
-- MEJORAS:
-- - Texturas y materiales realistas
-- - Iluminación profesional
-- - Detalles arquitectónicos
-- - Sombras y efectos
-- ============================================================

local ProfessionalBuilder = {
    info = {
        nombre = "ProfessionalBuilder",
        version = "1.0.0",
        autor = "MOFUZII",
        descripcion = "Construcciones profesionales de alta calidad",
        dependencias = {},
        permisos = {}
    },
    
    comandos = {},
    construcciones = {},
    interceptores = {},
    hooks = {}
}

-- ============================================================
-- MATERIALES Y TEXTURAS PROFESIONALES
-- ============================================================

local MaterialesPro = {
    maderaOscura = {material = "Wood", color = "Reddish brown"},
    maderaClara = {material = "Wood", color = "Nougat"},
    piedra = {material = "Slate", color = "Medium stone grey"},
    marmol = {material = "Marble", color = "White"},
    ladrilloRojo = {material = "Brick", color = "Bright red"},
    metalOscuro = {material = "Metal", color = "Black"},
    vidrio = {material = "Glass", color = "Institutional white", transparency = 0.5},
    neon = {material = "Neon", color = "Toothpaste"},
    granito = {material = "Granite", color = "Dark stone grey"},
    hormigon = {material = "Concrete", color = "Medium stone grey"}
}

-- ============================================================
-- FUNCIONES AUXILIARES
-- ============================================================

local function crearParteProfesional(config)
    local parte = Instance.new('Part')
    
    -- Tamaño y posición
    parte.Size = config.tamano or Vector3.new(4, 4, 4)
    parte.Position = config.posicion or Vector3.new(0, 5, 0)
    
    -- Material y color
    local mat = MaterialesPro[config.materialPro] or {material = "SmoothPlastic", color = "Medium stone grey"}
    parte.Material = Enum.Material[mat.material]
    parte.BrickColor = BrickColor.new(mat.color)
    
    -- Transparencia
    if mat.transparency then
        parte.Transparency = mat.transparency
    end
    
    -- Propiedades físicas
    parte.Anchored = config.anchored ~= false
    parte.CanCollide = config.colision ~= false
    parte.CastShadow = config.sombra ~= false
    
    -- Reflectividad
    if config.reflectante then
        parte.Reflectance = 0.3
    end
    
    -- Nombre
    parte.Name = config.nombre or "Parte"
    
    -- Atributos de seguimiento
    parte:SetAttribute("CreadoPorIA", true)
    parte:SetAttribute("CreacionTimestamp", os.time())
    parte:SetAttribute("Profesional", true)
    
    parte.Parent = workspace
    
    -- Agregar iluminación si se especifica
    if config.luz then
        local luz = Instance.new('PointLight')
        luz.Brightness = config.luzBrillo or 2
        luz.Color = config.luzColor or Color3.fromRGB(255, 200, 100)
        luz.Range = config.luzRango or 30
        luz.Parent = parte
    end
    
    -- Agregar sombra mejorada
    if config.sombraMejorada then
        parte.CastShadow = true
        local sombra = Instance.new('SurfaceGui')
        sombra.Face = Enum.NormalId.Bottom
        sombra.Parent = parte
    end
    
    return parte
end

local function agregarDetalles(parte, tipo)
    if tipo == "ventana" then
        -- Agregar marco de ventana
        local marco = Instance.new('SelectionBox')
        marco.LineThickness = 0.05
        marco.Color3 = Color3.fromRGB(100, 60, 40)
        marco.Adornee = parte
        marco.Parent = parte
    elseif tipo == "puerta" then
        -- Agregar manija
        local manija = Instance.new('Part')
        manija.Size = Vector3.new(0.2, 0.2, 0.3)
        manija.Position = parte.Position + Vector3.new(parte.Size.X/3, 0, parte.Size.Z/2 + 0.2)
        manija.BrickColor = BrickColor.new('Gold')
        manija.Material = Enum.Material.Metal
        manija.Shape = Enum.PartType.Ball
        manija.Anchored = true
        manija.Parent = workspace
    elseif tipo == "columna" then
        -- Agregar detalles decorativos
        for i = 0, 3 do
            local anillo = Instance.new('Part')
            anillo.Size = Vector3.new(parte.Size.X * 1.2, 0.3, parte.Size.Z * 1.2)
            anillo.Position = parte.Position + Vector3.new(0, (parte.Size.Y/2) - (i * parte.Size.Y/4), 0)
            anillo.BrickColor = BrickColor.new('Gold')
            anillo.Material = Enum.Material.Marble
            anillo.Anchored = true
            anillo.Parent = workspace
        end
    end
end

-- ============================================================
-- CONSTRUCCIONES PROFESIONALES
-- ============================================================

ProfessionalBuilder.construcciones = {
    
    ["mansionpro"] = function(params)
        return [[
-- MANSIÓN PROFESIONAL CON DETALLES
local function crearPartePro(tamano, pos, material, color, nombre)
    local p = Instance.new('Part')
    p.Size = tamano
    p.Position = pos
    p.Material = Enum.Material[material]
    p.BrickColor = BrickColor.new(color)
    p.Anchored = true
    p.CastShadow = true
    p.Name = nombre
    p:SetAttribute("CreadoPorIA", true)
    p:SetAttribute("CreacionTimestamp", os.time())
    p.Parent = workspace
    return p
end

-- Base de mármol
crearPartePro(Vector3.new(40, 1, 40), Vector3.new(0, 0, 0), "Marble", "White", "Base")

-- Paredes exteriores con textura de ladrillo
for i, pos in ipairs({{0, 8, 20}, {0, 8, -20}, {20, 8, 0}, {-20, 8, 0}}) do
    local pared = crearPartePro(Vector3.new(40, 16, 2), Vector3.new(pos[1], pos[2], pos[3]), "Brick", "Reddish brown", "Pared"..i)
    
    -- Agregar ventanas con vidrio
    for j = -15, 15, 10 do
        local ventana = Instance.new('Part')
        ventana.Size = Vector3.new(3, 5, 0.3)
        ventana.Position = pared.Position + Vector3.new(j, 0, 1.2)
        ventana.Material = Enum.Material.Glass
        ventana.BrickColor = BrickColor.new('Institutional white')
        ventana.Transparency = 0.5
        ventana.Anchored = true
        ventana.Parent = workspace
    end
end

-- Techo con tejas
local techo = crearPartePro(Vector3.new(42, 1, 42), Vector3.new(0, 17, 0), "Slate", "Dark stone grey", "Techo")

-- Columnas decorativas en las esquinas
for i, pos in ipairs({{-18, 8, -18}, {18, 8, -18}, {-18, 8, 18}, {18, 8, 18}}) do
    local columna = crearPartePro(Vector3.new(2, 16, 2), Vector3.new(pos[1], pos[2], pos[3]), "Marble", "White", "Columna"..i)
    
    -- Capitel de la columna (decoración superior)
    local capitel = crearPartePro(Vector3.new(3, 1, 3), Vector3.new(pos[1], 16, pos[3]), "Marble", "Gold", "Capitel"..i)
end

-- Puerta principal de madera con detalles
local puerta = crearPartePro(Vector3.new(6, 10, 0.5), Vector3.new(0, 5, -20.5), "Wood", "Reddish brown", "Puerta")

-- Manijas doradas
for i, xOffset in ipairs({-2, 2}) do
    local manija = Instance.new('Part')
    manija.Size = Vector3.new(0.3, 0.3, 0.5)
    manija.Position = puerta.Position + Vector3.new(xOffset, 0, -0.4)
    manija.BrickColor = BrickColor.new('Gold')
    manija.Material = Enum.Material.Metal
    manija.Shape = Enum.PartType.Ball
    manija.Anchored = true
    manija.Parent = workspace
end

-- Iluminación exterior (faroles)
for i, pos in ipairs({{-10, 6, -22}, {10, 6, -22}}) do
    local farol = Instance.new('Part')
    farol.Size = Vector3.new(1, 8, 1)
    farol.Position = Vector3.new(pos[1], pos[2], pos[3])
    farol.Material = Enum.Material.Metal
    farol.BrickColor = BrickColor.new('Black')
    farol.Anchored = true
    farol.Parent = workspace
    
    -- Luz del farol
    local lampara = Instance.new('Part')
    lampara.Size = Vector3.new(2, 2, 2)
    lampara.Position = Vector3.new(pos[1], 10, pos[3])
    lampara.Material = Enum.Material.Neon
    lampara.BrickColor = BrickColor.new('Bright yellow')
    lampara.Shape = Enum.PartType.Ball
    lampara.Anchored = true
    lampara.Parent = workspace
    
    local luz = Instance.new('PointLight')
    luz.Brightness = 3
    luz.Color = Color3.fromRGB(255, 200, 100)
    luz.Range = 40
    luz.Parent = lampara
end

-- Jardín frontal con césped
local cesped = crearPartePro(Vector3.new(60, 0.5, 20), Vector3.new(0, -0.5, -30), "Grass", "Bright green", "Cesped")
]]
    end,
    
    ["rascacielos"] = function(params)
        local altura = 50
        if params and params[1] then
            altura = tonumber(params[1]) or 50
        end
        
        return [[
-- RASCACIELOS PROFESIONAL
local altura = ]] .. altura .. [[

-- Estructura principal de vidrio y acero
for piso = 0, altura do
    -- Marco de acero
    for i, pos in ipairs({{-12, 0, -12}, {12, 0, -12}, {-12, 0, 12}, {12, 0, 12}}) do
        local columna = Instance.new('Part')
        columna.Size = Vector3.new(1, 3, 1)
        columna.Position = Vector3.new(pos[1], piso * 3 + 1.5, pos[3])
        columna.Material = Enum.Material.Metal
        columna.BrickColor = BrickColor.new('Dark stone grey')
        columna.Anchored = true
        columna:SetAttribute("CreadoPorIA", true)
        columna:SetAttribute("CreacionTimestamp", os.time())
        columna.Parent = workspace
    end
    
    -- Paredes de vidrio
    if piso > 0 then
        for i, config in ipairs({
            {Vector3.new(24, 3, 0.5), Vector3.new(0, piso * 3 + 1.5, 12)},
            {Vector3.new(24, 3, 0.5), Vector3.new(0, piso * 3 + 1.5, -12)},
            {Vector3.new(0.5, 3, 24), Vector3.new(12, piso * 3 + 1.5, 0)},
            {Vector3.new(0.5, 3, 24), Vector3.new(-12, piso * 3 + 1.5, 0)}
        }) do
            local pared = Instance.new('Part')
            pared.Size = config[1]
            pared.Position = config[2]
            pared.Material = Enum.Material.Glass
            pared.BrickColor = BrickColor.new('Institutional white')
            pared.Transparency = 0.3
            pared.Reflectance = 0.4
            pared.Anchored = true
            pared:SetAttribute("CreadoPorIA", true)
            pared:SetAttribute("CreacionTimestamp", os.time())
            pared.Parent = workspace
        end
    end
    
    -- Piso interior
    if piso > 0 and piso % 3 == 0 then
        local piso_parte = Instance.new('Part')
        piso_parte.Size = Vector3.new(24, 0.5, 24)
        piso_parte.Position = Vector3.new(0, piso * 3, 0)
        piso_parte.Material = Enum.Material.Concrete
        piso_parte.BrickColor = BrickColor.new('Medium stone grey')
        piso_parte.Anchored = true
        piso_parte:SetAttribute("CreadoPorIA", true)
        piso_parte:SetAttribute("CreacionTimestamp", os.time())
        piso_parte.Parent = workspace
    end
end

-- Antena en la cima
local antena = Instance.new('Part')
antena.Size = Vector3.new(0.5, 20, 0.5)
antena.Position = Vector3.new(0, altura * 3 + 10, 0)
antena.Material = Enum.Material.Metal
antena.BrickColor = BrickColor.new('Really red')
antena.Anchored = true
antena.Parent = workspace

-- Luz de advertencia en la antena
local luzAntena = Instance.new('Part')
luzAntena.Size = Vector3.new(1, 1, 1)
luzAntena.Position = Vector3.new(0, altura * 3 + 20, 0)
luzAntena.Material = Enum.Material.Neon
luzAntena.BrickColor = BrickColor.new('Really red')
luzAntena.Shape = Enum.PartType.Ball
luzAntena.Anchored = true
luzAntena.Parent = workspace

local luz = Instance.new('PointLight')
luz.Brightness = 5
luz.Color = Color3.fromRGB(255, 0, 0)
luz.Range = 60
luz.Parent = luzAntena
]]
    end,
    
    ["temploantiguo"] = function(params)
        return [[
-- TEMPLO ANTIGUO CON DETALLES HISTÓRICOS
local function crearColumna(posX, posZ)
    -- Base de la columna
    local base = Instance.new('Part')
    base.Size = Vector3.new(3, 1, 3)
    base.Position = Vector3.new(posX, 0.5, posZ)
    base.Material = Enum.Material.Marble
    base.BrickColor = BrickColor.new('White')
    base.Anchored = true
    base:SetAttribute("CreadoPorIA", true)
    base:SetAttribute("CreacionTimestamp", os.time())
    base.Parent = workspace
    
    -- Cuerpo de la columna
    local columna = Instance.new('Part')
    columna.Size = Vector3.new(2, 15, 2)
    columna.Position = Vector3.new(posX, 8, posZ)
    columna.Material = Enum.Material.Marble
    columna.BrickColor = BrickColor.new('White')
    columna.Anchored = true
    columna:SetAttribute("CreadoPorIA", true)
    columna:SetAttribute("CreacionTimestamp", os.time())
    columna.Parent = workspace
    
    -- Estrías (detalles)
    for i = 1, 8 do
        local estria = Instance.new('Part')
        estria.Size = Vector3.new(0.2, 15, 0.2)
        local angulo = (i / 8) * math.pi * 2
        local offset = 1
        estria.Position = Vector3.new(
            posX + math.cos(angulo) * offset,
            8,
            posZ + math.sin(angulo) * offset
        )
        estria.Material = Enum.Material.Marble
        estria.BrickColor = BrickColor.new('Medium stone grey')
        estria.Anchored = true
        estria.Parent = workspace
    end
    
    -- Capitel (parte superior decorativa)
    local capitel = Instance.new('Part')
    capitel.Size = Vector3.new(3, 2, 3)
    capitel.Position = Vector3.new(posX, 16, posZ)
    capitel.Material = Enum.Material.Marble
    capitel.BrickColor = BrickColor.new('Gold')
    capitel.Anchored = true
    capitel.Parent = workspace
end

-- Plataforma base del templo
local plataforma = Instance.new('Part')
plataforma.Size = Vector3.new(50, 2, 40)
plataforma.Position = Vector3.new(0, -1, 0)
plataforma.Material = Enum.Material.Granite
plataforma.BrickColor = BrickColor.new('Medium stone grey')
plataforma.Anchored = true
plataforma:SetAttribute("CreadoPorIA", true)
plataforma:SetAttribute("CreacionTimestamp", os.time())
plataforma.Parent = workspace

-- Escaleras frontales
for i = 0, 10 do
    local escalon = Instance.new('Part')
    escalon.Size = Vector3.new(20, 0.5, 3)
    escalon.Position = Vector3.new(0, i * 0.5 - 1, -20 + i * 1.5)
    escalon.Material = Enum.Material.Marble
    escalon.BrickColor = BrickColor.new('White')
    escalon.Anchored = true
    escalon:SetAttribute("CreadoPorIA", true)
    escalon:SetAttribute("CreacionTimestamp", os.time())
    escalon.Parent = workspace
end

-- Columnas frontales (6 columnas)
for i = -15, 15, 6 do
    crearColumna(i, -10)
end

-- Columnas laterales
for z = -5, 10, 7.5 do
    crearColumna(-20, z)
    crearColumna(20, z)
end

-- Techo triangular (frontón)
local techo = Instance.new('Part')
techo.Size = Vector3.new(50, 1, 40)
techo.Position = Vector3.new(0, 17, 0)
techo.Material = Enum.Material.Slate
techo.BrickColor = BrickColor.new('Dark stone grey')
techo.Anchored = true
techo.Parent = workspace

-- Frontón triangular decorativo
for i = 0, 5 do
    local triangulo = Instance.new('WedgePart')
    triangulo.Size = Vector3.new(30 - i*5, 2, 2)
    triangulo.Position = Vector3.new(0, 18 + i, -19)
    triangulo.Material = Enum.Material.Marble
    triangulo.BrickColor = BrickColor.new('White')
    triangulo.Anchored = true
    triangulo.Parent = workspace
end

-- Antorcha ceremonial (iluminación)
for i, posX in ipairs({-18, 18}) do
    local antorcha = Instance.new('Part')
    antorcha.Size = Vector3.new(1, 5, 1)
    antorcha.Position = Vector3.new(posX, 2.5, -15)
    antorcha.Material = Enum.Material.Wood
    antorcha.BrickColor = BrickColor.new('Reddish brown')
    antorcha.Anchored = true
    antorcha.Parent = workspace
    
    -- Fuego de la antorcha
    local fuego = Instance.new('Part')
    fuego.Size = Vector3.new(2, 2, 2)
    fuego.Position = Vector3.new(posX, 6, -15)
    fuego.Material = Enum.Material.Neon
    fuego.BrickColor = BrickColor.new('Deep orange')
    fuego.Shape = Enum.PartType.Ball
    fuego.Anchored = true
    fuego.Parent = workspace
    
    local luz = Instance.new('PointLight')
    luz.Brightness = 4
    luz.Color = Color3.fromRGB(255, 100, 0)
    luz.Range = 35
    luz.Parent = fuego
    
    -- Efecto de partículas de fuego
    local fire = Instance.new('Fire')
    fire.Size = 8
    fire.Heat = 10
    fire.Parent = fuego
end
]]
    end
}

-- ============================================================
-- COMANDOS
-- ============================================================

ProfessionalBuilder.comandos = {
    
    ["mansionpro"] = {
        tipo = "construccion",
        descripcion = "Mansión profesional con detalles arquitectónicos",
        parametros = {},
        ejemplos = {"mansionpro"},
        categoria = "construccion"
    },
    
    ["rascacielos"] = {
        tipo = "construccion",
        descripcion = "Rascacielos moderno de vidrio y acero",
        parametros = {"altura"},
        ejemplos = {"rascacielos", "rascacielos 100"},
        categoria = "construccion"
    },
    
    ["temploantiguo"] = {
        tipo = "construccion",
        descripcion = "Templo griego antiguo con columnas",
        parametros = {},
        ejemplos = {"temploantiguo"},
        categoria = "construccion"
    }
}

-- ============================================================
-- HOOKS
-- ============================================================

ProfessionalBuilder.hooks = {
    
    onInit = function()
        print("[ProfessionalBuilder] 🏛️ Sistema de construcciones profesionales iniciado")
    end,
    
    onConstruccionCreada = function(nombre)
        if nombre == "mansionpro" or nombre == "rascacielos" or nombre == "temploantiguo" then
            print("[ProfessionalBuilder] ✨ Construcción profesional creada: " .. nombre)
        end
    end
}

-- ============================================================
-- RETORNAR PLUGIN
-- ============================================================

return ProfessionalBuilder

