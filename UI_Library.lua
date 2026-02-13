-- ============================================================
-- UI_LIBRARY.LUA v3.2.2 - FIX CRÍTICO
-- Corregido: PaddingBottom UDim (no UDim2)
-- ============================================================

local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

UI.Colores = {
    fondo = Color3.fromRGB(25, 25, 28),
    fondoChat = Color3.fromRGB(32, 33, 35),
    mensajeIA = Color3.fromRGB(42, 43, 46),
    mensajeUsuario = Color3.fromRGB(52, 53, 65),
    textoPrincipal = Color3.fromRGB(236, 236, 241),
    textoSecundario = Color3.fromRGB(142, 142, 160),
    textoTerciario = Color3.fromRGB(86, 88, 105),
    acento = Color3.fromRGB(171, 104, 255),
    acentoHover = Color3.fromRGB(151, 84, 235),
    acentoGradiente = Color3.fromRGB(99, 102, 241),
    borde = Color3.fromRGB(52, 53, 65),
    bordeOscuro = Color3.fromRGB(42, 43, 46),
    exito = Color3.fromRGB(16, 185, 129),
    error = Color3.fromRGB(239, 68, 68),
    advertencia = Color3.fromRGB(245, 158, 11),
}

UI.Estilos = {
    fuentePrincipal = Enum.Font.Gotham,
    fuenteTitulo = Enum.Font.GothamBold,
    tamanoTexto = 14,
    tamanoTitulo = 17,
    redondeo = 10,
    duracionRapida = 0.15,
    duracionNormal = 0.25,
    duracionLenta = 0.35,
    streamingNormal = 0.03,
    streamingRapido = 0.015,
    streamingLento = 0.05,
}

UI.Memoria = {
    historial = {},
    maxHistorial = 100,
    contexto = {},
    maxContexto = 10,
    preferencias = {
        velocidadStreaming = "normal",
        mostrarTimestamps = false,
        sonidosActivados = true,
    },
    estadisticas = {
        mensajesEnviados = 0,
        mensajesRecibidos = 0,
        sesionInicio = os.time(),
    }
}

function UI:guardarMensaje(texto, esUsuario, metadata)
    local mensaje = {
        texto = texto,
        esUsuario = esUsuario,
        timestamp = os.time(),
        metadata = metadata or {}
    }
    
    table.insert(self.Memoria.historial, mensaje)
    table.insert(self.Memoria.contexto, mensaje)
    
    if #self.Memoria.historial > self.Memoria.maxHistorial then
        table.remove(self.Memoria.historial, 1)
    end
    
    if #self.Memoria.contexto > self.Memoria.maxContexto then
        table.remove(self.Memoria.contexto, 1)
    end
    
    if esUsuario then
        self.Memoria.estadisticas.mensajesEnviados = self.Memoria.estadisticas.mensajesEnviados + 1
    else
        self.Memoria.estadisticas.mensajesRecibidos = self.Memoria.estadisticas.mensajesRecibidos + 1
    end
end

function UI:obtenerContexto()
    return self.Memoria.contexto
end

-- ============================================================
-- SPLASH SCREEN - TAMAÑO 500x600
-- ============================================================

function UI:mostrarSplashScreen(callback)
    print("[UI_Library] Iniciando splash screen...")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RozekSplash"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 1000
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Fondo = Instance.new("Frame")
    Fondo.Size = UDim2.new(0, 500, 0, 600)
    Fondo.Position = UDim2.new(0.5, -250, 0.5, -300)
    Fondo.BackgroundColor3 = self.Colores.fondo
    Fondo.BorderSizePixel = 0
    Fondo.Parent = ScreenGui
    
    local FondoCorner = Instance.new("UICorner")
    FondoCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    FondoCorner.Parent = Fondo
    
    local FondoStroke = Instance.new("UIStroke")
    FondoStroke.Color = self.Colores.borde
    FondoStroke.Thickness = 1
    FondoStroke.Transparency = 0.5
    FondoStroke.Parent = Fondo
    
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(0, 200, 0, 200)
    LogoContainer.Position = UDim2.new(0.5, -100, 0.4, -100)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Fondo
    
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 100, 0, 100)
    Logo.Position = UDim2.new(0.5, -50, 0, 0)
    Logo.BackgroundColor3 = self.Colores.acento
    Logo.Text = "R"
    Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    Logo.TextSize = 60
    Logo.Font = self.Estilos.fuenteTitulo
    Logo.BorderSizePixel = 0
    Logo.BackgroundTransparency = 1
    Logo.TextTransparency = 1
    Logo.Parent = LogoContainer
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 20)
    LogoCorner.Parent = Logo
    
    local Titulo = Instance.new("TextLabel")
    Titulo.Size = UDim2.new(0, 200, 0, 40)
    Titulo.Position = UDim2.new(0, 0, 0, 110)
    Titulo.BackgroundTransparency = 1
    Titulo.Text = "Rozek"
    Titulo.TextColor3 = self.Colores.textoPrincipal
    Titulo.TextSize = 32
    Titulo.Font = self.Estilos.fuenteTitulo
    Titulo.TextTransparency = 1
    Titulo.Parent = LogoContainer
    
    local Subtitulo = Instance.new("TextLabel")
    Subtitulo.Size = UDim2.new(0, 200, 0, 20)
    Subtitulo.Position = UDim2.new(0, 0, 0, 150)
    Subtitulo.BackgroundTransparency = 1
    Subtitulo.Text = "Asistente IA v3.2"
    Subtitulo.TextColor3 = self.Colores.textoSecundario
    Subtitulo.TextSize = 14
    Subtitulo.Font = self.Estilos.fuentePrincipal
    Subtitulo.TextTransparency = 1
    Subtitulo.Parent = LogoContainer
    
    local BarraContainer = Instance.new("Frame")
    BarraContainer.Size = UDim2.new(0, 300, 0, 4)
    BarraContainer.Position = UDim2.new(0.5, -150, 0.7, 0)
    BarraContainer.BackgroundColor3 = self.Colores.bordeOscuro
    BarraContainer.BorderSizePixel = 0
    BarraContainer.BackgroundTransparency = 1
    BarraContainer.Parent = Fondo
    
    local BarraCorner = Instance.new("UICorner")
    BarraCorner.CornerRadius = UDim.new(1, 0)
    BarraCorner.Parent = BarraContainer
    
    local Barra = Instance.new("Frame")
    Barra.Size = UDim2.new(0, 0, 1, 0)
    Barra.BackgroundColor3 = self.Colores.acento
    Barra.BorderSizePixel = 0
    Barra.Parent = BarraContainer
    
    local BarraProgCorner = Instance.new("UICorner")
    BarraProgCorner.CornerRadius = UDim.new(1, 0)
    BarraProgCorner.Parent = Barra
    
    local Gradiente = Instance.new("UIGradient")
    Gradiente.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.Colores.acento),
        ColorSequenceKeypoint.new(1, self.Colores.acentoGradiente)
    }
    Gradiente.Parent = Barra
    
    local Estado = Instance.new("TextLabel")
    Estado.Size = UDim2.new(0, 300, 0, 20)
    Estado.Position = UDim2.new(0.5, -150, 0.75, 0)
    Estado.BackgroundTransparency = 1
    Estado.Text = "Iniciando sistema..."
    Estado.TextColor3 = self.Colores.textoTerciario
    Estado.TextSize = 12
    Estado.Font = self.Estilos.fuentePrincipal
    Estado.TextTransparency = 1
    Estado.Parent = Fondo
    
    task.spawn(function()
        print("[UI_Library] Animando splash...")
        
        TweenService:Create(Logo, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            TextTransparency = 0
        }):Play()
        
        TweenService:Create(Titulo, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
        
        TweenService:Create(Subtitulo, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
        
        task.wait(0.4)
        
        TweenService:Create(BarraContainer, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(Estado, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        
        task.wait(0.2)
        
        TweenService:Create(Barra, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
        
        task.wait(0.9)
        
        Estado.Text = "¡Listo!"
        task.wait(0.2)
        
        print("[UI_Library] Splash completado, ejecutando callback...")
        
        for _, obj in ipairs({Logo, Titulo, Subtitulo, BarraContainer, Estado}) do
            TweenService:Create(obj, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                TextTransparency = 1
            }):Play()
        end
        
        TweenService:Create(FondoStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(Fondo, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        
        task.wait(0.3)
        ScreenGui:Destroy()
        print("[UI_Library] Splash destruido")
        
        if callback then 
            print("[UI_Library] Ejecutando callback...")
            callback() 
        end
    end)
end

-- ============================================================
-- CREAR VENTANA
-- ============================================================

function UI:crearVentana(config)
    config = config or {}
    
    local cfg = {
        titulo = config.titulo or "Rozek",
        subtitulo = config.subtitulo or "Asistente IA v3.2",
        ancho = config.ancho or 500,
        alto = config.alto or 600,
        draggable = config.draggable ~= false,
        mostrarSplash = config.mostrarSplash ~= false,
    }
    
    local function crearInterfaz()
        print("[UI_Library] Creando interfaz...")
        
        pcall(function()
            local vieja = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor")
            if vieja then vieja:Destroy() end
        end)
        
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "RobloxAIConstructor"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.DisplayOrder = 999
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = game:GetService("CoreGui")
        
        local Main = Instance.new("Frame")
        Main.Name = "Main"
        Main.Size = UDim2.new(0, cfg.ancho, 0, 0)
        Main.Position = UDim2.new(0.5, -cfg.ancho/2, 0.5, -cfg.alto/2)
        Main.AnchorPoint = Vector2.new(0, 0)
        Main.BackgroundColor3 = self.Colores.fondo
        Main.BorderSizePixel = 0
        Main.Active = true
        Main.Parent = ScreenGui
        
        if cfg.draggable then
            Main.Draggable = true
        end
        
        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
        MainCorner.Parent = Main
        
        local MainStroke = Instance.new("UIStroke")
        MainStroke.Color = self.Colores.borde
        MainStroke.Thickness = 1
        MainStroke.Transparency = 0.5
        MainStroke.Parent = Main
        
        local componentes = {
            ScreenGui = ScreenGui,
            Main = Main,
            Header = nil,
            ChatArea = nil,
            InputBox = nil,
            StatusBar = nil,
        }
        
        componentes.Header = self:_crearHeader(Main, cfg)
        componentes.ChatArea = self:_crearChatArea(Main)
        componentes.StatusBar = self:_crearStatusBar(Main)
        componentes.InputBox = self:_crearInput(Main)
        
        Main.BackgroundTransparency = 1
        TweenService:Create(Main, TweenInfo.new(self.Estilos.duracionLenta, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, cfg.ancho, 0, cfg.alto),
            BackgroundTransparency = 0
        }):Play()
        
        print("[UI_Library] Interfaz creada exitosamente")
        
        return componentes
    end
    
    if cfg.mostrarSplash then
        self:mostrarSplashScreen(function()
            crearInterfaz()
        end)
        return nil
    else
        return crearInterfaz()
    end
end

function UI:_crearHeader(parent, config)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = self.Colores.fondo
    Header.BorderSizePixel = 0
    Header.Parent = parent
    
    local Divisor = Instance.new("Frame")
    Divisor.Size = UDim2.new(1, -40, 0, 1)
    Divisor.Position = UDim2.new(0, 20, 1, -1)
    Divisor.BackgroundColor3 = self.Colores.borde
    Divisor.BorderSizePixel = 0
    Divisor.Parent = Header
    
    local IconContainer = Instance.new("Frame")
    IconContainer.Size = UDim2.new(0, 36, 0, 36)
    IconContainer.Position = UDim2.new(0, 20, 0, 12)
    IconContainer.BackgroundColor3 = self.Colores.acento
    IconContainer.BorderSizePixel = 0
    IconContainer.Parent = Header
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 8)
    IconCorner.Parent = IconContainer
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = "R"
    Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    Icon.TextSize = 18
    Icon.Font = self.Estilos.fuenteTitulo
    Icon.Parent = IconContainer
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -180, 0, 20)
    Title.Position = UDim2.new(0, 66, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = config.titulo
    Title.TextColor3 = self.Colores.textoPrincipal
    Title.TextSize = self.Estilos.tamanoTitulo
    Title.Font = self.Estilos.fuenteTitulo
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -180, 0, 16)
    Subtitle.Position = UDim2.new(0, 66, 0, 34)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = config.subtitulo
    Subtitle.TextColor3 = self.Colores.textoSecundario
    Subtitle.TextSize = 12
    Subtitle.Font = self.Estilos.fuentePrincipal
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 36, 0, 36)
    CloseBtn.Position = UDim2.new(1, -56, 0, 12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = self.Colores.textoSecundario
    CloseBtn.TextSize = 16
    CloseBtn.Font = self.Estilos.fuentePrincipal
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
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
    ChatArea.Size = UDim2.new(1, -40, 0, 440)
    ChatArea.Position = UDim2.new(0, 20, 0, 72)
    ChatArea.BackgroundColor3 = self.Colores.fondoChat
    ChatArea.BorderSizePixel = 0
    ChatArea.ScrollBarThickness = 4
    ChatArea.ScrollBarImageColor3 = self.Colores.textoTerciario
    ChatArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChatArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChatArea.Parent = parent
    
    local ChatCorner = Instance.new("UICorner")
    ChatCorner.CornerRadius = UDim.new(0, 8)
    ChatCorner.Parent = ChatArea
    
    local ChatStroke = Instance.new("UIStroke")
    ChatStroke.Color = self.Colores.borde
    ChatStroke.Thickness = 1
    ChatStroke.Transparency = 0.5
    ChatStroke.Parent = ChatArea
    
    local ChatLayout = Instance.new("UIListLayout")
    ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChatLayout.Padding = UDim.new(0, 12)
    ChatLayout.Parent = ChatArea
    
    local ChatPadding = Instance.new("UIPadding")
    ChatPadding.PaddingTop = UDim.new(0, 16)
    ChatPadding.PaddingBottom = UDim.new(0, 16)
    ChatPadding.PaddingLeft = UDim.new(0, 16)
    ChatPadding.PaddingRight = UDim.new(0, 16)
    ChatPadding.Parent = ChatArea
    
    return ChatArea
end

function UI:_crearStatusBar(parent)
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(1, -40, 0, 24)
    StatusBar.Position = UDim2.new(0, 20, 0, 520)
    StatusBar.BackgroundTransparency = 1
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = parent
    
    local StatusDot = Instance.new("Frame")
    StatusDot.Name = "StatusDot"
    StatusDot.Size = UDim2.new(0, 6, 0, 6)
    StatusDot.Position = UDim2.new(0, 0, 0.5, -3)
    StatusDot.BackgroundColor3 = self.Colores.exito
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = StatusBar
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -14, 1, 0)
    StatusText.Position = UDim2.new(0, 14, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Listo"
    StatusText.TextColor3 = self.Colores.textoSecundario
    StatusText.TextSize = 12
    StatusText.Font = self.Estilos.fuentePrincipal
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar
    
    return {StatusBar = StatusBar, StatusDot = StatusDot, StatusText = StatusText}
end

function UI:_crearInput(parent)
    local InputContainer = Instance.new("Frame")
    InputContainer.Name = "InputContainer"
    InputContainer.Size = UDim2.new(1, -40, 0, 48)
    InputContainer.Position = UDim2.new(0, 20, 0, 548)
    InputContainer.BackgroundColor3 = self.Colores.fondoChat
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = parent
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 24)
    InputCorner.Parent = InputContainer
    
    local InputStroke = Instance.new("UIStroke")
    InputStroke.Name = "InputStroke"
    InputStroke.Color = self.Colores.borde
    InputStroke.Thickness = 1.5
    InputStroke.Transparency = 0.5
    InputStroke.Parent = InputContainer
    
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, -90, 1, 0)
    InputBox.Position = UDim2.new(0, 18, 0, 0)
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
    
    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(self.Estilos.duracionRapida), {
            Color = self.Colores.acento,
            Thickness = 2,
            Transparency = 0
        }):Play()
    end)
    
    InputBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(self.Estilos.duracionRapida), {
            Color = self.Colores.borde,
            Thickness = 1.5,
            Transparency = 0.5
        }):Play()
    end)
    
    local SendBtn = Instance.new("TextButton")
    SendBtn.Size = UDim2.new(0, 36, 0, 36)
    SendBtn.Position = UDim2.new(1, -42, 0.5, -18)
    SendBtn.BackgroundColor3 = self.Colores.acento
    SendBtn.Text = "→"
    SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SendBtn.TextSize = 18
    SendBtn.Font = self.Estilos.fuenteTitulo
    SendBtn.BorderSizePixel = 0
    SendBtn.AutoButtonColor = false
    SendBtn.Parent = InputContainer
    
    local SendCorner = Instance.new("UICorner")
    SendCorner.CornerRadius = UDim.new(1, 0)
    SendCorner.Parent = SendBtn
    
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

function UI:crearMensajeConStreaming(chatArea, config, callback)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "",
        esUsuario = config.esUsuario or false,
        esError = config.esError or false,
        esExito = config.esExito or false,
        velocidad = config.velocidad or "normal",
    }
    
    self:guardarMensaje(cfg.texto, cfg.esUsuario)
    
    local msgCount = #chatArea:GetChildren() - 2
    
    local MsgContainer = Instance.new("Frame")
    MsgContainer.Size = UDim2.new(1, 0, 0, 0)
    MsgContainer.AutomaticSize = Enum.AutomaticSize.Y
    MsgContainer.BackgroundTransparency = 1
    MsgContainer.LayoutOrder = msgCount
    MsgContainer.Parent = chatArea
    
    local backgroundColor
    if cfg.esUsuario then
        backgroundColor = self.Colores.mensajeUsuario
    elseif cfg.esError then
        backgroundColor = Color3.fromRGB(60, 30, 30)
    elseif cfg.esExito then
        backgroundColor = Color3.fromRGB(20, 60, 40)
    else
        backgroundColor = self.Colores.mensajeIA
    end
    
    local MsgBubble = Instance.new("TextLabel")
    MsgBubble.Size = UDim2.new(1, 0, 0, 0)
    MsgBubble.AutomaticSize = Enum.AutomaticSize.Y
    MsgBubble.BackgroundColor3 = backgroundColor
    MsgBubble.TextColor3 = self.Colores.textoPrincipal
    MsgBubble.Text = ""
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
    
    -- ✅ FIX CRÍTICO: UDim no UDim2
    local MsgPadding = Instance.new("UIPadding")
    MsgPadding.PaddingTop = UDim.new(0, 12)
    MsgPadding.PaddingBottom = UDim.new(0, 12)  -- ⬅️ CORREGIDO
    MsgPadding.PaddingLeft = UDim.new(0, 14)
    MsgPadding.PaddingRight = UDim.new(0, 14)
    MsgPadding.Parent = MsgBubble
    
    TweenService:Create(MsgBubble, TweenInfo.new(self.Estilos.duracionRapida), {
        BackgroundTransparency = 0
    }):Play()
    
    if cfg.esUsuario then
        MsgBubble.Text = cfg.texto
        TweenService:Create(MsgBubble, TweenInfo.new(self.Estilos.duracionRapida), {
            TextTransparency = 0
        }):Play()
        
        task.wait(0.05)
        local targetPos = chatArea.AbsoluteCanvasSize.Y
        TweenService:Create(chatArea, TweenInfo.new(self.Estilos.duracionNormal, Enum.EasingStyle.Quart), {
            CanvasPosition = Vector2.new(0, targetPos)
        }):Play()
        
        if callback then callback() end
        return MsgBubble
    end
    
    TweenService:Create(MsgBubble, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
    
    task.spawn(function()
        local velocidadChar = self.Estilos.streamingNormal
        if cfg.velocidad == "rapido" then
            velocidadChar = self.Estilos.streamingRapido
        elseif cfg.velocidad == "lento" then
            velocidadChar = self.Estilos.streamingLento
        end
        
        local textoCompleto = cfg.texto
        local caracteresAMostrar = 0
        
        while caracteresAMostrar < #textoCompleto do
            caracteresAMostrar = caracteresAMostrar + 1
            MsgBubble.Text = textoCompleto:sub(1, caracteresAMostrar)
            
            if caracteresAMostrar % 10 == 0 then
                local targetPos = chatArea.AbsoluteCanvasSize.Y
                chatArea.CanvasPosition = Vector2.new(0, targetPos)
            end
            
            task.wait(velocidadChar)
        end
        
        MsgBubble.Text = textoCompleto
        
        task.wait(0.05)
        local targetPos = chatArea.AbsoluteCanvasSize.Y
        TweenService:Create(chatArea, TweenInfo.new(self.Estilos.duracionNormal, Enum.EasingStyle.Quart), {
            CanvasPosition = Vector2.new(0, targetPos)
        }):Play()
        
        if callback then callback() end
    end)
    
    return MsgBubble
end

function UI:crearMensaje(chatArea, config)
    return self:crearMensajeConStreaming(chatArea, config)
end

function UI:mostrarPensando(chatArea)
    local msgCount = #chatArea:GetChildren() - 2
    
    local MsgContainer = Instance.new("Frame")
    MsgContainer.Name = "PensandoIndicador"
    MsgContainer.Size = UDim2.new(1, 0, 0, 0)
    MsgContainer.AutomaticSize = Enum.AutomaticSize.Y
    MsgContainer.BackgroundTransparency = 1
    MsgContainer.LayoutOrder = msgCount
    MsgContainer.Parent = chatArea
    
    local MsgBubble = Instance.new("Frame")
    MsgBubble.Size = UDim2.new(0, 70, 0, 40)
    MsgBubble.BackgroundColor3 = self.Colores.mensajeIA
    MsgBubble.BorderSizePixel = 0
    MsgBubble.Parent = MsgContainer
    
    local MsgCorner = Instance.new("UICorner")
    MsgCorner.CornerRadius = UDim.new(0, 8)
    MsgCorner.Parent = MsgBubble
    
    local PuntosContainer = Instance.new("Frame")
    PuntosContainer.Size = UDim2.new(0, 42, 0, 20)
    PuntosContainer.Position = UDim2.new(0.5, -21, 0.5, -10)
    PuntosContainer.BackgroundTransparency = 1
    PuntosContainer.Parent = MsgBubble
    
    for i = 1, 3 do
        local punto = Instance.new("Frame")
        punto.Size = UDim2.new(0, 6, 0, 6)
        punto.Position = UDim2.new(0, (i-1) * 14 + 4, 0.5, -3)
        punto.BackgroundColor3 = self.Colores.textoTerciario
        punto.BorderSizePixel = 0
        punto.Parent = PuntosContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = punto
        
        task.spawn(function()
            while MsgContainer.Parent do
                TweenService:Create(punto, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0, (i-1) * 14 + 4, 0.5, -10)
                }):Play()
                task.wait(0.2 * (i-1))
                task.wait(0.6)
                TweenService:Create(punto, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0, (i-1) * 14 + 4, 0.5, -3)
                }):Play()
                task.wait(0.6 + 0.2 * (3-i))
            end
        end)
    end
    
    task.wait(0.05)
    local targetPos = chatArea.AbsoluteCanvasSize.Y
    TweenService:Create(chatArea, TweenInfo.new(self.Estilos.duracionNormal, Enum.EasingStyle.Quart), {
        CanvasPosition = Vector2.new(0, targetPos)
    }):Play()
    
    return MsgContainer
end

function UI:ocultarPensando(chatArea)
    local pensando = chatArea:FindFirstChild("PensandoIndicador")
    if pensando then
        pensando:Destroy()
    end
end

function UI:mostrarNotificacion(config)
    config = config or {}
    
    local cfg = {
        texto = config.texto or "Notificación",
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
    Toast.Position = UDim2.new(0.5, 0, 1, -80)
    Toast.AnchorPoint = Vector2.new(0.5, 0)
    Toast.BackgroundColor3 = self.Colores.fondoChat
    Toast.BorderSizePixel = 0
    Toast.Parent = ScreenGui
    
    local ToastCorner = Instance.new("UICorner")
    ToastCorner.CornerRadius = UDim.new(0, 8)
    ToastCorner.Parent = Toast
    
    local ToastStroke = Instance.new("UIStroke")
    ToastStroke.Color = self.Colores.borde
    ToastStroke.Thickness = 1
    ToastStroke.Parent = Toast
    
    local ToastText = Instance.new("TextLabel")
    ToastText.Size = UDim2.new(1, -24, 1, 0)
    ToastText.Position = UDim2.new(0, 12, 0, 0)
    ToastText.BackgroundTransparency = 1
    ToastText.Text = cfg.texto
    ToastText.TextColor3 = self.Colores.textoPrincipal
    ToastText.TextSize = 13
    ToastText.Font = self.Estilos.fuentePrincipal
    ToastText.TextXAlignment = Enum.TextXAlignment.Center
    ToastText.Parent = Toast
    
    TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 44)
    }):Play()
    
    task.delay(cfg.duracion, function()
        TweenService:Create(Toast, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 44),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(ToastText, TweenInfo.new(0.25), {
            TextTransparency = 1
        }):Play()
        
        task.wait(0.3)
        Toast:Destroy()
    end)
end

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
    
    statusComponents.StatusText.Text = mensaje or estado
    
    if estado == "pensando" then
        local pulso = TweenService:Create(
            statusComponents.StatusDot,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true),
            {BackgroundTransparency = 0.3}
        )
        pulso:Play()
        statusComponents.StatusDot:SetAttribute("Pulso", pulso)
    else
        local pulso = statusComponents.StatusDot:GetAttribute("Pulso")
        if pulso then
            pulso:Cancel()
        end
        statusComponents.StatusDot.BackgroundTransparency = 0
    end
end

function UI:cerrarVentana(screenGui)
    local main = screenGui:FindFirstChild("Main")
    if main then
        TweenService:Create(main, TweenInfo.new(self.Estilos.duracionNormal, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, main.Size.X.Offset, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.3)
    end
    
    screenGui:Destroy()
end

return UI
