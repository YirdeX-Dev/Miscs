local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local BLACKHOLE_RANGE = 100000000
local currentTarget = nil
local blacklistedPlayers = {}
local playerButtons = {}
local friendList = {} 

local currentCharacter = nil
local currentHumanoidRootPart = nil

local function updateCharacter()
    currentCharacter = LocalPlayer.Character
    if currentCharacter then
        currentHumanoidRootPart = currentCharacter:WaitForChild("HumanoidRootPart")
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    currentCharacter = char
    currentHumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)
updateCharacter()

--  获取好友
local function getFriendList()
    friendList = {}
    --Friends获取好友
    local FriendsService = game:GetService("Friends")
    
    --GetFriendsAsync
    local success, result = pcall(function()
        return FriendsService:GetFriendsAsync()
    end)
    
    if success and result then
        for _, friendInfo in pairs(result) do
            friendList[friendInfo.Name] = true
        end
    end
    
    if next(friendList) == nil then
        pcall(function()
            local friendIds = FriendsService:GetFriendIds()
            for _, userId in pairs(friendIds) do
                local player = Players:GetPlayerByUserId(userId)
                if player then
                    friendList[player.Name] = true
                end
            end
        end)
    end
    
    return friendList
end

-- 获取好友列表
local function refreshFriendList()
    local FriendsService = game:GetService("Friends")
    local success, result = pcall(function()
        return FriendsService:GetFriendsAsync()
    end)
    
    if success and result then
        friendList = {}
        for _, friendInfo in pairs(result) do
            friendList[friendInfo.Name] = true
        end
    end
end

-- 初始列表
getFriendList()

-- 下一个目标 
local function getNextTarget()
    local players = Players:GetPlayers()
    local target = nil
    local startIndex = 0
    
    if currentTarget then
        for i, p in ipairs(players) do
            if p == currentTarget then
                startIndex = i
                break
            end
        end
    end
    
    for i = startIndex + 1, #players do
        local p = players[i]
        if p ~= LocalPlayer 
           and p.Character 
           and p.Character:FindFirstChild("HumanoidRootPart")
           and p.Character:FindFirstChild("Humanoid")
           and p.Character.Humanoid.Health > 0
           and not blacklistedPlayers[p.Name] then
            target = p
            break
        end
    end
    
    if not target then
        for _, p in ipairs(players) do
            if p ~= LocalPlayer 
               and p.Character 
               and p.Character:FindFirstChild("HumanoidRootPart")
               and p.Character:FindFirstChild("Humanoid")
               and p.Character.Humanoid.Health > 0
               and not blacklistedPlayers[p.Name] then
                target = p
                break
            end
        end
    end
    
    currentTarget = target
    return target
end

--获取位置
local function getTargetRootPart()
    if currentTarget and currentTarget.Character then
        return currentTarget.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

--检查目标
local function isTargetValid()
    if not currentTarget then return false end
    if not currentTarget.Parent then return false end
    if not currentTarget.Character then return false end
    
    local rootPart = currentTarget.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local humanoid = currentTarget.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if blacklistedPlayers[currentTarget.Name] then return false end
    
    if currentHumanoidRootPart then
        local distance = (rootPart.Position - currentHumanoidRootPart.Position).Magnitude
        if distance > 10000 then
            return false
        end
    end
    
    return true
end

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424,14.46262424,14.46262424)
    }

    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge) end)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function ForcePart(v)
    if not currentHumanoidRootPart then return end
    
    local targetRoot = getTargetRootPart()
    if not targetRoot then
        getNextTarget()
        targetRoot = getTargetRootPart()
        if not targetRoot then return end
    end
    
    if v:IsA("BasePart") and not v.Anchored 
       and not (currentCharacter and v:IsDescendantOf(currentCharacter))
       and v.Name ~= "Handle"
       and (v.Position - currentHumanoidRootPart.Position).Magnitude < BLACKHOLE_RANGE
    then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
        if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
        if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end
        
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(99999999, 99999999, 99999999)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = 9999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1

        Network.RetainPart(v)
    end
end

local blackHoleActive = false
local blackHoleConnection = nil
local updateConnection = nil
local switchTimer = 0

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    if blackHoleActive then
        getNextTarget()
        
        for _, v in next, Workspace:GetDescendants() do
            ForcePart(v)
        end

        if blackHoleConnection then blackHoleConnection:Disconnect() end
        blackHoleConnection = Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then
                ForcePart(v)
            end
        end)

        if updateConnection then updateConnection:Disconnect() end
        updateConnection = RunService.RenderStepped:Connect(function()
            if blackHoleActive then
                if currentCharacter and currentHumanoidRootPart then
                    local targetRoot = getTargetRootPart()
                    if targetRoot then
                        Attachment1.WorldCFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
                    else
                        getNextTarget()
                    end
                end
            end
        end)
        
    else
        if blackHoleConnection then blackHoleConnection:Disconnect() end
        if updateConnection then updateConnection:Disconnect() end
        currentTarget = nil
    end
end

--自动切换目标
RunService.Heartbeat:Connect(function(deltaTime)
    if not blackHoleActive then return end
    if not currentHumanoidRootPart then return end
    
    switchTimer = switchTimer + deltaTime
    
    if switchTimer >= 0.5 then
        switchTimer = 0
        
        if not isTargetValid() then
            getNextTarget()
            if blackHoleActive then
                local targetName = currentTarget and currentTarget.Name or "无"
                statusLabel.Text = "已开启 | 目标: " .. targetName
            end
            return
        end
        
        local targetRoot = getTargetRootPart()
        if targetRoot then
            local velocity = targetRoot.AssemblyLinearVelocity.Magnitude
            if velocity > 30 then
                getNextTarget()
                local targetName = currentTarget and currentTarget.Name or "无"
                statusLabel.Text = "已开启 | 目标: " .. targetName
                return
            end
        end
        
        if targetRoot then
            local count = 0
            for _, part in pairs(Network.BaseParts) do
                if part:IsDescendantOf(Workspace) then
                    local dist = (part.Position - targetRoot.Position).Magnitude
                    if dist < 5 then
                        count = count + 1
                        if count > 3 then
                            break
                        end
                    end
                end
            end
            
            if count > 3 then
                getNextTarget()
                local targetName = currentTarget and currentTarget.Name or "无"
                statusLabel.Text = "已开启 | 目标: " .. targetName
            end
        end
    end
end)

--UI部分
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 350)
mainFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "自动甩飞"
title.TextColor3 = Color3.fromRGB(0,170,255)
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0, 2)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(0,170,255)
minBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
minBtn.Parent = mainFrame
Instance.new("UICorner", minBtn)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "x"
closeBtn.TextColor3 = Color3.fromRGB(0,170,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 180, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -90, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.Text = "开启"
toggleBtn.TextColor3 = Color3.fromRGB(0,170,255)
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn)

statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 0, 0, 95)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "已关闭 | 目标: 无"
statusLabel.TextColor3 = Color3.fromRGB(0,170,255)
statusLabel.Parent = mainFrame

--玩家列表扩展UI
local expandBtn = Instance.new("TextButton")
expandBtn.Size = UDim2.new(0, 25, 0, 25)
expandBtn.Position = UDim2.new(1, -30, 0, 35)
expandBtn.Text = "↓"
expandBtn.TextColor3 = Color3.fromRGB(0,170,255)
expandBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
expandBtn.Parent = mainFrame
Instance.new("UICorner", expandBtn)

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1, 0, 0, 180)
playerListFrame.Position = UDim2.new(0, 0, 0, 130)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
playerListFrame.Visible = false
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListFrame.ScrollBarThickness = 4
playerListFrame.Parent = mainFrame
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 8)

local playerListOpen = false

--刷新玩家列表
local function refreshPlayerList()
    for _, child in pairs(playerListFrame:GetChildren()) do
        child:Destroy()
    end
    playerButtons = {}
    
    --刷新好友列表
    refreshFriendList()
    
    local players = Players:GetPlayers()
    local yPos = 5
    
    for _, player in pairs(players) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 30)
            btn.Position = UDim2.new(0.05, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            
            -- 检查好友
            local isFriend = friendList[player.Name] == true
            local displayName = player.Name
            
            --添加标记
            if isFriend then
                displayName = player.Name .. " (好友)"
                btn.BackgroundColor3 = Color3.fromRGB(30,60,30)
            end
            
            -- 白名单检测
            if blacklistedPlayers[player.Name] then
                btn.BackgroundColor3 = Color3.fromRGB(80,30,30)
                displayName = player.Name .. " ⛔"
                if isFriend then
                    displayName = player.Name .. " ⛔ (好友)"
                end
            end
            
            btn.Text = displayName
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.Parent = playerListFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            
            btn.MouseButton1Click:Connect(function()
                if blacklistedPlayers[player.Name] then
                    blacklistedPlayers[player.Name] = nil
                else
                    blacklistedPlayers[player.Name] = true
                end
                if currentTarget and currentTarget.Name == player.Name then
                    getNextTarget()
                end
                refreshPlayerList()
            end)
            
            table.insert(playerButtons, btn)
            yPos = yPos + 35
        end
    end
    
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

--定时刷新好友列表
task.spawn(function()
    while task.wait(30) do
        if playerListOpen then
            refreshFriendList()
            refreshPlayerList()
        end
    end
end)

expandBtn.MouseButton1Click:Connect(function()
    playerListOpen = not playerListOpen
    playerListFrame.Visible = playerListOpen
    expandBtn.Text = playerListOpen and "▼" or "▶"
    
    if playerListOpen then
        refreshPlayerList()
        mainFrame.Size = UDim2.new(0, 280, 0, 350)
    else
        mainFrame.Size = UDim2.new(0, 280, 0, 170)
    end
end)

Players.PlayerAdded:Connect(function()
    if playerListOpen then refreshPlayerList() end
end)

Players.PlayerRemoving:Connect(function()
    if playerListOpen then refreshPlayerList() end
end)

local minimized = false
local miniButton = nil

minBtn.MouseButton1Click:Connect(function()
    if minimized then return end
    minimized = true
    mainFrame.Visible = false

    miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(0, 40, 0, 40)
    miniButton.Position = UDim2.new(0.8, 0, 0.8, 0)
    miniButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
    miniButton.Text = "打开"
    miniButton.TextColor3 = Color3.fromRGB(0,170,255)
    miniButton.TextSize = 24
    miniButton.Parent = screenGui
    Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1,0)

    miniButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        miniButton:Destroy()
        minimized = false
    end)
end)

closeBtn.MouseButton1Click:Connect(function()
    if blackHoleActive then
        toggleBlackHole()
    end
    if miniButton then miniButton:Destroy() end
    screenGui:Destroy()
end)

toggleBtn.MouseButton1Click:Connect(function()
    toggleBlackHole()
    if blackHoleActive then
        toggleBtn.Text = "关闭"
        local targetName = currentTarget and currentTarget.Name or "无"
        statusLabel.Text = "已开启 | 目标: " .. targetName
    else
        toggleBtn.Text = "开启"
        statusLabel.Text = "已关闭 | 目标: 无"
    end
end)