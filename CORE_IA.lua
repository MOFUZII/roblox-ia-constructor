-- ============================================================
-- CORE_IA.LUA v3.2.5 - SIN SPLASH SCREEN
-- Sistema Principal - DIRECTO, sin pantalla de carga
-- ============================================================

print("[IA Constructor] Iniciando sistema v3.2.5...")

local URLS = {
    Database     = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/Database_Mejorado.lua",
    UI_Library   = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/UI_Library.lua",
    SmartAI      = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/SmartResponses.lua",
    Plugins = {
        AnimationMaster = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/AnimationMaster_Plugin.lua",
        HybridLearning  = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/plugins/HybridLearning_Plugin.lua",
        PersonalityAI   = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/plugins/PersonalityAI_Plugin.lua",
    }
}

local Modulos = {}

local function cargarModulo(nombre, url)
    print("[IA Constructor] Cargando: " .. nombre)
    local ok, resultado = pcall(function()
        local codigo = game:HttpGet(url)
        if not codigo or codigo == "" then
            error("Contenido vacío")
        end
        local fn = loadstring(codigo)
        if fn then return fn() end
        error("loadstring falló")
    end)
    if ok and resultado then
        print("[IA Constructor] ✅ OK: " .. nombre)
        return resultado
    else
        warn("[IA Constructor] ❌ ERROR: " .. nombre)
        warn("[IA Constructor] Razón: " .. tostring(resultado))
        return nil
    end
end

-- ============================================================
-- CARGAR MÓDULOS BASE
-- ============================================================

Modulos.Database = cargarModulo("Database", URLS.Database)
if not Modulos.Database then error("[IA Constructor] No se pudo cargar Database.") end

Modulos.UI = cargarModulo("UI_Library", URLS.UI_Library)
if not Modulos.UI then error("[IA Constructor] No se pudo cargar UI_Library.") end

Modulos.SmartAI = cargarModulo("SmartAI", URLS.SmartAI)
if not Modulos.SmartAI then 
    warn("[IA Constructor] ⚠️ SmartAI no disponible - usando respuestas básicas")
else
    print("[IA Constructor] ✅ SmartAI cargado - Respuestas inteligentes activadas")
end

print("[IA Constructor] ✅ Módulos base cargados OK")

-- ============================================================
-- SISTEMA DE PLUGINS
-- ============================================================

print("[IA Constructor] Inicializando sistema de plugins...")

local function cargarPlugins()
    local pluginsCargados = 0
    local pluginsFallidos = 0
    
    for nombre, url in pairs(URLS.Plugins) do
        print("[IA Constructor] Intentando cargar plugin: " .. nombre)
        local success, plugin = pcall(function()
            local codigo = game:HttpGet(url)
            if not codigo or codigo == "" then
                error("Archivo vacío o no existe")
            end
            return loadstring(codigo)()
        end)
        
        if success and plugin then
            if plugin.info and plugin.comandos then
                local instalado, mensaje = Modulos.Database:instalarPlugin(plugin)
                if instalado then
                    print("[IA Constructor] ✅ Plugin '" .. nombre .. "' instalado correctamente")
                    pluginsCargados = pluginsCargados + 1
                else
                    warn("[IA Constructor] ❌ Error al instalar '" .. nombre .. "': " .. mensaje)
                    pluginsFallidos = pluginsFallidos + 1
                end
            else
                warn("[IA Constructor] ❌ Plugin '" .. nombre .. "' tiene estructura inválida")
                pluginsFallidos = pluginsFallidos + 1
            end
        else
            warn("[IA Constructor] ❌ Error al cargar plugin '" .. nombre .. "'")
            pluginsFallidos = pluginsFallidos + 1
        end
    end
    
    print("[IA Constructor] Plugins cargados: " .. pluginsCargados .. " | Fallidos: " .. pluginsFallidos)
    return pluginsCargados
end

local pluginsActivos = 0
if Modulos.Database.instalarPlugin then
    pluginsActivos = cargarPlugins()
else
    warn("[IA Constructor] ⚠️ Database no soporta plugins")
end

-- ============================================================
-- VARIABLES GLOBALES
-- ============================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player           = Players.LocalPlayer

local estadoIA = { pensando = false, ultimoComando = "" }
local historialAcciones = {}

-- ============================================================
-- FUNCIONES AUXILIARES
-- ============================================================

local function normalizarTexto(texto)
    if not texto then return "" end
    return texto:lower():gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function contiene(texto, palabras)
    if type(palabras) == "string" then palabras = {palabras} end
    texto = normalizarTexto(texto)
    for _, palabra in ipairs(palabras) do
        if texto:find(palabra:lower(), 1, true) then return true end
    end
    return false
end

local function extraerNumero(texto, porDefecto)
    local num = texto:match("(%d+)")
    return tonumber(num) or porDefecto
end

local function extraerColor(texto)
    return Modulos.Database:obtenerColor(normalizarTexto(texto))
end

local function extraerMaterial(texto)
    return Modulos.Database:obtenerMaterial(normalizarTexto(texto))
end

local function levenshtein(s1, s2)
    local len1, len2 = #s1, #s2
    if len1 == 0 then return len2 end
    if len2 == 0 then return len1 end
    local matrix = {}
    for i = 0, len1 do matrix[i] = {[0] = i} end
    for j = 0, len2 do matrix[0][j] = j end
    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (s1:sub(i,i) == s2:sub(j,j)) and 0 or 1
            matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
        end
    end
    return matrix[len1][len2]
end

local function buscarComandoSimilar(texto)
    local minDist = math.huge
    local mejorMatch = nil
    for nombre, _ in pairs(Modulos.Database.Comandos) do
        local dist = levenshtein(texto:lower(), nombre:lower())
        if dist < minDist and dist <= 2 then
            minDist = dist
            mejorMatch = nombre
        end
    end
    return mejorMatch, minDist
end

-- ============================================================
-- INTERPRETAR COMANDO (versión simplificada por espacio)
-- ============================================================

local function interpretarComando(texto)
    texto = normalizarTexto(texto)
    Modulos.Database:actualizarEstadistica("totalComandos")

    local palabras = {}
    for palabra in texto:gmatch("%S+") do
        table.insert(palabras, palabra)
    end
    local nombreCmd = palabras[1]

    if contiene(texto, {"ayuda", "help", "comandos"}) then
        local lista = Modulos.Database:listarComandos()
        if pluginsActivos > 0 then
            lista = lista .. "\n[PLUGINS: " .. pluginsActivos .. " activos]"
        end
        return { exito = true, codigo = nil, mensaje = lista }
    end

    if contiene(texto, {"limpiar", "borrar todo", "clear"}) then
        return {
            exito = true,
            codigo = "for _, obj in ipairs(workspace:GetDescendants()) do if obj:IsA('BasePart') and obj:GetAttribute('CreadoPorIA') then obj:Destroy() end end",
            mensaje = "🧹 Construcciones eliminadas"
        }
    end

    local cmdData = Modulos.Database.Comandos[nombreCmd]
    if not cmdData then
        local similar, dist = buscarComandoSimilar(nombreCmd)
        if similar then
            return { exito = false, codigo = nil, mensaje = "¿Quisiste decir '" .. similar .. "'?" }
        end
        return { exito = false, codigo = nil, mensaje = "Comando '" .. nombreCmd .. "' no encontrado. Escribe 'ayuda'" }
    end

    if cmdData.tipo == "construccion" then
        local construccion = Modulos.Database.Construcciones[nombreCmd]
        if not construccion then
            return { exito = false, codigo = nil, mensaje = "⚠️ Construcción no implementada" }
        end
        local parametros = {}
        for i = 2, #palabras do
            table.insert(parametros, palabras[i])
        end
        
        local codigo = construccion(parametros)
        return { exito = true, codigo = codigo, mensaje = "🏗️ " .. cmdData.descripcion }
    end

    return { exito=false, codigo=nil, mensaje="Comando reconocido pero no implementado" }
end

local function ejecutarCodigo(codigo)
    if not codigo or codigo=="" then return true,"Sin código" end
    local fn, errC = loadstring(codigo)
    if not fn then return false, "Sintaxis: "..tostring(errC) end
    table.insert(historialAcciones, { codigo=codigo, timestamp=os.time() })
    local ok, errE = pcall(fn)
    if ok then
        Modulos.Database:actualizarEstadistica("comandosExitosos")
        return true,"OK"
    else
        Modulos.Database:actualizarEstadistica("comandosFallidos")
        return false,"Error: "..tostring(errE)
    end
end

local function deshacer()
    local ultimoTimestamp = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("CreadoPorIA") then
            local timestamp = obj:GetAttribute("CreacionTimestamp")
            if timestamp and timestamp > ultimoTimestamp then
                ultimoTimestamp = timestamp
            end
        end
    end
    
    if ultimoTimestamp > 0 then
        local count = 0
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:GetAttribute("CreadoPorIA") then
                local timestamp = obj:GetAttribute("CreacionTimestamp")
                if timestamp == ultimoTimestamp then
                    obj:Destroy()
                    count = count + 1
                end
            end
        end
        return true, "↩️ Deshice " .. count .. " objetos"
    else
        return false, "Nada que deshacer"
    end
end

-- ============================================================
-- INICIALIZAR SISTEMA - SIN SPLASH
-- ============================================================

local function inicializar()
    if not Modulos.Database or not Modulos.UI then error("Módulos no cargados") end
    
    print("[IA Constructor] Creando interfaz DIRECTAMENTE...")
    
    -- ✅ CREAR VENTANA DIRECTAMENTE (sin splash)
    local ventana = Modulos.UI:crearVentana({
        titulo = "Rozek",
        subtitulo = "Asistente IA v3.2",
        ancho = 500,
        alto = 600
    })
    
    if not ventana then
        error("No se pudo crear la ventana")
    end
    
    local chatArea = ventana.ChatArea
    local inputComponents = ventana.InputBox
    local statusComponents = ventana.StatusBar
    
    print("[IA Constructor] ✅ Interfaz creada")
    
    -- Mensaje de bienvenida
    local msg = "¡Hola! 👋 Soy Rozek v3.2\n\nPrueba:\n• casa roja\n• torre 15 azul\n• castillo\n• ayuda"
    
    if pluginsActivos > 0 then
        msg = msg .. "\n\n[" .. pluginsActivos .. " plugins activos]"
    end
    
    Modulos.UI:crearMensaje(chatArea, {texto = msg, esUsuario = false})
    
    -- Función procesar mensaje
    local function procesarMensaje(texto)
        if estadoIA.pensando or texto == "" then return end
        
        estadoIA.pensando = true
        estadoIA.ultimoComando = texto
        
        Modulos.UI:crearMensaje(chatArea, {texto = texto, esUsuario = true})
        Modulos.UI:actualizarEstado(statusComponents, "pensando", "Procesando...")
        local pensandoIndicador = Modulos.UI:mostrarPensando(chatArea)
        
        inputComponents.InputBox.Text = ""
        
        task.wait(0.3)
        
        Modulos.UI:ocultarPensando(chatArea)
        
        local res = interpretarComando(texto)
        
        if res.codigo then
            local ok, msg = ejecutarCodigo(res.codigo)
            if ok then
                Modulos.UI:crearMensaje(chatArea, {texto = res.mensaje, esExito = true})
                Modulos.UI:actualizarEstado(statusComponents, "exito", "OK")
            else
                Modulos.UI:crearMensaje(chatArea, {texto = "❌ " .. msg, esError = true})
                Modulos.UI:actualizarEstado(statusComponents, "error", "Error")
            end
        else
            Modulos.UI:crearMensaje(chatArea, {texto = res.mensaje, esError = not res.exito})
            Modulos.UI:actualizarEstado(statusComponents, res.exito and "listo" or "error", res.exito and "Listo" or "Error")
        end
        
        estadoIA.pensando = false
    end
    
    -- Conectar eventos
    inputComponents.SendBtn.MouseButton1Click:Connect(function()
        procesarMensaje(inputComponents.InputBox.Text)
    end)
    
    inputComponents.InputBox.FocusLost:Connect(function(enter)
        if enter then procesarMensaje(inputComponents.InputBox.Text) end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Z and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local ok, msg = deshacer()
            Modulos.UI:mostrarNotificacion({texto = msg, tipo = ok and "exito" or "error", duracion = 2})
        end
    end)
    
    -- Notificación final
    task.wait(0.2)
    local msg = "✅ Rozek v3.2 listo!"
    if pluginsActivos > 0 then msg = msg .. " (" .. pluginsActivos .. " plugins)" end
    Modulos.UI:mostrarNotificacion({texto = msg, tipo = "exito", duracion = 3})
    
    print("[IA Constructor] ✅ Sistema completamente inicializado")
end

-- ============================================================
-- EJECUTAR
-- ============================================================

local ok, err = pcall(inicializar)
if not ok then
    warn("[IA Constructor] ❌ Error crítico: " .. tostring(err))
    pcall(function()
        local sg = Instance.new("ScreenGui") sg.Parent = game:GetService("CoreGui")
        local f = Instance.new("Frame") f.Size = UDim2.new(0, 400, 0, 120) f.Position = UDim2.new(0.5, -200, 0.5, -60)
        f.BackgroundColor3 = Color3.fromRGB(200, 40, 40) f.Parent = sg
        local t = Instance.new("TextLabel") t.Size = UDim2.new(1, -20, 1, -20) t.Position = UDim2.new(0, 10, 0, 10)
        t.BackgroundTransparency = 1 t.Text = "ERROR: " .. tostring(err)
        t.TextColor3 = Color3.fromRGB(255, 255, 255) t.TextSize = 13 t.Font = Enum.Font.GothamBold
        t.TextWrapped = true t.Parent = f
    end)
end
