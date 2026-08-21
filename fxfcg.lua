-- ==================== 第 1 段：初始化 ====================

if not getgenv().shared then
    getgenv().shared = {}
end

if not getgenv().voidware_loaded then
    getgenv().voidware_loaded = true
else
    local suc = pcall(function()
        shared.Voidware_InkGame_Library:Unload()
    end)
    if not suc then
        return 
    end
end

local isNew = false
pcall(function()
    if not isfolder("voidware_linoria") then makefolder("voidware_linoria"); isNew = true; end
    for _, v in pairs({"voidware_linoria/ink_game", "voidware_linoria/themes"}) do
        if not isfolder(v) then makefolder(v); isNew = true; end
    end
    for _, v in pairs({"voidware_linoria/ink_game/settings", "voidware_linoria/ink_game/themes"}) do
        if not isfolder(v) then makefolder(v); isNew = true; end
    end
    if isNew then
        writefile("voidware_linoria/themes/default.txt", "Jester")
        local suc = pcall(function()
            writefile("voidware_linoria/ink_game/settings/default.json", game:HttpGet("https://raw.githubusercontent.com/Erchobg/VoidwareProfiles/refs/heads/main/InkGame/ink_game/settings/default.json", true))
        end)
        if suc then
            writefile("voidware_linoria/ink_game/settings/autoload.txt", "default")
        end
    end
end)

task.spawn(function()
    pcall(function()
        if not isfile("Local_VW_Update_Log.json") then
            shared.UpdateLogBypass = true
        end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWExtra/main/VWUpdateLog.lua", true))()
        shared.UpdateLogBypass = nil
    end)
end)

local allowedlibs = {"Obsidian", "LinoriaLib"}
local default = "Obsidian"
local function getLibrary()
    local res = default
    if not isfile("Voidware_InkGame_Library_Choice.txt") then
        writefile("Voidware_InkGame_Library_Choice.txt", res)
    else
        local suc, opt = pcall(function()
            return readfile("Voidware_InkGame_Library_Choice.txt")
        end)
        if suc then
            res = tostring(opt)
        end
    end
    if not table.find(allowedlibs, res) then
        res = default
    end
    writefile("Voidware_InkGame_Library_Choice.txt", res)
    return res
end

local suc, targetlib = pcall(getLibrary)
if not suc then
    targetlib = default
end

local repo = "https://raw.githubusercontent.com/mstudio45/"..tostring(targetlib).."/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
shared.Voidware_InkGame_Library = Library
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options
local Toggles
if targetlib == "Obsidian" then
    Options = getgenv().Library.Options
    Toggles = getgenv().Library.Toggles
else 
    Options = getgenv().Linoria.Options
    Toggles = getgenv().Linoria.Toggles   
end

local Window = Library:CreateWindow({
    Title = "NOL［墨水游戏］",
    Footer = "免费版/付费版",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    TabPadding = 2,
    MenuFadeTime = 0
})

local Tabs = {
    Main = Window:AddTab("主要功能", "gamepad-2"),
    Other = Window:AddTab("其他功能", "settings"),
    Misc = Window:AddTab("杂项区", "wrench"),
    Visuals = Window:AddTab("绘制区", "eye"),
    ["UI Settings"] = Window:AddTab("UI 调试", "sliders-horizontal"),
}

-- ==================== Maid 系统 ====================
local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({Tasks = {}}, Maid)
end

function Maid:Add(task)
    if typeof(task) == "RBXScriptConnection" or (typeof(task) == "Instance" and task.Destroy) or typeof(task) == "function" then
        table.insert(self.Tasks, task)
    end
    return task
end

function Maid:GiveTask(task)
    return self:Add(task)
end

function Maid:Clean()
    for _, task in ipairs(self.Tasks) do
        pcall(function()
            if typeof(task) == "RBXScriptConnection" then
                task:Disconnect()
            elseif typeof(task) == "Instance" then
                task:Destroy()
            elseif typeof(task) == "function" then
                task()
            end
        end)
    end
    table.clear(self.Tasks)
    self.Tasks = {}
end

-- ==================== 服务引用 ====================
local Services = setmetatable({}, {
    __index = function(self, key)
        local suc, service = pcall(game.GetService, game, key)
        if suc and service then
            self[key] = service
            return service
        else
            warn(`[Services] Warning: "{key}" is not a valid Roblox service.`)
            return nil
        end
    end
})

local Players = Services.Players
local Lighting = Services.Lighting
local RunService = Services.RunService
local HttpService = Services.HttpService
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
local ReplicatedStorage = Services.ReplicatedStorage
local ProximityPromptService = Services.ProximityPromptService

local lplr = Players.LocalPlayer
local localPlayer = lplr

local camera = workspace.CurrentCamera
local alive = true
local rootPart = nil

-- ==================== 共享函数 ====================
local SharedFunctions = {}

function SharedFunctions.GetBoosts(arg1, arg2, arg3)
    local boosts = arg1 and arg1:FindFirstChild("Boosts")
    if boosts then
        local boostVal = boosts:FindFirstChild(arg2)
        if boostVal then
            return 0.1 * boostVal.Value
        end
    end
    return 0
end

function SharedFunctions.Invisible(arg1, arg2, arg3)
    for _, part in ipairs(arg1:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
            if arg3 then
                part.CanCollide = false
            end
        end
    end
end

function SharedFunctions.CreateFolder(parent, name, lifetime, opts)
    local Folder = Instance.new("Folder")
    Folder.Name = name
    if opts then
        if opts.ObjectValue then Folder.Value = opts.ObjectValue end
        if opts.Attributes then
            for k, v in pairs(opts.Attributes) do
                Folder:SetAttribute(k, v)
            end
        end
    end
    Folder.Parent = parent
    if lifetime then
        task.delay(lifetime, function()
            if Folder and Folder.Parent then Folder:Destroy() end
        end)
    end
    return Folder
end

-- ==================== Script 对象 ====================
local Script = {
    GameStateChanged = Instance.new("BindableEvent"),
    GameState = "unknown",
    Services = Services,
    Maid = Maid.new(),
    Connections = {},
    Functions = {},
    ESPTable = {
        Player = {}, Seeker = {}, Hider = {}, Guard = {},
        Door = {}, None = {}, Key = {}, EscapeDoor = {}
    },
    Temp = {
        ValidGuards = {},
        NoclipParts = {}
    }
}

local States = {}

-- ==================== Alert 函数 ====================
function Script.Functions.Alert(message, time_obj)
    Library:Notify(message, time_obj or 5)
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://4590662766"
    sound.Volume = 2
    sound.PlayOnRemove = true
    sound:Destroy()
end

function Script.Functions.Warn(message)
    warn("WARN - voidware:", message)
end

-- ==================== SafeRequire ====================
Script.Functions.SafeRequire = function(module)
    if Script.Temp[tostring(module)] then return Script.Temp[tostring(module)] end
    local suc, err = pcall(function()
        return require(module)
    end)
    if not suc then
        warn("[SafeRequire]: Failure loading "..tostring(module).." ("..tostring(err)..")")
    else
        Script.Temp[tostring(module)] = err
    end
    return suc and err
end

-- ==================== ESP 系统 ====================
function Script.Functions.ESP(args)
    if not args.Object then return Script.Functions.Warn("ESP Object is nil") end

    local ESPManager = {
        Object = args.Object,
        Text = args.Text or "No Text",
        TextParent = args.TextParent,
        Color = args.Color or Color3.new(),
        Offset = args.Offset or Vector3.zero,
        IsEntity = args.IsEntity or false,
        Type = args.Type or "None",
        Highlights = {},
        Humanoid = nil,
        RSConnection = nil,
        Connections = {}
    }

    local tableIndex = #Script.ESPTable[ESPManager.Type] + 1

    if ESPManager.IsEntity and ESPManager.Object.PrimaryPart and ESPManager.Object.PrimaryPart.Transparency == 1 then
        ESPManager.Object:SetAttribute("Transparency", ESPManager.Object.PrimaryPart.Transparency)
        ESPManager.Humanoid = Instance.new("Humanoid", ESPManager.Object)
        ESPManager.Object.PrimaryPart.Transparency = 0.99
    end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = ESPManager.Object
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = ESPManager.Color
    highlight.FillTransparency = Options.ESPFillTransparency.Value
    highlight.OutlineColor = ESPManager.Color
    highlight.OutlineTransparency = Options.ESPOutlineTransparency.Value
    highlight.Enabled = Toggles.ESPHighlight.Value
    highlight.Parent = ESPManager.Object
    table.insert(ESPManager.Highlights, highlight)

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = ESPManager.TextParent or ESPManager.Object
    billboardGui.AlwaysOnTop = true
    billboardGui.ClipsDescendants = false
    billboardGui.Size = UDim2.new(0, 1, 0, 1)
    billboardGui.StudsOffset = ESPManager.Offset
    billboardGui.Parent = ESPManager.TextParent or ESPManager.Object

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Oswald
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = ESPManager.Text
    textLabel.TextColor3 = ESPManager.Color
    textLabel.TextSize = Options.ESPTextSize.Value
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.75
    textLabel.Parent = billboardGui

    function ESPManager.SetColor(newColor)
        ESPManager.Color = newColor
        for _, hl in pairs(ESPManager.Highlights) do
            hl.FillColor = newColor
            hl.OutlineColor = newColor
        end
        textLabel.TextColor3 = newColor
    end

    function ESPManager.Destroy()
        if ESPManager.RSConnection then ESPManager.RSConnection:Disconnect() end
        if ESPManager.IsEntity and ESPManager.Object then
            if ESPManager.Object.PrimaryPart then
                ESPManager.Object.PrimaryPart.Transparency = ESPManager.Object.PrimaryPart:GetAttribute("Transparency")
            end
            if ESPManager.Humanoid then ESPManager.Humanoid:Destroy() end
        end
        for _, hl in pairs(ESPManager.Highlights) do hl:Destroy() end
        if billboardGui then billboardGui:Destroy() end
        if Script.ESPTable[ESPManager.Type][tableIndex] then
            Script.ESPTable[ESPManager.Type][tableIndex] = nil
        end
        for _, conn in pairs(ESPManager.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        ESPManager.Connections = {}
    end

    ESPManager.RSConnection = RunService.RenderStepped:Connect(function()
        if not ESPManager.Object or not ESPManager.Object:IsDescendantOf(workspace) then
            ESPManager.Destroy()
            return
        end
        for _, hl in pairs(ESPManager.Highlights) do
            hl.Enabled = Toggles.ESPHighlight.Value
            hl.FillTransparency = Options.ESPFillTransparency.Value
            hl.OutlineTransparency = Options.ESPOutlineTransparency.Value
        end
        textLabel.TextSize = Options.ESPTextSize.Value
        if Toggles.ESPDistance.Value then
            textLabel.Text = string.format("%s\n[%s]", ESPManager.Text, math.floor(Script.Functions.DistanceFromCharacter(ESPManager.Object)))
        else
            textLabel.Text = ESPManager.Text
        end
    end)

    function ESPManager.GiveSignal(signal)
        table.insert(ESPManager.Connections, signal)
    end

    Script.ESPTable[ESPManager.Type][tableIndex] = ESPManager
    return ESPManager
end

-- ==================== ESP 类型函数 ====================
function Script.Functions.SeekerESP(player)
    if player:GetAttribute("IsHunter") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        Script.Functions.ESP({
            Object = player.Character,
            Text = player.Name .. " (Seeker)",
            Color = Options.SeekerEspColor.Value,
            Offset = Vector3.new(0, 3, 0),
            Type = "Seeker"
        })
    end
end

function Script.Functions.HiderESP(player)
    if player:GetAttribute("IsHider") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local esp = Script.Functions.ESP({
            Object = player.Character,
            Text = player.Name .. " (Hider)",
            Color = Options.HiderEspColor.Value,
            Offset = Vector3.new(0, 3, 0),
            Type = "Hider"
        })
        player:GetAttributeChangedSignal("IsHider"):Once(function()
            if not player:GetAttribute("IsHider") then esp.Destroy() end
        end)
    end
end

function Script.Functions.KeyESP(key)
    if key:IsA("Model") and key.PrimaryPart then
        Script.Functions.ESP({
            Object = key,
            Text = key.Name .. " (Key)",
            Color = Options.KeyEspColor.Value,
            Offset = Vector3.new(0, 1, 0),
            Type = "Key",
            IsEntity = true
        })
    end
end

function Script.Functions.DoorESP(door)
    if door:IsA("Model") and door.Name == "FullDoorAnimated" and door.PrimaryPart then
        local keyNeeded = door:GetAttribute("KeyNeeded") or "None"
        Script.Functions.ESP({
            Object = door,
            Text = "门 (钥匙: " .. keyNeeded .. ")",
            Color = Options.DoorEspColor.Value,
            Offset = Vector3.new(0, 2, 0),
            Type = "Door",
            IsEntity = true
        })
    end
end

function Script.Functions.EscapeDoorESP(door)
    if door:IsA("Model") and door.Name == "EXITDOOR" and door.PrimaryPart and door:GetAttribute("CANESCAPE") then
        Script.Functions.ESP({
            Object = door,
            Text = "逃生门",
            Color = Options.EscapeDoorEspColor.Value,
            Offset = Vector3.new(0, 2, 0),
            Type = "EscapeDoor",
            IsEntity = true
        })
    end
end

function Script.Functions.GuardESP(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local esp = Script.Functions.ESP({
            Object = character,
            Text = "警卫",
            Color = Options.GuardEspColor.Value,
            Offset = Vector3.new(0, 3, 0),
            Type = "Guard"
        })
        table.insert(esp.Connections, character.ChildAdded:Connect(function(v)
            if v.Name == "Dead" and v.ClassName == "Folder" then esp.Destroy() end
        end))
    end
end

function Script.Functions.PlayerESP(player)
    if not (player.Character and player.Character.PrimaryPart and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0) then return end
    local playerEsp = Script.Functions.ESP({
        Type = "Player",
        Object = player.Character,
        Text = string.format("%s [%s]", player.DisplayName, player.Character.Humanoid.Health),
        TextParent = player.Character.PrimaryPart,
        Color = Options.PlayerEspColor.Value
    })
    playerEsp.GiveSignal(player.Character.Humanoid.HealthChanged:Connect(function(newHealth)
        if newHealth > 0 then
            playerEsp.Text = string.format("%s [%s]", player.DisplayName, newHealth)
        else
            playerEsp.Destroy()
        end
    end))
end

-- ==================== 游戏功能 ====================
Script.Functions.ExecuteClick = function()
    game:GetService("ReplicatedStorage"):WaitForChild("Replication"):WaitForChild("Event"):FireServer("Clicked")
end

Script.Functions.CompleteDalgonaGame = function()
    Script.Functions.ExecuteClick()
    local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    remotes:WaitForChild("DALGONATEMPREMPTE"):FireServer({Completed = true})
    remotes:WaitForChild("DALGONATEMPREMPTE"):FireServer({Success = true})
end

Script.Functions.PullRope = function(perfect)
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer({PerfectQTE = true})
end

function Script.Functions.RevealGlassBridge()
    local glassHolder = workspace:FindFirstChild("GlassBridge") and workspace.GlassBridge:FindFirstChild("GlassHolder")
    if not glassHolder then return end
    for _, tilePair in pairs(glassHolder:GetChildren()) do
        for _, tileModel in pairs(tilePair:GetChildren()) do
            if tileModel:IsA("Model") and tileModel.PrimaryPart then
                local primaryPart = tileModel.PrimaryPart
                for _, child in ipairs(tileModel:GetChildren()) do
                    if child:IsA("Highlight") then child:Destroy() end
                end
                local isBreakable = primaryPart:GetAttribute("exploitingisevil") == true
                local targetColor = isBreakable and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                for _, part in pairs(tileModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        TweenService:Create(part, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                            Transparency = 0.5,
                            Color = targetColor
                        }):Play()
                    end
                end
                local highlight = Instance.new("Highlight")
                highlight.FillColor = targetColor
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0.5
                highlight.Parent = tileModel
            end
        end
    end
end

-- ==================== 第 1 段结束 ====================
-- ==================== 第 2 段：核心功能 ====================

Script.Functions.OnLoad = function()
    local EffectsModule = Script.Functions.SafeRequire(ReplicatedStorage.Modules.Effects) or {
        AnnouncementTween = function(args)
            Script.Functions.Alert(args.AnnouncementDisplayText, args.DisplayTime)
        end
    }
    Script.Functions.EffectsNotification("Voidware - Ink Game loaded!", 5)
    Script.Functions.EffectsNotification("Join discord.gg/voidware for updates :)", 5)
end

function Script.Functions.EffectsNotification(text, dur)
    local EffectsModule = Script.Functions.SafeRequire(ReplicatedStorage.Modules.Effects) or {
        AnnouncementTween = function(args)
            Script.Functions.Alert(args.AnnouncementDisplayText, args.DisplayTime)
        end
    }
    dur = dur or 5
    text = tostring(text)
    EffectsModule.AnnouncementTween({
        AnnouncementOneLine = true,
        FasterTween = true,
        DisplayTime = dur,
        AnnouncementDisplayText = text
    })
end

-- ==================== 布娃娃绕过 ====================
Script.Functions.BypassRagdoll = function()
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChild("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Torso = Character:FindFirstChild("Torso")
    if not (Humanoid and HumanoidRootPart and Torso) then return end

    if Script.Temp.RagdollBlockConn then Script.Temp.RagdollBlockConn:Disconnect() end
    Script.Temp.RagdollBlockConn = Character.ChildAdded:Connect(function(child)
        if child.Name == "Ragdoll" then
            pcall(function() child:Destroy() end)
            pcall(function()
                Humanoid.PlatformStand = false
                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            end)
        end
    end)

    for _, child in ipairs(Character:GetChildren()) do
        if child.Name == "Ragdoll" then pcall(function() child:Destroy() end) end
    end

    for _, folderName in pairs({"Stun", "RotateDisabled", "RagdollWakeupImmunity", "InjuredWalking"}) do
        local folder = Character:FindFirstChild(folderName)
        if folder then folder:Destroy() end
    end

    for _, obj in pairs(HumanoidRootPart:GetChildren()) do
        if obj:IsA("BallSocketConstraint") or obj.Name:match("^CacheAttachment") then obj:Destroy() end
    end
    local joints = {"Left Hip", "Left Shoulder", "Neck", "Right Hip", "Right Shoulder"}
    for _, jointName in pairs(joints) do
        local motor = Torso:FindFirstChild(jointName)
        if motor and motor:IsA("Motor6D") and not motor.Part0 then
            motor.Part0 = Torso
        end
    end
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part:FindFirstChild("BoneCustom") then
            part.BoneCustom:Destroy()
        end
    end
end

-- ==================== 糖饼绕过 ====================
Script.Functions.BypassDalgonaGame = function()
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    local CurrentCamera = workspace.CurrentCamera

    if not Character or not Humanoid then return end

    SharedFunctions.Invisible(Character, 0, true)

    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
    local DalgonaRemote = Remotes:WaitForChild("DALGONATEMPREMPTE")
    DalgonaRemote:FireServer({Success = true})

    task.wait(0.5)
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = Humanoid
end

-- ==================== 角色功能 ====================
Script.Functions.GetRootPart = function()
    if not lplr.Character then return end
    return lplr.Character:WaitForChild("HumanoidRootPart", 10)
end

Script.Functions.GetHumanoid = function()
    if not lplr.Character then return end
    return lplr.Character:WaitForChild("Humanoid", 10)
end

local KillauraDebug = false
local tools = {"叉子", "瓶子", "刀", "功率保持"}

Script.Functions.GetFork = function()
    local res
    for _, index in pairs(tools) do
        local tool = lplr.Character:FindFirstChild(index) or lplr:FindFirstChild("Backpack") and lplr.Backpack:FindFirstChild(index)
        if tool then
            res = tool
            break
        end
    end
    return res
end

local function getNearestEnemy(maxDist)
    maxDist = maxDist or 15
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            if hum.Health > 0 then
                local dist = (lplr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist and dist <= maxDist then
                    closest = player.Character.HumanoidRootPart
                    closestDist = dist
                end
            end
        end
    end
    return closest
end

Script.Functions.FireForkRemote = function()
    local fork = Script.Functions.GetFork()
    if not fork then return end
    if fork.Parent and fork.Parent.Name == "Backpack" then
        lplr.Character.Humanoid:EquipTool(fork)
    end
    fork = Script.Functions.GetFork()
    if not fork then return end
    local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
    Remotes:WaitForChild("UsedTool"):FireServer("UsingMoveCustom", fork, nil, {Clicked = true})
    Remotes:WaitForChild("UsedTool"):FireServer("UsingMoveCustom", fork, true, {Clicked = true})
end

-- ==================== Discord ====================
Script.Functions.JoinDiscordServer = function()
    pcall(function() setclipboard("discord.gg/voidware") end)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "复制NOL dc - discord.gg/voidware",
        Text = "加入我们dc群 (discord.gg/voidware)",
        Duration = 10,
    })
end

function Script.Functions.GetDalgonaRemote()
    return game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("DALGONATEMPREMPTE")
end

function Script.Functions.DistanceFromCharacter(position)
    if typeof(position) == "Instance" then
        position = position:GetPivot().Position
    end
    if not alive then
        return (camera.CFrame.Position - position).Magnitude
    end
    return (rootPart and rootPart.Position or camera.CFrame.Position - position).Magnitude
end

Script.Functions.FixCamera = function()
    if workspace.CurrentCamera then
        pcall(function() workspace.CurrentCamera:Destroy() end)
    end
    local new = Instance.new("Camera")
    new.Parent = workspace
    workspace.CurrentCamera = new
    new.CameraType = Enum.CameraType.Custom
    new.CameraSubject = lplr.Character and lplr.Character:FindFirstChild("Humanoid")
end

Script.Functions.RestoreVisibility = function(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "BoneCustom" then
            if part.Transparency >= 0.99 then part.Transparency = 0 end
        end
    end
end

Script.Functions.CheckPlayersVisibility = function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then Script.Functions.RestoreVisibility(player.Character) end
    end
end

function Script.Functions.SetupOtherPlayerConnection(player)
    if player.Character then
        if Toggles.PlayerESP.Value then Script.Functions.PlayerESP(player) end
    end
    Library:GiveSignal(player.CharacterAdded:Connect(function()
        task.delay(0.1, function()
            if Toggles.PlayerESP.Value then Script.Functions.PlayerESP(player) end
        end)
    end))
end

-- ==================== Anti-Fling ====================
function Script.Functions.DisableAntiFling()
    if Toggles.AntiFlingToggle.Value then Toggles.AntiFlingToggle:SetValue(false) end
end

function Script.Functions.EnableAntiFling()
    if not Toggles.AntiFlingToggle.Value then Toggles.AntiFlingToggle:SetValue(true) end
end

-- ==================== 传送函数 ====================
function Script.Functions.WinRLGL()
    if not lplr.Character then return end
    local call = Toggles.AntiFlingToggle.Value
    Script.Functions.DisableAntiFling()
    lplr.Character:PivotTo(CFrame.new(Vector3.new(-100.8, 1030, 115)))
    if call then task.delay(0.5, Script.Functions.EnableAntiFling) end
end

function Script.Functions.TeleportSafe()
    if not lplr.Character then return end
    pcall(function()
        Script.Temp.OldLocation = CFrame.new(lplr.Character.HumanoidRootPart.Position)
    end)
    local call = Toggles.AntiFlingToggle.Value
    Script.Functions.DisableAntiFling()
    lplr.Character:PivotTo(CFrame.new(Vector3.new(-108, 329.1, 462.1)))
    if call then task.delay(0.5, Script.Functions.EnableAntiFling) end
end

function Script.Functions.TeleportBackFromSafe()
    local OldLocation = Script.Temp.OldLocation
    if not OldLocation then return end
    if not lplr.Character then return end
    local call = Toggles.AntiFlingToggle.Value
    Script.Functions.DisableAntiFling()
    lplr.Character:PivotTo(OldLocation)
    if call then task.delay(0.5, Script.Functions.EnableAntiFling) end
end

function Script.Functions.TeleportSafeHidingSpot()
    if not lplr.Character then return end
    local call = Toggles.AntiFlingToggle.Value
    Script.Functions.DisableAntiFling()
    lplr.Character:PivotTo(CFrame.new(Vector3.new(229.9, 1005.3, 169.4)))
    if call then task.delay(0.5, Script.Functions.EnableAntiFling) end
end

function Script.Functions.WinGlassBridge()
    if not lplr.Character then return end
    local call = Toggles.AntiFlingToggle.Value
    Script.Functions.DisableAntiFling()
    lplr.Character:PivotTo(CFrame.new(Vector3.new(-203.9, 520.7, -1534.3485)))
    if call then task.delay(0.5, Script.Functions.EnableAntiFling) end
end

function Script.Functions.ToggleTPTSP()
    pcall(function()
        if not Toggles.TeleportToSafePlace.Value then
            Toggles.TeleportToSafePlace:SetValue(true)
        end
    end)
end

-- ==================== 警卫判断 ====================
local function isGuard(model)
    if not model:IsA("Model") or model == lplr.Character then return false end
    if not model:FindFirstChild("TypeOfGuard") then return false end
    if string.find(model.Name, "RebelGuard") or string.find(model.Name, "FinalRebel") or string.find(model.Name, "HallwayGuard") or string.find(string.lower(model.Name), "aggro") then
        local hum = model:FindFirstChild("Humanoid")
        if not hum then return false end
        return not model:FindFirstChild("Dead") and hum.Health > 0
    end
    return false
end

function Script.Functions.Wallcheck(attackerCharacter, targetCharacter, additionalIgnore)
    if not (attackerCharacter and targetCharacter) then return false end
    local humanoidRootPart = attackerCharacter.PrimaryPart
    local targetRootPart = targetCharacter.PrimaryPart
    if not (humanoidRootPart and targetRootPart) then return false end
    local origin = humanoidRootPart.Position
    local targetPosition = targetRootPart.Position
    local direction = targetPosition - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.RespectCanCollide = true
    local ignoreList = {attackerCharacter}
    if additionalIgnore and typeof(additionalIgnore) == "table" then
        for _, item in pairs(additionalIgnore) do table.insert(ignoreList, item) end
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then
        return raycastResult.Instance:IsDescendantOf(targetCharacter)
    else
        return true
    end
end

function Script.Functions.PivotRebelGuardsToPlayer()
    local myChar = lplr.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position
    for _, guard in ipairs(Script.Temp.ValidGuards or {}) do
        if isGuard(guard) and guard:FindFirstChild("HumanoidRootPart") then
            local guardRoot = guard.HumanoidRootPart
            guardRoot.CFrame = CFrame.new(guardRoot.Position, myPos)
        end
    end
end

-- ==================== 初始化守卫列表 ====================
task.spawn(function()
    pcall(function()
        local Live = workspace:WaitForChild("Live")
        for _, v in pairs(Live:GetChildren()) do
            if isGuard(v) then table.insert(Script.Temp.ValidGuards, v) end
        end
        Library:GiveSignal(Live.ChildAdded:Connect(function(v)
            if isGuard(v) then table.insert(Script.Temp.ValidGuards, v) end
        end))
        Library:GiveSignal(Live.ChildRemoved:Connect(function(v)
            if isGuard(v) then
                local index = table.find(Script.Temp.ValidGuards, v)
                if index then table.remove(Script.Temp.ValidGuards, index) end
            end
        end))
    end)
end)

-- ==================== 第 2 段结束 ====================
-- ==================== 第 3 段：UI 界面 ====================

-- ==================== Main ESP ====================
local MAIN_ESP_META = {
    {
        metaName = "PlayerESP",
        text = "玩家绘制",
        default = false,
        color = { metaName = "PlayerEspColor", default = Color3.fromRGB(255, 255, 255) },
        func = function()
            for _, player in pairs(Players:GetPlayers()) do
                if player == localPlayer then continue end
                Script.Functions.PlayerESP(player)
            end
        end
    },
    {
        metaName = "GuardESP",
        text = "守卫绘制",
        default = false,
        color = { metaName = "GuardEspColor", default = Color3.fromRGB(200, 100, 200) },
        func = function()
            local live = workspace:FindFirstChild("Live")
            if not live then return end
            for _, descendant in pairs(live:GetChildren()) do
                if descendant:IsA("Model") and descendant:FindFirstChild("TypeOfGuard") then
                    if string.find(descendant.Name, "RebelGuard") or string.find(descendant.Name, "FinalRebel") or string.find(descendant.Name, "HallwayGuard") or string.find(string.lower(descendant.Name), "aggro") then
                        Script.Functions.GuardESP(descendant)
                    end
                end
            end
        end,
        descendantcheck = function(descendant)
            if descendant:IsA("Model") and descendant:FindFirstChild("TypeOfGuard") then
                if string.find(descendant.Name, "RebelGuard") or string.find(descendant.Name, "FinalRebel") or string.find(descendant.Name, "HallwayGuard") or string.find(string.lower(descendant.Name), "aggro") then
                    Script.Functions.GuardESP(descendant)
                end
            end
        end
    }
}

local MainESPGroup = Tabs.Visuals:AddLeftGroupbox("Main ESP", "eye")
for _, meta in pairs(MAIN_ESP_META) do
    MainESPGroup:AddToggle(meta.metaName, {
        Text = meta.text,
        Default = meta.default
    }):AddColorPicker(meta.color.metaName, {
        Default = meta.color.default
    })

    Toggles[meta.metaName]:OnChanged(function(call)
        if call then
            if meta.func then meta.func(call) end
        else
            Script.ESPTable[meta.text] = Script.ESPTable[meta.text] or {}
            for _, esp in pairs(Script.ESPTable[meta.text]) do
                esp.Destroy()
            end
        end
    end)

    if meta.descendantcheck then
        Library:GiveSignal(workspace.DescendantAdded:Connect(function(descendant)
            if not Toggles[meta.metaName].Value then return end
            meta.descendantcheck(descendant)
        end))
    end
end

-- ==================== Hide and Seek ESP ====================
local ESP_META = {
    {
        metaName = "HiderESP",
        text = "躲藏者绘制",
        default = false,
        color = { metaName = "HiderEspColor", default = Color3.fromRGB(0, 255, 0) },
        checkType = "player"
    },
    {
        metaName = "SeekerESP",
        text = "追踪者绘制",
        default = false,
        color = { metaName = "SeekerEspColor", default = Color3.fromRGB(255, 0, 0) },
        checkType = "player"
    },
    {
        metaName = "KeyESP",
        text = "钥匙绘制",
        default = false,
        color = { metaName = "KeyEspColor", default = Color3.fromRGB(255, 255, 0) },
        checkType = "key",
        descendantcheck = function(descendant)
            local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
            if not hideAndSeekMap then return end
            if descendant:IsA("Model") and descendant.Parent and descendant.Parent.Name == "KEYS" and descendant.Parent.Parent == hideAndSeekMap then
                Script.Functions.KeyESP(descendant)
            end
        end
    },
    {
        metaName = "DoorESP",
        text = "门绘制",
        default = false,
        color = { metaName = "DoorEspColor", default = Color3.fromRGB(0, 128, 255) },
        checkType = "door",
        descendantcheck = function(descendant)
            local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
            if not hideAndSeekMap then return end
            if descendant:IsA("Model") and descendant.Name == "FullDoorAnimated" and descendant.Parent and descendant.Parent.Parent and descendant.Parent.Parent.Name == "NEWFIXEDDOORS" then
                Script.Functions.DoorESP(descendant)
            end
        end
    },
    {
        metaName = "EscapeDoorESP",
        text = "逃生门绘制",
        default = false,
        color = { metaName = "EscapeDoorEspColor", default = Color3.fromRGB(255, 0, 255) },
        checkType = "escapedoor",
        descendantcheck = function(descendant)
            local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
            if not hideAndSeekMap then return end
            if descendant:IsA("Model") and descendant.Name == "EXITDOOR" and descendant.PrimaryPart and descendant:GetAttribute("CANESCAPE") then
                Script.Functions.EscapeDoorESP(descendant)
            end
        end
    },
}

local ESPGroupBox = Tabs.Visuals:AddLeftGroupbox("Hide and Seek ESP", "search")
for _, meta in pairs(ESP_META) do
    ESPGroupBox:AddToggle(meta.metaName, {
        Text = meta.text,
        Default = meta.default
    }):AddColorPicker(meta.color.metaName, {
        Default = meta.color.default
    })

    Toggles[meta.metaName]:OnChanged(function(call)
        if call then
            if not string.find(Script.GameState, "HideAndSeek") then return end
            if meta.checkType == "player" then
                for _, player in pairs(Players:GetPlayers()) do
                    Script.Functions[meta.metaName](player)
                end
            elseif meta.checkType == "key" then
                local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
                if hideAndSeekMap then
                    local keysFolder = hideAndSeekMap:FindFirstChild("KEYS")
                    if keysFolder then
                        for _, key in pairs(keysFolder:GetChildren()) do Script.Functions.KeyESP(key) end
                    end
                end
            elseif meta.checkType == "door" then
                local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
                if hideAndSeekMap then
                    local newFixedDoors = hideAndSeekMap:FindFirstChild("NEWFIXEDDOORS")
                    if newFixedDoors then
                        for _, floor in pairs(newFixedDoors:GetChildren()) do
                            if floor.Name:match("^Floor") then
                                for _, door in pairs(floor:GetChildren()) do Script.Functions.DoorESP(door) end
                            end
                        end
                    end
                end
            elseif meta.checkType == "escapedoor" then
                local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
                if hideAndSeekMap then
                    local newFixedDoors = hideAndSeekMap:FindFirstChild("NEWFIXEDDOORS")
                    if newFixedDoors then
                        for _, floor in pairs(newFixedDoors:GetChildren()) do
                            if floor.Name:match("^Floor") then
                                for _, group in pairs(floor:GetChildren()) do
                                    if group.Name == "EXITDOORS" then
                                        for _, door in pairs(group:GetChildren()) do
                                            if door:IsA("Model") and door.Name == "EXITDOOR" and door.PrimaryPart and door:GetAttribute("CANESCAPE") then
                                                Script.Functions.EscapeDoorESP(door)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            Script.ESPTable[meta.text] = Script.ESPTable[meta.text] or {}
            for _, esp in pairs(Script.ESPTable[meta.text]) do esp.Destroy() end
        end
    end)

    Options[meta.color.metaName]:OnChanged(function(value)
        Script.ESPTable[meta.text] = Script.ESPTable[meta.text] or {}
        for _, esp in pairs(Script.ESPTable[meta.text]) do esp.SetColor(value) end
    end)

    if meta.descendantcheck then
        Library:GiveSignal(workspace.DescendantAdded:Connect(function(descendant)
            if not string.find(Script.GameState, "HideAndSeek") then return end
            if not Toggles[meta.metaName].Value then return end
            meta.descendantcheck(descendant)
        end))
    end
end

-- ==================== ESP Settings ====================
local ESPSettingsGroupBox = Tabs.Visuals:AddRightGroupbox("ESP Settings", "sliders")
ESPSettingsGroupBox:AddToggle("ESPHighlight", { Text = "高亮绘制", Default = true })
ESPSettingsGroupBox:AddToggle("ESPDistance", { Text = "绘制距离", Default = true })
ESPSettingsGroupBox:AddSlider("ESPFillTransparency", {
    Text = "填充透明度", Default = 0.75, Min = 0, Max = 1, Rounding = 2
})
ESPSettingsGroupBox:AddSlider("ESPOutlineTransparency", {
    Text = "边缘透明度", Default = 0, Min = 0, Max = 1, Rounding = 2
})
ESPSettingsGroupBox:AddSlider("ESPTextSize", {
    Text = "文字大小", Default = 22, Min = 16, Max = 26, Rounding = 0
})

-- ==================== Self ====================
local SelfGroupBox = Tabs.Visuals:AddRightGroupbox("Self", "user")
SelfGroupBox:AddToggle("FOVToggle", { Text = "范围", Default = false })
SelfGroupBox:AddSlider("FOVSlider", {
    Text = "范围", Default = 60, Min = 10, Max = 120, Rounding = 1
})

-- ==================== Fun 功能 ====================
local FunGroupBox = Tabs.Main:AddLeftGroupbox("Fun", "zap")

FunGroupBox:AddToggle("InkGameAutowin", { Text = "自动获胜", Default = false })
Toggles.InkGameAutowin:OnChanged(function(call)
    if call then
        Script.Functions.Alert("Autowin enabled!", 3)
        task.spawn(function()
            Script.Functions.EffectsNotification("Autowin enabled!", 5)
        end)
        Script.Functions.HandleAutowin()
    else
        Script.Functions.Alert("Autowin disabled!", 3)
    end
end)

FunGroupBox:AddToggle("FlingAuraToggle", { Text = "飞翔光环", Default = false })
FunGroupBox:AddToggle("AntiFlingToggle", { Text = "反翻转", Default = false })

Toggles.AntiFlingToggle:OnChanged(function(call)
    if call then
        if not hookmetamethod then
            Script.Functions.Alert("[Fling Aura]: Unsupported executor :(")
            Toggles.AntiFlingToggle:SetValue(false)
            return
        end
        Script.Temp.PauseAntiFling = nil
        Script.Functions.Alert("Anti Fling Enabled", 3)
        Script.Temp.AntiFlingActive = true
        Script.Temp.AntiFlingLoop = task.spawn(function()
            local lastSafeCFrame = nil
            while Script.Temp.AntiFlingActive and not Library.Unloaded do
                if Script.Temp.PauseAntiFling then return end
                local character = lplr.Character
                local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
                if root then
                    local gs = Script.GameState
                    local isActiveGame = gs and gs ~= "" and States[gs] ~= nil
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BodyMover") or part:IsA("BodyVelocity") or part:IsA("BodyGyro") or part:IsA("BodyThrust") or part:IsA("BodyAngularVelocity") then
                            part:Destroy()
                        end
                    end
                    local maxVel = 100
                    local vel = root.Velocity
                    if vel.Magnitude > maxVel then
                        root.Velocity = Vector3.new(
                            math.clamp(vel.X, -maxVel, maxVel),
                            math.clamp(vel.Y, -maxVel, maxVel),
                            math.clamp(vel.Z, -maxVel, maxVel)
                        )
                    end
                    if not lastSafeCFrame or (root.Position - lastSafeCFrame.Position).Magnitude < 20 then
                        lastSafeCFrame = root.CFrame
                    elseif isActiveGame and (root.Position - lastSafeCFrame.Position).Magnitude > 50 then
                        root.CFrame = lastSafeCFrame
                        root.Velocity = Vector3.zero
                    end
                end
                task.wait(0.05)
            end
        end)
    else
        Script.Functions.Alert("Anti Fling Disabled", 3)
        Script.Temp.AntiFlingActive = false
        if Script.Temp.AntiFlingLoop then
            task.cancel(Script.Temp.AntiFlingLoop)
            Script.Temp.AntiFlingLoop = nil
        end
    end
end)

-- ==================== Killaura ====================
local KillauraGroupBox = Tabs.Main:AddLeftGroupbox("Killaura", "sword")
KillauraGroupBox:AddToggle("KillauraInkGame", { Text = "杀戮光环", Default = false })
KillauraGroupBox:AddToggle("KillauraFaceTarget", { Text = "静默自瞄", Default = true })

Toggles.KillauraInkGame:OnChanged(function(call)
    if call then
        pcall(function()
            if Toggles.RedLightGodmode.Value then Toggles.RedLightGodmode:SetValue(false) end
        end)
        local fork = Script.Functions.GetFork()
        if not fork then
            Script.Functions.Alert("No Weapon found!", 3)
            Toggles.KillauraInkGame:SetValue(false)
            return
        end
        task.spawn(function()
            repeat
                task.wait(0.5)
                if Script.GameState == "RedLightGreenLight" then return end
                local target = getNearestEnemy(15)
                if target and Toggles.KillauraFaceTarget.Value then
                    local root = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = CFrame.new(root.Position, target.Position)
                    end
                end
                Script.Functions.FireForkRemote()
                local args = { CFrame.new(lplr.Character.HumanoidRootPart.Position) }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("rootCFrame"):FireServer(unpack(args))
            until not Toggles.KillauraInkGame.Value or Library.Unloaded
        end)
    end
end)

-- ==================== 红绿灯 ====================
local GreenLightRedLightGroup = Tabs.Main:AddLeftGroupbox("Red Light / Green Light", "traffic-light")

GreenLightRedLightGroup:AddToggle("RedLightGodmode", { Text = "上帝模式", Default = false })

local RLGL_OriginalNamecall
Toggles.RedLightGodmode:OnChanged(function(enabled)
    if enabled then
        if not hookmetamethod then
            Script.Functions.Alert("Your executor doesn't support this :(")
            Toggles.RedLightGodMode:SetValue(false)
            return
        end
        local TrafficLightImage = lplr.PlayerGui:FindFirstChild("ImpactFrames") and lplr.PlayerGui.ImpactFrames:FindFirstChild("TrafficLightEmpty")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local lastRootPartCFrame = nil
        local isGreenLight = true
        if TrafficLightImage and ReplicatedStorage:FindFirstChild("Effects") and ReplicatedStorage.Effects:FindFirstChild("Images") and ReplicatedStorage.Effects.Images:FindFirstChild("TrafficLights") and ReplicatedStorage.Effects.Images.TrafficLights:FindFirstChild("GreenLight") then
            isGreenLight = TrafficLightImage.Image == ReplicatedStorage.Effects.Images.TrafficLights.GreenLight.Image
        end
        local function updateState()
            local character = lplr.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then lastRootPartCFrame = root.CFrame end
        end
        updateState()
        local RLGL_Connection = ReplicatedStorage.Remotes.Effects.OnClientEvent:Connect(function(EffectsData)
            if EffectsData.EffectName ~= "TrafficLight" then return end
            isGreenLight = EffectsData.GreenLight == true
            updateState()
        end)
        Script.Temp.RLGL_Connection = RLGL_Connection
        RLGL_OriginalNamecall = RLGL_OriginalNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if tostring(self) == "rootCFrame" and method == "FireServer" and Script.GameState == "RedLightGreenLight" then
                if Toggles.RedLightGodmode.Value and not isGreenLight and lastRootPartCFrame then
                    args[1] = lastRootPartCFrame
                    return RLGL_OriginalNamecall(self, unpack(args))
                end
            end
            return RLGL_OriginalNamecall(self, ...)
        end)
        Script.Temp.RLGL_OriginalNamecall = RLGL_OriginalNamecall
        Script.Functions.Alert("Red Light Green Light Godmode Enabled", 3)
    else
        if Script.Temp.RLGL_Connection then
            pcall(function() Script.Temp.RLGL_Connection:Disconnect() end)
            Script.Temp.RLGL_Connection = nil
        end
        if Script.Temp.RLGL_OriginalNamecall then
            hookmetamethod(game, "__namecall", Script.Temp.RLGL_OriginalNamecall)
            Script.Temp.RLGL_OriginalNamecall = nil
        end
        Script.Functions.Alert("无视红灯", 3)
    end
end)

GreenLightRedLightGroup:AddButton("秒过木头人", function()
    if not game.Workspace:FindFirstChild("RedLightGreenLight") then
        Script.Functions.Alert("Game not running")
        return
    end
    Script.Functions.WinRLGL()
end)

GreenLightRedLightGroup:AddButton("受伤时行走", function()
    if lplr.Character and lplr.Character:FindFirstChild("InjuredWalking") then
        lplr.Character.InjuredWalking:Destroy()
    end
    Script.Functions.BypassRagdoll()
end)

-- ==================== 第 3 段结束 ====================
-- ==================== 第 4 段：更多功能 ====================

-- ==================== 救援功能 ====================
local fireproximityprompt = fireproximityprompt or function(prompt)
    prompt.HoldDuration = 0
    prompt:InputHoldBegin()
end

function Script.Functions.FindCarryPrompt(plr)
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not (plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Humanoid").Health > 0) then return false end
    return plr.Character.HumanoidRootPart:FindFirstChild("CarryPrompt")
end

function Script.Functions.FireCarryPrompt(plr)
    local CarryPrompt = Script.Functions.FindCarryPrompt(plr)
    if not CarryPrompt then return false end
    return pcall(function() fireproximityprompt(CarryPrompt) end)
end

function Script.Functions.FindInjuredPlayer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lplr then continue end
        if plr:GetAttribute("IsDead") then continue end
        local CarryPrompt = Script.Functions.FindCarryPrompt(plr)
        if not CarryPrompt then continue end
        if plr.Character and plr.Character:FindFirstChild("SafeRedLightGreenLight") then continue end
        if plr.Character and plr.Character:FindFirstChild("IsBeingHeld") then continue end
        return plr, CarryPrompt
    end
end

function Script.Functions.UnCarryPerson()
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
end

GreenLightRedLightGroup:AddButton("带走受伤玩家", function()
    local injuredPlayer, carryPrompt = Script.Functions.FindInjuredPlayer()
    if not injuredPlayer or not carryPrompt then
        Script.Functions.Alert("No injured player found!", 2)
        return
    end
    if lplr.Character and injuredPlayer.Character and injuredPlayer.Character.PrimaryPart then
        Script.Temp.PauseAntiFling = true
        if Toggles.RedLightGodmode.Value then Toggles.RedLightGodmode:SetValue(false) end
        lplr.Character:PivotTo(injuredPlayer.Character:GetPrimaryPartCFrame())
        task.wait(0.2)
        Script.Functions.FireCarryPrompt(injuredPlayer)
        task.wait(0.2)
        Script.Functions.WinRLGL()
        task.wait(0.2)
        Script.Functions.UnCarryPerson()
        task.wait(0.2)
        Script.Temp.PauseAntiFling = false
    end
end)

local bringLoopThread = nil
GreenLightRedLightGroup:AddToggle("LoopBringPlayers", {
    Text = "救援受伤玩家",
    Default = false
})
Toggles.LoopBringPlayers:OnChanged(function(val)
    if val then
        bringLoopThread = task.spawn(function()
            while Toggles.LoopBringPlayers.Value and Script.GameState == "RedLightGreenLight" and not Library.Unloaded do
                local injuredPlayer, carryPrompt = Script.Functions.FindInjuredPlayer()
                if injuredPlayer and carryPrompt and lplr.Character and injuredPlayer.Character and injuredPlayer.Character.PrimaryPart then
                    Script.Temp.PauseAntiFling = true
                    if Toggles.RedLightGodmode.Value then Toggles.RedLightGodmode:SetValue(false) end
                    lplr.Character:PivotTo(injuredPlayer.Character:GetPrimaryPartCFrame())
                    task.wait(0.2)
                    Script.Functions.FireCarryPrompt(injuredPlayer)
                    task.wait(0.2)
                    Script.Functions.WinRLGL()
                    task.wait(0.2)
                    Script.Functions.UnCarryPerson()
                    task.wait(0.2)
                    Script.Temp.PauseAntiFling = false
                end
                task.wait(1)
            end
        end)
    else
        if bringLoopThread then
            task.cancel(bringLoopThread)
            bringLoopThread = nil
        end
    end
end)
Toggles.LoopBringPlayers:SetVisible(false)

-- ==================== 扣糖饼 ====================
function Script.Functions.RestartRemotesScript()
    if lplr.Character and lplr.Character:FindFirstChild("Remotes") then
        local Remotes = lplr.Character:FindFirstChild("Remotes")
        pcall(function() Remotes.Disabled = true; Remotes.Enabled = false end)
        task.wait(0.5)
        pcall(function() Remotes.Disabled = false; Remotes.Enabled = true end)
    end
end

local DalgonaGameGroup = Tabs.Main:AddLeftGroupbox("扣糖饼", "circle")

DalgonaGameGroup:AddButton("秒过糖饼游戏", function()
    if not Script.Functions.GetDalgonaRemote() then
        Script.Functions.Alert("Game hasn't started yet")
        return
    end
    Script.Functions.CompleteDalgonaGame()
    Script.Functions.BypassDalgonaGame()
    Script.Functions.Alert("Completed Dalgona Game!", 2)
    Script.Functions.RestartRemotesScript()
    Script.Functions.Alert("Camera should be automatically fixed!", 3)
    task.spawn(function()
        repeat
            task.wait(1)
            Script.Functions.CheckPlayersVisibility()
        until not Script.Functions.GetDalgonaRemote()
    end)
end)

DalgonaGameGroup:AddToggle("ImmuneDalgonaGame", { Text = "免疫糖饼游戏", Default = false })

Toggles.ImmuneDalgonaGame:OnChanged(function(call)
    if call then
        if not hookmetamethod then
            Script.Functions.Alert("Your executor doesn't support this function :(", 5)
            Toggles.ImmuneDalgonaGame:SetValue(false)
            return
        end
        local DalgonaRemoteHook
        DalgonaRemoteHook = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if tostring(self) == "DALGONATEMPREMPTE" and method == "FireServer" then
                if args[1] ~= nil and type(args[1]) == "table" and args[1].CrackAmount ~= nil then
                    Script.Functions.Alert("Prevented your cookie from cracking", 3)
                    return nil
                end
            end
            return DalgonaRemoteHook(self, unpack(args))
        end)
        Script.Temp.DalgonaRemoteHook = DalgonaRemoteHook
        Script.Functions.Alert("Your cookie will not break from now on!", 3)
    else
        if not hookmetamethod then return end
        if not Script.Temp.DalgonaRemoteHook then return end
        hookmetamethod(game, '__namecall', Script.Temp.DalgonaRemoteHook)
    end
end)

-- ==================== 拔河 ====================
local TugOfWarGroup = Tabs.Main:AddLeftGroupbox("拔河区", "rope")
TugOfWarGroup:AddToggle("AutoPull", { Text = "自动拉绳子", Default = false })
TugOfWarGroup:AddToggle("PerfectPull", { Text = "完美拔河", Default = true })

-- ==================== Mingle ====================
local MingleGroup = Tabs.Main:AddLeftGroupbox("Mingle", "users")
MingleGroup:AddToggle("AutoMingleQTE", { Text = "自动打击", Default = false })

local RemoteForQTE
Toggles.AutoMingleQTE:OnChanged(function(call)
    Script.Temp.AutoMingleQTEActive = call
    if call then
        Script.Temp.AutoMingleQTEThread = task.spawn(function()
            while Script.Temp.AutoMingleQTEActive and not Library.Unloaded do
                local character = lplr.Character
                if character then
                    if not RemoteForQTE then
                        for _, obj in pairs(character:GetChildren()) do
                            if obj:IsA("RemoteEvent") and obj.Name == "RemoteForQTE" then
                                RemoteForQTE = obj
                                break
                            end
                        end
                    end
                    pcall(function() RemoteForQTE:FireServer() end)
                end
                task.wait(0.5)
            end
        end)
    else
        if Script.Temp.AutoMingleQTEThread then
            task.cancel(Script.Temp.AutoMingleQTEThread)
        end
    end
end)

-- ==================== 玻璃桥 ====================
local GlassBridgeGroup = Tabs.Main:AddLeftGroupbox("玻璃桥", "bridge")
GlassBridgeGroup:AddButton("完成玻璃桥游戏", function()
    if not workspace:FindFirstChild("GlassBridge") then
        Script.Functions.Alert("Game not running")
        return
    end
    Script.Functions.WinGlassBridge()
end)
GlassBridgeGroup:AddButton("显示玻璃桥的玻璃", function()
    if not workspace:FindFirstChild("GlassBridge") then
        Script.Functions.Alert("Game not running")
        return
    end
    Script.Functions.RevealGlassBridge()
end)

-- ==================== 信息 ====================
local InformationGroup = Tabs.Main:AddRightGroupbox("信息", "info")
InformationGroup:AddLabel("欢迎使用 NOL脚本!")
InformationGroup:AddLabel("加入我们的QQ群!")
InformationGroup:AddLabel("")
InformationGroup:AddButton("复制群号", Script.Functions.JoinDiscordServer)
InformationGroup:AddButton("无", function() Library:Unload() end)

-- ==================== 捉迷藏 ====================
function Script.Functions.GetHider()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lplr then continue end
        if not plr.Character then continue end
        if not plr:GetAttribute("IsHider") then continue end
        if plr.Character ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            return plr.Character
        end
    end
end

local HideAndSeekGroup = Tabs.Main:AddRightGroupbox("Hide And Seek", "search")

HideAndSeekGroup:AddToggle("TeleportToHider", {
    Text = "传送隐藏点",
    Default = false
}):AddKeyPicker("TTH", {
    Mode = "Toggle",
    Default = "P",
    Text = "传送隐藏点",
    SyncToggleState = true
})

Toggles.TeleportToHider:OnChanged(function(call)
    if call then
        task.spawn(function()
            task.delay(0.5, function()
                if Toggles.TeleportToHider.Value then Toggles.TeleportToHider:SetValue(false) end
            end)
        end)
        if not lplr.Character then return end
        if Script.GameState ~= "HideAndSeek" then
            Script.Functions.Alert("Game not running!")
            return
        end
        local hider = Script.Functions.GetHider()
        if not hider then
            Script.Functions.Alert("No hider found :(")
            return
        end
        lplr.Character:PivotTo(hider:GetPrimaryPartCFrame())
    end
end)

HideAndSeekGroup:AddToggle("StaminaBypass", { Text = "无限体力", Default = false })
Toggles.StaminaBypass:OnChanged(function(enabled)
    if enabled then
        Script.Temp.StaminaBypassLoop = task.spawn(function()
            while Toggles.StaminaBypass.Value and not Library.Unloaded do
                local char = lplr.Character
                if char then
                    local stamina = char:FindFirstChild("StaminaVal")
                    if stamina then stamina.Value = 100 end
                end
                task.wait(0.1)
            end
        end)
    else
        if Script.Temp.StaminaBypassLoop then
            task.cancel(Script.Temp.StaminaBypassLoop)
            Script.Temp.StaminaBypassLoop = nil
        end
    end
end)

HideAndSeekGroup:AddButton("Teleport to Safe Hiding Spot", function()
    if Script.GameState ~= "HideAndSeek" then
        Script.Functions.Alert("Game not running!")
        return
    end
    Script.Functions.TeleportSafeHidingSpot()
end)

-- ==================== 反叛 ====================
local RebelGroup = Tabs.Main:AddRightGroupbox("其他", "sword")

RebelGroup:AddToggle("ExpandGuardHitbox", { Text = "加大守卫碰撞箱", Default = false })

local processedModels = {}
local TARGET_SIZE = Vector3.new(4, 4, 4)
local DEFAULT_SIZE = Vector3.new(1, 1, 1)

local function isPlayerCharacter(model)
    return Players:FindFirstChild(model.Name) ~= nil
end

local function processModel(model)
    if not model or not model:IsA("Model") then return end
    if isPlayerCharacter(model) then return end
    if not isGuard(model) then return end
    if processedModels[model] then return end
    local head = model:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return end
    processedModels[model] = head
end

local function cleanup()
    for model, head in pairs(processedModels) do
        if head and head.Parent then
            pcall(function() head.Size = DEFAULT_SIZE; head.CanCollide = true end)
        end
    end
    processedModels = {}
end

Toggles.ExpandGuardHitbox:OnChanged(function(call)
    if call then
        task.spawn(function()
            repeat
                local liveFolder = workspace:FindFirstChild("Live")
                if not Toggles.ExpandGuardHitbox.Value or not liveFolder then return end
                for _, model in ipairs(liveFolder:GetChildren()) do processModel(model) end
                for model, head in pairs(processedModels) do
                    if model and model.Parent and head and head.Parent then
                        if head.Size ~= TARGET_SIZE then
                            head.Size = TARGET_SIZE
                            head.CanCollide = false
                        end
                    else
                        processedModels[model] = nil
                    end
                end
                task.wait(3)
            until not Toggles.ExpandGuardHitbox.Value or Library.Unloaded
        end)
    else
        cleanup()
    end
end)

RebelGroup:AddButton("Bring All Guards", function()
    Script.Functions.PivotRebelGuardsToPlayer()
end)

-- ==================== 武器强化 ====================
RebelGroup:AddToggle("GunMods", { Text = "武器强化", Default = false })

local originalGunStats = {}
local originalDamageValues = {}

local function patchGunStats(enable)
    local Guns = ReplicatedStorage:FindFirstChild("Weapons") and ReplicatedStorage.Weapons:FindFirstChild("Guns")
    if not Guns then return end
    local GunDamageValues = Script.Functions.SafeRequire(ReplicatedStorage.Modules.GunDamageValues)
    for _, gun in pairs(Guns:GetChildren()) do
        if enable then
            if not originalGunStats[gun.Name] then
                originalGunStats[gun.Name] = {}
                for _, stat in ipairs({"Spread", "FireRateCD", "MaxBullets", "ReloadingSpeed"}) do
                    if gun:FindFirstChild(stat) then
                        originalGunStats[gun.Name][stat] = gun[stat].Value
                    end
                end
            end
            if gun:FindFirstChild("Spread") then gun.Spread.Value = 0 end
            if gun:FindFirstChild("FireRateCD") then gun.FireRateCD.Value = 0.01 end
            if gun:FindFirstChild("MaxBullets") then gun.MaxBullets.Value = 999 end
            if gun:FindFirstChild("ReloadingSpeed") then gun.ReloadingSpeed.Value = 0.01 end
        else
            if originalGunStats[gun.Name] then
                for stat, val in pairs(originalGunStats[gun.Name]) do
                    if gun:FindFirstChild(stat) then gun[stat].Value = val end
                end
            end
        end
    end
end

Toggles.GunMods:OnChanged(function(enabled)
    patchGunStats(enabled)
end)

-- ==================== 第 4 段结束 ====================
-- ==================== 第 5 段：自瞄与自动射击 ====================

-- ==================== 自瞄 ====================
local function getNearestGuard(camPos, wallcheckEnabled, character)
    local closest, closestDist = nil, math.huge
    for _, model in ipairs(Script.Temp.ValidGuards or {}) do
        if isGuard(model) then
            local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
            if part then
                if not wallcheckEnabled or Script.Functions.Wallcheck(character, model) then
                    local dist = (part.Position - camPos).Magnitude
                    if dist < closestDist then
                        closest = part
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local AimbotGroup = Tabs.Main:AddRightGroupbox("自瞄区", "bow-arrow")
AimbotGroup:AddToggle("GuardAimbot", { Text = "瞄准守卫", Default = false })
AimbotGroup:AddToggle("PlayerAimbot", { Text = "瞄准玩家", Default = false })
AimbotGroup:AddToggle("AimbotWallcheck", { Text = "瞄准速度", Default = true })
AimbotGroup:AddSlider("AimSpeed", {
    Text = "自瞄速度",
    Default = 0.2,
    Min = 0.01,
    Max = 1,
    Rounding = 2
})

local function getNearestPlayer(camPos, wallcheckEnabled, character)
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and not player.Character:FindFirstChild("Dead") then
            local part = player.Character.HumanoidRootPart
            if not wallcheckEnabled or Script.Functions.Wallcheck(character, player.Character) then
                local dist = (part.Position - camPos).Magnitude
                if dist < closestDist then
                    closest = part
                    closestDist = dist
                end
            end
        end
    end
    return closest
end

if Script.Temp.AimBotConnection then
    Script.Temp.AimBotConnection:Disconnect()
    Script.Temp.AimBotConnection = nil
end

local function updateAimbot()
    if Script.Temp.AimBotConnection then
        Script.Temp.AimBotConnection:Disconnect()
        Script.Temp.AimBotConnection = nil
    end
    if Toggles.GuardAimbot.Value or Toggles.PlayerAimbot.Value then
        Script.Temp.AimBotConnection = RunService.RenderStepped:Connect(function()
            if not (Toggles.GuardAimbot.Value or Toggles.PlayerAimbot.Value) or not lplr.Character then return end
            local cam = workspace.CurrentCamera
            local camPos = cam.CFrame.Position
            local aimTarget = nil
            local guardTarget, guardDist = nil, math.huge
            local playerTarget, playerDist = nil, math.huge
            if Toggles.GuardAimbot.Value then
                guardTarget = getNearestGuard(camPos, Toggles.AimbotWallcheck.Value, lplr.Character)
                if guardTarget then guardDist = (guardTarget.Position - camPos).Magnitude end
            end
            if Toggles.PlayerAimbot.Value then
                playerTarget = getNearestPlayer(camPos, Toggles.AimbotWallcheck.Value, lplr.Character)
                if playerTarget then playerDist = (playerTarget.Position - camPos).Magnitude end
            end
            if guardTarget and playerTarget then
                aimTarget = guardDist <= playerDist and guardTarget or playerTarget
            else
                aimTarget = guardTarget or playerTarget
            end
            if aimTarget then
                local look = (aimTarget.Position - camPos).Unit
                local aimSpeed = Options.AimSpeed and Options.AimSpeed.Value or 0.2
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, camPos + look), aimSpeed)
            end
        end)
    end
end

Toggles.GuardAimbot:OnChanged(updateAimbot)
Toggles.PlayerAimbot:OnChanged(updateAimbot)
Toggles.AimbotWallcheck:OnChanged(updateAimbot)

-- ==================== 自动射击 ====================
local AutoShootGroup = Tabs.Main:AddRightGroupbox("自动射击", "target")
AutoShootGroup:AddToggle("AutoShoot", { Text = "自动射击", Default = false })
AutoShootGroup:AddToggle("AutoShootWallcheck", { Text = "穿墙检测", Default = true })

Toggles.AutoShoot:OnChanged(function(enabled)
    if enabled then
        Script.Temp.AutoShootActive = true
        task.spawn(function()
            while Script.Temp.AutoShootActive and not Library.Unloaded do
                local character = lplr.Character
                if character and not character:FindFirstChild("Dead") then
                    local heldGun = nil
                    for _, tool in ipairs(character:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            heldGun = tool
                            break
                        end
                    end
                    if heldGun then
                        local cam = workspace.CurrentCamera
                        local camPos = cam.CFrame.Position
                        local closest = getNearestGuard(camPos, Toggles.AutoShootWallcheck.Value, character)
                        if closest and (closest.Position - camPos).Magnitude < 100 then
                            local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                            if Remotes and Remotes:FindFirstChild("FiredGunClient") then
                                Remotes.FiredGunClient:FireServer(heldGun, {FiredGun = true})
                            end
                            task.wait(0.15)
                        else
                            task.wait(0.1)
                        end
                    else
                        task.wait(0.2)
                    end
                else
                    task.wait(0.5)
                end
            end
        end)
    else
        Script.Temp.AutoShootActive = false
    end
end)

-- ==================== 玩家功能 ====================
local PlayerGroupBox = Tabs.Main:AddRightGroupbox("玩家", "user")

PlayerGroupBox:AddSlider("SpeedSlider", {
    Text = "走路速度",
    Default = 30,
    Min = 0,
    Max = 100,
    Rounding = 1
})

PlayerGroupBox:AddToggle("SpeedToggle", {
    Text = "速度启用",
    Default = false
}):AddKeyPicker("SpeedKey", {
    Mode = "Toggle",
    Default = "C",
    Text = "速度",
    SyncToggleState = true
})

PlayerGroupBox:AddToggle("Noclip", {
    Text = "穿墙",
    Default = false
}):AddKeyPicker("NoclipKey", {
    Mode = "Toggle",
    Default = "N",
    Text = "穿墙",
    SyncToggleState = true
})

PlayerGroupBox:AddToggle("InfiniteJump", { Text = "无限跳跃", Default = false })
PlayerGroupBox:AddToggle("Fly", { Text = "飞行", Default = false })

PlayerGroupBox:AddSlider("FlySpeed", {
    Text = "飞行速度",
    Default = 40,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Compact = true,
})

-- ==================== Fling Aura ====================
Toggles.FlingAuraToggle:OnChanged(function(call)
    local function setNoclip(state)
        if Toggles.Noclip.Value ~= state then Toggles.Noclip:SetValue(state) end
    end

    local function stopFlingAura()
        Script.Temp.FlingAuraActive = false
        setNoclip(false)
        if Script.Temp.FlingAuraDeathConn then
            Script.Temp.FlingAuraDeathConn:Disconnect()
            Script.Temp.FlingAuraDeathConn = nil
        end
    end

    if call then
        Script.Functions.Alert("Fling Aura Enabled", 3)
        Script.Temp.FlingAuraActive = true
        setNoclip(true)
        local player = lplr
        local function getRoot(character)
            return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
        end
        local humanoid = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            Script.Temp.FlingAuraDeathConn = humanoid.Died:Connect(stopFlingAura)
        end
        task.spawn(function()
            local movel = 0.1
            while Script.Temp.FlingAuraActive and not Library.Unloaded do
                local character = player.Character
                local root = getRoot(character)
                if character and character.Parent and root and root.Parent then
                    local originalVel = root.Velocity
                    root.Velocity = originalVel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if character and character.Parent and root and root.Parent then
                        root.Velocity = originalVel
                    end
                    RunService.Stepped:Wait()
                    if character and character.Parent and root and root.Parent then
                        root.Velocity = originalVel + Vector3.new(0, movel, 0)
                        movel = -movel
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    else
        Script.Functions.Alert("Fling Aura Disabled", 3)
        stopFlingAura()
    end
end)

-- ==================== Noclip ====================
Toggles.Noclip:OnChanged(function(call)
    Script.Temp.NoclipParts = Script.Temp.NoclipParts or {}
    if call then
        Script.Functions.Alert("Noclip Enabled", 3)
        local function NoclipLoop()
            if lplr.Character ~= nil then
                for _, child in pairs(lplr.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                        Script.Temp.NoclipParts[child] = true
                    end
                end
            end
        end
        task.spawn(function()
            repeat
                RunService.Heartbeat:Wait()
                NoclipLoop()
            until not Toggles.Noclip.Value or Library.Unloaded
        end)
    else
        Script.Functions.Alert("Noclip Disabled", 3)
        if lplr.Character ~= nil and Script.Temp.NoclipParts then
            for part, _ in pairs(Script.Temp.NoclipParts) do
                if part and part:IsA("BasePart") then part.CanCollide = true end
            end
            Script.Temp.NoclipParts = {}
        end
    end
end)

-- ==================== 速度 ====================
Options.SpeedSlider:OnChanged(function(val)
    if not Toggles.SpeedToggle.Value then return end
    if not lplr.Character then return end
    if not lplr.Character:FindFirstChild("Humanoid") then return end
    lplr.Character.Humanoid.WalkSpeed = Options.SpeedSlider.Value
end)

Toggles.SpeedToggle:OnChanged(function(call)
    if call then
        Script.Functions.Alert("Speed Enabled", 3)
        if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            Script.Temp.OldSpeed = lplr.Character.Humanoid.WalkSpeed
            lplr.Character.Humanoid.WalkSpeed = Options.SpeedSlider.Value
        end
        task.spawn(function()
            repeat
                task.wait(0.5)
                if not Toggles.SpeedToggle.Value then return end
                if not lplr.Character then return end
                if not lplr.Character:FindFirstChild("Humanoid") then return end
                lplr.Character.Humanoid.WalkSpeed = Options.SpeedSlider.Value
            until not Toggles.SpeedToggle.Value or Library.Unloaded
        end)
    else
        Script.Functions.Alert("Speed Disabled", 3)
        if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            lplr.Character.Humanoid.WalkSpeed = 31
            Script.Temp.OldSpeed = nil
        end
    end
end)

-- ==================== 飞行 ====================
Toggles.Fly:SetVisible(false)
Options.FlySpeed:SetVisible(false)

local controlModule

Toggles.Fly:OnChanged(function(value)
    local rootPart = Script.Functions.GetRootPart()
    if not rootPart then return end

    local humanoid = Script.Functions.GetHumanoid()
    if humanoid then humanoid.PlatformStand = value end

    local flyBody = Script.Temp.FlyBody or Instance.new("BodyVelocity")
    flyBody.Velocity = Vector3.zero
    flyBody.MaxForce = Vector3.one * 9e9
    Script.Temp.FlyBody = flyBody
    Script.Temp.FlyBody.Parent = value and rootPart or nil

    if value then
        controlModule = controlModule or Script.Functions.SafeRequire(lplr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
        Script.Connections["Fly"] = RunService.RenderStepped:Connect(function()
            local moveVector = controlModule:GetMoveVector()
            local velocity = -((camera.CFrame.LookVector * moveVector.Z) - (camera.CFrame.RightVector * moveVector.X)) * Options.FlySpeed.Value
            Script.Temp.FlyBody.Velocity = velocity
        end)
    else
        if Script.Connections["Fly"] then Script.Connections["Fly"]:Disconnect() end
    end
end)

-- ==================== Fling 速度欺骗 ====================
function Script.Functions.SpoofFlingVelocity(call)
    if call then
        local spoofedValue = Vector3.new(0, 0, 0)
        local root = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
        if not root then
            Script.Functions.Alert("No HumanoidRootPart found!", 3)
            return
        end

        if not Script.Temp.OriginalIndex then
            Script.Temp.OriginalIndex = hookmetamethod(game, "__index", function() end)
            hookmetamethod(game, "__index", Script.Temp.OriginalIndex)
        end
        if not Script.Temp.OriginalNewIndex then
            Script.Temp.OriginalNewIndex = hookmetamethod(game, "__newindex", function() end)
            hookmetamethod(game, "__newindex", Script.Temp.OriginalNewIndex)
        end

        local spoofedProps = {
            Velocity = spoofedValue,
            AssemblyLinearVelocity = spoofedValue
        }

        local index = hookmetamethod(game, "__index", function(self, key)
            if not checkcaller() and typeof(self) == "Instance" and self == root then
                if spoofedProps[key] ~= nil then return spoofedProps[key] end
            end
            return Script.Temp.OriginalIndex(self, key)
        end)

        local newindex = hookmetamethod(game, "__newindex", function(self, key, value)
            if not checkcaller() and typeof(self) == "Instance" and self == root then
                if spoofedProps[key] ~= nil then
                    if key == "Velocity" then
                        Script.Temp.LastVelocity = value
                        return
                    elseif key == "AssemblyLinearVelocity" then
                        Script.Temp.LastAssemblyLinearVelocity = value
                        return
                    end
                end
            end
            return Script.Temp.OriginalNewIndex(self, key, value)
        end)

        Script.Temp.SpoofedIndex = index
        Script.Temp.SpoofedNewIndex = newindex
        Script.Functions.Alert("Fling Velocity Spoofing Enabled!", 3)
    else
        if Script.Temp.SpoofedIndex then
            hookmetamethod(game, "__index", Script.Temp.OriginalIndex)
            Script.Temp.SpoofedIndex = nil
        end
        if Script.Temp.SpoofedNewIndex then
            hookmetamethod(game, "__newindex", Script.Temp.OriginalNewIndex)
            Script.Temp.SpoofedNewIndex = nil
        end
        Script.Functions.Alert("Fling Velocity Spoofing Disabled!", 3)
    end
end

-- ==================== 第 5 段结束 ====================
-- ==================== 第 6 段：安全、性能、杂项、结束 ====================

-- ==================== Fling 角色钩子 ====================
function Script.Functions.FlingCharacterHook(call)
    if call then
        local function PatchFlingAnticheat()
            local char = lplr.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local anticheatStates = { "Stun", "Anchor", "RotateDisabled", "CantRun", "InCutscene", "DisableHeadLookAt" }
            if not Script.Temp.FlingAnticheatChildConn then
                Script.Temp.FlingAnticheatChildConn = char.ChildAdded:Connect(function(child)
                    if table.find(anticheatStates, child.Name) then child:Destroy() end
                end)
            end

            if not Script.Temp.FlingAnticheatMT then
                local mt = getrawmetatable(root)
                Script.Temp.FlingAnticheatOldNewIndex = mt.__newindex
                setreadonly(mt, false)
                mt.__newindex = function(self, key, value)
                    if self == root and key == "Anchored" and value == true then return end
                    return Script.Temp.FlingAnticheatOldNewIndex(self, key, value)
                end
                setreadonly(mt, true)
                Script.Temp.FlingAnticheatMT = mt
            end
        end

        local function onChar(char)
            task.wait(1)
            PatchFlingAnticheat()
        end
        Script.Temp.FlingAnticheatCharConn = lplr.CharacterAdded:Connect(onChar)
        if lplr.Character then PatchFlingAnticheat() end
        Script.Functions.Alert("Anticheat Patched!", 3)
    else
        if Script.Temp.FlingAnticheatCharConn then
            Script.Temp.FlingAnticheatCharConn:Disconnect()
            Script.Temp.FlingAnticheatCharConn = nil
        end
        if Script.Temp.FlingAnticheatChildConn then
            Script.Temp.FlingAnticheatChildConn:Disconnect()
            Script.Temp.FlingAnticheatChildConn = nil
        end
        if Script.Temp.FlingAnticheatMT and Script.Temp.FlingAnticheatOldNewIndex then
            local root = lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local mt = Script.Temp.FlingAnticheatMT
                setreadonly(mt, false)
                mt.__newindex = Script.Temp.FlingAnticheatOldNewIndex
                setreadonly(mt, true)
            end
            Script.Temp.FlingAnticheatMT = nil
            Script.Temp.FlingAnticheatOldNewIndex = nil
        end
        Script.Functions.Alert("Anticheat Patch Disabled!", 3)
    end
end

-- ==================== 安全组 ====================
local SecurityGroupBox = Tabs.Main:AddRightGroupbox("安全保险绕过", "shield")

SecurityGroupBox:AddToggle("PatchFlingAnticheat", {
    Text = "绕过反作弊",
    Default = false
})

Toggles.PatchFlingAnticheat:OnChanged(function(call)
    if call and not hookmetamethod then
        Script.Functions.Alert("[Anticheat Patch]: Unsupported executor :(")
    end
    pcall(Script.Functions.SpoofFlingVelocity, call)
    pcall(Script.Functions.FlingCharacterHook, call)
end)

SecurityGroupBox:AddToggle("AntiAfk", { Text = "反挂机检测", Default = true })
Toggles.AntiAfk:OnChanged(function(call)
    if call then
        local VirtualUser = Services.VirtualUser
        Script.Temp.AntiAfkConnection = lplr.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
        end)
    else
        if Script.Temp.AntiAfkConnection then
            pcall(function() Script.Temp.AntiAfkConnection:Disconnect() end)
        end
    end
end)

SecurityGroupBox:AddToggle("StaffDetector", { Text = "管理员检测［防止Ban］", Default = true })
Toggles.StaffDetector:OnChanged(function(call)
    if call then
        local STAFF_GROUP_ID = 12398672
        local STAFF_MIN_RANK = 120
        local staffRoles = { [120] = "moderator", [254] = "dev", [255] = "owner" }
        Script.Temp.DetectedStaff = Script.Temp.DetectedStaff or {}
        local function checkPlayerStaff(player)
            local success, rank = pcall(function() return player:GetRankInGroup(STAFF_GROUP_ID) end)
            if success and rank and rank >= STAFF_MIN_RANK then
                local roleName = staffRoles[rank] or ("rank " .. tostring(rank))
                Script.Functions.Alert("[StaffDetector] Staff detected: " .. player.Name .. " (" .. roleName .. ")", 10)
                Script.Temp.DetectedStaff[player.UserId] = {Name = player.Name, Role = roleName}
                return true
            end
            return false
        end
        Script.Temp.StaffDetectorConnections = Script.Temp.StaffDetectorConnections or {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then checkPlayerStaff(player) end
        end
        Script.Temp.StaffDetectorConnections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
            if player ~= localPlayer then
                task.wait(1)
                checkPlayerStaff(player)
            end
        end)
        Script.Temp.StaffDetectorConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
            local staffInfo = Script.Temp.DetectedStaff and Script.Temp.DetectedStaff[player.UserId]
            if staffInfo then
                Script.Functions.Alert("[StaffDetector] Staff left: " .. staffInfo.Name .. " (" .. staffInfo.Role .. ")", 10)
                Script.Temp.DetectedStaff[player.UserId] = nil
            end
        end)
    else
        if Script.Temp.StaffDetectorConnections then
            for _, conn in pairs(Script.Temp.StaffDetectorConnections) do
                pcall(function() conn:Disconnect() end)
            end
            Script.Temp.StaffDetectorConnections = nil
        end
        Script.Temp.DetectedStaff = nil
    end
end)

-- ==================== 性能 ====================
local PerformanceGroupBox = Tabs.Misc:AddRightGroupbox("Performance", "gauge")

PerformanceGroupBox:AddToggle("LowGFX", { Text = "低画质", Default = false })
Toggles.LowGFX:OnChanged(function(call)
    if call then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        pcall(function() settings().Rendering.QualityLevel = 1 end)
    else
        Lighting.GlobalShadows = true
        pcall(function() settings().Rendering.QualityLevel = 10 end)
    end
end)

PerformanceGroupBox:AddToggle("DisableEffects", { Text = "禁用特效", Default = false })
Toggles.DisableEffects:OnChanged(function(call)
    if call then
        local Effects = workspace:WaitForChild("Effects", 15)
        if not Effects then return end
        Effects:ClearAllChildren()
        Script.Temp.DisableEffectsConnection = Effects.ChildAdded:Connect(function(child)
            pcall(function() child:Destroy() end)
        end)
    else
        if Script.Temp.DisableEffectsConnection then
            pcall(function() Script.Temp.DisableEffectsConnection:Disconnect() end)
            Script.Temp.DisableEffectsConnection = nil
        end
    end
end)

PerformanceGroupBox:AddButton("清除特效缓存", function()
    if workspace:FindFirstChild("Effects") then workspace.Effects:ClearAllChildren() end
end)

-- ==================== 杂项 - 反摔 ====================
local MiscGroup = Tabs.Misc:AddLeftGroupbox("Misc", "wrench")

MiscGroup:AddToggle("AntiRagdoll", { Text = "反跌倒效果和减速", Default = false })
MiscGroup:AddButton("移除跌倒", Script.Functions.BypassRagdoll)
MiscGroup:AddDivider()
MiscGroup:AddToggle("SpectateModeToggler", { Text = "开启旁观模式", Default = false })
Toggles.SpectateModeToggler:OnChanged(function(call)
    workspace.Values.CanSpectateIfWonGame.Value = call
end)
MiscGroup:AddDivider()
MiscGroup:AddButton("Fix Camera", function()
    if camera then
        camera.CameraType = Enum.CameraType.Custom
        if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = lplr.Character:FindFirstChild("Humanoid")
        end
    end
end)
MiscGroup:AddButton("重置相机", Script.Functions.FixCamera)
MiscGroup:AddButton("跳过过场", function()
    if camera then
        camera.CameraType = Enum.CameraType.Custom
        if lplr.Character and lplr.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = lplr.Character:FindFirstChild("Humanoid")
        end
    end
end)
MiscGroup:AddDivider()
MiscGroup:AddToggle("TeleportToSafePlace", { Text = "传送到安全的地方", Default = false })
Toggles.TeleportToSafePlace:OnChanged(function(call)
    if call then
        Script.Functions.Alert("Teleported to Safe Place, disable to go back", 3)
        Script.Functions.TeleportSafe()
    else
        Script.Functions.TeleportBackFromSafe()
    end
end)
MiscGroup:AddButton("修复玩家可见性", Script.Functions.CheckPlayersVisibility)

-- ==================== 反摔循环 ====================
Toggles.AntiRagdoll:OnChanged(function(call)
    if call then
        Script.Functions.Alert("防摔倒+无电击启用", 3)
        Script.Functions.BypassRagdoll()
        if Script.Temp.AntiRagdollLoop then task.cancel(Script.Temp.AntiRagdollLoop) end
        Script.Temp.AntiRagdollLoop = task.spawn(function()
            while Toggles.AntiRagdoll.Value and not Library.Unloaded do
                Script.Functions.BypassRagdoll()
                task.wait(0.1)
            end
        end)
    else
        Script.Functions.Alert("Anti Ragdoll + No Stun Disabled", 3)
        if Script.Temp.AntiRagdollLoop then
            task.cancel(Script.Temp.AntiRagdollLoop)
            Script.Temp.AntiRagdollLoop = nil
        end
        if Script.Temp.RagdollBlockConn then
            Script.Temp.RagdollBlockConn:Disconnect()
            Script.Temp.RagdollBlockConn = nil
        end
    end
end)

-- ==================== FOV ====================
Library:GiveSignal(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then camera = workspace.CurrentCamera end
end))

Toggles.FOVToggle:OnChanged(function(call)
    if call then
        Script.Temp.OldFOV = camera and camera.FieldOfView or 60
        task.spawn(function()
            repeat
                if camera then camera.FieldOfView = Options.FOVSlider.Value end
                task.wait()
            until not Toggles.FOVToggle.Value or Library.Unloaded
        end)
    end
end)

-- ==================== 自动获胜状态 ====================
local lastCleanupFunction = function() end

pcall(function()
    Script.GameState = workspace.Values.CurrentGame.Value
end)

function Script.Functions.HandleAutowin()
    if lastCleanupFunction then pcall(lastCleanupFunction) end
    pcall(function()
        Script.GameState = workspace.Values.CurrentGame.Value
    end)
    if States[Script.GameState] then
        Script.Functions.Alert("[Autowin]: Running on "..tostring(Script.GameState))
        task.spawn(function()
            Script.Functions.EffectsNotification("[Autowin]: Running on "..tostring(Script.GameState), 10)
        end)
        lastCleanupFunction = States[Script.GameState]()
    else
        task.spawn(function()
            Script.Functions.EffectsNotification("[Autowin]: Waiting for the next game...", 10)
        end)
        Script.Functions.Alert("[Autowin]: Waiting for the next game...")
    end
end

States = {
    RedLightGreenLight = function()
        local call = true
        task.spawn(function()
            repeat
                Script.Functions.WinRLGL()
                task.wait(5)
            until not call or not Toggles.InkGameAutowin.Value or Script.GameState ~= "RedLightGreenLight"
        end)
        if not Toggles.AntiFlingToggle.Value then Toggles.AntiFlingToggle:SetValue(true) end
        return function()
            call = false
            if Toggles.AntiFlingToggle.Value then Toggles.AntiFlingToggle:SetValue(false) end
        end
    end,
    Mingle = function()
        if not Toggles.AutoMingleQTE.Value then Toggles.AutoMingleQTE:SetValue(true) end
        return function()
            if Toggles.AutoMingleQTE.Value then Toggles.AutoMingleQTE:SetValue(false) end
        end
    end,
    TugOfWar = function()
        if not Toggles.AutoPull.Value then Toggles.AutoPull:SetValue(true) end
        if not Toggles.PerfectPull.Value then Toggles.PerfectPull:SetValue(true) end
        return function()
            if Toggles.AutoPull.Value then Toggles.AutoPull:SetValue(false) end
        end
    end,
    GlassBridge = function()
        task.spawn(function() Script.Functions.RevealGlassBridge() end)
        local call = true
        task.spawn(function()
            task.wait(15)
            repeat
                Script.Functions.WinGlassBridge()
                task.wait(3)
            until not call or not Toggles.InkGameAutowin.Value or Library.Unloaded
        end)
        return function() call = false end
    end,
    HideAndSeek = function()
        if lplr:GetAttribute("IsHider") then Script.Functions.ToggleTPTSP() end
    end,
    LightsOut = Script.Functions.ToggleTPTSP,
    Dalgona = function()
        task.spawn(function()
            repeat task.wait() until Script.Functions.GetDalgonaRemote() or not Toggles.InkGameAutowin.Value or Library.Unloaded
            if not Toggles.InkGameAutowin.Value then return end
            task.wait(3)
            Script.Functions.CompleteDalgonaGame()
            Script.Functions.BypassDalgonaGame()
        end)
        return function() Script.Functions.CheckPlayersVisibility() end
    end
}

Library:GiveSignal(workspace:WaitForChild("Values"):WaitForChild("CurrentGame"):GetPropertyChangedSignal("Value"):Connect(function()
    Script.GameState = workspace.Values.CurrentGame.Value
    Script.GameStateChanged:Fire(Script.GameState)
    if not Script.GameState then return end
    Script.GameState = tostring(Script.GameState)
    if Toggles.InkGameAutowin.Value then Script.Functions.HandleAutowin() end
end))

Toggles.AutoPull:OnChanged(function(call)
    if call then
        task.spawn(function()
            repeat
                Script.Functions.PullRope(Toggles.PerfectPull.Value)
                task.wait()
            until not Toggles.AutoPull.Value or Library.Unloaded
        end)
    end
end)

-- ==================== 无限跳 ====================
Library:GiveSignal(UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump.Value then
        if not lplr.Character then return end
        if not lplr.Character:FindFirstChild("Humanoid") then return end
        lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

-- ==================== 初始化 rootPart ====================
if lplr.Character then
    rootPart = lplr.Character:FindFirstChild("HumanoidRootPart")
end

Library:GiveSignal(lplr.CharacterAdded:Connect(function(char)
    rootPart = char:WaitForChild("HumanoidRootPart", 10)
    alive = true
    if not Toggles.SpeedToggle.Value then return end
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end
    hum.WalkSpeed = Options.SpeedSlider.Value
end))

for _, player in pairs(Players:GetPlayers()) do
    if player == localPlayer then continue end
    Script.Functions.SetupOtherPlayerConnection(player)
end

Library:GiveSignal(Players.PlayerAdded:Connect(function(player)
    if player == localPlayer then return end
    Script.Functions.SetupOtherPlayerConnection(player)
end))

task.spawn(function() pcall(Script.Functions.OnLoad) end)

-- ==================== 卸载 ====================
Library:OnUnload(function()
    pcall(function() Script.Maid:Clean() end)
    for _, conn in pairs(Script.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, espType in pairs(Script.ESPTable) do
        for _, esp in pairs(espType) do pcall(esp.Destroy) end
    end
    pcall(Script.Functions.RevertAntiFlingDetection)
    Library.Unloaded = true
    getgenv().voidware_loaded = false
    shared.Voidware_InkGame_Library = nil
end)

-- ==================== UI 设置 ====================
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "menu")
local CreditsGroup = Tabs["UI Settings"]:AddRightGroupbox("Credits", "heart")

MenuGroup:AddToggle("KeybindMenuOpen", { Default = false, Text = "Open Keybind Menu", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = false, Text = "Menu keybind" })
MenuGroup:AddButton("Join Discord Server", Script.Functions.JoinDiscordServer)
MenuGroup:AddButton("Unload", function() Library:Unload() end)

CreditsGroup:AddLabel("erchodev#0 - script dev")
CreditsGroup:AddLabel("Jorsan - Mingle Support & Godmode")
CreditsGroup:AddLabel("linoria - ui library")
CreditsGroup:AddLabel("obsidian - ui library")

Library.ToggleKeybind = Options.MenuKeybind

Toggles.KeybindMenuOpen:OnChanged(function(call)
    if call then
        if Services.UserInputService.TouchEnabled and not Services.UserInputService.KeyboardEnabled and not Services.UserInputService.MouseEnabled then
            Script.Functions.Alert("Keybind Menu Disabled on mobile", 1.5)
            Toggles.KeybindMenuOpen:SetValue(false)
        end
    end
end)

-- ==================== 主题与保存 ====================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("voidware_linoria")
SaveManager:SetFolder("voidware_linoria/ink_game")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- ==================== 全部 6 段完成 ====================
