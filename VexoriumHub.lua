local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UIStroke_Main = Instance.new("UIStroke")
local BackgroundImage = Instance.new("ImageLabel")
local TitleLabel = Instance.new("TextLabel")
local LogoImage = Instance.new("ImageLabel")
local UICorner_Logo = Instance.new("UICorner")

-- Sidebar (onglets à gauche)
local SidebarFrame = Instance.new("Frame")
local UICorner_Sidebar = Instance.new("UICorner")
local ActiveIndicator = Instance.new("Frame")
local UICorner_Indicator = Instance.new("UICorner")
local VersionLabel = Instance.new("TextLabel")

-- Contenu (à droite de la sidebar)
local ContentFrame = Instance.new("Frame")
local ButtonFrame = Instance.new("Frame")
local UICorner_Btn = Instance.new("UICorner")
local UIGradient_Btn = Instance.new("UIGradient")
local TextButton = Instance.new("TextButton")

ScreenGui.Name = "VexoriumGUI"

if RunService:IsStudio() then
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
else
    ScreenGui.Parent = CoreGui
end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ===================== WINDOW =====================
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 1 -- pour l'animation d'ouverture (fade-in)

UICorner_Main.CornerRadius = UDim.new(0, 12)
UICorner_Main.Parent = MainFrame

UIStroke_Main.Color = Color3.fromRGB(60, 60, 60)
UIStroke_Main.Thickness = 1
UIStroke_Main.Parent = MainFrame

-- Fond en image
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Parent = MainFrame
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Image = "rbxassetid://98601834782862"
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ImageTransparency = 1
BackgroundImage.ZIndex = 0

-- ===================== SIDEBAR (gauche) =====================
SidebarFrame.Name = "SidebarFrame"
SidebarFrame.Parent = MainFrame
SidebarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SidebarFrame.Position = UDim2.new(0, 0, 0, 0)
SidebarFrame.Size = UDim2.new(0, 150, 1, 0)
SidebarFrame.ZIndex = 2
SidebarFrame.BackgroundTransparency = 1

UICorner_Sidebar.CornerRadius = UDim.new(0, 12)
UICorner_Sidebar.Parent = SidebarFrame

-- Logo dans la sidebar
LogoImage.Name = "LogoImage"
LogoImage.Parent = SidebarFrame
LogoImage.BackgroundTransparency = 1
LogoImage.ImageTransparency = 1
LogoImage.Position = UDim2.new(0.5, 0, 0, 12)
LogoImage.AnchorPoint = Vector2.new(0.5, 0)
LogoImage.Size = UDim2.new(0, 36, 0, 36)
LogoImage.Image = "rbxthumb://type=Asset&id=98601834782862&w=420&h=420"
LogoImage.ScaleType = Enum.ScaleType.Crop
LogoImage.ClipsDescendants = true
LogoImage.ZIndex = 3

UICorner_Logo.CornerRadius = UDim.new(0, 90)
UICorner_Logo.Parent = LogoImage

-- Indicateur d'onglet actif (petite barre qui se déplace)
ActiveIndicator.Name = "ActiveIndicator"
ActiveIndicator.Parent = SidebarFrame
ActiveIndicator.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
ActiveIndicator.BorderSizePixel = 0
ActiveIndicator.Position = UDim2.new(0, 0, 0, 60)
ActiveIndicator.Size = UDim2.new(0, 3, 0, 36)
ActiveIndicator.ZIndex = 4
ActiveIndicator.BackgroundTransparency = 1

UICorner_Indicator.CornerRadius = UDim.new(0, 4)
UICorner_Indicator.Parent = ActiveIndicator

-- Version en bas à gauche
VersionLabel.Name = "VersionLabel"
VersionLabel.Parent = SidebarFrame
VersionLabel.BackgroundTransparency = 1
VersionLabel.AnchorPoint = Vector2.new(0, 1)
VersionLabel.Position = UDim2.new(0, 12, 1, -10)
VersionLabel.Size = UDim2.new(1, -20, 0, 16)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Text = "v1.0.0"
VersionLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
VersionLabel.TextSize = 12
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.TextTransparency = 1
VersionLabel.ZIndex = 3

-- Fonction pour créer un onglet animé
local tabButtons = {}

local function CreateTab(name, yPos, isFirst)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = SidebarFrame
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BackgroundTransparency = isFirst and 0 or 1
    TabButton.Position = UDim2.new(0.5, 0, 0, yPos)
    TabButton.AnchorPoint = Vector2.new(0.5, 0)
    TabButton.Size = UDim2.new(0.85, 0, 0, 36)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = name
    TabButton.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    TabButton.TextSize = 13
    TabButton.TextTransparency = 1
    TabButton.AutoButtonColor = false
    TabButton.ZIndex = 3

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton

    tabButtons[TabButton] = yPos

    -- Survol fluide
    TabButton.MouseEnter:Connect(function()
        if ActiveIndicator.Position.Y.Offset ~= yPos then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if ActiveIndicator.Position.Y.Offset ~= yPos then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end)

    -- Clic : déplace l'indicateur et met à jour les couleurs
    TabButton.MouseButton1Click:Connect(function()
        for btn, _ in pairs(tabButtons) do
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TweenService:Create(ActiveIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 0, 0, yPos)
        }):Play()
        print(name.." sélectionné !")
    end)

    return TabButton
end

CreateTab("Accueil", 60, true)
CreateTab("Scripts", 102)
CreateTab("Settings", 144)
CreateTab("Crédits", 186)

-- ===================== CONTENU (droite) =====================
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.ZIndex = 2

-- Titre
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = ContentFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.Size = UDim2.new(1, -30, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "VexoriumHub"
TitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextTransparency = 1
TitleLabel.ZIndex = 3

-- Structure du bouton "TEST"
ButtonFrame.Name = "ButtonFrame"
ButtonFrame.Parent = ContentFrame
ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ButtonFrame.Position = UDim2.new(0.07, 0, 0.3, 0)
ButtonFrame.Size = UDim2.new(0.86, 0, 0, 55)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.ZIndex = 3

UICorner_Btn.CornerRadius = UDim.new(0, 8)
UICorner_Btn.Parent = ButtonFrame

UIGradient_Btn.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
})
UIGradient_Btn.Rotation = 45
UIGradient_Btn.Parent = ButtonFrame
UIGradient_Btn.Enabled = false -- activé après l'animation d'ouverture

TextButton.Name = "TextButton"
TextButton.Parent = ButtonFrame
TextButton.BackgroundTransparency = 1
TextButton.Position = UDim2.new(0, 15, 0, 0)
TextButton.Size = UDim2.new(1, -25, 1, 0)
TextButton.Font = Enum.Font.GothamBold
TextButton.Text = "TEST"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 18
TextButton.TextXAlignment = Enum.TextXAlignment.Left
TextButton.TextTransparency = 1
TextButton.AutoButtonColor = false
TextButton.ZIndex = 4

TextButton.MouseEnter:Connect(function()
    TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)
TextButton.MouseLeave:Connect(function()
    TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)
TextButton.MouseButton1Click:Connect(function()
    -- petit effet de "pulse" au clic
    TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {Size = UDim2.new(0.84, 0, 0, 53)}):Play()
    task.wait(0.08)
    TweenService:Create(ButtonFrame, TweenInfo.new(0.12), {Size = UDim2.new(0.86, 0, 0, 55)}):Play()
    print("Bouton cliqué !")
end)

-- ===================== ANIMATION D'OUVERTURE =====================
local function FadeIn(obj, prop, target, time)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[prop] = target}):Play()
end

task.spawn(function()
    -- petit effet de "scale-up" du cadre
    MainFrame.Size = UDim2.new(0, 540, 0, 340)
    FadeIn(MainFrame, "Size", UDim2.new(0, 600, 0, 380), 0.35)
    FadeIn(MainFrame, "BackgroundTransparency", 0, 0.3)
    task.wait(0.1)
    FadeIn(BackgroundImage, "ImageTransparency", 0, 0.4)
    FadeIn(SidebarFrame, "BackgroundTransparency", 0, 0.3)
    FadeIn(LogoImage, "ImageTransparency", 0, 0.3)
    FadeIn(VersionLabel, "TextTransparency", 0.4, 0.3)
    task.wait(0.1)
    FadeIn(TitleLabel, "TextTransparency", 0, 0.3)
    for btn, _ in pairs(tabButtons) do
        FadeIn(btn, "TextTransparency", 0, 0.3)
    end
    FadeIn(ActiveIndicator, "BackgroundTransparency", 0, 0.3)
    task.wait(0.05)
    FadeIn(ButtonFrame, "BackgroundTransparency", 0, 0.3)
    FadeIn(TextButton, "TextTransparency", 0, 0.3)
    task.wait(0.2)
    UIGradient_Btn.Enabled = true
end)
