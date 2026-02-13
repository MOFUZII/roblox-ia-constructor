-- ============================================================
-- UI_LIBRARY.LUA v2.0 - Librería de Interfaz MEJORADA
-- Módulo 3: Sistema completo de GUI con diseño moderno
-- ============================================================
-- MEJORAS v2.0:
-- • Degradados suaves en fondos y bordes
-- • Efectos de resplandor (glow) en elementos activos
-- • Animaciones más fluidas y profesionales
-- • Sombras y profundidad mejorada
-- • Colores más vibrantes y modernos
-- • Transiciones suaves entre estados
-- ============================================================

local UI = {}

-- Servicios
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ============================================================
-- CONFIGURACIÓN DE COLORES Y ESTILOS v2.0
-- ============================================================

UI.Colores = {
    -- Colores principales (más vibrantes)
    primario = Color3.fromRGB(0, 230, 140),        -- Verde brillante
    primarioOscuro = Color3.fromRGB(0, 180, 110),  -- Para degradados
    secundario = Color3.fromRGB(70, 150, 255),     -- Azul vibrante
    secundarioOscuro = Color3.fromRGB(40, 120, 220),
    
    -- Fondos con más contraste
    fondo = Color3.fromRGB(18, 20, 30),            -- Azul oscuro profundo
    fondoOscuro = Color3.fromRGB(12, 14, 22),      -- Casi negro azulado
    fondoClaro = Color3.fromRGB(25, 28, 40),       -- Para overlays
    
    -- Texto
    texto = Color3.fromRGB(245, 250, 255),         -- Blanco azulado
    textoSecundario = Color3.fromRGB(160, 170, 190),
    textoTerciario = Color3.fromRGB(120, 130, 150),
    
    -- Estados (más saturados)
    exito = Color3.fromRGB(40, 255, 150),          -- Verde brillante
    error = Color3.fromRGB(255, 70, 90),           -- Rojo vibrante
    advertencia = Color3.fromRGB(255, 200, 50),    -- Amarillo dorado
    info = Color3.fromRGB(100, 170, 255),          -- Azul info
    
    -- Chat
    mensajeUsuario = Color3.fromRGB(70, 150, 255), -- Azul vibrante
    mensajeIA = Color3.fromRGB(35, 40, 55),        -- Gris azulado
    mensajeExito = Color3.fromRGB(30, 220, 130),   -- Verde
    mensajeError = Color3.fromRGB(230, 60, 80),    -- Rojo
    
    -- Efectos especiales
    resplandor = Color3.fromRGB(0, 230, 140),      -- Para glow effects
    sombra = Color3.fromRGB(0, 0, 0),              -- Sombras
}

UI.Estilos = {
    fuentePrincipal = Enum.Font.Gotham,
    fuenteTitulo = Enum.Font.GothamBold,
    tamañoTexto = 14,
    tamañoTitulo = 20,
    redondeo = 14,          -- Más redondeado
    padding = 12,
    
    -- Efectos
    sombra = 4,             -- Intensidad de sombra
    resplandor = 6,         // Tamaño del glow
    duracionAnimacion = 0.3,
}

-- ============================================================
-- FUNCIÓN PRINCIPAL: CREAR VENTANA
-- ============================================================

function UI:crearVentana(config)
    config = config or {}
    
    -- Configuración por defecto
    local cfg = {
        titulo = config.titulo or "🤖 IA Constructor",
        subtitulo = config.subtitulo or "Sistema Inteligente v2.1",
        ancho = config.ancho or 480,
        alto = config.alto or 640,
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
    
    -- Esquinas redondeadas (más pronunciadas)
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    MainCorner.Parent = Main
    
    -- Borde con resplandor
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = self.Colores.primario
    MainStroke.Thickness = 2.5
    MainStroke.Transparency = 0
    MainStroke.Parent = Main
    
    -- Efecto de sombra (usando ImageLabel)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = self.Colores.sombra
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    Shadow.ZIndex = Main.ZIndex - 1
    Shadow.Parent = Main
    
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
    
    -- Animación de entrada más dramática
    Main.Rotation = -5
    TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, cfg.ancho, 0, cfg.alto),
        Position = UDim2.new(0.5, -cfg.ancho/2, 0.5, -cfg.alto/2),
        Rotation = 0
    }):Play()
    
    -- Efecto de resplandor pulsante en el borde
    self:_aplicarResplandorPulsante(MainStroke)
    
    return componentes
end

-- ============================================================
-- COMPONENTES INTERNOS MEJORADOS
-- ============================================================

function UI:_crearHeader(parent, config)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = self.Colores.primario
    Header.BorderSizePixel = 0
    Header.Parent = parent
    
    -- Degradado en el header
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.Colores.primario),
        ColorSequenceKeypoint.new(1, self.Colores.primarioOscuro)
    }
    Gradient.Rotation = 45
    Gradient.Parent = Header
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    HeaderCorner.Parent = Header
    
    -- Fix para esquinas inferiores
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 20)
    HeaderFix.Position = UDim2.new(0, 0, 1, -20)
    HeaderFix.BackgroundColor3 = self.Colores.primario
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    -- Degradado también en el fix
    local FixGradient = Gradient:Clone()
    FixGradient.Parent = HeaderFix
    
    -- Icono mejorado con resplandor
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 45, 0, 45)
    IconContainer.Position = UDim2.new(0, 12, 0.5, -22.5)
    IconContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IconContainer.BackgroundTransparency = 0.85
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Header
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = IconContainer
    
    -- Efecto de resplandor en el icono
    local IconGlow = Instance.new("UIStroke")
    IconGlow.Color = Color3.fromRGB(255, 255, 255)
    IconGlow.Thickness = 3
    IconGlow.Transparency = 0.7
    IconGlow.Parent = IconContainer
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = "🤖"
    Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    Icon.TextSize = 24
    Icon.Font = self.Estilos.fuenteTitulo
    Icon.Parent = IconContainer
    
    -- Título con sombra de texto
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -200, 0, 26)
    Title.Position = UDim2.new(0, 68, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = config.titulo
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = self.Estilos.tamañoTitulo
    Title.Font = self.Estilos.fuenteTitulo
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextStrokeTransparency = 0.8
    Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Title.Parent = Header
    
    -- Subtítulo mejorado
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -200, 0, 16)
    Subtitle.Position = UDim2.new(0, 68, 0, 38)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = config.subtitulo
    Subtitle.TextColor3 = Color3.fromRGB(230, 255, 240)
    Subtitle.TextSize = 12
    Subtitle.Font = self.Estilos.fuentePrincipal
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextTransparency = 0.25
    Subtitle.Parent = Header
    
    -- Botones mejorados
    if config.minimizable then
        local MinBtn = self:crearBotonModerno({
            parent = Header,
            texto = "−",
            posicion = UDim2.new(1, -72, 0.5, -16),
            tamaño = UDim2.new(0, 32, 0, 32),
            color = self.Colores.advertencia,
            callback = function()
                self:_toggleMinimizar(parent)
            end
        })
    end
    
    local CloseBtn = self:crearBotonModerno({
        parent = Header,
        texto = "✕",
        posicion = UDim2.new(1, -36, 0.5, -16),
        tamaño = UDim2.new(0, 32, 0, 32),
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
    ChatArea.Size = UDim2.new(1, -24, 0, 460)
    ChatArea.Position = UDim2.new(0, 12, 0, 72)
    ChatArea.BackgroundColor3 = self.Colores.fondoOscuro
    ChatArea.BorderSizePixel = 0
    ChatArea.ScrollBarThickness = 8
    ChatArea.ScrollBarImageColor3 = self.Colores.primario
    ChatArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChatArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChatArea.Parent = parent
    
    local ChatCorner = Instance.new("UICorner")
    ChatCorner.CornerRadius = UDim.new(0, 12)
    ChatCorner.Parent = ChatArea
    
    -- Borde sutil
    local ChatStroke = Instance.new("UIStroke")
    ChatStroke.Color = self.Colores.primario
    ChatStroke.Thickness = 1
    ChatStroke.Transparency = 0.8
    ChatStroke.Parent = ChatArea
    
    local ChatLayout = Instance.new("UIListLayout")
    ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChatLayout.Padding = UDim.new(0, 10)
    ChatLayout.Parent = ChatArea
    
    local ChatPadding = Instance.new("UIPadding")
    ChatPadding.PaddingTop = UDim.new(0, 12)
    ChatPadding.PaddingBottom = UDim.new(0, 12)
    ChatPadding.PaddingLeft = UDim.new(0, 12)
    ChatPadding.PaddingRight = UDim.new(0, 12)
    ChatPadding.Parent = ChatArea
    
    return ChatArea
end

function UI:_crearStatusBar(parent)
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(1, -24, 0, 32)
    StatusBar.Position = UDim2.new(0, 12, 0, 540)
    StatusBar.BackgroundColor3 = self.Colores.fondoClaro
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = parent
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 10)
    StatusCorner.Parent = StatusBar
    
    -- Borde sutil
    local StatusStroke = Instance.new("UIStroke")
    StatusStroke.Color = self.Colores.primario
    StatusStroke.Thickness = 1
    StatusStroke.Transparency = 0.85
    StatusStroke.Parent = StatusBar
    
    -- Indicador de estado con resplandor
    local StatusDotContainer = Instance.new("Frame")
    StatusDotContainer.Name = "StatusDotContainer"
    StatusDotContainer.Size = UDim2.new(0, 12, 0, 12)
    StatusDotContainer.Position = UDim2.new(0, 12, 0.5, -6)
    StatusDotContainer.BackgroundColor3 = self.Colores.exito
    StatusDotContainer.BorderSizePixel = 0
    StatusDotContainer.Parent = StatusBar
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDotContainer
    
    -- Efecto de resplandor pulsante
    local DotGlow = Instance.new("UIStroke")
    DotGlow.Name = "Glow"
    DotGlow.Color = self.Colores.exito
    DotGlow.Thickness = 3
    DotGlow.Transparency = 0.5
    DotGlow.Parent = StatusDotContainer
    
    -- Texto de estado
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -40, 1, 0)
    StatusText.Position = UDim2.new(0, 32, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "🟢 Sistema listo"
    StatusText.TextColor3 = self.Colores.texto
    StatusText.TextSize = 13
    StatusText.Font = self.Estilos.fuentePrincipal
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar
    
    return {StatusBar = StatusBar, StatusDot = StatusDotContainer, StatusText = StatusText}
end

function UI:_crearInput(parent)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "InputFrame"
    InputFrame.Size = UDim2.new(1, -24, 0, 56)
    InputFrame.Position = UDim2.new(0, 12, 0, 580)
    InputFrame.BackgroundColor3 = self.Colores.fondoClaro
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = parent
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 12)
    InputCorner.Parent = InputFrame
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Name = "InputStroke"
    InputStroke.Color = self.Colores.primario
    InputStroke.Thickness = 2
    InputStroke.Transparency = 0.5
    InputStroke.Parent = InputFrame
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, -75, 1, 0)
    InputBox.Position = UDim2.new(0, 14, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.TextColor3 = self.Colores.texto
    InputBox.PlaceholderText = "💬 Escribe tu comando aquí..."
    InputBox.PlaceholderColor3 = self.Colores.textoTerciario
    InputBox.Text = ""
    InputBox.TextSize = self.Estilos.tamañoTexto
    InputBox.Font = self.Estilos.fuentePrincipal
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = InputFrame
    
    -- Efecto de focus en el input
    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Transparency = 0,
            Thickness = 2.5
        }):Play()
    end)
    
    InputBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Transparency = 0.5,
            Thickness = 2
        }):Play()
    end)
    
    local SendBtn = self:crearBotonModerno({
        parent = InputFrame,
        texto = "➤",
        posicion = UDim2.new(1, -60, 0.5, -22),
        tamaño = UDim2.new(0, 54, 0, 44),
        color = self.Colores.primario,
        textoTamaño = 20
    })
    
    return {InputFrame = InputFrame, InputBox = InputBox, SendBtn = SendBtn}
end

-- ============================================================
-- FUNCIÓN: CREAR MENSAJE EN CHAT (MEJORADO)
-- ============================================================

function UI:crearMensaje(chatArea, config)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "",
        esUsuario = config.esUsuario or false,
        esError = config.esError or false,
        esExito = config.esExito or false,
    }
    
    local msgCount = #chatArea:GetChildren() - 2
    
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
        backgroundColor = self.Colores.mensajeExito
    else
        backgroundColor = self.Colores.mensajeIA
    end
    
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(0.88, 0, 0, 0)
    MsgLabel.AutomaticSize = Enum.AutomaticSize.Y
    MsgLabel.Position = cfg.esUsuario and UDim2.new(0.12, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
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
    MsgCorner.CornerRadius = UDim.new(0, 12)
    MsgCorner.Parent = MsgLabel
    
    -- Degradado sutil en mensajes del usuario
    if cfg.esUsuario then
        local MsgGradient = Instance.new("UIGradient")
        MsgGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, backgroundColor),
            ColorSequenceKeypoint.new(1, self:_ajustarBrillo(backgroundColor, 0.85))
        }
        MsgGradient.Rotation = 135
        MsgGradient.Parent = MsgLabel
    end
    
    local MsgPadding = Instance.new("UIPadding")
    MsgPadding.PaddingTop = UDim.new(0, 12)
    MsgPadding.PaddingBottom = UDim.new(0, 12)
    MsgPadding.PaddingLeft = UDim.new(0, 14)
    MsgPadding.PaddingRight = UDim.new(0, 14)
    MsgPadding.Parent = MsgLabel
    
    -- Animación de entrada más suave
    MsgLabel.Position = cfg.esUsuario and UDim2.new(0.12, 20, 0, 0) or UDim2.new(0, -20, 0, 0)
    
    TweenService:Create(MsgLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        TextTransparency = 0,
        Position = cfg.esUsuario and UDim2.new(0.12, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- Scroll automático suave
    task.wait(0.05)
    local targetPos = chatArea.AbsoluteCanvasSize.Y
    TweenService:Create(chatArea, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        CanvasPosition = Vector2.new(0, targetPos)
    }):Play()
    
    return MsgLabel
end

-- ============================================================
-- FUNCIÓN: CREAR BOTÓN MODERNO (NUEVA)
-- ============================================================

function UI:crearBotonModerno(config)
    config = config or {}
    
    local Boton = Instance.new("TextButton")
    Boton.Size = config.tamaño or UDim2.new(0, 100, 0, 40)
    Boton.Position = config.posicion or UDim2.new(0, 0, 0, 0)
    Boton.BackgroundColor3 = config.color or self.Colores.primario
    Boton.Text = config.texto or "Botón"
    Boton.TextColor3 = config.textoColor or Color3.fromRGB(255, 255, 255)
    Boton.TextSize = config.textoTamaño or 16
    Boton.Font = self.Estilos.fuenteTitulo
    Boton.BorderSizePixel = 0
    Boton.AutoButtonColor = false
    Boton.Parent = config.parent
    
    local BotonCorner = Instance.new("UICorner")
    BotonCorner.CornerRadius = UDim.new(config.redondeo or 0.25, 0)
    BotonCorner.Parent = Boton
    
    -- Degradado
    local BtnGradient = Instance.new("UIGradient")
    BtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, config.color or self.Colores.primario),
        ColorSequenceKeypoint.new(1, self:_ajustarBrillo(config.color or self.Colores.primario, 0.85))
    }
    BtnGradient.Rotation = 90
    BtnGradient.Parent = Boton
    
    -- Efecto de resplandor
    local BtnGlow = Instance.new("UIStroke")
    BtnGlow.Color = config.color or self.Colores.primario
    BtnGlow.Thickness = 0
    BtnGlow.Transparency = 0.5
    BtnGlow.Parent = Boton
    
    -- Efectos hover mejorados
    Boton.MouseEnter:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.2), {
            Size = config.tamaño + UDim2.new(0, 4, 0, 4) or UDim2.new(0, 104, 0, 44)
        }):Play()
        
        TweenService:Create(BtnGlow, TweenInfo.new(0.2), {
            Thickness = 4
        }):Play()
    end)
    
    Boton.MouseLeave:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.2), {
            Size = config.tamaño or UDim2.new(0, 100, 0, 40)
        }):Play()
        
        TweenService:Create(BtnGlow, TweenInfo.new(0.2), {
            Thickness = 0
        }):Play()
    end)
    
    -- Click con animación
    Boton.MouseButton1Down:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.1), {
            Size = config.tamaño - UDim2.new(0, 2, 0, 2) or UDim2.new(0, 98, 0, 38)
        }):Play()
    end)
    
    Boton.MouseButton1Up:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.1), {
            Size = config.tamaño or UDim2.new(0, 100, 0, 40)
        }):Play()
    end)
    
    -- Click callback
    if config.callback then
        Boton.MouseButton1Click:Connect(config.callback)
    end
    
    return Boton
end

-- ============================================================
-- FUNCIÓN: NOTIFICACIÓN MEJORADA
-- ============================================================

function UI:mostrarNotificacion(config)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "Notificación",
        tipo = config.tipo or "info",
        duracion = config.duracion or 3,
    }
    
    -- Color según tipo
    local color
    local icono
    if cfg.tipo == "exito" then 
        color = self.Colores.exito
        icono = "✅"
    elseif cfg.tipo == "error" then 
        color = self.Colores.error
        icono = "❌"
    elseif cfg.tipo == "advertencia" then 
        color = self.Colores.advertencia
        icono = "⚠️"
    else 
        color = self.Colores.info
        icono = "ℹ️"
    end
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 0, 0, 0)
    Notif.Position = UDim2.new(1, -20, 0, 20)
    Notif.BackgroundColor3 = self.Colores.fondo
    Notif.BorderSizePixel = 0
    Notif.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = Notif
    
    -- Borde de color
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = color
    NotifStroke.Thickness = 2.5
    NotifStroke.Parent = Notif
    
    -- Barra lateral de color
    local ColorBar = Instance.new("Frame")
    ColorBar.Size = UDim2.new(0, 4, 1, 0)
    ColorBar.BackgroundColor3 = color
    ColorBar.BorderSizePixel = 0
    ColorBar.Parent = Notif
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 12)
    BarCorner.Parent = ColorBar
    
    -- Icono
    local NotifIcon = Instance.new("TextLabel")
    NotifIcon.Size = UDim2.new(0, 30, 0, 30)
    NotifIcon.Position = UDim2.new(0, 12, 0.5, -15)
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Text = icono
    NotifIcon.TextSize = 20
    NotifIcon.Font = self.Estilos.fuenteTitulo
    NotifIcon.Parent = Notif
    
    -- Texto
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -55, 1, -10)
    NotifText.Position = UDim2.new(0, 48, 0, 5)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = cfg.texto
    NotifText.TextColor3 = self.Colores.texto
    NotifText.TextSize = 14
    NotifText.Font = self.Estilos.fuentePrincipal
    NotifText.TextWrapped = true
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Center
    NotifText.Parent = Notif
    
    -- Animación entrada
    TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 70),
        Position = UDim2.new(1, -340, 0, 20)
    }):Play()
    
    -- Auto-destruir con animación
    task.delay(cfg.duracion, function()
        TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20),
            Size = UDim2.new(0, 0, 0, 70)
        }):Play()
        
        task.wait(0.35)
        Notif:Destroy()
    end)
end

-- ============================================================
-- FUNCIÓN: ACTUALIZAR ESTADO (MEJORADO)
-- ============================================================

function UI:actualizarEstado(statusComponents, estado, mensaje)
    local colores = {
        listo = self.Colores.exito,
        pensando = self.Colores.advertencia,
        error = self.Colores.error,
        exito = self.Colores.exito,
    }
    
    local iconos = {
        listo = "🟢",
        pensando = "🟡",
        error = "🔴",
        exito = "🟢"
    }
    
    local color = colores[estado] or self.Colores.info
    local icono = iconos[estado] or "⚪"
    
    -- Actualizar color con transición
    TweenService:Create(statusComponents.StatusDot, TweenInfo.new(0.3), {
        BackgroundColor3 = color
    }):Play()
    
    local glow = statusComponents.StatusDot:FindFirstChild("Glow")
    if glow then
        TweenService:Create(glow, TweenInfo.new(0.3), {
            Color = color
        }):Play()
    end
    
    statusComponents.StatusText.Text = icono .. " " .. (mensaje or estado)
    
    -- Animación de pulso mejorada si está pensando
    if estado == "pensando" then
        if glow then
            local pulso = TweenService:Create(
                glow,
                TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Thickness = 6, Transparency = 0.2}
            )
            pulso:Play()
            statusComponents.StatusDot:SetAttribute("Pulso", pulso)
        end
    else
        local pulso = statusComponents.StatusDot:GetAttribute("Pulso")
        if pulso then
            pulso:Cancel()
            if glow then
                TweenService:Create(glow, TweenInfo.new(0.3), {
                    Thickness = 3,
                    Transparency = 0.5
                }):Play()
            end
        end
    end
end

-- ============================================================
-- FUNCIONES AUXILIARES NUEVAS
-- ============================================================

function UI:_aplicarResplandorPulsante(stroke)
    spawn(function()
        while stroke and stroke.Parent do
            TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.3
            }):Play()
            task.wait(1.5)
            TweenService:Create(stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0
            }):Play()
            task.wait(1.5)
        end
    end)
end

function UI:_toggleMinimizar(ventana)
    local estaMinimizado = ventana:GetAttribute("Minimizado") or false
    
    local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if estaMinimizado then
        TweenService:Create(ventana, ti, {
            Size = UDim2.new(0, ventana:GetAttribute("AnchoOriginal"), 0, ventana:GetAttribute("AltoOriginal"))
        }):Play()
        ventana:SetAttribute("Minimizado", false)
    else
        ventana:SetAttribute("AnchoOriginal", ventana.Size.X.Offset)
        ventana:SetAttribute("AltoOriginal", ventana.Size.Y.Offset)
        
        TweenService:Create(ventana, ti, {
            Size = UDim2.new(0, ventana.Size.X.Offset, 0, 60)
        }):Play()
        ventana:SetAttribute("Minimizado", true)
    end
end

function UI:cerrarVentana(screenGui)
    local main = screenGui:FindFirstChild("Main")
    if main then
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = 5
        }):Play()
        
        task.wait(0.35)
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
