-- ============================================================
-- UI_LIBRARY.LUA - Librería de Interfaz
-- Módulo 3: Sistema completo de GUI
-- ============================================================

local UI = {}

-- Servicios
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ============================================================
-- CONFIGURACIÓN DE COLORES Y ESTILOS
-- ============================================================

UI.Colores = {
    -- Colores principales
    primario = Color3.fromRGB(0, 200, 120),
    secundario = Color3.fromRGB(0, 150, 255),
    fondo = Color3.fromRGB(15, 15, 25),
    fondoOscuro = Color3.fromRGB(8, 10, 20),
    texto = Color3.fromRGB(240, 245, 255),
    textoSecundario = Color3.fromRGB(150, 160, 180),
    
    -- Estados
    exito = Color3.fromRGB(0, 255, 140),
    error = Color3.fromRGB(255, 60, 60),
    advertencia = Color3.fromRGB(255, 195, 0),
    info = Color3.fromRGB(100, 150, 255),
    
    -- Chat
    mensajeUsuario = Color3.fromRGB(0, 120, 215),
    mensajeIA = Color3.fromRGB(30, 30, 50),
    mensajeError = Color3.fromRGB(200, 40, 40),
}

UI.Estilos = {
    fuentePrincipal = Enum.Font.Gotham,
    fuenteTitulo = Enum.Font.GothamBold,
    tamañoTexto = 13,
    tamañoTitulo = 18,
    redondeo = 12,
    padding = 10,
}

-- ============================================================
-- FUNCIÓN PRINCIPAL: CREAR VENTANA
-- ============================================================

function UI:crearVentana(config)
    config = config or {}
    
    -- Configuración por defecto
    local cfg = {
        titulo = config.titulo or "🤖 IA Constructor",
        subtitulo = config.subtitulo or "Asistente de construcción",
        ancho = config.ancho or 450,
        alto = config.alto or 600,
        draggable = config.draggable ~= false,
        minimizable = config.minimizable ~= false,
    }
    
    -- Limpiar GUI anterior
    pcall(function()
        local vieja = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor")
        if vieja then vieja:Destroy() end
    end)
    
    -- Crear ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RobloxAIConstructor"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Frame principal
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, cfg.ancho, 0, 0)
    Main.Position = UDim2.new(0.5, -cfg.ancho/2, 0.5, 0)
    Main.BackgroundColor3 = self.Colores.fondo
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Parent = ScreenGui
    
    if cfg.draggable then
        Main.Draggable = true
    end
    
    -- Esquinas redondeadas
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    MainCorner.Parent = Main
    
    -- Borde
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = self.Colores.primario
    MainStroke.Thickness = 2
    MainStroke.Parent = Main
    
    -- Contenedor de componentes
    local componentes = {
        ScreenGui = ScreenGui,
        Main = Main,
        Header = nil,
        ChatArea = nil,
        InputBox = nil,
        StatusBar = nil,
    }
    
    -- Crear header
    componentes.Header = self:_crearHeader(Main, cfg)
    
    -- Crear área de chat
    componentes.ChatArea = self:_crearChatArea(Main)
    
    -- Crear barra de estado
    componentes.StatusBar = self:_crearStatusBar(Main)
    
    -- Crear input
    componentes.InputBox = self:_crearInput(Main)
    
    -- Animación de entrada
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, cfg.ancho, 0, cfg.alto),
        Position = UDim2.new(0.5, -cfg.ancho/2, 0.5, -cfg.alto/2)
    }):Play()
    
    return componentes
end

-- ============================================================
-- COMPONENTES INTERNOS
-- ============================================================

function UI:_crearHeader(parent, config)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = self.Colores.primario
    Header.BorderSizePixel = 0
    Header.Parent = parent
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    HeaderCorner.Parent = Header
    
    -- Fix para esquinas inferiores
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 16)
    HeaderFix.Position = UDim2.new(0, 0, 1, -16)
    HeaderFix.BackgroundColor3 = self.Colores.primario
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    -- Icono
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 10, 0.5, -20)
    Icon.BackgroundTransparency = 0.85
    Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Icon.Text = "🤖"
    Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    Icon.TextSize = 20
    Icon.Font = self.Estilos.fuenteTitulo
    Icon.BorderSizePixel = 0
    Icon.Parent = Header
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 10)
    IconCorner.Parent = Icon
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -180, 0, 22)
    Title.Position = UDim2.new(0, 60, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = config.titulo
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = self.Estilos.tamañoTitulo
    Title.Font = self.Estilos.fuenteTitulo
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtítulo
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -180, 0, 14)
    Subtitle.Position = UDim2.new(0, 60, 0, 32)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = config.subtitulo
    Subtitle.TextColor3 = Color3.fromRGB(200, 255, 220)
    Subtitle.TextSize = 11
    Subtitle.Font = self.Estilos.fuentePrincipal
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextTransparency = 0.3
    Subtitle.Parent = Header
    
    -- Botones
    if config.minimizable then
        local MinBtn = self:crearBoton({
            parent = Header,
            texto = "-",
            posicion = UDim2.new(1, -64, 0.5, -14),
            tamaño = UDim2.new(0, 28, 0, 28),
            color = self.Colores.advertencia,
            callback = function()
                self:_toggleMinimizar(parent)
            end
        })
    end
    
    local CloseBtn = self:crearBoton({
        parent = Header,
        texto = "X",
        posicion = UDim2.new(1, -32, 0.5, -14),
        tamaño = UDim2.new(0, 28, 0, 28),
        color = self.Colores.error,
        callback = function()
            self:cerrarVentana(parent.Parent)
        end
    })
    
    return Header
end

function UI:_crearChatArea(parent)
    local ChatArea = Instance.new("ScrollingFrame")
    ChatArea.Name = "ChatArea"
    ChatArea.Size = UDim2.new(1, -20, 0, 440)
    ChatArea.Position = UDim2.new(0, 10, 0, 60)
    ChatArea.BackgroundColor3 = self.Colores.fondoOscuro
    ChatArea.BorderSizePixel = 0
    ChatArea.ScrollBarThickness = 6
    ChatArea.ScrollBarImageColor3 = self.Colores.primario
    ChatArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChatArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChatArea.Parent = parent
    
    local ChatCorner = Instance.new("UICorner")
    ChatCorner.CornerRadius = UDim.new(0, 10)
    ChatCorner.Parent = ChatArea
    
    local ChatLayout = Instance.new("UIListLayout")
    ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChatLayout.Padding = UDim.new(0, 8)
    ChatLayout.Parent = ChatArea
    
    local ChatPadding = Instance.new("UIPadding")
    ChatPadding.PaddingTop = UDim.new(0, 10)
    ChatPadding.PaddingBottom = UDim.new(0, 10)
    ChatPadding.PaddingLeft = UDim.new(0, 10)
    ChatPadding.PaddingRight = UDim.new(0, 10)
    ChatPadding.Parent = ChatArea
    
    return ChatArea
end

function UI:_crearStatusBar(parent)
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(1, -20, 0, 28)
    StatusBar.Position = UDim2.new(0, 10, 0, 508)
    StatusBar.BackgroundColor3 = Color3.fromRGB(4, 12, 26)
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = parent
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusBar
    
    -- Indicador de estado
    local StatusDot = Instance.new("Frame")
    StatusDot.Name = "StatusDot"
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(0, 10, 0.5, -4)
    StatusDot.BackgroundColor3 = self.Colores.exito
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = StatusBar
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot
    
    -- Texto de estado
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -28, 1, 0)
    StatusText.Position = UDim2.new(0, 24, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Listo"
    StatusText.TextColor3 = Color3.fromRGB(130, 255, 195)
    StatusText.TextSize = 11
    StatusText.Font = self.Estilos.fuentePrincipal
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar
    
    return {StatusBar = StatusBar, StatusDot = StatusDot, StatusText = StatusText}
end

function UI:_crearInput(parent)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "InputFrame"
    InputFrame.Size = UDim2.new(1, -20, 0, 50)
    InputFrame.Position = UDim2.new(0, 10, 0, 544)
    InputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = parent
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 10)
    InputCorner.Parent = InputFrame
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = self.Colores.primario
    InputStroke.Thickness = 2
    InputStroke.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, -70, 1, 0)
    InputBox.Position = UDim2.new(0, 10, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.TextColor3 = self.Colores.texto
    InputBox.PlaceholderText = "Escribe tu comando aquí..."
    InputBox.PlaceholderColor3 = self.Colores.textoSecundario
    InputBox.Text = ""
    InputBox.TextSize = self.Estilos.tamañoTexto
    InputBox.Font = self.Estilos.fuentePrincipal
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = InputFrame
    
    local SendBtn = self:crearBoton({
        parent = InputFrame,
        texto = "➤",
        posicion = UDim2.new(1, -55, 0.5, -20),
        tamaño = UDim2.new(0, 50, 0, 40),
        color = self.Colores.primario,
        textoTamaño = 18
    })
    
    return {InputFrame = InputFrame, InputBox = InputBox, SendBtn = SendBtn}
end

-- ============================================================
-- FUNCIÓN: CREAR MENSAJE EN CHAT
-- ============================================================

function UI:crearMensaje(chatArea, config)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "",
        esUsuario = config.esUsuario or false,
        esError = config.esError or false,
        esExito = config.esExito or false,
    }
    
    local msgCount = #chatArea:GetChildren() - 1 -- -1 por el UIListLayout y UIPadding
    
    local MsgFrame = Instance.new("Frame")
    MsgFrame.Size = UDim2.new(1, 0, 0, 0)
    MsgFrame.AutomaticSize = Enum.AutomaticSize.Y
    MsgFrame.BackgroundTransparency = 1
    MsgFrame.LayoutOrder = msgCount
    MsgFrame.Parent = chatArea
    
    -- Color según tipo
    local backgroundColor
    if cfg.esUsuario then
        backgroundColor = self.Colores.mensajeUsuario
    elseif cfg.esError then
        backgroundColor = self.Colores.mensajeError
    elseif cfg.esExito then
        backgroundColor = self.Colores.exito
    else
        backgroundColor = self.Colores.mensajeIA
    end
    
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(0.85, 0, 0, 0)
    MsgLabel.AutomaticSize = Enum.AutomaticSize.Y
    MsgLabel.Position = cfg.esUsuario and UDim2.new(0.15, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    MsgLabel.BackgroundColor3 = backgroundColor
    MsgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MsgLabel.Text = cfg.texto
    MsgLabel.TextSize = self.Estilos.tamañoTexto
    MsgLabel.Font = self.Estilos.fuentePrincipal
    MsgLabel.TextWrapped = true
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.TextYAlignment = Enum.TextYAlignment.Top
    MsgLabel.BorderSizePixel = 0
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.TextTransparency = 1
    MsgLabel.Parent = MsgFrame
    
    local MsgCorner = Instance.new("UICorner")
    MsgCorner.CornerRadius = UDim.new(0, 10)
    MsgCorner.Parent = MsgLabel
    
    local MsgPadding = Instance.new("UIPadding")
    MsgPadding.PaddingTop = UDim.new(0, 10)
    MsgPadding.PaddingBottom = UDim.new(0, 10)
    MsgPadding.PaddingLeft = UDim.new(0, 12)
    MsgPadding.PaddingRight = UDim.new(0, 12)
    MsgPadding.Parent = MsgLabel
    
    -- Animación de entrada
    TweenService:Create(MsgLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        TextTransparency = 0
    }):Play()
    
    -- Scroll automático
    task.wait(0.05)
    chatArea.CanvasPosition = Vector2.new(0, chatArea.AbsoluteCanvasSize.Y)
    
    return MsgLabel
end

-- ============================================================
-- FUNCIÓN: CREAR BOTÓN
-- ============================================================

function UI:crearBoton(config)
    config = config or {}
    
    local Boton = Instance.new("TextButton")
    Boton.Size = config.tamaño or UDim2.new(0, 100, 0, 35)
    Boton.Position = config.posicion or UDim2.new(0, 0, 0, 0)
    Boton.BackgroundColor3 = config.color or self.Colores.primario
    Boton.Text = config.texto or "Botón"
    Boton.TextColor3 = config.textoColor or Color3.fromRGB(255, 255, 255)
    Boton.TextSize = config.textoTamaño or 14
    Boton.Font = self.Estilos.fuenteTitulo
    Boton.BorderSizePixel = 0
    Boton.AutoButtonColor = false
    Boton.Parent = config.parent
    
    local BotonCorner = Instance.new("UICorner")
    BotonCorner.CornerRadius = UDim.new(config.redondeo or 1, 0)
    BotonCorner.Parent = Boton
    
    -- Efectos hover
    Boton.MouseEnter:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.2), {
            BackgroundColor3 = self:_ajustarBrillo(Boton.BackgroundColor3, 1.2)
        }):Play()
    end)
    
    Boton.MouseLeave:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.2), {
            BackgroundColor3 = config.color or self.Colores.primario
        }):Play()
    end)
    
    -- Click
    if config.callback then
        Boton.MouseButton1Click:Connect(config.callback)
    end
    
    return Boton
end

-- ============================================================
-- FUNCIÓN: NOTIFICACIÓN
-- ============================================================

function UI:mostrarNotificacion(config)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "Notificación",
        tipo = config.tipo or "info", -- info, exito, error, advertencia
        duracion = config.duracion or 3,
    }
    
    -- Color según tipo
    local color
    if cfg.tipo == "exito" then color = self.Colores.exito
    elseif cfg.tipo == "error" then color = self.Colores.error
    elseif cfg.tipo == "advertencia" then color = self.Colores.advertencia
    else color = self.Colores.info end
    
    -- Crear notificación
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 300, 0, 0)
    Notif.Position = UDim2.new(1, -320, 0, 20)
    Notif.BackgroundColor3 = color
    Notif.BorderSizePixel = 0
    Notif.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notif
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, -20)
    NotifText.Position = UDim2.new(0, 10, 0, 10)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = cfg.texto
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 13
    NotifText.Font = self.Estilos.fuentePrincipal
    NotifText.TextWrapped = true
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.Parent = Notif
    
    -- Animación entrada
    TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 60)
    }):Play()
    
    -- Auto-destruir
    task.delay(cfg.duracion, function()
        TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(NotifText, TweenInfo.new(0.3), {
            TextTransparency = 1
        }):Play()
        
        task.wait(0.3)
        Notif:Destroy()
    end)
end

-- ============================================================
-- FUNCIÓN: ACTUALIZAR ESTADO
-- ============================================================

function UI:actualizarEstado(statusComponents, estado, mensaje)
    -- estados: listo, pensando, error, exito
    
    local colores = {
        listo = self.Colores.exito,
        pensando = self.Colores.advertencia,
        error = self.Colores.error,
        exito = self.Colores.exito,
    }
    
    local color = colores[estado] or self.Colores.info
    
    statusComponents.StatusDot.BackgroundColor3 = color
    statusComponents.StatusText.Text = mensaje or estado
    
    -- Animación de pulso si está pensando
    if estado == "pensando" then
        local pulso = TweenService:Create(
            statusComponents.StatusDot,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true),
            {Size = UDim2.new(0, 12, 0, 12)}
        )
        pulso:Play()
        
        -- Guardar para cancelar después
        statusComponents.StatusDot:SetAttribute("Pulso", pulso)
    else
        -- Cancelar pulso
        local pulso = statusComponents.StatusDot:GetAttribute("Pulso")
        if pulso then
            pulso:Cancel()
        end
        statusComponents.StatusDot.Size = UDim2.new(0, 8, 0, 8)
    end
end

-- ============================================================
-- FUNCIONES AUXILIARES
-- ============================================================

function UI:_toggleMinimizar(ventana)
    local estaMinimizado = ventana:GetAttribute("Minimizado") or false
    
    local ti = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if estaMinimizado then
        -- Expandir
        TweenService:Create(ventana, ti, {
            Size = UDim2.new(0, ventana:GetAttribute("AnchoOriginal"), 0, ventana:GetAttribute("AltoOriginal"))
        }):Play()
        ventana:SetAttribute("Minimizado", false)
    else
        -- Minimizar
        ventana:SetAttribute("AnchoOriginal", ventana.Size.X.Offset)
        ventana:SetAttribute("AltoOriginal", ventana.Size.Y.Offset)
        
        TweenService:Create(ventana, ti, {
            Size = UDim2.new(0, ventana.Size.X.Offset, 0, 50)
        }):Play()
        ventana:SetAttribute("Minimizado", true)
    end
end

function UI:cerrarVentana(screenGui)
    local main = screenGui:FindFirstChild("Main")
    if main then
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, main.Size.X.Offset, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.27)
    end
    
    screenGui:Destroy()
end

function UI:_ajustarBrillo(color, factor)
    local h, s, v = color:ToHSV()
    v = math.clamp(v * factor, 0, 1)
    return Color3.fromHSV(h, s, v)
end

-- ============================================================
-- RETORNAR MÓDULO
-- ============================================================

return UI
