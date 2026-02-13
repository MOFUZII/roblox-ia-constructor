-- ============================================================
-- UI_LIBRARY.LUA v3.0 - Estilo Claude
-- Diseno moderno, minimalista y profesional
-- ============================================================
-- Inspirado en la interfaz de Claude AI
-- - Colores sutiles y sofisticados
-- - Tipografia clara y legible
-- - Espaciado generoso
-- - Animaciones suaves y naturales
-- - Enfoque en el contenido
-- ============================================================

local UI = {}

-- Servicios
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ============================================================
-- PALETA DE COLORES ESTILO CLAUDE
-- ============================================================

UI.Colores = {
    -- Fondo principal (beige claro/crema)
    fondo = Color3.fromRGB(250, 247, 242),
    fondoChat = Color3.fromRGB(255, 255, 255),
    
    -- Mensajes
    mensajeIA = Color3.fromRGB(245, 242, 237),      -- Beige muy claro
    mensajeUsuario = Color3.fromRGB(232, 223, 255),  -- Lavanda suave
    
    -- Texto
    textoPrincipal = Color3.fromRGB(31, 31, 31),     -- Negro suave
    textoSecundario = Color3.fromRGB(102, 102, 102), -- Gris medio
    textoTerciario = Color3.fromRGB(153, 153, 153),  -- Gris claro
    
    -- Acentos
    acento = Color3.fromRGB(170, 130, 255),          -- Morado Claude
    acentoHover = Color3.fromRGB(150, 110, 235),
    
    -- Bordes y divisores
    borde = Color3.fromRGB(229, 231, 235),
    bordeOscuro = Color3.fromRGB(209, 213, 219),
    
    -- Estados
    exito = Color3.fromRGB(34, 197, 94),
    error = Color3.fromRGB(239, 68, 68),
    advertencia = Color3.fromRGB(245, 158, 11),
}

UI.Estilos = {
    -- Tipografia (estilo Claude)
    fuentePrincipal = Enum.Font.Gotham,
    fuenteTitulo = Enum.Font.GothamBold,
    tamanoTexto = 15,
    tamanoTitulo = 18,
    
    -- Espaciado generoso
    paddingGrande = 24,
    paddingMedio = 16,
    paddingPequeno = 12,
    
    -- Bordes sutiles
    redondeo = 12,
    
    -- Animaciones suaves
    duracionRapida = 0.15,
    duracionNormal = 0.25,
    duracionLenta = 0.35,
}

-- ============================================================
-- FUNCION PRINCIPAL: CREAR VENTANA
-- ============================================================

function UI:crearVentana(config)
    config = config or {}
    
    local cfg = {
        titulo = config.titulo or "IA Constructor",
        subtitulo = config.subtitulo or "Sistema Inteligente v2.1",
        ancho = config.ancho or 720,
        alto = config.alto or 840,
        draggable = config.draggable ~= false,
    }
    
    -- Limpiar GUI anterior
    pcall(function()
        local vieja = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor")
        if vieja then vieja:Destroy() end
    end)
    
    -- ScreenGui principal
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
    
    -- Sombra sutil (borde muy suave)
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = self.Colores.bordeOscuro
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.3
    MainStroke.Parent = Main
    
    local componentes = {
        ScreenGui = ScreenGui,
        Main = Main,
        Header = nil,
        ChatArea = nil,
        InputBox = nil,
        StatusBar = nil,
    }
    
    -- Crear componentes
    componentes.Header = self:_crearHeader(Main, cfg)
    componentes.ChatArea = self:_crearChatArea(Main)
    componentes.StatusBar = self:_crearStatusBar(Main)
    componentes.InputBox = self:_crearInput(Main)
    
    -- Animacion de entrada suave
    Main.BackgroundTransparency = 1
    TweenService:Create(Main, TweenInfo.new(self.Estilos.duracionLenta, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, cfg.ancho, 0, cfg.alto),
        Position = UDim2.new(0.5, -cfg.ancho/2, 0.5, -cfg.alto/2),
        BackgroundTransparency = 0
    }):Play()
    
    return componentes
end

-- ============================================================
-- COMPONENTES INTERNOS
-- ============================================================

function UI:_crearHeader(parent, config)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 72)
    Header.BackgroundColor3 = self.Colores.fondo
    Header.BorderSizePixel = 0
    Header.Parent = parent
    
    -- Linea divisora inferior
    local Divisor = Instance.new("Frame")
    Divisor.Size = UDim2.new(1, -48, 0, 1)
    Divisor.Position = UDim2.new(0, 24, 1, -1)
    Divisor.BackgroundColor3 = self.Colores.borde
    Divisor.BorderSizePixel = 0
    Divisor.Parent = Header
    
    -- Icono minimalista
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 40, 0, 40)
    IconContainer.Position = UDim2.new(0, 24, 0, 16)
    IconContainer.BackgroundColor3 = self.Colores.acento
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Header
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 8)
    IconCorner.Parent = IconContainer
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = "AI"
    Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    Icon.TextSize = 16
    Icon.Font = self.Estilos.fuenteTitulo
    Icon.Parent = IconContainer
    
    -- Titulo estilo Claude
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -220, 0, 24)
    Title.Position = UDim2.new(0, 76, 0, 16)
    Title.BackgroundTransparency = 1
    Title.Text = config.titulo
    Title.TextColor3 = self.Colores.textoPrincipal
    Title.TextSize = self.Estilos.tamanoTitulo
    Title.Font = self.Estilos.fuenteTitulo
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtitulo
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -220, 0, 18)
    Subtitle.Position = UDim2.new(0, 76, 0, 42)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = config.subtitulo
    Subtitle.TextColor3 = self.Colores.textoSecundario
    Subtitle.TextSize = 13
    Subtitle.Font = self.Estilos.fuentePrincipal
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header
    
    -- Boton cerrar minimalista
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -64, 0, 16)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = self.Colores.textoSecundario
    CloseBtn.TextSize = 18
    CloseBtn.Font = self.Estilos.fuentePrincipal
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Hover effect
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(self.Estilos.duracionRapida), {
            BackgroundTransparency = 0.9,
            TextColor3 = self.Colores.textoPrincipal
        }):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(self.Estilos.duracionRapida), {
            BackgroundTransparency = 1,
            TextColor3 = self.Colores.textoSecundario
        }):Play()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:cerrarVentana(parent.Parent)
    end)
    
    return Header
end

function UI:_crearChatArea(parent)
    local ChatArea = Instance.new("ScrollingFrame")
    ChatArea.Name = "ChatArea"
    ChatArea.Size = UDim2.new(1, -48, 0, 660)
    ChatArea.Position = UDim2.new(0, 24, 0, 84)
    ChatArea.BackgroundColor3 = self.Colores.fondoChat
    ChatArea.BorderSizePixel = 0
    ChatArea.ScrollBarThickness = 6
    ChatArea.ScrollBarImageColor3 = self.Colores.bordeOscuro
    ChatArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChatArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChatArea.Parent = parent
    
    local ChatCorner = Instance.new("UICorner")
    ChatCorner.CornerRadius = UDim.new(0, 8)
    ChatCorner.Parent = ChatArea
    
    -- Borde muy sutil
    local ChatStroke = Instance.new("UIStroke")
    ChatStroke.Color = self.Colores.borde
    ChatStroke.Thickness = 1
    ChatStroke.Parent = ChatArea
    
    local ChatLayout = Instance.new("UIListLayout")
    ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChatLayout.Padding = UDim.new(0, 16)
    ChatLayout.Parent = ChatArea
    
    local ChatPadding = Instance.new("UIPadding")
    ChatPadding.PaddingTop = UDim.new(0, 20)
    ChatPadding.PaddingBottom = UDim.new(0, 20)
    ChatPadding.PaddingLeft = UDim.new(0, 20)
    ChatPadding.PaddingRight = UDim.new(0, 20)
    ChatPadding.Parent = ChatArea
    
    return ChatArea
end

function UI:_crearStatusBar(parent)
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(1, -48, 0, 32)
    StatusBar.Position = UDim2.new(0, 24, 0, 752)
    StatusBar.BackgroundTransparency = 1
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = parent
    
    -- Punto indicador
    local StatusDot = Instance.new("Frame")
    StatusDot.Name = "StatusDot"
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(0, 0, 0.5, -4)
    StatusDot.BackgroundColor3 = self.Colores.exito
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = StatusBar
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot
    
    -- Texto de estado
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -16, 1, 0)
    StatusText.Position = UDim2.new(0, 16, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Listo"
    StatusText.TextColor3 = self.Colores.textoSecundario
    StatusText.TextSize = 13
    StatusText.Font = self.Estilos.fuentePrincipal
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar
    
    return {StatusBar = StatusBar, StatusDot = StatusDot, StatusText = StatusText}
end

function UI:_crearInput(parent)
    local InputContainer = Instance.new("Frame")
    InputContainer.Name = "InputContainer"
    InputContainer.Size = UDim2.new(1, -48, 0, 52)
    InputContainer.Position = UDim2.new(0, 24, 0, 792)
    InputContainer.BackgroundColor3 = self.Colores.fondoChat
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = parent
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 26)
    InputCorner.Parent = InputContainer
    
    -- Borde que cambia en focus
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Name = "InputStroke"
    InputStroke.Color = self.Colores.borde
    InputStroke.Thickness = 1.5
    InputStroke.Parent = InputContainer
    
    -- TextBox
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, -100, 1, 0)
    InputBox.Position = UDim2.new(0, 20, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.TextColor3 = self.Colores.textoPrincipal
    InputBox.PlaceholderText = "Escribe un comando..."
    InputBox.PlaceholderColor3 = self.Colores.textoTerciario
    InputBox.Text = ""
    InputBox.TextSize = self.Estilos.tamanoTexto
    InputBox.Font = self.Estilos.fuentePrincipal
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = InputContainer
    
    -- Efectos de focus
    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(self.Estilos.duracionRapida), {
            Color = self.Colores.acento,
            Thickness = 2
        }):Play()
    end)
    
    InputBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(self.Estilos.duracionRapida), {
            Color = self.Colores.borde,
            Thickness = 1.5
        }):Play()
    end)
    
    -- Boton enviar estilo Claude
    local SendBtn = Instance.new("TextButton")
    SendBtn.Size = UDim2.new(0, 40, 0, 40)
    SendBtn.Position = UDim2.new(1, -46, 0.5, -20)
    SendBtn.BackgroundColor3 = self.Colores.acento
    SendBtn.Text = ">"
    SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SendBtn.TextSize = 18
    SendBtn.Font = self.Estilos.fuenteTitulo
    SendBtn.BorderSizePixel = 0
    SendBtn.AutoButtonColor = false
    SendBtn.Parent = InputContainer
    
    local SendCorner = Instance.new("UICorner")
    SendCorner.CornerRadius = UDim.new(1, 0)
    SendCorner.Parent = SendBtn
    
    -- Hover effect
    SendBtn.MouseEnter:Connect(function()
        TweenService:Create(SendBtn, TweenInfo.new(self.Estilos.duracionRapida), {
            BackgroundColor3 = self.Colores.acentoHover
        }):Play()
    end)
    
    SendBtn.MouseLeave:Connect(function()
        TweenService:Create(SendBtn, TweenInfo.new(self.Estilos.duracionRapida), {
            BackgroundColor3 = self.Colores.acento
        }):Play()
    end)
    
    return {InputFrame = InputContainer, InputBox = InputBox, SendBtn = SendBtn}
end

-- ============================================================
-- FUNCION: CREAR MENSAJE ESTILO CLAUDE
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
    
    -- Container del mensaje
    local MsgContainer = Instance.new("Frame")
    MsgContainer.Size = UDim2.new(1, 0, 0, 0)
    MsgContainer.AutomaticSize = Enum.AutomaticSize.Y
    MsgContainer.BackgroundTransparency = 1
    MsgContainer.LayoutOrder = msgCount
    MsgContainer.Parent = chatArea
    
    -- Color de fondo segun tipo
    local backgroundColor
    if cfg.esUsuario then
        backgroundColor = self.Colores.mensajeUsuario
    elseif cfg.esError then
        backgroundColor = Color3.fromRGB(254, 242, 242)
    elseif cfg.esExito then
        backgroundColor = Color3.fromRGB(240, 253, 244)
    else
        backgroundColor = self.Colores.mensajeIA
    end
    
    -- Bubble del mensaje
    local MsgBubble = Instance.new("TextLabel")
    MsgBubble.Size = UDim2.new(1, 0, 0, 0)
    MsgBubble.AutomaticSize = Enum.AutomaticSize.Y
    MsgBubble.BackgroundColor3 = backgroundColor
    MsgBubble.TextColor3 = self.Colores.textoPrincipal
    MsgBubble.Text = cfg.texto
    MsgBubble.TextSize = self.Estilos.tamanoTexto
    MsgBubble.Font = self.Estilos.fuentePrincipal
    MsgBubble.TextWrapped = true
    MsgBubble.TextXAlignment = Enum.TextXAlignment.Left
    MsgBubble.TextYAlignment = Enum.TextYAlignment.Top
    MsgBubble.BorderSizePixel = 0
    MsgBubble.BackgroundTransparency = 1
    MsgBubble.TextTransparency = 1
    MsgBubble.Parent = MsgContainer
    
    local MsgCorner = Instance.new("UICorner")
    MsgCorner.CornerRadius = UDim.new(0, 8)
    MsgCorner.Parent = MsgBubble
    
    local MsgPadding = Instance.new("UIPadding")
    MsgPadding.PaddingTop = UDim.new(0, 16)
    MsgPadding.PaddingBottom = UDim.new(0, 16)
    MsgPadding.PaddingLeft = UDim.new(0, 16)
    MsgPadding.PaddingRight = UDim.new(0, 16)
    MsgPadding.Parent = MsgBubble
    
    -- Animacion de entrada suave
    TweenService:Create(MsgBubble, TweenInfo.new(self.Estilos.duracionNormal, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        TextTransparency = 0
    }):Play()
    
    -- Scroll automatico
    task.wait(0.05)
    local targetPos = chatArea.AbsoluteCanvasSize.Y
    TweenService:Create(chatArea, TweenInfo.new(self.Estilos.duracionNormal, Enum.EasingStyle.Quart), {
        CanvasPosition = Vector2.new(0, targetPos)
    }):Play()
    
    return MsgBubble
end

-- ============================================================
-- FUNCION: NOTIFICACION ESTILO TOAST
-- ============================================================

function UI:mostrarNotificacion(config)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "Notificacion",
        tipo = config.tipo or "info",
        duracion = config.duracion or 3,
    }
    
    local color
    if cfg.tipo == "exito" then color = self.Colores.exito
    elseif cfg.tipo == "error" then color = self.Colores.error
    elseif cfg.tipo == "advertencia" then color = self.Colores.advertencia
    else color = self.Colores.textoPrincipal end
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(0, 0, 0, 0)
    Toast.Position = UDim2.new(0.5, 0, 1, -100)
    Toast.AnchorPoint = Vector2.new(0.5, 0)
    Toast.BackgroundColor3 = self.Colores.textoPrincipal
    Toast.BorderSizePixel = 0
    Toast.Parent = ScreenGui
    
    local ToastCorner = Instance.new("UICorner")
    ToastCorner.CornerRadius = UDim.new(0, 8)
    ToastCorner.Parent = Toast
    
    local ToastText = Instance.new("TextLabel")
    ToastText.Size = UDim2.new(1, -32, 1, 0)
    ToastText.Position = UDim2.new(0, 16, 0, 0)
    ToastText.BackgroundTransparency = 1
    ToastText.Text = cfg.texto
    ToastText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToastText.TextSize = 14
    ToastText.Font = self.Estilos.fuentePrincipal
    ToastText.TextXAlignment = Enum.TextXAlignment.Center
    ToastText.Parent = Toast
    
    -- Animacion entrada
    TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 48)
    }):Play()
    
    -- Auto-destruir
    task.delay(cfg.duracion, function()
        TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 48),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(ToastText, TweenInfo.new(0.25), {
            TextTransparency = 1
        }):Play()
        
        task.wait(0.3)
        Toast:Destroy()
    end)
end

-- ============================================================
-- FUNCION: ACTUALIZAR ESTADO
-- ============================================================

function UI:actualizarEstado(statusComponents, estado, mensaje)
    local colores = {
        listo = self.Colores.exito,
        pensando = self.Colores.advertencia,
        error = self.Colores.error,
        exito = self.Colores.exito,
    }
    
    local color = colores[estado] or self.Colores.textoSecundario
    
    TweenService:Create(statusComponents.StatusDot, TweenInfo.new(self.Estilos.duracionRapida), {
        BackgroundColor3 = color
    }):Play()
    
    statusComponen
