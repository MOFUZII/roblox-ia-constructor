-- ============================================================
-- PLUGIN: ANIMATION MASTER
-- Sistema completo de animaciones para construcciones
-- Version: 1.0.0 | Autor: MOFUZII
-- ============================================================

local AnimationMaster = {
    info = {
        nombre = "AnimationMaster",
        version = "1.0.0",
        autor = "MOFUZII",
        descripcion = "Agrega animaciones automaticas a cualquier construccion",
        dependencias = {},
        permisos = {"workspace", "tweenservice", "runservice"}
    },
    
    -- ========================================================
    -- COMANDOS QUE AGREGA ESTE PLUGIN
    -- ========================================================
    comandos = {
        ["rotar"] = {
            tipo = "animacion",
            descripcion = "Hace rotar objetos continuamente",
            parametros = {"velocidad", "eje"},
            ejemplos = {"rotar rapido", "rotar lento eje y"},
            categoria = "animacion"
        },
        ["flotar"] = {
            tipo = "animacion",
            descripcion = "Hace flotar objetos arriba y abajo",
            parametros = {"amplitud", "velocidad"},
            ejemplos = {"flotar", "flotar suave", "flotar rapido"},
            categoria = "animacion"
        },
        ["pulsar"] = {
            tipo = "animacion",
            descripcion = "Hace pulsar el tamano del objeto",
            parametros = {"intensidad"},
            ejemplos = {"pulsar", "pulsar intenso"},
            categoria = "animacion"
        },
        ["orbitar"] = {
            tipo = "animacion",
            descripcion = "Hace orbitar objetos alrededor de un punto",
            parametros = {"radio", "velocidad"},
            ejemplos = {"orbitar", "orbitar grande rapido"},
            categoria = "animacion"
        },
        ["onda"] = {
            tipo = "animacion",
            descripcion = "Crea efecto de onda en construcciones",
            parametros = {"amplitud", "frecuencia"},
            ejemplos = {"onda", "onda intensa"},
            categoria = "animacion"
        },
        ["arcoiris"] = {
            tipo = "animacion",
            descripcion = "Cambia colores en ciclo arcoiris",
            parametros = {"velocidad"},
            ejemplos = {"arcoiris", "arcoiris rapido"},
            categoria = "animacion"
        },
        ["explotar"] = {
            tipo = "animacion",
            descripcion = "Animacion de explosion (partes vuelan)",
            parametros = {"fuerza"},
            ejemplos = {"explotar", "explotar fuerte"},
            categoria = "animacion"
        },
        ["construir"] = {
            tipo = "animacion",
            descripcion = "Animacion de construccion (aparece progresivamente)",
            parametros = {"velocidad"},
            ejemplos = {"construir lento", "construir"},
            categoria = "animacion"
        },
        ["disolver"] = {
            tipo = "animacion",
            descripcion = "Disuelve objetos gradualmente",
            parametros = {"velocidad"},
            ejemplos = {"disolver", "disolver rapido"},
            categoria = "animacion"
        },
        ["teletransportar"] = {
            tipo = "animacion",
            descripcion = "Teletransporta con efecto visual",
            parametros = {"x", "y", "z"},
            ejemplos = {"teletransportar 0 50 0"},
            categoria = "animacion"
        }
    },
    
    -- ========================================================
    -- CONSTRUCCIONES (ESTE PLUGIN NO AGREGA CONSTRUCCIONES)
    -- ========================================================
    construcciones = {},
    
    -- ========================================================
    -- INTERCEPTORES DE SERVICIOS
    -- ========================================================
    interceptores = {
        ["TweenService"] = function()
            return game:GetService("TweenService")
        end,
        ["RunService"] = function()
            return game:GetService("RunService")
        end
    },
    
    -- ========================================================
    -- HOOKS DEL SISTEMA
    -- ========================================================
    hooks = {
        onInit = function()
            print("[AnimationMaster] Plugin de animaciones cargado!")
            print("[AnimationMaster] Comandos disponibles: rotar, flotar, pulsar, orbitar, onda, arcoiris")
        end,
        
        onComandoEjecutado = function(comando)
            -- Detectar cuando se crea una construccion
            if comando == "torre" or comando == "piramide" or comando == "casa" then
                print("[AnimationMaster] Construccion detectada: " .. comando)
                print("[AnimationMaster] Usa 'rotar' o 'flotar' para animarla!")
            end
        end,
        
        onConstruccionCreada = function(nombre)
            print("[AnimationMaster] Construccion '" .. nombre .. "' lista para animar!")
        end,
        
        onError = function(errorData)
            warn("[AnimationMaster] Error detectado en comando: " .. errorData.comando)
        end
    }
}

-- ============================================================
-- FUNCIONES GENERADORAS DE CODIGO
-- Estas funciones retornan codigo Lua que se ejecuta
-- ============================================================

-- Funcion auxiliar para encontrar ultima construccion
local function obtenerUltimasConstrucciones()
    return [[
local objetivos = {}
local ultimoTimestamp = 0

-- Encontrar timestamp mas reciente
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj:GetAttribute("CreadoPorIA") then
        local ts = obj:GetAttribute("CreacionTimestamp")
        if ts and ts > ultimoTimestamp then
            ultimoTimestamp = ts
        end
    end
end

-- Recolectar objetos con ese timestamp
if ultimoTimestamp > 0 then
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("CreadoPorIA") then
            local ts = obj:GetAttribute("CreacionTimestamp")
            if ts == ultimoTimestamp then
                table.insert(objetivos, obj)
            end
        end
    end
end

if #objetivos == 0 then
    warn("[AnimationMaster] No hay construcciones recientes para animar")
end
]]
end

-- ROTAR
AnimationMaster.generarRotacion = function(velocidad, eje)
    velocidad = velocidad or "normal"
    eje = eje or "y"
    
    local rpm = 15
    if velocidad == "rapido" then rpm = 30
    elseif velocidad == "lento" then rpm = 5
    elseif velocidad == "super rapido" then rpm = 60 end
    
    local ejeX, ejeY, ejeZ = 0, 0, 0
    if eje == "x" then ejeX = 1
    elseif eje == "y" then ejeY = 1
    elseif eje == "z" then ejeZ = 1
    else ejeY = 1 end -- default eje Y
    
    return obtenerUltimasConstrucciones() .. [[
local TweenService = game:GetService("TweenService")

for _, parte in ipairs(objetivos) do
    if parte.Anchored then
        -- Usar CFrame para rotacion continua
        local RunService = game:GetService("RunService")
        local velocidadAngular = math.rad(360 / (60/]] .. rpm .. [[))
        
        RunService.Heartbeat:Connect(function(dt)
            if parte and parte.Parent then
                parte.CFrame = parte.CFrame * CFrame.Angles(
                    ]] .. ejeX .. [[ * velocidadAngular * dt,
                    ]] .. ejeY .. [[ * velocidadAngular * dt,
                    ]] .. ejeZ .. [[ * velocidadAngular * dt
                )
            end
        end)
    else
        -- Usar BodyAngularVelocity para partes no ancladas
        local angularVel = Instance.new("BodyAngularVelocity")
        angularVel.MaxTorque = Vector3.new(4e6, 4e6, 4e6)
        angularVel.AngularVelocity = Vector3.new(
            ]] .. ejeX .. [[ * ]] .. rpm .. [[,
            ]] .. ejeY .. [[ * ]] .. rpm .. [[,
            ]] .. ejeZ .. [[ * ]] .. rpm .. [[
        )
        angularVel.Parent = parte
    end
end

print("[AnimationMaster] Rotacion aplicada a " .. #objetivos .. " objetos")
]]
end

-- FLOTAR
AnimationMaster.generarFlotacion = function(amplitud, velocidad)
    amplitud = amplitud or "normal"
    velocidad = velocidad or "normal"
    
    local amp = 3
    if amplitud == "suave" then amp = 1
    elseif amplitud == "intensa" then amp = 6 end
    
    local freq = 2
    if velocidad == "lento" then freq = 1
    elseif velocidad == "rapido" then freq = 4 end
    
    return obtenerUltimasConstrucciones() .. [[
local RunService = game:GetService("RunService")
local tiempo = 0
local posicionesIniciales = {}

for _, parte in ipairs(objetivos) do
    posicionesIniciales[parte] = parte.Position
end

RunService.Heartbeat:Connect(function(dt)
    tiempo = tiempo + dt
    for parte, posInicial in pairs(posicionesIniciales) do
        if parte and parte.Parent then
            local offset = math.sin(tiempo * ]] .. freq .. [[) * ]] .. amp .. [[
            parte.Position = posInicial + Vector3.new(0, offset, 0)
        end
    end
end)

print("[AnimationMaster] Flotacion aplicada a " .. #objetivos .. " objetos")
]]
end

-- PULSAR
AnimationMaster.generarPulsacion = function(intensidad)
    intensidad = intensidad or "normal"
    
    local factor = 1.2
    if intensidad == "suave" then factor = 1.1
    elseif intensidad == "intenso" then factor = 1.5 end
    
    return obtenerUltimasConstrucciones() .. [[
local TweenService = game:GetService("TweenService")

for _, parte in ipairs(objetivos) do
    local tamanoOriginal = parte.Size
    local tamanoGrande = tamanoOriginal * ]] .. factor .. [[
    
    local info = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut,
        -1,
        true
    )
    
    local tween = TweenService:Create(parte, info, {Size = tamanoGrande})
    tween:Play()
end

print("[AnimationMaster] Pulsacion aplicada a " .. #objetivos .. " objetos")
]]
end

-- ORBITAR
AnimationMaster.generarOrbitacion = function(radio, velocidad)
    radio = radio or "normal"
    velocidad = velocidad or "normal"
    
    local r = 10
    if radio == "pequeno" then r = 5
    elseif radio == "grande" then r = 20 end
    
    local freq = 2
    if velocidad == "lento" then freq = 1
    elseif velocidad == "rapido" then freq = 4 end
    
    return obtenerUltimasConstrucciones() .. [[
local RunService = game:GetService("RunService")
local centro = Vector3.new(0, 10, 0)

-- Calcular centro promedio de los objetos
if #objetivos > 0 then
    local suma = Vector3.new(0, 0, 0)
    for _, parte in ipairs(objetivos) do
        suma = suma + parte.Position
    end
    centro = suma / #objetivos
end

local tiempo = 0
local angulosIniciales = {}

for i, parte in ipairs(objetivos) do
    angulosIniciales[parte] = (i - 1) * (360 / #objetivos)
end

RunService.Heartbeat:Connect(function(dt)
    tiempo = tiempo + dt
    for parte, anguloInicial in pairs(angulosIniciales) do
        if parte and parte.Parent then
            local angulo = math.rad(anguloInicial + tiempo * ]] .. freq .. [[ * 60)
            local x = centro.X + math.cos(angulo) * ]] .. r .. [[
            local z = centro.Z + math.sin(angulo) * ]] .. r .. [[
            parte.Position = Vector3.new(x, centro.Y, z)
        end
    end
end)

print("[AnimationMaster] Orbitacion aplicada a " .. #objetivos .. " objetos")
]]
end

-- ONDA
AnimationMaster.generarOnda = function(amplitud, frecuencia)
    amplitud = amplitud or "normal"
    frecuencia = frecuencia or "normal"
    
    local amp = 3
    if amplitud == "suave" then amp = 1
    elseif amplitud == "intensa" then amp = 6 end
    
    local freq = 2
    if frecuencia == "baja" then freq = 1
    elseif frecuencia == "alta" then freq = 4 end
    
    return obtenerUltimasConstrucciones() .. [[
local RunService = game:GetService("RunService")
local tiempo = 0
local posicionesIniciales = {}

for _, parte in ipairs(objetivos) do
    posicionesIniciales[parte] = parte.Position
end

RunService.Heartbeat:Connect(function(dt)
    tiempo = tiempo + dt
    for parte, posInicial in pairs(posicionesIniciales) do
        if parte and parte.Parent then
            local distancia = (posInicial - Vector3.new(0, 0, 0)).Magnitude
            local offset = math.sin(tiempo * ]] .. freq .. [[ + distancia * 0.1) * ]] .. amp .. [[
            parte.Position = posInicial + Vector3.new(0, offset, 0)
        end
    end
end)

print("[AnimationMaster] Efecto de onda aplicado a " .. #objetivos .. " objetos")
]]
end

-- ARCOIRIS
AnimationMaster.generarArcoiris = function(velocidad)
    velocidad = velocidad or "normal"
    
    local freq = 1
    if velocidad == "lento" then freq = 0.5
    elseif velocidad == "rapido" then freq = 2 end
    
    return obtenerUltimasConstrucciones() .. [[
local RunService = game:GetService("RunService")
local tiempo = 0

RunService.Heartbeat:Connect(function(dt)
    tiempo = tiempo + dt
    for _, parte in ipairs(objetivos) do
        if parte and parte.Parent then
            local hue = (tiempo * ]] .. freq .. [[ * 60) % 360
            parte.Color = Color3.fromHSV(hue / 360, 1, 1)
        end
    end
end)

print("[AnimationMaster] Efecto arcoiris aplicado a " .. #objetivos .. " objetos")
]]
end

-- EXPLOTAR
AnimationMaster.generarExplosion = function(fuerza)
    fuerza = fuerza or "normal"
    
    local f = 50
    if fuerza == "suave" then f = 25
    elseif fuerza == "fuerte" then f = 100 end
    
    return obtenerUltimasConstrucciones() .. [[
local centro = Vector3.new(0, 10, 0)

-- Calcular centro
if #objetivos > 0 then
    local suma = Vector3.new(0, 0, 0)
    for _, parte in ipairs(objetivos) do
        suma = suma + parte.Position
    end
    centro = suma / #objetivos
end

for _, parte in ipairs(objetivos) do
    parte.Anchored = false
    
    local direccion = (parte.Position - centro).Unit
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(4e6, 4e6, 4e6)
    bodyVel.Velocity = direccion * ]] .. f .. [[
    bodyVel.Parent = parte
    
    -- Eliminar BodyVelocity despues de 1 segundo
    task.delay(1, function()
        if bodyVel and bodyVel.Parent then
            bodyVel:Destroy()
        end
    end)
end

-- Efecto de explosion visual
local explosion = Instance.new("Explosion")
explosion.Position = centro
explosion.BlastRadius = 20
explosion.BlastPressure = 0
explosion.Parent = workspace

print("[AnimationMaster] Explosion aplicada a " .. #objetivos .. " objetos")
]]
end

-- CONSTRUIR (aparece progresivamente)
AnimationMaster.generarConstruccion = function(velocidad)
    velocidad = velocidad or "normal"
    
    local delay = 0.1
    if velocidad == "lento" then delay = 0.3
    elseif velocidad == "rapido" then delay = 0.05 end
    
    return obtenerUltimasConstrucciones() .. [[
for _, parte in ipairs(objetivos) do
    parte.Transparency = 1
end

task.spawn(function()
    for i, parte in ipairs(objetivos) do
        task.wait(]] .. delay .. [[)
        if parte and parte.Parent then
            local TweenService = game:GetService("TweenService")
            local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(parte, info, {Transparency = 0})
            tween:Play()
            
            -- Sonido de construccion
            local sonido = Instance.new("Sound")
            sonido.SoundId = "rbxassetid://156785206"
            sonido.Volume = 0.2
            sonido.Parent = parte
            sonido:Play()
            sonido.Ended:Connect(function() sonido:Destroy() end)
        end
    end
end)

print("[AnimationMaster] Animacion de construccion iniciada para " .. #objetivos .. " objetos")
]]
end

-- DISOLVER
AnimationMaster.generarDisolucion = function(velocidad)
    velocidad = velocidad or "normal"
    
    local duracion = 2
    if velocidad == "lento" then duracion = 4
    elseif velocidad == "rapido" then duracion = 1 end
    
    return obtenerUltimasConstrucciones() .. [[
local TweenService = game:GetService("TweenService")

for _, parte in ipairs(objetivos) do
    local info = TweenInfo.new(]] .. duracion .. [[, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tween = TweenService:Create(parte, info, {Transparency = 1})
    tween:Play()
    
    task.delay(]] .. duracion .. [[, function()
        if parte and parte.Parent then
            parte:Destroy()
        end
    end)
end

print("[AnimationMaster] Disolucion aplicada a " .. #objetivos .. " objetos")
]]
end

-- TELETRANSPORTAR
AnimationMaster.generarTeletransporte = function(x, y, z)
    x = x or 0
    y = y or 50
    z = z or 0
    
    return obtenerUltimasConstrucciones() .. [[
local TweenService = game:GetService("TweenService")
local destino = Vector3.new(]] .. x .. [[, ]] .. y .. [[, ]] .. z .. [[)

-- Calcular centro actual
local centroActual = Vector3.new(0, 0, 0)
if #objetivos > 0 then
    local suma = Vector3.new(0, 0, 0)
    for _, parte in ipairs(objetivos) do
        suma = suma + parte.Position
    end
    centroActual = suma / #objetivos
end

local offset = destino - centroActual

for _, parte in ipairs(objetivos) do
    -- Efecto de particulas
    local particulas = Instance.new("ParticleEmitter")
    particulas.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particulas.Rate = 100
    particulas.Lifetime = NumberRange.new(0.5)
    particulas.Speed = NumberRange.new(5)
    particulas.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))
    particulas.Parent = parte
    
    task.delay(0.5, function()
        if particulas and particulas.Parent then
            particulas:Destroy()
        end
    end)
    
    -- Tween de teletransporte
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(parte, info, {Position = parte.Position + offset})
    tween:Play()
end

-- Sonido de teletransporte
local sonido = Instance.new("Sound")
sonido.SoundId = "rbxassetid://3194600974"
sonido.Volume = 0.5
sonido.Parent = workspace
sonido:Play()
sonido.Ended:Connect(function() sonido:Destroy() end)

print("[AnimationMaster] Teletransporte aplicado a " .. #objetivos .. " objetos")
]]
end

-- ============================================================
-- EXPORTAR PLUGIN
-- ============================================================

return AnimationMaster
