 Players = game:GetService("Players")
 Player = Players.LocalPlayer

if not AbysallHubSettings then
	 getgenv().AbysallHubSettings = {
	Name = "YX-DOORS脚本",
	DiscordInvite = "YirdeX制作",
}
end

 ScriptName = AbysallHubSettings.Name
 notif = true
 LoadingCooldown = false

 local repo = "https://raw.githubusercontent.com/YirdeX-Dev/obsidian_UI/refs/heads/main/"

 LoadingTime = tick()

 local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "ThemeManager.lua"))()

 Toggles = Library.Toggles
 Options = Library.Options



 Unloaded = false


function DoorsNotify(unsafeOptions) 
    assert(typeof(unsafeOptions) == "table", "期望参数是一个表，但实际得到的是 " .. typeof(unsafeOptions)) 


		local options = {
			Title = unsafeOptions.Title,
			Description = unsafeOptions.Description,
			Reason = unsafeOptions.Reason,
			NotificationType = unsafeOptions.NotificationType,
			Image = unsafeOptions.Image,
			Color = nil,
			Time = unsafeOptions.Time,

			TweenDuration = 0.8
		}

		if options.NotificationType == nil then
			options.NotificationType = "NOTIFICATION"
		end
		local achievement = game.Players.LocalPlayer.PlayerGui.MainUI["AchievementsHolder"].Achievement:Clone()
		achievement.Size = UDim2.new(0, 0, 0, 0)
		achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
		achievement.Name = "LiveAchievement"
		achievement.Visible = true

		achievement.Frame.TextLabel.Text = options.NotificationType

		if options.NotificationType == "WARNING" then
			achievement.Frame.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
			achievement.Frame.UIStroke.Color = Color3.fromRGB(255, 0, 0)
			achievement.Frame.Glow.ImageColor3 = Color3.fromRGB(255, 0, 0)
		end


		achievement.Frame.Details.Desc.Text = tostring(options.Description)
		achievement.Frame.Details.Title.Text = AbysallHubSettings.Name
		achievement.Frame.Details.Reason.Text = tostring(options.Reason or "")

		achievement.Frame.ImageLabel.BackgroundTransparency = 0
		if options.Image ~= nil then
			if options.Image:match("rbxthumb://") or options.Image:match("rbxassetid://") then
				achievement.Frame.ImageLabel.Image = tostring(options.Image or "rbxassetid://0")
			else
				achievement.Frame.ImageLabel.Image = options.Image
			end
		else
			achievement.Frame.ImageLabel.Image = "rbxassetid://6023426923"
		end
		achievement.Parent = game.Players.LocalPlayer.PlayerGui.MainUI["AchievementsHolder"]
		achievement.Sound.SoundId = "rbxassetid://10469938989"

		achievement.Sound.Volume = (Options.NotificationSoundVolume and Options.NotificationSoundVolume.Value/3 or 1)

		if notif == true then
			achievement.Sound:Play()
		end

		task.spawn(function()
			achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", options.TweenDuration, true)

			task.wait(0.8)

			achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)

			game:GetService("TweenService"):Create(achievement.Frame.Glow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
				ImageTransparency = 1
			}):Play()

			if options.Time ~= nil then
				if typeof(options.Time) == "number" then
					task.wait(options.Time)
				elseif typeof(options.Time) == "Instance" then
					options.Time.Destroying:Wait()
				end
			else
				task.wait(8)
			end

			achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
			task.wait(0.5)
			achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
			task.wait(0.5)
			achievement:Destroy()
		end)
	end


	function Sound()



		local sound = Instance.new("Sound")


		sound.Volume = 3

		sound.SoundId = "rbxassetid://4590662766"


		sound:Play()

		sound.Parent = game.ReplicatedStorage

		game:GetService("Debris"):AddItem(sound,15)


	end

	Unloaded = false

	function Unload()
		Library.ScreenGui.Enabled = false

		if #Toggles > 0 then
			for i,Toggle in pairs(Toggles) do
				Toggle:SetValue(false)
			end
		end


		Library:Unload()

		Library = nil

		getgenv().YX-HUBHubLoaded = false
		getgenv().Library = nil
	end



	ErrorConnection = game:GetService("LogService").MessageOut:Connect(function(Message, MessageType)
		if MessageType == Enum.MessageType.MessageError and not string.find(Message, "Lobby") and not string.find(Message, "Event")  and Unloaded == false then
			toclipboard(Message)
			Unloaded = true
			DoorsNotify({Title = ScriptName, Description = AbysallHubSettings.Name .. " has encountered an error.", Reason = "The error has been copied to your clipboard", Image = "http://www.roblox.com/asset/?id=4463096168", NotifyTimeLevers = "WARNING"})
			return
		end
	end)

	if workspace:FindFirstChild("Lobby") then

		LoadingCooldown = false
	



		-- Variables --



		Players = game:GetService("Players")
		Player = Players.LocalPlayer

		TeleportService = game:GetService("TeleportService")


		Window = Library:CreateWindow({

			Title = ScriptName,
	 Icon = "rbxassetid://71400987113958", 
	Footer = "大厅",		    
    Size = UDim2.fromOffset(750, 650),
    AutoShow = true,
    NotifySide = "Right",
    ShowCustomCursor = true,
    IconSize = UDim2.fromOffset(30, 30),
    Resizable = true,
    MobileButtonsSide = "Left",
    DisableSearch = false,
    SearchbarSize = UDim2.new(0.8, 0, 1, 0),
    GlobalSearch = false,
    
    Position = UDim2.fromOffset(100, 100),
    Center = true,
    
    EnableSidebarResize = true,
    EnableCompacting = true,
    SidebarCompacted = false,
    MinContainerWidth = 256,
    			TabPadding = 4,
			MenuFadeTime = 0,
		})

	Tabs = {
    -- 创建一个标题为"通用"的标签页
    Main = Window:AddTab('通用', "house"),

    -- 创建一个标题为"存档"的标签页
    Saves = Window:AddTab('存档', "save"),

    -- 创建一个标题为"配置"的标签页
    UISettings = Window:AddTab('配置', "settings"),
}

		ReplicatedStorage = game:GetService("ReplicatedStorage")
		RunService = game:GetService("RunService")
		SoundService = game:GetService("SoundService")
		TweenService = game:GetService("TweenService")

		while not game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI") do
			task.wait()
		end

		while game.Players.LocalPlayer.Character == nil do
			task.wait()
		end

		while #workspace:GetChildren() == 0 do
			task.wait()
		end

		if not ExecutorSupport then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/AbysallHub/refs/heads/main/ExecutorTest.lua"))()
task.wait()
		end

	

		while not ExecutorSupport do
			task.wait()
		end

		local RemotesFolder
		if ReplicatedStorage:FindFirstChild("RemotesFolder") then
			RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder")
		elseif ReplicatedStorage:FindFirstChild("EntityInfo") then
			RemotesFolder = ReplicatedStorage:FindFirstChild("EntityInfo")
		else
			RemotesFolder = ReplicatedStorage:FindFirstChild("Bricks")
		end

		Library.ScreenGui.DisplayOrder = 999999

		ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/ESPLibrary/refs/heads/main/Library.lua"))()


		UnlockedBadges = {}

		CodesList = {
			"67",
			"54",
			"41",
			"CHEDDAR BALLS",
			"XQC",
			"PENGUINZ0",
			"KREEKCRAFT",
			"ISHOWSPEED",
			"DANTDM",
			"KUBZ SCOUTS",
			"FIND THE TROLLFACES",
			"THINKNOODLES",
			"W",
			"RAGDOLL UNIVERSE",
			"RAGDOLL MAYHEM",
			"BIJUU MIKE",
			"8BITRYAN",
			"SCREECHSUCKS",
			"LORE",
			"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
			"FIND THE TROLLFACES",
				"3rd",
				"LAZYDEVS",
				"RAGDOLL COMBAT",
				"VOCAB HAVOC",
				"PATHSWAP",
				"JUMP OVER THE BRICK"
		}

		for i,Frame in pairs(Player.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
			if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
				table.insert(UnlockedBadges, Frame.Name)
			end
		end

		Player.PlayerGui.MainUI.LobbyFrame.Achievements.List.ChildAdded:Connect(function(Frame)
			RunService.Heartbeat:Wait()
			if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
				table.insert(UnlockedBadges, Frame.Name)
			end
		end)

		 local CustomPhysicalProperties
		 PartProperties = {}

		 Character = Player.Character

		 HumanoidRootPart = Character.HumanoidRootPart
		 Humanoid = Character.Humanoid

		local fly = {
			enabled = false,
			flyBody = Instance.new("BodyVelocity"),
			flyGyro = Instance.new("BodyGyro"),
		}






		fly.flyBody.Velocity = Vector3.zero
		fly.flyBody.MaxForce = Vector3.one * 9e9

		fly.flyGyro.P = 6500
		fly.flyGyro.MaxTorque = Vector3.new(4000000,4000000,4000000)
		fly.flyGyro.D = 500

		if HumanoidRootPart.CustomPhysicalProperties ~= nil then
			CustomPhysicalProperties = PhysicalProperties.new(100, HumanoidRootPart.CustomPhysicalProperties.Friction, HumanoidRootPart.CustomPhysicalProperties.Elasticity, HumanoidRootPart.CustomPhysicalProperties.FrictionWeight, HumanoidRootPart.CustomPhysicalProperties.ElasticityWeight)
		end

WorldTab = Tabs.Main:AddLeftGroupbox('世界')


WorldTab:AddSlider('Walkspeed',{
    Text = "移动速度",
    Default = 19,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = false
})



WorldTab:AddDivider()

WorldTab:AddToggle('Noclip', {
    Text = '穿墙模式',
    Default = false, -- 默认值（true / false）
    Tooltip = '禁用碰撞检测，允许你穿过物体行走', -- 悬停时显示的信息

    Callback = function(Value)

    end

}):AddKeyPicker('NoclipKeybind', {


    Default = 'N', -- 按键名称（MB1、MB2 为鼠标按键）
    SyncToggleState = true,


    -- 你可以自定义模式，但我从未用过
    Mode = 'Toggle', -- 模式：Always（始终）、Toggle（切换）、Hold（按住）

    Text = '穿墙模式', -- 按键菜单中显示的文字
    NoUI = false, -- 设为 true 可在按键菜单中隐藏

    -- 按键按下时触发，Value 为 true / false
    Callback = function(Value)



    end,

    -- 按键本身被更改时触发，New 是 KeyCode 枚举或 UserInputType 枚举
    ChangedCallback = function(New)
    end
})

WorldTab:AddToggle('NoAccell', {
    Text = '无加速度',
    Default = false, -- 默认值（true / false）
    Tooltip = '防止角色因高移动速度而滑动。', -- 悬停时显示的信息

    Callback = function(Value)


        for i,part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then

                if Value == true then
                    part.CustomPhysicalProperties = CustomPhysicalProperties
                else
                    part.CustomPhysicalProperties = PartProperties[part]
                end
            end
        end
    end
})

WorldTab:AddDivider()

WorldTab:AddToggle('Fly', {
    Text = '飞行',
    Default = false, -- 默认值（true / false）
    Tooltip = '允许你的角色飞行。', -- 悬停时显示的信息

    Callback = function(Value)

        fly.enabled = Value

        if Value then
            fly.flyBody.Parent = Collision
        else
            fly.flyBody.Parent = nil
        end

        if Value == true then 
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        else
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end

    end
}):AddKeyPicker('FlyKeybind', {


    Default = 'F', -- 按键名称（MB1、MB2 为鼠标按键）
    SyncToggleState = true,


    -- 你可以自定义模式，但我从未用过
    Mode = 'Toggle', -- 模式：Always（始终）、Toggle（切换）、Hold（按住）

    Text = '飞行', -- 按键菜单中显示的文字
    NoUI = false, -- 设为 true 可在按键菜单中隐藏

    -- 按键按下时触发，Value 为 true / false
    Callback = function(Value)


    end,

    -- 按键本身被更改时触发，New 是 KeyCode 枚举或 UserInputType 枚举
    ChangedCallback = function(New)
    end
})		

WorldTab:AddSlider('FlySpeed', {
    Text = '飞行速度',
    Default = 25,
    Min = 0,
    Max = 60,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        flyspeed = Value

    end
})



MainLeftGroupbox = Tabs.Main:AddRightGroupbox('玩家')
MainLeftGroupbox:AddToggle('SpamBadges',{
    Text = "循环切换成就",
    Default = false,
    Tooltip = '快速随机装备一个徽章'
})
MainLeftGroupbox:AddSlider('SpamBadgesDelay',{
    Text = "切换间隔",
    Default = 0.1,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true
})

MainLeftGroupbox:AddDivider()
MainLeftGroupbox:AddToggle('ElevatorSniper',{
    Text = "自动加入电梯",
    Default = false,
    Tooltip = "自动加入选中玩家的电梯"
})


MainLeftGroupbox:AddDropdown('ElevatorSniperTarget', {
    SpecialType = 'Player',
    Default = 0,
    Multi = false,
    Text = '玩家',
    Tooltip = nil,
    Compact = true,

})

MiscTab = Tabs.Main:AddRightGroupbox('杂项')



MiscTab:AddToggle('DisableAFKKick', {
    Default = false,
    Text = '禁止AFK踢出',
    Tooltip = '防止Roblox在20分钟后将你踢出。'
})

local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    if Toggles.DisableAFKKick.Value then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

MiscTab:AddDivider()

MiscTab:AddButton{
    Text = '兑换所有兑换码',
    DoubleClick = false,
    Tooltip = '兑换游戏中当前所有有效的兑换码',
    Func = function()
        for i,ShopCode in pairs(CodesList) do
            RemotesFolder.ShopCode:FireServer(ShopCode)
            task.wait(1.1)
        end
    end
}



MiscTab:AddButton({
    Text = '重新加入服务器',
    DoubleClick = true,
    Tooltip = '重新加入当前服务器。',
    Func = function()
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        if #Players:GetPlayers() <= 1 then
            Player:Kick("\n正在重新加入...")
            task.wait()
            TeleportService:Teleport(PlaceId, Players.LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
        end
    end
})

		for i,part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") then
				PartProperties[part] = part.CustomPhysicalProperties
				if Toggles.NoAccell.Value then
					part.CustomPhysicalProperties = CustomPhysicalProperties
				end
			end
		end

		local MainConnection = RunService.RenderStepped:Connect(function()



			TweenService:Create(fly.flyGyro, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {CFrame = game.Workspace.CurrentCamera.CFrame}):Play()

			local function u2()



				if Character:WaitForChild("Humanoid").MoveDirection == Vector3.new(0, 0, 0) then

					local NewVelocity = Character:WaitForChild("Humanoid").MoveDirection



					return Character:WaitForChild("Humanoid").MoveDirection

				else


				end
				local v12 = (game.Workspace.CurrentCamera.CFrame * CFrame.new((CFrame.new(game.Workspace.CurrentCamera.CFrame.p, game.Workspace.CurrentCamera.CFrame.p + Vector3.new(game.Workspace.CurrentCamera.CFrame.lookVector.x, 0, game.Workspace.CurrentCamera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - game.Workspace.CurrentCamera.CFrame.p;
				if v12 == Vector3.new() then
					return v12
				end
				return v12.unit
			end
			if fly.enabled == true then
				local velocity = Vector3.zero

				velocity = u2()


				TweenService:Create(fly.flyBody, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {Velocity = velocity * (Options.FlySpeed.Value)}):Play()



				fly.flyBody.Parent = Character.HumanoidRootPart
				fly.flyGyro.Parent = Character.HumanoidRootPart



			else

				fly.flyBody.Parent = ReplicatedStorage
				fly.flyGyro.Parent = ReplicatedStorage



			end
			Character.Humanoid.WalkSpeed = Options.Walkspeed.Value


			Character.Humanoid.PlatformStand = (Toggles.Fly.Value and true or Options.FlyKeybind:GetState() == true and true or false)

			for i,part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") then
					if part.Name == "UpperTorso" then
						part.CanCollide = (not Toggles.Noclip.Value and not Options.NoclipKeybind:GetState() == true and true or false)
					else
						part.CanCollide = false
					end
				end
			end
		end)



		task.wait()


		Connections = {}




		Elevators = workspace.Lobby.LobbyElevators:GetChildren()

		function CheckElevators()
			local TargetFound = false
			if not Toggles.ElevatorSniper.Value then
				return
			end
			local TargetCharacter = Options.ElevatorSniperTarget.Value.Character
			for i,Elevator in pairs(workspace.Lobby.LobbyElevators:GetChildren()) do
				if Elevator:GetAttribute("ID") == TargetCharacter:GetAttribute("InGameElevator") then
						TargetFound = true
						RemotesFolder.ElevatorJoin:FireServer(Elevator)

					end

				

			end
			if TargetFound == false then
				RemotesFolder.ElevatorExit:FireServer()
			end
		end

	


		ElevatorAddedConnection = RunService.RenderStepped:Connect(function()

			if Toggles.ElevatorSniper.Value and Options.ElevatorSniperTarget.Value then
			CheckElevators()
			end

		end)

		

		CharacterAddedConnection = Player.CharacterAdded:Connect(function(NewCharacter)
			Character = NewCharacter

			HumanoidRootPart = NewCharacter.HumanoidRootPart
			Humanoid = NewCharacter.Humanoid

			for i,part in pairs(NewCharacter:GetDescendants()) do
				if part:IsA("BasePart") then
					PartProperties[part] = part.CustomPhysicalProperties
				end
			end
		end)





		-- I set NoUI so it does not show up in the keybinds menu


		PreviousBadge = ""
		local SpamBadgeCooldown = false
		SpamConnection = RunService.RenderStepped:Connect(function()
			if SpamBadgeCooldown then
				return
			end
			SpamBadgeCooldown = true
			if Toggles.SpamBadges.Value then


				local Badge = UnlockedBadges[math.random(1,#UnlockedBadges)]

				if Badge == PreviousBadge then

					while task.wait() do
						local NewBadge = UnlockedBadges[math.random(1,#UnlockedBadges)]

						if NewBadge ~= PreviousBadge then
							Badge = NewBadge
							break
						end
					end
				end





				for i,Frame in pairs(Player.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
					if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
						Player.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Frame.Name).Icons.Star.Visible = false
					end
				end


				RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
				PreviousBadge = Badge
				Player.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Badge).Icons.Star.Visible = true

			end

			task.wait(Options.SpamBadgesDelay.Value)

			SpamBadgeCooldown = false


		end)

local ElevatorManagerLeft = Tabs.Saves:AddLeftGroupbox('创建')

		local ModifierExclude = {
			"AdminPanel",
			"CustomSeed",
			"StreamerMode",
			"BeforePlus",
			"SuperHardMode",
			"RetroMode",
			"Ranked",
			"Template"
		}

		local NonMinesModifiers = {
			"Every Angle",
			"New Roommate",
			"Locked And Loaded",
			"Key Key Key Key",
			"Rush Around",
			"Watch Your Step",
			"Are Those Pancakes?!",
			"I Love Pancakes!!!"
		}

		local ModifierList = {

		}



		local ModifierFileNames = {

		}

		local ModifierFrames = {}

		for i,Modifier in pairs(Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers:GetChildren()) do
			if Modifier:IsA("TextButton") and not table.find(ModifierExclude, Modifier.Name) then
				table.insert(ModifierList, Modifier.Text)
				ModifierFileNames[Modifier.Text] = Modifier.Name
				table.insert(ModifierFrames, Modifier)
			end
		end

		local FloorFileNames = {
			['The Hotel'] = "Hotel",
			['The Mines'] = "Mines",
			['The Backdoor'] = "Backdoor",
			['The Outdoors'] = "Garden",
			['The Rooms'] = 'Rooms'
		}

		Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.ChildAdded:Connect(function(Child)
			if Child:IsA("TextButton") and not table.find(ModifierExclude, Child.Name) then
				table.insert(ModifierFrames, Child)
			end
		end)

		Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.ChildRemoved:Connect(function(Child)
			for i,Modifier in pairs(ModifierFrames) do
				if Modifier == Child then
					table.remove(ModifierFrames, i)
				end
			end
		end)




		SaveManager:SetIgnoreIndexes({
			"ElevatorMaxPlayers", "ElevatorModifiers", "ElevatorFloor", "ElevatorFriendsOnly"

		})


ElevatorManagerLeft:AddSlider('ElevatorMaxPlayers', {
    Text = "最大玩家数",
    Min = 1,
    Max = 50,
    Default = 1,
    Rounding = 0
})

ElevatorManagerLeft:AddDropdown('ElevatorModifiers', {
    Text = "修改器",
    Values = ModifierList,
    Default = 0,
    AllowNull = true,
    Multi = true

})

ElevatorManagerLeft:AddDropdown('ElevatorFloor', {
    Text = "目的地",
    Values = {'旅馆', '矿井', '后门', '房间', '复古模式','派对模式' , '超级困难模式!!!', '旅馆-', '户外'},
    Default = 1
})

ElevatorManagerLeft:AddToggle('ElevatorFriendsOnly', {
    Text = "仅限好友",
    Default = false,
    Tooltip = nil
})

ElevatorManagerLeft:AddDivider()

ElevatorManagerLeft:AddButton({
    Text = "创建电梯",
    Tooltip = '使用所选选项创建一部电梯。',
    DoubleClick = false,
    Func = function()
        local NewModifierList = {}
        local Floor = nil

        for i,Modifier in pairs(ModifierList) do
            if Options.ElevatorModifiers.Value[Modifier] then
                table.insert(NewModifierList, ModifierFileNames[Modifier])
            end
        end


				Floor = FloorFileNames[Options.ElevatorFloor.Value] or nil

				if Options.ElevatorFloor.Value == "SUPER HARD MODE!!!" then
					table.insert(NewModifierList, "SuperHardMode")
				end
				if Options.ElevatorFloor.Value == "Hotel-" then
					table.insert(NewModifierList, "BeforePlus")
				end
				if Options.ElevatorFloor.Value == "Retro Mode" then
					table.insert(NewModifierList, "RetroMode")
				end
				if Options.ElevatorFloor.Value == "Party Mode" then
					table.insert(NewModifierList, "Ranked")
				end

				if Floor == nil and #NewModifierList > 1 then
					Library:Notify("Elevator creation failed:\nThe floor '" .. Options.ElevatorFloor.Value .. "' does not support modifiers.", 8)
					Sound()
					return
				end




				local OverlappingModifiers = {
					["Ambush"] = {},
					["Chaos"] = {},
					["Dread"] = {},
					["DupeSpawn"] = {},
					["EntitySpawn"] = {},
					["SpawnEyes"] = {},
					["Firedamp"] = {},
					["Giggle"] = {},
					["Gloombat"] = {},
					["Gold"] = {},
					["Items"] = {},
					["Lights"] = {},
					["PlayerHealth"] = {},
					["PlayerSpeed"] = {},
					["Rooms"] = {},
					["ScreechSpeed"] = {},
					["Timothy"] = {},
					["Key"] = {},
					["Snare"] = {}
				}
				for i,Modifier in pairs(ModifierFrames) do
					if Options.ElevatorModifiers.Value[Modifier.Text] and Modifier:GetAttribute("Merge") ~= nil then
						table.insert(OverlappingModifiers[Modifier:GetAttribute("Merge")], Modifier.Text)
					end
				end

				for i,ModifierTable in pairs(OverlappingModifiers) do
					local Text = ""
					for i,Modifier in pairs(ModifierTable) do
						Text = Text .. "\n'" .. Modifier .. "'" 
					end



					if #ModifierTable > 1 then
Library:Notify("电梯创建失败：\n以下修改器互相冲突： " .. Text, 8)
						Sound()
						return
					end

				end

				local LockedModifiers = {}
				local HotelOnlyModifiers = {}

				for i,Modifier in pairs(ModifierFrames) do
					if Modifier:FindFirstChild("Locked") then
						if Options.ElevatorModifiers.Value[Modifier.Text] and Modifier:FindFirstChild("Locked").Visible == true then
							table.insert(LockedModifiers, Modifier.Text)
						end
					end






				end

				for i,Modifier in pairs(ModifierList) do


					if Floor == "Mines" and Options.ElevatorModifiers.Value[Modifier] and table.find(NonMinesModifiers, Modifier) then
						table.insert(HotelOnlyModifiers, Modifier)

					end






				end








				if #LockedModifiers > 0 then
					local Text = ""
					for i,Modifier in pairs(LockedModifiers) do
						Text = Text .. "\n'" .. Modifier .. "'" 
					end
	Library:Notify("电梯创建失败：\n以下修改器已被锁定： " .. Text, 8)
Sound()
return
end

if #HotelOnlyModifiers > 0 then
    local Text = ""
    for i,Modifier in pairs(HotelOnlyModifiers) do
        Text = Text .. "\n'" .. Modifier .. "'" 
    end
    Library:Notify("电梯创建失败：\n以下修改器不能在'矿井'中使用： " .. Text, 8)
    Sound()
    return
end

if Floor == nil and #NewModifierList > 1 then
    Library:Notify("电梯创建失败：\n楼层 '" .. Options.ElevatorFloor.Value .. "' 不支持修改器。", 8)
					Sound()
					return
				end

				if Floor == nil then
					Floor = "酒店"
				end


				RemotesFolder.CreateElevator:FireServer({

					Mods = NewModifierList,
					MaxPlayers = tostring(Options.ElevatorMaxPlayers.Value),
					Settings = {},
					FriendsOnly = Toggles.ElevatorFriendsOnly.Value,
					Destination = Floor

				})
			end,
		})

ElevatorManagerLeft:AddButton{
    Text = "从游戏界面导入",
    Tooltip = '将设置更改为当前在大厅界面中选中的内容。',
    DoubleClick = true,
    Func = function()

        local SelectedModifiers = {}

        for i,Modifier in pairs(ModifierFrames) do
            if Modifier:FindFirstChild("UIStroke") then
                if Modifier:FindFirstChild("UIStroke").Enabled then
                    SelectedModifiers[Modifier.Text] = true
                end
            end
        end

        local Floor = "旅馆"

        if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Floors.Mines.Visible == true then
            Floor = "矿井"
        end

        if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Floors.Backdoor.Visible == true then
            Floor = "后门"
        end

        if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Floors.Garden.Visible == true then
            Floor = "户外"
        end

        if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Floors.Hotel.Visible == true then
            if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers:FindFirstChild("SuperHardMode") then
                if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.SuperHardMode.UIStroke.Enabled == true then
                    Floor = "超级困难模式!!!"
                end
                if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.BeforePlus.UIStroke.Enabled == true then
                    Floor = "旅馆-"
                end
                if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.RetroMode.UIStroke.Enabled == true then
                    Floor = "复古模式"
                end
                if Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.Ranked.UIStroke.Enabled == true then
                    Floor = "派对模式"
                end
            end
        end

        Options.ElevatorFloor:SetValue(Floor)
        Options.ElevatorMaxPlayers:SetValue(tonumber(Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Settings.MaxPlayers.Toggle.Text))
        Options.ElevatorModifiers:SetValue(SelectedModifiers)
        Toggles.ElevatorFriendsOnly:SetValue(Player.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Settings.FriendsOnly:GetAttribute("Setting"))

        Library:Notify("<b>[" .. AbysallHubSettings.Name .. "]</b>" .. "\n" .. '成功导入电梯设置！', 8)
				Sound()

			end,
		}

local ElevatorManager = {
    Folder = ScriptName .. "/Doors/Elevators"  -- 电梯配置文件存放路径
}

local httpService = game:GetService("HttpService")

function ElevatorManager:GetPaths()  -- 获取所有层级路径
    local paths = {}

    local parts = self.Folder:split("/")
    for idx = 1, #parts do
        paths[#paths + 1] = table.concat(parts, "/", 1, idx)
    end

    paths[#paths + 1] = self.Folder

    return paths
end

function ElevatorManager:BuildFolderTree()  -- 创建文件夹目录
    local paths = self:GetPaths()

    for i = 1, #paths do
        local str = paths[i]
        if not isfolder(str) then
            makefolder(str)
        end
    end
end

function ElevatorManager:CheckFolderTree()  -- 检查并确保文件夹存在
    if isfolder(self.Folder) then
        return
    end
    self:BuildFolderTree()

    task.wait(0.1)
end

ElevatorManager:CheckFolderTree()

function ElevatorManager:SaveElevator(file, maxplayers, modifiers, destination, friendsonly)  -- 保存电梯配置
    if file:gsub(" ", "") == "" then
        return Library:Notify("电梯文件名无效（为空）", 3)
    end

    local theme = {
        maxplayers,      -- 最大玩家数
        modifiers,       -- 修改器
        destination,     -- 目的地
        friendsonly      -- 仅限好友
    }

    writefile(self.Folder .. "/" .. file .. ".json", httpService:JSONEncode(theme))

    Library:Notify(string.format("已创建电梯配置 %q", file))
end

function ElevatorManager:OverwriteElevator(file, maxplayers, modifiers, destination, friendsonly)  -- 覆盖电梯配置
    if file:gsub(" ", "") == "" then
        return Library:Notify("电梯文件名无效（为空）", 3)
    end

    local existingfile = self.Folder .. "/" .. file .. ".json"

			local theme = {
				maxplayers,
				modifiers,
				destination,
				friendsonly
			}


			writefile(existingfile, httpService:JSONEncode(theme))

	Library:Notify(string.format("已覆盖电梯配置 %q", file))



		end

		function ElevatorManager:Delete(name)
			if not name then
				return false, "no elevator file is selected"
			end

			local file = self.Folder .. "/" .. name .. ".json"
			if not isfile(file) then
				return false, "invalid file"
			end

			local success = pcall(delfile, file)
			if not success then
				return false, "delete file error"
			end

			return true
		end

		function ElevatorManager:ReloadElevators()
			local list = listfiles(self.Folder)

			local out = {}
			for i = 1, #list do
				local file = list[i]
				if file:sub(-5) == ".json" then
					-- i hate this but it has to be done ...

					local pos = file:find(".json", 1, true)
					local start = pos

					local char = file:sub(pos, pos)
					while char ~= "/" and char ~= "\\" and char ~= "" do
						pos = pos - 1
						char = file:sub(pos, pos)
					end

					if char == "/" or char == "\\" then
						table.insert(out, file:sub(pos + 1, start - 1))
					end
				end
			end

			return out
		end

		function ElevatorManager:GetElevator(file)
			local path = self.Folder .. "/" .. file .. ".json"
			if not isfile(path) then
				return nil
			end

			local data = readfile(path)
			local success, decoded = pcall(httpService.JSONDecode, httpService, data)

			if not success then
				return nil
			end

			return decoded
		end

		function ElevatorManager:ApplyElevator(elevator)
			local data = ElevatorManager:GetElevator(elevator)

			if not data then
				return
			end

			Options.ElevatorMaxPlayers:SetValue(data[1])
			Options.ElevatorFloor:SetValue(data[3])

			local SelectedModifiers = {}

			for i,Modifier in pairs(data[2]) do

				SelectedModifiers[Modifier] = true
			end

			Options.ElevatorModifiers:SetValue(SelectedModifiers)

			Toggles.ElevatorFriendsOnly:SetValue(data[4])


		end

		function AddElevatorManager(groupbox)
groupbox:AddInput("ElevatorName", { Text = "电梯名称" })
groupbox:AddButton("创建电梯", function()
    if Library.Options.ElevatorName.Value:gsub(" ", "") == ""  then
        Library:Notify("创建电梯失败：名称为空")
        return
    end

    local SelectedModifiers = {}

    for i,Modifier in pairs(ModifierList) do
        if Options.ElevatorModifiers.Value[Modifier] then
            table.insert(SelectedModifiers, Modifier)
        end
    end

    ElevatorManager:SaveElevator(Library.Options.ElevatorName.Value, Options.ElevatorMaxPlayers.Value, SelectedModifiers, Options.ElevatorFloor.Value, Toggles.ElevatorFriendsOnly.Value)

    Library.Options.ElevatorList:SetValues(ElevatorManager:ReloadElevators())
    Library.Options.ElevatorList:SetValue(nil)
end)

groupbox:AddDivider()
groupbox:AddDropdown(
    "ElevatorList",
    { Text = "已保存的电梯", Values = ElevatorManager:ReloadElevators(), AllowNull = true, Default = 0 }
)
groupbox:AddButton("加载电梯", function()
    local name = Options.ElevatorList.Value

    if not name then
        Library:Notify("加载电梯失败：未选择电梯配置文件")
        return
    end

    ElevatorManager:ApplyElevator(name)
    Library:Notify(string.format("已加载电梯配置 %q", name))
end)
groupbox:AddButton("覆盖电梯", function()
    local name = Library.Options.ElevatorList.Value

    if not name then
        Library:Notify("覆盖电梯失败：未选择电梯配置文件")
        return
    end

    local SelectedModifiers = {}

    for i,Modifier in pairs(ModifierList) do
        if Options.ElevatorModifiers.Value[Modifier] then
            table.insert(SelectedModifiers, Modifier)
        end
    end

    ElevatorManager:OverwriteElevator(name, Options.ElevatorMaxPlayers.Value, SelectedModifiers, Options.ElevatorFloor.Value, Toggles.ElevatorFriendsOnly.Value)

end)
groupbox:AddButton("删除电梯", function()
    local name = Library.Options.ElevatorList.Value

    local success, err = ElevatorManager:Delete(name)
    if not success then
        return Library:Notify("删除电梯失败：" .. err)
    end

    Library:Notify(string.format("已删除电梯配置 %q", name))
    Library.Options.ElevatorList:SetValues(ElevatorManager:ReloadElevators())
    Library.Options.ElevatorList:SetValue(nil)
end)
groupbox:AddButton("刷新列表", function()
    Library.Options.ElevatorList:SetValues(ElevatorManager:ReloadElevators())
    Library.Options.ElevatorList:SetValue(nil)
end)
end

local Groupbox = Tabs.Saves:AddRightGroupbox('管理')
AddElevatorManager(Groupbox)
		function Unload()

			Library.ScreenGui.Enabled = false

			for i,Toggle in pairs(Toggles) do
				Toggle:SetValue(false)
			end


			SpamConnection:Disconnect()
			ElevatorAddedConnection:Disconnect()
			MainConnection:Disconnect()


			for i,Connection in pairs(Connections) do
				if Connection ~= nil then
					Connection:Disconnect()
				end
			end

			fly.flyBody:Destroy()
			fly.flyGyro:Destroy()



			Humanoid.PlatformStand = false


			Library:Unload()
			ESPLibrary:Unload()
			Library = nil

			getgenv().YX-HUBHubLoaded = false
			getgenv().Library = nil


			Player.Character:WaitForChild("Humanoid",9e9).WalkSpeed = 19

			task.wait()

			Character.UpperTorso.CanCollide = true



		end








		Library:SetWatermarkVisibility(false)







MenuSettings = Tabs.UISettings:AddRightGroupbox("面板设置")



-- 我设置了 NoUI，所以它不会在按键绑定菜单中显示



MenuSettings:AddToggle('KeybindMenu', {
    Text = '显示按键绑定',
    Default = false, -- 默认值（true / false）
    Tooltip = '切换按键绑定菜单，显示所有按键绑定及其状态。', -- 悬停时显示的信息

    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end

})

MenuSettings:AddToggle('CustomCursor', {
    Text = '自定义光标',
    Default = (Library.IsMobile == false and true or false), -- 默认值（true / false）
    Tooltip = '切换自定义光标。', -- 悬停时显示的信息

    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end

})

Library.ShowCustomCursor = (Library.IsMobile == false and true or false)

Library:SetWatermarkVisibility(false)  -- 隐藏水印

MenuSettings:AddLabel('切换按键'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = '界面显示/隐藏按键' })
MenuSettings:AddDivider()
MenuSettings:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",

    Text = "DPI 缩放",

    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)

        Library:SetDPIScale(DPI)
    end,
})
MenuSettings:AddButton({
    Text = "卸载",
    Tooltip = "完全卸载界面，禁用所有功能，让游戏恢复到执行前的状态。",
    DoubleClick = true,
    Func = function()
        Unload()
    end,
}):AddButton({
    Text = "重新加载",
    Tooltip = "卸载脚本并重新执行。",
    DoubleClick = true,
    Func = function()
        Unload()
        task.wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/AbysallHub/refs/heads/main/Loader.lua"))()
    end,
})
		Library.ToggleKeybind = Options.MenuKeybind

		Options.MenuKeybind:OnChanged(function(Value)
			Library.ToggleKeybind = Options.MenuKeybind
		end)


		SaveManager:SetLibrary(Library)
		ThemeManager:SetLibrary(Library)
		ThemeManager:SetFolder(ScriptName)
		SaveManager:SetFolder(ScriptName .. "/Doors/Lobby")

		SaveManager:IgnoreThemeSettings()
		ThemeManager:ApplyToTab(Tabs.UISettings)

		SaveManager:BuildConfigSection(Tabs.UISettings)

		SaveManager:LoadAutoloadConfig()

		ErrorConnection:Disconnect()

		

	else


		Functions = {}
		RenderConnections = {}
		DestroyElements = {}

		ReplicatedStorage = game:GetService("ReplicatedStorage")
		RunService = game:GetService("RunService")
		SoundService = game:GetService("SoundService")
		TweenService = game:GetService("TweenService")
		PathfindingService = game:GetService("PathfindingService")


		local RemotesFolder
		if ReplicatedStorage:FindFirstChild("RemotesFolder") then
			RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder")
		elseif ReplicatedStorage:FindFirstChild("EntityInfo") then
			RemotesFolder = ReplicatedStorage:FindFirstChild("EntityInfo")
		else
			RemotesFolder = ReplicatedStorage:FindFirstChild("Bricks")
		end
		local Floor = ReplicatedStorage.GameData.Floor.Value

local FloorText = "旅馆"

if Floor == "Mines" then
    FloorText = "矿井"
end

if Floor == "Backdoor" then
    FloorText = "后门"
end

if Floor == "Rooms" then
    FloorText = "房间"
end

if Floor == "Fools" then
    FloorText = "超级困难模式!!!"
end

if Floor == "Retro" then
    FloorText = "复古模式"
end

if Floor == "Party" then
    FloorText = "派对模式"
end

if Floor == "Garden" then
    FloorText = "户外"
end

if RemotesFolder.Name == "Bricks" then
    FloorText = "旅馆（酒店+ 之前）"
end

		Window = Library:CreateWindow({

			Title = ScriptName,
			    Icon = "rbxassetid://71400987113958", 
    Size = UDim2.fromOffset(750, 650),
    AutoShow = true,
    NotifySide = "Right",
    ShowCustomCursor = true,
    IconSize = UDim2.fromOffset(30, 30),
    Resizable = true,
    MobileButtonsSide = "Left",
    DisableSearch = false,
    SearchbarSize = UDim2.new(0.8, 0, 1, 0),
    GlobalSearch = false,
    
    Position = UDim2.fromOffset(100, 100),
    Center = true,
    
    EnableSidebarResize = true,
    EnableCompacting = true,
    SidebarCompacted = false,
    MinContainerWidth = 256,
			TabPadding = 4,
			MenuFadeTime = 0,
			Footer = "Doors: " .. FloorText
		})

Tabs = {
    Main = Window:AddTab('通用', "house"),
    Exploits = Window:AddTab('漏洞利用', "shield-ban"),
    ESP = Window:AddTab('透视', "scan-search"),
    Visuals = Window:AddTab('视觉', "scan-eye"),
    Floor = Window:AddTab('楼层', "earth"),
    Misc = Window:AddTab('杂项', "boxes"),
    UISettings = Window:AddTab('配置', "settings"),
}





			while not game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI") do
			task.wait()
		end

		while game.Players.LocalPlayer.Character == nil do
			task.wait()
		end

		while #workspace:GetChildren() == 0 do
			task.wait()
		end

		if not ExecutorSupport then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/AbysallHub/refs/heads/main/ExecutorTest.lua"))()
task.wait()
		end

		while not ExecutorSupport do
			task.wait()
		end


		ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/ESPLibrary/refs/heads/main/Library.lua"))()
				
		PathfindingFolder = Instance.new("Folder")
		PathfindingFolder.Name = ESPLibrary:GenerateRandomString()
		PathfindingFolder.Parent = game.Workspace

		ChatNotifyMessage = " has spawned!"
		TextChatService = game:GetService("TextChatService")
		function ChatNotify(Text)
			local Folder = ReplicatedStorage:FindFirstChild("DefaultChatSystemEvents") or Instance.new("Folder")
			local Event = Folder:FindFirstChild("SayMessageRequest") or Instance.new("RemoteEvent")
			Event:FireServer(
				Text,
				"All")
			local textchannel = (game:GetService("TextChatService"):FindFirstChild("TextChannels") and game:GetService("TextChatService"):FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral") or Instance.new("TextChannel"))
			textchannel:SendAsync(Text)



		end
		function GetNearestAssetWithCondition(condition)
			local nearestDistance = math.huge
			local nearest
			for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
				if room:FindFirstChild("Assets") then

				for _, asset in pairs(room.Assets:GetChildren()) do
					if asset:FindFirstChild("HiddenPlayer") then
						if condition(asset) and Player:DistanceFromCharacter(asset.PrimaryPart.Position) < nearestDistance then
							nearestDistance = Player:DistanceFromCharacter(asset.PrimaryPart.Position)
							nearest = asset
						end
					end
				end
			end
        end

			return nearest
		end

		function DisableTouching(Part)
			if not Part:IsA("BasePart") then
				return
			end

			Part.CanTouch = false
			if Part:FindFirstChild("TouchInterest") then
				Part:FindFirstChild("TouchInterest"):Destroy()
			end
		end

		Connections = {}

		notifvolume = 3
		EntityCounter = 0
		GlitchCounter = 0


		NotifyType = "Default"
		pingid = "4590662766" 
		monsternotif = false
		DeletingSeek = false
		tracerthickness = 1





		function GetPadlockCode(paper)
			if paper:FindFirstChild("UI") then
				local code = {}

				for _, image in pairs(paper.UI:GetChildren()) do
					if image:IsA("ImageLabel") and tonumber(image.Name) then
						code[image.ImageRectOffset.X .. image.ImageRectOffset.Y] = {tonumber(image.Name), "_"}
					end
				end

				for _, image in pairs(game.Players.LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()) do
					if image.Name == "Icon" then
						if code[image.ImageRectOffset.X .. image.ImageRectOffset.Y] then
							code[image.ImageRectOffset.X .. image.ImageRectOffset.Y][2] = image.TextLabel.Text
						end
					end
				end

				local normalizedCode = {}
				for _, num in pairs(code) do
					normalizedCode[num[1]] = num[2]
				end

				return table.concat(normalizedCode)
			end

			return "_____"
		end




		OtherLinora = false


		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		
		local Main_Game = nil
		local CamShake = {}


		Library.ScreenGui.DisplayOrder = 999999


		local function Notify(notifytable)



			RunService.RenderStepped:Wait()

			local reason = nil
			if notifytable.Reason then
				reason = "\n" .. notifytable.Reason
			else
				reason = ""
			end
			if NotifyType == "Default" then

				Library:Notify("<b>[" .. AbysallHubSettings.Name .. "]</b>" .. "\n" .. notifytable.Description .. reason,notifytable.Time or 8)


			elseif NotifyType == "Doors" then
				DoorsNotify(notifytable)

			end
		end
		local function Sound()
			if notif == true and NotifyType ~= "Doors" then

				local achievement = game.Players.LocalPlayer.PlayerGui.MainUI["AchievementsHolder"].Achievement:Clone()
				achievement.Parent = game.Players.LocalPlayer.PlayerGui.MainUI["AchievementsHolder"]
				local sound = achievement.Sound


				sound.Volume = Options.NotificationSoundVolume.Value

				sound.SoundId = "rbxassetid://"..pingid


				sound:Play()

				game:GetService("Debris"):AddItem(achievement,15)

			end
		end
		Library.NotifySide = "Right"



		local flytoggle = false







		local BreakerSolving = false
		AutoBreaker = false

		function EnableBreaker(Breaker)
			if Breaker:GetAttribute("Enabled") == false then
				Breaker:SetAttribute("Enabled", true)
				Breaker:WaitForChild("Light", 9e9).Material = Enum.Material.Neon
				Breaker:WaitForChild("Light", 9e9).Attachment.Spark:Emit(1)
				Breaker:WaitForChild("PrismaticConstraint", 9e9).TargetPosition = -0.2
				Breaker:WaitForChild("Sound", 9e9):Play()
			end
		end

		function DisableBreaker(Breaker)
			if Breaker:GetAttribute("Enabled") == true then
				Breaker:SetAttribute("Enabled", false)
				Breaker:WaitForChild("Light", 9e9).Material = Enum.Material.Glass
				Breaker:WaitForChild("PrismaticConstraint", 9e9).TargetPosition = 0.2
				Breaker:WaitForChild("Sound", 9e9):Play()
			end
		end



		local Entities = {"RushMoving","AmbushMoving","A60","A120","BackdoorRush","Eyes", "BackdoorLookman", "GlitchRush", "GlitchAmbush", "CustomEntity"}
		local EntityShortNames = {
			["RushMoving"] = "Rush",
			["AmbushMoving"] = "Ambush",
			["A60"] = "A-60",
			["A120"] = "A-120",
			["BackdoorRush"] = "Blitz",
			["Eyes"] = "Eyes",
			["BackdoorLookman"] = "Lookman",
			["Lookman"] = "Eyes",
			["GloombatSwarm"] = "Gloombat Swarm",
			["Jeff"] = "Jeff",
			["Halt"] = "Halt",
			["GlitchRush"] = "Glitched Rush",
			["GlitchAmbush"] = "Glitched Ambush",
			["CustomEntity"] = "Custom Rush",

		}
		local EntityAlliases = {
			["RushMoving"] = "Rush",
			["AmbushMoving"] = "Ambush",
			["A60"] = "A-60",
			["A120"] = "A-120",
			["BackdoorRush"] = "Blitz",
			["Eyes"] = "Eyes",
			["BackdoorLookman"] = "Lookman",
			["Lookman"] = "Eyes",
			["Gloombats"] = "Gloombat Swarm",
			["Halt"] = "Halt",
			["Jeff"] = "Jeff the Killer",
			["Giggle"] = "Giggle",
			["GlitchRush"] = "Glitched Rush",
			["GlitchAmbush"] = "Glitched Ambush",
			["CustomEntity"] = "Custom Rush"
		}
		local EntityNotifers = {
			["Rush"] = false,
			["Ambush"] = false,
			["Eyes"] = false,
			["Blitz"] = false,
			["A-60"] = false,
			["A-120"] = false
		}
		local EntityIcons = {
			["RushMoving"] = "rbxassetid://10716032262",
			["AmbushMoving"] = "rbxassetid://10110576663",
			["A60"] = "rbxassetid://12571092295",
			["A120"] = "rbxassetid://12711591665",
			["BackdoorRush"] = "rbxassetid://16602023490",
			["Eyes"] = "rbxassetid://10183704772",
			["Lookman"] = "rbxassetid://10183704772",
			["BackdoorLookman"] = "rbxassetid://16764872677",
			["GloombatSwarm"] = "rbxassetid://79221203116470",
			["Halt"] = "rbxassetid://11331795398",
			["Jeff"] = "rbxassetid://94479432156278",
			["Giggle"] = "rbxassetid://76353443801508",
			["GlitchRush"] = "rbxassetid://73859273102919",
			["GlitchAmbush"] = "rbxassetid://88369678433359",
			["SallyMoving"] = "rbxassetid://10840888070",
			["MonumentEntity"] = "rbxassetid://88933556873017",
			["Groundskeeper"] = "rbxassetid://114991380115557"
		}
		local EntityChatNotifyMessages = {
			["RushMoving"] = "Rush has spawned!",
			["AmbushMoving"] = "Ambush has spawned!",
			["A60"] = "A-60 has spawned!",
			["A120"] = "A-120 has spawned!",
			["BackdoorRush"] = "Blitz has spawned!",
			["Halt"] = "Halt will spawn in the next room!",
			["GloombatSwarm"] = "Gloombats will be in the next room, turn off all light sources!",
			["Jeff"] = "Jeff has spawned!",
			["Eyes"] = "Eyes has spawned. Don't look at it!",
			["BackdoorLookman"] = "Lookman has spawned. Don't look at it!"
		}
		local EntityList = {"RushMoving","AmbushMoving","Eyes","A60","A120","BackdoorRush","Jeff","GloombatSwarm","Halt","BackdoorLookman"}	
		local Closets = {"Wardrobe","Rooms_Locker","Rooms_Locker_Fridge","Backdoor_Wardrobe","Locker_Large","Toolshed", "Double_Bed", "Dumpster", "CircularVent"}
		local Items = {"Lighter",
			"Flashlight",
			"Lockpick",
			"Vitamins",
			"Bandage",
			"StarVial",
			"StarBottle",
			"StarJug",
			"Shakelight",
			"Straplight",
			"BigLight",
			"Battery",
			"Candle",
			"Crucifix",
			"CrucifixWall",
			"Glowsticks",
			"SkeletonKey",
			"Candy",
			"ShieldMini",
			"ShieldBig",
			"BandagePack",
			"BatteryPack",
			"RiftCandle",
			"Shakelight",
			"LaserPointer",
			"HolyGrenade",
			"Shears",
			"Straplight",
			"Smoothie",
			"Cheese",
			"Bulklight",
			"Bread",
			"AlarmClock",
			"RiftSmoothie",
			"GweenSoda",
			"GlitchCube",
			"Scanner",
			"Bomb",
			"Knockbomb",
			"Nanner",
			"BigBomb",
			"Multitool",
"BoxingGloves"
		}
		local Items2 = {
			"Lighter",
			"Flashlight",
			"Lockpick",
			"Vitamins",
			"Bandage",
			"StarVial",
			"StarBottle",
			"StarJug",
			"Shakelight",
			"Straplight",
			"BigLight",
			"Battery",
			"Candle",
			"Crucifix",
			"CrucifixWall",
			"Glowsticks",
			"SkeletonKey",
			"Candy",
			"ShieldMini",
			"ShieldBig",
			"BandagePack",
			"BatteryPack",
			"RiftCandle",
			"Shakelight",
			"LaserPointer",
			"HolyGrenade",
			"Shears",
			"Straplight",
			"Smoothie",
			"Cheese",
			"Bulklight",
			"Bread",
			"AlarmClock",
			"RiftSmoothie",
			"GweenSoda",
			"GlitchCube",
			"Scanner",
			"Bomb",
			"Knockbomb",
			"Nanner",
			"BigBomb",
			"SnakeBox",
			"GoldGun",
			"StopSign",
			"TipJar",
			"Lantern",
			"IronKey",
			"LotusPetal",
			"Compass",
			"LotusPetalPickup",
			"LanternLitItem",
			"KeyIron",
			"IronKeyForCrypt",
			"LotusHolder",
			"Multitool",
			"RiftJar",
			"AloeVera",
			"Donut",
			"Lotus",
			"BoxingGloves"
		}

		local ItemNames = {                                  
			["Lighter"] = "Lighter",
			["Flashlight"] = "Flashlight",
			["Lockpick"] = "Lockpicks",
			["Vitamins"] = "Vitamins",
			["Bandage"] = "Bandage",
			["StarVial"] = "Vial of Starlight",
			["StarBottle"] = "Bottle of Starlight",
			["StarJug"] = "Barrel of Starlight",
			["Shakelight"] = "Gummy Flashlight",
			["Straplight"] = "Straplight",
			["Bulklight"] = "Spotlight",
			["Battery"] = "Battery",
			["Candle"] = "Candle",
			["Crucifix"] = "Crucifix",
			["CrucifixWall"] = "Crucifix",
			["Glowsticks"] = "Glowstick",
			["SkeletonKey"] = "Skeleton Key",
			["Candy"] = "Candy",
			["ShieldMini"] = "Mini Shield Potion",
			["ShieldBig"] = "Big Shield Potion",
			["BandagePack"] = "Bandage Pack",
			["BatteryPack"] = "Battery Pack",
			["RiftCandle"] = "Moonlight Candle",
			["LaserPointer"] = "Laser Pointer",
			["HolyGrenade"] = "Hold Hand Grenade",
			["Shears"] = "Shears",
			["Smoothie"] = "Smoohie",
			["Cheese"] = "Cheese",
			["Bread"] = "Bread",
			["AlarmClock"] = "Alarm Clock",
			["RiftSmoothie"] = "Moonlight Smoothie",
			["GweenSoda"] = "Gween Soda",
			["GlitchCube"] = "Glitch Fragment",
			["Scanner"] = "NVCS-3000",
			["Bomb"] = "Bomb",
			["Knockbomb"] = "Knockbomb",
			["Nanner"] = "Nanner",
			["BigBomb"] = "Big Bomb",
			["SnakeBox"] = "Hiding Box",
			["GoldGun"] = "Golden Gun",
			["StopSign"] = "Stop Sign",
			["TipJar"] = "Tip Jar",
			["Lantern"] = "Lantern",
			["IronKey"] = "Iron Key",
			["LotusPetal"] = "Lotus Petal",
			["Compass"] = "Compass",
			["LotusPetalPickup"] = "Lotus Petal",
			["LanternLitItem"] = "Lantern",
			["KeyIron"] = "Iron Key",
			["IronKeyForCrypt"] = "Iron Key",
			["LotusHolder"] = "Lotus Petal",
			["Multitool"] = "Multitool",
			["RiftJar"] = "Rift Jar",
			["AloeVera"] = "Aloe Vera",
			["Donut"] = "Donut",
			["Lotus"] = "Lotus",
			["BoxingGloves"] = "Boxing Gloves"
		}
		local SpeedBypassEnabled = false
		local SpeedBypassing = false

		local FakePromptPart = Instance.new("Part")
		FakePromptPart.Anchored = true
		FakePromptPart.Parent = game.Workspace
		FakePromptPart.Position = Vector3.new(9999,9999,9999)
		FakePromptPart.Transparency = 1
		FakePromptPart.Name = ESPLibrary:GenerateRandomString()



		local FOVValue = Instance.new("NumberValue")
		FOVValue.Parent = ReplicatedStorage
		FOVValue.Value = 70



		local bypassdelay = 0.235
		local Character = Player.Character
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Instance.new("Part")
		local Humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or Instance.new("Humanoid")
		local Collision = game.Players.LocalPlayer.Character:FindFirstChild("Collision") or Instance.new("Part")
		local MainWeld = Collision:FindFirstChild("Weld") or Instance.new("ManualWeld")

		CollisionPart = Character:FindFirstChild("CollisionPart") or Collision

		local CollisionClone = Collision:Clone()

		CollisionClone.Parent = Character
		CollisionClone.Name = ESPLibrary:GenerateRandomString()
		CollisionClone.Massless = true
		CollisionClone.CanCollide = false
		CollisionClone.Position = HumanoidRootPart.Position

		local CollisionPartClone = CollisionPart:Clone()
		CollisionPartClone.Parent = Character
		CollisionPartClone.Name = ESPLibrary:GenerateRandomString()
		CollisionPartClone.Massless = true
		CollisionPartClone.Anchored = false

	










		if CollisionClone:FindFirstChild("CollisionCrouch") then
			CollisionClone.CollisionCrouch.Massless = true
			CollisionClone.CollisionCrouch.CanCollide = false
			CollisionClone.CollisionCrouch.Name = ESPLibrary:GenerateRandomString()
		end




		local AvoidingEntity = false



		local CollisionCrouch = Collision:FindFirstChild("CollisionCrouch") or Instance.new("Part")

		local LatestRoom = ReplicatedStorage.GameData.LatestRoom

		local CurrentRoom = LatestRoom.Value

		local ForceSpeedBypass = false


		local SpeedBypassDelay = false
		function SpeedBypass()

			task.spawn(function()
				while task.wait() do

					if Library.Unloaded then
					
						CollisionPartClone.Massless = true
						
						break
					end

					if SpeedBypassEnabled == true or ForceSpeedBypass == true then

						if CollisionPart.Anchored or AvoidingEntity == true then


							
							CollisionPartClone.Massless = true		
							


							task.wait(1)

						elseif Character:GetAttribute("Hiding") == true or Toggles.ACM.Value or Options.AnticheatManipulation:GetState() == true then

						
							CollisionPartClone.Massless = true
							



							task.wait(0.75)

						else






							if SpeedBypassDelay == false then
								SpeedBypassDelay = true
								if CollisionPartClone.Massless == true then
									
									CollisionPartClone.Massless = false
									
								else
								
									CollisionPartClone.Massless = true
									
								end

							end











						end


					else

					
						CollisionPartClone.Massless = true
						




					end




				end






			end)

		end

		local SpeedBypassDelayCooldown = false
		local SpeedBypassConnection = RunService.RenderStepped:Connect(function()
			if SpeedBypassDelayCooldown == false and not CollisionPart.Anchored then
				SpeedBypassDelayCooldown = true
				task.wait(bypassdelay)
				SpeedBypassDelay = false
				SpeedBypassDelayCooldown = false
			end
		end)

		local NewHotel = false

		if RemotesFolder.Name == "RemotesFolder" then
			NewHotel = true
		end

	

			




		local PlayerModule

		local OldFunction

		if ExecutorSupport["require"] == true then
			PlayerModule = require(Player.PlayerScripts.PlayerModule):GetControls()
			OldFunction = PlayerModule.GetMoveVector
			Main_Game = require(game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game)
		
		end

       








		tracerorigin = "Bottom"
		SpeedBoostType = "SpeedBoost"
		MinesAnticheatBypassActive = false
		SpeedBoostEnabled = false
		doorcolor = Color3.fromRGB(0, 170, 255)
		ThirdPersonX = 1.5
		ThirdPersonY = 1
		ThirdPersonZ = 5
		espfadetime = 0.5
		espstrokethickness = 0
		entitycolor = Color3.fromRGB(255,0,0)
		bananapeelcolor = Color3.fromRGB(255,0,0)
		DoorsDifference = 0
		EntityESPShape = "Dynamic"
		EntityOutline = true
		DupeESP = false
		playercolor = Color3.fromRGB(255,255,255)



		itemcolor = Color3.fromRGB(170, 0, 255)


		closetcolor = Color3.fromRGB(0, 125, 0)
		keycolor = Color3.fromRGB(0,255,0)

		goldcolor = Color3.fromRGB(255,255,0)
		stardustcolor = Color3.fromRGB(255,170,0)

         local function GetDoorNumber(Door)
            return tonumber(Door.Parent.Name) + (1 + DoorsDifference)
        end




		FogInstances = {}
		for i,Fog in pairs(game:GetService("Lighting"):GetChildren()) do
			if Fog:IsA("Atmosphere") then
				table.insert(FogInstances, Fog)
			end
		end
		local FogEnd2 = game:GetService("Lighting").FogEnd
		if game.Lighting:FindFirstChild("Fog") then
			FogEnd = game:GetService("Lighting"):WaitForChild("Fog").Density
		end
		local Color = Color3.fromRGB(255,255,255)

		local BypassSeek = false
		local ot = 0
		if not game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI",99999).Initiator:FindFirstChild("Main_Game") then

			Notify({
				Title = "Error",
				Description = "There was an error while loading the script",
			})	
			Sound()
			getgenv().YX-HUBHubLoaded = false
		else
			local Modules = Player.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
			local ModulesClient = ReplicatedStorage:FindFirstChild("ModulesClient") or ReplicatedStorage:FindFirstChild("ClientModules")
			local EntityModules = ModulesClient.EntityModules


			local Screech = Modules:FindFirstChild("Screech") or Modules:FindFirstChild("Screech_")
			local Halt = EntityModules.Shade
			local Dread = Instance.new("Folder")
			if Modules:FindFirstChild("Dread") then
				Dread = Modules.Dread
			end
			local Timothy = Modules.SpiderJumpscare
			local Glitch = EntityModules.Glitch
			local SeekModule = EntityModules.Seek
			local Void = Instance.new("Folder")

			Void = ModulesClient.EntityModules:FindFirstChild("Void") or Instance.new("ModuleScript")

			local A90 = Instance.new("Folder")
			if Modules:FindFirstChild("A90") then
				A90 = Modules.A90
			end
			ShadeEvent = RemotesFolder:FindFirstChild("ShadeResult") or Instance.new("RemoteEvent")
			FakeShadeEvent = Instance.new("RemoteEvent")
			FakeShadeEvent.Name = "ShadeResult"
			FakeShadeEvent.Parent = ReplicatedStorage

			DreadEvent = RemotesFolder:FindFirstChild("Dread") or Instance.new("RemoteEvent")
			FakeDreadEvent = Instance.new("RemoteEvent")
			FakeDreadEvent.Name = "Dread"
			FakeDreadEvent.Parent = ReplicatedStorage

			A90Event = RemotesFolder:FindFirstChild("A90") or Instance.new("RemoteEvent")
			FakeA90Event = Instance.new("RemoteEvent")
			FakeA90Event.Name = "A90"
			FakeA90Event.Parent = ReplicatedStorage

			ScreechEvent = RemotesFolder:FindFirstChild("Screech") or Instance.new("RemoteEvent")
			FakeScreechEvent = Instance.new("RemoteEvent")
			FakeScreechEvent.Name = "Screech"
			FakeScreechEvent.Parent = ReplicatedStorage






			HideTimeValues = {
    {min = 1, max = 5, a = -1/6, b = 1, c = 20},
    {min = 6, max = 19, a = -1/13, b = 6, c = 19},
    {min = 19, max = 22, a = -1/4, b = 19, c = 18},
    {min = 23, max = 26, a = 1/3, b = 23, c = 18},
    {min = 26, max = 30, a = -1/4, b = 26, c = 19},
    {min = 30, max = 35, a = -1/3, b = 30, c = 18},
    {min = 36, max = 60, a = -1/12, b = 36, c = 18},
    {min = 60, max = 90, a = -1/30, b = 60, c = 16},
    {min = 90, max = 99, a = -1/6, b = 90, c = 15}
}


function GetHideTime(room)
    for _, range in ipairs(HideTimeValues) do
        if room >= range.min and room <= range.max then
            return math.round(range.a * (room - range.b) + range.c)
        end
    end    

    return nil
end
			noclip = false








			local FloorReplicated = ReplicatedStorage:FindFirstChild("FloorReplicated") or Instance.new("Folder")



			local function togglenoclip(value)

				noclip = value



			end
			if Floor == "Backdoor" then
				DoorsDifference = -51
			elseif Floor == "Mines" then
				DoorsDifference = 100
			end

			local SpeedBoost = 0

			local OldHotel = false
			if RemotesFolder.Name == "Bricks" then
				OldHotel = true
			end

			

			LiveModifiers = (OldHotel == false and ReplicatedStorage:WaitForChild("LiveModifiers") or Instance.new("Folder"))
			Jam = (OldHotel == false and Player.PlayerGui.MainUI.Initiator.Main_Game.Health.Jam or Instance.new("Sound"))
			Jammin = (OldHotel == false and SoundService:WaitForChild("Main").Jamming or Instance.new("SoundGroup"))


			TIMEOUT  = 0.6
			RAY_LENGTH = 2
			SPEED      = 1
			MAX_FORCE  = 1e32

			-- State
			bypassActive = false
			bv = nil 
			timer = nil

			-- Raycast filter (ignore your own character)
			rayParams = RaycastParams.new()
			rayParams.FilterType = Enum.RaycastFilterType.Exclude

			function refreshFilter()
				char = game.Players.LocalPlayer.Character
				if char then
					rayParams.FilterDescendantsInstances = {char}
				end
			end

			function clearBV()
				if bv and bv.Parent then
					bv:Destroy()
				end
				bv = nil
				timer = nil
				-- NOTE: we no longer touch fakecollision hereБ─■leave it at whatever state it is
			end

			function onStep()
				if not bypassActive then clearBV() return end
				char = Player.Character
				hrp  = CollisionClone
				if not hrp then return end


				-- create or maintain BodyVelocity
				if not bv then
					bv = Instance.new("BodyVelocity")
					bv.Name     = "NoclipBypassBV"
					bv.MaxForce = Vector3.new(MAX_FORCE, MAX_FORCE, MAX_FORCE)
					bv.Parent   = hrp
				end
				bv.Velocity = hrp.CFrame.LookVector * SPEED
				timer = TIMEOUT

				-- continuously lock fakecollision to non-massless while validHit persists




			end




			local MaxInventorySize = 6

			if NewHotel == false then
				MaxInventorySize = math.huge
			end

			if LiveModifiers:FindFirstChild("PlayerLessSlots") then
				MaxInventorySize = 3
			end

			if LiveModifiers:FindFirstChild("PlayerLeastSlots") then
				MaxInventorySize = 1
			end

			function GetItem(Name)
				if Character:FindFirstChild(Name) then
					return Character:FindFirstChild(Name)
				end
				if Player.Backpack:FindFirstChild(Name) then
					return Player.Backpack:FindFirstChild(Name)
				end
			end

			function GetItems()
				local ItemsTable = {}
				local ToolBlacklist = {
					"Key",
					"KeyBackdoor",
					"KeyElectrical",
					"LibraryHintPaper",
					"Keyiron",
					"LotusPetal"
				}

				for i,Tool in pairs(Character:GetChildren()) do
					if Tool:IsA("Tool") then
						if not table.find(ToolBlacklist, Tool.Name) then
						table.insert(ItemsTable,Tool)
						end
					end
				end 

				for i,Tool in pairs(Player.Backpack:GetChildren()) do
					if Tool:IsA("Tool") then
						if not table.find(ToolBlacklist, Tool.Name) then
						table.insert(ItemsTable,Tool)
						end
					end
				end 

				return ItemsTable
			end

			function IsHoldingLight()
				local Result = false

				if Character:FindFirstChild("Flashlight") then
					Result = true
				end
				if Character:FindFirstChild("Bulklight") then
					Result = true
				end
				if Character:FindFirstChild("Straplight") then
					Result = true
				end
				if Character:FindFirstChild("LaserPointer") then
					Result = true
				end
				return Result
			end


			local function forcefireproximityprompt(Obj)

				if game:GetService("ProximityPromptService").Enabled == false then
					return
				end

				if Character:GetAttribute("Hiding") == true or Character:GetAttribute("Climbing") == true or Player:GetAttribute("Dead") == true then
					return
				end

				local Prompt = Obj



				if Obj.Parent == nil or Obj.Parent.Parent == nil then
					return
				end

				if Obj.Enabled == false and Obj.Name ~= "LongPushPrompt" then
					return
				end



				if Obj.Parent.Name == "FuseObtain" and Obj.Parent.Hitbox.FuseModel.LocalTransparencyModifier == 1 or Obj:GetAttribute("CustomFrame") == "Glitch" and Obj.Parent:FindFirstChild("MainPart") and Obj.Parent.MainPart.Transparency == 1  then

					return
				end

				if Obj.ActionText == "Close" then
					return
				end

				if Obj.Parent:GetAttribute("JeffShop") == true and Options.AutoInteractIgnoreList.Value['Jeff Items'] then 
					return
				end

				if Obj:GetAttribute("OriginalName") == "UnlockPrompt" and Options.AutoInteractIgnoreList.Value['Doors']  then

						return
					end

						if Obj.Name == "PropPrompt" and Options.AutoInteractIgnoreList.Value['Paintings']  then

						return
					end



				if Obj.Name == "FakePrompt" and Options.AutoInteractIgnoreList.Value['Locked Items'] then

					if Obj:GetAttribute("OriginalName") == "FusesPrompt" and not GetItem("GeneratorFuse") then
						return
					end

					if Obj:GetAttribute("OriginalName") == "UnlockPrompt" and not GetItem("Key") and not GetItem("ElectricalKey") then

						return
					end

					if Obj:GetAttribute("OriginalName") == "UnlockPrompt" and GetItem("Key") or Obj:GetAttribute("OriginalName") == "UnlockPrompt" and GetItem("ElectricalKey") then
						if not Character:FindFirstChild("Key") and not Character:FindFirstChild("ElectricalKey") and NewHotel == false then
							return
						end
					end

					if Obj:GetAttribute("OriginalName") ~= "FusesPrompt" and Obj:GetAttribute("OriginalName") ~= "UnlockPrompt" then
						return
					end

				end

				if Obj.Name == "FakePrompt" and not Character:FindFirstChild("Lockpick") and not Character:FindFirstChild("SkeletonKey") and not Character:FindFirstChild("Multitool") then
					if Obj.Parent.Name == "Chest_Vine" and not Character:FindFirstChild("Shears") and not Character:FindFirstChild("Multitool")  then
						return
					elseif Obj.Parent.Name ~= "Chest_Vine" and Obj:GetAttribute("OriginalName") ~= "FusesPrompt" and Obj:GetAttribute("OriginalName") ~= "UnlockPrompt" and Obj.Parent.Name ~= "CuttableVines" then
						return

					end
				end

				if Obj:GetAttribute("FakePrompt") == true then
					return
				end




				if Obj.Parent.Name == "GoldPile" and Options.AutoInteractIgnoreList.Value['Gold'] then 
					return
				end

				if Obj.Name == "ClimbPrompt" and Options.AutoInteractIgnoreList.Value['Ladders'] then 
					return
				end

				if Obj.Name == "ClimbPrompt" and MinesAnticheatBypassActive == true then 
					return
				end

				if Obj.Name == "PushPrompt" and Options.AutoInteractIgnoreList.Value['Minecarts'] then 
					return
				end


				if Obj.Name == "SkullPrompt" and Options.AutoInteractIgnoreList.Value['Locked Items'] then 
					return

				end

				if Obj.Name == "ThingToEnable" and Options.AutoInteractIgnoreList.Value['Locked Items'] then 
					return
				end

				if Obj.Name == "LockPrompt" and Options.AutoInteractIgnoreList.Value['Locked Items'] then 
					return
				end

				if table.find(Items2, Obj.Parent.Name) and Obj.Parent.Parent == workspace:WaitForChild("Drops") and Options.AutoInteractIgnoreList.Value['Dropped Items'] then 
					return
				end

				if table.find(Items2, Obj.Parent.Name) and Obj.Parent.Parent ~= workspace:WaitForChild("Drops") and Options.AutoInteractIgnoreList.Value['Loot Items'] then 
					return
				end

				if Prompt.Parent.Name == "LibraryHintPaper" or Prompt.Parent.Name == "PickupItem" then
					if GetItem("LibraryHintPaper") or GetItem("LibraryHintPaperHard") then
						return
					end
				end

				if table.find(Items2, Prompt.Parent.Name)  and Prompt.Parent:GetAttribute("ToolDurability") and GetItem(Prompt.Parent.Name) and GetItem(Prompt.Parent.Name):GetAttribute("DurabilityMax") > 10 and GetItem(Prompt.Parent.Name):GetAttribute("Durability") >= Prompt.Parent:GetAttribute("Tool_Durability") then
					return
				end

				if table.find(Items2, Prompt.Parent.Name) and GetItem(Prompt.Parent.Name) and GetItem(Prompt.Parent.Name):GetAttribute("Durability") and GetItem(Prompt.Parent.Name):GetAttribute("DurabilityMax") and GetItem(Prompt.Parent.Name):GetAttribute("Durability") >= GetItem(Prompt.Parent.Name):GetAttribute("DurabilityMax") then
					return
				end

				if table.find(Items2, Prompt.Parent.Name) and GetItem(Prompt.Parent.Name) and not GetItem(Prompt.Parent.Name):GetAttribute("Durability") then
					if Prompt.Parent.Name == "Crucifix" or Prompt.Parent.Name == "SkeletonKey" or Prompt.Parent.Name == "AlarmClock" then
						return
					end

				end

				if table.find(Items2, Prompt.Parent.Name) and #GetItems() >= MaxInventorySize and not Character:FindFirstChildOfClass("Tool") then
					if Prompt.Parent.Name == "Bandage" and not GetItem("BandagePack") and Humanoid.Health >= Humanoid.MaxHealth or Prompt.Parent.Name == "Battery" and not GetItem("BatteryPack") and IsHoldingLight() == false or Prompt.Parent.Name ~= "Bandage" and Prompt.Parent.Name ~= "Battery" then
						return
					end
				end

				if Prompt.Parent.Name == "Bandage" and not GetItem("BandagePack") and Humanoid.Health >= Humanoid.MaxHealth or Prompt.Parent.Name == "Bandage" and GetItem("BandagePack") and GetItem("BandagePack"):GetAttribute("Durability") >= GetItem("BandagePack"):GetAttribute("DurabilityMax") and Humanoid.Health >= Humanoid.MaxHealth then
					return
				end

				if Prompt.Parent.Name == "Battery" and not GetItem("BatteryPack") and IsHoldingLight() == false or Prompt.Parent.Name == "Battery" and GetItem("BatteryPack") and GetItem("BatteryPack"):GetAttribute("Durability") >= GetItem("BatteryPack"):GetAttribute("DurabilityMax") and IsHoldingLight() == false then
					return
				end

				if Prompt.Parent.Name == "LeverForGate" and Prompt:GetAttribute("Interactions") ~= nil or Prompt.Parent.Name == "KeyObtain" and GetItem("Key") or Prompt.Parent.Name == "ElectricalKeyObtain" and GetItem("ElectricalKey") then
					return
				end

				if Prompt.Parent.Name == "LanternLitItem" and GetItem("Lantern") then
					return
				end







				fireproximityprompt(Obj)













			end

			function fixfireproximityprompt(Prompt)
				local ParentObject = Prompt.Parent

				if ParentObject == nil then
					return
				end

				if ParentObject:IsA("Model") and ParentObject.PrimaryPart == nil then
					return
				end
				local NewCFrame = (ParentObject:IsA("Model") and ParentObject.PrimaryPart and ParentObject.PrimaryPart.CFrame or ParentObject.CFrame)
				

				
					workspace.CurrentCamera.CFrame = NewCFrame*CFrame.new(0,0,2)
					fireproximityprompt(Prompt)
					Prompt.MaxActivationDistance = (Prompt:GetAttribute("OldDistance") * ReachDistance or Prompt.MaxActivationDistance)
				

				

			end


			ito = false

			Ambience = Color3.fromRGB(255,255,255)
			AA = false
			NotifyEyes = false
			AntiScreech = false
			godmodefools = false
			Figure = nil
			AutoLibraryUnlockDistance = 35
			RemoveFigure = false
			RemoveHideVignette = false
			GeneratorESP = false
			JumpBoost = 5
			DoorReach = false
			AntiSeekObstructions = false
			NotifyA120 = false


			Watermark = Instance.new("TextLabel")
			Watermark.Parent = Library.ScreenGui
			Watermark.Size = UDim2.new(1,0,0.4,0)
			Watermark.Position = UDim2.new(0,0,0.6,0)

			Watermark.Font = Enum.Font.Oswald
			Watermark.TextColor3 = Color3.fromRGB(255,255,255)
			Watermark.Visible = false
			Watermark.BackgroundTransparency = 1
			Watermark.Text = ""
			Watermark.TextScaled = true
			Watermark.TextTransparency = 0.9

			OriginalAmbience = game.Lighting.Ambient

			EnableFOV = true
			AntiEyes = false
			FigureESP = false
			TransparentCloset = false
			TransparentClosetNumber = 0.75
			FuseESP = false
			anchorcolor = Color3.fromRGB(255,170,0)
			AnchorESP = false
			laddercolor = Color3.fromRGB(255, 255, 255)
			chestcolor = Color3.fromRGB(255,255,0)
			grumblecolor = Color3.fromRGB(255, 0, 0)
			louiecolor = Color3.fromRGB(0,255,255)
			jeffcolor = Color3.fromRGB(255,0,0)
			figurecolor = Color3.fromRGB(255,0,0)
			fusecolor = Color3.fromRGB(0,255,255)
			generatorcolor = Color3.fromRGB(255,170,0)
			timelevercolor = Color3.fromRGB(255,170,0)
			dupecolor = Color3.fromRGB(255,0,0)
			gigglecolor = Color3.fromRGB(255,0,0)
			Ladders = false
			ReachDistance = 1
			autoplay = false
			ToolSpamSelf = false
			ToolSpamAll = false
			AntiFH = false
			AntiSnare = false
			AntiDupe = false
			NotifyTimeLevers = false

			SnareESP = false
			GrumbleESP = false
			keycarddupe = false
			godmodelocker = nil
			MinesBypass = false
			EntityESP = false
			AntiLookman = false
			AntiVacuum = false
			fb = false

			ToolSpam = false
			ItemESP = false
			godmode = false
			TimerLevers = false
			AutoLibrary = false



			flyspeed = 15
			godmodenotif = false
			keycardtable = {"NormalKeyCard", "RidgeKeyCard"}
			spectate = false
			antilag = false
			speakers = false
			rev = false
			maxinteract = false
			VacuumESP = false
			local flyvelocity
			NA = false
			gold = false

			fov = 70
			fovmultiplier = 1
			interact = false
			playingagain = false
			PathfindingFolder = Instance.new("Folder")
			PathfindingFolder.Name = ESPLibrary:GenerateRandomString()
			PathfindingFolder.Parent = game.Workspace

			SeekNodesFolder = Instance.new("Folder")
			SeekNodesFolder.Name = ESPLibrary:GenerateRandomString()
			SeekNodesFolder.Parent = game.Workspace





			local ObjectsTable = {
				Doors = {},
				Keys = {},
				Prompts = {},
				Snares = {},
				Levers = {},
				Gold = {},
				Items = {},
				Closets = {},
				Chests = {},
				Giggles = {},
				Entities = {},
				EntityModels = {},
				Grumbes = {},
				Fuses = {},
				Players = {},
				Ladders = {},
				TimeLevers = {},
				Anchors = {},
				Books = {},
				Breakers = {},
				Figures = {},
				Dupe = {},
				Jeffs = {},
				Bananas = {},
				Generators = {},
				Prompts2 = {},
				SeekObstructions = {},
				DoorParts = {},
				RemovableModels = {},
				Stardust = {},
				GardenEntities = {},
				RiftSpawn = {}
			}

			local LastHidingSpot

			if Floor == "Mines" or LiveModifiers:FindFirstChild("HideLevel2") or Floor == "Party" then
				LastHidingSpot = Instance.new("ObjectValue")
				LastHidingSpot.Name = "LastHidingSpot"
				LastHidingSpot.Parent = ReplicatedStorage

				if Character:FindFirstChild("LastHideSpot") then
					LastHidingSpot.Value = Character.LastHideSpot.Value
				end
			end


			function GetNearestCloset()
				local Closet
				local NearestCloset = math.huge

				for i,NewCloset in pairs(ObjectsTable.Closets) do
					if NewCloset.PrimaryPart ~= nil and Character:GetAttribute("Hiding") ~= true then
						local Distance = Player:DistanceFromCharacter(NewCloset.PrimaryPart.Position)
						if NewCloset:FindFirstChild("HidePrompt", true) and Distance < NewCloset:FindFirstChild("HidePrompt", true).MaxActivationDistance and Distance < NearestCloset then
							if LastHidingSpot and LastHidingSpot.Value ~= NewCloset or not LastHidingSpot then

								if not NewCloset:FindFirstChild("HiddenPlayer", true).Value then


									Closet = NewCloset
									NearestCloset = Distance
								end
							end

						end
					end
				end
				return Closet
			end

			function IsPlayerHiding()

				for i,NewCloset in pairs(ObjectsTable.Closets) do
					if NewCloset:FindFirstChild("HiddenPlayer", true) then


						if NewCloset:FindFirstChild("HiddenPlayer", true).Value == Character then


							return true



						end
					end
				end
				return false
			end






			function GetNearestEntity()
				local Entities = {
					"RushMoving",
					"AmbushMoving",
					"A60",
					"A120",
					"GlitchRush",
					"GlitchAmbush",
					"BackdoorRush",
					"CustomEntity"
				}
				local EntityDistances = {
					["RushMoving"] = 85,
					["AmbushMoving"] = 150,
					["A60"] = 125,
					["A120"] = 85,
					["GlitchRush"] = 90,
					["GlitchAmbush"] = 175,
					["BackdoorRush"] = 85,
					["CustomEntity"] = 85,
				}

				local Entity
				local NearestEntity = math.huge




				for i,Child in pairs(ObjectsTable.EntityModels) do
					if table.find(Entities, Child.Name)  then




						local HideDistance = EntityDistances[Child.Name]


						if Child.Name == "CustomEntity" then
							HideDistance = math.clamp(Child:GetAttribute("speed") * 1.5, 85, 175)
						end



						if Child.PrimaryPart == nil then
							Child.PrimaryPart = Child:FindFirstChild("RushNew")
						end





						if Child.PrimaryPart then

							if Child:GetAttribute("LatestPosition") == nil then
								Child:SetAttribute("LatestPosition", Child.PrimaryPart.Position)
							end











							if Player:DistanceFromCharacter(Child.PrimaryPart.Position) < NearestEntity and Player:DistanceFromCharacter(Child.PrimaryPart.Position) < HideDistance then










								Entity = Child
								NearestEntity = Player:DistanceFromCharacter(Child.PrimaryPart.Position)

							end




							Child:SetAttribute("LatestPosition", Child.PrimaryPart.Position)




						end
					end
				end
				return Entity
			end

			function GetNearestEntityDistance()
				nearestDistance = math.huge

				if OldHotel == false then
					return nearestDistance
				end

				for _, obj in ipairs(ObjectsTable.EntityModels) do
					if obj:IsA("Model") and obj.Name ~= "Eyes" then
						MainPart = obj:FindFirstChild("RushNew") or Instance.new("Part")
						local Position1 = Vector3.new(HumanoidRootPart.Position.X,0,HumanoidRootPart.Position.Y)
						local Position2 = Vector3.new(MainPart.Position.X,0,MainPart.Position.Y)
						distance = (Position1 - Position2).Magnitude
						if obj.Name == "RushMoving" and distance < 90 or obj.Name == "AmbushMoving" then

							if distance < nearestDistance then



								nearestDistance = distance

							end
						end
					end
				end
				return nearestDistance
			end

			function RemovefromTables(inst)
				for i,NewTable in pairs(ObjectsTable) do
					if table.find(NewTable, inst) then
						for index,Object in pairs(NewTable) do
							if Object == inst then
								table.remove(NewTable,index)
							end
							task.wait(0.05)
						end
					end
					task.wait(0.05)
				end
			end






			-- Set up a listener to detect when objects are removed

			MissingFunctions = {}

		





			

			

			function GetHasteTime()
				local TimeRemaining = FloorReplicated.DigitalTimer.Value

				local Minutes = math.floor(TimeRemaining/60)
				local Seconds = TimeRemaining-(Minutes*60)

				local MinutesText = tostring(Minutes)
				local SecondsText = tostring(Seconds)

				if Minutes < 10 then
					MinutesText = "0" .. MinutesText
				end

				if Seconds < 10 then
					SecondsText = "0" .. SecondsText
				end

				return MinutesText .. ":" .. SecondsText
			end


			AutoInteractIgnorePrompts = {
				"PropPrompt",
				"EnterPrompt",
				"HintPrompt",
				"DonatePrompt",
				"InteractPrompt",
				"RevivePrompt",
				"HidePrompt",
				"AnimatePrompt"
			}

			local RequiresParentRoom = {
				"PowerupPad"
			}


			local allowedInstances = {
				"Lava",
				"GoldPile",
				"KeyObtain",
				"KeyObtainFake",
				"Drakobloxxer",
				"FuseObtain",
				"MinesGenerator",
				"JeffTheKiller",
				"Snare",
				"FakeDoor",
				"DoorFake",
				"SideroomSpace",
				"ChestBox",
				"ChestBoxLocked",
				"Chest_Vine",
				"Locker_Small_Locked",
				"Toolbox",
				"Toolbox_Locked",
				"Wardrobe",
				"Toolshed",
				"Toolshed_Small",
				"Bed",
				"MinesAnchor",
				"Double_Bed",
				"DoubleBed",
				"RetroWardrobe",
				"Backdoor_Wardrobe",
				"Rooms_Locker",
				"Rooms_Locker_Fridge",
				"Locker_Large",
				"FigureRig",
				"FigureRagdoll",
				"TimerLever",
				"Seek_Arm",
				"ChandelierObstruction",
				"AmbushMoving",
				"RushMoving",
				"ScaryWall",
				"Ladder",
				"CircularVent",
				"Dumpster",
				"DumpsterLeft",
				"DumpsterRight",
				"SquareGrate",
				"Eyes",
				"A60",
				"TriggerEventCollision",
				"A120",
				"GrumbleRig",
				"GiggleCeiling",
				"MinesGateButton",
				"ElectricalKeyObtain",
				"LibraryHintPaper",
				"WaterPump",
				"PickupItem",
				"LiveHintBook",
				"LiveBreakerPolePickup",
				"LeverForGate",
				"GloomPile",
				"SeekFloodline",
				"Door",
				"Green_Herb",
				"GiggleCeiling",
				"Bridge",
				"MouseHole",
				"BananaPeel",
				"JeffTheKiller",
				"NannerPeel",
				"PowerupPad",
				"IndustrialGate",
				"CollisionFloor",
				"Wax_Door",
				"ThingToOpen",
				"MovingDoor",
				"StardustPickup",
				"Hole",
				"Groundskeeper",
				"Mandrake",
				"GardenGateButton",
				"LotusPetalPickup",
				"VineGuillotine",
				"LiveEntityBramble",
				"RiftSpawn",
				"ElevatorBreaker",
				"SurgeSpawn"
			}

			-- Hook into new objects being added for future-proofing




		

			


			function GetCurrentAnchor()
				local NewPart = Instance.new("Part")
				NewPart.Parent = ReplicatedStorage
				NewPart:SetAttribute("Anchor", "A")
				if Player:WaitForChild("PlayerGui").MainUI:FindFirstChild("AnchorHintFrame") then
					for i,Anchor in pairs(ObjectsTable.Keys) do
						if Anchor:GetAttribute("Anchor") ~= nil and Anchor:GetAttribute("Anchor") == Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame.AnchorCode.Text then
							return Anchor
						end
					end


				end
				return NewPart
			end

			function SolveAnchorCode()
				if not Player:WaitForChild("PlayerGui").MainUI:FindFirstChild("AnchorHintFrame") then return "000" end

				local inst = GetCurrentAnchor()

				local CodeTable = {}

				if not inst then return end
				local DefaultCode = Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame.Code.Text
				local AnchorID = inst:GetAttribute("Anchor")
				local Adder = (inst:FindFirstChild("Note") and inst:FindFirstChild("Note").SurfaceGui.TextLabel.Text or 0)
				local AdderType = "Add"

				if string.find(Adder, "-") then
					Adder = Adder:split("-")[2]
					AdderType = "Subtract"
				end

				local Code = DefaultCode



				local NewCode = ""

				for i,letter in pairs(Code:split("")) do

					local number = tonumber(letter)


					if AdderType == "Add" then
						number = number + tonumber(Adder)
					else
						number = number - tonumber(Adder)
					end


					if number > 9 then
						number = number - 10
					end
					if number < 0 then
						number = number + 10


					end
					NewCode = NewCode .. tostring(number)

				end


				if tonumber(NewCode) and tonumber(NewCode) < 100 then
					NewCode = "0" .. tostring(tonumber(NewCode))
				end

				if tonumber(NewCode) and tonumber(NewCode) < 10 then
					NewCode = "00" .. tostring(tonumber(NewCode))
				end



				return NewCode







			end



			function NotifyAnchorCode()
				if Toggles.NotifyAnchorCode and not Toggles.NotifyAnchorCode.Value or Floor ~= "Mines" then return end
				task.wait(0.1)
				if not Player:WaitForChild("PlayerGui").MainUI:FindFirstChild("AnchorHintFrame") or workspace:FindFirstChild("AnchorSolved") or GetCurrentAnchor() == nil then return end
				local Part = Instance.new("Part")
				Part.Name = "AnchorSolved"
				Part.Parent = workspace

				Notify({Title = "Auto Anchor Code", Description = "Successfully solved anchor code!", Reason = "The code for Anchor " .. GetCurrentAnchor():GetAttribute("Anchor") .. " is '" .. SolveAnchorCode() .. "'", Time = Part})
				Sound()


				Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame.AnchorCode:GetPropertyChangedSignal("Text"):Connect(function()

					Part:Destroy()

				end)

				Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame:GetPropertyChangedSignal("Visible"):Connect(function()

					Part:Destroy()

				end)
			end

			function SolveCurrentAnchor()
				if Toggles.SolveAnchors and not Toggles.SolveAnchors.Value or Floor ~= "Mines" then return end
				task.wait(0.1)
				if not Player:WaitForChild("PlayerGui").MainUI:FindFirstChild("AnchorHintFrame") or GetCurrentAnchor() == nil then return end

				local DefaultCode = Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame.Code.Text

				local SolveConnection = RunService.Heartbeat:Connect(function()
					if Toggles.SolveAnchors.Value and GetCurrentAnchor() then
						local AnchorRemote = GetCurrentAnchor():FindFirstChild("AnchorRemote", true)
						if AnchorRemote then
							AnchorRemote:InvokeServer(DefaultCode)
						end

					end
				end)
			end

			function SolveAnchor()
				Player:WaitForChild("PlayerGui").MainUI:WaitForChild("AnchorHintFrame", 9e9)
				local Anchor = GetCurrentAnchor()
				local CompletionPoint = workspace.CurrentRooms:WaitForChild("50")._NestHandler.Model.TriggerEventCollision:FindFirstChild("Collision")

				local PrimaryPart

				if Anchor ~= nil then
					PrimaryPart = Anchor:WaitForChild("AnchorBase")
				else
					PrimaryPart = CompletionPoint
				end


				local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = PrimaryPart.CFrame})

				Tween:Play()


				Tween.Completed:Connect(function()


					Anchor:WaitForChild("AnchorRemote"):InvokeServer(SolveAnchorCode())

				end)

			end



			function AutoAnchors()
				Player:WaitForChild("PlayerGui").MainUI:WaitForChild("AnchorHintFrame", 9e9)
				Toggles.TheMinesAnticheatBypass:SetValue(true)
				if MinesAnticheatBypassActive == false then
Notify({Title = "自动锚点", Description = "爬上梯子以启用自动锚点。"})
					Sound()
					while MinesAnticheatBypassActive == false do

						task.wait()
					end

					SolveAnchor()


					Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame.AnchorCode:GetPropertyChangedSignal("Text"):Connect(function()


						SolveAnchor()
					end)

				else
					SolveAnchor()


					Player:WaitForChild("PlayerGui").MainUI.AnchorHintFrame.AnchorCode:GetPropertyChangedSignal("Text"):Connect(function()


						SolveAnchor()
					end)

				end




			end


			function IsSeekChase()
				return (workspace:WaitForChild("CurrentRooms"):FindFirstChild(CurrentRoom):GetAttribute("Chase") == true)
			end

			local vps = game.Workspace.CurrentCamera.ViewportSize

			local function PlayAgain()

				RemotesFolder.PlayAgain:FireServer()


			end

			function DeleteJeff(inst)
Notify({Title = "删除Jeff", Description = "检测到新的Jeff。", Reason = "请等待他被打扫掉。"})
Sound()

				local DeleteConnection
				local Deleted = false

              
for i,inst2 in pairs(inst:GetDescendants()) do
 if ExecutorSupport["firetouchinterest"] and inst2:IsA("BasePart") then
                        firetouchinterest(inst2, Collision, 1)
                        task.wait()
                        firetouchinterest(inst2, Collision, 0)
                    end
                end



				DeleteConnection = RunService.Heartbeat:Connect(function()


					local Part = inst:FindFirstChild("HumanoidRootPart")

					if Part then
						if isnetworkowner(Part) then
							Part.CFrame = CFrame.new(-49999,-49999,-49999)

						end
					else
						DeleteConnection:Disconnect()
Notify({Title = "删除Jeff", Description = "成功删除Jeff！"})
Sound()
Deleted = true
end
end)

task.wait(8)

if Deleted == false then
    DeleteConnection:Disconnect()
    Notify({Title = "删除Jeff", Description = "删除Jeff失败：", Reason = "无法获取网络所有权。"})
					Sound()
				end



			end


			--// Linoria \\--


			--// Variables \\--

			if Floor == "Mines" then



				--@Internal funtion
				local previousNode = nil
				local function CreateNode(node, color)
					if color == nil then
						node.Color = Color3.fromRGB(255,255,255)
						node.Transparency = 1
						node.Size = Vector3.new(1.0, 1.0, 1.0)
						return
					end

					if previousNode ~= nil then
						local trace = Instance.new("Beam")
						trace.Name = ESPLibrary:GenerateRandomString()
						trace.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, color),
							ColorSequenceKeypoint.new(1, color)
						})
						trace.FaceCamera = true
						trace.Width0 = 0.2
						trace.Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, (Toggles.ShowMinecartNodes.Value and 0 or 1)),
							NumberSequenceKeypoint.new(1, (Toggles.ShowMinecartNodes.Value and 0 or 1)),
						})

						trace.Width1 = 0.2
						trace.Brightness = 10
						trace.LightInfluence = 0
						trace.LightEmission = 0
						trace.Enabled = true
						trace.Parent = workspace.Terrain
						trace:SetAttribute("SeekNode", true)

						local att0 = Instance.new("Attachment")
						att0.Name = ESPLibrary:GenerateRandomString()
						att0.Parent = workspace.Terrain
						att0.Position = previousNode.Position
						att0:SetAttribute("SeekNode", true)

						local att1 = Instance.new("Attachment")
						att1.Name = ESPLibrary:GenerateRandomString()
						att1.Parent = workspace.Terrain
						att1.Position = node.Position
						att1:SetAttribute("SeekNode", true)

						trace.Attachment0 = att0
						trace.Attachment1 = att1

					end
					previousNode = node

					return node
				end

				function Functions.Pathfind()
					local NodesFolder = workspace:FindFirstChild("PathLights")

					if not NodesFolder then
						return
					end

					if IsSeekChase() == false then
						SeekNodesFolder:ClearAllChildren()
						return
					end


					local NodesTable = NodesFolder:GetChildren()

					for i,Node in pairs(NodesTable) do
						if Node.Name == "SeekGuidingLight" then
							local NewNode = Instance.new("Part")
							NewNode.Size = Vector3.new(1,1,1)
							NewNode.Transparency = 1
							NewNode.Parent = SeekNodesFolder
							NewNode.Anchored = true
							NewNode.CFrame = Node.CFrame
							NewNode.CanCollide = false
							NewNode.Name = "SeekLightNode" .. tostring(i)

							CreateNode(NewNode, Options.MinecartNodeColor.Value)

						end

					end

				end

			end

			local CaptionValue = Instance.new("NumberValue")
			CaptionValue.Parent = game:WaitForChild("CoreGui")

			function Caption(Text, PlaySound)
				local MainUI = Player:WaitForChild("PlayerGui"):WaitForChild("MainUI")
				local Caption = MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
				local CaptionSound = MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")

				for i,Child in pairs(MainUI:GetChildren()) do
					if Child.Name == "LiveCaption" then
						Child:Destroy()
					end
				end

				Caption.Parent = MainUI
				Caption.Visible = true
				Caption.Name = "LiveCaption"
				Caption.Text = Text

				if PlaySound then
					CaptionSound:Play()
				end

				local HolderTween = TweenService:Create(CaptionValue, TweenInfo.new(3), {Value = 100})

				HolderTween:Play()

				HolderTween.Completed:Connect(function()
					TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
					TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), {TextStrokeTransparency = 1}):Play()

				end)
			end

			local function IsEntityActive()

				local Result = nil

				if workspace:FindFirstChild("RushMoving") or workspace:FindFirstChild("AmbushMoving") or workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120") or workspace:FindFirstChild("BackdoorRush") or workspace:FindFirstChild("CustomEntity") or workspace:FindFirstChild("GlitchRush") or workspace:FindFirstChild("GlitchAmbush") then
					Result = true
				end

				return Result
			end


			function GetRoundedNumber(Number)
				local Text = tostring(Number)
				local Parts = Text:split(".")

				if Parts[2] == nil then
					return Text
				end

				Text = Parts[1] .. "." .. Parts[2]:split("")[1]

				return Text
			end

			local function GetRoom(inst, instant)
				local result = false
				for i,room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
					if inst:IsDescendantOf(room) then
						inst:SetAttribute("ParentRoom", room.Name)
						result = true
						break

					end
					if instant == false then

						task.wait(0.025)

					end

				end

				return result


			end


			local CrouchingValue = Instance.new("BoolValue")
			CrouchingValue.Name = "PlayerCrouching"
			CrouchingValue.Parent = ReplicatedStorage
			CrouchingValue.Value = (Collision.CollisionGroup == "PlayerCrouching" and true or false)



			local AvoidingFigure = Instance.new("BoolValue")
			AvoidingFigure.Name = "AvoidingFigure"
			AvoidingFigure.Parent = ReplicatedStorage
			AvoidingFigure.Value = false

			function RemoveESP(inst)
				inst:SetAttribute("CurrentESP",false)



			end


			if game.Workspace.CurrentRooms:FindFirstChild("0") and not game.Workspace.CurrentRooms:FindFirstChild("2") then
				Player:SetAttribute("CurrentRoom","0")
			end

			local ColorTable = {}

			local function esp(Target,TracerTarget,Text, ColorText, shoulddestroy, instanthighlight)

				if Target.Parent ~= nil and Target:GetAttribute("ESP") == true or Target:GetAttribute("ESPBlacklist") == true then return end

				ColorTable[Target] = ColorText

				local connections = {}
				local destroying = false
				local waittable = {"Door","KeyObtain"}
				local transparencyenabled = false





				if Target:GetAttribute("ESP") ~= true then










					if Target:GetAttribute("ParentRoom") == nil then
						GetRoom(Target, false)
					end












					connections.Connection1 = Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()

						if Target ~= nil and Target.Parent ~= nil and Target:GetAttribute("ParentRoom") ~= nil then






							if shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("ESP") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("Door") == true and Target:GetAttribute("ESP") == true then

								ESPLibrary:AddESP({
									Object = Target,
									Text = Text,
									Color = ColorTable[Target]
								})


							elseif shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) < tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("Door") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) < tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("Door") == nil or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) > tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("Door") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) > tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("Door") == nil or Target:GetAttribute("ESP") ~= true then





								ESPLibrary:RemoveESP(Target)

							end

						end


						if Target == nil or Target.Parent == nil or Target:IsA("Model") and Target.PrimaryPart == nil then
							Target:SetAttribute("CurrentESP",false)
						end





					end)
					connections.Connection2 = Target:GetAttributeChangedSignal("ESP"):Connect(function()

						if Target ~= nil and Target.Parent ~= nil and Target:GetAttribute("ParentRoom") ~= nil then





							if shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("ESP") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) == tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("Door") == true and Target:GetAttribute("ESP") == true then

								ESPLibrary:AddESP({
									Object = Target,
									Text = Text,
									Color = ColorTable[Target]
								})


							elseif shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) < tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("Door") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) < tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("Door") == nil or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) > tonumber(Player:GetAttribute("CurrentRoom"))+1 and Target:GetAttribute("Door") == true or shoulddestroy == true and tonumber(Target:GetAttribute("ParentRoom")) > tonumber(Player:GetAttribute("CurrentRoom")) and Target:GetAttribute("Door") == nil or Target:GetAttribute("ESP") ~= true then





								ESPLibrary:RemoveESP(Target)

							end





						end


						if Target == nil or Target.Parent == nil or Target:IsA("Model") and Target.PrimaryPart == nil then
							Target:SetAttribute("CurrentESP",false)
						end



					end)
				end

				connections.CurrentConnection = Target:GetAttributeChangedSignal("CurrentESP"):Connect(function()
					if Target:GetAttribute("CurrentESP") == false then
						Target:SetAttribute("ESP",false)

						ESPLibrary:RemoveESP(Target)
					end

				end)
				connections.DestroyConnection = Target.Destroying:Once(function()



					ESPLibrary:RemoveESP(Target)
					connections.Connection1:Disconnect()
					connections.DestroyConnection:Disconnect()
					connections.Connection2:Disconnect()
					connections.CurrentConnection:Disconnect()



				end)










				if Target == nil or Target.Parent == nil or Target:IsA("Model") and Target.PrimaryPart == nil then
					Target:SetAttribute("CurrentESP",false)
				end






				Target:SetAttribute("CurrentESP", true)
				Target:SetAttribute("ESP", true)







			end



			function DisableDupe(Model, Disabled)


				for i,part in pairs(Model:GetDescendants()) do

					if part:IsA("ProximityPrompt") then
						part.Enabled = not Disabled

					elseif part:IsA("BasePart") then

						part.CanTouch = not Disabled













					end
				end
			end
			function ApplyDupeESP(Model)
				if Model:IsDescendantOf(workspace) then
					if Model.Name == "DoorFake" or Model.Name == "FakeDoor" then
						if Model:FindFirstChild("Door") then
							esp(Model.Door,Model.Door,"Dupe",dupecolor,true,false)
							Model:GetAttributeChangedSignal("ESP"):Connect(function()
								if Model:GetAttribute("ESP") == false then
									Model.Door:SetAttribute("ESP",false)
								end
							end)

						end





					end
				end
			end






			function CanAutoInteract(Prompt)

				if Prompt.Parent == nil then 
					return false
				end

				local Result = false

				local ChestNames = {
					"ChestBox",
					"ChestBoxLocked",
					"Toolbox",
					"Toolbox_Locked",
					"Locker_Small",
					"Locker_Small_Locked",
					"Toolshed_Small",
					"RolltopContainer",
					"Chest_Vine"
				}

				local Pickups = {
					"LibraryHintPaper",
					"PickupItem",
					"LiveHintBook",
					"LiveBreakerPolePickup"
				}

				if table.find(AutoInteractIgnorePrompts, Prompt.Name) then
					return
				end

				

				if table.find(ChestNames, Prompt.Parent.Name) or Prompt.Parent ~= nil and Prompt.Parent.Parent ~= nil and table.find(ChestNames, Prompt.Parent.Parent.Name) then
					Result = true
				end

				if table.find(Items2, Prompt.Parent.Name) then
					Result = true
				end

				if Prompt:GetAttribute("UnlockPrompt") == true and Prompt.Parent and Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "Door" or Prompt.Name == "SkullPrompt" then
					Result = true
				end

				if Prompt.Name == "FusesPrompt" or Prompt.Name == "ThingToEnable" or Prompt.Name == "LeverPrompt" or Prompt.Name == "LockPrompt" then
					Result = true
				end

				if Prompt.Parent.Name == "Knobs"  or Prompt.Parent.Name == "Metal" or Prompt.Parent.Name == "Button" or Prompt.Parent.Name == "Knob" or Prompt.Parent.Name == "End" then
					Result = true
				end

				if Prompt.Name == "LootPrompt" or Prompt.Parent.Name == "KeyObtain" or Prompt.Parent.Name == "FuseObtain"  or Prompt.Parent.Name == "ElectricalKeyObtain" then
					Result = true
				end

				if Prompt.Name == "PushPrompt" or Prompt.Name == "ClimbPrompt" or Prompt.Name == "LongPushPrompt" or Prompt.Name == "ValvePrompt" then
					Result = true
				end

				if Prompt.Parent.Name == "LeverForGate" or Prompt.Parent.Name == "TimerLever" then
					Result = true
				end

				if Prompt.Name == "AwesomePrompt" then
					Result = true
				end

				if Prompt.Name == "PartyDoorPrompt" then
					Result = true
				end

				if table.find(Pickups, Prompt.Parent.Name) or Prompt.Parent.Parent ~= nil and table.find(Pickups, Prompt.Parent.Parent.Name) then
					Result = true
				end

				if Prompt.Parent.Name == "Door" and Prompt.Name == "ActivateEventPrompt" then
					Result = true
				end

				if Prompt.Name == "FakePrompt" or Prompt.Name == "HerbPrompt" then
					Result = true
				end

				if Prompt.Name == "ModulePrompt" and Prompt.Parent.Name == "StardustPickup" then
					Result = true
				end

				if Prompt.Name == "ModulePrompt" and Prompt.Parent.Name == "Mandrake" then
					Result = true
				end

				if Prompt.Name == "ModulePrompt" and Prompt.Parent.Name == "Hole" then
					Result = true
				end

				if Prompt.Name == "ActivateEventPrompt" and Prompt.Parent.Name == "Lever" then
					Result = true
				end

				if Prompt.Name == "ActivateEventPrompt" and Prompt.Parent.Name == "DrawerDoors" then
					Result = true
				end









				return Result

			end



			local NotifierConnection
			if OldHotel == true or Floor == "Fools" then
				NotifierConnection = game.Workspace.ChildAdded:Connect(function(child)
					if child:IsA("Model") then




						task.wait(0.25)


						local mainpart = nil

						if child.Name == "Lookman" then
							child.Name = "Eyes"
						end


						mainpart = child.PrimaryPart or child:FindFirstChild("RushNew") or child:FindFirstChild("Core")


						local EntityText = EntityAlliases[child.Name] 

						if child.Name == "RushMoving" and mainpart.Name ~= "RushNew" then
							EntityText = mainpart.Name
						end



						if child:IsA("Model") then

							if child:IsA("Model") then
								if child:IsDescendantOf(workspace) then
									if table.find(Entities,child.Name) and mainpart.Position ~= Vector3.new(0, -10000, 1000000) then
										
										if child.Name ~= "GlitchAmbush" and child.Name ~= "GlitchRush" then
											if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] and Toggles.ChatNotify.Value and Toggles.NotifyEntities.Value then
												if child.Name == "RushMoving" then
													local Text = EntityAlliases[child.Name] .. ChatNotifyMessage
													if mainpart.Name ~= "RushNew" then
														Text = mainpart.Name .. ChatNotifyMessage
													end
													ChatNotify(Text)
												else
													ChatNotify(EntityAlliases[child.Name] .. ChatNotifyMessage)	
												end
											end
										end
										if child.Name == "Eyes" or child.Name == "BackdoorLookman" then
											if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] and Toggles.NotifyEntities.Value then
												Notify({Title = "Entity Warning", Description = "Entity '"..EntityAlliases[child.Name] .. "' has spawned.",Reason = "Avoid looking at it!",Image = EntityIcons[child.Name],NotificationType = "WARNING"})
												Sound()	

											end

										else
											if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] and Toggles.NotifyEntities.Value then



												if child.Name == "RushMoving" then

													if mainpart.Name == "RushNew" or OldHotel == true then
														Notify({Title =  "Entity Warning", Description =  "Entity '"..EntityAlliases[child.Name] .."' has spawned.",Reason = "Find a hiding spot quickly!",Image = EntityIcons[child.Name],NotificationType = "WARNING"})
														Sound()
													else
														Notify({Title =  "Entity Warning", Description =  "Entity '"..mainpart.Name .."' has spawned.",Reason = "Find a hiding spot quickly!",Image = mainpart:WaitForChild("Attachment").ParticleEmitter.Texture,NotificationType = "WARNING"})
														Sound()
													end	


												else
													Notify({Title =  "Entity Warning", Description = "Entity '"..EntityAlliases[child.Name] .."' has spawned.",Reason = "Find a hiding spot quickly!",Image = EntityIcons[child.Name],NotificationType = "WARNING"})
													Sound()
												end


											end
										end


										local NewHumanoid = Instance.new("Humanoid")
										NewHumanoid.Parent = child

										local mainpart2 = mainpart

										mainpart.Transparency = 0.99

										mainpart.CanCollide = false



										if Floor == "Retro" then
											mainpart = child
										end

										table.insert(ObjectsTable.Entities, mainpart)
										table.insert(ObjectsTable.EntityModels, child)


										if EntityESP == true then
											ESPLibrary:AddESP({
												Object = mainpart,
												Text = EntityText,
												Color = entitycolor
											}

											)
										end
										mainpart:SetAttribute("ESPText", EntityText)

										mainpart:GetPropertyChangedSignal("Parent"):Once(function()
											ESPLibrary:RemoveESP(mainpart)
										end)





										if child.Name == "Eyes" then
											workspace:WaitForChild("CurrentRooms").ChildAdded:Wait()
											task.wait(3)
											child:Destroy()
										end

									end






								end
							end

						end
					end
				end)
			else
	
										if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] and Toggles.NotifyEntities.Value then
Notify({Title = "实体警告", Description = "实体 '"..EntityAlliases[child.Name] .. "' 已生成。", Reason = "避免看向它！", Image = EntityIcons[child.Name], NotificationType = "警告"})
Sound()

end

else
    if Options.NotifyMonsters.Value[EntityShortNames[child.Name]] and Toggles.NotifyEntities.Value then
        if child.Name == "CustomEntity" then
            Notify({Title = "实体警告", Description = "实体 'Custom Rush' 已生成。", Reason = "快找藏身之处！", Image = mainpart:WaitForChild("Attachment").ParticleEmitter.Texture, NotificationType = "警告"})
            Sound()

        elseif child.Name == "RushMoving" then

            if mainpart.Name == "Scary Entity" then
                mainpart.Name = "Custom Rush"
            end

            if mainpart.Name == "RushNew" or OldHotel == true then
                Notify({Title = "实体警告", Description = "实体 '"..EntityAlliases[child.Name] .."' 已生成。", Reason = "快找藏身之处！", Image = EntityIcons[child.Name], NotificationType = "警告"})
                Sound()
            else
                Notify({Title = "实体警告", Description = "实体 '"..mainpart.Name .."' 已生成。", Reason = "快找藏身之处！", Image = mainpart:WaitForChild("Attachment").ParticleEmitter.Texture, NotificationType = "警告"})
                Sound()
            end

        elseif child.Name == "A120" then
            Notify({Title = "实体警告", Description = "实体 '"..EntityAlliases[child.Name] .."' 已生成。快躲起来！", Reason = "位置欺骗对A-120无效。", Image = EntityIcons[child.Name], NotificationType = "警告"})
            Sound()
        else
            Notify({Title = "实体警告", Description = "实体 '"..EntityAlliases[child.Name] .."' 已生成。", Reason = "快找藏身之处！", Image = EntityIcons[child.Name], NotificationType = "警告"})
												Sound()
											end






										end
									end


									local NewHumanoid = Instance.new("Humanoid")
									NewHumanoid.Parent = child

									local mainpart2 = mainpart



									mainpart.Transparency = 0.99

									mainpart.CanCollide = false



									if Floor == "Retro" then
										mainpart = child
									end

									table.insert(ObjectsTable.Entities, mainpart)
									table.insert(ObjectsTable.EntityModels, child)


									if EntityESP == true then
										ESPLibrary:AddESP({
											Object = mainpart,
											Text = EntityText,
											Color = entitycolor
										}

										)
									end
									mainpart:SetAttribute("ESPText", EntityText)

									mainpart:GetPropertyChangedSignal("Parent"):Once(function()
										ESPLibrary:RemoveESP(mainpart)
									end)






								end

							end

						end

					end
				end)
			end


			local ReplicateSignalSupport = false


			if replicatesignal then

				ReplicateSignalSupport = true

			end





			function ApplyScriptSpeedBoost()
				if LiveModifiers:FindFirstChild("PlayerSlow") then
					Character:SetAttribute("SpeedBoostScript", -3)
				end
				if Floor == "Party" then
					Character:SetAttribute("SpeedBoostScript", 10)
				end
				if LiveModifiers:FindFirstChild("PlayerFast") then
					Character:SetAttribute("SpeedBoostScript", 3)
				end
				if LiveModifiers:FindFirstChild("PlayerFaster") then
					Character:SetAttribute("SpeedBoostScript", 6)
				end
				if LiveModifiers:FindFirstChild("PlayerFastest") then
					Character:SetAttribute("SpeedBoostScript", 20)
				end

			end


			local function GetInstanceUseable(inst)
				local UseableClasses = {"Part","Model","MeshPart","ProximityPrompt"}
				local Useable = false
				for i,room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
					if inst:IsDescendantOf(room) and room:FindFirstChild("Parts") then
						if inst:IsDescendantOf(room:WaitForChild("Parts")) then
							return table.find(UseableClasses,inst.ClassName)
						end
					end
				end
			end


			function DeleteCollision(inst)

				local Success = false






				for i,inst2 in pairs(inst:GetChildren()) do
					inst2.CanCollide = false
					inst2.Position = Collision.Position

                    if ExecutorSupport["firetouchinterest"] then
                        firetouchinterest(inst2, Collision, 1)
                        task.wait()
                        firetouchinterest(inst2, Collision, 0)
                    end
					task.wait()
				end

				inst.ChildRemoved:Once(function()
					Success = true

Notify({Title = "删除Seek", Description = "成功删除Seek触发器！"})
Sound()

end)

task.wait(1)

if #inst:GetChildren() > 0 then

    Notify({Title = "删除Seek", Description = "删除Seek触发器失败。", Reason = "Seek触发器已被删除，但其他人仍可触发。")
					Sound()

					for i,inst2 in pairs(inst:GetChildren()) do
						inst2.CanTouch = false
						inst2.CanCollide = false
						task.wait()

					end
				end

			end

			local fly = {
				enabled = false,
				flyBody = Instance.new("BodyVelocity"),

			}






			fly.flyBody.Velocity = Vector3.zero
			fly.flyBody.MaxForce = Vector3.one * 9e9







			PartProperties = {}

			local keys = false
			local books = false
			local levers = false
			local doors = false
			local closets = false

			local BreakerSolved = false

			function IsLockedPrompt(Prompt)
				local result = false

				if Prompt.Name == "UnlockPrompt" or Prompt.Name == "ThingToEnable" or Prompt.Name == "LockPrompt" or Prompt.Name == "SkullPrompt" or Prompt.Parent:GetAttribute("Locked") == true or Prompt.Parent.Parent:GetAttribute("Locked") == true then
					result = true
				end

				return result
			end



			local AvoidingValue = Instance.new("Vector3Value", game.ReplicatedStorage)
			AvoidingValue.Name = "AvoidingValue"



			function StartAvoiding()

				if AvoidingEntity == false then
					workspace.Gravity = 0
					AvoidingEntity = true

					local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(1), {CFrame = CFrame.new(HumanoidRootPart.Position - Vector3.new(0,7,0))})

					Tween:Play()

					Tween.Completed:Connect(function()
						CollisionPart.Anchored = true
					end) 



				end
			end

			function StopAvoiding()

				if AvoidingEntity == true then

					CollisionPart.Anchored = false
					workspace.Gravity = 0

					local Tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(1), {CFrame = CFrame.new(HumanoidRootPart.Position + Vector3.new(0,7,0))})

					Tween:Play()

					Tween.Completed:Connect(function()
						AvoidingEntity = false
						workspace.Gravity = 90
					end) 



				end
			end










			UISettings = Tabs["UISettings"]


			if HumanoidRootPart.CustomPhysicalProperties ~= nil then
				CustomPhysicalProperties = PhysicalProperties.new(100, HumanoidRootPart.CustomPhysicalProperties.Friction, HumanoidRootPart.CustomPhysicalProperties.Elasticity, HumanoidRootPart.CustomPhysicalProperties.FrictionWeight, HumanoidRootPart.CustomPhysicalProperties.ElasticityWeight)
			end


ESP = Tabs.ESP:AddLeftGroupbox('选择')
ESPSettings = Tabs.ESP:AddRightGroupbox('配置')
Automation = Tabs.Main:AddRightGroupbox('自动化')
LeftGroupBox = Tabs.Main:AddLeftGroupbox('角色')
MainRightTab = Tabs.Main:AddRightTabbox('世界 / 杂项')
BypassEntity = Tabs.Exploits:AddLeftGroupbox('禁用')
LeftGroupBox2 = Tabs.Exploits:AddRightGroupbox('绕过')
VisualsRightTab = Tabs.Visuals:AddRightGroupbox('通知')
VisualsLeftTab = Tabs.Visuals:AddLeftTabbox('镜头 / 效果')
LeftGroupBox9 = VisualsLeftTab:AddTab('镜头')
VisualsRemove = VisualsLeftTab:AddTab('效果')
ProximityPrompts = Tabs.Main:AddLeftGroupbox('交互提示')
AudioGroupbox = Tabs.Misc:AddLeftGroupbox('音频调整')
WorldTab = Tabs.Main:AddRightGroupbox('世界')

ProximityPrompts:AddToggle('Toggle7', {
    Text = '瞬间交互',
    Default = false, -- 默认值（true / false）
    Tooltip = '使所有交互提示变为瞬间完成。', -- 悬停时显示的信息

    Callback = function(Value)
        interact = Value
        for i, inst in pairs(ObjectsTable.Prompts2) do
            if interact == true then
                inst.HoldDuration = 0
            else
                inst.HoldDuration = inst:GetAttribute("OldHoldTime")
            end


        end
    end
})

ProximityPrompts:AddToggle('Toggle9', {
    Text = '穿墙交互',
    Default = false, -- 默认值（true / false）
    Tooltip = '允许你穿过墙壁触发交互提示。', -- 悬停时显示的信息

    Callback = function(Value)
        ito = Value
        for i, inst in pairs(ObjectsTable.Prompts2) do
            if ito == true then
                inst.RequiresLineOfSight = false
            else
                inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
            end


        end
    end
})

ProximityPrompts:AddSlider('ReachDistance', {
    Text = '距离倍数',
    Default = 1,
    Min = 1,
    Max = 2,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        ReachDistance = Value
        task.wait(0.1)

            for i, inst in pairs(ObjectsTable.Prompts2) do

                inst.MaxActivationDistance = inst:GetAttribute("OldDistance") * ReachDistance



            end



    end
})







AudioGroupbox:AddToggle('RemoveFootstepSounds',{
    Text = "移除脚步声",
    Default = false,
    Tooltip = '使所有走路声音静音。'
})
AudioGroupbox:AddToggle('RemoveJamminMusic',{
    Text = "移除Jammin音乐",
    Default = false,
    Tooltip = "移除由'Jammin'修改器产生的音乐和消音效果。",
    Callback = function(Value)
        if LiveModifiers:FindFirstChild("Jammin") then
            Jam.Playing = (not Value)
            Jammin.Enabled = (not Value)
        end
    end,
})

AudioGroupbox:AddToggle('RemoveInteractingSounds',{
    Text = "移除交互声音",
    Default = false,
    Tooltip = '使所有交互声音静音。',
    Callback = function(Value)
        Player.PlayerGui.MainUI.Initiator.Main_Game.PromptService.Triggered.Volume = (Value and 0 or 0.04)
        Player.PlayerGui.MainUI.Initiator.Main_Game.PromptService.Holding.Volume = (Value and 0 or 0.1)
        Player.PlayerGui.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = (Value and 0 or 0.1)
    end,
})
AudioGroupbox:AddToggle('RemoveDamageSounds',{
    Text = "移除受伤声音",
    Default = false,
    Tooltip = '使所有受伤声音静音。',
    Callback = function(Value)
        Player.PlayerGui.MainUI.Initiator.Main_Game.Health.Hit.Volume = (Value and 0 or 0.5)
        Player.PlayerGui.MainUI.Initiator.Main_Game.Health.Ringing.SoundId = (Value and "" or "rbxassetid://1517024660")
        if Player.PlayerGui.MainUI.Initiator.Main_Game.Health:FindFirstChild("HitShield") then
            Player.PlayerGui.MainUI.Initiator.Main_Game.Health.HitShield.Volume = (Value and 0 or 0.2)
        end
    end,
})

ButtonsTab = Tabs.Misc:AddRightGroupbox('其他')

ButtonsTab:AddToggle('DisableAFKKick', {
    Default = false,
    Text = '禁止AFK踢出',
    Tooltip = '防止Roblox在20分钟后将你踢出。'
})

local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    if Toggles.DisableAFKKick.Value then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

ButtonsTab:AddDivider()

ButtonsTab:AddButton({
    Text = '复活',
    Func = function()
        RemotesFolder.Revive:FireServer()
    end,
    DoubleClick = true,
    Tooltip = '提示玩家复活。'
})

ButtonsTab:AddButton({
    Text = '杀死角色',
    Func = function()
        if ExecutorSupport["replicatesignal"] then
            replicatesignal(game.Players.LocalPlayer.Kill)
        else
            if RemotesFolder:FindFirstChild("Underwater") then
                if Resetting == false then
                    RemotesFolder.Underwater:FireServer(true)
                    Notify({Title = "杀死角色", Description = "你应该在接下来20秒内死亡。", Reason = "再次点击按钮取消。"})
                    Sound()
                    Resetting = true
                else
                    RemotesFolder.Underwater:FireServer(false)
                    Notify({Title = "杀死角色", Description = "已取消死亡尝试。"})
                    Sound()
                    Resetting = false
                end
            else
                Character:WaitForChild("Humanoid").Health = 0
            end
        end
    end,
    DoubleClick = (ExecutorSupport["replicatesignal"] and true or false),
    Tooltip = '杀死你的角色。'
})
ButtonsTab:AddButton({
    Text = '再来一局',
    Func = function()
        PlayAgain()
    end,
    DoubleClick = true,
    Tooltip = '尝试加入新对局'
})
ButtonsTab:AddButton({
    Text = '返回大厅',
    Func = function()
        RemotesFolder.Lobby:FireServer()
    end,
    DoubleClick = true,
    Tooltip = '返回主大厅'
})

local function AddRetroTab()
    local RetroAnti = Tabs.Floor:AddLeftGroupbox('禁用')
    local RetroBypass = Tabs.Floor:AddRightGroupbox('绕过')

    RetroBypass:AddToggle('AntiDread', {
        Text = '禁用Dread',
        Default = false,
        Tooltip = '防止Dread生成。',
        Callback = function(Value)
            if Value == true then
                Dread.Name = "Dread_"
            else
                Dread.Name = "Dread"
            end
        end
    })

    RetroAnti:AddToggle('AntiLava',{
        Text = "禁用即死砖块",
        Default = false,
        Tooltip = '防止复古模式的即死砖块伤害你。',
    })


				Toggles.AntiLava:OnChanged(function(value)

					for i,part in pairs(workspace.CurrentRooms:GetDescendants()) do
						if part.Name == "Lava" then
							part.CanTouch = not value

						end
					end

				end)

RetroAnti:AddToggle('AntiScaryWall',{
    Text = "禁用追踪墙",
    Default = false,
    Tooltip = "防止你被追踪墙撞到！！！"
})

RetroAnti:AddDivider()

RetroAnti:AddToggle('AntiDread', {
    Text = '移除Dread',
    Default = false,
    Tooltip = '防止Dread生成。',
    Callback = function(Value)
        if Value == true then
            Dread.Name = "Dread_"
        else
            Dread.Name = "Dread"
        end
    end
})

Toggles.AntiScaryWall:OnChanged(function(value)
    for i,room in pairs(game.Workspace.CurrentRooms:GetChildren()) do
        for i,part in pairs(room:GetDescendants()) do
            if part.Name == "ScaryWall" then
                for i,part2 in pairs(part:GetDescendants()) do
                    if part2:IsA("BasePart") then
                        part2.CanTouch = not value
                        part2.CanCollide = not value
                    end
                end
            end
        end
    end
end)

end

function AddGardenTab()
    SurgeEvent = RemotesFolder:FindFirstChild("SurgeRemote") or Instance.new("RemoteEvent")
    FakeSurgeEvent = Instance.new("RemoteEvent")
    FakeSurgeEvent.Name = "SurgeRemote"
    FakeSurgeEvent.Parent = ReplicatedStorage
    local GardenDisable = Tabs.Floor:AddLeftGroupbox('禁用')
    local GardenVisuals = Tabs.Floor:AddRightGroupbox('视觉')

    GardenDisable:AddToggle('DisableSurge', {
        Text = '禁用Surge',
        Default = false,
        Tooltip = "防止Surge生成。",
        Callback = function(Value)
            if Value == true then
                SurgeEvent.Parent = ReplicatedStorage
                FakeSurgeEvent.Parent = RemotesFolder
            else
                SurgeEvent.Parent = RemotesFolder
                FakeSurgeEvent.Parent = ReplicatedStorage
            end

            for i,Child in pairs(workspace:GetChildren()) do
                if Child.Name == "SurgeSpawn" then
                    Child:Destroy()
                end
            end
        end,
    })

    GardenDisable:AddToggle('AntiDread', {
        Text = '禁用Dread',
        Default = false,
        Tooltip = '防止Dread生成。',
        Callback = function(Value)
            if Value == true then
                Dread.Name = "Dread_"
            else
                Dread.Name = "Dread"
            end
        end
    })

    GardenDisable:AddDivider()

    GardenDisable:AddToggle('NoSurgeDamage', {
        Text = '免疫Surge伤害',
        Default = false,
        Tooltip = "防止Surge对你造成伤害。",
        Callback = function(Value)
            if Value == true then
                SurgeEvent.Parent = ReplicatedStorage
                FakeSurgeEvent.Parent = RemotesFolder
            else
                SurgeEvent.Parent = RemotesFolder
                FakeSurgeEvent.Parent = ReplicatedStorage
            end
        end,
    })

GardenVisuals:AddToggle('NotifyOxygen', {
    Default = false,
    Text = "通知氧气水平",
    Tooltip = '会告诉你剩余氧气量'
})

GardenVisuals:AddToggle('ShowSeekPath', {
    Defualt = false,
    Text = '显示Eyestalk路径',
    Tooltip = '在Eyestalk追逐中显示正确路线。'
}):AddColorPicker('GardenNodeColor', {
    Default = Color3.fromRGB(0,255,0), -- 亮绿色
    Title = '节点颜色', -- 可选。允许自定义颜色选择器标题
    Transparency = 0, -- 可选。启用透明度更改（留空为nil则禁用）

    Callback = function(Value)
        for i,inst in pairs(workspace.Terrain:GetChildren()) do
            if inst:IsA("Beam") and inst:GetAttribute("GardenNode") ~= nil then
                inst.Color  = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Value),
                    ColorSequenceKeypoint.new(1, Value)
                })
            end
        end
    end
})

				Toggles.ShowSeekPath:OnChanged(function(value)




					for i,inst in pairs(workspace.Terrain:GetChildren()) do
						if inst:IsA("Beam") and inst:GetAttribute("GardenNode") ~= nil then
							inst.Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, (Toggles.ShowSeekPath.Value and 0 or 1)),
								NumberSequenceKeypoint.new(1, (Toggles.ShowSeekPath.Value and 0 or 1)),
							})
						end
					end





				end)

				local GardenRoomAddedConnection = workspace.CurrentRooms.ChildAdded:Connect(function(Room)

					
				
					Room:WaitForChild("RoomEntrance", 9e9)
					Room:WaitForChild("RoomExit", 9e9)
					if string.find(Room:GetAttribute("RawName"), "Eyestalk") then

						while Room:GetAttribute("Pathfinded") ~= true do
						
						local path = game:GetService("PathfindingService"):CreatePath({
							AgentCanJump = false,
							AgentCanClimb = false,
							WaypointSpacing = 6,
							AgentRadius = 1.25,
						
						})

						path:ComputeAsync(HumanoidRootPart.Position, Room.RoomExit.Position)



						if path.Status == Enum.PathStatus.Success then
							Room:SetAttribute("Pathfinded", true)
							local waypoints = path:GetWaypoints()

							local previousnode = nil

							for i, node in pairs(waypoints) do
								local color = Options.GardenNodeColor.Value
								if previousnode ~= nil then
									local trace = Instance.new("Beam")
									trace.Name = ESPLibrary:GenerateRandomString()
									trace.Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, color),
										ColorSequenceKeypoint.new(1, color)
									})
									trace.FaceCamera = true
									trace.Width0 = 0.2
									trace.Transparency = NumberSequence.new({
										NumberSequenceKeypoint.new(0, (Toggles.ShowSeekPath.Value and 0 or 1)),
										NumberSequenceKeypoint.new(1, (Toggles.ShowSeekPath.Value and 0 or 1))
									})

									trace.Width1 = 0.2
									trace.Brightness = 10
									trace.LightInfluence = 0
									trace.LightEmission = 0
									trace.Enabled = true
									trace.Parent = workspace.Terrain
									trace:SetAttribute("GardenNode", true)

									local att0 = Instance.new("Attachment")
									att0.Name = ESPLibrary:GenerateRandomString()
									att0.Parent = workspace.Terrain
									att0.Position = previousnode.Position + Vector3.new(0,2,0)
									att0:SetAttribute("GardenNode", true)

									local att1 = Instance.new("Attachment")
									att1.Name = ESPLibrary:GenerateRandomString()
									att1.Parent = workspace.Terrain
									att1.Position = node.Position + Vector3.new(0,2,0)
									att1:SetAttribute("GardenNode", true)

									trace.Attachment0 = att0
									trace.Attachment1 = att1

								end
								previousnode = node
							end
						end





					end

					task.wait(0.1)

				end

				end)


			end


			function AddBackdoorTab()
				local BackdoorAnti = Tabs.Floor:AddLeftGroupbox('Disablers')
				

				local BackdoorVisuals = Tabs.Floor:AddRightGroupbox('Visuals')

	BackdoorVisuals:AddToggle('NotifyHasteTime', {
    Default = false,
    Text = "通知Haste时间",
    Tooltip = '会显示距离Haste生成还剩多少时间'
})

BackdoorAnti:AddToggle('AntiVacuum', {
    Text = '禁用Vacuum',
    Default = false,
    Tooltip = '防止Vacuum将你吸入虚空。',

    Callback = function(Value)
        AntiVacuum = Value

        for i,e in pairs(ObjectsTable.Dupe) do
            if e.Name == "SideroomSpace" then
                DisableDupe(e, Value)
            end
        end
    end
})

BackdoorBypass:AddToggle('AntiDread', {
    Text = '禁用Dread',
    Default = false,
    Tooltip = '防止Dread生成。',
    Callback = function(Value)
        if Value == true then
            Dread.Name = "Dread_"
        else
            Dread.Name = "Dread"
        end
    end
})

BackdoorAnti:AddDivider()

BackdoorAnti:AddToggle('AntiLookman', {
    Text = '免疫Lookman伤害',
    Default = false,
    Tooltip = "允许你直视Lookman的眼睛而不受伤害。",
					Callback = function(Value)

						AntiLookman = Value

						if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then






							if NewHotel == true then

								RemotesFolder.MotorReplication:FireServer(-750)

							else


								RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)


							end


						end

					end
				})



				



			end
			local AntiJeff = false
			local LibraryCodeSolved = false

			local WaitedForAmbush = false



			

		local AvoidingEntity = false
		local PreviousPosition = HumanoidRootPart.Position

	

		function AvoidEntity(Entity)
			
			if Toggles.AvoidEntities.Value and AvoidingEntity == false then
				AvoidingEntity = true
				PreviousPosition = HumanoidRootPart.Position

				local AvoidConnection = RunService.RenderStepped:Connect(function()
				Character:PivotTo(CFrame.new(Vector3.new(0,7500,0)))
				end)

				Entity.Destroying:Connect(function()
					local ExistingEntity
					for i,NewEntity in pairs(ObjectsTable.EntityModels) do
						if NewEntity.PrimaryPart and NewEntity.PrimaryPart.Position ~= Vector3.new(0, -10000, 1000000) and NewEntity.Name ~= "Eyes" then
							ExistingEntity = NewEntity
						end
					end
				

				if not ExistingEntity then
					HumanoidRootPart.Anchored = true
					task.wait(0.15)
					AvoidConnection:Disconnect()
					Character:PivotTo(CFrame.new(PreviousPosition))
					AvoidingEntity = false
					task.wait(0.15)
					HumanoidRootPart.Anchored = false
				end
				end)
			end
		end


			local function AddBeforePlusTab()
				local AutoDoorsCooldown = false
			function DoAutoDoors()

				if AutoDoorsCooldown == true then
					return
				end

				AutoDoorsCooldown = true
			
			local KeyObtain = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("KeyObtain", true)
			local ElectricalKeyObtain = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("ElectricalKeyObtain", true)
			local LiveHintBook = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("LiveHintBook", true)
			local PickupItem = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("PickupItem", true)
			local Door = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("Door")
			local Padlock = workspace:FindFirstChild("Padlock", true)
			local CollisionFloor = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("CollisionFloor", true)
			local LiveBreakerPolePickup = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("LiveBreakerPolePickup", true)
			local Entity = workspace:FindFirstChild("RushMoving") or workspace:FindFirstChild("AmbushMoving")
			local LibraryPaper = Character:FindFirstChild("LibraryHintPaper") or Player.Backpack:FindFirstChild("LibraryHintPaper") or Character:FindFirstChild("LibraryHintPaperHard") or Player.Backpack:FindFirstChild("LibraryHintPaperHard")
			local IndustrialGate = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("IndustrialGate", true)
			local ElevatorBreaker = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("ElevatorBreaker")
			local UnlockPrompt = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("UnlockPrompt", true)
				local ElectricalDoor = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("ElectricalDoor", true)
				local LeverForGate = workspace.CurrentRooms[CurrentRoom]:FindFirstChild("LeverForGate", true)
						

			
				
			if Entity and CurrentRoom > 45 and CurrentRoom < 55 or Entity and CurrentRoom > 95 then
			AutoDoorsCooldown = false
				Character:PivotTo(CFrame.new(Vector3.new(0,7500,0)))
				
			
			elseif KeyObtain and Door:FindFirstChild("Lock") and UnlockPrompt then
				
				if GetItem("Key") then
						Character:PivotTo(CFrame.new(Door.Door.Position))
						task.wait(0.2)
			     fireproximityprompt(UnlockPrompt)
				else
				Character:PivotTo(CFrame.new(KeyObtain.Hitbox.Position))
				task.wait(0.2)
			     fireproximityprompt(KeyObtain.ModulePrompt)
				end

		

				elseif ElectricalKeyObtain and UnlockPrompt and ElectricalDoor then
				
				if GetItem("KeyElectrical") then
						Character:PivotTo(CFrame.new(ElectricalDoor.Door.Position))
						task.wait(0.2)
			     fireproximityprompt(UnlockPrompt)
				else
				Character:PivotTo(CFrame.new(ElectricalKeyObtain.Hitbox.Position))
				task.wait(0.2)
			     fireproximityprompt(ElectricalKeyObtain.ModulePrompt)
				end
				
				elseif CollisionFloor and CollisionFloor:FindFirstChild("TouchInterest") then
						AutoDoorsCooldown = false
					Character:PivotTo(CFrame.new(CollisionFloor.Position))
					
				elseif IndustrialGate and IndustrialGate.Box.ActivateEventPrompt:GetAttribute("Interactions") == nil then
					
					
					
				Character:PivotTo(CFrame.new(IndustrialGate.Box.Position))
				task.wait(0.2)
			     fireproximityprompt(IndustrialGate.Box.ActivateEventPrompt)
				
			elseif PickupItem and not GetItem("LibraryHintPaper") and not GetItem("LibraryHintPaperHard") and LibraryCodeSolved == false then
				
				Character:PivotTo(CFrame.new(PickupItem.PrimaryPart.Position))
			task.wait(0.2)
			     fireproximityprompt(PickupItem.ModulePrompt)
			
				elseif LiveHintBook then
				
				Character:PivotTo(CFrame.new(LiveHintBook.PrimaryPart.Position - Vector3.new(0,5,0)))
				task.wait(0.2)
			     fireproximityprompt(LiveHintBook.ActivateEventPrompt)
				 
				 elseif LiveBreakerPolePickup then
				
				Character:PivotTo(CFrame.new(LiveBreakerPolePickup.PrimaryPart.Position - Vector3.new(0,5,0)))
			task.wait(0.2)
			     fireproximityprompt(LiveBreakerPolePickup.ActivateEventPrompt)

				 elseif LeverForGate and LeverForGate.ActivateEventPrompt:GetAttribute("Interactions") == nil then
				
				Character:PivotTo(CFrame.new(LeverForGate.PrimaryPart.Position - Vector3.new(0,5,0)))
			task.wait(0.2)
			     fireproximityprompt(LeverForGate.ActivateEventPrompt)
			
			
			
			elseif Padlock then

				local part
						for i,e in pairs(Padlock:GetDescendants()) do
							if e:IsA("BasePart") then
								part = e
							end
						end

				if LibraryPaper then
	
				local code = GetPadlockCode(LibraryPaper)
						local output, count = string.gsub(code, "_", "_")
						
						

						if tonumber(code) then

							RemotesFolder.PL:FireServer(code)
							LibraryCodeSolved = true




						end

					end

					if part then
				Character:PivotTo(CFrame.new(part.Position))
					end
				
					elseif ElevatorBreaker and CollisionFloor and not CollisionFloor:FindFirstChild("TouchInterest") and ElevatorBreaker.ActivateEventPrompt:GetAttribute("Interactions") == nil then
						Character:PivotTo(CFrame.new(ElevatorBreaker.Box.Position))
						Toggles.AutoBreaker:SetValue(true)
						task.wait(0.2)
					     fireproximityprompt(ElevatorBreaker.ActivateEventPrompt)
						 
						  
			
			elseif CurrentRoom ~= 100 and Door then
				
				Character:PivotTo(CFrame.new(Door.Door.Position))
				task.wait(0.2)
				Door.ClientOpen:FireServer()
				

		end

		task.wait(Options.AutoPlayDelay.Value)
						AutoDoorsCooldown = false

		end
				
				local BeforePlusAnti = Tabs.Floor:AddLeftGroupbox('Disablers')
				local BeforePlusBypass = Tabs.Floor:AddRightGroupbox('Bypass')
				local BeforePlusAutomation = Tabs.Floor:AddRightGroupbox('Automation')
				local BeforePlusVisuals = Tabs.Floor:AddLeftGroupbox('Visuals')
				local BeforePlusRemove = Tabs.Floor:AddLeftGroupbox('Removals')
				local BeforePlusBeta = Tabs.Floor:AddLeftGroupbox('Beta Features')


BeforePlusAnti:AddToggle('GodmodeFigureBeforePlus', {
    Text = 'Figure无敌模式',
    Tooltip = '使Figure无法杀死你。',
    Default = false,
})

BeforePlusRemove:AddToggle('RemoveGates', {
    Default = false,
    Text = "移除地下室大门",
    Tooltip = '移除所有生成的地下室大门。'
})

BeforePlusRemove:AddToggle('RemovePaintingDoor', {
    Default = false,
    Text = "移除画室门",
    Tooltip = '移除画室中的大门。'
})

Toggles.RemoveGates:OnChanged(function(Value)
    for i,Gate in pairs(ObjectsTable.RemovableModels) do
        if Gate.Name == "ThingToOpen" then
            if Value then
                Gate:PivotTo(CFrame.new(-10000,-10000,-10000))
            else
                Gate:PivotTo(Gate:GetAttribute("OriginalPosition"))
            end
        end
    end
end)

Toggles.RemovePaintingDoor:OnChanged(function(Value)
    for i,Gate in pairs(ObjectsTable.RemovableModels) do
        if Gate.Name == "MovingDoor" then
            if Value then
                Gate:PivotTo(CFrame.new(-10000,-10000,-10000))
            else
                Gate:PivotTo(Gate:GetAttribute("OriginalPosition"))
            end
        end
    end
end)

BeforePlusAutomation:AddToggle('AutoBreaker', {
    Text = '自动断路器谜题',
    Default = false,
    Tooltip = "自动完成断路器小游戏",

    Callback = function(Value)
        AutoBreaker = Value
    end
})

BeforePlusAutomation:AddToggle('AutoHeartbeatMinigame', {
    Text = "自动心跳小游戏",
    Default = false,
    Tooltip = '自动完成心跳小游戏。',
    Disabled = not (ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

BeforePlusAutomation:AddDivider()

BeforePlusAutomation:AddToggle('NotifyLibraryCode', {
    Default = false,
    Text = "自动图书馆密码",
    Tooltip = '自动破解图书馆密码并通知你'
})

BeforePlusAutomation:AddToggle('AutoUnlockPadlock', {
    Text = '自动解锁挂锁',
    Default = false,
    Tooltip = "当距离小于设定值时自动解锁图书馆挂锁。",
})

BeforePlusAutomation:AddSlider('AutoUnlockPadlockDistance', {
    Text = '解锁距离',
    Default = 35,
    Min = 10,
    Max = 75,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        AutoLibraryUnlockDistance = Value
    end
})

BeforePlusBeta:AddToggle("AutoPlay", {
    Text = "自动游玩",
    Tooltip = '自动帮你通关游戏。',
    Default = false,
    Disabled = not ExecutorSupport["fireproximityprompt"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

BeforePlusBeta:AddSlider('AutoPlayDelay', {
    Text = '传送延迟',
    Default = 0.5,
    Min = 0.25,
    Max = 0.75,
    Rounding = 2,
    Compact = true,
    Disabled = not ExecutorSupport["fireproximityprompt"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

BeforePlusVisuals:AddToggle('PredictEntities', {
    Default = false,
    Text = '预测实体',
    Tooltip = '告诉你实体何时会生成。'
})

BeforePlusVisuals:AddToggle('NotifyHideTime', {
    Default = false,
    Text = "通知藏匿时间",
    Tooltip = '告诉你还能在柜子里藏多久'
})

BeforePlusBypass:AddToggle('DeleteSeek', {
    Text = '删除Seek触发器',
    Tooltip = '删除Seek追逐触发器。',
    Default = false,

    Callback = function(Value)
        BypassSeek = Value
        if Value == true then

        end
    end,
})

BeforePlusBypass:AddToggle('DeleteFigure', {
    Text = '删除Figure',
    Default = false,
    Tooltip = '为所有玩家删除Figure。',

    Disabled = not (ExecutorSupport["isnetworkowner"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

BeforePlusBypass:AddDivider()

BeforePlusBypass:AddToggle('InfiniteRevivesBeforePlus', {
    Text = '无限复活',
    Default = false,
    Tooltip = '死亡时立即复活',
})

	
BeforePlusBypass:AddToggle('AvoidEntities', {
    Text = '躲避实体',
    Default = false,
    Tooltip = '实体生成时将你的角色传送到安全位置。',
})
				local AutoPlayConnection = RunService.RenderStepped:Connect(function()
					if Toggles.AutoPlay.Value then
						DoAutoDoors()
					end
				end)

				table.insert(RenderConnections, AutoPlayConnection)

				






				





				local ChaseStart = ReplicatedStorage:WaitForChild("GameData").ChaseStart
				local ChaseEnd = ReplicatedStorage:WaitForChild("GameData").ChaseEnd

				Toggles.PredictEntities:OnChanged(function(Value)
					if Value and Unloaded == false and ChaseStart.Value > CurrentRoom and (ChaseStart.Value - CurrentRoom) < 6 and ChaseEnd.Value == ChaseStart.Value + 1 then
						task.wait(0.5)
						if (ChaseStart.Value - CurrentRoom) > 1 then
							Caption('An entity will spawn in '..ChaseStart.Value - CurrentRoom .. ' rooms.', true)
						else
							Caption('An entity will spawn in '..ChaseStart.Value - CurrentRoom .. ' room.', true)
						end
					end
				end)

				LatestRoom:GetPropertyChangedSignal("Value"):Connect(function(Child)
					if Unloaded == false and Toggles.PredictEntities.Value and ChaseStart.Value > CurrentRoom and (ChaseStart.Value - CurrentRoom) < 7 and (ChaseStart.Value - CurrentRoom) > 1 and ChaseEnd.Value == ChaseStart.Value + 1 then
						task.wait(0.5)
						if (ChaseStart.Value - CurrentRoom) > 1 then
							Caption('An entity will spawn in '..ChaseStart.Value - CurrentRoom .. ' rooms.', true)
						else
							Caption('An entity will spawn in '..ChaseStart.Value - CurrentRoom .. ' room.', true)
						end
					end
				end)



			end

local function AddFoolsTab()
    local FoolsAnti = Tabs.Floor:AddLeftGroupbox('禁用')
    local FoolsBypass = Tabs.Floor:AddRightGroupbox('绕过')
    local FoolsAutomation = Tabs.Floor:AddRightGroupbox('自动化')
    local FoolsRemove = Tabs.Floor:AddLeftGroupbox('移除')
    local FoolsVisuals = Tabs.Floor:AddLeftGroupbox('视觉')

    FoolsVisuals:AddToggle('NotifyHideTime', {
        Default = false,
        Text = "通知藏匿时间",
        Tooltip = '告诉你还能在柜子里藏多久'
    })

    --[[if ExecutorSupport["isnetworkowner"] then
        local FoolsTrolling = Tabs.Floor:AddLeftGroupbox('恶搞')
        FoolsTrolling:AddButton{
            Text = '收集香蕉',
            DoubleClick = false,
            Tooltip = '将所有香蕉传送到你身边。',
            Func = function()
                for i,inst in pairs(workspace:GetChildren()) do
                    if inst.Name == "BananaPeel" then
                        if isnetworkowner(inst) then
                            inst.Position = Character.Head.Position
                        end
                    end
                end
            end,
        }
        FoolsTrolling:AddDivider()
        FoolsTrolling:AddDropdown('BananaTarget', {
            SpecialType = 'Player',
            Default = 0,
            Multi = false,
            Text = '目标',
            Tooltip = nil,
            Compact = true
        })
        FoolsTrolling:AddButton{
            Text = '传送香蕉到玩家',
            DoubleClick = false,
            Tooltip = '将所有香蕉传送到选中玩家身边。',
            Func = function()
                if typeof(Options.BananaTarget.Value) == "Instance" and Options.BananaTarget.Value ~= nil then
                    for i,inst in pairs(workspace:GetChildren()) do
                        if inst.Name == "BananaPeel" then
                            if isnetworkowner(inst) then
                                inst.Position = Options.BananaTarget.Value.Character.Head.Position
                            end
                        end
                    end
                end
            end,
        }
        FoolsTrolling:AddToggle('LoopTeleportBananas', {
            Text = '循环传送香蕉',
            Default = false,
            Tooltip = '自动将香蕉传送到选中目标。',
        })
    end]]

FoolsAnti:AddToggle("AntiBananaPeel",{Text = "禁用香蕉皮", Default = false,Tooltip = '防止香蕉皮绊倒你。'})

FoolsAnti:AddToggle("AntiJeff",{Text = "禁用Jeff",Default = false,Tooltip = '防止Jeff刺伤你。',
    Callback = function(Value)
        AntiJeff = Value
    end,
})

FoolsAnti:AddDivider()

FoolsAnti:AddToggle('GodmodeFigureFools', {
    Text = 'Figure无敌模式',
    Tooltip = '使Figure无法杀死你。',
    Default = false,
})

FoolsBypass:AddToggle('DeleteSeek', {
    Text = '删除Seek触发器',
    Tooltip = '删除Seek追逐触发器。',
    Default = false,

    Callback = function(Value)
        BypassSeek = Value
        if Value == true then

        end
    end,
})
FoolsBypass:AddToggle('DeleteFigure', {
    Text = '删除Figure',
    Default = false,
    Tooltip = '为所有玩家删除Figure。',

    Disabled = not (ExecutorSupport["isnetworkowner"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

FoolsBypass:AddToggle('DeleteJeff', {
    Text = "删除Jeff",
    Default = false,
    Tooltip = '为所有玩家删除Jeff。',

    Disabled = not (ExecutorSupport["isnetworkowner"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

--[[if ExecutorSupport["isnetworkowner"] then
    local Cooldown = false
    local Connection = RunService.RenderStepped:Connect(function()
        if Cooldown == false then
            Cooldown = true

            if typeof(Options.BananaTarget.Value) == "Instance" and Options.BananaTarget.Value and Toggles.LoopTeleportBananas.Value then
                for i,inst in pairs(workspace:GetChildren()) do
                    if inst.Name == "BananaPeel" then
                        if isnetworkowner(inst) then
                            inst.Position = Options.BananaTarget.Value:WaitForChild("Head", 9e9).Position
                        end
                    end
                end
            end
            task.wait(0.1)
            Cooldown = false
        end
    end)

    table.insert(RenderConnections, Connection)
end]]

FoolsBypass:AddDivider()

FoolsBypass:AddToggle('InfiniteRevivesFools', {
    Text = '无限复活',
    Default = false,
    Tooltip = '死亡时立即复活',
})

FoolsAutomation:AddToggle('AutoBreaker', {
    Text = '自动断路器谜题',
    Default = false,
    Tooltip = "自动完成断路器小游戏",

    Callback = function(Value)
        AutoBreaker = Value
    end
})

FoolsAutomation:AddToggle('AutoHeartbeatMinigame', {
    Text = "自动心跳小游戏",
    Default = false,
    Tooltip = '自动完成心跳小游戏。',
    Disabled = not (ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

FoolsAutomation:AddDivider()

FoolsAutomation:AddToggle('NotifyLibraryCode', {
    Default = false,
    Text = "自动图书馆密码",
    Tooltip = '自动破解图书馆密码并通知你'
})

FoolsAutomation:AddToggle('AutoUnlockPadlock', {
    Text = '自动解锁挂锁',
    Default = false,
    Tooltip = "当距离小于设定值时自动解锁图书馆挂锁。",
})

FoolsAutomation:AddSlider('AutoUnlockPadlockDistance', {
    Text = '解锁距离',
    Default = 35,
    Min = 10,
    Max = 75,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        AutoLibraryUnlockDistance = Value
    end
})

FoolsRemove:AddToggle('RemoveGates', {
    Default = false,
    Text = "移除地下室大门",
    Tooltip = '移除所有生成的地下室大门。'
})

FoolsRemove:AddToggle('RemovePaintingDoor', {
    Default = false,
    Text = "移除画室门",
    Tooltip = '移除画室中的大门。'
})

FoolsRemove:AddToggle('RemoveSkeletonDoor', {
    Default = false,
    Text = "移除骷髅门",
    Tooltip = '移除阻挡药草房的门。'
})

if Floor == "Fools" or OldHotel == true then
    Toggles.AntiBananaPeel:OnChanged(function(value)
        for _, peel in pairs(workspace:GetChildren()) do
            if peel.Name == "BananaPeel" then
                peel.CanTouch = not value
            end
        end
    end)

    Toggles.AntiJeff:OnChanged(function(value)
        for _, jeff in pairs(workspace:GetChildren()) do
            if jeff:IsA("Model") and jeff.Name == "JeffTheKiller" then
                for i,Part in pairs(jeff:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanTouch = not value
                    end
                end
            end
        end
    end)

    Toggles.RemoveGates:OnChanged(function(Value)
        for i,Gate in pairs(ObjectsTable.RemovableModels) do
            if Gate.Name == "ThingToOpen" then
                if Value then
                    Gate:PivotTo(CFrame.new(-10000,-10000,-10000))
                else
                    Gate:PivotTo(Gate:GetAttribute("OriginalPosition"))
                end
            end
        end
    end)

    Toggles.RemovePaintingDoor:OnChanged(function(Value)
        for i,Gate in pairs(ObjectsTable.RemovableModels) do
            if Gate.Name == "MovingDoor" then
                if Value then
                    Gate:PivotTo(CFrame.new(-10000,-10000,-10000))
                else
                    Gate:PivotTo(Gate:GetAttribute("OriginalPosition"))
                end
            end
        end
    end)

    Toggles.RemoveSkeletonDoor:OnChanged(function(Value)
        for i,SkeletonDoor in pairs(ObjectsTable.RemovableModels) do
            if SkeletonDoor.Name == "Wax_Door" then
                if Value then
                    SkeletonDoor:PivotTo(CFrame.new(-10000,-10000,-10000))
                else
                    SkeletonDoor:PivotTo(SkeletonDoor:GetAttribute("OriginalPosition"))
                end
            end
        end
    end)

    if ExecutorSupport["isnetworkowner"] then
        Toggles.DeleteJeff:OnChanged(function(value)
            for _, jeff in pairs(workspace:GetChildren()) do
                if jeff:IsA("Model") and jeff.Name == "JeffTheKiller" then
                    if value then
                        DeleteJeff(jeff)
                    end
                end
            end
        end)
    end
end

end

function AddRoomsTab()

    local RoomsAutomation = Tabs.Floor:AddRightGroupbox('自动化')
    local RoomsAnti = Tabs.Floor:AddLeftGroupbox('绕过')

    RoomsAnti:AddToggle('AntiDread', {
        Text = '禁用Dread',
        Default = false,
        Tooltip = '防止Dread生成。',
        Callback = function(Value)
            if Value == true then
                Dread.Name = "Dread_"
            else
                Dread.Name = "Dread"
            end
        end
    })		

function FixAutoRooms()
task.spawn(function()
while task.wait() do
	if Toggles.AutoRooms.Value and Character:GetAttribute("Hiding") ~= true and Character:GetAttribute("ClientAnimating") ~= true then
	CollisionPart.Weld.Enabled = false
	task.wait(0.75)
	CollisionPart.Weld.Enabled = true
	else
		CollisionPart.Weld.Enabled = true
	end
	if Library.Unloaded then 
		break
	end
end
end)
end	


FixAutoRooms()

RoomsAutomation:AddToggle("AutoRooms", {
    Text = "自动游玩Rooms",
    Default = false,
    Tooltip = '自动完成The Rooms',
})

Toggles.AutoRooms:OnChanged(function(Value)
    task.wait()
    Humanoid:MoveTo(HumanoidRootPart.Position)
end)

RoomsAutomation:AddToggle("ShowAutoRoomsPathNodes",{
    Text = "显示路径",
    Default = false,
    Tooltip = '为矿井Seek追逐创建可视化路径。',
}):AddColorPicker('RoomsNodeColor', {
    Default = Color3.fromRGB(0,255,0), -- 亮绿色
    Title = '节点颜色', -- 可选。允许自定义颜色选择器标题
    Transparency = 0, -- 可选。启用透明度更改（留空为nil则禁用）

    Callback = function(Value)
        for i,inst in pairs(workspace.Terrain:GetChildren()) do
            if inst:IsA("Beam") and inst:GetAttribute("RoomsNode") ~= nil then
                inst.Color  = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Value),
                    ColorSequenceKeypoint.new(1, Value)
                })
            end
        end
    end
})

Toggles.ShowAutoRoomsPathNodes:OnChanged(function(value)
    for i,inst in pairs(workspace.Terrain:GetChildren()) do
        if inst:IsA("Beam") and inst:GetAttribute("RoomsNode") ~= nil then
            inst.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, (Toggles.ShowAutoRoomsPathNodes.Value and 0 or 1)),
                NumberSequenceKeypoint.new(1, (Toggles.ShowAutoRoomsPathNodes.Value and 0 or 1)),
            })
        end
    end
end)

RoomsAutomation:AddDivider()

RoomsAutomation:AddToggle("IgnoreA60", {
    Text = "忽略A-60",
    Default = false,
    Tooltip = "不会躲避实体'A-60'（强制位置欺骗）。",
})

				if game.ReplicatedStorage.GameData.Floor.Value == "Rooms" then
					Toggles.RemoveA90:OnChanged(function(value)

						if Toggles.AutoRooms.Value and not value then


							Toggles.RemoveA90:SetValue(true)

						end


					end)

					local function CheckEntityActive()
						local Result

						for i,Child in pairs(ObjectsTable.EntityModels) do

							if Child.Name == "A120" or Child.Name == "GlitchRush" or Child.Name == "GlitchAmbush" or Child.Name == "A60" and not Toggles.IgnoreA60.Value then
								if Child.PrimaryPart == nil then
								elseif Child.PrimaryPart.Position.Y > -10 and Child.PrimaryPart.Position.Y < 150 then
									Result = Child
								end

							end
						end

						return Result
					end

					local function GetAutoRoomsPathfindingGoal()
						local entity = (CheckEntityActive())
						if entity and not game.Players.LocalPlayer.Character.CollisionPart.Anchored then

							local GoalLocker = GetNearestAssetWithCondition(function(asset)

								return asset.Name == "Rooms_Locker" and not asset.HiddenPlayer.Value and asset.PrimaryPart.Position.Y > -10 or asset.Name == "Rooms_Locker_Fridge" and not asset.HiddenPlayer.Value and asset.PrimaryPart.Position.Y > -10
							end)

							

							return GoalLocker.PrimaryPart

						end
						return workspace.CurrentRooms[CurrentRoom].RoomExit
					end


					local _internal_mspaint_pathfinding_block = Instance.new("Folder", game.Workspace) do
						_internal_mspaint_pathfinding_block.Name = "pathfinding_block"
					end

					local AutoRoomsPosition = Vector3.new(0,0,0)
					local AutoRoomsPathStatus = Enum.PathStatus.Success

				

					local A1000Connection = game["Run Service"].RenderStepped:Connect(function()

	local pathfindingGoal = GetAutoRoomsPathfindingGoal()
						if not Toggles.AutoRooms.Value then return end

						

							Toggles.NoAccell:SetValue(true)

							if Toggles.IgnoreA60.Value then
								Toggles.Godmode:SetValue(true)
							end
					


	
						local entity = CheckEntityActive()

						local isEntitySpawned = (entity)
						if isEntitySpawned and not game.Players.LocalPlayer.Character.CollisionPart.Anchored then



					

							if pathfindingGoal.Parent:FindFirstChild("HidePrompt") then

								if Player:DistanceFromCharacter(pathfindingGoal.Position) < pathfindingGoal.Parent.HidePrompt.MaxActivationDistance then
									fireproximityprompt(pathfindingGoal.Parent.HidePrompt)
								end


								if not game.Players.LocalPlayer.Character.CollisionPart.Anchored and game.Players.LocalPlayer:DistanceFromCharacter(pathfindingGoal.Position) < 5 then
									if ExecutorSupport["fireproximityprompt"] == false then
										local pos = CFrame.new(pathfindingGoal.Position)*CFrame.new(0,0,2)
										game.Workspace.CurrentCamera.CFrame = pos
									end
								end
							end


						elseif not entity and game.Players.LocalPlayer.Character.CollisionPart.Anchored or entity and entity.Name == "A60" and Toggles.IgnoreA60.Value  then

							for i = 1, 10 do
								game.ReplicatedStorage.RemotesFolder.CamLock:FireServer()
							end
						end

					end)
				
				
							
						
							
							table.insert(RenderConnections, A1000Connection)

					Toggles.AutoRooms:OnChanged(function(value)

						HumanoidRootPart.Massless = false
						local hasResetFailsafe = false

						local function nodeCleanup()
							workspace.Terrain:ClearAllChildren()
							_internal_mspaint_pathfinding_block:ClearAllChildren()
							hasResetFailsafe = true
						end
						local function moveToCleanup()
							if game.Players.LocalPlayer.Character.Humanoid then
								game.Players.LocalPlayer.Character.Humanoid:Move(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
								game.Players.LocalPlayer.Character.Humanoid.WalkToPart = nil
								game.Players.LocalPlayer.Character.Humanoid.WalkToPoint = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
							end
							nodeCleanup()
						end

						if value then
							Toggles.RemoveA90:SetValue(true)
							local lastRoomValue = 0

							local function createNewBlockedPoint(point)
								if not point then return end
								local block = Instance.new("Part", _internal_mspaint_pathfinding_block)
								local pathMod = Instance.new("PathfindingModifier", block)
								pathMod.Label = "Path_Block"


								block.Name = ESPLibrary:GenerateRandomString()
								block.Shape = Enum.PartType.Block

								local sizeY = 10

								block.Size = Vector3.new(1, sizeY, 1)
								block.Color = Color3.fromRGB(255, 130, 30)
								block.Material = Enum.Material.Neon
								block.Position = point.Position + Vector3.new(0, sizeY / 2, 0)
								block.Anchored = true
								block.CanCollide = false
								block.Transparency = Toggles.ShowAutoRoomsPathNodes.Value and 1 or 1
							end

							local FixCooldown = false


							local function doAutoRooms()
								local pathfindingGoal = GetAutoRoomsPathfindingGoal()
	local entity = CheckEntityActive()

								if CurrentRoom ~= lastRoomValue then
									_internal_mspaint_pathfinding_block:ClearAllChildren()
									lastRoomValue = CurrentRoom
								end

								if game.Players.LocalPlayer.Character.CollisionPart.Anchored then
									moveToCleanup()
									return
								end

								if Player:DistanceFromCharacter(pathfindingGoal.Position) > 1000 then
									return
								end

								



								local path = game:GetService("PathfindingService"):CreatePath({
									AgentCanJump = false,
									AgentCanClimb = false,
									WaypointSpacing = 8,
									AgentRadius = 1.25,
									Costs = {
										Path_Block = 8 --cost will increase the more stuck you get.
									}
								})

								local TargetPosition = pathfindingGoal.Position

								



								path:ComputeAsync(HumanoidRootPart.Position, TargetPosition)


								local waypoints = path:GetWaypoints()
								local waypointAmount = #waypoints



								if path.Status == Enum.PathStatus.Success then
									hasResetFailsafe = true



									workspace.Terrain:ClearAllChildren()

									local previousnode = nil

									for i, node in pairs(waypoints) do
										local color = Options.RoomsNodeColor.Value
										if previousnode ~= nil then
											local trace = Instance.new("Beam")
											trace.Name = ESPLibrary:GenerateRandomString()
											trace.Color = ColorSequence.new({
												ColorSequenceKeypoint.new(0, color),
												ColorSequenceKeypoint.new(1, color)
											})
											trace.FaceCamera = true
											trace.Width0 = 0.25
											trace.Transparency = NumberSequence.new({
												NumberSequenceKeypoint.new(0, (Toggles.ShowAutoRoomsPathNodes.Value and 0 or 1)),
												NumberSequenceKeypoint.new(1, (Toggles.ShowAutoRoomsPathNodes.Value and 0 or 1))
											})

											trace.Width1 = 0.25
											trace.Brightness = 10
											trace.LightInfluence = 0
											trace.LightEmission = 0
											trace.Enabled = true
											trace.Parent = workspace.Terrain
											trace:SetAttribute("RoomsNode", true)

											local att0 = Instance.new("Attachment")
											att0.Name = ESPLibrary:GenerateRandomString()
											att0.Parent = workspace.Terrain
											att0.Position = previousnode.Position + Vector3.new(0,1,0)
											att0:SetAttribute("RoomsNode", true)

											local att1 = Instance.new("Attachment")
											att1.Name = ESPLibrary:GenerateRandomString()
											att1.Parent = workspace.Terrain
											att1.Position = node.Position + Vector3.new(0,1,0)
											att1:SetAttribute("RoomsNode", true)

											trace.Attachment0 = att0
											trace.Attachment1 = att1

										end
										previousnode = node
									end

									local lastWaypoint = nil
									for i, waypoint in pairs(waypoints) do
										local moveToFinished = false
										local recalculate = false
										local waypointConnection = game.Players.LocalPlayer.Character.Humanoid.MoveToFinished:Connect(function() moveToFinished = true end)
										if not moveToFinished or not Toggles.AutoRooms.Value or CheckEntityActive() then
											if pathfindingGoal.Parent:FindFirstChild("HiddenPlayer") then
												if pathfindingGoal.Parent.HiddenPlayer.Value then
													moveToCleanup()
													break
												end
											end

											if game.Players.LocalPlayer.Character.CollisionPart.Anchored then
												moveToCleanup()
												break
											end

											if pathfindingGoal.Parent:FindFirstChild("HidePrompt") and game.Players.LocalPlayer.Character.CollisionPart.Anchored then
									moveToCleanup()
									return
								end



											game.Players.LocalPlayer.Character.Humanoid:MoveTo(waypoint.Position)





											local entity = CheckEntityActive()
											local isEntitySpawned = (entity)


											if isEntitySpawned and not game.Players.LocalPlayer.Character.CollisionPart.Anchored and pathfindingGoal.Parent.Name ~= "Rooms_Locker" and pathfindingGoal.Parent.Name ~= "Rooms_Locker_Fridge" then
												waypointConnection:Disconnect()

												if not Toggles.AutoRooms.Value then
													nodeCleanup()
													break
												else

												end

												break
											end

											task.delay(1, function()
												if moveToFinished then return end
												if (not Toggles.AutoRooms.Value) then return moveToCleanup() end

												repeat task.wait(0.25) until (not game.Players.LocalPlayer.Character:GetAttribute("Hiding") and not game.Players.LocalPlayer.Character.PrimaryPart.Anchored)

												recalculate = true

												if lastWaypoint == nil and waypointAmount > 1 then
													waypoint = waypoints[i+1]
												else
													waypoint = waypoints[i-1]
												end

												createNewBlockedPoint(waypoint)
											end)
										end

										repeat task.wait() until moveToFinished or not Toggles.AutoRooms.Value or recalculate
										lastWaypoint = waypoint

										waypointConnection:Disconnect()

										if not Toggles.AutoRooms.Value then
											nodeCleanup()
											break
										else

										end

										if recalculate then break end
									end
								else

									local Door = workspace.CurrentRooms:FindFirstChild(CurrentRoom):WaitForChild("Door", 9e9).Door
									Humanoid:MoveTo(Door.Position)

								end
							end
							while Toggles.AutoRooms.Value and not Library.Unloaded do
								if CurrentRoom == 1000 then


									break
								end

								if Player:DistanceFromCharacter(workspace:WaitForChild("CurrentRooms"):FindFirstChild(CurrentRoom).RoomExit.Position) < 1000 then

									doAutoRooms()

								end

								task.wait()
							end

						end
					end)
				end
			end
			local MinesRoomAddedConnection
			local Bridges = {}








--[[local ExtraVisualsTab = Tabs.Extra:AddLeftGroupbox('内容创作')

ExtraVisualsTab:AddToggle("WatermarkToggle",{
    Text = "启用水印",
    Default = false,
    Tooltip = '允许你在屏幕上始终显示自定义文字',
    Callback = function(value)
        Watermark.Visible = value
    end,
})
ExtraVisualsTab:AddInput('WatermarkText', {
    Default = '',
    Numeric = false, -- true / false，仅允许数字
    Finished = false, -- true / false，仅在按下回车时触发回调

    Text = '水印文字',
    Tooltip = '选择水印显示的文字',

    Placeholder = '在此输入文字',
    -- MaxLength 也是可选参数，表示文字最大长度

    Callback = function(Value)
        Watermark.Text = Value
    end
})]]



--[[local ItemsTab = Tabs.Fun:AddLeftGroupbox('客户端物品')

ItemsTab:AddButton({
    Text = '获取手电筒',
    Func = function()
        -- ... 手电筒生成代码 ...
    end,
    DoubleClick = false,
    Tooltip = '获取一个其他玩家看不到的客户端手电筒。'
})

ItemsTab:AddButton({
    Text = '获取软糖手电筒',
    Func = function()

					local Modules = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules
					local shears = game:GetObjects("rbxassetid://12794355024")[1]
					shears.CanBeDropped = false
					shears.Parent = game.Players.LocalPlayer.Backpack
					shears:WaitForChild("Handle").SpotLight.Brightness = 2
					shears:WaitForChild("Handle").SpotLight.Range = 75
					shears:WaitForChild("Handle").SpotLight.Angle = 50
					shears:SetAttribute("LightSourceBeam",true)
					shears:SetAttribute("LightSourceStrong",true)
					shears:SetAttribute("Enabled",false)
					shears:SetAttribute("Interactable",true)
					shears:SetAttribute("LightSource",true)
					shears:SetAttribute("NamePlural","Shakelights")
					shears:SetAttribute("NameSingular","Shakelight")
					local newCFrame = CFrame.new(0.00991821289, -0.17137143, 0.0771455616, 1, 0, 0, 0, 0, -1, 0, 1, 0)

					shears.Grip = newCFrame
					shears.WorldPivot = CFrame.new(249.886551, 1.53111672, -16.8949146, -0.765167952, 0.00742102973, 0.64378804, -0.000446901657, 0.999927223, -0.0120574543, -0.643830597, -0.00951368641, -0.765108943)
					shears.Name = "Shakelight"
					local Animations_Folder = Instance.new("Folder")
					Animations_Folder.Name = "Animations"
					Animations_Folder.Parent = shears
					local Shake_Animation = Instance.new("Animation")
					Shake_Animation.AnimationId = "rbxassetid://12001275923"
					Shake_Animation.Parent = Animations_Folder
					local Idle_Animation = Instance.new("Animation")
					Idle_Animation.AnimationId = "rbxassetid://11372556429"
					Idle_Animation.Parent = Animations_Folder
					local Equip_Animation = Instance.new("Animation")
					Equip_Animation.AnimationId = "rbxassetid://15386368619"
					Equip_Animation.Parent = Animations_Folder
					local Shake_Sound = Instance.new("Sound")
					Shake_Sound.Name = "Shake_Sound"
					Shake_Sound.Parent = shears
					Shake_Sound.SoundId = "rbxassetid://11374330092"
					Shake_Sound.PlaybackSpeed = 0.9
					Shake_Sound.Volume = 1
					local Shaking = false

					shears.TextureId = "rbxassetid://11373085609"

					local Animator = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
					local anim2 = Animator:LoadAnimation(Idle_Animation)
					anim2.Priority = Enum.AnimationPriority.Action3

					local anim3 = Animator:LoadAnimation(Equip_Animation)
					anim3.Priority = Enum.AnimationPriority.Action3
					anim3:Play()

					local anim = Animator:LoadAnimation(Shake_Animation)	

					shears.Activated:Connect(function()
						if Shaking == false and shears.Parent == game.Players.LocalPlayer.Character then





							anim.Priority = Enum.AnimationPriority.Action4

							anim:Stop()
							Shaking = true
							task.wait()
							anim:Play()

							Shake_Sound:Play()

							task.wait(0.25)

							Shaking = false


						end

					end)
					shears.Equipped:Connect(function()
						anim3:Play()
						anim2:Play()
						if Modules:FindFirstChild("Screech") then
							Modules.Screech.Name = "Screech_"
						end
					end)
					shears.Unequipped:Connect(function()
						anim2:Stop()
						if Modules:FindFirstChild("Screech_") then
							if AntiScreech == false then
								Modules["Screech_"].Name = "Screech"
							end
						end
					end)




				end,
				DoubleClick = false,
Tooltip = '获取一个其他玩家看不到的客户端软糖手电筒。'
})

ItemsTab:AddDivider()

ItemsTab:AddButton({
    Text = "获取维生素",
    DoubleClick = false,
    Func = function()
        -- ... 维生素生成代码 ...
    end,
    Tooltip = '获取一组客户端维生素来提升速度。'
})

ItemsTab:AddButton({
    Text = "获取无限维生素",
    DoubleClick = false,
    Func = function()
        -- ... 无限维生素生成代码 ...
    end,
    Tooltip = '获取一组客户端无限维生素来提升速度。'
})

if firesignal and OldHotel == false then

    local Environment = Tabs.Fun:AddRightGroupbox('环境')

    Environment:AddSlider('FlickerDuration', {
        Min = 0.5,
        Max = 10,
        Default = 1,
        Rounding = 1,
        Text = "闪烁时长",
        Tooltip = '你希望灯光闪烁持续多久。',
        Compact = true
    })

    Environment:AddButton{
        Text = "闪烁灯光",
        Tooltip = '在客户端以选定的时长闪烁灯光。',
        DoubleClick = false,
        Func = function()
            FlickerLights(Options.FlickerDuration.Value)
        end,
    }

    Environment:AddDivider()

    Environment:AddToggle('InfiniteFlickerLights', {
        Default = false,
        Text = "无限闪烁灯光",
        Tooltip = '重复闪烁灯光直到关闭。'
    })

    -- ... 渲染循环代码 ...

end

local TrollingTab = Tabs.Fun:AddRightGroupbox('恶搞')

TrollingTab:AddToggle('Fake Stun', {
    Default = false,
    Text = "假眩晕",
    Tooltip = '让你的角色看起来被眩晕了。',
    Callback = function(Value)
        Character:SetAttribute("Stunned", Value)
    end,
})

if ExecutorSupport["isnetworkowner"] and Floor ~= "Retro" then
    TrollingTab:AddToggle('BreakDoorAnimation', {
        Default = false,
        Text = "破坏门动画",
        Tooltip = '完全破坏所有门的动画。'
    })
end]]

			local Resetting = false
			local SilentAimChance = 100


local function GetSilentAimTarget()
	local Camera = workspace.CurrentCamera
	local NearestTarget
	local NearestTargetDistance = math.huge
	
	for i,NewPlayer in pairs(Players:GetPlayers()) do
	
				if NewPlayer ~= Player and NewPlayer.Character and NewPlayer.Character:FindFirstChild("Collision") and NewPlayer.Character:GetAttribute("Stunned") ~= true and Player:DistanceFromCharacter(NewPlayer.Character:FindFirstChild("Collision").Position) <= 75 then
					
					local ScreenPosition, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(NewPlayer.Character:FindFirstChild("Collision").Position)

				
							if OnScreen then
								local MousePosition = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
								
						local HeadPosition2D = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
								local Distance = (MousePosition - HeadPosition2D).Magnitude
					if Distance < NearestTargetDistance and Distance < Options.circleSize.Value then

						local origin = Collision.Position
		local target = NewPlayer.Character:FindFirstChild("Collision").Position
		local direction = (target - origin).Unit * (target - origin).Magnitude

		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {Character, NewPlayer.Character}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local result = workspace:Raycast(origin, direction, rayParams)

		if result and Options.SilentAimSettings.Value["Ignore Walls"] or not result then
			
		

						
									NearestTargetDistance = Distance
							NearestTarget = NewPlayer.Character:FindFirstChild("Collision")
		end
							end
								end
							end
						
					
				
			
		
		
	end
	
	
	
	return NearestTarget
end







local SilentAimTarget









			function AddPartyTab()
				local PartyAnti = Tabs.Floor:AddLeftGroupbox('Disablers')
				local PartyVisuals = Tabs.Floor:AddRightGroupbox('Visuals')
				local PartyBypasses = Tabs.Floor:AddRightGroupbox('Bypasses')
				

PartyVisuals:AddToggle('NotifyOxygen', {
    Default = false,
    Text = "通知氧气水平",
    Tooltip = '会告诉你剩余氧气量'
})

PartyVisuals:AddToggle('NotifyHideTime', {
    Default = false,
    Text = "通知藏匿时间",
    Tooltip = '告诉你还能在柜子里藏多久'
})

PartyBypasses:AddToggle('AutoPowerups', {
    Default = false,
    Text = "能量光环",
    Tooltip = '自动触碰能量板。',
    Disabled = not (ExecutorSupport["firetouchinterest"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

PartyAnti:AddToggle("AntiNanner", {
    Text = "禁用Nanner Peel",
    Default = false,
    Tooltip = '允许你踩在Nanner Peel上而不会滑倒。'
})

PartyAnti:AddToggle('AntiVacuum', {
    Text = '禁用Vacuum',
    Default = false,
    Tooltip = '防止Vacuum将你吸入虚空。',

    Callback = function(Value)
        AntiVacuum = Value
        for i,e in pairs(ObjectsTable.Dupe) do
            if e.Name == "SideroomSpace" then
                DisableDupe(e, Value)
            end
        end
    end
})
PartyAnti:AddToggle("AntiGiggle", {
    Text = "禁用Giggle",
    Default = false,
    Tooltip = '防止Giggle攻击你。',
    Callback = function(value)
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, giggle in pairs(room:GetChildren()) do
                if giggle.Name == "GiggleCeiling" then
                    giggle:WaitForChild("Hitbox", 5).CanTouch = not value
                end
            end
        end
    end,
})

PartyAnti:AddToggle("AntiGloomEgg", {
    Text = "禁用Gloombat蛋",
    Default = false,
    Tooltip = '允许你踩在Gloombat蛋上而不会使其破碎。'
})

PartyAnti:AddToggle('AntiDread', {
    Text = '禁用Dread',
    Default = false,
    Tooltip = '防止Dread生成。',
    Callback = function(Value)
        if Value == true then
            Dread.Name = "Dread_"
        else
            Dread.Name = "Dread"
        end
    end
})

PartyAnti:AddDivider()

PartyAnti:AddToggle('AntiLookman', {
    Text = '免疫Lookman伤害',
    Default = false,
    Tooltip = "允许你直视Lookman的眼睛而不受伤害。",

    Callback = function(Value)
        AntiLookman = Value
        if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then
            if NewHotel == true then
                RemotesFolder.MotorReplication:FireServer(-750)
            else
                RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)
            end
        end
    end
})

Toggles.AntiNanner:OnChanged(function(value)
    for _, peel in pairs(workspace:GetChildren()) do
        if peel.Name == "NannerPeel" then
            peel.CanTouch = not value
            peel.Hitbox.CanTouch = not Toggles.AntiNanner.Value
        end
    end
end)

end

function AddHotelTab()
    local HotelLeftTab = Tabs.Floor:AddLeftTabbox('实体 / 自动化')
    local HotelAutomation = HotelLeftTab:AddTab('自动化')
    local HotelAnti = HotelLeftTab:AddTab('实体')

    local HotelVisuals = Tabs.Floor:AddRightGroupbox('视觉')

    HotelVisuals:AddToggle('NotifyOxygen', {
        Default = false,
        Text = "通知氧气水平",
        Tooltip = '会告诉你剩余氧气量'
    })

    HotelVisuals:AddToggle('NotifyHideTime', {
        Default = false,
        Text = "通知藏匿时间",
        Tooltip = '告诉你还能在柜子里藏多久'
    })

    HotelVisuals:AddToggle('NotifyHasteTime', {
        Default = false,
        Text = "通知Haste时间",
        Tooltip = '会显示距离Haste生成还剩多少时间'
    })

    HotelVisuals:AddDivider()

    HotelVisuals:AddToggle('NoFiredampEffects', {
        Text = '禁用瓦斯效果',
        Default = false,
        Tooltip = '移除瓦斯屏幕效果',

        Callback = function(Value)
            for i,Room in pairs(workspace:WaitForChild("CurrentRooms"):GetChildren()) do
                if Room:GetAttribute("OriginalFiredamp") == nil then
                    Room:SetAttribute("OriginalFiredamp", Room:GetAttribute("Firedamp") == true and true or false)
                end
                Room:SetAttribute("Firedamp", (Room:GetAttribute("OriginalFiredamp") == true and Value == false and true or false))
            end

            local PreviousCurrentRoom = Player:GetAttribute("CurrentRoom")
            Player:SetAttribute("CurrentRoom", (tonumber(PreviousCurrentRoom) + 1))
            task.wait(0.1)
            Player:SetAttribute("CurrentRoom", PreviousCurrentRoom)
        end
    })

    HotelAnti:AddToggle('AntiVacuum', {
        Text = '禁用Vacuum',
        Default = false,
        Tooltip = '防止Vacuum将你吸入虚空。',

        Callback = function(Value)
            AntiVacuum = Value
            for i,e in pairs(ObjectsTable.Dupe) do
                if e.Name == "SideroomSpace" then
                    DisableDupe(e, Value)
                end
            end
        end
    })
    HotelAnti:AddToggle("AntiGiggle", {
        Text = "禁用Giggle",
        Default = false,
        Tooltip = '防止Giggle攻击你。',
        Callback = function(value)
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                for _, giggle in pairs(room:GetChildren()) do
                    if giggle.Name == "GiggleCeiling" then
                        giggle:WaitForChild("Hitbox", 5).CanTouch = not value
                    end
                end
            end
        end,
    })

    HotelAnti:AddToggle("AntiGloomEgg", {
        Text = "禁用Gloombat蛋",
        Default = false,
        Tooltip = '允许你踩在Gloombat蛋上而不会使其破碎。'
    })

    HotelAnti:AddToggle('AntiDread', {
        Text = '禁用Dread',
        Default = false,
        Tooltip = '防止Dread生成。',
        Callback = function(Value)
            if Value == true then
                Dread.Name = "Dread_"
            else
                Dread.Name = "Dread"
            end
        end
    })

    HotelAnti:AddDivider()

    HotelAnti:AddToggle('AntiLookman', {
        Text = '免疫Lookman伤害',
        Default = false,
        Tooltip = "允许你直视Lookman的眼睛而不受伤害。",
					Callback = function(Value)

						AntiLookman = Value

						if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then






							if NewHotel == true then

								RemotesFolder.MotorReplication:FireServer(-750)

							else


								RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)


							end


						end

					end
				})









	HotelAutomation:AddToggle('AutoBreaker', {
    Text = '自动断路器谜题',
    Default = false,
    Tooltip = "自动完成断路器小游戏",

    Callback = function(Value)
        AutoBreaker = Value
    end
})

HotelAutomation:AddToggle('AutoHeartbeatMinigame', {
    Text = "自动心跳小游戏",
    Default = false,
    Tooltip = '自动完成心跳小游戏。',
    Disabled = not (ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

HotelAutomation:AddDivider()

HotelAutomation:AddToggle('AutoEatCandies', {
    Text = '自动吃糖果',
    Default = false,
    Tooltip = '自动吃掉你持有的所有糖果',

    Callback = function(Value)
    end
})
HotelAutomation:AddDropdown("AutoEatCandiesIgnoreList",
    { Values = {'Volatile Starlight','Can-Die'},
        Default = 0,
        Multi = true,
        Text = "糖果忽略列表",
    })

HotelAutomation:AddDivider()

HotelAutomation:AddToggle('NotifyLibraryCode', {
    Default = false,
    Text = "自动图书馆密码",
    Tooltip = '自动破解图书馆密码并通知你'
})

HotelAutomation:AddToggle('AutoUnlockPadlock', {
    Text = '自动解锁挂锁',
    Default = false,
    Tooltip = "当距离小于设定值时自动解锁图书馆挂锁。",
})

HotelAutomation:AddSlider('AutoUnlockPadlockDistance', {
    Text = '解锁距离',
    Default = 35,
    Min = 10,
    Max = 75,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        AutoLibraryUnlockDistance = Value
    end
})

Toggles.AntiGloomEgg:OnChanged(function(value)
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        for _, gloomPile in pairs(room:GetChildren()) do
            if gloomPile.Name == "GloomPile" then
                for _, gloomEgg in pairs(gloomPile:GetDescendants()) do
                    if gloomEgg.Name == "Egg" then
                        gloomEgg.CanTouch = not value
                    end
                end
            end
        end
    end
end)

Toggles.AntiGiggle:OnChanged(function(value)
    for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
        for _, giggle in pairs(room:GetChildren()) do
            if giggle.Name == "GiggleCeiling" then
                giggle:WaitForChild("Hitbox", 5).CanTouch = not value
            end
        end
    end
end)

MinesRoomAddedConnection = game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)
    if Toggles.NoFiredampEffects then
        child:SetAttribute("OriginalFiredamp", child:GetAttribute("Firedamp") == true and true or false)
        child:SetAttribute("Firedamp", (child:GetAttribute("OriginalFiredamp") == true and Toggles.NoFiredampEffects.Value == false and true or false))
    end
end)
end

function AddMinesTab()
    local EntitiesDisabled = false

    local MinesLeftTab = Tabs.Floor:AddLeftTabbox('自动化 / 实体')
    local MinesBypasses = Tabs.Floor:AddRightGroupbox('绕过')
    local MinesVisuals = Tabs.Floor:AddRightGroupbox('视觉')

    local MinesAutomation = MinesLeftTab:AddTab('自动化')
    local MinesAnti = MinesLeftTab:AddTab('禁用')

    MinesVisuals:AddToggle('NotifyOxygen', {
        Default = false,
        Text = "通知氧气水平",
        Tooltip = '会告诉你剩余氧气量'
    })

    MinesVisuals:AddToggle('NotifyHideTime', {
        Default = false,
        Text = "通知藏匿时间",
        Tooltip = '告诉你还能在柜子里藏多久'
    })

    MinesAutomation:AddToggle('NotifyAnchorCode', {
        Default = false,
        Text = "自动锚点密码",
        Tooltip = '计算出当前锚点的正确密码。'
    })

    MinesAutomation:AddToggle('SolveAnchors', {
        Default = false,
        Text = "自动破解锚点",
        Tooltip = '自动将正确密码输入锚点。'
    })

    MinesAutomation:AddDivider()

    MinesAutomation:AddToggle('AutoEatCandies', {
        Text = '自动吃糖果',
        Default = false,
        Tooltip = '自动吃掉你持有的所有糖果',

        Callback = function(Value)
        end
    })
    MinesAutomation:AddDropdown("AutoEatCandiesIgnoreList",
        { Values = {'Volatile Starlight','Can-Die'},
            Default = 0,
            Multi = true,
            Text = "糖果忽略列表",
        })
MinesAnti:AddToggle("AntiGiggle", {
    Text = "禁用Giggle",
    Default = false,
    Tooltip = '防止Giggle攻击你。',
    Callback = function(value)
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, giggle in pairs(room:GetChildren()) do
                if giggle.Name == "GiggleCeiling" then
                    giggle:WaitForChild("Hitbox", 5).CanTouch = not value
                end
            end
        end
    end,
})

MinesAnti:AddToggle("AntiGloomEgg", {
    Text = "禁用Gloombat蛋",
    Default = false,
    Tooltip = '允许你踩在Gloombat蛋上而不会使其破碎。'
})

MinesAnti:AddToggle('AntiVacuum', {
    Text = '禁用Vacuum',
    Default = false,
    Tooltip = '防止Vacuum将你吸入虚空。',

    Callback = function(Value)
        AntiVacuum = Value
        for i,e in pairs(ObjectsTable.Dupe) do
            if e.Name == "SideroomSpace" then
                DisableDupe(e, Value)
            end
        end
    end
})

MinesAnti:AddToggle("AntiSeekFlood", {
    Text = "禁用Seek洪水",
    Default = false,
    Tooltip = '防止Dam Seek伤害你。'
})

MinesAnti:AddToggle('AntiDread', {
    Text = '禁用Dread',
    Default = false,
    Tooltip = '防止Dread生成。',
    Callback = function(Value)
        if Value == true then
            Dread.Name = "Dread_"
        else
            Dread.Name = "Dread"
        end
    end
})

MinesAnti:AddDivider()

MinesAnti:AddToggle('AntiLookman', {
    Text = '免疫Lookman伤害',
    Default = false,
    Tooltip = "允许你直视Lookman的眼睛而不受伤害。",

    Callback = function(Value)
        AntiLookman = Value
        if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then
            if NewHotel == true then
                RemotesFolder.MotorReplication:FireServer(-750)
            else
                RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)
            end
        end
    end
})

local TurnNodes = {}

MinesAutomation:AddDivider()

MinesAutomation:AddToggle('AutoPlayMinecart', {
    Default = false,
    Text = '自动矿车',
    Tooltip = '自动完成矿车追逐。',
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

MinesAutomation:AddSlider('AutoMinecartDuckDetectDistance', {
    Text = '蹲下距离',
    Default = 35,
    Min = 25,
    Max = 50,
    Rounding = 0,
    Compact = true,
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

MinesAutomation:AddSlider('AutoMinecartTurnDetectDistance', {
    Text = '转弯距离',
    Default = 45,
    Min = 35,
    Max = 50,
    Rounding = 0,
    Compact = true,
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})
			
				if ExecutorSupport["require"] == true then

					local AutoMinecartInitialised = false
					local AutoMinecartFinished = false

					local MinesObstuction = Instance.new("ObjectValue")
					MinesObstuction.Name = "MinesObstruction"
					MinesObstuction.Parent = ReplicatedStorage

					local Minecart = Instance.new("ObjectValue")
					Minecart.Name = "Minecart"
					Minecart.Parent = ReplicatedStorage

					local MinesPlaceholder = Instance.new("Model")
					MinesPlaceholder.Name = "MinesPlaceholder"
					MinesPlaceholder.Parent = ReplicatedStorage

					local GetMoveVector = Instance.new("Vector3Value")
					GetMoveVector.Name = "GetMoveVector"
					GetMoveVector.Parent = ReplicatedStorage


					table.insert(DestroyElements, MinesObstuction)

					table.insert(DestroyElements, Minecart)

					table.insert(DestroyElements, MinesPlaceholder)

					table.insert(DestroyElements, GetMoveVector)


					local function GetNearestObstruction()
						local NearestDistance = math.huge
						local Obstruction = MinesPlaceholder
						for i,Asset in pairs(workspace:WaitForChild("CurrentRooms"):FindFirstChild(Player:GetAttribute("CurrentRoom")).Assets:GetChildren()) do
							if Asset.Name == "DuckBoard" and Player:DistanceFromCharacter(Asset.PrimaryPart.Position) < NearestDistance and Player:DistanceFromCharacter(Asset.PrimaryPart.Position) < Options.AutoMinecartDuckDetectDistance.Value  then
								Obstruction = Asset
								NearestDistance = Player:DistanceFromCharacter(Asset.PrimaryPart.Position)
							end
						end
						return Obstruction
					end

					local AutoPlayMinecartConnection = RunService.RenderStepped:Connect(function()
						if not workspace.CurrentCamera:FindFirstChild("MinecartRig") then return end


						MinesObstuction.Value = GetNearestObstruction()

					end)

					local AutoPlayMinecartConnection2 = MinesObstuction:GetPropertyChangedSignal("Value"):Connect(function()
						if not workspace.CurrentCamera:FindFirstChild("MinecartRig") then return end
						local Obstruction = MinesObstuction.Value
						if Toggles.AutoPlayMinecart.Value then
							if Obstruction.Name == "DuckBoard" then
								Main_Game.crouch(true)
							else
								Main_Game.crouch(false)
							end
						end
					end)








					local function GetNearestTurnNode()
						local NearestDistance = math.huge
						local NearestNode
						for i,Node in pairs(TurnNodes) do
							if Node.Parent ~= nil and Player:DistanceFromCharacter(Node.Position) < NearestDistance and Player:DistanceFromCharacter(Node.Position) < Options.AutoMinecartTurnDetectDistance.Value  then
								NearestNode = Node
								NearestDistance = Player:DistanceFromCharacter(Node.Position)
							end
						end
						return NearestNode
					end





					Toggles.AutoPlayMinecart:OnChanged(function(Value)
						if Value then
							if workspace.CurrentCamera:FindFirstChild("MinecartRig") then

								if AutoMinecartInitialised == false then
									AutoMinecartInitialised = true
									Notify({Title = "Auto Minecart", Description = "Your movement is now fully automated.",Reason = "Please keep looking forwards for auto minecart to work."})
									Sound()
								end

								PlayerModule.GetMoveVector = function()
									return game.ReplicatedStorage:FindFirstChild("GetMoveVector").Value or Vector3.new(0,0,0) 
								end
							else
								PlayerModule.GetMoveVector = OldFunction




							end
						elseif not Value then
							PlayerModule.GetMoveVector = OldFunction
						end
					end)




















					local function IsFacingForwardsOrBackwards(cframeA, cframeB)
						local dirA = cframeA.LookVector
						local dirB = cframeB.LookVector
						local dot = dirA:Dot(dirB)

						if dot > 0 then
							return "Forwards"
						else
							return "Backwards"
						end
					end

					local AutoPlayMinecartConnection7 = RunService.RenderStepped:Connect(function()
						if not workspace.CurrentCamera:FindFirstChild("MinecartRig") then return end
						local NearestNode = GetNearestTurnNode()


						if NearestNode then
							if NearestNode:GetAttribute("Turn") == "Left" then



								GetMoveVector.Value = Vector3.new(-1,0,0)





							elseif NearestNode:GetAttribute("Turn") == "Right" then



								GetMoveVector.Value = Vector3.new(1,0,0)






							else
								GetMoveVector.Value = Vector3.new(0,0,0)
							end
						else
							GetMoveVector.Value = Vector3.new(0,0,0)
						end
					end)

					local AutoPlayMinecartConnection5 = workspace.CurrentCamera.ChildAdded:Connect(function(Child)



						if workspace.CurrentCamera:FindFirstChild("MinecartRig") and Toggles.AutoPlayMinecart.Value then

							if AutoMinecartInitialised == false then
								AutoMinecartInitialised = true
Notify({Title = "自动矿车", Description = "你的移动现在已完全自动化。", Reason = "请保持向前看以使自动矿车正常工作。"})
Sound()
end

PlayerModule.GetMoveVector = function()
    return game.ReplicatedStorage:FindFirstChild("GetMoveVector").Value or Vector3.new(0,0,0)
end

else
    PlayerModule.GetMoveVector = OldFunction
end
end)

local AutoPlayMinecartConnection6 = workspace.CurrentCamera.ChildRemoved:Connect(function(Child)
    if workspace.CurrentCamera:FindFirstChild("MinecartRig") and Toggles.AutoPlayMinecart.Value then
        if AutoMinecartInitialised == false then
            AutoMinecartInitialised = true
            Notify({Title = "自动矿车", Description = "你的移动现在已完全自动化。", Reason = "请保持向前看以使自动矿车正常工作。"})
            Sound()
        end
        PlayerModule.GetMoveVector = function()
            return game.ReplicatedStorage:FindFirstChild("GetMoveVector").Value or Vector3.new(0,0,0)
        end
    else
        PlayerModule.GetMoveVector = OldFunction
    end
end)

local AutoPlayMinecartConnection3 = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    AutoPlayMinecartConnection5 = workspace.CurrentCamera.ChildAdded:Connect(function(Child)
        if workspace.CurrentCamera:FindFirstChild("MinecartRig") and Toggles.AutoPlayMinecart.Value then
            if AutoMinecartInitialised == false then
                AutoMinecartInitialised = true
                Notify({Title = "自动矿车", Description = "你的移动现在已完全自动化。", Reason = "请保持向前看以使自动矿车正常工作。"})
                Sound()
            end
            PlayerModule.GetMoveVector = function()
                return game.ReplicatedStorage:FindFirstChild("GetMoveVector").Value or Vector3.new(0,0,0)
            end
        else
            PlayerModule.GetMoveVector = OldFunction
        end
    end)

    AutoPlayMinecartConnection6 = workspace.CurrentCamera.ChildRemoved:Connect(function(Child)
        if workspace.CurrentCamera:FindFirstChild("MinecartRig") and Toggles.AutoPlayMinecart.Value then
            if AutoMinecartInitialised == false then
                AutoMinecartInitialised = true
                Notify({Title = "自动矿车", Description = "你的移动现在已完全自动化。", Reason = "请保持向前看以使自动矿车正常工作。"})
                Sound()
            end
            PlayerModule.GetMoveVector = function()
                return game.ReplicatedStorage:FindFirstChild("GetMoveVector").Value or Vector3.new(0,0,0)
            end
        else
            PlayerModule.GetMoveVector = OldFunction
        end
    end)
end)

table.insert(RenderConnections, AutoPlayMinecartConnection)
table.insert(RenderConnections, AutoPlayMinecartConnection2)
table.insert(RenderConnections, AutoPlayMinecartConnection3)
table.insert(RenderConnections, AutoPlayMinecartConnection5)
table.insert(RenderConnections, AutoPlayMinecartConnection7)

workspace.CurrentRooms.ChildAdded:Connect(function(Child)
    if Child.Name == "50" then
        task.wait(1)
        if CurrentRoom > 48 and AutoMinecartFinished == false and Toggles.AutoPlayMinecart.Value then
            AutoMinecartFinished = true
            Notify({Title = "自动矿车", Description = "自动矿车已完成。", Reason = "你现在可以自由控制移动。"})
            Sound()
        end
        AutoPlayMinecartConnection:Disconnect()
        AutoPlayMinecartConnection2:Disconnect()
        AutoPlayMinecartConnection3:Disconnect()
        AutoPlayMinecartConnection5:Disconnect()
        AutoPlayMinecartConnection7:Disconnect()
    end
end)
end

MinesBypasses:AddToggle('DeleteFigure', {
    Text = '删除Figure',
    Default = false,
    Tooltip = '为所有玩家删除Figure。',

    Disabled = not (ExecutorSupport["isnetworkowner"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

MinesBypasses:AddToggle("TheMinesAnticheatBypass", {
    Text = "反作弊绕过",
    Default = false,
    Tooltip = '通过爬上梯子绕过反作弊系统。',
})

MinesVisuals:AddToggle("ShowMinecartNodes",{
    Text = "显示Seek路径",
    Default = false,
    Tooltip = '为矿井Seek追逐创建可视化路径。',

}):AddColorPicker('MinecartNodeColor', {
    Default = Color3.fromRGB(0,255,0), -- 亮绿色
    Title = '节点颜色', -- 可选。允许自定义颜色选择器标题
    Transparency = 0, -- 可选。启用透明度更改（留空为nil则禁用）

    Callback = function(Value)
        for i,inst in pairs(workspace.Terrain:GetChildren()) do
            if inst:IsA("Beam") and inst:GetAttribute("SeekNode") ~= nil then
                inst.Color  = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Value),
                    ColorSequenceKeypoint.new(1, Value)
                })
            end
        end
    end
})

MinesVisuals:AddDivider()

MinesVisuals:AddToggle('NoFiredampEffects', {
    Text = '禁用瓦斯效果',
    Default = false,
    Tooltip = '移除瓦斯屏幕效果',
					Callback = function(Value)
						for i,Room in pairs(workspace:WaitForChild("CurrentRooms"):GetChildren()) do
							if Room:GetAttribute("OriginalFiredamp") == nil then
								Room:SetAttribute("OriginalFiredamp", Room:GetAttribute("Firedamp") == true and true or false)
							end

							Room:SetAttribute("Firedamp", (Room:GetAttribute("OriginalFiredamp") == true and Value == false and true or false))
						end

						local PreviousCurrentRoom = Player:GetAttribute("CurrentRoom")

						Player:SetAttribute("CurrentRoom", (tonumber(PreviousCurrentRoom) + 1))
						task.wait(0.1)
						Player:SetAttribute("CurrentRoom", PreviousCurrentRoom)
					end
				})





				Toggles.TheMinesAnticheatBypass:OnChanged(function(value)


					MinesBypass = value
					if value then



						Notify({
							Title = "Anticheat bypass",
							Description = "Climb on a ladder to bypass the anticheat.",


						})
						Sound()
					else
						if MinesAnticheatBypassActive == true then
							RemotesFolder:WaitForChild("ClimbLadder"):FireServer()
							MinesAnticheatBypassActive = false
						end

						-- Ladder ESP


					end
				end)
				Toggles.NotifyAnchorCode:OnChanged(function(Value)
					if Value then
						NotifyAnchorCode()
					end
				end)

				Toggles.SolveAnchors:OnChanged(function(Value)
					if Value then
						SolveCurrentAnchor()
					end
				end)



				Toggles.ShowMinecartNodes:OnChanged(function(value)




					for i,inst in pairs(workspace.Terrain:GetChildren()) do
						if inst:IsA("Beam") and inst:GetAttribute("SeekNode") ~= nil then
							inst.Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, (Toggles.ShowMinecartNodes.Value and 0 or 1)),
								NumberSequenceKeypoint.new(1, (Toggles.ShowMinecartNodes.Value and 0 or 1)),
							})
						end
					end





				end)






				Toggles.AntiGloomEgg:OnChanged(function(value)
					for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
						for _, gloomPile in pairs(room:GetChildren()) do
							if gloomPile.Name == "GloomPile" then
								for _, gloomEgg in pairs(gloomPile:GetDescendants()) do
									if gloomEgg.Name == "Egg" then
										gloomEgg.CanTouch = not value
									end
								end
							end
						end
					end
				end)





			Toggles.AntiSeekObstructions:OnChanged(function(value)
	if value then
		for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
			if room:FindFirstChild("Parts") then

				for _, bridge in pairs(room.Parts:GetChildren()) do
					if bridge.Name == "Bridge" then
						for _, barrier in pairs(bridge:GetChildren()) do
							if (barrier.Name == "PlayerBarrier" and barrier.Size.Y == 2.75 and (barrier.Rotation.X == 0 or barrier.Rotation.X == 180)) then

								local clone = barrier:Clone()
								clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
								clone.Color = Color3.new(0, 0.666667, 1)
								clone.Name = ESPLibrary:GenerateRandomString()
								clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
								clone.Transparency = 0.5
								clone.Parent = bridge
								clone.CanCollide = true
								table.insert(Bridges, clone)

							end

						end
					end
				end
				end
						end
					else
						for _, bridge in pairs(Bridges) do
							bridge:Destroy()
						end
					end
				end)
				local Pipes = {}


				Toggles.AntiGiggle:OnChanged(function(value)
					for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
						for _, giggle in pairs(room:GetChildren()) do
							if giggle.Name == "GiggleCeiling" then
								giggle:WaitForChild("Hitbox", 5).CanTouch = not value
							end
						end
					end
				end)
				Toggles.AntiSeekFlood:OnChanged(function(value)
					local room = workspace.CurrentRooms:FindFirstChild("100")

					if room and room:FindFirstChild("_DamHandler") then
						local seekFlood = room._DamHandler:FindFirstChild("SeekFloodline")
						if seekFlood then
							seekFlood.CanCollide = value
						end
					end
				end)




				MinesRoomAddedConnection = game.Workspace.CurrentRooms.ChildAdded:Connect(function(child)


					if Toggles.NoFiredampEffects then


						child:SetAttribute("OriginalFiredamp", child:GetAttribute("Firedamp") == true and true or false)



						child:SetAttribute("Firedamp", (child:GetAttribute("OriginalFiredamp") == true and Toggles.NoFiredampEffects.Value == false and true or false))

					end





					if child:GetAttribute("RawName") and string.find(child:GetAttribute("RawName"), "Halt") or child:GetAttribute("Shade") ~= nil then

						game.Workspace.CurrentRooms.ChildAdded:Wait()
					
						game.Workspace.CurrentRooms.ChildAdded:Wait()
						if MinesAnticheatBypassActive == true then
Notify({Title = "反作弊绕过", Description = "反作弊绕过已失效。", Reason = "爬上梯子来修复它。"})
Sound()
MinesAnticheatBypassActive = false
end
end

if Floor == "Mines" then
    game.Workspace.CurrentRooms.ChildAdded:Wait()

    Functions.Pathfind(child, true)

    task.wait(0.15)

    local function IsInFront(Part1, Part2)
        local partA = Part1
        local partB = Part2
        local direction = partB.Position - partA.Position
        local rightDistance = partA.CFrame.RightVector:Dot(direction)
        if rightDistance > 0.5 then
            return false
        elseif rightDistance < 0 - 0.5 then
            return false
        end
        return true
    end

    if child:FindFirstChild("RunnerNodes") and workspace.CurrentCamera:FindFirstChild("MinecartRig") then
        local function IsBehind(CharHRP,Part)
            local point1,point2 = (CharHRP.CFrame + CharHRP.CFrame.LookVector),(CharHRP.CFrame + CharHRP.CFrame.LookVector*-1)
            local mag1,mag2 = (point1.Position-Part.Position).Magnitude,(point2.Position-Part.Position).Magnitude
            return not (mag1 <= mag2)
        end

        local function GetDirection(Part1, Part2)
            local partA = Part1
            local partB = Part2
            local direction = partB.Position - partA.Position
            local rightDistance = partA.CFrame.RightVector:Dot(direction)
            if rightDistance > 0.5 then
                return "Right"
            elseif rightDistance < 0 - 0.5 then
                return "Left"
            end
            return "Straight"
        end

        for i,NewNode in pairs(workspace.CurrentRooms[CurrentRoom].RunnerNodes:GetChildren()) do
            local NodeID = NewNode.Name:split("MinecartNode")[2]
            if workspace.CurrentRooms[CurrentRoom].RunnerNodes:FindFirstChild("MinecartNode" .. tonumber(NodeID) + 10) and workspace.CurrentRooms[CurrentRoom].RunnerNodes:FindFirstChild("MinecartNode" .. tonumber(NodeID) + 10):GetAttribute("DeathType") ~= nil then
                NewNode:SetAttribute("DistanceBlacklist", true)
            elseif workspace.CurrentRooms[CurrentRoom].RunnerNodes:FindFirstChild("MinecartNode" .. tonumber(NodeID) + 4) and workspace.CurrentRooms[CurrentRoom].RunnerNodes:FindFirstChild("MinecartNode" .. tonumber(NodeID) + 4):GetAttribute("DeathType") ~= nil then
                NewNode:SetAttribute("DistanceBlacklist", true)
            elseif workspace.CurrentRooms[CurrentRoom].RunnerNodes:FindFirstChild("MinecartNode" .. tonumber(NodeID) + 7) and workspace.CurrentRooms[CurrentRoom].RunnerNodes:FindFirstChild("MinecartNode" .. tonumber(NodeID) + 7):GetAttribute("DeathType") ~= nil then
                NewNode:SetAttribute("DistanceBlacklist", true)
            end
        end

        local function GetClosestNode(Node)
            local ClosestNodeDistance = math.huge
            local ClosestNode = nil
            for i,NewNode in pairs(workspace.CurrentRooms[CurrentRoom].RunnerNodes:GetChildren()) do
                local NodeID = NewNode.Name:split("MinecartNode")[2]
                local NodeID2 = Node.Name:split("MinecartNode")[2]
                if NewNode ~= Node and tonumber(NodeID) > tonumber(NodeID2) then
                    local Distance = (Node.Position - NewNode.Position).Magnitude
                    if Distance < ClosestNodeDistance and NewNode:GetAttribute("DistanceBlacklist") ~= true then
                        ClosestNodeDistance = Distance
                        ClosestNode = NewNode
                    end
                end
            end
            return ClosestNode
        end

        for i,Node in pairs(workspace.CurrentRooms[CurrentRoom].RunnerNodes:GetChildren()) do
            if Node:GetAttribute("ForceConnect") then
                local NextNode = GetClosestNode(Node)
                if NextNode then
                    Node:SetAttribute("Turn", GetDirection(Node, NextNode))
                    table.insert(TurnNodes, Node)
                end
            end
        end
    end
end

if child.Name == "49" then
    if ExecutorSupport["require"] == true then
        PlayerModule.GetMoveVector = OldFunction
    end
end

end)

end



BypassEntity:AddToggle('AntiSeekObstructions', {
    Text = '禁用Seek障碍物',
    Default = false,
    Tooltip = "防止Seek的手臂和掉落吊灯\n[一楼]伤害你",

    Callback = function(Value)
        AntiSeekObstructions = Value
        for i,e in pairs(ObjectsTable.SeekObstructions) do
            if e.Name == "Seek_Arm" or e.Name == "ChandelierObstruction" then
                for i,a in pairs(e:GetDescendants()) do
                    if a:IsA("BasePart") then
                        a.CanTouch = false
                    end
                end
            end
        end
    end
})

BypassEntity:AddToggle('AntiSnare', {
    Text = '禁用Snare',
    Default = false,
    Tooltip = '允许你踩在Snares上而不会触发它们',

    Callback = function(Value)
        AntiSnare = Value
        for i,e in pairs(ObjectsTable.Snares) do
            if e:FindFirstChild("Hitbox") then
                e:FindFirstChild("Hitbox").CanTouch = not Value
            end
        end
    end
})

BypassEntity:AddToggle('AntiDupe', {
    Text = '禁用Dupe',
    Default = false,
    Tooltip = '防止你打开假门。',

    Callback = function(Value)
        AntiDupe = Value
        for i,e in pairs(ObjectsTable.Dupe) do
            local a = e.Parent
            if a then
                if a.Name == "DoorFake" or a.Name == "FakeDoor" then
                    DisableDupe(a, Value)
                end
            end
        end
    end
})

BypassEntity:AddToggle('RemoveScreech', {
    Text = '禁用Screech',
    Default = false,
    Tooltip = '防止Screech生成',

    Callback = function(Value)
        AntiScreech = Value
        if Value then
            Screech.Name = "Screech_"
            for i, Child in pairs(workspace.CurrentCamera:GetChildren()) do
                if Child.Name == "GlitchScreech" or Child.Name == "Screech" then
                    Child:Destroy()
                end
            end
        else
            Screech.Name = "Screech"
        end
    end
})
BypassEntity:AddToggle('DisableHalt', {
    Text = '禁用Halt',
    Default = false,
    Tooltip = '防止Halt生成。',

    Callback = function(Value)
        if Value then
            Halt.Name = "Shade_"
        else
            Halt.Name = "Shade"
        end
    end
})

BypassEntity:AddToggle('RemoveA90', {
    Text = '禁用A-90',
    Default = false,
    Tooltip = '防止A-90生成。',

    Callback = function(Value)
        if A90 then
            if Value == true then
                A90.Name = "A90_"
            else
                A90.Name = "A90"
            end
        end
    end
})

BypassEntity:AddDivider()

BypassEntity:AddToggle('AntiEyes', {
    Text = '免疫Eyes伤害',
    Default = false,
    Tooltip = '允许你直视Eyes而不受伤害。',

    Callback = function(Value)
        AntiEyes = Value
        if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then
            if NewHotel == true then
                RemotesFolder.MotorReplication:FireServer(-750)
            else
                RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)
            end
        end
    end
})
BypassEntity:AddToggle('AntiScreech', {
    Text = '免疫Screech伤害',
    Default = false,
    Tooltip = '防止Screech伤害你。',
    Callback = function(Value)
        if Value == true then
            ScreechEvent.Parent = ReplicatedStorage
            FakeScreechEvent.Parent = RemotesFolder
        else
            ScreechEvent.Parent = RemotesFolder
            FakeScreechEvent.Parent = ReplicatedStorage
        end
    end
})

BypassEntity:AddToggle('AntiHalt', {
    Text = '免疫Halt伤害',
    Default = false,
    Tooltip = '防止Halt伤害你。',

    Callback = function(Value)
        if Value == true then
            ShadeEvent.Parent = ReplicatedStorage
            FakeShadeEvent.Parent = RemotesFolder
        else
            ShadeEvent.Parent = RemotesFolder
            FakeShadeEvent.Parent = ReplicatedStorage
        end
    end
})

BypassEntity:AddToggle('AntiA90', {
    Text = '免疫A-90伤害',
    Default = false,
    Tooltip = '防止A-90对你造成伤害。',

    Callback = function(Value)
        if Value == true then
            A90Event.Parent = ReplicatedStorage
            FakeA90Event.Parent = RemotesFolder
        else
            A90Event.Parent = RemotesFolder
            FakeA90Event.Parent = ReplicatedStorage
        end
    end
})

local FogEnd = game:GetService("Lighting").FogEnd
local Jumpscares = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares") or Instance.new("Folder")
local Jumpscare_Rush = Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("Jumpscare_Rush") or Instance.new("Frame")
local Jumpscare_Ambush = Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("Jumpscare_Ambush") or Instance.new("Frame")
local Jumpscare_Shade = game:GetService("Players").LocalPlayer.PlayerGui.MainUI:FindFirstChild("Jumpscare_Shade", true) or Instance.new("Frame")
local Jumpscare_Dread = game:GetService("Players").LocalPlayer.PlayerGui.MainUI:FindFirstChild("Jumpscare_Dread", true) or Instance.new("Frame")

Jumpscare_Rush_Sound = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Rush") or Instance.new("Sound")
Jumpscare_Rush_Sound2 = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Rush2") or Instance.new("Sound")
Jumpscare_Ambush_Sound = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Ambush") or Instance.new("Sound")
Jumpscare_Ambush_Sound2 = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Ambush2") or Instance.new("Sound")
Jumpscare_Seek_Sound = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Seek") or Instance.new("Sound")

VisualsRemove:AddToggle('RemoveJumpscares', {
    Text = '无死亡跳杀',
    Default = false,
    Tooltip = "禁用Rush和Ambush等实体的跳杀效果。",

    Callback = function(Value)
        Jumpscares.Name = (Value and "Jumpscares_" or "Jumpscares")
        Jumpscare_Rush.Name = (Value and "Jumpscare_Rush_" or "Jumpscare_Rush")
        Jumpscare_Ambush.Name = (Value and "Jumpscare_Ambush_" or "Jumpscare_Ambush")
        Jumpscare_Shade.Visible = (workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetAttribute("Shade") == true or workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetAttribute("RawName") and workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetAttribute("RawName") == 'HaltHallway' and true or false)
        Jumpscare_Rush_Sound.SoundId = (Value and "rbxassetid://0" or "rbxassetid://10483790459")
        Jumpscare_Rush_Sound2.SoundId = (Value and "rbxassetid://0" or "rbxassetid://10483837590")
        Jumpscare_Ambush_Sound.SoundId = (Value and "rbxassetid://0" or "rbxassetid://88807654977")
        Jumpscare_Ambush_Sound2.SoundId = (Value and "rbxassetid://0" or "rbxassetid://9045199073")
        Jumpscare_Seek_Sound.SoundId = (Value and "rbxassetid://0" or "rbxassetid://9145202614")
    end
})
VisualsRemove:AddToggle('NoHidingVegnette', {
    Text = '无藏匿效果',
    Default = false,
    Tooltip = '移除藏匿屏幕效果',

    Callback = function(Value)
        RemoveHideVignette = Value
        if Value == false then
            if Player.PlayerGui:FindFirstChild("MainUI") and Character:GetAttribute("Hiding") == true then
                if Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("HideVignette") then
                    Player.PlayerGui.MainUI.HideVignette.Visible = true
                else
                    if Character:GetAttribute("Hiding") == true then
                        Player.PlayerGui.MainUI.MainFrame.HideVignette.Visible = true
                    end
                end
            end
        end
    end
})

VisualsRemove:AddToggle('NoFog', {
    Text = '无雾气效果',
    Default = false,
    Tooltip = "移除所有雾气以提高可见度",

    Callback = function(Value)
        game:GetService("Lighting").FogEnd = 100000 or FogEnd
        for i,Fog in pairs(FogInstances) do
            if Fog then
                Fog.Parent = (Value and ReplicatedStorage or game:GetService("Lighting"))
            end
        end
    end
})

VisualsRemove:AddDivider()

VisualsRemove:AddToggle('DisableSeekEffects', {
    Text = '无Seek效果',
    Default = false,
    Tooltip = '移除Seek追逐时的屏幕效果。',
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})
VisualsRemove:AddToggle('NoCameraShake',{
    Default = false,
    Tooltip = '防止镜头震动',
    Text = "无镜头震动",
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})
VisualsRemove:AddToggle('NoCameraBobbing',{
    Default = false,
    Tooltip = '防止移动时镜头晃动',
    Text = "无镜头晃动",
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

VisualsRemove:AddToggle('DisableTimothyJumpscare', {
    Text = '无Timothy跳杀',
    Default = false,
    Tooltip = '移除Timothy跳向你的跳杀效果。',
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

VisualsRemove:AddToggle('DisableGlitchJumpscare', {
    Text = '无Glitch跳杀',
    Default = false,
    Tooltip = '移除Glitch传送你时的跳杀效果。',
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

VisualsRemove:AddToggle('DisableVoidJumpscare', {
    Text = '无Void跳杀',
    Default = false,
    Tooltip = '移除Void传送你时的跳杀效果。',
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

if ExecutorSupport["require"] == true then
    local GlitchFunction = require(Glitch).stuff
    local SeekFunction = require(SeekModule).tease
    local VoidFunction
    if OldHotel == false then
        VoidFunction = require(Void).stuff
    end

    Toggles.DisableGlitchJumpscare:OnChanged(function(Value)
        require(Glitch).stuff = (Value and function() end or GlitchFunction)
    end)

    Toggles.DisableSeekEffects:OnChanged(function(Value)
        require(Glitch).stuff = (Value and function() end or SeekFunction)
    end)

    if OldHotel == false then
        Toggles.DisableVoidJumpscare:OnChanged(function(Value)
            require(Void).stuff = (Value and function() end or VoidFunction)
        end)
    end
end

task.wait()

Toggles.DisableTimothyJumpscare:OnChanged(function(Value)
    Timothy.Name = (Value and "SpiderJumpscare_" or "SpiderJumpscare")
end)

VisualsRightTab:AddDropdown('NotifyMonsters', {
    Values = {"Rush","Ambush","Blitz","Eyes","Lookman","Jeff The Killer","A-60","A-120","Gloombat Swarm","Halt","Sally","Monument","Groundskeeper", "Glitched Rush", "Glitched Ambush", "Custom Rush"},
    Default = 0,
    Multi = true,
    Compact = true,

    Text = '实体列表',
    Tooltip = '选择哪些实体生成时通知你',
})

VisualsRightTab:AddToggle('NotifyEntities', {
    Default = true,
    Text = '通知实体',
    Tooltip = '实体通知的总开关。'
})

VisualsRightTab:AddDivider()

VisualsRightTab:AddToggle('ChatNotify', {
    Default = false,
    Text = "聊天通知",
    Tooltip = '在聊天中发送实体警告消息，让其他人也能看到。'
})

VisualsRightTab:AddInput("ChatNotifyMessage", {
    Default = "已生成！",
    Numeric = false,
    Finished = true,

    Text = "通知消息",
    Tooltip = '实体生成时发送的消息',

    Placeholder = '在此输入消息',

    Callback = function(Value)
        ChatNotifyMessage = " " .. Value
        local message2 = game:GetService("Chat"):FilterStringForBroadcast(Value, Player)
        if string.find(message2,"#") then
            Notify({Title = "警告", Description = "输入的消息已被审查。", Reason = "它不会显示给其他人。"})
            Sound()
        end
    end
})

VisualsRightTab:AddDivider()

VisualsRightTab:AddToggle('PlayNotificationSound',{
    Default = true,
    Text = "播放声音",
    Tooltip = "在通知时播放声音以使其更明显",
    Callback = function(Value)
        notif = Value
    end,
})

VisualsRightTab:AddSlider('NotificationSoundVolume', {
    Text = '声音音量',
    Default = 3,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = true,
})

VisualsRightTab:AddDropdown('NotificationStyle', {
    Values = {'默认','Doors'},
    Default = 1,
    Multi = false,

    Text = '通知样式',
    Tooltip = '选择通知的显示样式',

    Callback = function(Value)
        NotifyType = Value
    end
})

VisualsRightTab:AddDivider()

VisualsRightTab:AddButton({
    Text = "发送通知测试",
    Tooltip = '发送一条通知以测试你的设置',
    DoubleClick = false,
    Func = function()
        Notify({Title = "通知测试", Description = "这就是通知的样子。"})
        Sound()
    end,
})

LeftGroupBox:AddSlider('WS', {
    Text = '速度提升',
    Default = 0,
    Min = 0,
    Max = 6,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        SpeedBoost = Value
    end
})

LeftGroupBox:AddToggle('SpeedBoostEnabled', {
    Text = '启用速度提升',
    Default = false,
    Tooltip = '将你的走路速度更改为指定数值。',

    Callback = function(Value)
        SpeedBoostEnabled = Value
        if not Value then
            local CrouchNerf = 0
            if Collision and Collision.CollisionGroup == "PlayerCrouching" then
                CrouchNerf = (LiveModifiers:FindFirstChild("PlayerCrouchSlow") and 8 or LiveModifiers:FindFirstChild("PlayerSlow") and 8 or 5)
            else
                CrouchNerf = 0
            end
            local num = 15 + (Character:GetAttribute("SpeedBoost") + Character:GetAttribute("SpeedBoostBehind") + Character:GetAttribute("SpeedBoostExtra") + Character:GetAttribute("SpeedBoostScript") - CrouchNerf)
            Humanoid.WalkSpeed = num
        else
            if Character ~= nil then
                local CrouchNerf = 0
                if Collision and Collision.CollisionGroup == "PlayerCrouching" then
                    CrouchNerf = (LiveModifiers:FindFirstChild("PlayerCrouchSlow") and 8 or LiveModifiers:FindFirstChild("PlayerSlow") and 8 or 5)
                else
                    CrouchNerf = 0
                end
                RunService.Heartbeat:Wait()
                if not CollisionClone or Character:GetAttribute("SpeedBoostExtra") == nil then return end
                local num = 15 + (Character:GetAttribute("SpeedBoost") + Character:GetAttribute("SpeedBoostBehind") + Character:GetAttribute("SpeedBoostExtra") + Character:GetAttribute("SpeedBoostScript") + SpeedBoost - CrouchNerf)
                Humanoid.WalkSpeed = num
            end
        end
    end
})

LeftGroupBox:AddSlider('LadderSpeed', {
    Text = '爬梯速度',
    Default = 0,
    Min = 0,
    Max = 75,
    Rounding = 0,
    Compact = true,
})

LeftGroupBox:AddToggle('LadderSpeedEnabled', {
    Text = '启用爬梯速度',
    Default = false,
    Tooltip = '将你的爬梯速度更改为指定数值。',
})

LeftGroupBox:AddDivider()
LeftGroupBox:AddToggle('NoClosetDelay', {
    Text = "快速出柜",
    Tooltip = '移除进入柜子后到可以出来之间的延迟。',
    Default = false,
})
LeftGroupBox:AddToggle('NoAccell', {
    Text = '无加速度',
    Default = false,
    Tooltip = '防止角色因高移动速度而滑动。',

    Callback = function(Value)
        NA = Value
        for i,part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if Value == true then
                    part.CustomPhysicalProperties = CustomPhysicalProperties
                else
                    part.CustomPhysicalProperties = PartProperties[part]
                end
            end
        end
    end
})

LeftGroupBox:AddToggle('Noclip', {
    Text = '穿墙模式',
    Default = false,
    Tooltip = '禁用碰撞检测，允许你穿过物体行走',

    Callback = function(Value)
        togglenoclip(Value)
    end

}):AddKeyPicker('NoclipKeybind', {
    Default = 'N',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = '穿墙模式',
    NoUI = false,
    Callback = function(Value)
    end,
    ChangedCallback = function(New)
    end
})

LeftGroupBox:AddDivider()

LeftGroupBox:AddToggle('EnableJump', {
    Text = '启用跳跃',
    Default = false,
    Tooltip = '允许你的角色随时跳跃。',
    Callback = function(Value)
        if Value then
            Character:SetAttribute("CanJump",true)
        else
            if Floor ~= "Party" and IsSeekChase() == false then
                Character:SetAttribute("CanJump",false)
            end
        end
    end
})

LeftGroupBox:AddToggle('InfiniteJumps', {
    Text = '无限跳跃',
    Default = false,
    Tooltip = '允许你的角色在空中跳跃。',
})

LeftGroupBox:AddToggle('Fly', {
    Text = '飞行',
    Default = false,
    Tooltip = '允许你的角色飞行。',

    Callback = function(Value)
        flytoggle = Value
        fly.enabled = Value
        if Value then
            fly.flyBody.Parent = Collision
        else
            fly.flyBody.Parent = nil
        end
    end
}):AddKeyPicker('FlyKeybind', {
    Default = 'F',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = '飞行',
    NoUI = false,
    Callback = function(Value)
        flytoggle = Value
        if Value == true then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        else
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end
    end,
    ChangedCallback = function(New)
    end
})

LeftGroupBox:AddSlider('FlySpeed', {
    Text = '飞行速度',
    Default = 15,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        flyspeed = Value
    end
})

LeftGroupBox9:AddToggle('ToggleAmbience', {
    Text = '环境光',
    Default = false,
    Tooltip = '启用环境光颜色为所选颜色',
    Callback = function(Value)
        fb = Value
    end,
}):AddColorPicker('Ambience',{
    Default = Color3.fromRGB(255,255,255),
    Title = "环境光",
    Transparency = 0,
    Callback = function(Value)
        Ambience = Value
    end,
})

LeftGroupBox9:AddSlider('FOV', {
    Text = '视野',
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
        fov = Value
    end,
})

LeftGroupBox9:AddDivider()

LeftGroupBox2:AddToggle('Godmode', {
    Default = false,
    Text = '位置欺骗',
    Tooltip = "让你免疫Rush等实体。",
    Disabled = not (Floor ~= "Party"),
    DisabledTooltip = "此功能在本楼层不可用。"
})

LeftGroupBox2:AddToggle('SpeedBypass', {
    Text = '速度绕过',
    Default = false,
    Tooltip = '尽可能规避速度反作弊系统。',
    Callback = function(Value)
        SpeedBypassEnabled = Value
        if Value == true then
            Options.WS:SetMax(45)
            Options.FlySpeed:SetMax(75)
        else
            Options.WS:SetMax(6)
            Options.FlySpeed:SetMax(20)
            if SpeedBoost > 6 then
                Options.WS:SetValue(6)
            end
            if flyspeed > 20 then
                Options.FlySpeed:SetValue(20)
            end
        end
    end,
})

LeftGroupBox2:AddToggle('AntiFH', {
    Text = '蹲下欺骗',
    Default = false,
    Tooltip = '让游戏以为你一直在蹲下。',
    Disabled = not RemotesFolder:FindFirstChild("Crouch"),
    Callback = function(Value)
        AntiFH = Value
        RemotesFolder.Crouch:FireServer(godmode == true and true or AntiFH == true and true or CrouchingValue.Value == true and true or false)
    end
})

Automation:AddToggle('AA', {
    Text = '自动交互',
    Default = false,
    Tooltip = '自动触发交互提示。',

    Callback = function(Value)
        AA = Value
    end
}):AddKeyPicker('AutoInteractKeybind', {
    Default = 'R',
    SyncToggleState = true,
    Mode = (Library.IsMobile and 'Toggle' or 'Hold'),
    Text = '自动交互',
    NoUI = false,
    Callback = function(Value)
    end,
    ChangedCallback = function(New)
    end
})
Automation:AddDropdown("AutoInteractIgnoreList",
    { Values = {'Jeff物品', '矿车', "门", "画作" ,'上锁物品', '掉落物品', '战利品物品', '梯子', '金币'},
        Default = 1,
        Multi = true,
        Text = "忽略列表",
    })

Automation:AddSlider('AutoInteractDelay', {
    Text = '交互延迟',
    Default = 0,
    Min = 0,
    Max = 0.25,
    Rounding = 2,
    Compact = true,
})

LeftGroupBox2:AddDivider()
LeftGroupBox2:AddToggle('ACM', {
    Text = '反作弊操控',
    Default = false,
    Tooltip = '尝试绕过穿墙反作弊系统。',
    Disabled = not NewHotel,
    DisabledTooltip = "此功能在本楼层不可用。",
    Callback = function(Value)
    end

}):AddKeyPicker('AnticheatManipulation', {
    Default = 'V',
    SyncToggleState = true,
    Mode = (Library.IsMobile and 'Toggle' or 'Hold'),
    Text = '反作弊操控',
    NoUI = false,
    Callback = function(Value)
    end,
    ChangedCallback = function(New)
    end
})

LeftGroupBox2:AddDropdown("AnticheatManipulationMethod",
    { Values = {'Pivot', 'Velocity'},
        Default = 1,
        Multi = false,
        Text = "操控方式",
        Disabled = not NewHotel,
        DisabledTooltip = "此功能在本楼层不可用。"
    })

LeftGroupBox2:AddDivider()
LeftGroupBox2:AddToggle('InfiniteItems', {
    Default = false,
    Text = '无限物品',
    Tooltip = "允许你使用选定物品而不消耗使用次数。",
    Disabled = (not ExecutorSupport["fireproximityprompt"] and true or not RemotesFolder:FindFirstChild("DropItem") and true or false),
    DisabledTooltip = "你的执行器不支持此功能，或本楼层不可用。"
})
LeftGroupBox2:AddDropdown("InfiniteItemsSelection",
    { Values = {'开锁器', '万能钥匙', '剪刀', '多功能工具'},
        Default = 0,
        Multi = true,
        Text = "物品列表",
        Disabled = (not ExecutorSupport["fireproximityprompt"] and true or not RemotesFolder:FindFirstChild("DropItem") and true or false),
        DisabledTooltip = "你的执行器不支持此功能，或本楼层不可用。"
    })

LeftGroupBox2:AddDivider()

LeftGroupBox2:AddToggle('SilentAim', {
    Text = "物品静默瞄准",
    Tooltip = '为投射物提供瞄准辅助。',
    Default = false,
    Disabled = not (Drawing and Drawing.new and ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

LeftGroupBox2:AddSlider('circleSize', {
    Text = '静默瞄准范围',
    Default = 150,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Compact = true,
    Disabled = not (Drawing and Drawing.new and ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

LeftGroupBox2:AddToggle('SilentAimShowRange', {
    Text = "显示范围",
    Tooltip = '显示你的瞄准范围有多大。',
    Default = false,
    Disabled = not (Drawing and Drawing.new and ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"]),
    DisabledTooltip = "你的执行器不支持此功能。"
})

				if Drawing and Drawing.new and ExecutorSupport["hookmetamethod"] and ExecutorSupport["newcclosure"] and ExecutorSupport["getnamecallmethod"] then

				local circle = Drawing.new("Circle")
circle.Visible = true
circle.Radius = 50
circle.Position = Vector2.new(300, 300)
circle.Color = Color3.fromRGB(255, 255, 255)
circle.Thickness = 1
circle.Filled = false



				local SilentAimConnection = RunService.RenderStepped:Connect(function()
					circle.Visible = (Library.Toggled == false and Toggles.SilentAimShowRange.Value and Toggles.SilentAim.Value and true or false)
					circle.Radius = Options.circleSize.Value
					circle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)

					


				local Target = GetSilentAimTarget()


			
				if Target then
					SilentAimTarget = Target
				else
					
					
				end
				end)

				table.insert(RenderConnections, SilentAimConnection)

			end
	









Toggles.Godmode:AddKeyPicker('GodmodeKeybind', {
    Default = 'B',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = '位置欺骗',
    NoUI = false,
    Callback = function(Value)
    end,
    ChangedCallback = function(New)
    end
})

OldPhysics = HumanoidRootPart.CustomPhysicalProperties

local NAC = Player.CharacterAdded:Connect(function(NewCharacter)
    task.wait(0.5)
    if Toggles.NoAccell.Value then
        for i,part in pairs(NewCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = CustomPhysicalProperties
            end
        end
    end
end)

local ThirdPersonParts = {}

local NewHead = Character:WaitForChild("Head"):Clone()
NewHead.Parent = Character
NewHead.LocalTransparencyModifier = 0
NewHead.Transparency = (thirdp == true and 0 or 1)
NewHead.Name = "FakeHead"
if NewHead:FindFirstChild("face", true) then
    NewHead:FindFirstChild("face", true):Destroy()
end
table.insert(ThirdPersonParts, NewHead)

for i,NewAccessory in pairs(Character:GetChildren()) do
    if NewAccessory:IsA("Accessory") and NewAccessory:FindFirstChild("Handle") then
        local Accessory = NewAccessory:Clone()
        Accessory.Handle.LocalTransparencyModifier = 0
        Accessory.Handle.Transparency = (thirdp == true and 0 or 1)
        Accessory.Name = Accessory.Name .. "_Fake"
        table.insert(ThirdPersonParts, Accessory.Handle)
        Accessory.Handle.Parent = Character
    end
end
LeftGroupBox9:AddToggle('Toggle50', {
    Text = '第三人称',
    Default = false,
    Tooltip = '将镜头拉远以便看到你的角色',

    Callback = function(Value)
        thirdp = Value
    end
}):AddKeyPicker('ThirdPersonKeybind', {
    Default = 'T',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = '第三人称',
    NoUI = false,
    Callback = function(Value)
        thirdp = Value
    end,
    ChangedCallback = function(New)
    end
})
LeftGroupBox9:AddSlider('TPX', {
    Text = 'X轴偏移',
    Default = 1.5,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        ThirdPersonX = Value
    end
})
LeftGroupBox9:AddSlider('TPY', {
    Text = 'Y轴偏移',
    Default = 1,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        ThirdPersonY = Value
    end
})
LeftGroupBox9:AddSlider('TPZ', {
    Text = 'Z轴偏移',
    Default = 5,
    Min = -10,
    Max = 10,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        ThirdPersonZ = Value
    end
})

LeftGroupBox9:AddDivider()

LeftGroupBox9:AddToggle('ToolOffset', {
    Text = "视角模型偏移",
    Default = false,
    Tooltip = "手持工具时移动视角模型位置。",
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

LeftGroupBox9:AddSlider('ToolOffsetX', {
    Text = 'X轴偏移',
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

LeftGroupBox9:AddSlider('ToolOffsetY', {
    Text = 'Y轴偏移',
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

LeftGroupBox9:AddSlider('ToolOffsetZ', {
    Text = 'Z轴偏移',
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Disabled = not ExecutorSupport["require"],
    DisabledTooltip = "你的执行器不支持此功能。"
})

WorldTab:AddToggle('DoorReach', {
    Text = '远距开门',
    Default = false,
    Tooltip = '从更远的距离开门',

    Callback = function(Value)
        DoorReach = Value
    end
})
WorldTab:AddSlider("DoorReachMultiplier",{
    Text = "距离倍数",
    Default = 1,
    Min = 1,
    Max = 3,
    Rounding = 1,
    Compact = true
})

if Floor ~= "Retro" then
    WorldTab:AddDivider()
    WorldTab:AddToggle('TransparentCloset', {
        Text = '透明藏匿点',
        Default = false,
        Tooltip = '使当前藏匿点变为透明',

        Callback = function(Value)
            TransparentCloset = Value
        end
    })
    WorldTab:AddSlider("HidingTransparency",{
        Text = "透明度",
        Default = 0.5,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Compact = true,
        Callback = function(Value)
            TransparentClosetNumber = Value
        end,
    })

    Toggles.TransparentCloset:OnChanged(function(Value)
        for i,inst in pairs(ObjectsTable.Closets) do
            if inst:FindFirstChild("HiddenPlayer") then
                local parts = {}
                local parts2 = inst:GetDescendants()
                if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
                    parts2 = inst.Parent:GetDescendants()
                end
                for i,part in pairs(parts2) do
                    if part:IsA("BasePart") then
                        if part:GetAttribute("Transparency") ~= nil then
                            table.insert(parts,part)
                        end
                    end
                end
                if inst:FindFirstChild("HiddenPlayer") then
                    if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
                        for i,e in pairs(parts) do
                            TweenService:Create(e, TweenInfo.new(0.75, Enum.EasingStyle.Quad), {Transparency = TransparentClosetNumber}):Play()
                        end
                    else
                        for i,e in pairs(parts) do
                            TweenService:Create(e, TweenInfo.new(0.75, Enum.EasingStyle.Quad), {Transparency = e:GetAttribute("Transparency")}):Play()
                        end
                    end
                end
            end
        end
    end)

    Options.HidingTransparency:OnChanged(function(Value)
        for i,inst in pairs(ObjectsTable.Closets) do
            if inst:FindFirstChild("HiddenPlayer") then
                local parts = {}
                local parts2 = inst:GetDescendants()
                if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
                    parts2 = inst.Parent:GetDescendants()
                end
                for i,part in pairs(parts2) do
                    if part:IsA("BasePart") then
                        if part:GetAttribute("Transparency") ~= nil then
                            table.insert(parts,part)
                        end
                    end
                end
                if inst:FindFirstChild("HiddenPlayer") then
                    if inst.HiddenPlayer.Value == Character then
                        for i,e in pairs(parts) do
                            TweenService:Create(e, TweenInfo.new(0.75, Enum.EasingStyle.Quad), {Transparency = TransparentClosetNumber}):Play()
                        end
                    end
                end
            end
        end
    end)
end

ESP:AddToggle('EssentialsESP', {
    Text = '目标物品',
    Default = false,
    Tooltip = '高亮所有生成的关键物品（如钥匙）',
Callback = function(Value)
    keys = Value
    task.wait()
    if Value == true then
        for i,inst in pairs(ObjectsTable.Keys) do
            if inst.Name == "KeyObtain" then
                esp(inst,inst,"门钥匙", keycolor,true,false)
            end

            if inst.Name == "MinesAnchor" and inst == GetCurrentAnchor() then
                esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
            end

            if inst.Name == "LiveBreakerPolePickup" then
                esp(inst,inst.Base,"断路器", keycolor,true,false)
            end

            if inst.Name == "LiveHintBook" then
                esp(inst,inst.Base,"书", keycolor,true,false)
            end

            if inst.Name == "TimerLever" then
                esp(inst,inst,"时间拉杆", keycolor,true,false)
            end

            if inst.Name == "ElectricalKeyObtain" then
                esp(inst,inst,"电气钥匙", keycolor,true,false)
            end

            if inst.Name == "PickupItem" then
                esp(inst,inst.Handle,"图书馆纸条",keycolor,false,false)
            end

            if inst.Name == "LibraryHintPaper" then
                esp(inst,inst.Handle,"图书馆纸条",keycolor,false,false)
            end

            if inst.Name == "MinesGenerator" then
                esp(inst,inst,"发电机", keycolor,true,false)
            elseif inst.Name == "MinesGateButton" then
                esp(inst,inst,"大门按钮", keycolor,true,false)
            elseif inst.Name == "GardenGateButton" then
                esp(inst,inst,"大门按钮", keycolor,true,false)
            elseif inst.Parent ~= nil and inst.Parent.Name == "WaterPump" then
                esp(inst,inst,"水泵", keycolor,true,false)
            end

            if inst.Name == "LeverForGate" and inst:FindFirstChild("Main") then
                esp(inst,inst.Main,"大门拉杆", keycolor,true,false)
            end

            if inst.Name == "VineGuillotine" and inst:FindFirstChild("Lever") then
                esp(inst.Lever,inst.Lever,"藤蔓拉杆", keycolor,true,false)
            end

            if inst.Name == "FuseObtain" and inst:FindFirstChild("Hitbox") then
                esp(inst,inst.Hitbox,"发电机保险丝", keycolor,true,false)
            end
        end
    end
    if Value == false then
        for i,inst in pairs(ObjectsTable.Keys) do
            inst:SetAttribute("ESP", false)
            if inst.Name == "VineGuillotine" then
                inst.Lever:SetAttribute("ESP", false)
            end
        end
    end
end
})
	
ESP:AddToggle('DoorESP', {
    Text = '门',
    Default = false,
    Tooltip = '高亮所有门',

    Callback = function(Value)
        doors = Value
        task.wait()
        if Value == true then
            for i,inst in pairs(ObjectsTable.Doors) do
                if inst.Name == "Door" and inst:FindFirstChild("Door") then
                    local knob = inst.Door:FindFirstChild("Knob") or inst.Door
                    if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then
                        if inst.Parent:GetAttribute("RequiresKey") == true then
                            esp(inst,inst.Hidden,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
                        else
                            esp(inst,inst.Hidden,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
                        end
                    else
                        if inst.Parent:GetAttribute("RequiresKey") == true then
                            esp(inst.Door,knob,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
                        else
                            esp(inst.Door,knob,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
                        end
                    end
                end
            end
        end

        if Value == false then
            for i,inst in pairs(ObjectsTable.Doors) do
                if inst:FindFirstChild("Door") then
                    inst:WaitForChild("Door"):SetAttribute("ESP",false)
                end
            end
        end
    end
})
ESP:AddToggle('ClosetESP', {
    Text = '藏匿点',
    Default = false,
    Tooltip = '高亮所有藏匿点',

    Callback = function(Value)
        closets = Value
        task.wait()
        if Value == true then
            for i,inst in pairs(ObjectsTable.Closets) do
                if inst.Name == "Wardrobe" and inst:FindFirstChild("Main") then
                    esp(inst,inst.Main,"衣柜", closetcolor,true,false)
                end

                if inst.Name == "Toolshed" and inst:FindFirstChild("Main") then
                    esp(inst,inst.Main,"工具棚", closetcolor,true,false)
                end

                if inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") then
                    esp(inst,inst.Main,"衣柜", closetcolor,true,false)
                end

                if inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") and closets == true then
                    esp(inst,inst.Main,"衣柜", closetcolor,true,false)
                end
                if inst.Name == "CircularVent" then
                    if closets == true then
                        esp(inst,inst,"管道", closetcolor,true,false)
                    end
                end

                if inst.Name == "Dumpster" then
                    if closets == true then
                        esp(inst,inst,"垃圾桶", closetcolor,true,false)
                    end
                end
                if inst.Name == "Bed" and inst:FindFirstChild("Main") and closets == true then
                    esp(inst,inst.Main,"床", closetcolor,true,false)
                end
                if inst.Name == "Double_Bed" and closets == true then
                    esp(inst,inst,"双人床", closetcolor,true,false)
                end
                if inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") then
                    esp(inst,inst.Base,"储物柜", closetcolor,true,false)
                end
                if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") then
                    esp(inst,inst.Base,"储物柜", closetcolor,true,false)
                end

                if inst.Name == "Locker_Large" and inst:FindFirstChild("Main") then
                    esp(inst,inst.Main,"储物柜", closetcolor,true,false)
                end
            end
        end

        if Value == false then
            for i,inst in pairs(ObjectsTable.Closets) do
                inst:SetAttribute("ESP", false)
            end
        end
    end
})

ESP:AddToggle('PlayerESP', {
    Text = '玩家',
    Default = false,
    Tooltip = '高亮其他玩家',

    Callback = function(Value)
        for i,inst in pairs(ObjectsTable.Players) do
            if Value then
                if inst:GetAttribute("Alive") == true and inst.Character and inst.Character:FindFirstChild("HumanoidRootPart") then
                    ESPLibrary:AddESP({
                        Object = inst.Character,
                        Text = inst.DisplayName,
                        Color = playercolor
                    })
                    inst:GetAttributeChangedSignal("Alive"):Connect(function()
                        ESPLibrary:RemoveESP(inst.Character)
                    end)
                end
            else
                ESPLibrary:RemoveESP(inst.Character)
            end
        end
    end
})
ESP:AddToggle('ChestESP', {
    Text = '箱子',
    Default = false,
    Tooltip = '高亮箱子',

    Callback = function(Value)
        task.wait()
        if Value == true then
            for i,inst in pairs(ObjectsTable.Chests) do
                if inst.Name == "ChestBox" and Toggles.ChestESP.Value or inst.Name == "ChestBoxLocked" and Toggles.ChestESP.Value then
                    local Text = "箱子"
                    if inst:GetAttribute("Locked") == true then
                        Text = "上锁箱子"
                    end
                    esp(inst,inst,Text, chestcolor,true,false)
                end
                if inst.Name == "Toolbox" and Toggles.ChestESP.Value or inst.Name == "Toolbox_Locked" and Toggles.ChestESP.Value then
                    local Text = "工具箱"
                    if inst:GetAttribute("Locked") == true then
                        Text = "上锁工具箱"
                    end
                    esp(inst,inst,Text, chestcolor,true,false)
                end
                if inst.Name == "Chest_Vine" then
                    local Text = "藤蔓箱子"
                    if Toggles.ChestESP.Value then
                        esp(inst,inst,Text, chestcolor,true,false)
                    end
                end

                if inst.Name == "Toolshed_Small" then
                    esp(inst,inst,"工具棚",chestcolor,true,false)
                end
                if inst.Name == "MouseHole" then
                    esp(inst,inst,"老鼠洞", chestcolor,true,false)
                end

                if inst.Name == "Locker_Small_Locked" then
                    local Text = "上锁物品柜"
                    if Toggles.ChestESP.Value then
                        esp(inst,inst,Text, chestcolor,true,false)
                    end
                end
            end
        end
        if Value == false then
            for i,inst in pairs(ObjectsTable.Chests) do
                inst:SetAttribute("ESP", false)
            end
        end
    end
})

ESP:AddToggle('ItemESP', {
    Text = '物品',
    Default = false,
    Tooltip = '高亮所有生成的物品',

    Callback = function(Value)
        ItemESP = Value
        task.wait()
        if Value == true then
            for i,inst in pairs(ObjectsTable.Items) do
                if table.find(Items2,inst.Name) then
                    if inst.Parent.Name == "Drops" then
                        ESPLibrary:AddESP({
                            Object = inst,
                            Text = ItemNames[inst.Name],
                            Color = itemcolor
                        })
                    else
                        esp(inst,inst,ItemNames[inst.Name],itemcolor, true, false)
                    end
                end

                if inst.Name == "Green_Herb" then
                    esp(inst,inst,"翠绿草药",itemcolor,true,false)
                end
            end
        end
        if Value == false then
            for i,inst in pairs(ObjectsTable.Items) do
                if table.find(Items2,inst.Name) or inst.Name == "Green_Herb" then
                    inst:SetAttribute("ESP", false)
                    ESPLibrary:RemoveESP(inst)
                end
            end
        end
    end
})

ESP:AddToggle('GoldESP', {
    Text = '金币',
    Default = false,
    Tooltip = '高亮所有生成的金币。',

    Callback = function(Value)
        gold = Value
        task.wait()
        if Value == true then
            for i,inst in pairs(ObjectsTable.Gold) do
                if inst:GetAttribute("GoldValue") ~= nil then
                    esp(inst,inst,inst:GetAttribute("GoldValue") .. " 金币", goldcolor,false,false)
                end
            end
        end
        if Value == false then
            for i,inst in pairs(ObjectsTable.Gold) do
                inst:SetAttribute("ESP", false)
            end
        end
    end
})
ESP:AddToggle('StardustESP', {
    Text = '星尘',
    Default = false,
    Tooltip = '高亮所有生成的星尘。',

    Callback = function(Value)
        task.wait()
        if Value == true then
            for i,inst in pairs(ObjectsTable.Stardust) do
                esp(inst,inst,"星尘堆", stardustcolor,false,false)
            end
        end
        if Value == false then
            for i,inst in pairs(ObjectsTable.Stardust) do
                inst:SetAttribute("ESP", false)
            end
        end
    end
})
ESP:AddToggle('DupeESP', {
    Text = '假门',
    Default = false,
    Tooltip = '高亮所有生成的假门',

    Callback = function(Value)
        DupeESP = Value
        task.wait()
        if Value == true then
            for i,door in pairs(ObjectsTable.Dupe) do
                if door.Name == "Collision" then
                    esp(door, door, "Vacuum", dupecolor, true, false)
                elseif door.Parent and door.Parent.Name == "FakeDoor" or door.Parent and door.Parent.Name == "DoorFake" then
                    ApplyDupeESP(door.Parent)
                end
            end
        end
        if Value == false then
            for i,door in pairs(ObjectsTable.Dupe) do
                if door.Name == "Collision" then
                    door:SetAttribute("ESP", false)
                elseif door.Parent and door.Parent.Name == "FakeDoor" or door.Parent and door.Parent.Name == "DoorFake" then
                    door:SetAttribute("ESP", false)
                end
            end
        end
    end
})

ESP:AddToggle('EntityESP', {
    Text = '实体',
    Default = false,
    Tooltip = '高亮所有生成的实体。',

    Callback = function(Value)
        EntityESP = Value
        if Value == true then
            for i,inst in pairs(ObjectsTable.Entities) do
                if inst:GetAttribute("ESPText") and inst:IsDescendantOf(workspace) and inst:GetAttribute("ESPBlacklist") == nil then
                    ESPLibrary:AddESP({
                        Object = inst,
                        Text = inst:GetAttribute("ESPText"),
                        Color = entitycolor
                    })
                end

                if inst.Name == "FigureRig" or inst.Name == "Figure" or inst.Name == "FigureRagdoll" then
                    esp(inst,inst,"Figure", entitycolor,true,false)
                end

                if inst.Name == "KeyObtainFake" then
                    esp(inst,inst,"恶魔钥匙!!!", entitycolor,true,false)
                end

                if inst.Name == "Hole" then
                    esp(inst, inst, "曼德拉草洞", entitycolor, true, false)
                end

                if inst.Name == "Mandrake" then
                    esp(inst, inst, "曼德拉草", entitycolor, true, false)
                end

                if inst.Name == "SallyMoving" then
                    ESPLibrary:AddESP({
                        Object = inst,
                        Text = "Sally",
                        Color = entitycolor
                    })
                end

                if inst.Name == "MonumentEntity" then
                    ESPLibrary:AddESP({
                        Object = inst.Top,
                        Text = "纪念碑",
                        Color = entitycolor
                    })
                end

                if inst.Name == "Groundskeeper" then
                    ESPLibrary:AddESP({
                        Object = inst,
                        Text = "园丁",
                        Color = entitycolor
                    })
                end

                if inst.Name == "LiveEntityBramble" then
                    ESPLibrary:AddESP({
                        Object = inst,
                        Text = "荆棘",
                        Color = entitycolor
                    })
                end

                if inst.Name == "LeverForGate" and inst:FindFirstChild("Main") then
                    esp(inst,inst.Main,"大门拉杆", keycolor,true,false)
                end

                if inst.Name == "JeffTheKiller" then
                    ESPLibrary:AddESP({
                        Object = inst,
                        Text = EntityAlliases["Jeff"],
                        Color = entitycolor
                    })
                end

                if inst.Name == "GrumbleRig" and inst:FindFirstChild("Root") then
                    esp(inst,inst,"Grumble", entitycolor,true,false)
                end

                if inst.Name == "Drakobloxxer" then
                    ESPLibrary:AddESP({
                        Object = inst,
                        Text = "Drakobloxxer",
                        Color = entitycolor
                    })
                end

                if inst.Name == "GiggleCeiling" then
                    esp(inst,inst,"Giggle",entitycolor,true,false)
                end

                if inst.Name == "Snare" then
                    esp(inst,inst,"Snare", entitycolor,true,false)
                    table.insert(ObjectsTable.Snares, inst)
                    if inst:FindFirstChild("Snare") then
                        inst:WaitForChild("Snare").Roots.Transparency = 1
                        inst:WaitForChild("Snare").SnareBase.Transparency = 1
                    end
                    if inst:FindFirstChild("Void") then
                        inst:WaitForChild("Void").Transparency = 0
                        inst:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
                    end
                end
            end
        else
            for i,inst in pairs(ObjectsTable.Entities) do
                inst:SetAttribute("ESP", false)
                ESPLibrary:RemoveESP(inst)
                if Toggles.EntityESP.Value then
                    inst.Hole:SetAttribute("ESP", false)
                end
            end
        end
    end
})

Toggles.DoorESP:AddColorPicker('ColorPicker1', {
    Default = doorcolor,
    Title = '门',
    Transparency = 0,

    Callback = function(Value)
        doorcolor = Value
        for i,inst in pairs(ObjectsTable.Doors) do
            if inst:FindFirstChild("Door") then
                ESPLibrary:UpdateObjectColor(inst:FindFirstChild("Door"),Value)
                ColorTable[inst:FindFirstChild("Door")] = Value
            end
        end
    end
})
Toggles.ClosetESP:AddColorPicker('ColorPicker2', {
    Default = closetcolor,
    Title = '藏匿点',
    Transparency = 0,

    Callback = function(Value)
        closetcolor = Value
        for i,inst in pairs(ObjectsTable.Closets) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})
Toggles.EssentialsESP:AddColorPicker('KeyColor', {
    Default = keycolor,
    Title = '目标物品',
    Transparency = 0,

    Callback = function(Value)
        keycolor = Value
        for i,inst in pairs(ObjectsTable.Keys) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
            if inst.Name == "VineGuillotine" then
                ESPLibrary:UpdateObjectColor(inst.Lever,Value)
                ColorTable[inst.Lever] = Value
            end
        end
    end
})

Toggles.PlayerESP:AddColorPicker('PlayerESPColor', {
    Default = playercolor,
    Title = '玩家',
    Transparency = 0,

    Callback = function(Value)
        playercolor = Value
        for i,inst in pairs(ObjectsTable.Players) do
            ColorTable[inst] = Value
            ESPLibrary:UpdateObjectColor(inst.Character,Value)
        end
    end
})
Toggles.ItemESP:AddColorPicker('ColorPickerItems', {
    Default = itemcolor,
    Title = '物品',
    Transparency = 0,

    Callback = function(Value)
        itemcolor = Value
        for i,inst in pairs(ObjectsTable.Items) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})

Toggles.GoldESP:AddColorPicker('ColorPicker6', {
    Default = goldcolor,
    Title = '金币',
    Transparency = 0,

    Callback = function(Value)
        goldcolor = Value
        for i,inst in pairs(ObjectsTable.Gold) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})
Toggles.StardustESP:AddColorPicker('StardustESPColor', {
    Default = stardustcolor,
    Title = '星尘',
    Transparency = 0,

    Callback = function(Value)
        stardustcolor = Value
        for i,inst in pairs(ObjectsTable.Stardust) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})
Toggles.DupeESP:AddColorPicker('DupeESPColor', {
    Default = dupecolor,
    Title = '假门',
    Transparency = 0,

    Callback = function(Value)
        dupecolor = Value
        for i,inst in pairs(ObjectsTable.Dupe) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})
Toggles.EntityESP:AddColorPicker('ColorPicker7', {
    Default = entitycolor,
    Title = '实体',
    Transparency = 0,

    Callback = function(Value)
        entitycolor = Value
        for i,inst in pairs(ObjectsTable.Entities) do
            ESPLibrary:UpdateObjectColor(inst, Value)
            ColorTable[inst] = Value
        end
    end
})
Toggles.ChestESP:AddColorPicker('ChestColorPicker', {
    Default = chestcolor,
    Title = '箱子',
    Transparency = 0,

    Callback = function(Value)
        chestcolor = Value
        for i,inst in pairs(ObjectsTable.Chests) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})

ESP:AddToggle("LadderESP", {
    Text = "梯子",
    Default = false,
    Tooltip = '高亮所有生成的梯子（用于矿井反作弊绕过）。',
})

Toggles.LadderESP:AddColorPicker('LadderColor', {
    Default = laddercolor,
    Title = '梯子',
    Transparency = 0,

    Callback = function(Value)
        laddercolor = Value
        for i,inst in pairs(ObjectsTable.Ladders) do
            ESPLibrary:UpdateObjectColor(inst,Value)
            ColorTable[inst] = Value
        end
    end
})

Toggles.LadderESP:OnChanged(function(value)
    for i,inst in pairs(ObjectsTable.Ladders) do
        if inst.Name == "Ladder" then
            if value then
                esp(inst,inst,"梯子", laddercolor,true,false)
            else
                inst:SetAttribute("ESP", false)
            end
        end
    end
end)

ESPLibrary:SetRainbow(false)
ESPLibrary:SetFillTransparency(0.75)
ESPLibrary:SetTextSize(22)
ESPLibrary:SetOutlineTransparency(0)
ESPLibrary:SetTextTransparency(0)
ESPLibrary:SetTextOutlineTransparency(0.25)
ESPLibrary:SetFadeTime(0.5)

ESPLibrary:SetMatchColors(true)
ESPLibrary:SetShowDistance(true)
ESPLibrary:SetTracers(false)
ESPLibrary:SetTracerOrigin('Bottom')
ESPLibrary:SetFont(Enum.Font.Oswald)
ESPLibrary:SetDistanceSizeRatio(0.8)
ESPLibrary:SetTracerSize(0.75)
ESPLibrary:SetArrows(false)
ESPLibrary:SetArrowRadius(200)

ESPSettings:AddToggle('Toggle21', {
    Text = '彩虹ESP',
    Default = false,
    Tooltip = '使所有ESP高亮具有彩虹效果。',

    Callback = function(Value)
        ESPLibrary:SetRainbow(Value)
    end
})
ESPSettings:AddDivider()
ESPSettings:AddSlider('Slider3', {
    Text = '填充透明度',
    Default = 0.75,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetFillTransparency(Value)
    end
})
ESPSettings:AddSlider('Slider4', {
    Text = '轮廓透明度',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetOutlineTransparency(Value)
    end
})
ESPSettings:AddSlider('ESPTextTransparency', {
    Text = '文字透明度',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetTextTransparency(Value)
    end
})

ESPSettings:AddSlider('ESPFadeTime', {
    Text = '淡出时间',
    Default = 0.5,
    Min = 0,
    Max = 2,
    Rounding = 2,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetFadeTime(Value)
    end
})
ESPSettings:AddSlider('ESPStrokeTransparency', {
    Text = '文字轮廓透明度',
    Default = 0.25,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetTextOutlineTransparency(Value)
    end
})
ESPSettings:AddSlider('ESPTextSize', {
    Text = '文字大小',
    Default = 22,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetTextSize(Value)
    end
})

ESPSettings:AddDropdown("ESPFont", { Values = { "Arial", "SourceSans", "Highway", "Fantasy","FredokaOne", "Gotham", "DenkOne", "JosefinSans", "Nunito", "Oswald", "RobotoCondensed", "Sarpanch", "Ubuntu" }, Default = 10, Multi = false, Text = "文字字体", Callback = function(Value) ESPLibrary:SetFont(Enum.Font[Value]) end})
ESPSettings:AddDivider()
ESPSettings:AddToggle('SyncColors', {
    Text = '自定义轮廓颜色',
    Default = false,
    Tooltip = '将所有ESP高亮的轮廓颜色设置为所选颜色。',

    Callback = function(Value)
        ESPLibrary:SetMatchColors(not Value)
    end
}):AddColorPicker('CustomOutlineColorPicker', {
    Default = Color3.fromRGB(255,255,255),
    Title = '自定义轮廓颜色',
    Transparency = 0,

    Callback = function(Value)
        ESPLibrary.OutlineColor = Value
    end
})
ESPLibrary:SetFont(Options.ESPFont.Value)
ESPSettings:AddToggle('ShowDistance', {
    Text = '显示距离',
    Default = true,
    Tooltip = '显示物体与玩家的距离[单位：studs]',

    Callback = function(Value)
        ESPLibrary:SetShowDistance(Value)
    end
})
ESPSettings:AddDivider()
ESPSettings:AddToggle('EnableTracers', {
    Text = '启用追踪线',
    Default = false,
    Tooltip = '在屏幕上显示指向物体的线条',

    Callback = function(Value)
        ESPLibrary:SetTracers(Value)
    end
})

ESPSettings:AddSlider('TracerSize', {
    Text = '追踪线粗细',
    Default = 0.75,
    Min = 0.5,
    Max = 3,
    Rounding = 2,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetTracerSize(Value)
    end
})

ESPSettings:AddDropdown("TracerOrigin", {
    Values = {'底部','顶部','中心','鼠标'},
    Default = 1,
    Multi = false,
    Text = "追踪线起点",
    Callback = function(Value)
        ESPLibrary:SetTracerOrigin(Value)
    end
})

ESPSettings:AddDivider()

ESPSettings:AddToggle('EnableArrows', {
    Text = '启用箭头',
    Default = false,
    Tooltip = '当物体不可见时在屏幕上显示指向箭头。',

    Callback = function(Value)
        ESPLibrary:SetArrows(Value)
    end
})

ESPSettings:AddSlider('ArrowRadius', {
    Text = '箭头半径',
    Default = 200,
    Min = 100,
    Max = 300,
    Rounding = 0,
    Compact = true,

    Callback = function(Value)
        ESPLibrary:SetArrowRadius(Value)
    end
})

-- 移动

-- UI设置

TimeInRun = 0

Player:GetAttributeChangedSignal("GlitchLevel"):Connect(function()
    Player:SetAttribute("CurrentRoom",CurrentRoom)
    if tonumber(Player:GetAttribute("GlitchLevel")) ~= 0 then
    end
end)

Library:SetWatermarkVisibility(false)

-- 动态更新水印示例（FPS和延迟）
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600) -- 计算小时
    seconds = seconds % 3600 -- 去掉小时后剩余秒数
    local minutes = math.floor(seconds / 60) -- 计算分钟
    seconds = seconds % 60 -- 剩余秒数

    -- 格式化字符串
    local formattedTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    return formattedTime
end

-- 使用示例

--[[local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    Library:SetWatermark((ScriptName..' | FPS: '..FPS..' | 延迟: '..math.round(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())..' ms'))

    Library:SetWatermarkVisibility(false)
end)

Library.KeybindFrame.Visible = false -- 待办：为此添加一个函数

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)]]

RoomAddedConnection = workspace:WaitForChild("CurrentRooms").ChildAdded:Connect(function(child)
    if child.Name == "100" then
        BreakerSolving = true
    end

    if child:GetAttribute("RawName") and string.find(child:GetAttribute("RawName"), "Halt") or child:GetAttribute("Shade") ~= nil then
        if Floor ~= "Party" and Toggles.NotifyEntities.Value then
            if Options.NotifyMonsters.Value["Halt"] and Toggles.ChatNotify.Value then
                ChatNotify("Halt在下一个房间！")
            end
            if Options.NotifyMonsters.Value["Halt"] then
                Notify({Title = "实体警告", Description = "实体 '"..EntityAlliases["Halt"] .. "' 将在下一个房间生成。", NotificationType = "警告", Image = EntityIcons["Halt"]})
                Sound()
            end
        end
    end
end)

task.wait()


local HasteTimeConnection
if ReplicatedStorage:FindFirstChild("FloorReplicated") then
	if ReplicatedStorage:WaitForChild("FloorReplicated"):FindFirstChild("DigitalTimer") then
		HasteTimeConnection = ReplicatedStorage:WaitForChild("FloorReplicated").DigitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
			if Toggles.NotifyHasteTime.Value then
				Caption(GetHasteTime(), true)
			end	
		end)
	else
		HasteTimeConnection = Player:GetAttributeChangedSignal("Alive"):Connect(function()

		end)
	end
else

	HasteTimeConnection = Player:GetAttributeChangedSignal("Alive"):Connect(function()

	end)
end



for i,part in pairs(Character:GetDescendants()) do
	if part:IsA("BasePart") then
		PartProperties[part] = part.CustomPhysicalProperties
	end
end





local promptsnum = 1

local firstenabled = false

local ItemsConnection = workspace:WaitForChild("Drops", 9e9).ChildAdded:Connect(function(inst)


	task.wait()

	if inst.Name == "GoldPile" then
		return
	end

	if Floor == "Party" then
		inst:SetAttribute("ESPRoom", CurrentRoom + 1)
	end



	

	if Floor == "Party" then
		local Connection = Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
			if inst:GetAttribute("ESPRoom") == Player:GetAttribute("CurrentRoom") and inst.PrimaryPart ~= nil then
				ESPLibrary:AddESP({
					Object = inst,
					Text = ItemNames[inst.Name],
					Color = itemcolor
				})
				table.insert(ObjectsTable.Items,inst)
			else
				ESPLibrary:RemoveESP(inst)
				RemovefromTables(inst)

			end
		end)
		inst.Destroying:Once(function()
			Connection:Disconnect()
		end)
	end
end)


for i,inst in pairs(workspace:WaitForChild("Drops"):GetChildren()) do


	table.insert(ObjectsTable.Items,inst)


end


local UseAnimation
local UseAnimationBreak

local InfiniteItemsCooldown = false


local InfiniteItemsConnection = game:GetService("ProximityPromptService").PromptTriggered:Connect(function(Prompt, TriggeredPlayer)
	local ParentName = Prompt.Parent.Name


	if ExecutorSupport["fireproximityprompt"] == false then
		return
	end





	if Prompt.Name == "FakePrompt" then


		if UseAnimationBreak then
			if Character:FindFirstChild("Lockpick") or Character:FindFirstChild("Shears") or Character:FindFirstChild("SkeletonKey") or Character:FindFirstChild("Key") or Character:FindFirstChild("ElectricalKey") then

				UseAnimationBreak:Play()

			end
		end

		if Character:FindFirstChild("Multitool") then

			if Prompt.Parent.Name == "CuttableVines" or Prompt.Parent.Name == "Chest_Vine" then
				local NewUseAnimationBreak = Humanoid.Animator:LoadAnimation(Character.Multitool.Animations.shearsuse)
				NewUseAnimationBreak:Stop()
				NewUseAnimationBreak:Play()

			elseif UseAnimationBreak then
				UseAnimationBreak:Stop()
				UseAnimationBreak:Play()
			end


		end



		if Toggles.InfiniteItems.Value then
		
		if Options.InfiniteItemsSelection.Value["Lockpicks"] and Character:FindFirstChild("Lockpick") then



			RemotesFolder.DropItem:FireServer(Character:FindFirstChild("Lockpick"))		










			workspace.Drops.ChildAdded:Wait()

			for i,Tool in pairs(workspace.Drops:GetChildren()) do
				if Tool.Name == "Lockpick" then
					fireproximityprompt(Tool:WaitForChild("ModulePrompt"))
				end
			end

			Character.ChildAdded:Wait()
			task.wait(0.1)
			InfiniteItemsCooldown = false




		end
		if Options.InfiniteItemsSelection.Value["Multitool"] and Character:FindFirstChild("Multitool") then





			RemotesFolder.DropItem:FireServer(Character:FindFirstChild("Multitool"))
			workspace.Drops.ChildAdded:Wait()
			task.wait()		
			for i,Tool in pairs(workspace.Drops:GetChildren()) do
				if Tool.Name == "Multitool" then
					fireproximityprompt(Tool:WaitForChild("ModulePrompt"))
				end
			end
			Character.ChildAdded:Wait()

			task.wait()



			if ParentName == "Chest_Vine" or ParentName == "CuttableVines" then
				Character:WaitForChild("Multitool", 9e9):WaitForChild("Handle", 9e9):WaitForChild("sound_promptend", 9e9):Play()
			end


			InfiniteItemsCooldown = false
		end
		if Options.InfiniteItemsSelection.Value["Shears"] and Character:FindFirstChild("Shears") then





			RemotesFolder.DropItem:FireServer(Character:FindFirstChild("Shears"))
			workspace.Drops.ChildAdded:Wait()
			task.wait()		
			for i,Tool in pairs(workspace.Drops:GetChildren()) do
				if Tool.Name == "Shears" then
					fireproximityprompt(Tool:WaitForChild("ModulePrompt"))
				end
			end
			Character.ChildAdded:Wait()

			task.wait()



			Character:WaitForChild("Shears", 9e9):WaitForChild("Handle", 9e9):WaitForChild("sound_promptend", 9e9):Play()



			InfiniteItemsCooldown = false
		end
		if Options.InfiniteItemsSelection.Value["Skeleton Key"] and Character:FindFirstChild("SkeletonKey") then



			RemotesFolder.DropItem:FireServer(Character:FindFirstChild("SkeletonKey"))

			workspace.Drops.ChildAdded:Wait()

			for i,Tool in pairs(workspace.Drops:GetChildren()) do
				if Tool.Name == "SkeletonKey" then
					fireproximityprompt(Tool:WaitForChild("ModulePrompt"))
				end
			end
			Character.ChildAdded:Wait()
			task.wait(0.1)
			InfiniteItemsCooldown = false
		end




		task.wait(0.1)

		InfiniteItemsCooldown = false

	end

	end




end)




local InfiniteItemsConnection2 = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(Prompt, TriggeredPlayer)
	if Prompt.Name ~= "FakePrompt" then
		return
	end



	if Character:FindFirstChild("Multitool") then

		if Prompt.Parent.Name == "CuttableVines" or Prompt.Parent.Name == "Chest_Vine" then
			local NewUseAnimation = Humanoid.Animator:LoadAnimation(Character.Multitool.Animations.shears)
			NewUseAnimation:Stop()
			NewUseAnimation:Play()
			Character.Multitool:FindFirstChild("sound_prompt", true):Play()
		else
			UseAnimation:Stop()
			UseAnimation:Play()
		end


	end

	if UseAnimation then
		if Character:FindFirstChild("Lockpick") or Character:FindFirstChild("Shears") or Character:FindFirstChild("SkeletonKey") or Character:FindFirstChild("Key") or Character:FindFirstChild("KeyElectrical") or Character:FindFirstChild("KeyBackdoor") or Character:FindFirstChild("KeyIron") then
			UseAnimation:Stop()
			UseAnimation:Play()
			if Character:FindFirstChild("Shears") then
				Character.Shears:FindFirstChild("sound_prompt", true):Play()
			end

		end
	end
end)

local InfiniteItemsConnection3 = game:GetService("ProximityPromptService").PromptTriggered:Connect(function(Prompt, TriggeredPlayer)









	if Prompt.Name == "FakePrompt" then
		Prompt.Enabled = false
		task.wait()
		Prompt.Enabled = true







	end




end)

local InfiniteCrucifixDistances = {
    ["RushMoving"] = 50,
    ["BackdoorRush"] = 50,
    ["AmbushMoving"] = 70,
    ["A60"] = 60,
    ["A120"] = 40
}

local InfiniteCrucifixConnection = RunService.Heartbeat:Connect(function()
	if true == true then
	return
	end
	
	if not Toggles.InfiniteItems or not Toggles.InfiniteItems.Value or not Options.InfiniteItemsSelection.Value["Crucifix"] or not Character:FindFirstChild("Crucifix") then
		return
	end

local NearestEntity = GetNearestEntity()

if NearestEntity and NearestEntity.PrimaryPart then
    local origin = HumanoidRootPart.Position
		local target = NearestEntity.PrimaryPart.Position
		local direction = (target - origin).Unit * (target - origin).Magnitude
		local Distance = (HumanoidRootPart.Position - NearestEntity.PrimaryPart.Position).Magnitude

		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {Character, NeearestEntity}
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist

		local result = workspace:Raycast(origin, direction, rayParams)

if not result and Distance <= InfiniteCrucifixDistances[NearestEntity.Name] or result and result.Instance.CanCollide == false and Distance <= InfiniteCrucifixDistances[NearestEntity.Name] then
	RemotesFolder.DropItem:FireServer(Character:FindFirstChild("Crucifix"))
	workspace.Drops.ChildAdded:Wait()
for i,Tool in pairs(workspace.Drops:GetChildren()) do
				if Tool.Name == "Crucifix" then
					fireproximityprompt(Tool:WaitForChild("ModulePrompt"))
				end
			end
		end
	end
end)








local BreakerConnection 



-- Table of all instance names used in the script
local Room100LeverPulled = false


local Connection5 = game.Workspace.DescendantAdded:Connect(function(inst)


	if not table.find(allowedInstances,inst.Name) and not inst:IsA("ProximityPrompt") and not table.find(Items2, inst.Name) then 
		return 
	end

	


local Delay = math.random(125,250) / 1000

		
if inst:IsA("ProximityPrompt") then
		table.insert(ObjectsTable.Prompts2, inst)

		






		inst:SetAttribute("CanFire", true)

		if inst:GetAttribute("OldHoldTime") == nil then
			inst:SetAttribute("OldHoldTime",inst.HoldDuration)
		end
		if inst:GetAttribute("PromptClip") == nil then
			inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
		end
		if inst:GetAttribute("OldDistance") == nil then
			inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
		end
		if interact == true then
			inst.HoldDuration = 0
		else
			inst.HoldDuration = inst:GetAttribute("OldHoldTime")
		end

		
			inst.MaxActivationDistance = inst:GetAttribute("OldDistance") * ReachDistance
	
		if ito == true then
			inst.RequiresLineOfSight = false
		else
			inst.RequiresLineOfSight = inst:GetAttribute("PromptClip")
		end

		local LockPrompts = {
			"UnlockPrompt",
			"SkullPrompt",
			"LockPrompt",
			"ThingToEnable",
			"FusesPrompt",

		}

if inst.Parent ~= nil and inst.Parent.Name == "Lock" then
    inst:SetAttribute("UnlockPrompt", true)
end

if RemotesFolder:FindFirstChild("DropItem") and ExecutorSupport["fireproximityprompt"] == true then
    if table.find(LockPrompts, inst.Name) or inst.Parent ~= nil and inst.Parent:GetAttribute("Locked") == true or inst.Parent ~= nil and inst.Parent.Parent ~= nil and inst.Parent.Parent.Name == "Locker_Small_Locked" and inst.Name == "ActivateEventPrompt" then
        if inst.Name ~= "FakePrompt" then
            local NewPrompt = inst:Clone()
            NewPrompt.Name = "FakePrompt"
            NewPrompt.Parent = inst.Parent

            NewPrompt:SetAttribute("IsEnabled", inst.Enabled)

            local OriginalParent = inst.Parent

            inst.Parent = FakePromptPart

            NewPrompt.Enabled = inst.Enabled

            inst:SetAttribute("FakePrompt", true)

            NewPrompt:SetAttribute("OriginalName", inst.Name)

            inst:GetPropertyChangedSignal("Enabled"):Connect(function()
                if inst.Enabled == false then
                    NewPrompt:SetAttribute("IsEnabled", false)
                    NewPrompt:Destroy()
                    inst.Parent = OriginalParent
                else
                    NewPrompt.Enabled = true
                    NewPrompt:SetAttribute("IsEnabled", true)
                end
            end)

            inst:GetPropertyChangedSignal("Parent"):Connect(function()
                if inst.Parent ~= FakePromptPart and NewPrompt:IsDescendantOf(workspace) then
                    NewPrompt.Parent = inst.Parent
                    inst.Parent = FakePromptPart
                end
            end)

            inst.Destroying:Connect(function()
                NewPrompt:Destroy()
            end)

            NewPrompt.Destroying:Connect(function()
                if inst:IsDescendantOf(workspace) then
                    inst.Parent = OriginalParent
                end
            end)

            NewPrompt.Triggered:Connect(function()
                if InfiniteItemsCooldown == false then
                    if Options.InfiniteItemsSelection.Value["开锁器"] and Character:FindFirstChild("Lockpick") and Toggles.InfiniteItems.Value then
                        InfiniteItemsCooldown = true
                        workspace.Drops.ChildAdded:Wait()
                        fireproximityprompt(inst)
                    elseif Options.InfiniteItemsSelection.Value["剪刀"] and Character:FindFirstChild("Shears") and Toggles.InfiniteItems.Value then
                        InfiniteItemsCooldown = true
                        workspace.Drops.ChildAdded:Wait()
                        fireproximityprompt(inst)
                    elseif Options.InfiniteItemsSelection.Value["多功能工具"] and Character:FindFirstChild("Multitool") and Toggles.InfiniteItems.Value then
                        InfiniteItemsCooldown = true
                        workspace.Drops.ChildAdded:Wait()
                        fireproximityprompt(inst)
                    elseif Options.InfiniteItemsSelection.Value["万能钥匙"] and Character:FindFirstChild("SkeletonKey") and Toggles.InfiniteItems.Value then
                        InfiniteItemsCooldown = true
                        workspace.Drops.ChildAdded:Wait()
                        fireproximityprompt(inst)
                    else
                        fireproximityprompt(inst)
                    end
                end
            end)
        end
    end
end

if CanAutoInteract(inst) then
    table.insert(ObjectsTable.Prompts, inst)
end

end

task.wait(Delay)

if table.find(RequiresParentRoom, inst.Name) then
    GetRoom(inst, false)
end

inst.Destroying:Connect(function()
    RemovefromTables(inst)
end)

if inst.Name == "IndustrialGate" then
    inst:WaitForChild("Box", 9e9).ActivateEventPrompt:GetAttributeChangedSignal("Interactions"):Connect(function()
        Room100LeverPulled = true
    end)
end

if inst.Name == "JeffTheKiller" then
    local ConnectionsTable = {}

    for i,part in pairs(inst:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = not Toggles.AntiJeff.Value
        end
    end

    table.insert(ObjectsTable.Entities, inst)

    if Toggles.EntityESP.Value then
        ESPLibrary:AddESP({
            Object = inst,
            Text = EntityAlliases["Jeff"],
            Color = entitycolor
        })
    end
    
if Options.NotifyMonsters.Value["Jeff The Killer"] and Toggles.NotifyEntities.Value then
    Notify({Title = "实体警告", Description = "实体 '"..EntityAlliases["Jeff"] .. "' 已生成。", NotificationType = "警告", Image = EntityIcons["Jeff"]})
    Sound()
    if Options.NotifyMonsters.Value["Jeff The Killer"] and Toggles.ChatNotify.Value then
        ChatNotify("Jeff" .. ChatNotifyMessage)
    end
end

task.wait()

if Toggles.DeleteJeff and Toggles.DeleteJeff.Value then
    DeleteJeff(inst)
end

end

if inst.Name == "KeyObtain" then
    table.insert(ObjectsTable.Keys,inst)

    if Toggles.EssentialsESP.Value then
        esp(inst,inst,"门钥匙", keycolor,true,false)
    end
end

if inst.Name == "RiftSpawn" then
    table.insert(ObjectsTable.RiftSpawn, inst)
end

if inst.Name == "BananaPeel" then
    inst.CanTouch = not Toggles.AntiBananaPeel.Value
end

if inst.Name == "Hole" and inst.Parent and inst.Parent.Name == "MandrakeLive" then
    table.insert(ObjectsTable.Entities, inst)

    if Toggles.EntityESP.Value then
        esp(inst, inst, "曼德拉草洞", entitycolor, true, false)
    end
end

if inst.Name == "ElevatorBreaker" then
    BreakerConnection = inst:WaitForChild("SurfaceGui").Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
        task.wait()
        local BreakerID = inst:WaitForChild("SurfaceGui").Frame.Code.Text
        if tonumber(BreakerID) and AutoBreaker == true then
            for i,Breaker in pairs(inst:GetChildren()) do
                if Breaker.Name == "BreakerSwitch" then
                    if Breaker:GetAttribute("ID") == tonumber(BreakerID) then
                        if inst:WaitForChild("SurfaceGui").Frame.Code.Frame.BackgroundTransparency == 0 then
                            EnableBreaker(Breaker)
                        else
                            DisableBreaker(Breaker)
                        end
                    end
                end
            end
        end
    end)
end

if inst.Name == "Mandrake" and inst.Parent.Name == "MandrakeLive" then
    table.insert(ObjectsTable.Entities, inst)

    if Toggles.EntityESP.Value then
        esp(inst, inst, "曼德拉草", entitycolor, true, false)
    end
end

if inst.Name == "SurgeSpawn" and Toggles.DisableSurge and Toggles.DisableSurge.Value then
    task.wait(0.25)
    inst:Destroy()
end

if inst.Name == "Snare" then
    table.insert(ObjectsTable.Entities,inst)

    if Toggles.EntityESP.Value then
        esp(inst,inst,"Snare", entitycolor,true,false)

        if inst:FindFirstChild("Snare") then
            inst:WaitForChild("Snare").Roots.Transparency = 1
            inst:WaitForChild("Snare").SnareBase.Transparency = 1
        end
        if inst:FindFirstChild("Void") then
            inst:WaitForChild("Void").Transparency = 0
            inst:WaitForChild("Void").Color = Color3.fromRGB(76, 67, 55)
        end
    end

    if AntiSnare == true then
        inst:WaitForChild("Hitbox",99999)
        inst.Hitbox.CanTouch = false
    end
end

if inst.Name == "Wax_Door" then
    inst:SetAttribute("OriginalPosition", inst:GetPivot())
    table.insert(ObjectsTable.RemovableModels, inst)
    if Toggles.RemoveSkeletonDoor and Toggles.RemoveSkeletonDoor.Value then
        inst:PivotTo(CFrame.new(-10000,-10000,-10000))
    end
end

if inst.Name == "ThingToOpen" then
    inst:SetAttribute("OriginalPosition", inst:GetPivot())
    table.insert(ObjectsTable.RemovableModels, inst)
    if Toggles.RemoveGates and Toggles.RemoveGates.Value then
        inst:PivotTo(CFrame.new(-10000,-10000,-10000))
    end
end

if inst.Name == "MovingDoor" then
    inst:SetAttribute("OriginalPosition", inst:GetPivot())
    table.insert(ObjectsTable.RemovableModels, inst)
    if Toggles.RemovePaintingDoor and Toggles.RemovePaintingDoor.Value then
        inst:PivotTo(CFrame.new(-10000,-10000,-10000))
    end
end

if inst.Name == "GloomPile" then
    for _, gloomEgg in pairs(inst:GetDescendants()) do
        if gloomEgg.Name == "Egg" then
            gloomEgg.CanTouch = not Toggles.AntiGloomEgg.Value
        end
    end
end

if inst:FindFirstChild("HiddenPlayer") then
    local parts = {}
    local parts2 = inst:GetDescendants()
    if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
        parts2 = inst.Parent:GetDescendants()
    end
    for i,part in pairs(parts2) do
        if part:IsA("BasePart") then
            if part.Transparency == 0 then
                table.insert(parts,part)
                part:SetAttribute("Transparency", 0)
            end
        end
        task.wait()
    end

    RenderConnections[ESPLibrary:GenerateRandomString()] = inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()
        if inst.HiddenPlayer.Value == Character and LastHidingSpot then
            LastHidingSpot.Value = inst
            if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
                LastHidingSpot.Value = inst.Parent
            end
        end

        if inst:FindFirstChild("HiddenPlayer") then
            if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
                for i,e in pairs(parts) do
                    e.Transparency = TransparentClosetNumber
                end
            else
                for i,e in pairs(parts) do
                    e.Transparency = 0
                end
            end
        end
    end)
end

if inst.Name == "DoorFake" then
    table.insert(ObjectsTable.Dupe, inst:FindFirstChild("Door"))
    if AntiDupe == true then
        DisableDupe(inst, true)
    end
    if DupeESP == true then
        ApplyDupeESP(inst)
    end
end

if inst.Name == "Toolshed_Small" then
    table.insert(ObjectsTable.Chests,inst)
    if ItemESP == true then
        esp(inst,inst,"工具棚", chestcolor,true,false)
    end
end

if inst.Name == "NannerPeel" then
    inst.CanTouch = not Toggles.AntiNanner.Value
    inst.Hitbox.CanTouch = not Toggles.AntiNanner.Value
end

if inst.Name == "Green_Herb" then
    table.insert(ObjectsTable.Items,inst)
    if ItemESP == true then
        esp(inst,inst,"翠绿草药",itemcolor,true,false)
    end
end

if inst.Name == "TimerLever" then
    inst:WaitForChild("Main", 9e9)

    table.insert(ObjectsTable.Keys,inst)

    inst.Destroying:Connect(function()
        inst:SetAttribute("ESP", true)
        inst:SetAttribute("ESPBlacklist", true)
    end)

    if Toggles.EssentialsESP.Value then
        esp(inst,inst,"时间拉杆", keycolor,true,false)
    end
end

if inst.Name == "PickupItem" then
    table.insert(ObjectsTable.Keys,inst)
    if ItemESP == true then
        esp(inst,inst,"图书馆纸条",keycolor,true,false)
    end
end

if inst.Name == "LibraryHintPaper" then
    table.insert(ObjectsTable.Keys,inst)
    if ItemESP == true then
        esp(inst,inst,"图书馆纸条",keycolor,true,false)
    end
end

if inst.Name == "GiggleCeiling" and Toggles.AntiGiggle and Toggles.AntiGiggle.Value then
    inst:WaitForChild("Hitbox", 5).CanTouch = false
end

if inst.Name == "Locker_Small_Locked" then
    table.insert(ObjectsTable.Chests, inst)
    local Text = "上锁物品柜"

    if Toggles.ChestESP.Value then
        esp(inst,inst,Text, chestcolor,true,false)
    end
end

if inst.Name == "Lava" and Toggles.AntiLava.Value then
    inst.CanTouch = false
end

if inst.Name == "ScaryWall" and Toggles.AntiScaryWall.Value then
    for i,part in pairs(inst:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = false
            part.CanCollide = false
        end
    end
end

if inst.Name == "DoorFake" or inst.Name == "FakeDoor" then
    if inst:FindFirstChild("Door") then
        table.insert(ObjectsTable.Dupe,inst.Door)
        if AntiDupe == true then
            DisableDupe(inst, true)
        end
    end
end

if inst.Name == "SideroomSpace" then
    table.insert(ObjectsTable.Dupe, inst)
    if AntiVacuum == true then
        DisableDupe(inst, true)
    end
end

if inst.Name == "LotusPetalPickup" then
    table.insert(ObjectsTable.Items,inst)
    inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "LotusHolder" then
    table.insert(ObjectsTable.Items,inst)
    inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end
if inst.Name == "GlitchCube" then
    table.insert(ObjectsTable.Items,inst)
    inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "GoldPile" and inst:GetAttribute("GoldValue") then
    table.insert(ObjectsTable.Gold,inst)
    if gold == true then
        esp(inst,inst,inst:GetAttribute("GoldValue") .. " 金币", goldcolor,true,false)
    end
end

if inst.Name == "StardustPickup" then
    table.insert(ObjectsTable.Stardust,inst)
    if Toggles.StardustESP.Value then
        esp(inst,inst,"星尘堆", stardustcolor,true,false)
    end
end

if inst.Name == "LotusPetalPickup" then
    table.insert(ObjectsTable.Items,inst)
    if Toggles.ItemESP.Value then
        esp(inst,inst,"莲花花瓣", itemcolor,true,false)
    end
end

if inst.Name == "Groundskeeper" then
    table.insert(ObjectsTable.Entities,inst)
    table.insert(ObjectsTable.GardenEntities,inst)
    if Toggles.EntityESP.Value then
        ESPLibrary:AddESP({
            Object = inst,
            Text = "园丁",
            Color = entitycolor
        })
    end

    if Options.NotifyMonsters.Value["Groundskeeper"] and Toggles.ChatNotify.Value and Toggles.NotifyEntities.Value then
        ChatNotify("园丁" .. ChatNotifyMessage)
    end
    if Options.NotifyMonsters.Value["Groundskeeper"] and Toggles.NotifyEntities.Value then
        Notify({Title = "实体警告", Description = "实体 '园丁' 已生成。", Reason = "避免在草地上行走。", NotificationType = "警告", Image = EntityIcons["Groundskeeper"]})
        Sound()
    end
end

if inst.Name == "LiveEntityBramble" then
    table.insert(ObjectsTable.Entities,inst)
    table.insert(ObjectsTable.GardenEntities,inst)
    if Toggles.EntityESP.Value then
        ESPLibrary:AddESP({
            Object = inst,
            Text = "荆棘",
            Color = entitycolor
        })
    end
end

if inst.Name == "Ladder" and inst.PrimaryPart ~= nil then
    table.insert(ObjectsTable.Ladders,inst)
    if Toggles.LadderESP.Value then
        esp(inst,inst.PrimaryPart,"梯子", laddercolor,true,false)
    end
end

if table.find(Items2, inst.Name) and inst:FindFirstChild("ModulePrompt") then
    table.insert(ObjectsTable.Items, inst)

    if ItemESP == true then
        esp(inst,inst,ItemNames[inst.Name],itemcolor, true, false)
    end
end

if inst.Name == "ChestBox" and inst:FindFirstChild("Main") or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Chests,inst)
    local Text = "箱子"
    if inst:GetAttribute("Locked") == true then
        Text = "上锁箱子"
    end

    if Toggles.ChestESP.Value then
        esp(inst,inst.Main,Text, chestcolor,true,false)
    end
end

if inst.Name == "Chest_Vine" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Chests,inst)
    local Text = "藤蔓箱子"

    if Toggles.ChestESP.Value then
        esp(inst,inst.Main,Text, chestcolor,true,false)
    end
end

if inst.Name == "Toolbox" or inst.Name == "Toolbox_Locked" then
    table.insert(ObjectsTable.Chests,inst)
    local Text = "工具箱"
    if inst:GetAttribute("Locked") == true then
        Text = "上锁工具箱"
    end
    if Toggles.ChestESP.Value then
        esp(inst,inst,Text, chestcolor,true,false)
    end
end

if inst.Name == "Locker_Small_Locked" then
    table.insert(ObjectsTable.Chests, inst)
    local Text = "上锁物品柜"

    if Toggles.ChestESP.Value then
        esp(inst,inst,Text, chestcolor,true,false)
    end
end

if inst.Name == "Door" then
    if inst:IsA("BasePart") then
        inst:SetAttribute("OriginalPosition", inst.Position)
        table.insert(ObjectsTable.DoorParts, inst)
    end

    inst:WaitForChild("ClientOpen", 9e9)
    inst:WaitForChild("Door", 9e9)

    table.insert(ObjectsTable.Doors,inst)

    local Connection
    Connection = RunService.Heartbeat:Connect(function()
        if Toggles.DoorReach.Value and Player:DistanceFromCharacter(inst:FindFirstChild("Door").Position) < 7 * Options.DoorReachMultiplier.Value then
            local Event = inst:FindFirstChild("ClientOpen")
            if Event then
                Event:FireServer()
            end
        end
    end)

    LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
        task.wait(0.25)
        LatestRoom:GetPropertyChangedSignal("Value"):Wait()
        Connection:Disconnect()
    end)

    if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then
        inst:SetAttribute("Door", true)

        if doors == true then
            if inst.Parent:GetAttribute("RequiresKey") == true then
                esp(inst,inst,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
            else
                esp(inst,inst,"门 " .. GetDoorNumber(inst), doorcolor,true, false)
            end
        end
    else
        inst:WaitForChild("Door")

        inst.Door:SetAttribute("Door", true)

        if doors == true then
            if inst.Parent:GetAttribute("RequiresKey") == true then
                esp(inst.Door,inst.Door,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
            else
                esp(inst.Door,inst.Door,"门 " .. GetDoorNumber(inst), doorcolor,true,false)
            end
        end
    end
end

if inst.Name == "FigureRig" or inst.Name == "Figure" or inst.Name == "FigureRagdoll" then
    Figure = inst
    table.insert(ObjectsTable.Entities, inst)

    if Toggles.EntityESP.Value then
        esp(inst,inst,"Figure", entitycolor,true,false)
    end

    if Toggles.DeleteFigure and Toggles.DeleteFigure.Value then
        if Floor == "Hotel" or Floor == "Fools" then
            workspace:WaitForChild("CurrentRooms").ChildAdded:Once(function()
                if NewHotel == false then
                    if CurrentRoom > 60 then
                        Notify({Title = "删除Figure", Description = "在此楼层，Figure只能在第50扇门处删除。"})
                        Sound()
                    end
                end
            end)
        end

        if Floor == "Mines" and ExecutorSupport["isnetworkowner"] then
            local part = inst:WaitForChild("Root", 9e9)

            if ExecutorSupport["firetouchinterest"] then
                firetouchinterest(part, Collision, 1)
                task.wait()
                firetouchinterest(part, Collision, 0)
            end

            local DeleteConnection
            DeleteConnection = RunService.Heartbeat:Connect(function()
                if Toggles.DeleteFigure.Value then
                    if isnetworkowner(part) then
                        part:PivotTo(CFrame.new(-49999,-49999,-49999))
                    end
                end
            end)

            part.Destroying:Connect(function()
                DeleteConnection:Disconnect()
                Notify({Title = "删除Figure", Description = "成功删除Figure！"})
                Sound()
            end)
        end

        if Toggles.DeleteFigure.Value then
            local GotNetworkOwnership = false
            workspace:WaitForChild("CurrentRooms").ChildAdded:Wait()
            task.wait(1.5)
            if NewHotel == false and not workspace.CurrentRooms:FindFirstChild("100") then
                Character:PivotTo(inst:WaitForChild("Torso", 9e9).CFrame)
                for i,part in pairs(inst:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Position = Vector3.new(9999,9999,9999)
                        task.wait()
                        inst:PivotTo(CFrame.new(9999,9999,9999))
                        if not isnetworkowner(part) then
                            break
                        else
                            GotNetworkOwnership = true
                        end
                    end
                end

                if GotNetworkOwnership == true then
                    Notify({Title = "删除Figure", Description = "成功删除Figure！"})
                    Sound()
                elseif Toggles.DeleteFigure.Value then
                    Notify({Title = "删除Figure", Description = "删除Figure失败：", Reason = "无法获取网络所有权。"})
                    Sound()
                end
            end
        end
    end
end

if inst.Name == "PowerupPad" and Toggles.AutoPowerups then
    Player:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
        if tostring(Player:GetAttribute("CurrentRoom")) == tostring(inst:GetAttribute("ParentRoom")) then
            task.wait(0.1)
            if Toggles.AutoPowerups.Value then
                local Hitbox = inst:WaitForChild("Hitbox", 9e9)
                firetouchinterest(Hitbox, Collision, 1)
                task.wait()
                firetouchinterest(Hitbox, Collision, 0)
            end
        end
    end)
end

if inst.Name == "LeverForGate" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst,"大门拉杆", keycolor,true,false)
    end

    inst:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Once(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "VineGuillotine" and inst:FindFirstChild("Lever") then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst.Lever,inst.Lever,"藤蔓拉杆", keycolor,true,false)
    end

    inst.Lever:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Once(function()
        inst.Lever:SetAttribute("ESP", false)
        inst.Lever:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "Wardrobe" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Main,"衣柜", closetcolor,true,false)
    end
end

if inst.Name == "Toolshed" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Main,"工具棚", closetcolor,true,false)
    end
end

if inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Base,"储物柜", closetcolor,true,false)
    end
end

if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Base,"冰箱储物柜", closetcolor,true,false)
    end
end

if inst.Name == "Locker_Large" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Main,"储物柜", closetcolor,true,false)
    end
end

if inst.Name == "CircularVent" then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst,"管道", closetcolor,true,false)
    end
end

if inst.Name == "Dumpster" then
    table.insert(ObjectsTable.Closets,inst)
    table.insert(ObjectsTable.Closets,inst:WaitForChild("DumpsterLeft"))
    table.insert(ObjectsTable.Closets,inst:WaitForChild("DumpsterRight"))
    if closets == true then
        esp(inst,inst,"垃圾桶", closetcolor,true,false)
    end
end

if inst.Name == "MinesAnchor" then
    inst:WaitForChild("Sign")
    inst:SetAttribute("Anchor", inst.Sign.TextLabel.Text)
    table.insert(ObjectsTable.Keys,inst)
    table.insert(ObjectsTable.Anchors,inst)
    if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor() then
        esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
    end

    inst:GetAttributeChangedSignal("Activated"):Connect(function()
        if inst:GetAttribute("Activated") == true then
            inst:SetAttribute("ESP", false)
            inst:SetAttribute("ESPBlacklist", true)
        end
    end)
end

if inst.Name == "DoorFake" and AntiDupe == true or inst.Name == "FakeDoor" and AntiDupe == true then
    DisableDupe(inst, true)
end

if inst.Name == "SideroomSpace" then
    inst:WaitForChild("Collision", 9e9)

    if AntiVacuum == true then
        DisableDupe(inst, true)
    end
    local Model = inst

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = inst

    inst.Collision.Transparency = 0.99

    if DupeESP == true then
        esp(inst.Collision, inst.Collision, "Vacuum", dupecolor, true, false)
    end

    table.insert(ObjectsTable.Dupe,inst.Collision)
end

if inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Main,"衣柜", closetcolor,true,false)
    end
end

if inst.Name == "Double_Bed" then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst,"双人床", closetcolor,true,false)
    end
end

if inst.Name == "Bed" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Main,"床", closetcolor,true,false)
    end
end

if inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main") then
    table.insert(ObjectsTable.Closets,inst)
    if closets == true then
        esp(inst,inst.Main,"衣柜", closetcolor,true,false)
    end
end

if inst.Name == "ElectricalKeyObtain" then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst.Hitbox.Key,"电气钥匙", keycolor,true,false)
    end
end

if inst.Name == "FuseObtain" then
    table.insert(ObjectsTable.Keys,inst)
    if inst:FindFirstChild("Hitbox") and Toggles.EssentialsESP.Value then
        esp(inst,inst.Hitbox,"发电机保险丝", keycolor,true,false)
        inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions" .. Player.Name):Once(function()
            inst:SetAttribute("ESP", false)
            inst:SetAttribute("ESPBlacklist", true)
        end)
    end
end

if inst.Name == "MinesGenerator" then
    inst:WaitForChild("Lever", 9e9)
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst,"发电机", keycolor,true,false)
    end
    inst:WaitForChild("Lever"):WaitForChild("Sound").Played:Connect(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "GiggleCeiling" then
    table.insert(ObjectsTable.Entities,inst)
    if Toggles.AntiGiggle and Toggles.AntiGiggle.Value then
        inst:WaitForChild("Hitbox", 5).CanTouch = not Toggles.AntiGiggle.Value
    end
    if Toggles.EntityESP.Value then
        esp(inst,inst,"Giggle",entitycolor,true,false)
    end
end

if inst.Name == "MinesGateButton" then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst.MainPart,"大门按钮", keycolor,true,false)
    end
    inst.Parent:WaitForChild("MinesGate").Main.SoundOpen.Played:Connect(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "GardenGateButton" then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst,"大门按钮", keycolor,true,false)
    end
    inst.Parent:WaitForChild("GardenGate").Collision.Sound.Played:Connect(function()
        inst:SetAttribute("ESP", false)
        inst:SetAttribute("ESPBlacklist", true)
    end)
end

if inst.Name == "Bridge" then
    for _, barrier in pairs(inst:GetChildren()) do
        if (barrier.Name == "PlayerBarrier" and barrier.Size.Y == 2.75 and (barrier.Rotation.X == 0 or barrier.Rotation.X == 180)) then
            local clone = barrier:Clone()
            clone.CFrame = clone.CFrame * CFrame.new(0, 0, -5)
            clone.Color = Color3.new(0, 0.666667, 1)
            clone.Name = ESPLibrary:GenerateRandomString()
            clone.Size = Vector3.new(clone.Size.X, clone.Size.Y, 11)
            clone.Transparency = 0.5
            clone.CanCollide = true
            clone.Parent = inst

            table.insert(Bridges, clone)
        end
    end
end

if inst.Name == "WaterPump" then
    table.insert(ObjectsTable.Keys,inst.Wheel)
    if Toggles.EssentialsESP.Value then
        esp(inst.Wheel,inst.Wheel,"水泵", keycolor,true,false)
        inst.Wheel:WaitForChild("Sound").Played:Connect(function()
            inst.Wheel:SetAttribute("ESP", false)
            inst.Wheel:SetAttribute("ESPBlacklist", true)
        end)
    end
end

if inst.Name == "GrumbleRig" then
    table.insert(ObjectsTable.Entities,inst)
    if Toggles.EntityESP.Value then
        esp(inst,inst,"Grumble", entitycolor,true,false)
    end
end

if inst.Name == "MouseHole" then
    table.insert(ObjectsTable.Chests,inst)
    if ItemESP == true then
        esp(inst,inst,"老鼠洞", chestcolor,true,false)
    end
end

if inst.Name == "LiveHintBook" then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst.Base,"书", keycolor,true,false)
    end
end

if inst.Name == "Seek_Arm" or inst.Name == "ChandelierObstruction" then
    table.insert(ObjectsTable.SeekObstructions, inst)
    if AntiSeekObstructions == true then
        for i,a in pairs(inst:GetDescendants()) do
            if a:IsA("BasePart") then
                a.CanTouch = false
            end
        end
    end
end

if inst.Name == "LiveBreakerPolePickup" then
    table.insert(ObjectsTable.Keys,inst)
    if Toggles.EssentialsESP.Value then
        esp(inst,inst.Base,"断路器", keycolor,true,false)
    end
end

if inst.Name == "SeekFloodline" then
    inst.CanCollide = Toggles.AntiSeekFlood.Value
    RenderConnections[ESPLibrary:GenerateRandomString()] = inst:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if inst.CanCollide ~= Toggles.AntiSeekFlood.Value then
            inst.CanCollide = Toggles.AntiSeekFlood.Value
        end
    end)
end

if inst.Name == "TriggerEventCollision" then
    if BypassSeek == true then
        DeleteCollision(inst)
    end
end

end)

for i,inst in pairs(game.Workspace:GetDescendants()) do
    if table.find(allowedInstances,inst.Name) or inst:IsA("ProximityPrompt") or table.find(Items2, inst.Name) then

		inst.Destroying:Connect(function()
			RemovefromTables(inst)
		end)

		


		if table.find(RequiresParentRoom, inst.Name) then
			GetRoom(inst, true)
		end



		if inst:IsA("ProximityPrompt") then

			table.insert(ObjectsTable.Prompts2, inst)

			if inst:GetAttribute("OldHoldTime") == nil then
				inst:SetAttribute("OldHoldTime",inst.HoldDuration)
			end
			if inst:GetAttribute("PromptClip") == nil then
				inst:SetAttribute("PromptClip",inst.RequiresLineOfSight)
			end
			if inst:GetAttribute("OldDistance") == nil then
				inst:SetAttribute("OldDistance",inst.MaxActivationDistance)
			end

			



			inst:SetAttribute("CanFire", true)

			local LockPrompts = {
				"UnlockPrompt",
				"SkullPrompt",
				"LockPrompt",
				"ThingToEnable",
				"FusesPrompt",
			}

			if inst.Parent ~= nil and inst.Parent.Name == "Lock" then
				inst:SetAttribute("UnlockPrompt", true)
			end

			if RemotesFolder:FindFirstChild("DropItem") and ExecutorSupport["fireproximityprompt"] == true then
				if table.find(LockPrompts, inst.Name) or inst.Parent ~= nil and inst.Parent:GetAttribute("Locked") == true or inst.Parent ~= nil and inst.Parent.Parent ~= nil and inst.Parent.Parent.Name == "Locker_Small_Locked" and inst.Name == "ActivateEventPrompt" then
					if inst.Name ~= "FakePrompt" then
						local NewPrompt = inst:Clone()
						NewPrompt.Name = "FakePrompt"
						NewPrompt.Parent = inst.Parent

						NewPrompt:SetAttribute("IsEnabled", inst.Enabled)

						local OriginalParent = inst.Parent

						inst.Parent = FakePromptPart

						NewPrompt.Enabled = inst.Enabled



						inst:SetAttribute("FakePrompt", true)

						NewPrompt:SetAttribute("OriginalName", inst.Name)

						inst:GetPropertyChangedSignal("Enabled"):Connect(function()

							if inst.Enabled == false then
								NewPrompt:Destroy()
								inst.Parent = OriginalParent
								NewPrompt:SetAttribute("IsEnabled", false)
							else
								NewPrompt.Enabled = true
								NewPrompt:SetAttribute("IsEnabled", true)

							end
						end)

						inst:GetPropertyChangedSignal("Parent"):Connect(function()
							if inst.Parent ~= FakePromptPart and NewPrompt:IsDescendantOf(workspace) then
								NewPrompt.Parent = inst.Parent
								inst.Parent = FakePromptPart
							end
						end)

						NewPrompt.Destroying:Connect(function()
							if inst:IsDescendantOf(workspace) then
								inst.Parent = OriginalParent
							end
						end)

						inst.Destroying:Connect(function()
							NewPrompt:Destroy()
						end)

						NewPrompt.Triggered:Connect(function()

							if InfiniteItemsCooldown == false then

								if Options.InfiniteItemsSelection.Value["Lockpicks"] and Character:FindFirstChild("Lockpick") and Toggles.InfiniteItems.Value then

									InfiniteItemsCooldown = true
									workspace.Drops.ChildAdded:Wait()
									fireproximityprompt(inst)

								elseif Options.InfiniteItemsSelection.Value["Shears"] and Character:FindFirstChild("Shears") and Toggles.InfiniteItems.Value then

									InfiniteItemsCooldown = true
									workspace.Drops.ChildAdded:Wait()
									fireproximityprompt(inst)

								elseif Options.InfiniteItemsSelection.Value["Multitool"] and Character:FindFirstChild("Multitool") and Toggles.InfiniteItems.Value then

									InfiniteItemsCooldown = true
									workspace.Drops.ChildAdded:Wait()
									fireproximityprompt(inst)

								elseif Options.InfiniteItemsSelection.Value["Skeleton Key"] and Character:FindFirstChild("SkeletonKey") and Toggles.InfiniteItems.Value then

									InfiniteItemsCooldown = true
									workspace.Drops.ChildAdded:Wait()
									fireproximityprompt(inst)

								else

									fireproximityprompt(inst)

								end
							end
						end)
					end
				end
			end

			if CanAutoInteract(inst) then

				table.insert(ObjectsTable.Prompts, inst)






			end

		end


		if inst.Name == "GoldPile" and inst:GetAttribute("GoldValue")  then
	
		
table.insert(ObjectsTable.Gold, inst)

	end


		if inst.Name == "Snare" then
			table.insert(ObjectsTable.Entities,inst)
			table.insert(ObjectsTable.Snares, inst)


		end


		if inst:FindFirstChild("HiddenPlayer") then
			RoomName = inst:GetAttribute("ParentRoom")
			local parts = {}
			local parts2 = inst:GetDescendants()
			if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
				parts2 = inst.Parent:GetDescendants()
			end
			for i,part in pairs(parts2) do
				if part:IsA("BasePart") then
					if part.Transparency == 0 then
						table.insert(parts,part)
						part:SetAttribute("Transparency", 0)
					end
				end

			end




			RenderConnections[ESPLibrary:GenerateRandomString()] = inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()

				if inst.HiddenPlayer.Value == Character and LastHidingSpot then
					LastHidingSpot.Value = inst
					if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
						LastHidingSpot.Value = inst.Parent
					end
				end

				if inst:FindFirstChild("HiddenPlayer") then
					if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
						for i,e in pairs(parts) do
							e.Transparency = TransparentClosetNumber

						end

					else
						for i,e in pairs(parts) do
							e.Transparency = 0

						end
					end
				end


			end)


		end






		if table.find(Items2, inst.Name) and inst:FindFirstChild("ModulePrompt") then

		table.insert(ObjectsTable.Items, inst)

end
	

		if inst.Name == "Toolshed_Small" then
			table.insert(ObjectsTable.Chests,inst)
		end

		if inst.Name == "Green_Herb" then
			table.insert(ObjectsTable.Items,inst)
		end


		if inst.Name == "KeyObtain"   then
			table.insert(ObjectsTable.Keys,inst)




		end

		if inst.Name == "LibraryHintPaper" then
			table.insert(ObjectsTable.Keys,inst)

		end	

		if inst.Name == "PickupItem" then
			table.insert(ObjectsTable.Keys,inst)

		end	




		if inst.Name == "Wax_Door" then
			inst:SetAttribute("OriginalPosition", inst:GetPivot())
			table.insert(ObjectsTable.RemovableModels, inst)

		end

		if inst.Name == "ThingToOpen" then
			inst:SetAttribute("OriginalPosition", inst:GetPivot())
			table.insert(ObjectsTable.RemovableModels, inst)

		end



		if inst.Name == "MovingDoor" then
			inst:SetAttribute("OriginalPosition", inst:GetPivot())
			table.insert(ObjectsTable.RemovableModels, inst)

		end






		if inst.Name == "Door" and inst:IsA("BasePart") then
			inst:SetAttribute("OriginalPosition", inst.Position)
			table.insert(ObjectsTable.DoorParts, inst)
		end




		if inst.Name == "Door" and inst:FindFirstChild("ClientOpen") and inst:FindFirstChild("Door") then

			table.insert(ObjectsTable.Doors,inst)

			

			if inst.Parent.Name == "49" and Floor == "Hotel" or inst.Parent.Name == "49" and Floor == "Fools" or inst.Parent.Name == "50" and Floor == "Hotel" or inst.Parent.Name == "50" and Floor == "Fools" then

				inst:SetAttribute("Door", true)


			else

				inst:WaitForChild("Door") 

				inst.Door:SetAttribute("Door", true)


			end

			local Connection
			Connection = RunService.Heartbeat:Connect(function()

				if Toggles.DoorReach.Value and Player:DistanceFromCharacter(inst:FindFirstChild("Door").Position) < 7 * Options.DoorReachMultiplier.Value then
					local Event = inst:FindFirstChild("ClientOpen")
					if Event then
						Event:FireServer()

					end
				end
			end)

			LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
				task.wait(0.25)
				
		
				LatestRoom:GetPropertyChangedSignal("Value"):Wait()
				Connection:Disconnect()
			end)


		end







		if inst.Name == "Ladder" and inst.PrimaryPart ~= nil
		then
			table.insert(ObjectsTable.Ladders,inst)

		end








		if inst.Name == "ChestBox" and inst:FindFirstChild("Main") or inst.Name == "ChestBoxLocked" and inst:FindFirstChild("Main") then
			table.insert(ObjectsTable.Chests,inst)



		end

		if inst.Name == "Chest_Vine" and inst:FindFirstChild("Main") then
			table.insert(ObjectsTable.Chests,inst)



		end

		if inst.Name == "Toolbox" or inst.Name == "Toolbox_Locked" then
			table.insert(ObjectsTable.Chests,inst)



		end


		if inst.Name == "MouseHole" then
			table.insert(ObjectsTable.Chests,inst)



		end

		if inst.Name == "Locker_Small_Locked" then
			table.insert(ObjectsTable.Chests, inst)



		end




		if inst.Name == "LeverForGate" and inst:FindFirstChild("Main")
		then
			table.insert(ObjectsTable.Keys,inst)
			inst:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)




		end

		if inst.Name == "VineGuillotine" and inst:FindFirstChild("Lever")
		then
			table.insert(ObjectsTable.Keys,inst)
			inst.Lever:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
				inst.Lever:SetAttribute("ESP", false)
				inst.Lever:SetAttribute("ESPBlacklist", true)
			end)




		end





		if inst.Name == "Wardrobe" and inst:FindFirstChild("Main")
		then
			table.insert(ObjectsTable.Closets,inst)


		end
		if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" or inst.Name == "Double_Bed"
		then
			table.insert(ObjectsTable.Closets,inst)


		end

		if inst:FindFirstChild("HiddenPlayer") then
			RoomName = inst:GetAttribute("ParentRoom")
			local parts = {}
			local parts2 = inst:GetDescendants()
			if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
				parts2 = inst.Parent:GetDescendants()
			end
			for i,part in pairs(parts2) do
				if part:IsA("BasePart") then

					table.insert(parts,part)
					part:SetAttribute("Transparency", part.Transparency)

				end

			end




			RenderConnections[ESPLibrary:GenerateRandomString()] = inst:FindFirstChild("HiddenPlayer"):GetPropertyChangedSignal("Value"):Connect(function()

				if inst.HiddenPlayer.Value == Character and LastHidingSpot then
					LastHidingSpot.Value = inst
					if inst.Name == "DoubleBed" or inst.Name == "DumpsterLeft" or inst.Name == "DumpsterRight" then
						LastHidingSpot.Value = inst.Parent
					end
				end

				if inst:FindFirstChild("HiddenPlayer") then
					if inst.HiddenPlayer.Value == Character and TransparentCloset == true then
						for i,e in pairs(parts) do
							e.Transparency = TransparentClosetNumber

						end

					else
						for i,e in pairs(parts) do
							e.Transparency = e:GetAttribute("Transparency")

						end
					end
				end


			end)


		end

		if inst.Name == "Toolshed" and inst:FindFirstChild("Main")
		then
			table.insert(ObjectsTable.Closets,inst)

		end

		if inst.Name == "Drakobloxxer" then
			table.insert(ObjectsTable.Entities, inst)
		end

		if inst.Name == "ElevatorBreaker" then
			BreakerConnection = inst:WaitForChild("SurfaceGui").Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
				task.wait()
				local BreakerID = inst:WaitForChild("SurfaceGui").Frame.Code.Text
				if tonumber(BreakerID) and AutoBreaker == true then
					for i,Breaker in pairs(inst:GetChildren()) do
						if Breaker.Name == "BreakerSwitch" then
							if Breaker:GetAttribute("ID") == tonumber(BreakerID) then
								if inst:WaitForChild("SurfaceGui").Frame.Code.Frame.BackgroundTransparency == 0 then
									EnableBreaker(Breaker)
								else
									DisableBreaker(Breaker)
								end
							end
						end
					end
				end

			end)
		end

		if inst.Name == "LotusPetalPickup" then
			table.insert(ObjectsTable.Items,inst)
			inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)
		end
		if inst.Name == "LotusHolder" then
			table.insert(ObjectsTable.Items,inst)
			inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions"):Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)
		end

		if inst.Name == "GlitchCube" then
			inst:WaitForChild("MainPart"):GetPropertyChangedSignal("Transparency"):Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)
		end

		if inst.Name == "Rooms_Locker" and inst:FindFirstChild("Base")


		then
			table.insert(ObjectsTable.Closets,inst)

		end

		if inst.Name == "Rooms_Locker_Fridge" and inst:FindFirstChild("Base")
		then
			table.insert(ObjectsTable.Closets,inst)


		end

		if inst.Name == "Locker_Large" and inst:FindFirstChild("Main")
		then
			table.insert(ObjectsTable.Closets,inst)


		end

		if inst.Name == "MinesAnchor" and inst:FindFirstChild("Sign") then
			inst:SetAttribute("Anchor", inst.Sign.TextLabel.Text)
			table.insert(ObjectsTable.Keys,inst)
			table.insert(ObjectsTable.Anchors,inst)
			inst:GetAttributeChangedSignal("Activated"):Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)
		end

		if inst.Name == "DoorFake" or inst.Name == "FakeDoor"  then
			if inst:FindFirstChild("Door") then
				table.insert(ObjectsTable.Dupe,inst:FindFirstChild("Door"))
			end
		end



		if inst.Name == "RetroWardrobe" and inst:FindFirstChild("Main")
		then
			table.insert(ObjectsTable.Closets,inst)

		end

		if inst.Name == "Bed" and inst:FindFirstChild("Main")
		then
			table.insert(ObjectsTable.Closets,inst)

		end

		if inst.Name == "Backdoor_Wardrobe" and inst:FindFirstChild("Main")  then
			table.insert(ObjectsTable.Closets,inst)	


		end

		if inst.Name == "CrouchPart" and inst:IsA("BasePart") then
			inst.CanCollide = false
		end

		if inst.Name == "ElectricalKeyObtain"   then
			table.insert(ObjectsTable.Keys,inst)

		end

		if inst.Name == "FuseObtain" then
			table.insert(ObjectsTable.Keys,inst)
			inst:WaitForChild("ModulePrompt"):GetAttributeChangedSignal("Interactions" .. Player.Name):Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)


		end

		if inst.Name == "Seek_Arm" or inst.Name == "ChandelierObstruction" then
			table.insert(ObjectsTable.SeekObstructions, inst)

		end	

		if inst.Name == "SideroomSpace" then
			table.insert(ObjectsTable.Dupe, inst)

		end


		if inst.Name == "StardustPickup"  then
			table.insert(ObjectsTable.Stardust,inst)



		end

		if inst.Name == "GroundsKeeper"  then
			table.insert(ObjectsTable.Entities,inst)
			table.insert(ObjectsTable.GardenEntities,inst)


		end

		if inst.Name == "RiftSpawn" then
			table.insert(ObjectsTable.RiftSpawn, inst)
		end

		if inst.Name == "LiveEntityBramble"  then
			table.insert(ObjectsTable.Entities,inst)
			table.insert(ObjectsTable.GardenEntities,inst)


		end

		if inst.Name == "MonumentEntity"  then
			table.insert(ObjectsTable.Entities,inst)
			table.insert(ObjectsTable.GardenEntities,inst)


		end



		if inst.Name == "LotusPetalPickup"  then
			table.insert(ObjectsTable.Items,inst)



		end

		if inst.Name == "Hole" and inst.Parent.Name == "MandrakeLive" then

			table.insert(ObjectsTable.Entities,inst)
		end

		if inst.Name == "Mandrake" and inst.Parent.Name == "MandrakeLive" then

			table.insert(ObjectsTable.Entities,inst)
		end



		if inst.Name == "CircularVent"
		then
			table.insert(ObjectsTable.Closets,inst)


		end

		if inst.Name == "Double_Bed" 
		then
			table.insert(ObjectsTable.Closets,inst)

		end

		if inst.Name == "Dumpster"
		then
			table.insert(ObjectsTable.Closets,inst)


		end

		if inst.Name == "MinesGenerator"  then
			table.insert(ObjectsTable.Keys,inst)
			inst:WaitForChild("Lever"):WaitForChild("Sound").Played:Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)							
			end)
		end
		if inst.Name == "WaterPump"  then
			table.insert(ObjectsTable.Keys,inst.Wheel)
			inst.Wheel:WaitForChild("Sound").Played:Connect(function()
				inst.Wheel:SetAttribute("ESP", false)
				inst.Wheel:SetAttribute("ESPBlacklist", true)							
			end)
		end

		if inst.Name == "KeyObtainFake"  then
			table.insert(ObjectsTable.Entities,inst)

		end

		if inst.Name == "GiggleCeiling" then
			table.insert(ObjectsTable.Entities,inst)


		end	

		if inst.Name == "MinesGateButton"  then
			table.insert(ObjectsTable.Keys,inst)
			inst.Parent:WaitForChild("MinesGate").Main.SoundOpen.Played:Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)


		end

		if inst.Name == "GardenGateButton"  then
			table.insert(ObjectsTable.Keys,inst)
			inst.Parent:WaitForChild("GardenGate").Collision.Sound.Played:Connect(function()
				inst:SetAttribute("ESP", false)
				inst:SetAttribute("ESPBlacklist", true)
			end)


		end





		if inst.Name == "GrumbleRig"  then
			table.insert(ObjectsTable.Entities,inst)


		end

		if inst.Name == "LiveHintBook" then
			table.insert(ObjectsTable.Keys,inst)





		end



		if inst.Name == "FigureRig" or inst.Name == "Figure" or inst.Name == "FigureRagdoll" then
			table.insert(ObjectsTable.Entities,inst)
			Figure = inst




































		end

		if inst.Name == "TimerLever" and inst:FindFirstChild("Main") then
			table.insert(ObjectsTable.Keys,inst)




		end

		if inst.Name == "LiveBreakerPolePickup" then
			table.insert(ObjectsTable.Keys,inst)






		end









	end

end






local UseAnimationParents = {
	"Key", 
	"ElectricalKey",
	"Lockpick",
	"Shears",
	"SkeletonKey",
	"Multitool",
	"KeyBackdoor",
	"IronKey",    
	"KeyIron"
}



local CharacterInstanceAddedConnection = Character.DescendantAdded:Connect(function(inst)
	if inst:IsA("Sound") and inst.Name == "Sound" and Toggles.RemoveFootstepSounds.Value then
			inst.Volume = 0 
		end	

	if inst.Name == "use" and inst:IsA("Animation") and table.find(UseAnimationParents, inst.Parent.Parent.Name) then 
		UseAnimation = Humanoid.Animator:LoadAnimation(inst)
	end

	if inst.Name == "usefinish" and inst:IsA("Animation") and table.find(UseAnimationParents, inst.Parent.Parent.Name) then 
		UseAnimationBreak = Humanoid.Animator:LoadAnimation(inst)
		UseAnimationBreak.Priority = Enum.AnimationPriority.Action4
	end

	if inst.Name == "lockpickuse" and inst:IsA("Animation") and table.find(UseAnimationParents, inst.Parent.Parent.Name) then 
		UseAnimationBreak = Humanoid.Animator:LoadAnimation(inst)
		UseAnimationBreak.Priority = Enum.AnimationPriority.Action4
	end


	if string.lower(inst.Name) == "promptanim" and inst:IsA("Animation") then 
		UseAnimation = Humanoid.Animator:LoadAnimation(inst)
		UseAnimation.Priority = Enum.AnimationPriority.Action4
	end

	if string.lower(inst.Name) == "promptanimend" and inst:IsA("Animation") then 
		UseAnimationBreak = Humanoid.Animator:LoadAnimation(inst)
		UseAnimationBreak.Priority = Enum.AnimationPriority.Action4
	end

end)

local count = 0
local active1 = true

for i,Plr in pairs(Players:GetPlayers()) do
    if Plr and Plr ~= Player then
        table.insert(ObjectsTable.Players, Plr)
        Plr.CharacterAdded:Connect(function(inst)
            task.wait(1)
            if Toggles.PlayerESP.Value then
                ESPLibrary:AddESP({
                    Object = inst,
                    Text = Plr.DisplayName,
                    Color = playercolor
                })
                Plr:GetAttributeChangedSignal("Alive"):Connect(function()
                    ESPLibrary:RemoveESP(inst)
                end)
            end
        end)
    end
end

local CurrentClockSmashed = false
local CurrentClockYours = false

RenderConnections[ESPLibrary:GenerateRandomString()] = LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
    CurrentRoom = LatestRoom.Value
end)

local WorkspaceChildAddedConnection = workspace.ChildAdded:Connect(function(child)
    task.wait()

    local inst = child

    inst.Destroying:Connect(function()
        RemovefromTables(inst)
    end)

    if child.Name == "Drakobloxxer" and Toggles.EntityESP.Value then
        ESPLibrary:AddESP({
            Object = child,
            Text = "Drakobloxxer",
            Color = entitycolor
        })
    end

    if child.Name == "51" then
        Player:SetAttribute("CurrentRoom","50")
    end

    if inst.Name == "GloombatSwarm" and Toggles.NotifyEntities.Value then
        if Options.NotifyMonsters.Value["Gloombat Swarm"] and Toggles.ChatNotify.Value then
            ChatNotify("一群Gloombat" .. ChatNotifyMessage)
        end
        if Options.NotifyMonsters.Value["Gloombat Swarm"] then
            Notify({Title = "实体警告", Description = "实体 'Gloombat群' 已生成。", Reason = "在接下来几个房间关闭灯光。", NotificationType = "警告", Image = EntityIcons["GloombatSwarm"]})
            Sound()
        end
    end

    if inst.Name == "SallyMoving" then
        table.insert(ObjectsTable.Entities, inst)
        if Options.NotifyMonsters.Value["Sally"] and Toggles.ChatNotify.Value and Toggles.NotifyEntities.Value then
            ChatNotify("Sally" .. ChatNotifyMessage)
        end
        if Options.NotifyMonsters.Value["Sally"] and Toggles.NotifyEntities.Value then
            Notify({Title = "实体警告", Description = "实体 'Sally' 已生成。", Reason = "给她丢一个物品。", NotificationType = "警告", Image = EntityIcons["SallyMoving"]})
            Sound()
        end

        if Toggles.EntityESP.Value then
            ESPLibrary:AddESP({
                Object = inst,
                Text = "Sally",
                Color = entitycolor
            })
        end
    end

    if inst.Name == "MonumentEntity" then
        table.insert(ObjectsTable.Entities, inst)
        table.insert(ObjectsTable.GardenEntities,inst)
        if Options.NotifyMonsters.Value["Monument"] and Toggles.ChatNotify.Value and Toggles.NotifyEntities.Value then
            ChatNotify("一座纪念碑" .. ChatNotifyMessage)
        end
        if Options.NotifyMonsters.Value["Monument"] and Toggles.NotifyEntities.Value then
            Notify({Title = "实体警告", Description = "实体 '纪念碑' 已生成。", Reason = "它只能在你没看它的时候移动。", NotificationType = "警告", Image = EntityIcons["MonumentEntity"]})
            Sound()
        end

        if Toggles.EntityESP.Value then
            ESPLibrary:AddESP({
                Object = inst.Top,
                Text = "纪念碑",
                Color = entitycolor
            })
        end
    end

    if child.Name == "RushMoving" and Toggles.AvoidEntities and Toggles.AvoidEntities.Value then
        AvoidEntity(child)
    end

    if child.Name == "AmbushMoving" and Toggles.AvoidEntities and Toggles.AvoidEntities.Value then
        AvoidEntity(child)
    end

    if child.Name == "100" then
        Player:SetAttribute("CurrentRoom","100")
    end

    if child.name == "BananaPeel" and Toggles.AntiBananaPeel then
        task.wait(0.5)
        child.CanTouch = not Toggles.AntiBananaPeel.Value
    end

    task.wait(0.25)

    if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then
        if NewHotel == true then
            RemotesFolder.MotorReplication:FireServer(-750)
        else
            RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)
        end
    end
end)

if Player:WaitForChild("PlayerGui").MainUI:FindFirstChild("AnchorHintFrame") then
    NotifyAnchorCode()
    SolveCurrentAnchor()
    for i,inst in pairs(ObjectsTable.Keys) do
        if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor():GetAttribute("Anchor") then
            esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
        else
            inst:SetAttribute("ESP", false)
        end
    end
    RenderConnections[ESPLibrary:GenerateRandomString()] = Player:WaitForChild("PlayerGui").MainUI:FindFirstChild("AnchorHintFrame").AnchorCode:GetPropertyChangedSignal("Text"):Connect(function()
        NotifyAnchorCode()
        SolveCurrentAnchor()
        for i,inst in pairs(ObjectsTable.Keys) do
            if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor():GetAttribute("Anchor") then
                esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
            else
                inst:SetAttribute("ESP", false)
            end
        end
    end)
end

Player:WaitForChild("PlayerGui").MainUI.ChildAdded:Connect(function(Child)
    if Child.Name == "AnchorHintFrame" then
        NotifyAnchorCode()
        SolveCurrentAnchor()
        for i,inst in pairs(ObjectsTable.Keys) do
            if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor():GetAttribute("Anchor") then
                esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
            else
                inst:SetAttribute("ESP", false)
            end
        end
        RenderConnections[ESPLibrary:GenerateRandomString()] = Child.AnchorCode:GetPropertyChangedSignal("Text"):Connect(function()
            NotifyAnchorCode()
            SolveCurrentAnchor()
            for i,inst in pairs(ObjectsTable.Keys) do
                if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor():GetAttribute("Anchor") then
                    esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
                else
                    inst:SetAttribute("ESP", false)
                end
            end
        end)
    end
end)

local SCCooldown = false

local Humanoid = Character:WaitForChild("Humanoid")
Humanoid.Died:Connect(function()
    if Floor == "Fools" and Toggles.InfiniteRevivesFools.Value or OldHotel == true and Toggles.InfiniteRevivesBeforePlus.Value then
        task.wait(1.5)
        RemotesFolder.Revive:FireServer()
        task.wait(3)
        if Player:DistanceFromCharacter(workspace.CurrentCamera.CFrame.Position) > 50 then
            while task.wait(1) do
                if Player:DistanceFromCharacter(workspace.CurrentCamera.CFrame.Position) < 50 then
                    break
                end
                RemotesFolder.Revive:FireServer()
            end
        end
    end
end)
Player.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")
    Humanoid.Died:Connect(function()
        if Floor == "Fools" and Toggles.InfiniteRevivesFools.Value or OldHotel == true and Toggles.InfiniteRevivesBeforePlus.Value then
            task.wait(1.5)
            RemotesFolder.Revive:FireServer()
            task.wait(3)
            if Player:DistanceFromCharacter(workspace.CurrentCamera.CFrame.Position) > 50 then
                while task.wait(1) do
                    if Player:DistanceFromCharacter(workspace.CurrentCamera.CFrame.Position) < 50 then
                        break
                    end
                    RemotesFolder.Revive:FireServer()
                end
            end
        end
    end)
end)

local lb = game.Lighting.Ambient
local solved = false

local AnticheatBypassConnection = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
    if MinesBypass == true then
        if Character:GetAttribute("Climbing") == true and MinesAnticheatBypassActive == false then
            MinesAnticheatBypassActive = true
            Notify({Title = "反作弊绕过", Description = "成功绕过反作弊系统！", Reason = "效果只能持续到下一个过场动画！"})
            Sound()
            Character:SetAttribute("Climbing",false)
        end
    end
end)

local AnticheatBypassConnection2 = RemotesFolder:WaitForChild("Cutscene").OnClientEvent:Connect(function(CutsceneName)
    if MinesAnticheatBypassActive == true and not string.find(CutsceneName, "SewerSeek") then
        MinesAnticheatBypassActive = false
        task.wait()
        Notify({Title = "反作弊绕过", Description = "反作弊绕过已失效。", Reason = "爬上梯子来修复它。"})
        Sound()
    end
end)

local CrouchConnection = Collision:GetPropertyChangedSignal("CollisionGroup"):Connect(function(Input)
    CrouchingValue.Value = (Collision.CollisionGroup == "PlayerCrouching" and true or false)
end)

local AnticheatBypassConnection3 = RemotesFolder:WaitForChild("UseEnemyModule").OnClientEvent:Connect(function(ModuleName)
    if Modules.Name == "Glitch" then
        Player:SetAttribute("CurrentRoom",CurrentRoom)
    end

    if ModuleName == "Void" or ModuleName == "Glitch" then
        task.wait()
        Player:SetAttribute("CurrentRoom",CurrentRoom)

        if MinesAnticheatBypassActive == true then
            MinesAnticheatBypassActive = false
            Notify({Title = "反作弊绕过", Description = "反作弊绕过已失效。", Reason = "爬上梯子来修复它。"})
            Sound()
        end
    end
end)

local JumpConnection = Character:GetAttributeChangedSignal("CanJump"):Connect(function()
	if Toggles.EnableJump.Value then
		Character:SetAttribute("CanJump", true)
	end
end)
local InfiniteJumpDebounce = false
local InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()


	if Toggles.InfiniteJumps.Value and InfiniteJumpDebounce == false and Toggles.EnableJump.Value or Toggles.EnableJump.Value and Humanoid.FloorMaterial ~= Enum.Material.Air and NewHotel == false then
		if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
			Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			InfiniteJumpDebounce = true
			task.wait(0.1)
			InfiniteJumpDebounce = false
		end
	end
end)

local InfiniteJumpConnection2

if NewHotel == true then
	InfiniteJumpConnection2 = Player.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Down:Connect(function()


		if Toggles.InfiniteJumps.Value and InfiniteJumpDebounce == false and Toggles.EnableJump.Value or Toggles.EnableJump.Value and Humanoid.FloorMaterial ~= Enum.Material.Air and NewHotel == false then
			if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
				Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				InfiniteJumpDebounce = true
				task.wait(0.1)
				InfiniteJumpDebounce = false
			end
		end
	end)
end

local PreviousOxygen = Character:GetAttribute("Oxygen") or 100
local OxygenConnection = Character:GetAttributeChangedSignal("Oxygen"):Connect(function()
	if Toggles.NotifyOxygen and Toggles.NotifyOxygen.Value then
		Caption("Oxygen Level: " .. GetRoundedNumber(Character:GetAttribute("Oxygen")) .. "%", tonumber(Character:GetAttribute("Oxygen")) < PreviousOxygen)
	end
	PreviousOxygen = Character:GetAttribute("Oxygen")
end)
local HidingConnection = Character:GetAttributeChangedSignal("Hiding"):Connect(function()
	if Character:GetAttribute("Hiding") == true and Floor == "Rooms" then
		task.wait(0.15)
		workspace.Terrain:ClearAllChildren()
	end
end)

local AutoPadlockConnection = game["Run Service"].Heartbeat:Connect(function()
	if not workspace.CurrentRooms:FindFirstChild("50") then
		return
	end
	local room = game.Workspace.CurrentRooms:FindFirstChild("50")
	if room and room:FindFirstChild("Door") and room.Door:FindFirstChild("Padlock") then
		local child = Character:FindFirstChild("LibraryHintPaper") or Player.Backpack:FindFirstChild("LibraryHintPaper") or Character:FindFirstChild("LibraryHintPaperHard") or game.Players.LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")
		if child ~= nil then
			local code = GetPadlockCode(child)
			local output, count = string.gsub(code, "_", "_")
			local padlock = workspace:FindFirstChild("Padlock", true)
			local part
			for i,e in pairs(padlock:GetDescendants()) do
				if e:IsA("BasePart") then
					part = e
				end
			end

			if tonumber(code) and Player:DistanceFromCharacter(part.Position) <= AutoLibraryUnlockDistance and Toggles.AutoUnlockPadlock.Value then

				RemotesFolder.PL:FireServer(code)




			end


			if Toggles.NotifyLibraryCode.Value and tonumber(code) and string.len(output) == 5 and solved == false and Floor ~= "Fools" or tonumber(code) and string.len(output) == 10 and Floor == "Fools" and solved == false then

				solved = true
	Notify({Title = "挂锁密码已找到", Description = "挂锁的密码是 '"..output.."'。", Time = room.Door.Padlock})
Sound()

end
end

end

end)

local PromptsCooldown = false
local PromptsConnection = RunService.Heartbeat:Connect(function()
    if not Toggles.AA.Value and Options.AutoInteractKeybind:GetState() ~= true or PromptsCooldown == true then
        return
    end

    PromptsCooldown = true

    for i, inst in pairs(ObjectsTable.Prompts) do
        if inst:GetAttribute("OldDistance") ~= nil then
            local ParentObject = inst.Parent
            local ParentDistance = 0

            if ParentObject then
                ParentDistance = Player:DistanceFromCharacter(ParentObject:IsA("Model") and ParentObject.PrimaryPart ~= nil and ParentObject.PrimaryPart.Position or ParentObject:IsA("Model") and ParentObject.WorldPivot.Position or ParentObject.Position)
            end

            if ParentDistance < inst:GetAttribute("OldDistance") * Options.ReachDistance.Value then
                forcefireproximityprompt(inst)
            end
        end
    end

    task.wait(Options.AutoInteractDelay.Value)

    PromptsCooldown = false
end)

local ncrp = RaycastParams.new()
ncrp.FilterType = Enum.RaycastFilterType.Exclude
local Bypassing = true
local acmcooldown = false
noclipbypassing = false

if ExecutorSupport["require"] == true then
    Toggles.NoCameraBobbing:OnChanged(function()
        Main_Game.spring.Speed = (Toggles.NoCameraBobbing.Value and 9e9 or 8)
    end)
end

local CameraDeadConnection = RunService.Heartbeat:Connect(function()
    if Player:GetAttribute("Alive") == true then
        return
    end

    local NearestDistance = math.huge
    local NearestPlayer
    for i,NewPlayer in pairs(ObjectsTable.Players) do
        if NewPlayer.Character then
            if NewPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local Distance = (workspace.CurrentCamera.CFrame.Position - NewPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
                if Distance < NearestDistance then
                    NearestPlayer = NewPlayer
                    NearestDistance = Distance
                end
            end
        end
    end
    if NearestPlayer ~= nil and Player:GetAttribute("Alive") == false then
        Player:SetAttribute("CurrentRoom", NearestPlayer:GetAttribute("CurrentRoom"))
    end
end)

local EyesActive = false

local EventHook

if ExecutorSupport["hookmetamethod"] == true and ExecutorSupport["newcclosure"] == true and ExecutorSupport["getnamecallmethod"] == true then
    EventHook = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local method = getnamecallmethod()
        local Args = {...}

        if tostring(self) == 'ClutchHeartbeat' and method == "FireServer" and Toggles.AutoHeartbeatMinigame and Toggles.AutoHeartbeatMinigame.Value then
            return
        end

        if tostring(self) == 'HideMonster' and method == "FireServer" and Toggles.AutoHeartbeatMinigame and Toggles.AutoHeartbeatMinigame.Value then
            return
        end

        if tostring(self) == 'ProjectileHit' and method == 'FireServer' and Toggles.SilentAim and Toggles.SilentAim.Value and Args[4] == nil and SilentAimTarget ~= nil then
            Args[2].Material = Enum.Material.Plastic
            Args[2].Instance = SilentAimTarget
            Args[2].Position = SilentAimTarget.Position
            return EventHook(self,unpack(Args))
        end

        if tostring(self) == 'FireProjectile' and method == 'FireServer' and Toggles.SilentAim and Toggles.SilentAim.Value and SilentAimTarget ~= nil then
            Args[2] = SilentAimTarget.Position
            return EventHook(self,unpack(Args))
        end

        if tostring(self) == 'FireToolProjectile' and method == 'Fire' and Toggles.SilentAim and Toggles.SilentAim.Value and SilentAimTarget ~= nil then
            Args[3] = SilentAimTarget.Position
            return EventHook(self,unpack(Args))
        end

        return EventHook(self,...)
    end))
end

local FOVConnection = RunService.RenderStepped:Connect(function()
    if ExecutorSupport["require"] == true then
        task.wait()
        Main_Game.fovtarget = fov
    else
        workspace.CurrentCamera.FieldOfView = fov
    end
end)

local BreakDoorConnection = RunService.Heartbeat:Connect(function()
    if Floor == "Retro" then return end
    if not isnetworkowner or not Toggles.BreakDoorAnimation then
        return
    end

    for i,Door in pairs(ObjectsTable.DoorParts) do
        if Toggles.BreakDoorAnimation.Value then
            if ExecutorSupport["isnetworkowner"] then
                if isnetworkowner(Door) then
                    if not Door:FindFirstChild("DoorBreakVelocity") then
                        local DoorBreakVelocity = Instance.new("BodyPosition")
                        DoorBreakVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                        DoorBreakVelocity.Parent = Door
                        DoorBreakVelocity.Name = "DoorBreakVelocity"
                    else
                        Door:FindFirstChild("DoorBreakVelocity").Position = Door:GetAttribute("OriginalPosition") + Vector3.new(math.random(-120,120),math.random(-120,120),math.random(-120,120))
                    end
                else
                    if Door:FindFirstChild("DoorBreakVelocity") then
                        Door:FindFirstChild("DoorBreakVelocity"):Destroy()
                    end
                end
            end
        else
            if Door:FindFirstChild("DoorBreakVelocity") then
                Door:FindFirstChild("DoorBreakVelocity"):Destroy()
            end
        end
    end
end)

local ClosestEntity = Instance.new("ObjectValue")
ClosestEntity.Name = "ClosestEntity"
ClosestEntity.Parent = game.ReplicatedStorage

local EntityPlaceholder = Instance.new("Model")
EntityPlaceholder.Name = "RushMoving"
EntityPlaceholder.Parent = game.ReplicatedStorage

local KeybindFixConnection = RunService.RenderStepped:Connect(function()
    if Toggles.Fly.Value or Options.FlyKeybind:GetState() == true then
        flytoggle = true
        fly.enabled = true
        fly.flyBody.Parent = Collision
    else
        flytoggle = false
        fly.enabled = false
        fly.flyBody.Parent = nil
    end

    if Toggles.Toggle50.Value or Options.ThirdPersonKeybind:GetState() == true then
        thirdp = true
    else
        thirdp = false
    end

    for i,Obj2 in pairs(ThirdPersonParts) do
        if Obj2.Parent ~= nil then
            Obj2.Transparency = (thirdp and 0 or 1)
        end
    end

    if Toggles.Noclip.Value or Options.NoclipKeybind:GetState() == true or bypassActive or AvoidingEntity == true then
        noclip = true
    else
        noclip = false
    end
end)

local previousgodmode = godmode
local MainConnectionCooldown = false

local MainConnection = RunService.RenderStepped:Connect(function()
    if not CollisionClone or Character:GetAttribute("SpeedBoostExtra") == nil then return end

    if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then
        EyesActive = true
        if NewHotel == true then
            RemotesFolder.MotorReplication:FireServer(-750)
        else
            RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)
        end
    else
        EyesActive = false
    end

    if NewHotel == true and Floor ~= "Party" then
        Humanoid.HipHeight = (Toggles.Godmode.Value and 0.09 or Options.GodmodeKeybind:GetState() == true and 0.09 or 2.4)
        Collision.Size = (Toggles.Godmode.Value and Vector3.new(1,3,3) or Options.GodmodeKeybind:GetState() == true and Vector3.new(1,3,3) or Vector3.new(5.5, 3, 3))
        CollisionClone.Size = (Toggles.Godmode.Value and Vector3.new(1,3,3) or Options.GodmodeKeybind:GetState() == true and Vector3.new(1,3,3) or Vector3.new(5.5, 3, 3))

        if Collision:FindFirstChild("CollisionCrouch") then
            Collision:FindFirstChild("CollisionCrouch").Size = (Toggles.Godmode.Value and Vector3.new(1,3,3) or Options.GodmodeKeybind:GetState() == true and Vector3.new(1,3,3) or Vector3.new(3,3,3))
        end
    end

    godmode = (Toggles.Godmode.Value and true or Options.GodmodeKeybind:GetState() == true and true or false)

    if Floor == "Fools" then
        Collision.Position = CollisionClone.Position - Vector3.new(0,(godmode == true and 5 or 0),0)
    end

    if RemotesFolder:FindFirstChild("Crouch") then
        RemotesFolder.Crouch:FireServer(Toggles.Godmode.Value and true or Options.GodmodeKeybind:GetState() == true and true or AntiFH == true and true or CrouchingValue.Value and true or false)
    end

    if godmode ~= previousgodmode and godmode == false and Character:GetAttribute("Hiding") ~= true and NewHotel == true then
        Character:PivotTo(Character:GetPivot()*CFrame.new(0,3,0))
    end

    previousgodmode = godmode

    if NewHotel == true then
        Player.PlayerGui.MainUI.MainFrame.Healthbar.Effects.Crouching.Visible = CrouchingValue.Value
    end

    if ExecutorSupport["require"] then
        if Toggles.ToolOffset.Value then
            Main_Game.tooloffset = Vector3.new(Options.ToolOffsetX.Value,Options.ToolOffsetY.Value,Options.ToolOffsetZ.Value)
        elseif Character:FindFirstChildOfClass("Tool") then
            Main_Game.tooloffset = (Character:FindFirstChildOfClass("Tool"):GetAttribute("ToolOffset") or Vector3.new(0,0,0))
        end
    end

    if ExecutorSupport["require"] and Toggles.NoCameraShake.Value then
        Main_Game.csgo = CFrame.new()
    end

    if Toggles.NoClosetDelay.Value and Humanoid.MoveDirection ~= Vector3.zero and CollisionPart.Anchored and Character:GetAttribute("ClientAnimating") ~= true and Character:GetAttribute("Hiding") == true then
        RemotesFolder.CamLock:FireServer()
    end

    if Toggles.NoClosetDelay.Value and Humanoid.MoveDirection ~= Vector3.zero and HumanoidRootPart.Anchored and Character:GetAttribute("ClientAnimating") ~= true and Character:GetAttribute("Hiding") == true then
        RemotesFolder.CamLock:FireServer()
    end

    if Toggles.RemoveJumpscares.Value then
        Jumpscare_Dread.Visible = false
        Jumpscare_Shade.Visible = false
    end

    if Toggles.NoFog.Value then
        game:GetService("Lighting").FogEnd = 100000
    end

    if Toggles.ACM.Value and Options.AnticheatManipulationMethod.Value == "Velocity" or Options.AnticheatManipulation:GetState() == true and Options.AnticheatManipulationMethod.Value == "Velocity" then
        bypassActive = true
    else
        bypassActive = false
    end

    if thirdp == true or Options.ThirdPersonKeybind:GetState() == true then
        game.Workspace.CurrentCamera.CFrame = game.Workspace.CurrentCamera.CFrame * CFrame.new(ThirdPersonX,ThirdPersonY,ThirdPersonZ)
    end

    if fb == true then
        local lighting = game:GetService("Lighting")
        game:GetService("TweenService"):Create(lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = Ambience}):Play()
    elseif Floor == "Fools" or OldHotel == true then
        local lighting = game:GetService("Lighting")
        game:GetService("TweenService"):Create(lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = OriginalAmbience}):Play()
    end

    CollisionClone.Position = HumanoidRootPart.Position

    if Toggles.AutoEatCandies and Toggles.AutoEatCandies.Value then
        if Player.Backpack:FindFirstChild("Candy") then
            local CharacterCandy = Character:FindFirstChild("Candy")
            local Candy = Player.Backpack:FindFirstChild("Candy")
            if CharacterCandy then
                if CharacterCandy:GetAttribute("CandyID") == "CandyCurious" and Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or CharacterCandy:GetAttribute("CandyID") == "CandyRed" and Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                    if Candy:GetAttribute("CandyID") == "CandyCurious" and not Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or Candy:GetAttribute("CandyID") == "CandyRed" and not Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                        Humanoid:EquipTool(Candy)
                    elseif Candy:GetAttribute("CandyID") ~= "CandyCurious" and Candy:GetAttribute("CandyID") ~= "CandyRed" then
                        Humanoid:EquipTool(Candy)
                    end
                end
            elseif not CharacterCandy then
                if Candy:GetAttribute("CandyID") == "CandyCurious" and not Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or Candy:GetAttribute("CandyID") == "CandyRed" and not Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                    Humanoid:EquipTool(Candy)
                elseif Candy:GetAttribute("CandyID") ~= "CandyCurious" and Candy:GetAttribute("CandyID") ~= "CandyRed" then
                    Humanoid:EquipTool(Candy)
                else
                    Candy.Name = "Candy_"
                    task.wait(1)
                    Candy.Name = "Candy"
                end
            end
        end
        if Character:FindFirstChild("Candy") then
            local Candy = Character:FindFirstChild("Candy")
            if Candy then
                if Candy:GetAttribute("CandyID") == "CandyCurious" and not Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or Candy:GetAttribute("CandyID") == "CandyRed" and not Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                    Candy:WaitForChild("Remote"):FireServer()
                elseif Candy:GetAttribute("CandyID") ~= "CandyCurious" and Candy:GetAttribute("CandyID") ~= "CandyRed" then
                    Candy:WaitForChild("Remote"):FireServer()
                end
            end
        end
    end



	if Player.PlayerGui:FindFirstChild("MainUI") and RemoveHideVignette == true then
		if Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("HideVignette") then
			Player.PlayerGui.MainUI.HideVignette.Visible = false
		else

			Player.PlayerGui.MainUI.MainFrame.HideVignette.Visible = false
		end
	end




	if Collision:FindFirstChild("CollisionCrouch") then
		Collision:FindFirstChild("CollisionCrouch").Position = HumanoidRootPart.Position - Vector3.new(0,1,0)
	end



local Figure = workspace:FindFirstChild("FigureRagdoll", true) or workspace:FindFirstChild("Figure", true)


					if Figure ~= nil then
						if Floor == "Fools" or OldHotel == true then
							if Floor == "Fools" and Toggles.GodmodeFigureFools.Value or OldHotel == true and Toggles.GodmodeFigureBeforePlus.Value then

								if Figure:FindFirstChild("Torso") and Player:DistanceFromCharacter(Figure.Torso.Position) < 20 then
									AvoidingFigure.Value = true
								else
									AvoidingFigure.Value = false
								end
							end

						end
					end


	onStep()

  if OldHotel == true  and GetNearestEntityDistance() >= 200 and AvoidingFigure.Value == false then
						
						Collision.Position = CollisionClone.Position
					end

					      if OldHotel == true  and GetNearestEntityDistance() < 200 or AvoidingFigure.Value == true then

							Collision.Position = CollisionClone.Position + Vector3.new(0,250,0)

						  end















	if  Toggles.ACM.Value and Options.AnticheatManipulationMethod.Value == "Pivot" and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false   or Options.AnticheatManipulation:GetState() == true and Options.AnticheatManipulationMethod.Value == "Pivot" and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false then
		if acmcooldown == false then

			Character:PivotTo(Character:GetPivot()*CFrame.new(0,0,500))



		end

	else








	end









	if Character ~= nil then
		if AvoidingEntity == true then
			Humanoid.WalkSpeed = 0
		elseif Character:GetAttribute("Climbing") == true then
			
				Humanoid.WalkSpeed = 15 + (Toggles.LadderSpeedEnabled and Options.LadderSpeed.Value or 0)
		
		else


			local CrouchNerf = 0




			if Collision and Collision.CollisionGroup == "PlayerCrouching" then
				CrouchNerf = (LiveModifiers:FindFirstChild("PlayerCrouchSlow") and 8 or LiveModifiers:FindFirstChild("PlayerSlow") and 8 or 5)
			else
				CrouchNerf = 0

			end
			
	Humanoid.JumpHeight = JumpBoost
			if SpeedBoostEnabled == true then
				RunService.Heartbeat:Wait()
				if not CollisionClone or Character:GetAttribute("SpeedBoostExtra") == nil then return end
				local num = 15 + (Character:GetAttribute("SpeedBoost") + Character:GetAttribute("SpeedBoostBehind") + Character:GetAttribute("SpeedBoostExtra") + Character:GetAttribute("SpeedBoostScript") + SpeedBoost - CrouchNerf)
				Humanoid.WalkSpeed = num

			end


		end

	end


	local function u2()



		if Humanoid.MoveDirection == Vector3.new(0, 0, 0) then

			local NewVelocity = Humanoid.MoveDirection



			return Humanoid.MoveDirection

		else


		end
		local v12 = (game.Workspace.CurrentCamera.CFrame * CFrame.new((CFrame.new(game.Workspace.CurrentCamera.CFrame.p, game.Workspace.CurrentCamera.CFrame.p + Vector3.new(game.Workspace.CurrentCamera.CFrame.lookVector.x, 0, game.Workspace.CurrentCamera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - game.Workspace.CurrentCamera.CFrame.p;
		if v12 == Vector3.new() then
			return v12
		end
		return v12.unit
	end

	if fly.enabled == true then
		local velocity = Vector3.zero

		velocity = u2()


		fly.flyBody.Velocity = velocity * (flyspeed)



	end



end)	

local HideTimeConnection = RemotesFolder.HideMonster.OnClientEvent:Connect(function()

    local hideTime = GetHideTime(CurrentRoom) or math.huge
    local finalTime = tick() + math.round(hideTime)

    if Toggles.NotifyHideTime and Toggles.NotifyHideTime.Value and hideTime ~= math.huge then
        while Character:GetAttribute("Hiding") and not Library.Unloaded and Toggles.NotifyHideTime.Value do
            local remainingTime = math.max(0, finalTime - tick()) - 10 - (Floor == "Fools" and 6 or LiveModifiers:FindFirstChild("HideTime") and 6 or 0)
		
	Caption("剩余藏匿时间: " .. string.format("%.1f", remainingTime) .. " 秒。", true)

task.wait(0.1)

end
end
end)

for i,part in pairs(Character:GetDescendants()) do
    if part:IsA("BasePart") then
        if part ~= CollisionCrouch and part ~= Collision and part ~= CollisionClone and part ~= HumanoidRootPart then
            part.CanCollide = false
            part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                RunService.Heartbeat:Wait()
                if part.CanCollide == true then
                    part.CanCollide = false
                end
            end)
        end
    end
end

local TouchConnection = AvoidingFigure:GetPropertyChangedSignal("Value"):Connect(function()
    for i,part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = not AvoidingFigure.Value
        end
    end
end)

AutoPaintingsCooldown = false
local AutoPaintingsConnection = RunService.Heartbeat:Connect(function()
    if AutoPaintingsCooldown == false and workspace:WaitForChild("CurrentRooms"):FindFirstChild(Player:GetAttribute("CurrentRoom")) then
        local Prop = Character:FindFirstChild("Prop")
        local PlacingDownCorrectly = false
        local Paintings = workspace:WaitForChild("CurrentRooms"):FindFirstChild(Player:GetAttribute("CurrentRoom")):WaitForChild("Assets", 9e9):FindFirstChild("Paintings")
        if not Paintings or not Toggles.AA.Value and Options.AutoInteractKeybind:GetState() ~= true then return end
        AutoPaintingsCooldown = true

        if not Paintings:FindFirstChild("Slots") then
            return
        end

        for i,Slot in pairs(Paintings:WaitForChild("Slots"):GetChildren()) do
            local Empty = false
            local Prompt = Slot:WaitForChild("PropPrompt")
            local SlotProp = Slot:FindFirstChild("Prop")

            if Player:DistanceFromCharacter(Slot.Position) <= Prompt.MaxActivationDistance and Prompt:GetAttribute("CanFire") ~= false then
                if Prop and Slot:GetAttribute("Hint") == Prop:GetAttribute("Hint") or not Prop and SlotProp and Slot:GetAttribute("Hint") ~= SlotProp:GetAttribute("Hint") then
                    fireproximityprompt(Prompt, 0)
                    Prompt:SetAttribute("CanFire", false)
                    local ReferenceValue = Instance.new("Part", game.ReplicatedStorage)
                    game:GetService("Debris"):AddItem(ReferenceValue, 0.25)
                    ReferenceValue.Destroying:Once(function()
                        Prompt:SetAttribute("CanFire", true)
                    end)
                end
            end
        end

        for i,Slot in pairs(Paintings:WaitForChild("Slots"):GetChildren()) do
            local Empty = false
            local Prompt = Slot:WaitForChild("PropPrompt")
            local SlotProp = Slot:FindFirstChild("Prop")

            if Player:DistanceFromCharacter(Slot.Position) <= Prompt.MaxActivationDistance and Prompt:GetAttribute("CanFire") ~= false then
                if SlotProp and Slot:GetAttribute("Hint") ~= SlotProp:GetAttribute("Hint") and Player:DistanceFromCharacter(Slot.Position) <= Prompt.MaxActivationDistance and not Prop then
                    fireproximityprompt(Prompt, 0)
                    Prompt:SetAttribute("CanFire", false)
                    local ReferenceValue = Instance.new("Part", game.ReplicatedStorage)
                    game:GetService("Debris"):AddItem(ReferenceValue, 0.25)
                    ReferenceValue.Destroying:Once(function()
                        Prompt:SetAttribute("CanFire", true)
                    end)
                end
            end
        end

        task.wait(0.3)
        AutoPaintingsCooldown = false
    end
end)

Player.CharacterAdded:Connect(function(NewCharacter)
    task.wait(0.5)
    Player.PlayerGui:WaitForChild("MainUI", 9e9)

    CollisionClone:Destroy()
    CollisionPartClone:Destroy()

    RunService.Heartbeat:Wait()
    Character = NewCharacter

    Collision = NewCharacter:WaitForChild("Collision")
    MainWeld = Collision:FindFirstChild("Weld") or Instance.new("ManualWeld")

    CollisionPart = Character:FindFirstChild("CollisionPart") or Collision

    CollisionClone = Collision:Clone()
    CollisionClone.Parent = NewCharacter
    CollisionClone.Name = ESPLibrary:GenerateRandomString()
    CollisionClone.Massless = true

    CollisionClone.Position = HumanoidRootPart.Position

    CollisionPartClone = CollisionPart:Clone()
    CollisionPartClone.Parent = NewCharacter
    CollisionPartClone.Name = ESPLibrary:GenerateRandomString()
    CollisionPartClone.Massless = true
    CollisionPartClone.Anchored = false

    Character.PrimaryPart = HumanoidRootPart

    Humanoid = NewCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = NewCharacter:WaitForChild("HumanoidRootPart")

    CollisionCrouch = Collision:FindFirstChild("CollisionCrouch") or Instance.new("Part")

    if NewCharacter:GetAttribute("SpeedBoost") == nil then
        NewCharacter:SetAttribute("SpeedBoost",0)
    end
    if NewCharacter:GetAttribute("SpeedBoostExtra") == nil then
        NewCharacter:SetAttribute("SpeedBoostExtra",0)
    end
    if NewCharacter:GetAttribute("SpeedBoostBehind") == nil then
        NewCharacter:SetAttribute("SpeedBoostBehind",0)
    end
    if NewCharacter:GetAttribute("SpeedBoostScript") == nil then
        NewCharacter:SetAttribute("SpeedBoostScript",0)
    end
    if CollisionClone:FindFirstChild("CollisionCrouch") then
        CollisionClone.CollisionCrouch.Massless = true
        CollisionClone.CollisionCrouch.CanCollide = false
        CollisionClone.CollisionCrouch.Name = ESPLibrary:GenerateRandomString()
    end

    ApplyScriptSpeedBoost()

    Character:SetAttribute("ClientAnimating", false)

    CollisionCrouch = Collision:FindFirstChild("CollisionCrouch") or Instance.new("Part")

    if flytoggle == true then
        fly.flyBody.Parent = Collision
    end

    RunService.Heartbeat:Wait()

    Jumpscares = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares") or Instance.new("Folder")

    if Toggles.EnableJump.Value then
        Character:SetAttribute("CanJump",true)
    end

    for i,part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if part ~= CollisionCrouch and part ~= Collision and part ~= CollisionClone and part ~= HumanoidRootPart then
                part.CanCollide = false
                part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                    RunService.Heartbeat:Wait()
                    if part.CanCollide == true then
                        part.CanCollide = false
                    end
                end)
            end
        end
    end

    table.clear(ThirdPersonParts)

    NewHead = Character:WaitForChild("Head"):Clone()
    NewHead.Parent = Character
    NewHead.LocalTransparencyModifier = 0
    NewHead.Transparency = (thirdp == true and 0 or 1)
    NewHead.Name = "FakeHead"
    NewHead:FindFirstChild("face", true):Destroy()
    table.insert(ThirdPersonParts, NewHead)

    for i,NewAccessory in pairs(Character:GetChildren()) do
        if NewAccessory:IsA("Accessory") and NewAccessory:FindFirstChild("Handle") then
            local Accessory = NewAccessory:Clone()
            Accessory.Handle.LocalTransparencyModifier = 0
            Accessory.Handle.Transparency = (thirdp == true and 0 or 1)
            Accessory.Name = Accessory.Name .. "_Fake"
            table.insert(ThirdPersonParts, Accessory.Handle)
            Accessory.Handle.Parent = Character
        end
    end

    CrouchConnection:Disconnect()

    CrouchConnection = Collision:GetPropertyChangedSignal("CollisionGroup"):Connect(function(Input)
        CrouchingValue.Value = (Collision.CollisionGroup == "PlayerCrouching" and true or false)
    end)

    if ExecutorSupport["require"] == true then
        Main_Game = require(Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game)
        CamShake = Main_Game.camShaker.ShakeOnce
    end
    Jam = (OldHotel == false and Player.PlayerGui.MainUI.Initiator.Main_Game.Health.Jam or Instance.new("Sound"))
    Jammin = (OldHotel == false and SoundService:WaitForChild("Main").Jamming or Instance.new("SoundGroup"))
    Modules = Player.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules

    EntityModules = ModulesClient.EntityModules
    Screech = Modules:FindFirstChild("Screech") or Modules:FindFirstChild("Screech_")

    Jumpscare_Rush = Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("Jumpscare_Rush") or Instance.new("Frame")
    Jumpscare_Ambush = Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("Jumpscare_Ambush") or Instance.new("Frame")
    Jumpscare_Shade = Player.PlayerGui.MainUI:FindFirstChild("Jumpscare_Shade", true) or Instance.new("Frame")
    Jumpscare_Dread = Player.PlayerGui.MainUI:FindFirstChild("Jumpscare_Dread", true) or Instance.new("Frame")

    Jumpscare_Rush_Sound = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Rush") or Instance.new("Sound")
    Jumpscare_Rush_Sound2 = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Rush2") or Instance.new("Sound")
    Jumpscare_Ambush_Sound = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Ambush") or Instance.new("Sound")
    Jumpscare_Ambush_Sound2 = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Ambush2") or Instance.new("Sound")
    Jumpscare_Seek_Sound = Player.PlayerGui:WaitForChild("MainUI").Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscare_Seek") or Instance.new("Sound")

    if ExecutorSupport["require"] == true and Toggles.NoCameraShake.Value then
        Main_Game.camShaker.ShakeOnce = function()
            return
        end
    end

    Dread = Instance.new("Folder")
    if Modules:FindFirstChild("A90") then
        A90 = Modules.A90
    end
    if Modules:FindFirstChild("Dread") then
        Dread = Modules.Dread
    end
    Timothy = Modules:FindFirstChild("SpiderJumpscare") or Modules:FindFirstChild("SpiderJumpscare_")

    if ExecutorSupport["require"] == true and Toggles.NoCameraBobbing.Value then
        Main_Game.spring.Speed = (Toggles.NoCameraBobbing.Value and 9e9 or 8)
    end

    if AntiScreech == true then
        Screech.Name = "Screech_"
    end

    if Toggles.AntiDread and Toggles.AntiDread.Value and Dread then
        Dread.Name = "Dread_"
    end
    if Toggles.RemoveA90 and Toggles.RemoveA90.Value and A90 then
        A90.Name = "A90_"
    end

    if Toggles.RemoveJamminMusic and Jam and Jammin then
        Jam.Playing = false
        Jammin.Enabled = false
    end

    if Toggles.DisableTimothyJumpscare and Timothy then
        Timothy.Name = "SpiderJumpscare_"
    end

    Jumpscares.Name = (Toggles.RemoveJumpscares.Value and "Jumpscares_" or "Jumpscares")
    Jumpscare_Rush.Name = (Toggles.RemoveJumpscares.Value and "Jumpscare_Rush_" or "Jumpscare_Rush")
    Jumpscare_Ambush.Name = (Toggles.RemoveJumpscares.Value and "Jumpscare_Ambush_" or "Jumpscare_Ambush")

    Jumpscare_Shade.Visible = (workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetAttribute("Shade") == true or workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetAttribute("RawName") and workspace.CurrentRooms:FindFirstChild(CurrentRoom):GetAttribute("RawName") == 'HaltHallway' and true or false)

    Jumpscare_Rush_Sound.SoundId = (Toggles.RemoveJumpscares.Value and "rbxassetid://0" or "rbxassetid://10483790459")
    Jumpscare_Rush_Sound2.SoundId = (Toggles.RemoveJumpscares.Value and "rbxassetid://0" or "rbxassetid://10483837590")

    Jumpscare_Ambush_Sound.SoundId = (Toggles.RemoveJumpscares.Value and "rbxassetid://0" or "rbxassetid://88807654977")
    Jumpscare_Ambush_Sound2.SoundId = (Toggles.RemoveJumpscares.Value and "rbxassetid://0" or "rbxassetid://9045199073")

    Jumpscare_Seek_Sound.SoundId = (Toggles.RemoveJumpscares.Value and "rbxassetid://0" or "rbxassetid://9145202614")

    Player.PlayerGui.MainUI.Initiator.Main_Game.PromptService.Triggered.Volume = (Toggles.RemoveInteractingSounds.Value and 0 or 0.04)
    Player.PlayerGui.MainUI.Initiator.Main_Game.PromptService.Holding.Volume = (Toggles.RemoveInteractingSounds.Value and 0 or 0.1)
    Player.PlayerGui.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = (Toggles.RemoveInteractingSounds.Value and 0 or 0.1)

    Player.PlayerGui.MainUI.Initiator.Main_Game.Health.Hit.Volume = (Toggles.RemoveDamageSounds.Value and 0 or 0.5)
    Player.PlayerGui.MainUI.Initiator.Main_Game.Health.Ringing.SoundId = (Toggles.RemoveDamageSounds.Value and "" or "rbxassetid://1517024660")
    if Player.PlayerGui.MainUI.Initiator.Main_Game.Health:FindFirstChild("HitShield") then
        Player.PlayerGui.MainUI.Initiator.Main_Game.Health.HitShield.Volume = (Toggles.RemoveDamageSounds.Value and 0 or 0.2)
    end

    for i,part in pairs(NewCharacter:GetDescendants()) do
        if part:IsA("BasePart") then
            PartProperties[part] = part.CustomPhysicalProperties
        end
    end

    if Toggles.NoAccell.Value then
        for i,part in pairs(NewCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = CustomPhysicalProperties
            end
        end
    end
    for i,room in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
        if tonumber(room.Name) == (CurrentRoom) then
            Player:SetAttribute("CurrentRoom",room.Name)
        end
    end

    MainConnection:Disconnect()
    AnticheatBypassConnection:Disconnect()
    AnticheatBypassConnection2:Disconnect()
    AnticheatBypassConnection3:Disconnect()
    CharacterInstanceAddedConnection:Disconnect()
    JumpConnection:Disconnect()
    InfiniteJumpConnection:Disconnect()
    if InfiniteJumpConnection2 then
        InfiniteJumpConnection2:Disconnect()
    end
    OxygenConnection:Disconnect()
    HidingConnection:Disconnect()
    CrouchConnection:Disconnect()
    RunService.Heartbeat:Wait()

    CrouchConnection = Character:GetAttributeChangedSignal("Crouching"):Connect(function()
        if not RemotesFolder:FindFirstChild("Crouch") then
            return
        end
    end)

    if Options.MaximumSlopeAngle then
        Humanoid.MaxSlopeAngle = Options.MaximumSlopeAngle.Value
    end

    if Toggles.EnableJump.Value then
        Character:SetAttribute("CanJump", true)
    end

    JumpConnection = Character:GetAttributeChangedSignal("CanJump"):Connect(function()
        if Toggles.EnableJump.Value then
            Character:SetAttribute("CanJump", true)
        end
    end)
    InfiniteJumpDebounce = false
    InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
        if Toggles.InfiniteJumps.Value and InfiniteJumpDebounce == false and Toggles.EnableJump.Value or Toggles.EnableJump.Value and Humanoid.FloorMaterial ~= Enum.Material.Air and NewHotel == false then
            if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
                Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                InfiniteJumpDebounce = true
                task.wait(0.1)
                InfiniteJumpDebounce = false
            end
        end
    end)

    if NewHotel == true then
        InfiniteJumpConnection2 = Player.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Down:Connect(function()
            if Toggles.InfiniteJumps.Value and InfiniteJumpDebounce == false and Toggles.EnableJump.Value or Toggles.EnableJump.Value and Humanoid.FloorMaterial ~= Enum.Material.Air and NewHotel == false then
                if game:GetService("UserInputService"):GetFocusedTextBox() == nil then
                    Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    InfiniteJumpDebounce = true
                    task.wait(0.1)
                    InfiniteJumpDebounce = false
                end
            end
        end)
    end

    PreviousOxygen = Character:GetAttribute("Oxygen") or 100
    OxygenConnection = Character:GetAttributeChangedSignal("Oxygen"):Connect(function()
        if Toggles.NotifyOxygen and Toggles.NotifyOxygen.Value then
            Caption("氧气水平: " .. GetRoundedNumber(Character:GetAttribute("Oxygen")) .. "%", tonumber(Character:GetAttribute("Oxygen")) < PreviousOxygen)
        end
        PreviousOxygen = Character:GetAttribute("Oxygen")
    end)

    HidingConnection = Character:GetAttributeChangedSignal("Hiding"):Connect(function()
        if Character:GetAttribute("Hiding") == true and Floor == "Rooms" then
            task.wait(0.15)
            workspace.Terrain:ClearAllChildren()
        end
    end)

    SCCooldown = false

    for i,part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            RenderConnections[ESPLibrary:GenerateRandomString()] = part:GetPropertyChangedSignal("CanTouch"):Connect(function()
                RunService.Heartbeat:Wait()
                if part.CanTouch == AvoidingFigure.Value then
                    part.CanTouch = not AvoidingFigure.Value
                end
            end)
        end
    end

    AnticheatBypassConnection = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
        if MinesBypass == true then
            if Character:GetAttribute("Climbing") == true and MinesAnticheatBypassActive == false then
                MinesAnticheatBypassActive = true

                Notify({Title = "反作弊绕过", Description = "成功绕过反作弊系统！", Reason = "效果只能持续到下一个过场动画！"})

                Sound()

                Character:SetAttribute("Climbing",false)
            end
        end
    end)

    AnticheatBypassConnection2 = RemotesFolder:WaitForChild("Cutscene").OnClientEvent:Connect(function(CutsceneName)

		if MinesAnticheatBypassActive == true and not string.find(CutsceneName, "SewerSeek") then


			task.wait()
Notify({Title = "反作弊绕过", Description = "反作弊绕过已失效。", Reason = "爬上梯子来修复它。"})

Sound()

MinesAnticheatBypassActive = false

end
end)

AnticheatBypassConnection3 = RemotesFolder:WaitForChild("UseEnemyModule").OnClientEvent:Connect(function(ModuleName)
    if Modules.Name == "Glitch" then
        Player:SetAttribute("CurrentRoom",CurrentRoom)
    end

    if ModuleName == "Void" or ModuleName == "Glitch" then
        task.wait()

        Player:SetAttribute("CurrentRoom",CurrentRoom)

        if MinesAnticheatBypassActive == true then
            Notify({Title = "反作弊绕过", Description = "反作弊绕过已失效。", Reason = "爬上梯子来修复它。"})

            Sound()

            MinesAnticheatBypassActive = false
        end
    end
end)

CharacterInstanceAddedConnection = Character.DescendantAdded:Connect(function(inst)
    if inst:IsA("Sound") and inst.Name == "Sound" and Toggles.RemoveFootstepSounds.Value then
        inst.Volume = 0
    end

    if inst.Name == "use" and inst:IsA("Animation") and table.find(UseAnimationParents, inst.Parent.Parent.Name) then
        UseAnimation = Humanoid.Animator:LoadAnimation(inst)
    end

    if inst.Name == "usefinish" and inst:IsA("Animation") and table.find(UseAnimationParents, inst.Parent.Parent.Name) then
        UseAnimationBreak = Humanoid.Animator:LoadAnimation(inst)
        UseAnimationBreak.Priority = Enum.AnimationPriority.Action4
    end

    if inst.Name == "lockpickuse" and inst:IsA("Animation") and table.find(UseAnimationParents, inst.Parent.Parent.Name) then
        UseAnimationBreak = Humanoid.Animator:LoadAnimation(inst)
        UseAnimationBreak.Priority = Enum.AnimationPriority.Action4
    end

    if string.lower(inst.Name) == "promptanim" and inst:IsA("Animation") then
        UseAnimation = Humanoid.Animator:LoadAnimation(inst)
        UseAnimation.Priority = Enum.AnimationPriority.Action4
    end

    if string.lower(inst.Name) == "promptanimend" and inst:IsA("Animation") then
        UseAnimationBreak = Humanoid.Animator:LoadAnimation(inst)
        UseAnimationBreak.Priority = Enum.AnimationPriority.Action4
    end
end)

MainConnectionCooldown = false

Player:WaitForChild("PlayerGui").MainUI.ChildAdded:Connect(function(Child)
    if Child.Name == "AnchorHintFrame" then
        NotifyAnchorCode()
        SolveCurrentAnchor()
        for i,inst in pairs(ObjectsTable.Keys) do
            if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor():GetAttribute("Anchor") then
                esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
            else
                inst:SetAttribute("ESP", false)
            end
        end
        RenderConnections[ESPLibrary:GenerateRandomString()] = Child.AnchorCode:GetPropertyChangedSignal("Text"):Connect(function()
            NotifyAnchorCode()
            SolveCurrentAnchor()
            for i,inst in pairs(ObjectsTable.Keys) do
                if Toggles.EssentialsESP.Value and inst:GetAttribute("Anchor") == GetCurrentAnchor():GetAttribute("Anchor") then
                    esp(inst,inst,"锚点".. " "..inst.Sign.TextLabel.Text, keycolor,true,false)
                else
                    inst:SetAttribute("ESP", false)
                end
            end
        end)
    end
end)

MainConnection = game["Run Service"].RenderStepped:Connect(function()
    if not CollisionClone or Character:GetAttribute("SpeedBoostExtra") == nil then return end

    if game.Workspace:FindFirstChild("Eyes") and AntiEyes == true or game.Workspace:FindFirstChild("BackdoorLookman") and AntiLookman == true then
        EyesActive = true

        if NewHotel == true then
            RemotesFolder.MotorReplication:FireServer(-750)
        else
            RemotesFolder.MotorReplication:FireServer(0, -450, 0, false)
        end
    else
        EyesActive = false
    end

    if NewHotel == true then
        Player.PlayerGui.MainUI.MainFrame.Healthbar.Effects.Crouching.Visible = CrouchingValue.Value
    end

    if RemotesFolder:FindFirstChild("Crouch") then
        RemotesFolder.Crouch:FireServer(godmode == true and true or AntiFH == true and true or CrouchingValue.Value == true and true or CrouchingValue.Value and true or false)
    end

    if ExecutorSupport["require"] then
        if Toggles.ToolOffset.Value then
            Main_Game.tooloffset = Vector3.new(Options.ToolOffsetX.Value,Options.ToolOffsetY.Value,Options.ToolOffsetZ.Value)
        elseif Character:FindFirstChildOfClass("Tool") then
            Main_Game.tooloffset = (Character:FindFirstChildOfClass("Tool"):GetAttribute("ToolOffset") or Vector3.new(0,0,0))
        end
    end

    if Toggles.RemoveJumpscares.Value then
        Jumpscare_Dread.Visible = false
        Jumpscare_Shade.Visible = false
    end

    if Toggles.NoClosetDelay.Value and Humanoid.MoveDirection ~= Vector3.zero and CollisionPart.Anchored and Character:GetAttribute("ClientAnimating") ~= true and Character:GetAttribute("Hiding") == true then
        RemotesFolder.CamLock:FireServer()
    end

    if Toggles.NoClosetDelay.Value and Humanoid.MoveDirection ~= Vector3.zero and HumanoidRootPart.Anchored and Character:GetAttribute("ClientAnimating") ~= true and Character:GetAttribute("Hiding") == true then
        RemotesFolder.CamLock:FireServer()
    end

    if NewHotel == true and Floor ~= "Party" then
        Humanoid.HipHeight = (Toggles.Godmode.Value and 0.09 or Options.GodmodeKeybind:GetState() == true and 0.09 or 2.4)
        Collision.Size = (Toggles.Godmode.Value and Vector3.new(1,3,3) or Options.GodmodeKeybind:GetState() == true and Vector3.new(1,3,3) or Vector3.new(5.5, 3, 3))
        CollisionClone.Size = (Toggles.Godmode.Value and Vector3.new(1,3,3) or Options.GodmodeKeybind:GetState() == true and Vector3.new(1,3,3) or Vector3.new(5.5, 3, 3))
        if Collision:FindFirstChild("CollisionCrouch") then
            Collision:FindFirstChild("CollisionCrouch").Size = (Toggles.Godmode.Value and Vector3.new(1,3,3) or Options.GodmodeKeybind:GetState() == true and Vector3.new(1,3,3) or Vector3.new(3,3,3))
        end
    end

    godmode = (Toggles.Godmode.Value and true or Options.GodmodeKeybind:GetState() == true and true or false)

    if Floor == "Fools" then
        Collision.Position = CollisionClone.Position - Vector3.new(0,(godmode == true and 5 or 0),0)
    end

    if RemotesFolder:FindFirstChild("Crouch") then
        RemotesFolder.Crouch:FireServer(Toggles.Godmode.Value and true or Options.GodmodeKeybind:GetState() == true and true or AntiFH == true and true or CrouchingValue.Value and true or false)
    end

    if godmode ~= previousgodmode and godmode == false and Character:GetAttribute("Hiding") ~= true and NewHotel == true then
        Character:PivotTo(Character:GetPivot()*CFrame.new(0,3,0))
    end

    previousgodmode = godmode

    if Toggles.NoFog.Value then
        game:GetService("Lighting").FogEnd = 100000
    end

    if Toggles.ACM.Value and Options.AnticheatManipulationMethod.Value == "Velocity" or Options.AnticheatManipulation:GetState() == true and Options.AnticheatManipulationMethod.Value == "Velocity" then
        bypassActive = true
    else
        bypassActive = false
    end

    if thirdp == true or Options.ThirdPersonKeybind:GetState() == true then
        game.Workspace.CurrentCamera.CFrame = game.Workspace.CurrentCamera.CFrame * CFrame.new(ThirdPersonX,ThirdPersonY,ThirdPersonZ)
    end

    if ExecutorSupport["require"] and Toggles.NoCameraShake.Value then
        Main_Game.csgo = CFrame.new()
    end

    if fb == true then
        local lighting = game:GetService("Lighting")
        game:GetService("TweenService"):Create(lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = Ambience}):Play()
    elseif Floor == "Fools" or OldHotel == true then
        local lighting = game:GetService("Lighting")
        game:GetService("TweenService"):Create(lighting,TweenInfo.new(1,Enum.EasingStyle.Exponential),{Ambient = OriginalAmbience}):Play()
    end

    local function u2()
        if Character:WaitForChild("Humanoid").MoveDirection == Vector3.new(0, 0, 0) then
            local NewVelocity = Character:WaitForChild("Humanoid").MoveDirection
            return Character:WaitForChild("Humanoid").MoveDirection
        else
        end
        local v12 = (game.Workspace.CurrentCamera.CFrame * CFrame.new((CFrame.new(game.Workspace.CurrentCamera.CFrame.p, game.Workspace.CurrentCamera.CFrame.p + Vector3.new(game.Workspace.CurrentCamera.CFrame.lookVector.x, 0, game.Workspace.CurrentCamera.CFrame.lookVector.z)):VectorToObjectSpace(Humanoid.MoveDirection)))).p - game.Workspace.CurrentCamera.CFrame.p;
        if v12 == Vector3.new() then
            return v12
        end
        return v12.unit
    end

    if fly.enabled == true then
        local velocity = Vector3.zero
        velocity = u2()
        fly.flyBody.Velocity = velocity * (flyspeed)
    end

    CollisionClone.Position = HumanoidRootPart.Position

    if Toggles.AutoEatCandies and Toggles.AutoEatCandies.Value then
        if Player.Backpack:FindFirstChild("Candy") then
            local CharacterCandy = Character:FindFirstChild("Candy")
            local Candy = Player.Backpack:FindFirstChild("Candy")
            if CharacterCandy then
                if CharacterCandy:GetAttribute("CandyID") == "CandyCurious" and Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or CharacterCandy:GetAttribute("CandyID") == "CandyRed" and Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                    if Candy:GetAttribute("CandyID") == "CandyCurious" and not Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or Candy:GetAttribute("CandyID") == "CandyRed" and not Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                        Humanoid:EquipTool(Candy)
                    elseif Candy:GetAttribute("CandyID") ~= "CandyCurious" and Candy:GetAttribute("CandyID") ~= "CandyRed" then
                        Humanoid:EquipTool(Candy)
                    end
                end
            elseif not CharacterCandy then
                if Candy:GetAttribute("CandyID") == "CandyCurious" and not Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or Candy:GetAttribute("CandyID") == "CandyRed" and not Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                    Humanoid:EquipTool(Candy)
                elseif Candy:GetAttribute("CandyID") ~= "CandyCurious" and Candy:GetAttribute("CandyID") ~= "CandyRed" then
                    Humanoid:EquipTool(Candy)
                else
                    Candy.Name = "Candy_"
                    task.wait(1)
                    Candy.Name = "Candy"
                end
            end
        end
        if Character:FindFirstChild("Candy") then
            local Candy = Character:FindFirstChild("Candy")
            if Candy then
                if Candy:GetAttribute("CandyID") == "CandyCurious" and not Options.AutoEatCandiesIgnoreList.Value["Volatile Starlight"] or Candy:GetAttribute("CandyID") == "CandyRed" and not Options.AutoEatCandiesIgnoreList.Value["Can-Die"] then
                    Candy:WaitForChild("Remote"):FireServer()
                elseif Candy:GetAttribute("CandyID") ~= "CandyCurious" and Candy:GetAttribute("CandyID") ~= "CandyRed" then
                    Candy:WaitForChild("Remote"):FireServer()
                end
            end
        end
    end

    if Player.PlayerGui:FindFirstChild("MainUI") and RemoveHideVignette == true then
        if Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("HideVignette") then
            Player.PlayerGui.MainUI.HideVignette.Visible = false
        else
            Player.PlayerGui.MainUI.MainFrame.HideVignette.Visible = false
        end
    end

    if Collision:FindFirstChild("CollisionCrouch") then
        Collision:FindFirstChild("CollisionCrouch").Position = HumanoidRootPart.Position - Vector3.new(0,1,0)
    end

    local Figure = workspace:FindFirstChild("FigureRagdoll", true) or workspace:FindFirstChild("Figure", true)

    if Figure ~= nil then
        if Floor == "Fools" or OldHotel == true then
            if Floor == "Fools" and Toggles.GodmodeFigureFools.Value or OldHotel == true and Toggles.GodmodeFigureBeforePlus.Value then
                if Figure:FindFirstChild("Torso") and Player:DistanceFromCharacter(Figure.Torso.Position) < 20 then
                    AvoidingFigure.Value = true
                else
                    AvoidingFigure.Value = false
                end
            end
        end
    end

    onStep()

    if OldHotel == true and GetNearestEntityDistance() >= 200 and AvoidingFigure.Value == false then
        Collision.Position = CollisionClone.Position
    end

    if OldHotel == true and GetNearestEntityDistance() < 200 or AvoidingFigure.Value == true then
        Collision.Position = CollisionClone.Position + Vector3.new(0,250,0)
    end

    if Toggles.ACM.Value and Options.AnticheatManipulationMethod.Value == "Pivot" and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false or Options.AnticheatManipulation:GetState() == true and Options.AnticheatManipulationMethod.Value == "Pivot" and Floor ~= "Fools" and OldHotel == false and MinesAnticheatBypassActive == false then
        if acmcooldown == false then
            Character:PivotTo(Character:GetPivot()*CFrame.new(0,0,500))
        end
    else
    end

    if Character ~= nil then
        if AvoidingEntity == true then
            Humanoid.WalkSpeed = 0
        elseif Character:GetAttribute("Climbing") == true then
            Humanoid.WalkSpeed = 15 + (Toggles.LadderSpeedEnabled and Options.LadderSpeed.Value or 0)
        else
            local CrouchNerf = 0

            if Collision and Collision.CollisionGroup == "PlayerCrouching" then
                CrouchNerf = (LiveModifiers:FindFirstChild("PlayerCrouchSlow") and 8 or LiveModifiers:FindFirstChild("PlayerSlow") and 8 or 5)
            else
                CrouchNerf = 0
            end

            Humanoid.JumpHeight = JumpBoost
            if SpeedBoostEnabled == true then
                RunService.Heartbeat:Wait()
                if not CollisionClone or Character:GetAttribute("SpeedBoostExtra") == nil then return end
                local num = 15 + (Character:GetAttribute("SpeedBoost") + Character:GetAttribute("SpeedBoostBehind") + Character:GetAttribute("SpeedBoostExtra") + Character:GetAttribute("SpeedBoostScript") + SpeedBoost - CrouchNerf)
                Humanoid.WalkSpeed = num
            end
        end
    end
end)
end)

local CameraChildConnection = workspace.CurrentCamera.ChildAdded:Connect(function(Child)
    if Child.Name == "GlitchScreech" and Toggles.RemoveScreech.Value or Child.Name == "Screech" and Toggles.RemoveScreech.Value then
        Child:Destroy()
    end
end)

if Character:GetAttribute("SpeedBoost") == nil then
    Character:SetAttribute("SpeedBoost",0)
end
if Character:GetAttribute("SpeedBoostExtra") == nil then
    Character:SetAttribute("SpeedBoostExtra",0)
end
if Character:GetAttribute("SpeedBoostBehind") == nil then
    Character:SetAttribute("SpeedBoostBehind",0)
end
if Character:GetAttribute("SpeedBoostScript") == nil then
    Character:SetAttribute("SpeedBoostScript",0)
end

ApplyScriptSpeedBoost()

SoundService.AmbientReverb = Enum.ReverbType.CarpettedHallway

local SoundConnection = SoundService:GetPropertyChangedSignal("AmbientReverb"):Connect(function()
    SoundService.AmbientReverb = Enum.ReverbType.CarpettedHallway
end)

local NoclipConnection = RunService.Heartbeat:Connect(function()
    if CollisionPart.Anchored or Character:GetAttribute("Hiding") == true or Toggles.ACM.Value or Options.AnticheatManipulation:GetState() == true then
        CollisionPartClone.Massless = true
    end

    if OldHotel == false and Floor ~= "Fools" then
        HumanoidRootPart.CanCollide = false
    end
    if Character:FindFirstChild("UpperTorso") then
        Character:WaitForChild("UpperTorso").CanCollide = false
        Character:WaitForChild("LowerTorso").CanCollide = false
    end
    Collision.CanCollide = false

    if Toggles.AutoRooms then
        HumanoidRootPart.CanCollide = Toggles.AutoRooms.Value
    end

    if NewHotel == true then
        if Character:GetAttribute("Stunned") == true then
            CollisionClone.CanCollide = true
            Collision.CanCollide = false

            if Collision:FindFirstChild("CollisionCrouch") and NewHotel == true then
                Collision:FindFirstChild("CollisionCrouch").CanCollide = true
            end
        elseif noclip == true then
            if Collision:FindFirstChild("CollisionCrouch") then
                Collision:FindFirstChild("CollisionCrouch").CanCollide = false
            end
            Collision.CanCollide = false
            CollisionClone.CanCollide = false
        elseif Collision.CollisionGroup == "PlayerCrouching" and noclip == false then
            Collision.CanCollide = false

            if Collision:FindFirstChild("CollisionCrouch") then
                Collision:FindFirstChild("CollisionCrouch").CanCollide = true
            end
            CollisionClone.CanCollide = false
        elseif Collision.CollisionGroup ~= "PlayerCrouching" and noclip == false then
            CollisionClone.CanCollide = true
            Collision.CanCollide = false

            if Collision:FindFirstChild("CollisionCrouch") and NewHotel == true then
                Collision:FindFirstChild("CollisionCrouch").CanCollide = false
            end
        end
    end
    if Floor == "Fools" or OldHotel == true then
        Collision.CollisionGroup = (Character:GetAttribute("Crouching") == true and "PlayerCrouching" or "Player")
        CollisionClone.CanCollide = false
        Collision.CanCollide = false

        if Collision:FindFirstChild("CollisionCrouch") then
            Collision:FindFirstChild("CollisionCrouch").CanCollide = false
        end

        HumanoidRootPart.CanCollide = not noclip
    end
end)

Automation:AddDivider()

Automation:AddToggle('AutoHide', {
    Default = false,
    Text = "自动藏柜",
    Tooltip = '自动帮你藏入柜子。',
    Disabled = Floor == "Retro",
    DisabledTooltip = "此功能在本楼层不可用。"
}):AddKeyPicker('AutoHideKeybind', {
    Default = 'Q',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = '自动藏柜',
    NoUI = false,
    Callback = function(Value)
    end,
    ChangedCallback = function(New)
    end
})

Automation:AddDropdown('AutoHideSpectateMode', {
    Values = {'玩家到实体', '实体到玩家'},
    Default = 1,
    Multi = false,
    Compact = true,

    Text = '观战模式',
    Tooltip = '选择观战方式。',
    Disabled = Floor == "Retro",
    DisabledTooltip = "此功能在本楼层不可用。"
})

Automation:AddToggle('AutoHideSpectateEntity', {
    Default = false,
    Text = '观战实体',
    Tooltip = '观战你正在躲避的实体。',
    Disabled = Floor == "Retro",
    DisabledTooltip = "此功能在本楼层不可用。"
})

	local AutoHideConnection = RunService.RenderStepped:Connect(function()
		if Toggles.AutoHide.Value or Options.AutoHideKeybind:GetState() == true then

			if Floor == "Retro" then
			return
		end
			
			if IsEntityActive() == false then
				return
			end

			if Toggles.AutoRooms and Toggles.AutoRooms.Value then
				return
			end

			





			local Entity = GetNearestEntity()

			if Entity and IsPlayerHiding() == true and Toggles.AutoHideSpectateEntity.Value then



				if Options.AutoHideSpectateMode.Value == 'Entity to Player' then
					workspace.CurrentCamera.CFrame = CFrame.lookAt(Entity.PrimaryPart.Position, Character:WaitForChild("Head").Position)
				else
					workspace.CurrentCamera.CFrame = CFrame.lookAt(Character:WaitForChild("Head").Position, Entity.PrimaryPart.Position)
				end

			end








			if Entity then
				local Closet = GetNearestCloset()
				if Closet then


					if ExecutorSupport["fireproximityprompt"] then

						forcefireproximityprompt(Closet:FindFirstChild("HidePrompt", true))

					else

						fixfireproximityprompt(Closet:FindFirstChild("HidePrompt", true))

					end




				end
			else

				if Character:GetAttribute("Hiding") == true and not Entity and Character:GetAttribute("AnimatingClient") ~= true then

					RemotesFolder:WaitForChild("CamLock"):FireServer()

				end
			end



		end


	end)

	table.insert(RenderConnections, AutoHideConnection)








local Unloading = false


function Unload()

	Library.ScreenGui.Enabled = false



	for i,Toggle in pairs(Toggles) do

		Toggle:SetValue(false)

	end






	MainConnection:Disconnect()
	HideTimeConnection:Disconnect()


	Connection5:Disconnect()
	NoclipConnection:Disconnect()

	JumpConnection:Disconnect()
	InfiniteJumpConnection:Disconnect()
	if InfiniteJumpConnection2 then
		InfiniteJumpConnection2:Disconnect()
	end
	OxygenConnection:Disconnect()
	HidingConnection:Disconnect()

	AnticheatBypassConnection:Disconnect()
	AnticheatBypassConnection2:Disconnect()
	AnticheatBypassConnection3:Disconnect()


	InfiniteItemsConnection:Disconnect()
	InfiniteItemsConnection2:Disconnect()
	InfiniteItemsConnection3:Disconnect()
	InfiniteCrucifixConnection:Disconnect()

	SpeedBypassConnection:Disconnect()


	if UseAnimation then
		UseAnimation:Stop()
	end


	SoundConnection:Disconnect()

	BreakDoorConnection:Disconnect()

	FOVConnection:Disconnect()

	ItemsConnection:Disconnect()
	HasteTimeConnection:Disconnect()

	PromptsConnection:Disconnect()

	PathfindingFolder:Destroy()


	AutoPadlockConnection:Disconnect()


	AutoPaintingsConnection:Disconnect()
	RoomAddedConnection:Disconnect()

	CameraChildConnection:Disconnect()
	CameraDeadConnection:Disconnect()


	NAC:Disconnect()

	for i, Accessory in pairs(ThirdPersonParts) do
		if Accessory ~= nil then
			Accessory:Destroy()
		end
	end


	NotifierConnection:Disconnect()


	if MinesRoomAddedConnection ~= nil then
		MinesRoomAddedConnection:Disconnect()
	end










	for i,Connection in pairs(RenderConnections) do
		if Connection ~= nil then
			Connection:Disconnect()
		end
	end



	for i,Connection in pairs(Connections) do
		if Connection ~= nil then
			Connection:Disconnect()
		end
	end



	for i,Object in pairs(DestroyElements) do
		if ObjectsTable ~= nil then
			Object:Destroy()
		end
	end





	if Player.PlayerGui:FindFirstChild("MainUI") and Character:GetAttribute("Hiding") == true then
		if Player.PlayerGui:WaitForChild("MainUI"):FindFirstChild("HideVignette") then
			Player.PlayerGui.MainUI.HideVignette.Visible = true
		else

			Player.PlayerGui.MainUI.MainFrame.HideVignette.Visible = true
		end
	end



	if Collision.CollisionGroup ~= "PlayerCrouching" then
		if RemotesFolder:FindFirstChild("Crouch") then
			task.wait()
			RemotesFolder.Crouch:FireServer(false)
		end
	end




	Collision.CanCollide = true
	CollisionClone:Destroy()
	CollisionPartClone:Destroy()
	PathfindingFolder:Destroy()



	PathfindingFolder:Destroy()


	fly.flyBody:Destroy()


















	for i,inst in pairs(game.Workspace:GetDescendants()) do


		if inst.Name == "AnchorSolved" then
			inst:Destroy()
		end

		if inst.Name == "FakePrompt" then
			inst:Destroy()
		end

		inst:SetAttribute("ESP", false)
		inst:SetAttribute("CurrentESP", false)




	end


	if ExecutorSupport["require"] == true then
		Main_Game.fovtarget = (Character:GetAttribute("SpeedBoost") > 0 and 90 or 70)
	end



	Humanoid.WalkSpeed = 15 - (Collision.CollisionGroup == "PlayerCrouching" and 5 or 0)





	game:GetService("TweenService"):Create(FOVValue, TweenInfo.new(1.25,Enum.EasingStyle.Exponential), {Value = 70}):Play()





	Library:Unload()
	ESPLibrary:Unload()




	getgenv().YX-HUBHubLoaded = false

	task.wait(1)

	SpeedBypassEnabled = false
	ForceSpeedBypass = false




if EventHook ~= nil then
hookmetamethod(game, "__namecall", EventHook)
end




	Halt.Name = "Shade"
	Screech.Name = "Screech"
	Timothy.Name = "SpiderJumpscare"
	A90.Name = "A90"
	Void.Name = "Void"
	Dread.Name = "Dread"

	for i,Prompt in pairs(ObjectsTable.Prompts2) do
		if Prompt:GetAttribute("OldHoldTime") then
			Prompt.HoldDuration = Prompt:GetAttribute("OldHoldTime")
		end
		if Prompt:GetAttribute("PromptClip") then
			Prompt.RequiresLineOfSight = Prompt:GetAttribute("PromptClip")
		end
		if Prompt:GetAttribute("OldDistance") then
			Prompt.MaxActivationDistance = Prompt:GetAttribute("OldDistance")
		end

	end


	table.clear(ObjectsTable.Prompts)

	for i,NewTable in pairs(ObjectsTable) do
		table.clear(NewTable)
	end


end	




task.wait()


MenuSettings = Tabs.UISettings:AddRightGroupbox("设置")

-- 我设置了NoUI，所以它不会在按键绑定菜单中显示

MenuSettings:AddToggle('KeybindMenu', {
    Text = '显示按键绑定',
    Default = false,
    Tooltip = '切换按键绑定菜单，显示所有按键绑定及其状态。',

    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})

MenuSettings:AddToggle('CustomCursor', {
    Text = '自定义光标',
    Default = (Library.IsMobile == false and true or false),
    Tooltip = '切换自定义光标。',

    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end
})

Library.ShowCustomCursor = (Library.IsMobile == false and true or false)

Library:SetWatermarkVisibility(false)

MenuSettings:AddLabel('切换按键'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = '界面显示/隐藏按键' })
MenuSettings:AddDivider()
MenuSettings:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",

    Text = "DPI 缩放",

    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)

        Library:SetDPIScale(DPI)
    end,
})

MenuSettings:AddButton({
    Text = "卸载",
    Tooltip = "完全卸载界面，禁用所有功能，让游戏恢复到执行前的状态。",
    DoubleClick = true,
    Func = function()
        Unload()
    end,
})

Library.ToggleKeybind = Options.MenuKeybind

Options.MenuKeybind:OnChanged(function(Value)
    Library.ToggleKeybind = Options.MenuKeybind
end)

local FloorFile = Floor

if OldHotel == true then
    FloorFile = "OldHotel"
end

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder(ScriptName)
SaveManager:SetFolder(ScriptName .. "/Doors/Game/" .. FloorFile)

ThemeManager:ApplyToTab(UISettings)

-- 1万行了我的天

SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(UISettings)

SaveManager:LoadAutoloadConfig()

if Floor == "Mines" then
    AddMinesTab()
elseif Floor == "Rooms" then
    AddRoomsTab()
elseif Floor == "Backdoor" then
    AddBackdoorTab()
elseif Floor == "Fools" then
    AddFoolsTab()
elseif OldHotel == true then
    AddBeforePlusTab()
elseif Floor == "Retro" then
    AddRetroTab()
elseif Floor == "Party" then
    AddPartyTab()
elseif Floor == "Garden" then
    AddGardenTab()
else
    AddHotelTab()
end

SpeedBypass()

ErrorConnection:Disconnect()

end

end