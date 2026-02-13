-- ============================================================
-- CORE_IA.LUA - Cerebro Principal v2.1
-- Sistema Principal - Carga módulos y maneja comandos
-- ============================================================

print("[IA Constructor] Iniciando sistema v2.1...")

local URLS = {
    Database   = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/Database_Mejorado.lua",
    UI_Library = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/UI_Library.lua",
    Plugins = {
        AnimationMaster = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/AnimationMaster_Plugin.lua",
        HybridLearning = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/plugins/HybridLearning_Plugin.lua",
        PersonalityAI = "https://raw.githubusercontent.com/MOFUZII/roblox-ia-constructor/main/plugins/PersonalityAI_Plugin.lua",
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

-- Cargar Database
Modulos.Database = cargarModulo("Database", URLS.Database)
if not Modulos.Database then error("[IA Constructor] No se pudo cargar Database.") end

-- Cargar UI
Modulos.UI = cargarModulo("UI_Library", URLS.UI_Library)
if not Modulos.UI then error("[IA Constructor] No se pudo cargar UI_Library.") end

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
                warn("[IA Constructor] Estructura: info=" .. tostring(plugin.info) .. ", comandos=" .. tostring(plugin.comandos))
                pluginsFallidos = pluginsFallidos + 1
            end
        else
            warn("[IA Constructor] ❌ Error al cargar plugin '" .. nombre .. "'")
            warn("[IA Constructor] Razón: " .. tostring(plugin))
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
local conocimientoUsuario = { scriptsAprendidos = {}, comandosPersonalizados = {} }

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
-- INTERPRETAR COMANDO
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
            lista = lista .. "\n[PLUGINS: " .. pluginsActivos .. " activos]\nUsa 'plugin listar' para ver detalles"
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

    if nombreCmd == "plugin" then
        if palabras[2] == "listar" or palabras[2] == "list" then
            local msg = "📦 PLUGINS INSTALADOS:\n"
            if Modulos.Database.Plugins and Modulos.Database.Plugins.instalados then
                for nombre, plugin in pairs(Modulos.Database.Plugins.instalados) do
                    msg = msg .. "✅ " .. nombre .. " v" .. plugin.info.version .. "\n"
                end
            else
                msg = msg .. "No hay plugins instalados"
            end
            return { exito = true, codigo = nil, mensaje = msg }
        end
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
            return { exito = false, codigo = nil, mensaje = "⚠️ Construcción '" .. nombreCmd .. "' no implementada aún" }
        end
        local parametros = {}
        for i = 2, #palabras do
            table.insert(parametros, palabras[i])
        end
        
        local mensajeRespuesta = "🏗️ Construyendo: " .. cmdData.descripcion
        if Modulos.Database.Plugins and Modulos.Database.Plugins.instalados then
            local personalityPlugin = Modulos.Database.Plugins.instalados["PersonalityAI"]
            if personalityPlugin and personalityPlugin.generarRespuesta then
                local colorParam = nil
                for _, param in ipairs(parametros) do
                    local color = extraerColor(param)
                    if color then
                        colorParam = param
                        break
                    end
                end
                mensajeRespuesta = personalityPlugin.generarRespuesta("construccion", nombreCmd, {color = colorParam})
            end
        end
        
        local codigo = construccion(parametros)
        if Modulos.Database.ejecutarHookPlugin then
            Modulos.Database:ejecutarHookPlugin("onConstruccionCreada", nombreCmd)
        end
        return { exito = true, codigo = codigo, mensaje = mensajeRespuesta }
    end

    if cmdData.tipo == "objeto" then
        local tipo = nombreCmd
        local tamano = extraerNumero(texto, 5)
        local color = extraerColor(texto) or "BrickColor.new('Medium stone grey')"
        local material = extraerMaterial(texto) or "Enum.Material.Plastic"
        local codigo = ""
        if tipo == "parte" then
            codigo = "local p=Instance.new('Part') p.Size=Vector3.new("..tamano..","..tamano..","..tamano..") p.Position=Vector3.new(0,5,0) p.BrickColor="..color.." p.Material="..material.." p.Anchored=true p:SetAttribute('CreadoPorIA',true) p:SetAttribute('CreacionTimestamp',os.time()) p.Parent=workspace"
        elseif tipo == "esfera" then
            codigo = "local p=Instance.new('Part') p.Shape=Enum.PartType.Ball p.Size=Vector3.new("..tamano..","..tamano..","..tamano..") p.Position=Vector3.new(0,5,0) p.BrickColor="..color.." p.Material="..material.." p.Anchored=true p:SetAttribute('CreadoPorIA',true) p:SetAttribute('CreacionTimestamp',os.time()) p.Parent=workspace"
        elseif tipo == "cilindro" then
            codigo = "local p=Instance.new('Part') p.Shape=Enum.PartType.Cylinder p.Size=Vector3.new("..tamano..","..tamano..","..tamano..") p.Position=Vector3.new(0,5,0) p.BrickColor="..color.." p.Material="..material.." p.Anchored=true p:SetAttribute('CreadoPorIA',true) p:SetAttribute('CreacionTimestamp',os.time()) p.Parent=workspace"
        elseif tipo == "cono" then
            codigo = "local p=Instance.new('Part') p.Size=Vector3.new("..tamano..","..tamano..","..tamano..") p.Position=Vector3.new(0,5,0) p.BrickColor="..color.." p.Material="..material.." p.Anchored=true local m=Instance.new('SpecialMesh') m.MeshType=Enum.MeshType.FileMesh m.MeshId='rbxassetid://1033714' m.Scale=Vector3.new("..tamano..","..tamano..","..tamano..") m.Parent=p p:SetAttribute('CreadoPorIA',true) p:SetAttribute('CreacionTimestamp',os.time()) p.Parent=workspace"
        elseif tipo == "cubo" then
            codigo = "local p=Instance.new('Part') p.Size=Vector3.new("..tamano..","..tamano..","..tamano..") p.Position=Vector3.new(0,5,0) p.BrickColor="..color.." p.Material="..material.." p.Anchored=true p:SetAttribute('CreadoPorIA',true) p:SetAttribute('CreacionTimestamp',os.time()) p.Parent=workspace"
        end
        return { exito = true, codigo = codigo, mensaje = "✅ " .. nombreCmd .. " creado" }
    end

    if cmdData.tipo == "modificador" then
        if nombreCmd == "velocidad" then
            local vel = extraerNumero(texto, 50)
            return { exito=true, codigo="local c=game.Players.LocalPlayer.Character if c then local h=c:FindFirstChildOfClass('Humanoid') if h then h.WalkSpeed="..vel.." end end", mensaje="🏃 Velocidad: "..vel }
        elseif nombreCmd == "salto" then
            local s = extraerNumero(texto, 100)
            return { exito=true, codigo="local c=game.Players.LocalPlayer.Character if c then local h=c:FindFirstChildOfClass('Humanoid') if h then h.JumpPower="..s.." end end", mensaje="🦘 Salto: "..s }
        elseif nombreCmd == "volar" then
            return { exito = true, codigo = "local char=game.Players.LocalPlayer.Character if char then local hrp=char:WaitForChild('HumanoidRootPart') local bg=Instance.new('BodyGyro') bg.MaxTorque=Vector3.new(9e9,9e9,9e9) bg.Parent=hrp local bv=Instance.new('BodyVelocity') bv.MaxForce=Vector3.new(9e9,9e9,9e9) bv.Velocity=Vector3.new(0,0,0) bv.Parent=hrp game:GetService('RunService').Heartbeat:Connect(function() local cam=workspace.CurrentCamera if game:GetService('UserInputService'):IsKeyDown(Enum.KeyCode.Space) then bv.Velocity=cam.CFrame.LookVector*50 else bv.Velocity=Vector3.new(0,0,0) end bg.CFrame=cam.CFrame end) end", mensaje = "✈️ Vuelo activado" }
        end
    end

    if cmdData.tipo == "mundo" then
        if nombreCmd == "dia" or contiene(texto, {"noche","atardecer"}) then
            local hora = contiene(texto,"noche") and "0" or contiene(texto,"atardecer") and "18" or "12"
            return { exito=true, codigo="game:GetService('Lighting').ClockTime="..hora, mensaje="🌞 Hora cambiada" }
        elseif nombreCmd == "gravedad" then
            local g = extraerNumero(texto, 196)
            return { exito=true, codigo="workspace.Gravity="..g, mensaje="🌍 Gravedad: "..g }
        end
    end

    if cmdData.tipo == "efecto" and nombreCmd == "explosion" then
        local p = extraerNumero(texto, 30)
        return { exito=true, codigo="local e=Instance.new('Explosion') e.Position=Vector3.new(0,5,0) e.BlastPressure="..p.." e.Parent=workspace", mensaje="💥 Boom!" }
    end
    
    if cmdData.tipo == "animacion" then
        local plugin = nil
        if Modulos.Database.Plugins and Modulos.Database.Plugins.instalados then
            for nombrePlugin, pluginData in pairs(Modulos.Database.Plugins.instalados) do
                if pluginData.comandos and pluginData.comandos[nombreCmd] then
                    plugin = pluginData
                    break
                end
            end
        end
        
        if plugin then
            local codigo = nil
            if nombreCmd == "rotar" then
                local velocidad = contiene(texto, "rapido") and "rapido" or "normal"
                codigo = plugin.generarRotacion(velocidad, "y")
            elseif nombreCmd == "flotar" then
                codigo = plugin.generarFlotacion("normal", "normal")
            elseif nombreCmd == "pulsar" then
                codigo = plugin.generarPulsacion("normal")
            elseif nombreCmd == "orbitar" then
                codigo = plugin.generarOrbitacion("normal", "normal")
            elseif nombreCmd == "arcoiris" then
                codigo = plugin.generarArcoiris("normal")
            end
            if codigo then
                return { exito = true, codigo = codigo, mensaje = "✨ Animación: " .. cmdData.descripcion }
            end
        end
    end
    
    if cmdData.tipo == "sistema" then
        if nombreCmd == "stats" or nombreCmd == "globalstats" or nombreCmd == "trending" or nombreCmd == "sync" then
            for nombrePlugin, pluginData in pairs(Modulos.Database.Plugins.instalados) do
                if pluginData.comandos and pluginData.comandos[nombreCmd] and pluginData.comandos[nombreCmd].ejecutar then
                    local resultado = pluginData.comandos[nombreCmd].ejecutar()
                    return { exito = true, codigo = nil, mensaje = resultado }
                end
            end
        end
    end

    Modulos.Database:actualizarEstadistica("comandosFallidos")
    return { exito=false, codigo=nil, mensaje="⚠️ Comando reconocido pero no implementado aún" }
end

local function ejecutarCodigo(codigo)
    if not codigo or codigo=="" then return true,"Sin código" end
    local fn, errC = loadstring(codigo)
    if not fn then return false, "Sintaxis: "..tostring(errC) end
    table.insert(historialAcciones, { codigo=codigo, timestamp=os.time() })
    local ok, errE = pcall(fn)
    if ok then
        Modulos.Database:actualizarEstadistica("comandosExitosos")
        if Modulos.Database.ejecutarHookPlugin then
            Modulos.Database:ejecutarHookPlugin("onSuccess", estadoIA.ultimoComando)
        end
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

local function inicializarInterfaz()
    local ventana = Modulos.UI:crearVentana({
        titulo="IA Constructor v2.1", subtitulo="Sistema Mejorado", ancho=450, alto=600
    })
    local chatArea = ventana.ChatArea
    local inputComponents = ventana.InputBox
    local statusComponents = ventana.StatusBar

    task.wait(0.5)
    
    local msg = "¡Hola! Soy tu asistente v2.1\n\n"
    msg = msg .. "Prueba:\n- casa roja\n- castillo gris\n- cupula azul\n- ayuda\n"
    
    if Modulos.Database.Plugins and Modulos.Database.Plugins.instalados then
        local personalityPlugin = Modulos.Database.Plugins.instalados["PersonalityAI"]
        if personalityPlugin and personalityPlugin.obtenerBienvenida then
            msg = personalityPlugin.obtenerBienvenida()
        elseif pluginsActivos > 0 then
            msg = msg .. "\n[PLUGINS: " .. pluginsActivos .. "]\n- rotar\n- flotar\n- stats"
        end
    elseif pluginsActivos > 0 then
        msg = msg .. "\n[PLUGINS: " .. pluginsActivos .. "]\n- rotar\n- flotar\n- stats"
    end
    
    Modulos.UI:crearMensaje(chatArea, {texto=msg, esUsuario=false})

    local function procesarMensaje(texto)
        if estadoIA.pensando or texto=="" then return end
        estadoIA.pensando=true
        estadoIA.ultimoComando=texto
        Modulos.UI:crearMensaje(chatArea,{texto=texto,esUsuario=true})
        Modulos.UI:actualizarEstado(statusComponents,"pensando","Procesando...")
        inputComponents.InputBox.Text=""
        task.wait(0.3)
        local res = interpretarComando(texto)
        if res.codigo then
            local ok,msg = ejecutarCodigo(res.codigo)
            if ok then
                Modulos.UI:crearMensaje(chatArea,{texto=res.mensaje,esExito=true})
                Modulos.UI:actualizarEstado(statusComponents,"exito","OK")
            else
                Modulos.UI:crearMensaje(chatArea,{texto=msg,esError=true})
                Modulos.UI:actualizarEstado(statusComponents,"error","Error")
            end
        else
            Modulos.UI:crearMensaje(chatArea,{texto=res.mensaje,esError=not res.exito})
            Modulos.UI:actualizarEstado(statusComponents, res.exito and "listo" or "error", res.exito and "Listo" or "Error")
        end
        estadoIA.pensando=false
    end

    inputComponents.SendBtn.MouseButton1Click:Connect(function()
        procesarMensaje(inputComponents.InputBox.Text)
    end)
    inputComponents.InputBox.FocusLost:Connect(function(enter)
        if enter then procesarMensaje(inputComponents.InputBox.Text) end
    end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode==Enum.KeyCode.Z and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local ok,msg = deshacer()
            Modulos.UI:mostrarNotificacion({texto=msg,tipo=ok and "exito" or "error",duracion=2})
        end
    end)
end

local function inicializar()
    if not Modulos.Database or not Modulos.UI then error("Módulos no cargados") end
    inicializarInterfaz()
    local msg = "IA Constructor v2.1 listo!"
    if pluginsActivos > 0 then msg = msg .. " (" .. pluginsActivos .. " plugins)" end
    Modulos.UI:mostrarNotificacion({texto=msg,tipo="exito",duracion=3})
    print("[IA Constructor] ✅ Version: "..Modulos.Database.Config.version)
end

local ok, err = pcall(inicializar)
if not ok then
    warn("[IA Constructor] ❌ Error: "..tostring(err))
    pcall(function()
        local sg=Instance.new("ScreenGui") sg.Parent=game:GetService("CoreGui")
        local f=Instance.new("Frame") f.Size=UDim2.new(0,400,0,120) f.Position=UDim2.new(0.5,-200,0.5,-60)
        f.BackgroundColor3=Color3.fromRGB(200,40,40) f.Parent=sg
        local t=Instance.new("TextLabel") t.Size=UDim2.new(1,-20,1,-20) t.Position=UDim2.new(0,10,0,10)
        t.BackgroundTransparency=1 t.Text="ERROR: "..tostring(err)
        t.TextColor3=Color3.fromRGB(255,255,255) t.TextSize=13 t.Font=Enum.Font.GothamBold
        t.TextWrapped=true t.Parent=f
    end)
end
