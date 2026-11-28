-- ==========================================
-- YX 批量 UI 美化模块（链接内容）
-- 由主结尾的 loadstring(game:HttpGet(链接))() 加载
-- 依赖：主脚本已把 Library 暴露到 getgenv().YX_Library
-- ==========================================

local RunSvc = game:GetService("RunService")
local Library = getgenv().YX_Library or getgenv().Library

-- ==========================================
-- YX 批量 UI 美化（修复版）
-- ① 标签页：黑白边框渐变（流动，统一型）+ 选中填充上深下浅
-- ② 窗口 / 按钮 / 下拉框 / 开关 / 颜色选择器 / 输入框 / 滑块 / 通知：批量填充上深下浅（无动画）
-- ③ 分隔线：两端 → 中间 渐隐（无动画）
-- ==========================================

local YXFillTop = Color3.fromRGB(150, 150, 150)
local YXFillBottom = Color3.fromRGB(255, 255, 255)

-- 上深下浅（无动画，按钮/开关/下拉/颜色选择器/标签页选中 共用）
local function MakeVerticalFill()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, YXFillTop),
		ColorSequenceKeypoint.new(1, YXFillBottom),
	})
end

-- 统一边框渐变：两端同为白色、中间黑，旋转到任何角度两侧都一致
local function MakeTabBorderGradient()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 18, 18)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
end

-- 注册表持久化在 Library 上：重复执行脚本共用同一张表
local BorderGrads = Library.__YXBorderGrads
if not BorderGrads then
	BorderGrads = setmetatable({}, { __mode = "k" })
	Library.__YXBorderGrads = BorderGrads
end

-- 填充（按名字复用；top 可指定强度，已存在则刷新颜色）
local function ApplyFillGradient(gui, top)
	if not gui then return end
	local g = gui:FindFirstChild("YX_FillGrad")
	if not g then
		g = Instance.new("UIGradient")
		g.Name = "YX_FillGrad"
		g.Rotation = 90
		g.Parent = gui
	end
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, top or YXFillTop),
		ColorSequenceKeypoint.new(1, YXFillBottom),
	})
end

-- ① 标签页：边框渐变（流动）+ 选中填充上深下浅
local function StyleTabButton(TabButton)
	if typeof(TabButton) ~= "Instance" or not TabButton.Parent then return end

	local BorderStroke = TabButton:FindFirstChild("YX_TabBorder")
	if not BorderStroke then
		BorderStroke = Instance.new("UIStroke")
		BorderStroke.Name = "YX_TabBorder"
		BorderStroke.Parent = TabButton
	end
	BorderStroke.Color = Color3.fromRGB(255, 255, 255)
	BorderStroke.Thickness = 2
	BorderStroke.Transparency = 0.35
	BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local BorderGrad = BorderStroke:FindFirstChild("YX_TabBorderGrad")
	if not BorderGrad then
		BorderGrad = Instance.new("UIGradient")
		BorderGrad.Name = "YX_TabBorderGrad"
		BorderGrad.Parent = BorderStroke
	end
	BorderGrad.Color = MakeTabBorderGradient()
	BorderGrads[BorderGrad] = true

	-- 选中时内部填充上深下浅（与组件填充同一规格 → 统一型）
	ApplyFillGradient(TabButton)
end

-- ②③ 组件批量美化（无动画）
local function BeautifyComponent(inst)
	if typeof(inst) ~= "Instance" or not inst:IsA("GuiObject") then return end

	-- 主窗口：名为 "Main"、直接挂在 ScreenGui 下（底色近黑，需要更强压暗才可见）
	if inst:IsA("TextButton")
		and inst.Name == "Main"
		and inst.Parent == Library.ScreenGui
		and inst:FindFirstChildOfClass("UIStroke")
		and inst:FindFirstChildOfClass("UICorner") then
		ApplyFillGradient(inst, Color3.fromRGB(110, 110, 110))
		return
	end

	-- 窗口主框（Name="Main"）：背景是 BackgroundColor（极暗，默认 15,15,15），
	-- 乘法渐变在这么暗的底上可见范围只有 0~14 级 → 顶部用纯黑吃满整个范围，上深下浅最大化
	if inst:IsA("TextButton") and inst.Name == "Main"
		and inst:FindFirstChildOfClass("UICorner")
		and inst:FindFirstChildOfClass("UIStroke") then
		if not inst:FindFirstChild("YX_FillGrad") then
			local g = Instance.new("UIGradient")
			g.Name = "YX_FillGrad"
			g.Rotation = 90
			g.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
			})
			g.Parent = inst
		end
		return
	end

	-- 按钮 / 下拉显示框 / 颜色选择器色块 / 输入框 / 滑块轨道：(TextButton|TextBox) + UIStroke + UICorner
	if (inst:IsA("TextButton") or inst:IsA("TextBox"))
		and inst:FindFirstChildOfClass("UIStroke")
		and inst:FindFirstChildOfClass("UICorner") then
		ApplyFillGradient(inst)
		return
	end

	-- 通知卡片：AutomaticSize=Y + UICorner + UIStroke，父级是透明 Frame（FakeBackground）
	if inst:IsA("Frame")
		and inst.AutomaticSize == Enum.AutomaticSize.Y
		and inst:FindFirstChildOfClass("UICorner")
		and inst:FindFirstChildOfClass("UIStroke")
		and inst.Parent
		and inst.Parent:IsA("Frame")
		and inst.Parent.BackgroundTransparency == 1 then
		ApplyFillGradient(inst)
		return
	end

	-- 开关（Switch）：圆角拉满的 Frame + UIStroke + UIPadding，宽高比 ≈ 32:18
	if inst:IsA("Frame") then
		local corner = inst:FindFirstChildOfClass("UICorner")
		if corner and corner.CornerRadius.Scale == 1
			and inst:FindFirstChildOfClass("UIStroke")
			and inst:FindFirstChildOfClass("UIPadding")
			and inst.Size.Y.Offset > 0
			and math.abs((inst.Size.X.Offset / inst.Size.Y.Offset) - (32 / 18)) < 0.25 then
			ApplyFillGradient(inst)
			return
		end

		-- 分隔线：高 2px 的实底 Frame → 两端向中间渐隐（无动画）
		if inst.Size.Y.Offset == 2
			and inst.BackgroundTransparency == 0
			and not inst:FindFirstChild("YX_DividerGrad") then
			local g = Instance.new("UIGradient")
			g.Name = "YX_DividerGrad"
			g.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.2, 0.5),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(0.8, 0.5),
				NumberSequenceKeypoint.new(1, 1),
			})
			g.Parent = inst
		end
	end
end

-- 动画连接：活性自检 + 断开自动重建（看门狗），处理器 pcall 包裹
local function EnsureBorderAnimation()
	local conn = Library.__YXBorderAnimConn
	if conn and conn.Connected then return end
	Library.__YXBorderAnimConn = RunSvc.RenderStepped:Connect(function()
		pcall(function()
			if Library.Unloaded then return end
			local grads = Library.__YXBorderGrads
			if not grads then return end
			local rot = (tick() * 60) % 360
			for grad in pairs(grads) do
				if grad.Parent then
					grad.Rotation = rot
				else
					grads[grad] = nil
				end
			end
		end)
	end)
end

task.spawn(function()
	for _ = 1, 50 do
		if Library.ScreenGui then break end
		task.wait(0.1)
	end
	task.wait(0.5)
	if not Library.ScreenGui then return end

	local function applyAll()
		for _, tab in pairs(Library.Tabs or {}) do
			if type(tab) == "table" and tab.Button then
				pcall(StyleTabButton, tab.Button)
			end
		end
		for _, d in ipairs(Library.ScreenGui:GetDescendants()) do
			pcall(BeautifyComponent, d)
		end
	end
	applyAll()
	EnsureBorderAnimation()

	-- 动态监听：新开下拉菜单、新建标签、后加的组件自动补样式
	Library.ScreenGui.DescendantAdded:Connect(function(inst)
		task.defer(function()
			pcall(BeautifyComponent, inst)
			-- 标签页按钮固定高 40
			if inst:IsA("TextButton") and inst.Size.Y.Offset == 40 then
				pcall(StyleTabButton, inst)
			end
		end)
	end)

	-- 看门狗：每 3 秒检查连接是否还活着，死了立刻重建；顺带补扫新组件
	while true do
		task.wait(3)
		if Library.Unloaded then break end
		pcall(EnsureBorderAnimation)
		pcall(applyAll)
	end
end)