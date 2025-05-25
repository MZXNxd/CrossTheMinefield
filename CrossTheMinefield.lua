--[[
    🔥 Auto-Miner + GUI Draggable + Discord Link + Minimize & Close Buttons + Teleport + Fly Script Button
    📌 By MZXN
    🛠️ UI Movable + Mine Activation + Window Controls + Teleport + Fly Script
]]

-- 👉 Copy Discord link
local url = "https://discord.gg/JZpvCrvgTK"
if setclipboard then
    setclipboard(url)
    if pcall(function() return game:GetService("StarterGui"):SetCore("SendNotification", {}) end) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Discord Copied",
            Text = "Join our Discord server 📋",
            Duration = 5
        })
    end
end

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Variables
local rootPart
local enabled = false -- starts disabled as requested

-- Update HumanoidRootPart
local function updateRoot()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    rootPart = character:WaitForChild("HumanoidRootPart", 5)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateRoot()
end)

updateRoot()

-- Get mine parts (parents of TouchTransmitter)
local function getTouchParts(folder)
    local parts = {}
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent:IsA("BasePart") then
            table.insert(parts, obj.Parent)
        end
    end
    return parts
end

-- Main loop for mining
RunService.Heartbeat:Connect(function()
    if not enabled or not rootPart then return end

    local mines = Workspace:FindFirstChild("Mines")
    if not mines then return end

    local parts = getTouchParts(mines)

    for _, part in ipairs(parts) do
        pcall(function()
            firetouchinterest(rootPart, part, 0)
            firetouchinterest(rootPart, part, 1)
        end)
    end
end)

-- 🎨 Create GUI Draggable with vertical buttons and top-right close/minimize
local function createGUI()
    local oldGui = CoreGui:FindFirstChild("AutoMinerGUI")
    if oldGui then oldGui:Destroy() end

    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "AutoMinerGUI"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 200, 0, 200) -- Más alto para otro botón
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    -- Minimize Button (arriba derecha)
    local minimizeButton = Instance.new("TextButton", frame)
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.Text = "—"
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.TextSize = 24
    minimizeButton.BorderSizePixel = 0
    minimizeButton.AutoButtonColor = true

    -- Close Button (arriba derecha, al lado de minimizar)
    local closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 20
    closeButton.BorderSizePixel = 0
    closeButton.AutoButtonColor = true

    -- Toggle AutoMiner Button
    local toggleButton = Instance.new("TextButton", frame)
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 40)
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Text = "AutoMiner: OFF"
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 18
    toggleButton.BorderSizePixel = 0

    -- Teleport Button (debajo de toggle)
    local teleportButton = Instance.new("TextButton", frame)
    teleportButton.Size = UDim2.new(1, -20, 0, 40)
    teleportButton.Position = UDim2.new(0, 10, 0, 85)
    teleportButton.BackgroundColor3 = Color3.fromRGB(40, 80, 160)
    teleportButton.TextColor3 = Color3.new(1, 1, 1)
    teleportButton.Text = "Teleport to the end"
    teleportButton.Font = Enum.Font.SourceSansBold
    teleportButton.TextSize = 16
    teleportButton.BorderSizePixel = 0
    teleportButton.AutoButtonColor = true

    -- Fly Script Button (nuevo botón debajo del teleport)
    local flyButton = Instance.new("TextButton", frame)
    flyButton.Size = UDim2.new(1, -20, 0, 40)
    flyButton.Position = UDim2.new(0, 10, 0, 130)
    flyButton.BackgroundColor3 = Color3.fromRGB(100, 45, 180)
    flyButton.TextColor3 = Color3.new(1, 1, 1)
    flyButton.Text = "Fly Script"
    flyButton.Font = Enum.Font.SourceSansBold
    flyButton.TextSize = 16
    flyButton.BorderSizePixel = 0
    flyButton.AutoButtonColor = true

    -- Credit Label (footer) más abajo con margen
    local credit = Instance.new("TextLabel", frame)
    credit.Size = UDim2.new(1, -20, 0, 20)
    credit.Position = UDim2.new(0, 10, 0, 180)
    credit.BackgroundColor3 = frame.BackgroundColor3 -- mismo fondo que frame
    credit.BackgroundTransparency = frame.BackgroundTransparency
    credit.TextColor3 = Color3.fromRGB(150, 150, 150)
    credit.Text = "By MZXN"
    credit.Font = Enum.Font.SourceSansItalic
    credit.TextSize = 14
    credit.TextXAlignment = Enum.TextXAlignment.Center

    -- Toggle AutoMiner functionality
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.Text = enabled and "AutoMiner: ON" or "AutoMiner: OFF"
    end)

    -- Teleport to fixed position functionality
    teleportButton.MouseButton1Click:Connect(function()
        if rootPart then
            rootPart.CFrame = CFrame.new(932.3, 109.7, -3373.6)
        end
    end)

    -- Fly Script functionality (tu link aquí)
    flyButton.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        end)
        if not success then
            warn("Fly script failed to load:", err)
        end
    end)

    -- Minimize functionality (oculta botones y credit, reduce tamaño)
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        if not minimized then
            frame.Size = UDim2.new(0, 200, 0, 40)
            toggleButton.Visible = false
            teleportButton.Visible = false
            flyButton.Visible = false
            credit.Visible = false
            minimized = true
        else
            frame.Size = UDim2.new(0, 200, 0, 200)
            toggleButton.Visible = true
            teleportButton.Visible = true
            flyButton.Visible = true
            credit.Visible = true
            minimized = false
        end
    end)

    -- Close functionality (disable and remove GUI)
    closeButton.MouseButton1Click:Connect(function()
        enabled = false
        screenGui:Destroy()
    end)
end

createGUI()
