-- =============================================
-- ANIM GUI v25.2 — GUI Premium Redesign + Keybinds Toggles + Neon Effects
-- Created by Rasyne
-- LocalScript → StarterPlayerScripts
-- =============================================
local PlayerService    = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")

local player = PlayerService.LocalPlayer
if not player then player = PlayerService.PlayerAdded:Wait() end
player:WaitForChild("PlayerGui")

-- =============================================
-- PALETTE v25.2 — Couleurs ultra riches avec effets néon
-- =============================================
local C = {
    -- Fonds
    BG_DARK       = Color3.fromRGB(8, 8, 16),
    BG_MID        = Color3.fromRGB(18, 18, 30),
    BG_ROW        = Color3.fromRGB(28, 26, 44),
    BG_ROW_ALT    = Color3.fromRGB(24, 22, 38),
    BG_ROW_HOVER  = Color3.fromRGB(38, 34, 62),
    -- Accents
    ACCENT        = Color3.fromRGB(145, 90, 255),
    ACCENT_LIGHT  = Color3.fromRGB(180, 140, 255),
    ACCENT2       = Color3.fromRGB(70, 200, 255),
    ACCENT2_LIGHT = Color3.fromRGB(120, 230, 255),
    GRADIENT_L    = Color3.fromRGB(120, 70, 220),
    GRADIENT_R    = Color3.fromRGB(60, 180, 240),
    GRADIENT_L2   = Color3.fromRGB(160, 110, 255),
    GRADIENT_R2   = Color3.fromRGB(80, 200, 255),
    GRADIENT_L3   = Color3.fromRGB(200, 100, 255),
    GRADIENT_R3   = Color3.fromRGB(100, 220, 255),
    -- Sémantiques
    GREEN         = Color3.fromRGB(40, 230, 120),
    GREEN_DIM     = Color3.fromRGB(25, 140, 75),
    RED           = Color3.fromRGB(255, 75, 75),
    RED_DIM       = Color3.fromRGB(150, 40, 40),
    YELLOW        = Color3.fromRGB(255, 220, 60),
    ORANGE        = Color3.fromRGB(255, 160, 50),
    PURPLE        = Color3.fromRGB(200, 120, 255),
    CYAN          = Color3.fromRGB(80, 220, 255),
    PINK          = Color3.fromRGB(255, 120, 200),
    -- Texte
    TEXT          = Color3.fromRGB(245, 245, 255),
    TEXT_DIM      = Color3.fromRGB(130, 130, 155),
    TEXT_DARK     = Color3.fromRGB(70, 70, 90),
    TEXT_MUTED    = Color3.fromRGB(95, 95, 115),
    -- Composants
    BTN_EMOTE     = Color3.fromRGB(45, 40, 70),
    BTN_EMOTE_G1  = Color3.fromRGB(60, 50, 90),
    BTN_EMOTE_G2  = Color3.fromRGB(32, 28, 55),
    BTN_HOVER     = Color3.fromRGB(65, 55, 105),
    BORDER        = Color3.fromRGB(65, 55, 115),
    BORDER_DIM    = Color3.fromRGB(45, 40, 75),
    STATUS_BG     = Color3.fromRGB(14, 14, 24),
    SHADOW        = Color3.fromRGB(0, 0, 0),
    GLASS         = Color3.fromRGB(18, 18, 32),
    SEARCH_BG     = Color3.fromRGB(22, 21, 36),
    INPUT_BG      = Color3.fromRGB(14, 14, 26),
    TOGGLE_OFF    = Color3.fromRGB(65, 45, 45),
    TOGGLE_ON     = Color3.fromRGB(40, 85, 55),
    DIVIDER       = Color3.fromRGB(50, 45, 80),
    GLOW_ACCENT   = Color3.fromRGB(145, 90, 255),
    GLOW_GREEN    = Color3.fromRGB(40, 230, 120),
    GLOW_RED      = Color3.fromRGB(255, 75, 75),
    GLOW_CYAN     = Color3.fromRGB(80, 220, 255),
}

-- =============================================
-- HELPERS UI AMÉLIORÉS
-- =============================================
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke"); s.Color = col or C.BORDER; s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end

local function tween(obj, props, t, style)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function tweenBounce(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props):Play()
end

local function padding(p, top, right, bottom, left)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, top    or 0)
    pad.PaddingRight  = UDim.new(0, right  or top or 0)
    pad.PaddingBottom = UDim.new(0, bottom or top or 0)
    pad.PaddingLeft   = UDim.new(0, left   or right or top or 0)
    pad.Parent = p; return pad
end

local function addGradient(parent, left, right, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(left, right)
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

local function addGlow(parent, color, size, transparency)
    local glow = Instance.new("Frame")
    glow.Parent = parent
    glow.BackgroundColor3 = color or C.GLOW_ACCENT
    glow.BackgroundTransparency = transparency or 0.8
    glow.Size = UDim2.new(1, size or 10, 1, size or 10)
    glow.Position = UDim2.new(0, -(size or 10)/2, 0, -(size or 10)/2)
    glow.ZIndex = parent.ZIndex - 1
    corner(glow, corner and parent:FindFirstChild("UICorner") and parent.UICorner.CornerRadius or 8)
    return glow
end

local function makeLabel(parent, text, size, pos, font, align, color, zindex)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.Size = size or UDim2.new(1,0,1,0)
    lbl.Position = pos or UDim2.new(0,0,0,0)
    lbl.Text = text or ""
    lbl.TextColor3 = color or C.TEXT
    lbl.TextScaled = true
    lbl.Font = font or Enum.Font.Gotham
    lbl.TextXAlignment = align or Enum.TextXAlignment.Left
    if zindex then lbl.ZIndex = zindex end
    return lbl
end

local function makeBtn(parent, text, bgColor, zindex)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = bgColor or C.BG_ROW
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = text or ""
    btn.TextColor3 = C.TEXT
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    if zindex then btn.ZIndex = zindex end
    corner(btn, 8)
    stroke(btn, C.BORDER_DIM, 1)

    local defaultBg = bgColor or C.BG_ROW
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = C.BTN_HOVER}, 0.15)
        tweenBounce(btn, {Size = UDim2.new(1, 2, 1, 2)}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = defaultBg}, 0.15)
        tween(btn, {Size = UDim2.new(1, 0, 1, 0)}, 0.15)
    end)
    return btn
end

local function makeDivider(parent, order)
    local div = Instance.new("Frame")
    div.Parent = parent
    div.BackgroundColor3 = C.DIVIDER
    div.BackgroundTransparency = 0.5
    div.Size = UDim2.new(1, -12, 0, 1)
    div.BorderSizePixel = 0
    div.LayoutOrder = order or 0
    return div
end

local function makeToggleRow(parent, labelText, order, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Parent = parent
    row.BackgroundColor3 = C.BG_ROW
    row.Size = UDim2.new(1, -4, 0, 26)
    row.LayoutOrder = order
    corner(row, 5)

    local lbl = makeLabel(row, labelText,
        UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 8, 0, 0),
        Enum.Font.GothamSemibold, Enum.TextXAlignment.Left, C.TEXT, 7)

    local track = Instance.new("TextButton")
    track.Parent = row
    track.BackgroundColor3 = defaultValue and C.TOGGLE_ON or C.TOGGLE_OFF
    track.Size = UDim2.new(0, 32, 0, 16)
    track.Position = UDim2.new(1, -38, 0.5, -8)
    track.Text = ""
    track.AutoButtonColor = false
    track.ZIndex = 7
    corner(track, 8)

    local knob = Instance.new("Frame")
    knob.Parent = track
    knob.BackgroundColor3 = defaultValue and C.GREEN or C.RED
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, defaultValue and 18 or 2, 0.5, -6)
    knob.ZIndex = 8
    corner(knob, 6)

    local active = defaultValue
    local function setVisual(val)
        if val then
            tween(track, {BackgroundColor3 = C.TOGGLE_ON}, 0.25)
            tween(knob, {Position = UDim2.new(0, 18, 0.5, -6), BackgroundColor3 = C.GREEN}, 0.25)
            tween(lbl, {TextColor3 = C.GREEN}, 0.25)
        else
            tween(track, {BackgroundColor3 = C.TOGGLE_OFF}, 0.25)
            tween(knob, {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = C.RED}, 0.25)
            tween(lbl, {TextColor3 = C.TEXT}, 0.25)
        end
    end
    setVisual(active)

    track.MouseButton1Click:Connect(function()
        active = not active
        setVisual(active)
        callback(active)
    end)

    return {Row = row, Set = setVisual, GetValue = function() return active end}
end

-- =============================================
-- DONNÉES ÉMOTES
-- =============================================
local emoteData = {
    {Name = "Grattement",               ID = "93910188107955",  Icon = "🐾"},
    {Name = "S'asseoir",                ID = "110757655806288", Icon = "🪑"},
    {Name = "Penché en avant",          ID = "123771165433588", Icon = "🙇"},
    {Name = "Joueur",                   ID = "80706795731202",  Icon = "🎮"},
    {Name = "Se détourner",             ID = "107643451592152", Icon = "↩️"},
    {Name = "Léchage main",             ID = "86345507952689",  Icon = "👋"},
    {Name = "Léchage patte",            ID = "85310727452727",  Icon = "🐾"},
    {Name = "Fixer du regard",          ID = "127703766312900", Icon = "👀"},
    {Name = "Roulade sociale",          ID = "86604363197749",  Icon = "🔄"},
    {Name = "S'allonger",               ID = "119370572836578", Icon = "🛏️"},
    {Name = "Allongé pattes en l'air",  ID = "91142240425542",  Icon = "🐕"},
    {Name = "Allongé pattes en l'air 2",ID = "123786470044230", Icon = "🐕"},
    {Name = "Reculer",                  ID = "108150470459728", Icon = "⬅️"},
    {Name = "Pose photo",               ID = "72185261708093",  Icon = "📸"},
    {Name = "Assis en V",               ID = "81180825463784",  Icon = "✌️"},
    {Name = "Pose assis curieux",       ID = "76261461321661",  Icon = "🤔"},
    {Name = "Sieste",                   ID = "105016815489641", Icon = "💤"},
    {Name = "Supplier",                 ID = "77895377417984",  Icon = "🙏"},
    {Name = "Timide",                   ID = "99425439298305",  Icon = "😳"},
    {Name = "Vérification",             ID = "73644021399239",  Icon = "🔍"},
    {Name = "Contempler",               ID = "129641195700400", Icon = "🌅"},
    {Name = "Toilette",                 ID = "117809429848082", Icon = "🧹"},
    {Name = "Battement de pieds",       ID = "103155280474275", Icon = "🦶"},
    {Name = "Pose de chat",             ID = "79458008243992",  Icon = "🐱"},
    {Name = "Feindre blessure",         ID = "103426546772784", Icon = "🤕"},
    {Name = "Émotion de chat en rotation", ID = "80965874589536", Icon = "🌀"},
    {Name = "Chat fou",                 ID = "77756238359953",  Icon = "😸"},
    {Name = "Chat en colère",           ID = "117831060131499", Icon = "😾"},
    {Name = "Mème de la dance du chat !",  ID = "135006750147835", Icon = "💃"},
    {Name = "Chat qui mange",           ID = "82650904590765",  Icon = "🍽️"},
}

-- =============================================
-- ÉTAT GLOBAL
-- =============================================
local emoteKeybinds      = {}
local settingsBtns       = {}
local listeningForKey    = nil
local isCustomAnimActive = false
local charConnections    = {}
local idleSequenceTask   = nil
local isIdle             = false
local isManualEmotePlaying = false
local currentMovementState = "Stopped"
local originalC0s        = {}
local customRunTrack, customWalkTrack, idleTrack1, idleTrack2
local loadedManualEmotes = {}

local customRunId   = "108985707207747"
local customWalkId  = "84792004932424"
local customIdle1Id = "73644021399239"
local customIdle2Id = "133544319055112"

local walkWithEmote      = false
local toggleEmotes       = false
local stopKeybind        = nil
local walkToggle         = nil
local modeToggle         = nil
local stopKeyBtn         = nil
local updateStopKeyBtn   = nil

-- NOUVEAUX: Keybinds pour les toggles
local walkWithEmoteKeybind = nil
local toggleEmotesKeybind = nil
local walkKeybindBtn = nil
local toggleKeybindBtn = nil
local updateWalkKeybindBtn = nil
local updateToggleKeybindBtn = nil

-- =============================================
-- EXPORT / IMPORT JSON
-- =============================================
local function exportData()
    local tbl = {
        keybinds = {},
        isActive = isCustomAnimActive,
        walkWithEmote = walkWithEmote,
        toggleEmotes = toggleEmotes,
        stopKeybind = stopKeybind,
        walkWithEmoteKeybind = walkWithEmoteKeybind,
        toggleEmotesKeybind = toggleEmotesKeybind
    }
    for k, v in pairs(emoteKeybinds) do tbl.keybinds[k] = v end
    local ok, json = pcall(function() return HttpService:JSONEncode(tbl) end)
    if ok then return json else return nil end
end

local function importData(json)
    local ok, tbl = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(tbl) ~= "table" then return false end
    if type(tbl.keybinds) == "table" then
        emoteKeybinds = tbl.keybinds
    end
    if tbl.walkWithEmote ~= nil then
        walkWithEmote = tbl.walkWithEmote
        if walkToggle then walkToggle.Set(walkWithEmote) end
    end
    if tbl.toggleEmotes ~= nil then
        toggleEmotes = tbl.toggleEmotes
        if modeToggle then modeToggle.Set(toggleEmotes) end
    end
    if tbl.stopKeybind ~= nil then
        stopKeybind = tbl.stopKeybind
        if updateStopKeyBtn then updateStopKeyBtn() end
    end
    if tbl.walkWithEmoteKeybind ~= nil then
        walkWithEmoteKeybind = tbl.walkWithEmoteKeybind
        if updateWalkKeybindBtn then updateWalkKeybindBtn() end
    end
    if tbl.toggleEmotesKeybind ~= nil then
        toggleEmotesKeybind = tbl.toggleEmotesKeybind
        if updateToggleKeybindBtn then updateToggleKeybindBtn() end
    end
    return tbl
end

-- =============================================
-- REMOTE DATASTORE
-- =============================================
local SAVE_KEY = "AnimGUI_v25_2_" .. tostring(player.UserId)

local function getRemote()
    return game.ReplicatedStorage:FindFirstChild("AnimGUISave")
end

local function saveToServer()
    local remote = getRemote(); if not remote then return end
    pcall(function()
        remote:InvokeServer({
            action = "save",
            key = SAVE_KEY,
            data = {
                keybinds = emoteKeybinds,
                isActive = isCustomAnimActive,
                walkWithEmote = walkWithEmote,
                toggleEmotes = toggleEmotes,
                stopKeybind = stopKeybind,
                walkWithEmoteKeybind = walkWithEmoteKeybind,
                toggleEmotesKeybind = toggleEmotesKeybind
            }
        })
    end)
end

local function loadFromServer()
    local remote = getRemote(); if not remote then return nil end
    local ok, result = pcall(function()
        return remote:InvokeServer({ action="load", key=SAVE_KEY })
    end)
    if ok and type(result) == "table" then return result end
    return nil
end

-- =============================================
-- SCREENGUI
-- =============================================
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false
gui.Name = "AnimGUI_v25_2"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =============================================
-- FENÊTRE PRINCIPALE — Container avec ombre
-- =============================================
local WIN_W = 220

local windowContainer = Instance.new("Frame")
windowContainer.Parent = gui
windowContainer.BackgroundTransparency = 1
windowContainer.Size = UDim2.new(0, WIN_W + 30, 0, 0)
windowContainer.AutomaticSize = Enum.AutomaticSize.Y
windowContainer.Position = UDim2.new(0.5, -(WIN_W + 30)/2, 0.5, -140)
windowContainer.Active = true
windowContainer.Draggable = true

-- Barre de titre (gradient amélioré)
local titleBar = Instance.new("Frame")
titleBar.Parent = windowContainer
titleBar.BackgroundColor3 = C.ACCENT
titleBar.Size = UDim2.new(0, WIN_W, 0, 30)
titleBar.Position = UDim2.new(0, 15, 0, 6)
titleBar.ZIndex = 3
corner(titleBar, 10)
addGradient(titleBar, C.GRADIENT_L2, C.GRADIENT_R2, 0)

-- Ombre du titre avec glow
local titleShadow = Instance.new("Frame")
titleShadow.Parent = windowContainer
titleShadow.BackgroundColor3 = C.ACCENT
titleShadow.BackgroundTransparency = 0.75
titleShadow.Size = UDim2.new(0, WIN_W - 20, 0, 30)
titleShadow.Position = UDim2.new(0, 25, 0, 11)
titleShadow.ZIndex = 1
corner(titleShadow, 10)
addGradient(titleShadow, C.GRADIENT_L2, C.GRADIENT_R2, 0)

-- Glow effect autour du titre
local titleGlow = Instance.new("Frame")
titleGlow.Parent = windowContainer
titleGlow.BackgroundColor3 = C.ACCENT
titleGlow.BackgroundTransparency = 0.85
titleGlow.Size = UDim2.new(0, WIN_W + 20, 0, 40)
titleGlow.Position = UDim2.new(0, 5, 0, 1)
titleGlow.ZIndex = 0
corner(titleGlow, 15)

-- Icône patte animée avec effet néon
local pawIcon = makeLabel(titleBar, "🐾", UDim2.new(0,20,0,20), UDim2.new(0,8,0.5,-10),
    Enum.Font.GothamBold, Enum.TextXAlignment.Center, C.TEXT, 4)
-- Animation de rotation subtile avec bounce et scale
task.spawn(function()
    while gui.Parent do
        tween(pawIcon, {Rotation = 15, Size = UDim2.new(0,22,0,22)}, 1.0, Enum.EasingStyle.Sine)
        task.wait(1.0)
        tween(pawIcon, {Rotation = -15, Size = UDim2.new(0,20,0,20)}, 1.0, Enum.EasingStyle.Sine)
        task.wait(1.0)
    end
end)

local titleLbl = makeLabel(titleBar, "Anim GUI",
    UDim2.new(0, 80, 1, 0), UDim2.new(0, 30, 0, 0),
    Enum.Font.GothamBold, Enum.TextXAlignment.Left, C.TEXT, 4)

local versionLbl = makeLabel(titleBar, "v25.2",
    UDim2.new(0, 30, 0, 14), UDim2.new(0, 108, 0.5, -7),
    Enum.Font.Gotham, Enum.TextXAlignment.Left, C.ACCENT_LIGHT, 4)
versionLbl.TextTransparency = 0.3

-- Dot de statut dans le titre avec glow amélioré
local titleDot = Instance.new("Frame")
titleDot.Parent = titleBar
titleDot.BackgroundColor3 = C.ACCENT2_LIGHT
titleDot.Size = UDim2.new(0,8,0,8)
titleDot.Position = UDim2.new(1,-20,0.5,-4)
titleDot.ZIndex = 4
corner(titleDot, 4)

local titleDotGlow = Instance.new("Frame")
titleDotGlow.Parent = titleBar
titleDotGlow.BackgroundColor3 = C.ACCENT2_LIGHT
titleDotGlow.BackgroundTransparency = 0.5
titleDotGlow.Size = UDim2.new(0,20,0,20)
titleDotGlow.Position = UDim2.new(1,-26,0.5,-10)
titleDotGlow.ZIndex = 3
corner(titleDotGlow, 10)

-- Pulse du dot titre amélioré avec effet néon
task.spawn(function()
    while gui.Parent do
        tween(titleDotGlow, {BackgroundTransparency = 0.92, Size = UDim2.new(0,30,0,30), Position = UDim2.new(1,-31,0.5,-15)}, 1.0, Enum.EasingStyle.Sine)
        task.wait(1.0)
        tween(titleDotGlow, {BackgroundTransparency = 0.5, Size = UDim2.new(0,20,0,20), Position = UDim2.new(1,-26,0.5,-10)}, 1.0, Enum.EasingStyle.Sine)
        task.wait(1.0)
    end
end)

-- =============================================
-- FENÊTRE BODY
-- =============================================
local frame = Instance.new("Frame")
frame.Parent = windowContainer
frame.BackgroundColor3 = C.BG_DARK
frame.Size = UDim2.new(0, WIN_W, 0, 0)
frame.Position = UDim2.new(0, 15, 0, 34)
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.ZIndex = 2
corner(frame, 10)
stroke(frame, C.BORDER_DIM, 1)

-- Ligne d'accent en haut du body avec gradient
local accentLine = Instance.new("Frame")
accentLine.Parent = frame
accentLine.BackgroundColor3 = C.ACCENT
accentLine.Size = UDim2.new(1, -16, 0, 2)
accentLine.Position = UDim2.new(0, 8, 0, 0)
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 3
corner(accentLine, 1)
addGradient(accentLine, C.GRADIENT_L2, C.GRADIENT_R2, 0)

-- Layout
local mainLayout = Instance.new("UIListLayout")
mainLayout.Parent = frame
mainLayout.Padding = UDim.new(0, 4)
mainLayout.FillDirection = Enum.FillDirection.Vertical
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
padding(frame, 6, 8, 8, 8)

-- =============================================
-- BARRE STATUS — avec pulse amélioré
-- =============================================
local statusBar = Instance.new("Frame")
statusBar.Parent = frame
statusBar.BackgroundColor3 = C.STATUS_BG
statusBar.Size = UDim2.new(1, 0, 0, 24)
statusBar.LayoutOrder = 1
statusBar.ZIndex = 3
corner(statusBar, 6)
stroke(statusBar, C.BORDER_DIM, 1)

-- Dot de statut
local statusDot = Instance.new("Frame")
statusDot.Parent = statusBar
statusDot.BackgroundColor3 = C.RED
statusDot.Size = UDim2.new(0,10,0,10)
statusDot.Position = UDim2.new(0,12,0.5,-5)
statusDot.ZIndex = 4
corner(statusDot, 5)

-- Glow du dot amélioré
local statusGlow = Instance.new("Frame")
statusGlow.Parent = statusBar
statusGlow.BackgroundColor3 = C.RED
statusGlow.BackgroundTransparency = 0.6
statusGlow.Size = UDim2.new(0,22,0,22)
statusGlow.Position = UDim2.new(0,6,0.5,-11)
statusGlow.ZIndex = 3
corner(statusGlow, 11)

-- Pulse animation du statut amélioré avec effet néon
local statusPulseRunning = true
task.spawn(function()
    while gui.Parent do
        if statusPulseRunning then
            tween(statusGlow, {BackgroundTransparency = 0.94, Size = UDim2.new(0,34,0,34), Position = UDim2.new(0,0,0.5,-17)}, 0.8, Enum.EasingStyle.Sine)
            task.wait(0.8)
            tween(statusGlow, {BackgroundTransparency = 0.6, Size = UDim2.new(0,22,0,22), Position = UDim2.new(0,6,0.5,-11)}, 0.8, Enum.EasingStyle.Sine)
            task.wait(0.8)
        else
            task.wait(0.5)
        end
    end
end)

local statusLabel = makeLabel(statusBar, "Hors-ligne",
    UDim2.new(1,-36,1,0), UDim2.new(0,30,0,0),
    Enum.Font.GothamBold, Enum.TextXAlignment.Left, C.RED, 4)

-- =============================================
-- TOGGLE SWITCH — Activer/Désactiver
-- =============================================
local toggleRow = Instance.new("Frame")
toggleRow.Parent = frame
toggleRow.BackgroundColor3 = C.BG_MID
toggleRow.Size = UDim2.new(1, 0, 0, 30)
toggleRow.LayoutOrder = 2
toggleRow.ZIndex = 3
corner(toggleRow, 6)
stroke(toggleRow, C.BORDER_DIM, 1)

local toggleLabel = makeLabel(toggleRow, "Anims custom",
    UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 8, 0, 0),
    Enum.Font.GothamSemibold, Enum.TextXAlignment.Left, C.TEXT, 4)

-- Switch track
local switchTrack = Instance.new("TextButton")
switchTrack.Parent = toggleRow
switchTrack.BackgroundColor3 = C.TOGGLE_OFF
switchTrack.Size = UDim2.new(0, 42, 0, 20)
switchTrack.Position = UDim2.new(1, -52, 0.5, -10)
switchTrack.Text = ""
switchTrack.AutoButtonColor = false
switchTrack.ZIndex = 4
corner(switchTrack, 10)

-- Switch knob
local switchKnob = Instance.new("Frame")
switchKnob.Parent = switchTrack
switchKnob.BackgroundColor3 = C.RED
switchKnob.Size = UDim2.new(0, 16, 0, 16)
switchKnob.Position = UDim2.new(0, 2, 0.5, -8)
switchKnob.ZIndex = 5
corner(switchKnob, 8)

-- Knob glow
local knobGlow = Instance.new("Frame")
knobGlow.Parent = switchKnob
knobGlow.BackgroundColor3 = C.RED
knobGlow.BackgroundTransparency = 0.5
knobGlow.Size = UDim2.new(1, 8, 1, 8)
knobGlow.Position = UDim2.new(0, -4, 0, -4)
knobGlow.ZIndex = 4
corner(knobGlow, 14)

local function updateToggleVisual(active)
    if active then
        tween(switchTrack, {BackgroundColor3 = C.TOGGLE_ON}, 0.3)
        tween(switchKnob, {Position = UDim2.new(0, 24, 0.5, -8), BackgroundColor3 = C.GREEN}, 0.3, Enum.EasingStyle.Back)
        tween(knobGlow, {BackgroundColor3 = C.GREEN}, 0.3)
        tween(toggleLabel, {TextColor3 = C.GREEN}, 0.3)
    else
        tween(switchTrack, {BackgroundColor3 = C.TOGGLE_OFF}, 0.3)
        tween(switchKnob, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = C.RED}, 0.3, Enum.EasingStyle.Back)
        tween(knobGlow, {BackgroundColor3 = C.RED}, 0.3)
        tween(toggleLabel, {TextColor3 = C.TEXT}, 0.3)
    end
end

-- =============================================
-- DIVIDER 1
-- =============================================
makeDivider(frame, 3)

-- =============================================
-- SECTION ACTIONS — Émotes / Réglages
-- =============================================
local actRow = Instance.new("Frame")
actRow.Parent = frame
actRow.BackgroundTransparency = 1
actRow.Size = UDim2.new(1, 0, 0, 28)
actRow.LayoutOrder = 4
actRow.ZIndex = 3

local actLayout = Instance.new("UIListLayout")
actLayout.Parent = actRow
actLayout.FillDirection = Enum.FillDirection.Horizontal
actLayout.Padding = UDim.new(0, 8)
actLayout.SortOrder = Enum.SortOrder.LayoutOrder

local emoteWrap = Instance.new("Frame")
emoteWrap.Parent = actRow; emoteWrap.BackgroundTransparency = 1
emoteWrap.Size = UDim2.new(0.5, -4, 1, 0); emoteWrap.LayoutOrder = 1; emoteWrap.ZIndex = 3
local emoteToggleButton = makeBtn(emoteWrap, "🎭 Émotes", C.BTN_EMOTE, 4)

local settingsWrap = Instance.new("Frame")
settingsWrap.Parent = actRow; settingsWrap.BackgroundTransparency = 1
settingsWrap.Size = UDim2.new(0.5, -4, 1, 0); settingsWrap.LayoutOrder = 2; settingsWrap.ZIndex = 3
local settingsButton = makeBtn(settingsWrap, "⚙ Réglages", Color3.fromRGB(32, 32, 55), 4)

-- =============================================
-- SECTION EXPORT / IMPORT
-- =============================================
local eiRow = Instance.new("Frame")
eiRow.Parent = frame
eiRow.BackgroundTransparency = 1
eiRow.Size = UDim2.new(1, 0, 0, 28)
eiRow.LayoutOrder = 5
eiRow.ZIndex = 3

local eiLayout = Instance.new("UIListLayout")
eiLayout.Parent = eiRow
eiLayout.FillDirection = Enum.FillDirection.Horizontal
eiLayout.Padding = UDim.new(0, 8)
eiLayout.SortOrder = Enum.SortOrder.LayoutOrder

local exportWrap = Instance.new("Frame")
exportWrap.Parent = eiRow; exportWrap.BackgroundTransparency = 1
exportWrap.Size = UDim2.new(0.5, -4, 1, 0); exportWrap.LayoutOrder = 1; exportWrap.ZIndex = 3
local exportBtn = makeBtn(exportWrap, "📤 Exporter", Color3.fromRGB(28, 50, 80), 4)

local importWrap = Instance.new("Frame")
importWrap.Parent = eiRow; importWrap.BackgroundTransparency = 1
importWrap.Size = UDim2.new(0.5, -4, 1, 0); importWrap.LayoutOrder = 2; importWrap.ZIndex = 3
local importBtn = makeBtn(importWrap, "📥 Importer", Color3.fromRGB(55, 40, 18), 4)

-- =============================================
-- ZONE TEXTE EXPORT/IMPORT
-- =============================================
local codeBox = Instance.new("Frame")
codeBox.Parent = frame
codeBox.BackgroundColor3 = C.BG_MID
codeBox.Size = UDim2.new(1, 0, 0, 68)
codeBox.Visible = false
codeBox.LayoutOrder = 6
codeBox.ZIndex = 3
corner(codeBox, 8)
stroke(codeBox, C.ACCENT, 1)

local codeBoxLabel = makeLabel(codeBox, "💡 Copie ce texte pour exporter",
    UDim2.new(1,-10,0,16), UDim2.new(0,6,0,4),
    Enum.Font.Gotham, Enum.TextXAlignment.Left, C.ACCENT2_LIGHT, 4)

local codeInput = Instance.new("TextBox")
codeInput.Parent = codeBox
codeInput.BackgroundColor3 = C.INPUT_BG
codeInput.Size = UDim2.new(1,-12,0,36)
codeInput.Position = UDim2.new(0,6,0,24)
codeInput.Text = ""
codeInput.TextColor3 = C.ACCENT2_LIGHT
codeInput.TextScaled = false
codeInput.TextSize = 11
codeInput.Font = Enum.Font.Code
codeInput.ClearTextOnFocus = false
codeInput.MultiLine = false
codeInput.TextXAlignment = Enum.TextXAlignment.Left
codeInput.ZIndex = 4
corner(codeInput, 6)
stroke(codeInput, C.BORDER, 1)
padding(codeInput, 6, 8, 6, 8)

-- =============================================
-- INDICATEUR SAUVEGARDE
-- =============================================
local saveInd = makeLabel(frame, "", UDim2.new(1,0,0,12),
    UDim2.new(0,0,0,0), Enum.Font.GothamSemibold,
    Enum.TextXAlignment.Right, C.TEXT_DIM, 4)
saveInd.LayoutOrder = 7

local saveTask = nil
local function showStatus(msg, color)
    saveInd.Text = msg; saveInd.TextColor3 = color or C.TEXT_DIM
    saveInd.TextTransparency = 0
    tween(saveInd, {TextTransparency = 0}, 0.1)
    if saveTask then task.cancel(saveTask) end
    saveTask = task.delay(2.5, function()
        tween(saveInd, {TextTransparency = 1}, 0.5)
        task.wait(0.5)
        saveInd.Text = ""
        saveInd.TextTransparency = 0
    end)
end

-- =============================================
-- DIVIDER 2
-- =============================================
local div2 = makeDivider(frame, 8)

-- =============================================
-- BOUTON FERMER
-- =============================================
local closeWrap = Instance.new("Frame")
closeWrap.Parent = frame; closeWrap.BackgroundTransparency = 1
closeWrap.Size = UDim2.new(1, 0, 0, 24); closeWrap.LayoutOrder = 9; closeWrap.ZIndex = 3
local destroyButton = makeBtn(closeWrap, "✕ Fermer", Color3.fromRGB(50, 22, 22), 4)

-- =============================================
-- CREDIT
-- =============================================
local creditLbl = makeLabel(frame, "v25.2 • Created by Rasyne ✨",
    UDim2.new(1, 0, 0, 10), UDim2.new(0,0,0,0),
    Enum.Font.Gotham, Enum.TextXAlignment.Center, C.ACCENT_LIGHT, 3)
creditLbl.LayoutOrder = 10
creditLbl.TextTransparency = 0.4

-- Animation subtile du credit
task.spawn(function()
    while gui.Parent do
        tween(creditLbl, {TextTransparency = 0.6}, 2, Enum.EasingStyle.Sine)
        task.wait(2)
        tween(creditLbl, {TextTransparency = 0.3}, 2, Enum.EasingStyle.Sine)
        task.wait(2)
    end
end)

-- =============================================
-- PANNEAU ÉMOTES — Latéral gauche avec slide
-- =============================================
local emoteFrame = Instance.new("Frame")
emoteFrame.Parent = windowContainer
emoteFrame.BackgroundColor3 = C.GLASS
emoteFrame.BackgroundTransparency = 0.05
emoteFrame.Size = UDim2.new(0, 170, 0, 260)
emoteFrame.Position = UDim2.new(0, 15 - 178, 0, 34)
emoteFrame.Visible = false
emoteFrame.ZIndex = 3
corner(emoteFrame, 10)
stroke(emoteFrame, C.BORDER, 1)

-- Titre émotes avec gradient
local eTitleBar = Instance.new("Frame")
eTitleBar.Parent = emoteFrame
eTitleBar.BackgroundColor3 = C.ACCENT2
eTitleBar.Size = UDim2.new(1, 0, 0, 26)
eTitleBar.ZIndex = 4
corner(eTitleBar, 10)
addGradient(eTitleBar, C.ACCENT2, C.ACCENT2_LIGHT, 0)

makeLabel(eTitleBar, "🎭  Émotes", UDim2.new(1,-12,1,0), UDim2.new(0,12,0,0),
    Enum.Font.GothamBold, Enum.TextXAlignment.Left, C.BG_DARK, 5)

-- Compteur d'émotes
local emoteCount = makeLabel(eTitleBar, tostring(#emoteData),
    UDim2.new(0, 24, 0, 18), UDim2.new(1, -36, 0.5, -9),
    Enum.Font.GothamBold, Enum.TextXAlignment.Center, C.ACCENT2, 5)
emoteCount.BackgroundColor3 = C.BG_DARK
emoteCount.BackgroundTransparency = 0.2
corner(emoteCount, 9)

-- Barre de recherche
local searchBar = Instance.new("Frame")
searchBar.Parent = emoteFrame
searchBar.BackgroundColor3 = C.SEARCH_BG
searchBar.Size = UDim2.new(1, -10, 0, 22)
searchBar.Position = UDim2.new(0, 5, 0, 30)
searchBar.ZIndex = 4
corner(searchBar, 6)
stroke(searchBar, C.BORDER_DIM, 1)

local searchIcon = makeLabel(searchBar, "🔍", UDim2.new(0,20,1,0), UDim2.new(0,6,0,0),
    Enum.Font.Gotham, Enum.TextXAlignment.Center, C.TEXT_DIM, 5)

local searchInput = Instance.new("TextBox")
searchInput.Parent = searchBar
searchInput.BackgroundTransparency = 1
searchInput.Size = UDim2.new(1, -32, 1, 0)
searchInput.Position = UDim2.new(0, 28, 0, 0)
searchInput.Text = ""
searchInput.PlaceholderText = "Nom ou raccourci..."
searchInput.PlaceholderColor3 = C.TEXT_DARK
searchInput.TextColor3 = C.TEXT
searchInput.TextScaled = true
searchInput.Font = Enum.Font.Gotham
searchInput.TextXAlignment = Enum.TextXAlignment.Left
searchInput.ClearTextOnFocus = false
searchInput.ZIndex = 5

local eScroll = Instance.new("ScrollingFrame")
eScroll.Parent = emoteFrame
eScroll.Size = UDim2.new(1,-6,1,-58)
eScroll.Position = UDim2.new(0,3,0,56)
eScroll.BackgroundTransparency = 1
eScroll.ScrollBarThickness = 3
eScroll.ScrollBarImageColor3 = C.ACCENT2
eScroll.CanvasSize = UDim2.new(0,0,0,#emoteData*30)
eScroll.ZIndex = 4

local eLayout = Instance.new("UIListLayout")
eLayout.Parent = eScroll
eLayout.Padding = UDim.new(0, 2)

-- Emote buttons storage for search filtering
local emoteButtons = {}

-- =============================================
-- PANNEAU RÉGLAGES — Latéral droit avec slide
-- =============================================
local settingsFrame = Instance.new("Frame")
settingsFrame.Parent = windowContainer
settingsFrame.BackgroundColor3 = C.GLASS
settingsFrame.BackgroundTransparency = 0.05
settingsFrame.Size = UDim2.new(0, 280, 0, 360)
settingsFrame.Position = UDim2.new(0, 15 + WIN_W + 8, 0, 34)
settingsFrame.Visible = false
settingsFrame.ZIndex = 5
corner(settingsFrame, 10)
stroke(settingsFrame, C.BORDER, 1)

-- Titre réglages avec gradient
local sTitleBar = Instance.new("Frame")
sTitleBar.Parent = settingsFrame
sTitleBar.BackgroundColor3 = C.ACCENT
sTitleBar.Size = UDim2.new(1, 0, 0, 26)
sTitleBar.ZIndex = 6
corner(sTitleBar, 10)
addGradient(sTitleBar, C.GRADIENT_L2, C.GRADIENT_R2, 0)

makeLabel(sTitleBar, "⚙ Raccourcis",
    UDim2.new(1,-10,1,0), UDim2.new(0,10,0,0),
    Enum.Font.GothamBold, Enum.TextXAlignment.Left, C.TEXT, 7)

-- Info box compacte
local sInfoBox = Instance.new("Frame")
sInfoBox.Parent = settingsFrame
sInfoBox.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
sInfoBox.Size = UDim2.new(1,-10,0,22)
sInfoBox.Position = UDim2.new(0,5,0,30)
sInfoBox.ZIndex = 6
corner(sInfoBox, 5)
stroke(sInfoBox, C.ACCENT, 1)

makeLabel(sInfoBox, "💡 Clic→assigner · Échap→effacer · Droit→suppr",
    UDim2.new(1,-8,1,0), UDim2.new(0,4,0,0),
    Enum.Font.Gotham, Enum.TextXAlignment.Left, C.ACCENT2_LIGHT, 7)

local sScroll = Instance.new("ScrollingFrame")
sScroll.Parent = settingsFrame
sScroll.Size = UDim2.new(1,-10,1,-58)
sScroll.Position = UDim2.new(0,5,0,56)
sScroll.BackgroundTransparency = 1
sScroll.ScrollBarThickness = 3
sScroll.ScrollBarImageColor3 = C.ACCENT
sScroll.ZIndex = 5

local sLayout = Instance.new("UIListLayout")
sLayout.Parent = sScroll
sLayout.Padding = UDim.new(0, 2)

-- =============================================
-- HELPERS ANIM
-- =============================================
local function getTrueAnimId(id)
    local sid = tostring(id):gsub("rbxassetid://","")
    local ok, assets = pcall(function() return game:GetObjects("rbxassetid://"..sid) end)
    if ok and assets then
        for _, a in ipairs(assets) do
            if a:IsA("Animation") then return a.AnimationId end
            local sub = a:FindFirstChildWhichIsA("Animation",true)
            if sub then return sub.AnimationId end
        end
    end
    return "rbxassetid://"..sid
end

local function isSpecialState(state)
    return state == Enum.HumanoidStateType.Climbing
        or state == Enum.HumanoidStateType.Swimming
        or state == Enum.HumanoidStateType.Seated
        or state == Enum.HumanoidStateType.GettingUp
        or state == Enum.HumanoidStateType.FallingDown
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.Flying
        or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Dead
end

local function stopAllManual()
    isManualEmotePlaying = false; isIdle = false
    if idleSequenceTask then task.cancel(idleSequenceTask); idleSequenceTask = nil end
    if idleTrack1 then idleTrack1:Stop(0.2) end
    if idleTrack2 then idleTrack2:Stop(0.2) end
    for _, t in pairs(loadedManualEmotes) do t:Stop(0.2) end
end

local function startIdle()
    if isIdle or not isCustomAnimActive or isManualEmotePlaying then return end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if isSpecialState(char.Humanoid:GetState()) then return end
    end
    isIdle = true
    if idleSequenceTask then task.cancel(idleSequenceTask) end
    idleSequenceTask = task.spawn(function()
        while isIdle and isCustomAnimActive do
            if isManualEmotePlaying then task.wait(0.5); continue end
            if idleTrack1 and not idleTrack1.IsPlaying then idleTrack1:Play(0.3) end
            local wt = (idleTrack1 and idleTrack1.Length > 0) and idleTrack1.Length or 5
            task.wait(wt)
            if not isIdle or isManualEmotePlaying then break end
            if math.random(1,100) <= 20 then
                if idleTrack1 then idleTrack1:Stop(0.3) end
                if idleTrack2 then
                    idleTrack2:Play(0.3); task.wait(5)
                    if not isIdle or isManualEmotePlaying then break end
                    idleTrack2:Stop(0.3)
                end
            end
        end
    end)
end

local function playEmote(name)
    local char = player.Character
    if not char or not isCustomAnimActive then return end
    local hum = char:FindFirstChild("Humanoid"); if not hum then return end
    
    local track = loadedManualEmotes[name]
    if track then
        if toggleEmotes and track.IsPlaying then
            stopAllManual()
            if hum.MoveDirection.Magnitude < 0.1 then isIdle = false; startIdle() end
            return
        end
        
        local canPlay = walkWithEmote or (hum.MoveDirection.Magnitude < 0.1)
        if canPlay and not isSpecialState(hum:GetState()) then
            stopAllManual(); isManualEmotePlaying = true
            track:Play(0.3)
            local conn; conn = track.Stopped:Connect(function()
                isManualEmotePlaying = false
                if hum.MoveDirection.Magnitude < 0.1 then isIdle=false; startIdle() end
                conn:Disconnect()
            end)
        end
    end
end

local function applyAnim(character)
    local hum = character:WaitForChild("Humanoid",5)
    local anim = hum:WaitForChild("Animator",5)
    if not anim then return end
    for _, c in pairs(charConnections) do c:Disconnect() end
    charConnections = {}; currentMovementState = "Stopped"; isIdle = false; originalC0s = {}
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("Motor6D") then originalC0s[d] = d.C0 end
    end
    local function loadAnim(id, prio)
        local a = Instance.new("Animation"); a.AnimationId = getTrueAnimId(id)
        local t = anim:LoadAnimation(a); t.Priority = prio; return t
    end
    customRunTrack  = loadAnim(customRunId,   Enum.AnimationPriority.Action3)
    customWalkTrack = loadAnim(customWalkId,  Enum.AnimationPriority.Action3)
    idleTrack1      = loadAnim(customIdle1Id, Enum.AnimationPriority.Action2)
    idleTrack2      = loadAnim(customIdle2Id, Enum.AnimationPriority.Action2)
    loadedManualEmotes = {}
    for _, data in ipairs(emoteData) do
        loadedManualEmotes[data.Name] = loadAnim(data.ID, Enum.AnimationPriority.Action4)
    end
    table.insert(charConnections, RunService.Heartbeat:Connect(function()
        if not isCustomAnimActive then return end
        local state = hum:GetState()
        local special = isSpecialState(state)
        if not special then
            for motor, c0 in pairs(originalC0s) do
                if motor.Parent and (motor.Name:match("Shoulder") or motor.Name=="Waist" or motor.Name=="Neck") then
                    motor.C0 = c0
                end
            end
        end
        if special then
            if currentMovementState ~= "Special" then
                currentMovementState = "Special"
                if customWalkTrack then customWalkTrack:Stop(0.1) end
                if customRunTrack  then customRunTrack:Stop(0.1) end
                stopAllManual()
            end
            return
        end
        local moving = hum.MoveDirection.Magnitude > 0.05
        if moving then
            local vel = hum.RootPart and hum.RootPart.Velocity or Vector3.new()
            local spd = Vector3.new(vel.X,0,vel.Z).Magnitude
            local animSpd = math.max(spd,2)
            local dir = 1
            if hum.RootPart then
                if hum.MoveDirection:Dot(hum.RootPart.CFrame.LookVector) < -0.1 then dir = -1 end
            end
            if spd <= 10 then
                if currentMovementState ~= "Walking" then
                    currentMovementState = "Walking"
                    if not walkWithEmote then stopAllManual() end
                    if customRunTrack  then customRunTrack:Stop(0.1) end
                    if customWalkTrack then customWalkTrack:Play(0.1) end
                end
                if customWalkTrack then customWalkTrack:AdjustSpeed((animSpd/10)*dir) end
            else
                if currentMovementState ~= "Running" then
                    currentMovementState = "Running"
                    if not walkWithEmote then stopAllManual() end
                    if customWalkTrack then customWalkTrack:Stop(0.1) end
                    if customRunTrack  then customRunTrack:Play(0.1) end
                end
                if customRunTrack then customRunTrack:AdjustSpeed((animSpd/16)*dir) end
            end
        else
            if currentMovementState ~= "Stopped" then
                currentMovementState = "Stopped"
                if customWalkTrack then customWalkTrack:Stop(0.1) end
                if customRunTrack  then customRunTrack:Stop(0.1) end
                isIdle = false
            end
            if not isManualEmotePlaying and not isIdle then startIdle() end
        end
    end))
end

local function restoreAnim(character)
    isCustomAnimActive = false
    for _, c in pairs(charConnections) do c:Disconnect() end
    charConnections = {}; originalC0s = {}
    if customWalkTrack then customWalkTrack:Stop(0.2) end
    if customRunTrack  then customRunTrack:Stop(0.2) end
    stopAllManual()
end

-- =============================================
-- UPDATE BOUTON TOUCHE
-- =============================================
local function updateKeyBtn(emoteName, btn)
    local key = emoteKeybinds[emoteName]
    if key then
        btn.Text = "[ " .. key .. " ]"
        btn.BackgroundColor3 = Color3.fromRGB(30, 60, 35)
        tween(btn, {TextColor3 = C.GREEN})
        -- Show X button if it exists
        local row = btn.Parent
        local xBtn = row:FindFirstChild("TextButton")
        if xBtn and xBtn ~= btn then
            xBtn.Visible = true
        end
    else
        btn.Text = "—"
        btn.BackgroundColor3 = C.BG_ROW
        tween(btn, {TextColor3 = C.TEXT_DARK})
        -- Hide X button if it exists
        local row = btn.Parent
        for _, child in ipairs(row:GetChildren()) do
            if child:IsA("TextButton") and child ~= btn and child.Text == "✕" then
                child.Visible = false
            end
        end
    end
end

local function refreshAllKeyBtns()
    for emoteName, btn in pairs(settingsBtns) do
        updateKeyBtn(emoteName, btn)
        stroke(btn, C.BORDER_DIM, 1)
    end
end

-- =============================================
-- LIGNES DE RÉGLAGES — avec keybinds pour toggles
-- =============================================
sLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 1. Marcher avec Émotes (avec keybind)
local walkRow = Instance.new("Frame")
walkRow.Parent = sScroll
walkRow.BackgroundColor3 = C.BG_ROW
walkRow.Size = UDim2.new(1, -4, 0, 26)
walkRow.LayoutOrder = 1
corner(walkRow, 5)

local walkIcon = makeLabel(walkRow, "🚶",
    UDim2.new(0, 20, 1, 0), UDim2.new(0, 6, 0, 0),
    Enum.Font.Gotham, Enum.TextXAlignment.Center, C.TEXT, 7)

makeLabel(walkRow, "Marcher avec Émote",
    UDim2.new(0.5, -85, 1, 0), UDim2.new(0, 28, 0, 0),
    Enum.Font.GothamSemibold, Enum.TextXAlignment.Left, C.TEXT, 7)

-- Toggle switch pour walk
local walkSwitchTrack = Instance.new("TextButton")
walkSwitchTrack.Parent = walkRow
walkSwitchTrack.BackgroundColor3 = walkWithEmote and C.TOGGLE_ON or C.TOGGLE_OFF
walkSwitchTrack.Size = UDim2.new(0, 28, 0, 14)
walkSwitchTrack.Position = UDim2.new(1, -100, 0.5, -7)
walkSwitchTrack.Text = ""
walkSwitchTrack.AutoButtonColor = false
walkSwitchTrack.ZIndex = 7
corner(walkSwitchTrack, 7)

local walkSwitchKnob = Instance.new("Frame")
walkSwitchKnob.Parent = walkSwitchTrack
walkSwitchKnob.BackgroundColor3 = walkWithEmote and C.GREEN or C.RED
walkSwitchKnob.Size = UDim2.new(0, 10, 0, 10)
walkSwitchKnob.Position = UDim2.new(0, walkWithEmote and 16 or 2, 0.5, -5)
walkSwitchKnob.ZIndex = 8
corner(walkSwitchKnob, 5)

local function updateWalkSwitchVisual(active)
    if active then
        tween(walkSwitchTrack, {BackgroundColor3 = C.TOGGLE_ON}, 0.25)
        tween(walkSwitchKnob, {Position = UDim2.new(0, 16, 0.5, -5), BackgroundColor3 = C.GREEN}, 0.25)
    else
        tween(walkSwitchTrack, {BackgroundColor3 = C.TOGGLE_OFF}, 0.25)
        tween(walkSwitchKnob, {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = C.RED}, 0.25)
    end
end

walkSwitchTrack.MouseButton1Click:Connect(function()
    walkWithEmote = not walkWithEmote
    updateWalkSwitchVisual(walkWithEmote)
    task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
end)

-- Keybind button pour walk
walkKeybindBtn = Instance.new("TextButton")
walkKeybindBtn.Parent = walkRow
walkKeybindBtn.BackgroundColor3 = C.BG_ROW
walkKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
walkKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
walkKeybindBtn.Text = "—"
walkKeybindBtn.TextColor3 = C.TEXT_DARK
walkKeybindBtn.TextScaled = true
walkKeybindBtn.Font = Enum.Font.GothamBold
walkKeybindBtn.AutoButtonColor = false
walkKeybindBtn.ZIndex = 7
corner(walkKeybindBtn, 5)
stroke(walkKeybindBtn, C.BORDER_DIM, 1)

-- X button pour walk keybind
local walkXBtn = Instance.new("TextButton")
walkXBtn.Parent = walkRow
walkXBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
walkXBtn.Size = UDim2.new(0, 16, 0, 16)
walkXBtn.Position = UDim2.new(1, -86, 0.5, -8)
walkXBtn.Text = "✕"
walkXBtn.TextColor3 = C.RED
walkXBtn.TextScaled = true
walkXBtn.Font = Enum.Font.GothamBold
walkXBtn.AutoButtonColor = false
walkXBtn.ZIndex = 8
walkXBtn.Visible = false
corner(walkXBtn, 4)
stroke(walkXBtn, C.RED_DIM, 1)

walkXBtn.MouseEnter:Connect(function()
    tween(walkXBtn, {BackgroundColor3 = Color3.fromRGB(80, 30, 30)}, 0.15)
end)
walkXBtn.MouseLeave:Connect(function()
    tween(walkXBtn, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
end)
walkXBtn.MouseButton1Click:Connect(function()
    walkWithEmoteKeybind = nil
    updateWalkKeybindBtn()
    walkXBtn.Visible = false
    task.spawn(function() saveToServer(); showStatus("❌ Keybind supprimé", C.RED) end)
end)

updateWalkKeybindBtn = function()
    if walkWithEmoteKeybind then
        walkKeybindBtn.Text = "[ " .. walkWithEmoteKeybind .. " ]"
        walkKeybindBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 35)
        tween(walkKeybindBtn, {TextColor3 = C.GREEN})
        walkXBtn.Visible = true
    else
        walkKeybindBtn.Text = "—"
        walkKeybindBtn.BackgroundColor3 = C.BG_ROW
        tween(walkKeybindBtn, {TextColor3 = C.TEXT_DARK})
        walkXBtn.Visible = false
    end
end
updateWalkKeybindBtn()

walkKeybindBtn.MouseEnter:Connect(function()
    if listeningForKey ~= "__WALK_KEY__" then
        tween(walkKeybindBtn, {BackgroundColor3 = C.BTN_HOVER}, 0.12)
    end
end)
walkKeybindBtn.MouseLeave:Connect(function()
    if listeningForKey ~= "__WALK_KEY__" then
        tween(walkKeybindBtn, {BackgroundColor3 = walkWithEmoteKeybind and Color3.fromRGB(30, 60, 35) or C.BG_ROW}, 0.12)
    end
end)
walkKeybindBtn.MouseButton1Click:Connect(function()
    if listeningForKey == "__WALK_KEY__" then
        listeningForKey = nil; updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1); return
    end
    if listeningForKey then
        local old = settingsBtns[listeningForKey]
        if old then updateKeyBtn(listeningForKey, old); stroke(old, C.BORDER_DIM, 1)
        elseif listeningForKey == "__STOP_KEY__" then updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1)
        elseif listeningForKey == "__TOGGLE_KEY__" then updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1) end
    end
    listeningForKey = "__WALK_KEY__"
    walkKeybindBtn.Text = "▶ ..."
    walkKeybindBtn.TextColor3 = C.YELLOW
    walkKeybindBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
    stroke(walkKeybindBtn, C.YELLOW, 1.5)
    tween(walkKeybindBtn, {Size = UDim2.new(0, 78, 0, 22), Position = UDim2.new(1, -86, 0.5, -11)}, 0.2, Enum.EasingStyle.Back)
end)
walkKeybindBtn.MouseButton2Click:Connect(function()
    walkWithEmoteKeybind = nil
    if listeningForKey == "__WALK_KEY__" then listeningForKey = nil end
    updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1)
    walkKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
    walkKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
    task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
end)

-- 2. Mode Bascule (avec keybind)
local toggleRow = Instance.new("Frame")
toggleRow.Parent = sScroll
toggleRow.BackgroundColor3 = C.BG_ROW_ALT
toggleRow.Size = UDim2.new(1, -4, 0, 26)
toggleRow.LayoutOrder = 2
corner(toggleRow, 5)

local toggleIcon = makeLabel(toggleRow, "🔄",
    UDim2.new(0, 20, 1, 0), UDim2.new(0, 6, 0, 0),
    Enum.Font.Gotham, Enum.TextXAlignment.Center, C.TEXT, 7)

makeLabel(toggleRow, "Mode Bascule",
    UDim2.new(0.5, -85, 1, 0), UDim2.new(0, 28, 0, 0),
    Enum.Font.GothamSemibold, Enum.TextXAlignment.Left, C.TEXT, 7)

-- Toggle switch pour mode
local modeSwitchTrack = Instance.new("TextButton")
modeSwitchTrack.Parent = toggleRow
modeSwitchTrack.BackgroundColor3 = toggleEmotes and C.TOGGLE_ON or C.TOGGLE_OFF
modeSwitchTrack.Size = UDim2.new(0, 28, 0, 14)
modeSwitchTrack.Position = UDim2.new(1, -100, 0.5, -7)
modeSwitchTrack.Text = ""
modeSwitchTrack.AutoButtonColor = false
modeSwitchTrack.ZIndex = 7
corner(modeSwitchTrack, 7)

local modeSwitchKnob = Instance.new("Frame")
modeSwitchKnob.Parent = modeSwitchTrack
modeSwitchKnob.BackgroundColor3 = toggleEmotes and C.GREEN or C.RED
modeSwitchKnob.Size = UDim2.new(0, 10, 0, 10)
modeSwitchKnob.Position = UDim2.new(0, toggleEmotes and 16 or 2, 0.5, -5)
modeSwitchKnob.ZIndex = 8
corner(modeSwitchKnob, 5)

local function updateModeSwitchVisual(active)
    if active then
        tween(modeSwitchTrack, {BackgroundColor3 = C.TOGGLE_ON}, 0.25)
        tween(modeSwitchKnob, {Position = UDim2.new(0, 16, 0.5, -5), BackgroundColor3 = C.GREEN}, 0.25)
    else
        tween(modeSwitchTrack, {BackgroundColor3 = C.TOGGLE_OFF}, 0.25)
        tween(modeSwitchKnob, {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = C.RED}, 0.25)
    end
end

modeSwitchTrack.MouseButton1Click:Connect(function()
    toggleEmotes = not toggleEmotes
    updateModeSwitchVisual(toggleEmotes)
    task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
end)

-- Keybind button pour mode
toggleKeybindBtn = Instance.new("TextButton")
toggleKeybindBtn.Parent = toggleRow
toggleKeybindBtn.BackgroundColor3 = C.BG_ROW
toggleKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
toggleKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
toggleKeybindBtn.Text = "—"
toggleKeybindBtn.TextColor3 = C.TEXT_DARK
toggleKeybindBtn.TextScaled = true
toggleKeybindBtn.Font = Enum.Font.GothamBold
toggleKeybindBtn.AutoButtonColor = false
toggleKeybindBtn.ZIndex = 7
corner(toggleKeybindBtn, 5)
stroke(toggleKeybindBtn, C.BORDER_DIM, 1)

-- X button pour toggle keybind
local toggleXBtn = Instance.new("TextButton")
toggleXBtn.Parent = toggleRow
toggleXBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
toggleXBtn.Size = UDim2.new(0, 16, 0, 16)
toggleXBtn.Position = UDim2.new(1, -86, 0.5, -8)
toggleXBtn.Text = "✕"
toggleXBtn.TextColor3 = C.RED
toggleXBtn.TextScaled = true
toggleXBtn.Font = Enum.Font.GothamBold
toggleXBtn.AutoButtonColor = false
toggleXBtn.ZIndex = 8
toggleXBtn.Visible = false
corner(toggleXBtn, 4)
stroke(toggleXBtn, C.RED_DIM, 1)

toggleXBtn.MouseEnter:Connect(function()
    tween(toggleXBtn, {BackgroundColor3 = Color3.fromRGB(80, 30, 30)}, 0.15)
end)
toggleXBtn.MouseLeave:Connect(function()
    tween(toggleXBtn, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
end)
toggleXBtn.MouseButton1Click:Connect(function()
    toggleEmotesKeybind = nil
    updateToggleKeybindBtn()
    toggleXBtn.Visible = false
    task.spawn(function() saveToServer(); showStatus("❌ Keybind supprimé", C.RED) end)
end)

updateToggleKeybindBtn = function()
    if toggleEmotesKeybind then
        toggleKeybindBtn.Text = "[ " .. toggleEmotesKeybind .. " ]"
        toggleKeybindBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 35)
        tween(toggleKeybindBtn, {TextColor3 = C.GREEN})
        toggleXBtn.Visible = true
    else
        toggleKeybindBtn.Text = "—"
        toggleKeybindBtn.BackgroundColor3 = C.BG_ROW
        tween(toggleKeybindBtn, {TextColor3 = C.TEXT_DARK})
        toggleXBtn.Visible = false
    end
end
updateToggleKeybindBtn()

toggleKeybindBtn.MouseEnter:Connect(function()
    if listeningForKey ~= "__TOGGLE_KEY__" then
        tween(toggleKeybindBtn, {BackgroundColor3 = C.BTN_HOVER}, 0.12)
    end
end)
toggleKeybindBtn.MouseLeave:Connect(function()
    if listeningForKey ~= "__TOGGLE_KEY__" then
        tween(toggleKeybindBtn, {BackgroundColor3 = toggleEmotesKeybind and Color3.fromRGB(30, 60, 35) or C.BG_ROW}, 0.12)
    end
end)
toggleKeybindBtn.MouseButton1Click:Connect(function()
    if listeningForKey == "__TOGGLE_KEY__" then
        listeningForKey = nil; updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1); return
    end
    if listeningForKey then
        local old = settingsBtns[listeningForKey]
        if old then updateKeyBtn(listeningForKey, old); stroke(old, C.BORDER_DIM, 1)
        elseif listeningForKey == "__STOP_KEY__" then updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1)
        elseif listeningForKey == "__WALK_KEY__" then updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1) end
    end
    listeningForKey = "__TOGGLE_KEY__"
    toggleKeybindBtn.Text = "▶ ..."
    toggleKeybindBtn.TextColor3 = C.YELLOW
    toggleKeybindBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
    stroke(toggleKeybindBtn, C.YELLOW, 1.5)
    tween(toggleKeybindBtn, {Size = UDim2.new(0, 78, 0, 22), Position = UDim2.new(1, -86, 0.5, -11)}, 0.2, Enum.EasingStyle.Back)
end)
toggleKeybindBtn.MouseButton2Click:Connect(function()
    toggleEmotesKeybind = nil
    if listeningForKey == "__TOGGLE_KEY__" then listeningForKey = nil end
    updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1)
    toggleKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
    toggleKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
    task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
end)

-- 3. Arrêt Émotes
local stopKeyRow = Instance.new("Frame")
stopKeyRow.Parent = sScroll
stopKeyRow.BackgroundColor3 = C.BG_ROW_ALT
stopKeyRow.Size = UDim2.new(1, -4, 0, 26)
stopKeyRow.LayoutOrder = 3
corner(stopKeyRow, 5)

local stopIcon = makeLabel(stopKeyRow, "🛑",
    UDim2.new(0, 20, 1, 0), UDim2.new(0, 6, 0, 0),
    Enum.Font.Gotham, Enum.TextXAlignment.Center, C.TEXT, 7)

makeLabel(stopKeyRow, "Arrêt Émote",
    UDim2.new(0.5, -10, 1, 0), UDim2.new(0, 28, 0, 0),
    Enum.Font.GothamSemibold, Enum.TextXAlignment.Left, C.TEXT, 7)

stopKeyBtn = Instance.new("TextButton")
stopKeyBtn.Parent = stopKeyRow
stopKeyBtn.BackgroundColor3 = C.BG_ROW
stopKeyBtn.Size = UDim2.new(0, 65, 0, 18)
stopKeyBtn.Position = UDim2.new(1, -70, 0.5, -9)
stopKeyBtn.Text = "—"
stopKeyBtn.TextColor3 = C.TEXT_DARK
stopKeyBtn.TextScaled = true
stopKeyBtn.Font = Enum.Font.GothamBold
stopKeyBtn.AutoButtonColor = false
stopKeyBtn.ZIndex = 7
corner(stopKeyBtn, 6)
stroke(stopKeyBtn, C.BORDER_DIM, 1)

-- X button pour stop keybind
local stopXBtn = Instance.new("TextButton")
stopXBtn.Parent = stopKeyRow
stopXBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
stopXBtn.Size = UDim2.new(0, 16, 0, 16)
stopXBtn.Position = UDim2.new(1, -88, 0.5, -8)
stopXBtn.Text = "✕"
stopXBtn.TextColor3 = C.RED
stopXBtn.TextScaled = true
stopXBtn.Font = Enum.Font.GothamBold
stopXBtn.AutoButtonColor = false
stopXBtn.ZIndex = 8
stopXBtn.Visible = false
corner(stopXBtn, 4)
stroke(stopXBtn, C.RED_DIM, 1)

stopXBtn.MouseEnter:Connect(function()
    tween(stopXBtn, {BackgroundColor3 = Color3.fromRGB(80, 30, 30)}, 0.15)
end)
stopXBtn.MouseLeave:Connect(function()
    tween(stopXBtn, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
end)
stopXBtn.MouseButton1Click:Connect(function()
    stopKeybind = nil
    updateStopKeyBtn()
    stopXBtn.Visible = false
    task.spawn(function() saveToServer(); showStatus("❌ Keybind supprimé", C.RED) end)
end)

updateStopKeyBtn = function()
    if stopKeybind then
        stopKeyBtn.Text = "[ " .. stopKeybind .. " ]"
        stopKeyBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
        tween(stopKeyBtn, {TextColor3 = C.RED})
        stopXBtn.Visible = true
    else
        stopKeyBtn.Text = "—"
        stopKeyBtn.BackgroundColor3 = C.BG_ROW
        tween(stopKeyBtn, {TextColor3 = C.TEXT_DARK})
        stopXBtn.Visible = false
    end
end
updateStopKeyBtn()

stopKeyBtn.MouseEnter:Connect(function()
    if listeningForKey ~= "__STOP_KEY__" then
        tween(stopKeyBtn, {BackgroundColor3 = C.BTN_HOVER}, 0.12)
    end
end)
stopKeyBtn.MouseLeave:Connect(function()
    if listeningForKey ~= "__STOP_KEY__" then
        tween(stopKeyBtn, {BackgroundColor3 = stopKeybind and Color3.fromRGB(80, 30, 30) or C.BG_ROW}, 0.12)
    end
end)

stopKeyBtn.MouseButton1Click:Connect(function()
    if listeningForKey == "__STOP_KEY__" then
        listeningForKey = nil; updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1); return
    end
    if listeningForKey then
        local old = settingsBtns[listeningForKey]
        if old then updateKeyBtn(listeningForKey, old); stroke(old, C.BORDER_DIM, 1)
        elseif listeningForKey == "__WALK_KEY__" then updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1)
        elseif listeningForKey == "__TOGGLE_KEY__" then updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1) end
    end
    listeningForKey = "__STOP_KEY__"
    stopKeyBtn.Text = "▶ ..."
    stopKeyBtn.TextColor3 = C.YELLOW
    stopKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
    stroke(stopKeyBtn, C.YELLOW, 1.5)
    tween(stopKeyBtn, {Size = UDim2.new(0, 84, 0, 24), Position = UDim2.new(1, -88, 0.5, -12)}, 0.2, Enum.EasingStyle.Back)
end)

stopKeyBtn.MouseButton2Click:Connect(function()
    stopKeybind = nil
    if listeningForKey == "__STOP_KEY__" then listeningForKey = nil end
    updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1)
    stopKeyBtn.Size = UDim2.new(0, 65, 0, 18)
    stopKeyBtn.Position = UDim2.new(1, -70, 0.5, -9)
    task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
end)

-- Divider avant les émotes
local emoteDivider = Instance.new("Frame")
emoteDivider.Parent = sScroll
emoteDivider.BackgroundColor3 = C.DIVIDER
emoteDivider.BackgroundTransparency = 0.6
emoteDivider.Size = UDim2.new(1, -8, 0, 1)
emoteDivider.BorderSizePixel = 0
emoteDivider.LayoutOrder = 4

-- Label section émotes
local emoteSectionLabel = makeLabel(sScroll, "🎭 ÉMOTES",
    UDim2.new(1, 0, 0, 18), UDim2.new(0, 4, 0, 4),
    Enum.Font.GothamBold, Enum.TextXAlignment.Left, C.ACCENT2_LIGHT, 6)
emoteSectionLabel.LayoutOrder = 5

for i, data in ipairs(emoteData) do
    local rowBg = (i%2==0) and C.BG_ROW_ALT or C.BG_ROW
    local row = Instance.new("Frame")
    row.Parent = sScroll
    row.BackgroundColor3 = rowBg
    row.Size = UDim2.new(1,-4,0,26)
    row.LayoutOrder = i + 5
    row.ZIndex = 6
    corner(row, 5)

    -- Hover sur la ligne
    local rowBtn = Instance.new("TextButton")
    rowBtn.Parent = row
    rowBtn.BackgroundTransparency = 1
    rowBtn.Size = UDim2.new(1,0,1,0)
    rowBtn.Text = ""
    rowBtn.ZIndex = 6
    rowBtn.MouseEnter:Connect(function()
        tween(row, {BackgroundColor3 = C.BG_ROW_HOVER}, 0.15)
    end)
    rowBtn.MouseLeave:Connect(function()
        tween(row, {BackgroundColor3 = rowBg}, 0.15)
    end)

    -- Icone
    local iconLbl = makeLabel(row, data.Icon or "🐾",
        UDim2.new(0,20,1,0), UDim2.new(0,6,0,0),
        Enum.Font.Gotham, Enum.TextXAlignment.Center, C.TEXT, 7)

    -- Numéro
    local numLbl = makeLabel(row, tostring(i),
        UDim2.new(0,18,1,0), UDim2.new(0,28,0,0),
        Enum.Font.GothamBold, Enum.TextXAlignment.Center, C.TEXT_DARK, 7)

    -- Nom
    makeLabel(row, data.Name,
        UDim2.new(0.5,-10,1,0), UDim2.new(0,48,0,0),
        Enum.Font.Gotham, Enum.TextXAlignment.Left, C.TEXT, 7)

    -- Bouton touche
    local keyBtn = Instance.new("TextButton")
    keyBtn.Parent = row
    keyBtn.BackgroundColor3 = C.BG_ROW
    keyBtn.Size = UDim2.new(0, 65, 0, 18)
    keyBtn.Position = UDim2.new(1, -70, 0.5, -9)
    keyBtn.Text = "—"
    keyBtn.TextColor3 = C.TEXT_DARK
    keyBtn.TextScaled = true
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.AutoButtonColor = false
    keyBtn.ZIndex = 7
    corner(keyBtn, 6)
    stroke(keyBtn, C.BORDER_DIM, 1)

    -- X button pour emote keybind
    local xBtn = Instance.new("TextButton")
    xBtn.Parent = row
    xBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
    xBtn.Size = UDim2.new(0, 16, 0, 16)
    xBtn.Position = UDim2.new(1, -88, 0.5, -8)
    xBtn.Text = "✕"
    xBtn.TextColor3 = C.RED
    xBtn.TextScaled = true
    xBtn.Font = Enum.Font.GothamBold
    xBtn.AutoButtonColor = false
    xBtn.ZIndex = 8
    xBtn.Visible = false
    corner(xBtn, 4)
    stroke(xBtn, C.RED_DIM, 1)

    xBtn.MouseEnter:Connect(function()
        tween(xBtn, {BackgroundColor3 = Color3.fromRGB(80, 30, 30)}, 0.15)
    end)
    xBtn.MouseLeave:Connect(function()
        tween(xBtn, {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}, 0.15)
    end)
    xBtn.MouseButton1Click:Connect(function()
        emoteKeybinds[data.Name] = nil
        updateKeyBtn(data.Name, keyBtn)
        xBtn.Visible = false
        if emoteButtons[data.Name] then emoteButtons[data.Name].UpdateKey() end
        task.spawn(function() saveToServer(); showStatus("❌ Keybind supprimé", C.RED) end)
    end)

    settingsBtns[data.Name] = keyBtn

    keyBtn.MouseEnter:Connect(function()
        if listeningForKey ~= data.Name then
            tween(keyBtn, {BackgroundColor3 = C.BTN_HOVER}, 0.12)
        end
    end)
    keyBtn.MouseLeave:Connect(function()
        if listeningForKey ~= data.Name then
            tween(keyBtn, {BackgroundColor3 = emoteKeybinds[data.Name] and Color3.fromRGB(30,60,35) or C.BG_ROW}, 0.12)
        end
    end)
    keyBtn.MouseButton1Click:Connect(function()
        if listeningForKey == data.Name then
            listeningForKey = nil; updateKeyBtn(data.Name, keyBtn); stroke(keyBtn, C.BORDER_DIM, 1); return
        end
        if listeningForKey then
            local old = settingsBtns[listeningForKey]
            if old then updateKeyBtn(listeningForKey, old); stroke(old, C.BORDER_DIM, 1)
            elseif listeningForKey == "__STOP_KEY__" then updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1)
            elseif listeningForKey == "__WALK_KEY__" then updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1)
            elseif listeningForKey == "__TOGGLE_KEY__" then updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1) end
        end
        listeningForKey = data.Name
        keyBtn.Text = "▶ ..."
        keyBtn.TextColor3 = C.YELLOW
        keyBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 15)
        stroke(keyBtn, C.YELLOW, 1.5)
        tween(keyBtn, {Size = UDim2.new(0, 84, 0, 24), Position = UDim2.new(1, -88, 0.5, -12)}, 0.2, Enum.EasingStyle.Back)
    end)
    keyBtn.MouseButton2Click:Connect(function()
        emoteKeybinds[data.Name] = nil
        if listeningForKey == data.Name then listeningForKey = nil end
        updateKeyBtn(data.Name, keyBtn); stroke(keyBtn, C.BORDER_DIM, 1)
        keyBtn.Size = UDim2.new(0, 65, 0, 18)
        keyBtn.Position = UDim2.new(1, -70, 0.5, -9)
        task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
    end)
end

sScroll.CanvasSize = UDim2.new(0,0,0,(#emoteData + 5)*28)

-- =============================================
-- BOUTONS ÉMOTES — avec icônes et hover amélioré
-- =============================================
for i, data in ipairs(emoteData) do
    local btn = Instance.new("TextButton")
    btn.Name = data.Name
    btn.Parent = eScroll
    btn.Size = UDim2.new(1,-6,0,26)
    btn.BackgroundColor3 = C.BTN_EMOTE
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    corner(btn, 7)
    addGradient(btn, C.BTN_EMOTE_G1, C.BTN_EMOTE_G2, 45)

    -- Icône
    local ico = makeLabel(btn, data.Icon or "🐾",
        UDim2.new(0, 22, 1, 0), UDim2.new(0, 6, 0, 0),
        Enum.Font.Gotham, Enum.TextXAlignment.Center, C.TEXT, 6)

    -- Nom
    local nameLbl = makeLabel(btn, data.Name,
        UDim2.new(1, -36, 1, 0), UDim2.new(0, 30, 0, 0),
        Enum.Font.Gotham, Enum.TextXAlignment.Left, C.TEXT, 6)

    -- Keybind indicator
    local keyInd = makeLabel(btn, "",
        UDim2.new(0, 30, 0, 16), UDim2.new(1, -36, 0.5, -8),
        Enum.Font.Code, Enum.TextXAlignment.Center, C.ACCENT_LIGHT, 6)
    keyInd.BackgroundColor3 = C.BG_DARK
    keyInd.BackgroundTransparency = 0.5
    corner(keyInd, 4)

    -- On met à jour l'indicateur de touche
    local function updateEmoteKeyInd()
        local key = emoteKeybinds[data.Name]
        keyInd.Text = key or ""
        keyInd.Visible = (key ~= nil)
    end
    updateEmoteKeyInd()

    -- Highlight au survol
    local hoverBar = Instance.new("Frame")
    hoverBar.Parent = btn
    hoverBar.BackgroundColor3 = C.ACCENT2
    hoverBar.Size = UDim2.new(0, 3, 0.6, 0)
    hoverBar.Position = UDim2.new(0, 0, 0.2, 0)
    hoverBar.BackgroundTransparency = 1
    hoverBar.ZIndex = 6
    corner(hoverBar, 2)

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = C.BTN_HOVER}, 0.12)
        tween(hoverBar, {BackgroundTransparency = 0}, 0.15)
        tween(nameLbl, {TextColor3 = C.ACCENT2_LIGHT}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = C.BTN_EMOTE}, 0.12)
        tween(hoverBar, {BackgroundTransparency = 1}, 0.15)
        tween(nameLbl, {TextColor3 = C.TEXT}, 0.15)
    end)
    btn.MouseButton1Click:Connect(function()
        -- Flash effect
        tween(btn, {BackgroundColor3 = C.ACCENT2}, 0.05)
        task.delay(0.1, function()
            tween(btn, {BackgroundColor3 = C.BTN_EMOTE}, 0.2)
        end)
        playEmote(data.Name)
    end)

    emoteButtons[data.Name] = {Button = btn, UpdateKey = updateEmoteKeyInd}
end

-- =============================================
-- RECHERCHE ÉMOTES
-- =============================================
searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local query = searchInput.Text:lower()
    for name, info in pairs(emoteButtons) do
        local key = emoteKeybinds[name]
        local keyMatch = key and key:lower():find(query, 1, true)
        if query == "" or name:lower():find(query, 1, true) or keyMatch then
            info.Button.Visible = true
        else
            info.Button.Visible = false
        end
    end
    -- Recalculer la taille du canvas
    local visibleCount = 0
    for _, info in pairs(emoteButtons) do
        if info.Button.Visible then visibleCount += 1 end
    end
    eScroll.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 28)
end)

-- =============================================
-- CLAVIER — avec support pour les keybinds de toggles
-- =============================================
UserInputService.InputBegan:Connect(function(input, gp)
    if listeningForKey then
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local key = input.KeyCode.Name
        if key == "Unknown" then return end
        local name = listeningForKey
        
        if name == "__STOP_KEY__" then
            if key == "Escape" then
                stopKeybind = nil; listeningForKey = nil
                updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1)
                stopKeyBtn.Size = UDim2.new(0, 65, 0, 18)
                stopKeyBtn.Position = UDim2.new(1, -70, 0.5, -9)
            else
                stopKeybind = key; listeningForKey = nil
                updateStopKeyBtn(); stroke(stopKeyBtn, C.BORDER_DIM, 1)
                stopKeyBtn.Size = UDim2.new(0, 65, 0, 18)
                stopKeyBtn.Position = UDim2.new(1, -70, 0.5, -9)
            end
            task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
            return
        end

        if name == "__WALK_KEY__" then
            if key == "Escape" then
                walkWithEmoteKeybind = nil; listeningForKey = nil
                updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1)
                walkKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
                walkKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
            else
                walkWithEmoteKeybind = key; listeningForKey = nil
                updateWalkKeybindBtn(); stroke(walkKeybindBtn, C.BORDER_DIM, 1)
                walkKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
                walkKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
            end
            task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
            return
        end

        if name == "__TOGGLE_KEY__" then
            if key == "Escape" then
                toggleEmotesKeybind = nil; listeningForKey = nil
                updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1)
                toggleKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
                toggleKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
            else
                toggleEmotesKeybind = key; listeningForKey = nil
                updateToggleKeybindBtn(); stroke(toggleKeybindBtn, C.BORDER_DIM, 1)
                toggleKeybindBtn.Size = UDim2.new(0, 60, 0, 16)
                toggleKeybindBtn.Position = UDim2.new(1, -68, 0.5, -8)
            end
            task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
            return
        end

        local btn  = settingsBtns[name]
        if key == "Escape" then
            emoteKeybinds[name] = nil; listeningForKey = nil
            if btn then
                updateKeyBtn(name, btn); stroke(btn, C.BORDER_DIM, 1)
                btn.Size = UDim2.new(0, 65, 0, 18)
                btn.Position = UDim2.new(1, -70, 0.5, -9)
            end
            if emoteButtons[name] then emoteButtons[name].UpdateKey() end
            task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
            return
        end
        emoteKeybinds[name] = key; listeningForKey = nil
        if btn then
            updateKeyBtn(name, btn); stroke(btn, C.BORDER_DIM, 1)
            btn.Size = UDim2.new(0, 65, 0, 18)
            btn.Position = UDim2.new(1, -70, 0.5, -9)
        end
        if emoteButtons[name] then emoteButtons[name].UpdateKey() end
        task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
        return
    end
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        
        -- Toggle keybinds
        if walkWithEmoteKeybind == key then
            walkWithEmote = not walkWithEmote
            updateWalkSwitchVisual(walkWithEmote)
            showStatus("🚶 Marcher: " .. (walkWithEmote and "ON" or "OFF"), walkWithEmote and C.GREEN or C.RED)
            task.spawn(function() saveToServer() end)
            return
        end
        
        if toggleEmotesKeybind == key then
            toggleEmotes = not toggleEmotes
            updateModeSwitchVisual(toggleEmotes)
            showStatus("🔄 Bascule: " .. (toggleEmotes and "ON" or "OFF"), toggleEmotes and C.GREEN or C.RED)
            task.spawn(function() saveToServer() end)
            return
        end
        
        -- Stop keybind
        if stopKeybind == key then
            stopAllManual()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local hum = player.Character.Humanoid
                if hum.MoveDirection.Magnitude < 0.1 then isIdle = false; startIdle() end
            end
            return
        end
        
        -- Emote keybinds
        for name, bound in pairs(emoteKeybinds) do
            if bound == key then playEmote(name); break end
        end
    end
end)

-- =============================================
-- ANIMATIONS DES PANNEAUX (slide in/out)
-- =============================================
local emotePanelOpen = false
local settingsPanelOpen = false

local function slideEmotePanel(open)
    emotePanelOpen = open
    if open then
        emoteFrame.Visible = true
        emoteFrame.Position = UDim2.new(0, 15 - 160, 0, 34)
        emoteFrame.BackgroundTransparency = 1
        tween(emoteFrame, {Position = UDim2.new(0, 15 - 178, 0, 34), BackgroundTransparency = 0.05}, 0.35, Enum.EasingStyle.Back)
    else
        tween(emoteFrame, {Position = UDim2.new(0, 15 - 150, 0, 34), BackgroundTransparency = 1}, 0.25)
        task.delay(0.25, function()
            if not emotePanelOpen then emoteFrame.Visible = false end
        end)
    end
end

local function slideSettingsPanel(open)
    settingsPanelOpen = open
    if open then
        settingsFrame.Visible = true
        settingsFrame.Position = UDim2.new(0, 15 + WIN_W + 4, 0, 34)
        settingsFrame.BackgroundTransparency = 1
        tween(settingsFrame, {Position = UDim2.new(0, 15 + WIN_W + 8, 0, 34), BackgroundTransparency = 0.05}, 0.35, Enum.EasingStyle.Back)
    else
        tween(settingsFrame, {Position = UDim2.new(0, 15 + WIN_W - 5, 0, 34), BackgroundTransparency = 1}, 0.25)
        task.delay(0.25, function()
            if not settingsPanelOpen then settingsFrame.Visible = false end
        end)
    end
end

-- =============================================
-- LOGIQUE BOUTONS PRINCIPAUX
-- =============================================
emoteToggleButton.MouseButton1Click:Connect(function()
    local shouldOpen = not emotePanelOpen
    if shouldOpen then
        slideSettingsPanel(false)
        tween(settingsButton, {BackgroundColor3 = Color3.fromRGB(32,32,55)}, 0.2)
    end
    slideEmotePanel(shouldOpen)
    tween(emoteToggleButton, {BackgroundColor3 = shouldOpen and C.ACCENT2 or C.BTN_EMOTE}, 0.2)
end)

settingsButton.MouseButton1Click:Connect(function()
    local shouldOpen = not settingsPanelOpen
    if shouldOpen then
        slideEmotePanel(false)
        tween(emoteToggleButton, {BackgroundColor3 = C.BTN_EMOTE}, 0.2)
    end
    slideSettingsPanel(shouldOpen)
    tween(settingsButton, {BackgroundColor3 = shouldOpen and C.ACCENT or Color3.fromRGB(32,32,55)}, 0.2)
end)

-- Toggle switch logic
switchTrack.MouseButton1Click:Connect(function()
    if not isCustomAnimActive then
        -- Activer
        isCustomAnimActive = true
        updateToggleVisual(true)
        statusLabel.Text = "En ligne"; statusLabel.TextColor3 = C.GREEN
        tween(statusDot, {BackgroundColor3 = C.GREEN})
        tween(statusGlow, {BackgroundColor3 = C.GREEN})
        tween(statusBar, {BackgroundColor3 = Color3.fromRGB(15, 30, 20)})
        if player.Character then applyAnim(player.Character) end
        task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
    else
        -- Désactiver
        statusLabel.Text = "Hors-ligne"; statusLabel.TextColor3 = C.RED
        tween(statusDot, {BackgroundColor3 = C.RED})
        tween(statusGlow, {BackgroundColor3 = C.RED})
        tween(statusBar, {BackgroundColor3 = C.STATUS_BG})
        updateToggleVisual(false)
        if player.Character then restoreAnim(player.Character) end
        task.spawn(function() saveToServer(); showStatus("💾 Sauvegardé", C.GREEN) end)
    end
end)

destroyButton.MouseButton1Click:Connect(function()
    -- Animation de fermeture
    tween(windowContainer, {Position = UDim2.new(windowContainer.Position.X.Scale, windowContainer.Position.X.Offset, windowContainer.Position.Y.Scale, windowContainer.Position.Y.Offset + 20)}, 0.2)
    tween(frame, {BackgroundTransparency = 1}, 0.2)
    tween(titleBar, {BackgroundTransparency = 1}, 0.2)
    task.delay(0.25, function()
        if isCustomAnimActive and player.Character then restoreAnim(player.Character) end
        gui:Destroy()
    end)
end)

player.CharacterAdded:Connect(function(c)
    if isCustomAnimActive then task.wait(0.5); applyAnim(c) end
end)

-- =============================================
-- EXPORT / IMPORT
-- =============================================
local codeBoxMode = nil

exportBtn.MouseButton1Click:Connect(function()
    local json = exportData()
    if not json then showStatus("❌ Erreur export", C.RED); return end
    if codeBoxMode == "export" and codeBox.Visible then
        codeBox.Visible = false; codeBoxMode = nil
        tween(exportBtn, {BackgroundColor3 = Color3.fromRGB(28,50,80)})
        return
    end
    codeBoxMode = "export"
    codeBox.Visible = true
    codeBoxLabel.Text = "📤 Copie ce texte pour sauvegarder :"
    codeInput.Text = json
    codeInput.TextEditable = false
    codeInput.TextXAlignment = Enum.TextXAlignment.Left
    tween(exportBtn, {BackgroundColor3 = C.ACCENT2})
    tween(importBtn, {BackgroundColor3 = Color3.fromRGB(55,40,18)})
    showStatus("📤 Données prêtes à copier", C.ACCENT2)
end)

importBtn.MouseButton1Click:Connect(function()
    if codeBoxMode == "import" and codeBox.Visible then
        local json = codeInput.Text
        if json == "" or json == "Colle ici le texte exporté..." then
            showStatus("❌ Texte vide", C.RED); return
        end
        local data = importData(json)
        if not data then showStatus("❌ Format invalide", C.RED); return end
        emoteKeybinds = data.keybinds or {}
        refreshAllKeyBtns()
        for name, info in pairs(emoteButtons) do info.UpdateKey() end
        if data.isActive ~= nil then
            if data.isActive and not isCustomAnimActive then
                isCustomAnimActive = true
                updateToggleVisual(true)
                statusLabel.Text = "En ligne"; statusLabel.TextColor3 = C.GREEN
                tween(statusDot, {BackgroundColor3 = C.GREEN})
                tween(statusGlow, {BackgroundColor3 = C.GREEN})
                tween(statusBar, {BackgroundColor3 = Color3.fromRGB(15,30,20)})
                if player.Character then applyAnim(player.Character) end
            end
        end
        if data.walkWithEmote ~= nil then
            walkWithEmote = data.walkWithEmote
            updateWalkSwitchVisual(walkWithEmote)
        end
        if data.toggleEmotes ~= nil then
            toggleEmotes = data.toggleEmotes
            updateModeSwitchVisual(toggleEmotes)
        end
        if data.walkWithEmoteKeybind ~= nil then
            walkWithEmoteKeybind = data.walkWithEmoteKeybind
            updateWalkKeybindBtn()
        end
        if data.toggleEmotesKeybind ~= nil then
            toggleEmotesKeybind = data.toggleEmotesKeybind
            updateToggleKeybindBtn()
        end
        task.spawn(function() saveToServer() end)
        codeBox.Visible = false; codeBoxMode = nil
        tween(importBtn, {BackgroundColor3 = Color3.fromRGB(55,40,18)})
        showStatus("✔ Import réussi !", C.GREEN)
        return
    end
    codeBoxMode = "import"
    codeBox.Visible = true
    codeBoxLabel.Text = "📥 Colle ici ton export, puis reclique Importer :"
    codeInput.Text = ""
    codeInput.TextEditable = true
    codeInput.PlaceholderText = "Colle ici le texte exporté..."
    tween(importBtn, {BackgroundColor3 = C.ORANGE})
    tween(exportBtn, {BackgroundColor3 = Color3.fromRGB(28,50,80)})
    showStatus("📥 Colle le texte puis reclique Importer", C.YELLOW)
end)

-- =============================================
-- ANIMATION D'ENTRÉE
-- =============================================
task.spawn(function()
    -- Début invisible
    frame.BackgroundTransparency = 1
    titleBar.BackgroundTransparency = 1
    titleShadow.BackgroundTransparency = 1
    titleGlow.BackgroundTransparency = 1
    windowContainer.Position = UDim2.new(
        windowContainer.Position.X.Scale,
        windowContainer.Position.X.Offset,
        windowContainer.Position.Y.Scale,
        windowContainer.Position.Y.Offset + 30
    )

    task.wait(0.1)

    -- Slide up + fade in
    tween(windowContainer, {
        Position = UDim2.new(0.5, -(WIN_W + 30)/2, 0.5, -140)
    }, 0.5, Enum.EasingStyle.Back)
    tween(frame, {BackgroundTransparency = 0}, 0.4)
    tween(titleBar, {BackgroundTransparency = 0}, 0.3)
    tween(titleShadow, {BackgroundTransparency = 0.75}, 0.4)
    tween(titleGlow, {BackgroundTransparency = 0.85}, 0.5)
end)

-- =============================================
-- CHARGEMENT AU DÉMARRAGE
-- =============================================
task.spawn(function()
    showStatus("⏳ Chargement...", C.YELLOW)
    task.wait(1.2)
    local data = loadFromServer()
    if data then
        if type(data.keybinds) == "table" then
            emoteKeybinds = data.keybinds
            refreshAllKeyBtns()
            for name, info in pairs(emoteButtons) do info.UpdateKey() end
        end
        if data.walkWithEmote ~= nil then
            walkWithEmote = data.walkWithEmote
            updateWalkSwitchVisual(walkWithEmote)
        end
        if data.toggleEmotes ~= nil then
            toggleEmotes = data.toggleEmotes
            updateModeSwitchVisual(toggleEmotes)
        end
        if data.stopKeybind ~= nil then
            stopKeybind = data.stopKeybind
            updateStopKeyBtn()
        end
        if data.walkWithEmoteKeybind ~= nil then
            walkWithEmoteKeybind = data.walkWithEmoteKeybind
            updateWalkKeybindBtn()
        end
        if data.toggleEmotesKeybind ~= nil then
            toggleEmotesKeybind = data.toggleEmotesKeybind
            updateToggleKeybindBtn()
        end
        if data.isActive == true then
            isCustomAnimActive = true
            updateToggleVisual(true)
            statusLabel.Text = "En ligne"; statusLabel.TextColor3 = C.GREEN
            tween(statusDot, {BackgroundColor3 = C.GREEN})
            tween(statusGlow, {BackgroundColor3 = C.GREEN})
            tween(statusBar, {BackgroundColor3 = Color3.fromRGB(15,30,20)})
            if player.Character then task.wait(0.5); applyAnim(player.Character) end
        end
        showStatus("✔ Chargé depuis la sauvegarde", C.GREEN)
    else
        showStatus("⚠ Aucune sauvegarde trouvée", C.YELLOW)
    end
end)

-- =============================================
-- GAZE EMOTES - Catalog Browser Integration
-- =============================================
local gazeEmotesEnabled = false
local gazeEmotesGUI = nil

local function initGazeEmotes()
    if gazeEmotesEnabled then
        -- Toggle visibility if already initialized
        if gazeEmotesGUI then
            gazeEmotesGUI.Enabled = not gazeEmotesGUI.Enabled
            showStatus(gazeEmotesGUI.Enabled and "🌐 Catalog Emotes ouvert" or "🌐 Catalog Emotes fermé", gazeEmotesGUI.Enabled and C.CYAN or C.YELLOW)
        end
        return
    end
    gazeEmotesEnabled = true

    local _1=setmetatable({},{__index=function(_,k)local c=workspace.CurrentCamera local s=c and c.ViewportSize or Vector2.new(1920,1080)if k=="Width"then return s.X elseif k=="Height"then return s.Y elseif k=="Size"then return s end end})
    local _2=game:GetService("UserInputService")
    local _3=workspace.CurrentCamera.ViewportSize
    local function _4(_a,_b)local _c=_2.TouchEnabled and not _2.KeyboardEnabled local _d,_e=1920,1080 local _f=_c and 2 or 1.5 if _a=="X"then return _b*(_3.X/_d)*_f elseif _a=="Y"then return _b*(_3.Y/_e)*_f end end
    local function _5(_a,_b,_c)if type(_b)==_a then return _b end return _c end
    local _6=_5("function",cloneref,function(...)return ... end)
    local _7=setmetatable({},{__index=function(_,_a)return _6(game:GetService(_a))end})
    local _8=_7.Players local _9=_7.RunService local _10=_7.UserInputService local _11=_7.TweenService local _12=_7.AvatarEditorService local _13=_7.HttpService
    local _14=_8.LocalPlayer local _15=_14.Character or _14.CharacterAdded:Wait()local _16=_15:WaitForChild("Humanoid")local _isR6=_16.RigType==Enum.HumanoidRigType.R6 local _17=_15.PrimaryPart and _15.PrimaryPart.Position or Vector3.new()
    local _35_Ref, _36_Ref, _37_Ref, _39_Ref, _43_Ref;

    _14.CharacterAdded:Connect(function(_a)
        _15=_a _16=_a:WaitForChild("Humanoid")_isR6=_16.RigType==Enum.HumanoidRigType.R6
        if _35_Ref then _35_Ref.Text=_isR6 and "GAZE EMOTES" or "Gaze Emotes" end
        if _36_Ref then _36_Ref.Text=_isR6 and "Anim" or "Catalog" end
        if _37_Ref then _37_Ref.Visible=not _isR6 end
        if _isR6 and _39_Ref and _43_Ref then
            _39_Ref.Visible=true _43_Ref.Visible=false
            _36_Ref.BackgroundColor3=Color3.fromRGB(30,30,80)
            _37_Ref.BackgroundColor3=Color3.fromRGB(20,50,20)
        end
        _17=_15.PrimaryPart and _15.PrimaryPart.Position or Vector3.new()
    end)

    local _18={} _18["Stop Emote When Moving"]=true _18["Fade In"]=0.1 _18["Fade Out"]=0.1 _18["Weight"]=1
    _18["Speed"]=1 _18["Time Position"]=0 _18["Freeze On Finish"]=false _18["Looped"]=true _18["Stop Other Animations On Play"]=true _18["High Priority"]=true
    local _19={} local _20="GazeEmotes_NewNEWN3WSaved.json"
    local function _21()local _a,_b=pcall(function()if readfile and isfile and isfile(_20)then return _13:JSONDecode(readfile(_20))end return{}end)if _a and type(_b)=="table"then _19=_b else _19={}end for _c,_d in ipairs(_19)do if not _d.AnimationId then if _d.AssetId then _d.AnimationId="rbxassetid://"..tostring(_d.AssetId)else _d.AnimationId="rbxassetid://"..tostring(_d.Id)end end if _d.Favorite==nil then _d.Favorite=false end end end
    local function _22()pcall(function()if writefile then writefile(_20,_13:JSONEncode(_19))end end)end
    _21()
    local _23=nil
    local function _24(_a)if _23 then _23:Stop(_18["Fade Out"])end local _b
    local _c,_d=pcall(function()return game:GetObjects("rbxassetid://"..tostring(_a))end)if _c and _d and #_d>0 then local _e=_d[1]if _e:IsA("Animation")then _b=_e.AnimationId else _b="rbxassetid://"..tostring(_a)end else _b="rbxassetid://"..tostring(_a)end local _e=Instance.new("Animation")_e.AnimationId=_b local _f=_16:LoadAnimation(_e)local _g=_18["High Priority"]and Enum.AnimationPriority.Action4 or Enum.AnimationPriority.Action _f.Priority=_g local _h=_18["Weight"]if _h==0
    then _h=0.001 end if _18["Stop Other Animations On Play"]then for _i,_j in pairs(_16.Animator:GetPlayingAnimationTracks())do if _j.Priority~=_g then _j:Stop()end end end _f:Play(_18["Fade In"],_h,_18["Speed"])_23=_f _23.TimePosition=math.clamp(_18["Time Position"],0,1)*(_23.Length or 1)_23.Priority=_g _23.Looped=_18["Looped"]return _f end
    _9.RenderStepped:Connect(function()if _18["Looped"]and _23 and _23.IsPlaying then _23.Looped=_18["Looped"]end if _15:FindFirstChild("HumanoidRootPart")then local _a=_15.HumanoidRootPart if _18["Stop Emote When Moving"]and _23 and _23.IsPlaying then local _b=(_a.Position-_17).Magnitude>0.1 local _c=_16 and _16:GetState()==Enum.HumanoidStateType.Jumping if _b or _c then _23:Stop(_18["Fade Out"])_23=nil end end _17=_a.Position end end)
    local _25=_7.CoreGui local _26=Instance.new("ScreenGui")_26.Name="GazeEmoteGUI"_26.Parent=_25 _26.Enabled=true _26.DisplayOrder=999
    gazeEmotesGUI = _26
    local function _27(_a,_b)local _c=Instance.new("UICorner")_c.CornerRadius=UDim.new(0,_b or 6)_c.Parent=_a return _c end
    local function _28(_a,_b,_c)local _d=Instance.new("UIStroke")_d.Color=_b or Color3.fromRGB(60,120,200)_d.Thickness=_c or 1 _d.ApplyStrokeMode=Enum.ApplyStrokeMode.Border _d.Parent=_a return _d end
    local function _29(_a)local _b=Instance.new("UIScale")_b.Scale=0.5 _b.Parent=_a _11:Create(_b,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Scale=1}):Play()end
    local _30=Instance.new("Frame")_30.Size=UDim2.new(0,_4("X",470),0,_4("Y",450))_30.Position=UDim2.new(0.5,-_4("X",325),0.5,-_4("Y",225))_30.BackgroundColor3=Color3.fromRGB(15,15,20)_30.BackgroundTransparency=0.15 _30.Active=true _30.Draggable=true _30.Parent=_26 _27(_30,8)_28(_30,Color3.fromRGB(80,80,120),1.5)
    local _31=Instance.new("TextButton")_31.Size=UDim2.new(0,24,0,24)_31.Position=UDim2.new(1,-24,1,-24)_31.BackgroundTransparency=1 _31.Text="◢"_31.TextColor3=Color3.fromRGB(100,100,140)_31.TextSize=18 _31.ZIndex=10 _31.Parent=_30
    local _32=false local _33 local _34 _31.InputBegan:Connect(function(_a)if _a.UserInputType==Enum.UserInputType.MouseButton1 or _a.UserInputType==Enum.UserInputType.Touch then _32=true _33=_a.Position _34=_30.AbsoluteSize end end)_10.InputChanged:Connect(function(_a)if _32 and(_a.UserInputType==Enum.UserInputType.MouseMovement or _a.UserInputType==Enum.UserInputType.Touch)then local _b=_a.Position-_33 local _c=math.max(150,_34.X+_b.X)local _d=math.max(100,_34.Y+_b.Y)_30.Size=UDim2.new(0,_c,0,_d)end end)_10.InputEnded:Connect(function(_a)if _a.UserInputType==Enum.UserInputType.MouseButton1 or _a.UserInputType==Enum.UserInputType.Touch then _32=false end end)
    local _35=Instance.new("TextLabel")_35_Ref=_35 _35.Size=UDim2.new(1,0,0,_4("Y",36))_35.BackgroundColor3=Color3.fromRGB(20,20,25)_35.BackgroundTransparency=0.5 _35.Text=_isR6 and "Gaze Emotes (R6)" or "Gaze Emotes"_35.TextColor3=Color3.new(1,1,1)_35.Font=Enum.Font.GothamBold _35.TextScaled=true _35.Parent=_30 _27(_35,8)
    local _36=Instance.new("TextButton")_36_Ref=_36 _36.Size=UDim2.new(0.3,0,0,_4("Y",24))_36.Position=UDim2.new(0.05,0,0,_4("Y",40))_36.BackgroundColor3=Color3.fromRGB(30,30,80)_36.BackgroundTransparency=0.2 _36.Text=_isR6 and "Animation" or "Catalog"_36.TextColor3=Color3.new(1,1,1)_36.Font=Enum.Font.GothamBold _36.TextScaled=true _36.Parent=_30 _27(_36,4)
    local _37=Instance.new("TextButton")_37_Ref=_37 _37.Size=UDim2.new(0.3,0,0,_4("Y",24))_37.Position=UDim2.new(0.35,0,0,_4("Y",40))_37.BackgroundColor3=Color3.fromRGB(30,80,30)_37.BackgroundTransparency=0.2 _37.Text="Saved"_37.TextColor3=Color3.new(1,1,1)_36.Font=Enum.Font.GothamBold _36.TextScaled=true _37.Visible=not _isR6 _37.Parent=_30 _27(_37,4)
    local _38=Instance.new("Frame")_38.Size=UDim2.new(0,_4("X",2),1,-_4("Y",70))_38.Position=UDim2.new(0.6,-_4("X",1),0,_4("Y",70))_38.BackgroundColor3=Color3.fromRGB(50,50,70)_38.BackgroundTransparency=0.5 _38.Parent=_30
    local _39=Instance.new("Frame")_39_Ref=_39 _39.Size=UDim2.new(0.6,-_4("X",10),1,-_4("Y",70))_39.Position=UDim2.new(0,_4("X",5),0,_4("Y",70))_39.BackgroundTransparency=1 _39.Visible=true _39.Parent=_30
    local _40=Instance.new("TextBox")_40.Size=UDim2.new(0.6,-_4("X",8),0,_4("Y",28))_40.Position=UDim2.new(0,_4("X",8),0,0)_40.PlaceholderText="Search..."_40.BackgroundColor3=Color3.fromRGB(20,20,25)_40.BackgroundTransparency=0.3 _40.TextColor3=Color3.new(1,1,1)_40.Font=Enum.Font.Gotham _40.TextScaled=true _40.ClearTextOnFocus=false _40.Text=""_40.Parent=_39
    _27(_40,4)_28(_40,Color3.fromRGB(50,50,70),1)
    local _41=Instance.new("TextButton")_41.Size=UDim2.new(0.2,-_4("X",4),0,_4("Y",28))_41.Position=UDim2.new(0.6,_4("X",4),0,0)_41.BackgroundColor3=Color3.fromRGB(0,60,150)_41.BackgroundTransparency=0.2 _41.Text="Refresh"_41.Font=Enum.Font.GothamBold _41.TextScaled=true _41.TextColor3=Color3.new(1,1,1)_41.Parent=_39 _27(_41,4)
    local _42=Instance.new("TextButton")_42.Size=UDim2.new(0.2,-_4("X",8),0,_4("Y",28))_42.Position=UDim2.new(0.8,_4("X",4),0,0)_42.BackgroundColor3=Color3.fromRGB(40,40,80)_42.BackgroundTransparency=0.2 _42.Text="Sort: Relevance"_42.Font=Enum.Font.GothamBold _42.TextScaled=true _42.TextColor3=Color3.new(1,1,1)_41.Parent=_39 _27(_42,4)
    local _43=Instance.new("Frame")_43_Ref=_43 _43.Size=UDim2.new(0.6,-_4("X",10),1,-_4("Y",70))_43.Position=UDim2.new(0,_4("X",5),0,_4("Y",70))_43.BackgroundTransparency=1 _43.Visible=false _43.Parent=_30
    local _44=Instance.new("TextBox")_44.Size=UDim2.new(0.7,-_4("X",16),0,_4("Y",28))_44.Position=UDim2.new(0,_4("X",8),0,0)_44.PlaceholderText="Search Saved..."_44.BackgroundColor3=Color3.fromRGB(20,20,25)_44.BackgroundTransparency=0.3 _44.TextColor3=Color3.new(1,1,1)_44.Font=Enum.Font.Gotham _44.TextScaled=true _44.ClearTextOnFocus=false _44.Text=""_44.Parent=_43 _27(_44,4)_28(_44,Color3.fromRGB(50,50,70),1)
    local _44a=Instance.new("TextBox")_44a.Size=UDim2.new(0.2,0,0,_4("Y",28))_44a.Position=UDim2.new(0.7,-_4("X",4),0,0)_44a.PlaceholderText="Emote ID"_44a.BackgroundColor3=Color3.fromRGB(20,20,25)_44a.BackgroundTransparency=0.3 _44a.TextColor3=Color3.new(1,1,1)_44a.Font=Enum.Font.Gotham _44a.TextScaled=true _44a.ClearTextOnFocus=false _44a.Text=""_44a.Parent=_43 _27(_44a,4)_28(_44a,Color3.fromRGB(50,50,70),1)
    local _44b=Instance.new("TextButton")_44b.Size=UDim2.new(0.1,0,0,_4("Y",28))_44b.Position=UDim2.new(0.9,0,0,0)_44b.BackgroundColor3=Color3.fromRGB(40,100,160)_44b.BackgroundTransparency=0.2 _44b.Text="+"_44b.Font=Enum.Font.GothamBold _44b.TextScaled=true _44b.TextColor3=Color3.new(1,1,1)_44b.Parent=_43 _27(_44b,4)
    local _45=Instance.new("ScrollingFrame")_45.Size=UDim2.new(1,-_4("X",16),1,-_4("Y",40))_45.Position=UDim2.new(0,_4("X",8),0,_4("Y",36))_45.CanvasSize=UDim2.new(0,0,0,0)_45.ScrollBarThickness=0 _45.BackgroundTransparency=1 _45.Parent=_43
    local _46=Instance.new("TextLabel")_46.Size=UDim2.new(1,0,0,_4("Y",36))_46.Position=UDim2.new(0,0,0.5,-_4("Y",18))_46.BackgroundTransparency=1
    _46.Text="Sorry I Was Changing Save Files Again 😅"_46.TextColor3=Color3.new(1,1,1)_46.Font=Enum.Font.GothamBold _46.TextScaled=true _46.Visible=false _46.Parent=_45
    local _47=Instance.new("UIGridLayout")_47.CellSize=UDim2.new(0,_4("X",120),0,_4("Y",200))_47.CellPadding=UDim2.new(0,_4("X",8),0,_4("Y",8))_47.HorizontalAlignment=Enum.HorizontalAlignment.Center _47.Parent=_45
    local _48=Instance.new("Frame")_48.Size=UDim2.new(0.4,-_4("X",10),1,-_4("Y",70))_48.Position=UDim2.new(0.6,_4("X",5),0,_4("Y",70))_48.BackgroundTransparency=1 _48.Parent=_30
    local _49=Instance.new("TextLabel")_49.Size=UDim2.new(1,0,0,_4("Y",28))_49.BackgroundTransparency=1 _49.Text="Settings"_49.TextColor3=Color3.new(1,1,1)_49.Font=Enum.Font.GothamBold _49.TextScaled=true _49.Parent=_48
    local _50=Instance.new("ScrollingFrame")_50.Size=UDim2.new(1,-_4("X",20),1,-_4("Y",40))_50.Position=UDim2.new(0,_4("X",10),0,_4("Y",30))_50.BackgroundTransparency=1 _50.CanvasSize=UDim2.new(0,0,0,0)_50.ScrollBarThickness=4 _50.ScrollBarImageColor3=Color3.fromRGB(100,100,140)_50.Parent=_48
    local function _51()_50.CanvasPosition=Vector2.new(0,_50.CanvasPosition.Y)end _50:GetPropertyChangedSignal("CanvasPosition"):Connect(_51)
    local _52=Instance.new("UIListLayout",_50)_52.Padding=UDim.new(0,8)_52.FillDirection=Enum.FillDirection.Vertical _52.SortOrder=Enum.SortOrder.LayoutOrder
    _52:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()_50.CanvasSize=UDim2.new(0,0,0,_52.AbsoluteContentSize.Y+10)end)
    function GetReal(_a)local _b,_c=pcall(function()return game:GetObjects("rbxassetid://"..tostring(_a))end)if _b and _c and #_c>0 then local _d=_c[1]if _d:IsA("Animation")and _d.AnimationId~=""then return tonumber(_d.AnimationId:match("%d+"))elseif _d:FindFirstChildOfClass("Animation")then local _e=_d:FindFirstChildOfClass("Animation")return tonumber(_e.AnimationId:match("%d+"))end end end
    local _80
    _44b.MouseButton1Click:Connect(function()local _a=tonumber(_44a.Text)if _a then local _b=false for _c,_d in ipairs(_19)do if _d.Id==_a then _b=true
    break end end if not _b then local _e=GetReal(_a)table.insert(_19,{Id=_a,AssetId=_a,Name="Custom ID: ".._a,AnimationId="rbxassetid://"..tostring(_e or _a),Favorite=false})_22()_80()end end end)
    _18._sliders={} _18._toggles={}
    local function _53(_a,_b,_c,_d)_18[_a]=_d or _b local _e=Instance.new("Frame")_e.Size=UDim2.new(1,0,0,_4("Y",65))_e.BackgroundTransparency=1 _e.Parent=_50 local _f=Instance.new("Frame")_f.Size=UDim2.new(1,0,1,0)_f.BackgroundColor3=Color3.fromRGB(20,20,30)_f.BackgroundTransparency=0.4 _f.Parent=_e _27(_f,6)_28(_f,Color3.fromRGB(60,60,90),1)local _g=Instance.new("TextLabel")_g.Size=UDim2.new(0.5,-_4("X",10),0,_4("Y",20))_g.Position=UDim2.new(0,10,0,5)_g.BackgroundTransparency=1 _g.Text=string.format("%s: %.2f",_a,_18[_a])_g.TextColor3=Color3.new(1,1,1)_g.Font=Enum.Font.Gotham _g.TextScaled=true _g.TextXAlignment=Enum.TextXAlignment.Left _g.Parent=_f local _h=Instance.new("TextBox")_h.Size=UDim2.new(0.5,-_4("X",20),0,_4("Y",20))_h.Position=UDim2.new(0.5,_4("X",10),0,_4("Y",5))_h.BackgroundColor3=Color3.fromRGB(30,30,40)_h.Text=tostring(_18[_a])_h.TextColor3=Color3.new(1,1,1)_h.Font=Enum.Font.Gotham _h.TextScaled=true _h.ClearTextOnFocus=false _h.Parent=_f
    _27(_h,4)local _i=Instance.new("Frame")_i.Size=UDim2.new(1,-_4("X",40),0,_4("Y",12))_i.Position=UDim2.new(0,_4("X",20),0,_4("Y",35))_i.BackgroundColor3=Color3.fromRGB(40,40,50)_i.Parent=_f _27(_i,6)local _j=Instance.new("Frame")_j.Size=UDim2.new(0,0,1,0)_j.BackgroundColor3=Color3.fromRGB(0,140,255)_j.Parent=_i _27(_j,6)local _k=Instance.new("Frame")_k.Size=UDim2.new(0,_4("X",20),0,_4("Y",20))_k.AnchorPoint=Vector2.new(0.5,0.5)_k.Position=UDim2.new(0,0,0.5,0)_k.BackgroundColor3=Color3.fromRGB(220,220,255)_k.Parent=_i _27(_k,10)_28(_k,Color3.fromRGB(0,0,0),1)local function _l(_m)local _n=math.clamp(_m,0,1)_11:Create(_j,TweenInfo.new(0.15),{Size=UDim2.new(_n,0,1,0)}):Play()_11:Create(_k,TweenInfo.new(0.15),{Position=UDim2.new(_n,0,0.5,0)}):Play()end local function _o(_p)_18[_a]=math.clamp(_p,_b,_c)_g.Text=string.format("%s: %.2f",_a,_18[_a])_h.Text=tostring(_18[_a])local _q=(_18[_a]-_b)/(_c-_b)_l(_q)if _23 and _23.IsPlaying then if _a=="Speed"then _23:AdjustSpeed(_18["Speed"])elseif _a=="Weight"then local _r=_18["Weight"]if _r==0 then _r=0.001 end _23:AdjustWeight(_r)elseif _a=="Time Position"then if _23.Length>0 then _23.TimePosition=math.clamp(_p,0,1)*_23.Length end end end end local _s=false local function _t(_u)local _v=math.clamp((_u.Position.X-_i.AbsolutePosition.X)/_i.AbsoluteSize.X,0,1)local _w=math.floor((_b+(_c-_b)*_v)*100)/100 _o(_w)end _i.InputBegan:Connect(function(_x)if _x.UserInputType==Enum.UserInputType.MouseButton1 or _x.UserInputType==Enum.UserInputType.Touch then _s=true _t(_x)end end)_k.InputBegan:Connect(function(_y)if _y.UserInputType==Enum.UserInputType.MouseButton1 or _y.UserInputType==Enum.UserInputType.Touch then _s=true _t(_y)end
    end)_10.InputChanged:Connect(function(_z)if _s and(_z.UserInputType==Enum.UserInputType.MouseMovement or _z.UserInputType==Enum.UserInputType.Touch)then _t(_z)end end)_10.InputEnded:Connect(function(_A)if _s and(_A.UserInputType==Enum.UserInputType.MouseButton1 or _A.UserInputType==Enum.UserInputType.Touch)then _s=false end end)_h.FocusLost:Connect(function(_B)if _B then local _C=tonumber(_h.Text)if _C then _o(_C)else _h.Text=tostring(_18[_a])end end end)_18._sliders[_a]=_o _o(_18[_a])end
    local function _54(_a)_18[_a]=_18[_a]or false local _b=Instance.new("Frame")_b.Size=UDim2.new(1,0,0,_4("Y",40))_b.BackgroundColor3=Color3.fromRGB(20,20,30)_b.BackgroundTransparency=0.4 _b.Parent=_50 _27(_b,6)_28(_b,Color3.fromRGB(60,60,90),1)local _c=Instance.new("TextLabel")_c.Size=UDim2.new(1,-_4("X",90),1,0)_c.Position=UDim2.new(0,_4("X",10),0,0)_c.BackgroundTransparency=1 _c.Text=_a _c.TextColor3=Color3.new(1,1,1)_c.Font=Enum.Font.Gotham _c.TextScaled=true _c.TextXAlignment=Enum.TextXAlignment.Left _c.Parent=_b
    local _d=Instance.new("TextButton")_d.Size=UDim2.new(0,_4("X",60),0,_4("Y",24))_d.Position=UDim2.new(1,-_4("X",70),0.5,-_4("Y",12))_d.TextColor3=Color3.new(1,1,1)_d.Font=Enum.Font.GothamBold _d.TextScaled=true _d.Parent=_b _27(_d,4)local function _e(_f)_d.Text=_f and "ON"or "OFF"_d.BackgroundColor3=_f and Color3.fromRGB(0,150,100)or Color3.fromRGB(150,40,40)_d.BackgroundTransparency=0.2 end _d.MouseButton1Click:Connect(function()_18[_a]=not _18[_a]_e(_18[_a])end)_e(_18[_a])_18._toggles[_a]=_e end
    function _18:EditSlider(_a,_b)local _c=self._sliders[_a]if _c then _c(_b)end end function _18:EditToggle(_a,_b)local _c=self._toggles[_a]if _c then _18[_a]=_b _c(_b)end end
    local function _55(_a,_b)local _c=Instance.new("Frame")_c.Size=UDim2.new(1,0,0,_4("Y",45))_c.BackgroundColor3=Color3.fromRGB(20,20,30)_c.BackgroundTransparency=0.4 _c.Parent=_50 _27(_c,6)local _d=Instance.new("TextButton")_d.Size=UDim2.new(1,-_4("X",20),1,-_4("Y",10))_d.Position=UDim2.new(0,_4("X",10),0,_4("Y",5))_d.BackgroundColor3=Color3.fromRGB(30,90,180)_d.BackgroundTransparency=0.2 _d.Text=_a _d.TextColor3=Color3.new(1,1,1)_d.Font=Enum.Font.GothamBold _d.TextScaled=true _d.Parent=_c _27(_d,6)_d.MouseButton1Click:Connect(function()if typeof(_b)=="function"then _b()end end)return _d end
    local _56=_55("Reset Settings",function()end)_54("Stop Emote When Moving")_54("Looped")_53("Speed",0,5,_18["Speed"])_53("Time Position",0,1,_18["Time Position"])_53("Weight",0,1,_18["Weight"])_53("Fade In",0,2,_18["Fade In"])_53("Fade Out",0,2,_18["Fade Out"])_54("Stop Other Animations On Play")_54("High Priority")
    _56.MouseButton1Click:Connect(function()_18:EditToggle("Stop Emote When Moving",true)_18:EditToggle("Stop Other Animations On Play",true)_18:EditToggle("High Priority",true)_18:EditSlider("Fade In",0.1)_18:EditSlider("Fade Out",0.1)_18:EditSlider("Weight",1)_18:EditSlider("Speed",1)_18:EditSlider("Time Position",0)_18:EditToggle("Freeze On Finish",false)_18:EditToggle("Looped",true)end)
    local _57={{Enum.CatalogSortType.Relevance,"Relevance"},{Enum.CatalogSortType.PriceHighToLow,"Price High→Low"},{Enum.CatalogSortType.PriceLowToHigh,"Price Low→High"},{Enum.CatalogSortType.MostFavorited,"Most Favorited"},{Enum.CatalogSortType.RecentlyCreated,"Recently Created"},{Enum.CatalogSortType.Bestselling,"Bestselling"}}
    local _58=1 local _59=""local _60=nil local _61=1 local _TAB=1
    local function _62(_a)if _isR6 then return {IsFinished=true,GetCurrentPage=function()return{{Id=115314801778772,Name="Dance If Youre The Best",AssetId=115314801778772}}end,AdvanceToNextPageAsync=function()end}end local _b=CatalogSearchParams.new()_b.SearchKeyword=_a or ""_b.CategoryFilter=Enum.CatalogCategoryFilter.None _b.SalesTypeFilter=Enum.SalesTypeFilter.All _b.AssetTypes={Enum.AvatarAssetType.EmoteAnimation}_b.IncludeOffSale=true _b.SortType=_57[_58][1]_b.Limit=10 local _c,_d=pcall(function()return _12:SearchCatalog(_b)end)if not _c then return nil end return _d end
    local function _63(_a)local _b=Instance.new("Frame")_b.Size=UDim2.new(0,_4("X",120),0,_4("Y",180))_b.BackgroundColor3=Color3.fromRGB(25,25,35)_b.BackgroundTransparency=0.2 _27(_b,8)_28(_b,Color3.fromRGB(60,60,90),1)local _c=_a.AssetId or _a.Id local _d=Instance.new("ImageLabel")_d.Size=UDim2.new(1,-_4("X",10),0,_4("Y",90))_d.Position=UDim2.new(0,_4("X",5),0,_4("Y",5))_d.BackgroundTransparency=1 _d.ScaleType=Enum.ScaleType.Fit pcall(function()_d.Image="rbxthumb://type=Asset&id="..tonumber(_c).."&w=150&h=150"end)_d.Parent=_b _27(_d,4)local _e=Instance.new("TextLabel")_e.Size=UDim2.new(1,-_4("X",10),0,_4("Y",28))_e.Position=UDim2.new(0,_4("X",5),0,_4("Y",100))_e.BackgroundTransparency=1 _e.Text=_a.Name or "Unknown"_e.TextScaled=true _e.TextWrapped=true _e.Font=Enum.Font.GothamBold _e.TextColor3=Color3.new(1,1,1)_e.Parent=_b local _f="https://www.roblox.com/catalog/"..tonumber(_a.Id)local _g=Instance.new("TextButton")_g.Parent=_b _g.Size=UDim2.new(0,_4("X",36),0,_4("Y",36))_g.Position=UDim2.new(1,-_4("X",42),0,_4("Y",5))_g.BackgroundColor3=Color3.fromRGB(30,30,45)_g.BackgroundTransparency=0.2 _g.Text="🛒🔗"_g.Font=Enum.Font.GothamBold _g.TextScaled=true _g.TextColor3=Color3.fromRGB(255,255,255)_g.AutoButtonColor=false _27(_g,6)_g.MouseButton1Click:Connect(function()setclipboard(_f)_g.Text="✅"_g.BackgroundColor3=Color3.fromRGB(0,150,100)task.wait(0.7)_g.Text="🛒🔗"_g.BackgroundColor3=Color3.fromRGB(30,30,45)end)local _h=Instance.new("TextButton")_h.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_h.Position=UDim2.new(0,_4("X",5),1,-_4("Y",29))_h.BackgroundColor3=Color3.fromRGB(40,140,80)_h.BackgroundTransparency=0.2 _h.Text="Play"_h.Font=Enum.Font.GothamBold _h.TextScaled=true _h.TextColor3=Color3.new(1,1,1)_h.Parent=_b _27(_h,4)_h.MouseButton1Click:Connect(function()_24(_c)end)local _i=Instance.new("TextButton")_i.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_i.Position=UDim2.new(0.55,0,1,-_4("Y",29))_i.BackgroundColor3=Color3.fromRGB(40,100,160)_i.BackgroundTransparency=0.2 _i.Text="Save"_i.Font=Enum.Font.GothamBold _i.TextScaled=true _i.TextColor3=Color3.new(1,1,1)_i.Parent=_b _27(_i,4)_i.MouseButton1Click:Connect(function()local _j=false for _k,_l in ipairs(_19)do if _l.Id==_a.Id
    then _j=true break end end if not _j then local _m=GetReal(_c)table.insert(_19,{Id=_a.Id,AssetId=_c,Name=_a.Name or "Unknown",AnimationId="rbxassetid://"..tostring(_m or _c),Favorite=false})_22()_i.Text="Saved!"_i.BackgroundColor3=Color3.fromRGB(0,160,100)task.wait(1)_i.Text="Save"_i.BackgroundColor3=Color3.fromRGB(40,100,160)else _i.Text="Already"task.wait(0.7)_i.Text="Save"end end)_29(_b)return _b end
    local _64=Instance.new("ScrollingFrame")_64.Size=UDim2.new(1,-_4("X",16),1,-_4("Y",100))_64.Position=UDim2.new(0,_4("X",8),0,_4("Y",36))_64.CanvasSize=UDim2.new(0,0,0,0)_64.ScrollBarThickness=6 _64.ScrollBarImageColor3=Color3.fromRGB(100,100,140)_64.BackgroundTransparency=1 _64.Parent=_39
    local _65=Instance.new("UIGridLayout",_64)_65.CellSize=UDim2.new(0,_4("X",120),0,_4("Y",180))_65.CellPadding=UDim2.new(0,_4("X",8),0,_4("Y",8))
    local _66=Instance.new("TextLabel",_64)_66.Size=UDim2.new(1,0,0,_4("Y",36))_66.Position=UDim2.new(0,0,0.5,-_4("Y",18))_66.BackgroundTransparency=1 _66.Text="Nothing Silly Here :3 (except me)"_66.TextColor3=Color3.new(1,1,1)_66.Font=Enum.Font.GothamBold _66.TextScaled=true _66.Visible=false
    local _67=Instance.new("TextButton",_39)_67.Size=UDim2.new(0.4,-_4("X",6),0,_4("Y",32))_67.Position=UDim2.new(0,_4("X",4),1,-_4("Y",36))_67.BackgroundColor3=Color3.fromRGB(50,50,70)_67.BackgroundTransparency=0.2 _67.Text="< Prev"_67.Font=Enum.Font.GothamBold _67.TextScaled=true _67.TextColor3=Color3.new(1,1,1)_27(_67,6)
    local _68=Instance.new("TextButton",_39)_68.Size=UDim2.new(0.4,-_4("X",6),0,_4("Y",32))_68.Position=UDim2.new(0.6,_4("X",2),1,-_4("Y",36))_68.BackgroundColor3=Color3.fromRGB(50,50,70)_67.BackgroundTransparency=0.2 _68.Text="Next >"_68.Font=Enum.Font.GothamBold _68.TextScaled=true _68.TextColor3=Color3.new(1,1,1)_27(_68,6)
    local _69=Instance.new("TextBox",_39)_69.Size=UDim2.new(0.2,0,0,_4("Y",32))_69.Position=UDim2.new(0.4,_4("X",2),1,-_4("Y",36))_69.BackgroundTransparency=1 _69.Font=Enum.Font.Gotham _69.TextScaled=true _69.TextColor3=Color3.new(1,1,1)_69.Text="1 / Enter page"
    local _70=Instance.new("TextLabel",_39)_70.Size=UDim2.new(0.3,0,0,_4("Y",24))_70.Position=UDim2.new(0.35,0,1,-_4("Y",68))_70.BackgroundTransparency=1 _70.TextColor3=Color3.fromRGB(255,100,100)_70.Font=Enum.Font.Gotham _70.TextScaled=true _70.Text=""_70.Visible=false
    local function _71()_67.Visible=(_61>1)if _60 and typeof(_60.IsFinished)=="boolean"then _68.Visible=not _60.IsFinished else _68.Visible=true end end

    local _73_id=0
    local function _73(_a)
        _73_id=_73_id+1
        local _myId=_73_id
        _69.Text="Loading..."
        for _b,_c in ipairs(_64:GetChildren()) do if _c:IsA("Frame") then _c:Destroy() end end
        local _d=nil
        local _e,_f=pcall(function() return _a:GetCurrentPage() end)
        if _e then _d=_f else _69.Text="ERROR" return end
        if _myId~=_73_id then return end
        if _d and #_d>0 then
            _66.Visible=false
            local _myTAB=_TAB
            local _count=0
            for _g,_h in ipairs(_d) do
                if _TAB~=_myTAB or _myId~=_73_id then break end
                _63(_h).Parent=_64
                _count=_count+1
                if _count%2==0 then _9.RenderStepped:Wait() end
            end
        else
            _66.Visible=true
        end
        if _myId==_73_id then
            _64.CanvasSize=UDim2.new(0,0,0,_65.AbsoluteContentSize.Y+8)
            _69.Text=tostring(_61).." / Enter page"
            _71()
        end
    end

    local function _74(_a)local _b=_62(_59)if not _b then return nil end for _c=2,_a do if _b.IsFinished then break end local _d,_e=pcall(function()_b:AdvanceToNextPageAsync()end)if not _d then break end end return _b end
    local function _75(_a)_59=_a or ""_61=1 _69.Text="Loading..."_60=_62(_59)if _60 then _73(_60)end end
    _41.MouseButton1Click:Connect(function()_75(_40.Text)end)_40.FocusLost:Connect(function(_a)if _a then _75(_40.Text)end end)_42.MouseButton1Click:Connect(function()_58=_58%#_57+1 _42.Text="Sort: ".._57[_58][2]_75(_59)end)
    local function _76()if not _60 or _60.IsFinished then return end local _a,_b=pcall(function()_60:AdvanceToNextPageAsync()end)if _a then _61+=1 _73(_60)else local _c=_61+1 local _d=_74(_c)if _d then _60=_d _61=math.min(_c,_61+1)_73(_60)end end end
    local function _77()if not _60 or _61<=1 then return end local _a,_b=pcall(function()_60:AdvanceToPreviousPageAsync()end)if _a
    then _61=math.max(1,_61-1)_73(_60)else local _c=math.max(1,_61-1)local _d=_74(_c)if _d then _60=_d _61=_c _73(_60)end end end
    _68.MouseButton1Click:Connect(_76)_67.MouseButton1Click:Connect(_77)
    _10.InputBegan:Connect(function(_a,_b)if _b then return end if _a.UserInputType==Enum.UserInputType.Keyboard and _a.KeyCode==Enum.KeyCode.Right then _76()elseif _a.KeyCode==Enum.KeyCode.Left then _77()end end)
    _69.FocusLost:Connect(function(_a)if not _a then return end local _b=_69.Text:gsub("%s+","")local _c=tonumber(_b:match("%d+"))if not _c or _c<1 then _70.Text="Invalid page number"_70.Visible=true task.delay(2,function()if _70 then _70.Visible=false end end)_69.Text="Page "..tostring(_61)return end local _d=math.floor(_c)if _d==_61 then _69.Text="Page "..tostring(_61)return end _69.Text="Loading..."local _e,_f=pcall(function()return _74(_d)end)if not _e or not _f then _70.Text="Unable to fetch page"_70.Visible=true task.delay(2,function()if _70 then _70.Visible=false end end)_69.Text="Page "..tostring(_61)return end _60=_f _61=math.max(1,_d)_73(_60)end)
    local function _78(_a)local _b=Instance.new("Frame")_b.Size=UDim2.new(0,_4("X",120),0,_4("Y",200))_b.BackgroundColor3=Color3.fromRGB(25,25,35)_b.BackgroundTransparency=0.2 _27(_b,8)_28(_b,Color3.fromRGB(60,60,90),1)local _c=Instance.new("ImageLabel")_c.Size=UDim2.new(1,-_4("X",10),0,_4("Y",90))_c.Position=UDim2.new(0,_4("X",5),0,_4("Y",5))_c.BackgroundTransparency=1 _c.ScaleType=Enum.ScaleType.Fit _c.Image="rbxthumb://type=Asset&id=11768914234&w=150&h=150"_c.Parent=_b _27(_c,4)local _d=Instance.new("TextLabel")_d.Size=UDim2.new(1,-_4("X",10),0,_4("Y",28))_d.Position=UDim2.new(0,_4("X",5),0,_4("Y",100))_d.BackgroundTransparency=1 _d.Text=_a.Name or "Unknown"_d.TextScaled=true _d.TextWrapped=true _d.Font=Enum.Font.GothamBold _d.TextColor3=Color3.new(1,1,1)_d.Parent=_b local _e=Instance.new("TextButton")_e.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_e.Position=UDim2.new(0,_4("X",5),1,-_4("Y",29))_e.BackgroundColor3=Color3.fromRGB(40,140,80)_e.BackgroundTransparency=0.2 _e.Text="Play"_e.Font=Enum.Font.GothamBold _e.TextScaled=true _e.TextColor3=Color3.new(1,1,1)_e.Parent=_b
    _27(_e,4)_e.MouseButton1Click:Connect(function()_24(_a.Id)end)local _f=Instance.new("TextButton")_f.Size=UDim2.new(0.45,-_4("X",5),0,_4("Y",24))_f.Position=UDim2.new(0.55,0,1,-_4("Y",29))_f.BackgroundColor3=Color3.fromRGB(160,50,50)_f.BackgroundTransparency=0.2 _f.Text="Remove"_f.Font=Enum.Font.GothamBold _f.TextScaled=true _f.TextColor3=Color3.new(1,1,1)_f.Parent=_b _27(_f,4)local _g=Instance.new("TextButton")_g.Size=UDim2.new(0,_4("X",40),0,_4("Y",24))_g.Position=UDim2.new(0.5,-_4("X",20),0,_4("Y",5))_g.BackgroundColor3=Color3.fromRGB(50,50,80)_g.BackgroundTransparency=0.2 _g.Text="Copy AnimId"_g.Font=Enum.Font.GothamBold _g.TextScaled=true _g.TextColor3=Color3.new(1,1,1)_g.Parent=_b _27(_g,4)_g.MouseButton1Click:Connect(function()if setclipboard then setclipboard(_a.AnimationId:gsub("rbxassetid://",""))end _g.Text="Copied!"task.wait(0.7)_g.Text="Copy AnimId"end)local _h=Instance.new("TextButton")_h.Size=UDim2.new(0,_4("X",24),0,_4("Y",24))_h.Position=UDim2.new(1,-_4("X",30),0,_4("Y",5))_h.Text=_a.Favorite and "★"or "☆"_h.Font=Enum.Font.GothamBold _h.TextScaled=true _h.TextColor3=Color3.fromRGB(255,220,50)_h.BackgroundTransparency=1 _h.Parent=_b _h.MouseButton1Click:Connect(function()_a.Favorite=not _a.Favorite _h.Text=_a.Favorite and "★"or "☆"_22()_80()end)_f.MouseButton1Click:Connect(function()for _i,_j in ipairs(_19)do if _j.Id==_a.Id then table.remove(_19,_i)_22()_80()break end end end)_29(_b)return _b end

    local _80_id=0
    function _80()
        _80_id=_80_id+1
        local _myId=_80_id
        for _a,_b in ipairs(_45:GetChildren())do if _b:IsA("Frame")then _b:Destroy()end end
        local _c=(_44.Text or ""):lower()
        local _d={}
        for _e,_f in ipairs(_19) do
            if _c=="" or (_f.Name and _f.Name:lower():find(_c)) then table.insert(_d,_f) end
        end
        table.sort(_d,function(_g,_h)if _g.Favorite~=_h.Favorite then return _g.Favorite else return false end end)
        if #_d>0 then
            _46.Visible=false
            local _myTAB=_TAB
            local _count=0
            for _i,_j in ipairs(_d) do
                if _TAB~=_myTAB or _myId~=_80_id then break end
                _78(_j).Parent=_45
                _count=_count+1
                if _count%25==0 then _9.RenderStepped:Wait() end
            end
        else
            _46.Visible=true
        end
        if _myId==_80_id then
            _45.CanvasSize=UDim2.new(0,0,0,_47.AbsoluteContentSize.Y+8)
        end
    end

    _36.MouseButton1Click:Connect(function()_TAB+=1 _39.Visible=true _43.Visible=false _36.BackgroundColor3=Color3.fromRGB(30,30,80)_37.BackgroundColor3=Color3.fromRGB(20,50,20)end)
    _44:GetPropertyChangedSignal("Text"):Connect(_80)
    _37.MouseButton1Click:Connect(function()_TAB+=1 _39.Visible=false _43.Visible=true
    _36.BackgroundColor3=Color3.fromRGB(20,20,40)_37.BackgroundColor3=Color3.fromRGB(30,80,30)_80()end)
    _75("")local _79=_26 local function _81()_79.Enabled=not _79.Enabled end local _82=Instance.new("ScreenGui")_82.Name="ToggleButtonGui"_82.ResetOnSpawn=false _82.Parent=_25 _82.Enabled=true local _83=Instance.new("TextButton")_83.Parent=_82 _83.Text="G"_83.Font=Enum.Font.GothamSemibold _83.TextScaled=true _83.Size=UDim2.new(0,50,0,50)_83.Position=UDim2.new(0,20,0.5,-50)_83.AnchorPoint=Vector2.new(0,0.5)_83.BackgroundColor3=Color3.fromRGB(25,25,35)_83.BackgroundTransparency=0.2 _83.TextColor3=Color3.new(1,1,1)_83.Active=true pcall(function()_83.Draggable=true end)_27(_83,12)_28(_83,Color3.fromRGB(60,60,100),2)local _84=Instance.new("UIAspectRatioConstraint")_84.Parent=_83 _84.AspectRatio=1 _83.MouseButton1Click:Connect(_81)_10.InputBegan:Connect(function(_a,_b)if _b then return end if _a.UserInputType==Enum.UserInputType.Keyboard and _a.KeyCode==Enum.KeyCode.G then _81()end end)_26.Enabled=true _80()

    -- Collision disable functionality
    task.spawn(function()
        local RunService = game:GetService("RunService")
        local Players = game.Players
        local player = Players.LocalPlayer

        local function setupCollision(character)
            local hrp = character:WaitForChild("HumanoidRootPart")
            local bodyParts = {}

            hrp.CanCollide = true

            local function addPart(part)
                if part:IsA("BasePart") and part ~= hrp then
                    table.insert(bodyParts, part)
                end
            end

            for _, part in pairs(character:GetDescendants()) do
                addPart(part)
            end

            local descendantConnection = character.DescendantAdded:Connect(addPart)

            local heartbeatConnection
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if not character or not character.Parent then
                    heartbeatConnection:Disconnect()
                    descendantConnection:Disconnect()
                    return
                end

                for i = 1, #bodyParts do
                    local p = bodyParts[i]
                    if p and p.Parent then
                        p.CanCollide = false
                    end
                end
            end)
        end

        if player.Character then
            setupCollision(player.Character)
        end

        player.CharacterAdded:Connect(setupCollision)
    end)
end

-- Add button to main GUI to open Gaze Emotes
local gazeBtnWrap = Instance.new("Frame")
gazeBtnWrap.Parent = frame
gazeBtnWrap.BackgroundTransparency = 1
gazeBtnWrap.Size = UDim2.new(1, 0, 0, 28)
gazeBtnWrap.LayoutOrder = 11
gazeBtnWrap.ZIndex = 3

local gazeButton = makeBtn(gazeBtnWrap, "🌐 Catalog Emotes", Color3.fromRGB(40, 60, 100), 4)
gazeButton.MouseButton1Click:Connect(function()
    initGazeEmotes()
end)
