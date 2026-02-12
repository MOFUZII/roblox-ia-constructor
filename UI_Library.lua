-- ============================================================
-- UI_LIBRARY.LUA - Libreria de Interfaz
-- Modulo 3: Sistema completo de GUI
-- ============================================================

local UI = {}

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local player           = Players.LocalPlayer

-- ============================================================
-- COLORES
-- ============================================================

UI.Colores = {
    primario         = Color3.fromRGB(0, 200, 120),
    secundario       = Color3.fromRGB(0, 150, 255),
    fondo            = Color3.fromRGB(15, 15, 25),
    fondoOscuro      = Color3.fromRGB(8, 10, 20),
    texto            = Color3.fromRGB(240, 245, 255),
    textoSecundario  = Color3.fromRGB(150, 160, 180),
    exito            = Color3.fromRGB(0, 255, 140),
    error            = Color3.fromRGB(255, 60, 60),
    advertencia      = Color3.fromRGB(255, 195, 0),
    info             = Color3.fromRGB(100, 150, 255),
    mensajeUsuario   = Color3.fromRGB(0, 120, 215),
    mensajeIA        = Color3.fromRGB(30, 30, 50),
    mensajeError     = Color3.fromRGB(200, 40, 40),
}

UI.Estilos = {
    fuente        = Enum.Font.Gotham,
    fuenteBold    = Enum.Font.GothamBold,
    tamanoTexto   = 13,
    tamanoTitulo  = 18,
    redondeo      = 12,
    padding       = 10,
}

-- ============================================================
-- CREAR VENTANA
-- ============================================================

function UI:crearVentana(config)
    config = config or {}
    local ancho = config.ancho or 450
    local alto  = config.alto  or 600

    pcall(function()
        local vieja = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor")
        if vieja then vieja:Destroy() end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "RobloxAIConstructor"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.DisplayOrder   = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent         = game:GetService("CoreGui")

    local Main = Instance.new("Frame")
    Main.Name             = "Main"
    Main.Size             = UDim2.new(0, ancho, 0, 0)
    Main.Position         = UDim2.new(0.5, -ancho/2, 0.5, 0)
    Main.BackgroundColor3 = self.Colores.fondo
    Main.BorderSizePixel  = 0
    Main.Active           = true
    Main.Draggable        = true
    Main.Parent           = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color     = self.Colores.primario
    MainStroke.Thickness = 2
    MainStroke.Parent    = Main

    local componentes = {
        ScreenGui = ScreenGui,
        Main      = Main,
    }

    componentes.Header    = self:_crearHeader(Main, config)
    componentes.ChatArea  = self:_crearChatArea(Main)
    componentes.StatusBar = self:_crearStatusBar(Main)
    componentes.InputBox  = self:_crearInput(Main)

    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, ancho, 0, alto),
        Position = UDim2.new(0.5, -ancho/2, 0.5, -alto/2)
    }):Play()

    return componentes
end

-- ============================================================
-- HEADER
-- ============================================================

function UI:_crearHeader(parent, config)
    local Header = Instance.new("Frame")
    Header.Name             = "Header"
    Header.Size             = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = self.Colores.primario
    Header.BorderSizePixel  = 0
    Header.Parent           = parent

    local HC = Instance.new("UICorner")
    HC.CornerRadius = UDim.new(0, self.Estilos.redondeo)
    HC.Parent = Header

    local HFix = Instance.new("Frame")
    HFix.Size             = UDim2.new(1, 0, 0, 16)
    HFix.Position         = UDim2.new(0, 0, 1, -16)
    HFix.BackgroundColor3 = self.Colores.primario
    HFix.BorderSizePixel  = 0
    HFix.Parent           = Header

    local Title = Instance.new("TextLabel")
    Title.Size               = UDim2.new(1, -120, 0, 22)
    Title.Position           = UDim2.new(0, 12, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text               = config.titulo or "IA Constructor"
    Title.TextColor3         = Color3.fromRGB(255, 255, 255)
    Title.TextSize           = self.Estilos.tamanoTitulo
    Title.Font               = self.Estilos.fuenteBold
    Title.TextXAlignment     = Enum.TextXAlignment.Left
    Title.Parent             = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size               = UDim2.new(1, -120, 0, 14)
    Subtitle.Position           = UDim2.new(0, 12, 0, 32)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text               = config.subtitulo or ""
    Subtitle.TextColor3         = Color3.fromRGB(200, 255, 220)
    Subtitle.TextSize           = 11
    Subtitle.Font               = self.Estilos.fuente
    Subtitle.TextXAlignment     = Enum.TextXAlignment.Left
    Subtitle.TextTransparency   = 0.3
    Subtitle.Parent             = Header

    -- Boton minimizar
    local MinBtn = self:crearBoton({
        parent   = Header,
        texto    = "-",
        posicion = UDim2.new(1, -64, 0.5, -14),
        tamano   = UDim2.new(0, 28, 0, 28),
        color    = self.Colores.advertencia,
        callback = function() self:_toggleMinimizar(parent) end
    })

    -- Boton cerrar
    local CloseBtn = self:crearBoton({
        parent   = Header,
        texto    = "X",
        posicion = UDim2.new(1, -32, 0.5, -14),
        tamano   = UDim2.new(0, 28, 0, 28),
        color    = self.Colores.error,
        callback = function() self:cerrarVentana(parent.Parent) end
    })

    return Header
end

-- ============================================================
-- CHAT AREA
-- ============================================================

function UI:_crearChatArea(parent)
    local ChatArea = Instance.new("ScrollingFrame")
    ChatArea.Name                 = "ChatArea"
    ChatArea.Size                 = UDim2.new(1, -20, 0, 440)
    ChatArea.Position             = UDim2.new(0, 10, 0, 60)
    ChatArea.BackgroundColor3     = self.Colores.fondoOscuro
    ChatArea.BorderSizePixel      = 0
    ChatArea.ScrollBarThickness   = 6
    ChatArea.ScrollBarImageColor3 = self.Colores.primario
    ChatArea.CanvasSize           = UDim2.new(0, 0, 0, 0)
    ChatArea.AutomaticCanvasSize  = Enum.AutomaticSize.Y
    ChatArea.Parent               = parent

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 10)
    CC.Parent = ChatArea

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding   = UDim.new(0, 8)
    Layout.Parent    = ChatArea

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop    = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.PaddingLeft   = UDim.new(0, 10)
    Padding.PaddingRight  = UDim.new(0, 10)
    Padding.Parent        = ChatArea

    return ChatArea
end

-- ============================================================
-- STATUS BAR
-- ============================================================

function UI:_crearStatusBar(parent)
    local StatusBar = Instance.new("Frame")
    StatusBar.Name             = "StatusBar"
    StatusBar.Size             = UDim2.new(1, -20, 0, 28)
    StatusBar.Position         = UDim2.new(0, 10, 0, 508)
    StatusBar.BackgroundColor3 = Color3.fromRGB(4, 12, 26)
    StatusBar.BorderSizePixel  = 0
    StatusBar.Parent           = parent

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(0, 8)
    SC.Parent = StatusBar

    local StatusDot = Instance.new("Frame")
    StatusDot.Name             = "StatusDot"
    StatusDot.Size             = UDim2.new(0, 8, 0, 8)
    StatusDot.Position         = UDim2.new(0, 10, 0.5, -4)
    StatusDot.BackgroundColor3 = self.Colores.exito
    StatusDot.BorderSizePixel  = 0
    StatusDot.Parent           = StatusBar

    local DC = Instance.new("UICorner")
    DC.CornerRadius = UDim.new(1, 0)
    DC.Parent = StatusDot

    local StatusText = Instance.new("TextLabel")
    StatusText.Name                 = "StatusText"
    StatusText.Size                 = UDim2.new(1, -28, 1, 0)
    StatusText.Position             = UDim2.new(0, 24, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text                 = "Listo"
    StatusText.TextColor3           = Color3.fromRGB(130, 255, 195)
    StatusText.TextSize             = 11
    StatusText.Font                 = self.Estilos.fuente
    StatusText.TextXAlignment       = Enum.TextXAlignment.Left
    StatusText.Parent               = StatusBar

    return { StatusBar = StatusBar, StatusDot = StatusDot, StatusText = StatusText }
end

-- ============================================================
-- INPUT
-- ============================================================

function UI:_crearInput(parent)
    local InputFrame = Instance.new("Frame")
    InputFrame.Name             = "InputFrame"
    InputFrame.Size             = UDim2.new(1, -20, 0, 50)
    InputFrame.Position         = UDim2.new(0, 10, 0, 544)
    InputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    InputFrame.BorderSizePixel  = 0
    InputFrame.Parent           = parent

    local IC = Instance.new("UICorner")
    IC.CornerRadius = UDim.new(0, 10)
    IC.Parent = InputFrame

    local IS = Instance.new("UIStroke")
    IS.Color     = self.Colores.primario
    IS.Thickness = 2
    IS.Parent    = InputFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Name                 = "InputBox"
    InputBox.Size                 = UDim2.new(1, -70, 1, 0)
    InputBox.Position             = UDim2.new(0, 10, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.TextColor3           = self.Colores.texto
    InputBox.PlaceholderText      = "Escribe tu comando aqui..."
    InputBox.PlaceholderColor3    = self.Colores.textoSecundario
    InputBox.Text                 = ""
    InputBox.TextSize             = self.Estilos.tamanoTexto
    InputBox.Font                 = self.Estilos.fuente
    InputBox.TextXAlignment       = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus     = false
    InputBox.Parent               = InputFrame

    local SendBtn = self:crearBoton({
        parent   = InputFrame,
        texto    = ">",
        posicion = UDim2.new(1, -55, 0.5, -20),
        tamano   = UDim2.new(0, 50, 0, 40),
        color    = self.Colores.primario,
        textoTamano = 18
    })

    return { InputFrame = InputFrame, InputBox = InputBox, SendBtn = SendBtn }
end

-- ============================================================
-- CREAR MENSAJE
-- ============================================================

function UI:crearMensaje(chatArea, config)
    config = config or {}
    local esUsuario = config.esUsuario or false
    local esError   = config.esError   or false
    local esExito   = config.esExito   or false
    local texto     = config.texto     or ""

    local count = #chatArea:GetChildren() - 1

    local MsgFrame = Instance.new("Frame")
    MsgFrame.Size                 = UDim2.new(1, 0, 0, 0)
    MsgFrame.AutomaticSize        = Enum.AutomaticSize.Y
    MsgFrame.BackgroundTransparency = 1
    MsgFrame.LayoutOrder          = count
    MsgFrame.Parent               = chatArea

    local bgColor
    if esUsuario then
        bgColor = self.Colores.mensajeUsuario
    elseif esError then
        bgColor = self.Colores.mensajeError
    elseif esExito then
        bgColor = self.Colores.exito
    else
        bgColor = self.Colores.mensajeIA
    end

    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size                 = UDim2.new(0.85, 0, 0, 0)
    MsgLabel.AutomaticSize        = Enum.AutomaticSize.Y
    MsgLabel.Position             = esUsuario and UDim2.new(0.15, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
    MsgLabel.BackgroundColor3     = bgColor
    MsgLabel.TextColor3           = Color3.fromRGB(255, 255, 255)
    MsgLabel.Text                 = texto
    MsgLabel.TextSize             = self.Estilos.tamanoTexto
    MsgLabel.Font                 = self.Estilos.fuente
    MsgLabel.TextWrapped          = true
    MsgLabel.TextXAlignment       = Enum.TextXAlignment.Left
    MsgLabel.TextYAlignment       = Enum.TextYAlignment.Top
    MsgLabel.BorderSizePixel      = 0
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.TextTransparency     = 1
    MsgLabel.Parent               = MsgFrame

    local MC = Instance.new("UICorner")
    MC.CornerRadius = UDim.new(0, 10)
    MC.Parent = MsgLabel

    local MP = Instance.new("UIPadding")
    MP.PaddingTop    = UDim.new(0, 10)
    MP.PaddingBottom = UDim.new(0, 10)
    MP.PaddingLeft   = UDim.new(0, 12)
    MP.PaddingRight  = UDim.new(0, 12)
    MP.Parent        = MsgLabel

    TweenService:Create(MsgLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        TextTransparency       = 0
    }):Play()

    task.wait(0.05)
    chatArea.CanvasPosition = Vector2.new(0, chatArea.AbsoluteCanvasSize.Y)

    return MsgLabel
end

-- ============================================================
-- CREAR BOTON
-- ============================================================

function UI:crearBoton(config)
    config = config or {}

    local Boton = Instance.new("TextButton")
    Boton.Size             = config.tamano   or UDim2.new(0, 100, 0, 35)
    Boton.Position         = config.posicion or UDim2.new(0, 0, 0, 0)
    Boton.BackgroundColor3 = config.color    or self.Colores.primario
    Boton.Text             = config.texto    or "Boton"
    Boton.TextColor3       = config.textoColor or Color3.fromRGB(255, 255, 255)
    Boton.TextSize         = config.textoTamano or 14
    Boton.Font             = self.Estilos.fuenteBold
    Boton.BorderSizePixel  = 0
    Boton.AutoButtonColor  = false
    Boton.Parent           = config.parent

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(config.redondeo or 1, 0)
    BC.Parent = Boton

    local colorBase = config.color or self.Colores.primario

    Boton.MouseEnter:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.2), {
            BackgroundColor3 = self:_ajustarBrillo(colorBase, 1.2)
        }):Play()
    end)

    Boton.MouseLeave:Connect(function()
        TweenService:Create(Boton, TweenInfo.new(0.2), {
            BackgroundColor3 = colorBase
        }):Play()
    end)

    if config.callback then
        Boton.MouseButton1Click:Connect(config.callback)
    end

    return Boton
end

-- ============================================================
-- NOTIFICACION
-- ============================================================

function UI:mostrarNotificacion(config)
    config = config or {}
    local texto   = config.texto   or "Notificacion"
    local tipo    = config.tipo    or "info"
    local duracion = config.duracion or 3

    local color
    if     tipo == "exito"      then color = self.Colores.exito
    elseif tipo == "error"      then color = self.Colores.error
    elseif tipo == "advertencia" then color = self.Colores.advertencia
    else                             color = self.Colores.info
    end

    local sg = game:GetService("CoreGui"):FindFirstChild("RobloxAIConstructor")
    if not sg then return end

    local Notif = Instance.new("Frame")
    Notif.Size             = UDim2.new(0, 300, 0, 0)
    Notif.Position         = UDim2.new(1, -320, 0, 20)
    Notif.BackgroundColor3 = color
    Notif.BorderSizePixel  = 0
    Notif.Parent           = sg

    local NC = Instance.new("UICorner")
    NC.CornerRadius = UDim.new(0, 10)
    NC.Parent = Notif

    local NT = Instance.new("TextLabel")
    NT.Size                 = UDim2.new(1, -20, 1, -20)
    NT.Position             = UDim2.new(0, 10, 0, 10)
    NT.BackgroundTransparency = 1
    NT.Text                 = texto
    NT.TextColor3           = Color3.fromRGB(255, 255, 255)
    NT.TextSize             = 13
    NT.Font                 = self.Estilos.fuente
    NT.TextWrapped          = true
    NT.TextXAlignment       = Enum.TextXAlignment.Left
    NT.Parent               = Notif

    TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 60)
    }):Play()

    task.delay(duracion, function()
        TweenService:Create(Notif, TweenInfo.new(0.3), {
            Position             = UDim2.new(1, 20, 0, 20),
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(NT, TweenInfo.new(0.3), {
            TextTransparency = 1
        }):Play()
        task.wait(0.3)
        Notif:Destroy()
    end)
end

-- ============================================================
-- ACTUALIZAR ESTADO
-- ============================================================

function UI:actualizarEstado(statusComponents, estado, mensaje)
    local colores = {
        listo    = self.Colores.exito,
        pensando = self.Colores.advertencia,
        error    = self.Colores.error,
        exito    = self.Colores.exito,
    }

    local color = colores[estado] or self.Colores.info
    statusComponents.StatusDot.BackgroundColor3 = color
    statusComponents.StatusText.Text            = mensaje or estado

    if estado == "pensando" then
        TweenService:Create(
            statusComponents.StatusDot,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true),
            { Size = UDim2.new(0, 12, 0, 12) }
        ):Play()
    else
        statusComponents.StatusDot.Size = UDim2.new(0, 8, 0, 8)
    end
end

-- ============================================================
-- AUXILIARES
-- ============================================================

function UI:_toggleMinimizar(ventana)
    local minimizado = ventana:GetAttribute("Minimizado") or false
    local ti = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if minimizado then
        TweenService:Create(ventana, ti, {
            Size = UDim2.new(0, ventana:GetAttribute("AnchoOrig"), 0, ventana:GetAttribute("AltoOrig"))
        }):Play()
        ventana:SetAttribute("Minimizado", false)
    else
        ventana:SetAttribute("AnchoOrig", ventana.Size.X.Offset)
        ventana:SetAttribute("AltoOrig",  ventana.Size.Y.Offset)
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
            Size                 = UDim2.new(0, main.Size.X.Offset, 0, 0),
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

return UI
