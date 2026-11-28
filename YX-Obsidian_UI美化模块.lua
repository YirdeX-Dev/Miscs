-- ==========================================
-- YX 批量 UI 美化模块（链接内容）
-- 由主结尾的 loadstring(game:HttpGet(链接))() 加载
-- 依赖：主脚本已把 Library 暴露到 getgenv().YX_Library
-- ==========================================

local RunSvc = game:GetService("RunService")
local Library = getgenv().YX_Library or getgenv().Library

-- ==========================================
-- YX 批量 UI 美化（修复版）
-- ① 标签页：黑白边框渐变（流动）+ 选中填充上深下浅
-- ② 窗口 / 可拖拽标签 / 按钮 / 复选框 / 下拉框 / 开关 / 颜色选择器 / 输入框 / 滑块 / 通知：上深下浅
-- ③ 分隔线：两端 → 中间 渐隐（无动画）
-- ==========================================

local YXFillTop = Color3.fromRGB(150, 150, 150)
local YXFillBottom = Color3.fromRGB(255, 255, 255)

-- 上深下浅（按钮/开关/下拉/颜色选择器/标签页选中 共用）
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

-- 把描边强制纯白并覆盖主题注册表（否则渐变乘上 OutlineColor 只剩 0~40 灰，看不见）
local function ForceWhiteStroke(stroke, thickness)
	if not stroke then return end
	stroke.Color = Color3.new(1, 1, 1)
	if thickness then
		stroke.Thickness = thickness
	end
	pcall(function()
		Library.Registry[stroke].Color = function()
			return Color3.new(1, 1, 1)
		end
	end)
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
	BorderStroke.Thickness = 3.5
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

-- ②③ 组件批量美化
local function BeautifyComponent(inst)
	if typeof(inst) ~= "Instance" or not inst:IsA("GuiObject") then return end

	-- 窗口主框（Name="Main"，直接挂在 ScreenGui 下）
	-- 填充：背景是 BackgroundColor（极暗，默认 15,15,15），乘法渐变可见范围只有 0~14 级
	--       → 顶部纯黑吃满整个范围，上深下浅最大化
	-- 边框：描边强制纯白 + 渐变注册进 BorderGrads → 与标签页同步流动（动画不靠这段代码驱动，
	--       靠下面的 EnsureBorderAnimation，注册即转）
	if inst:IsA("TextButton")
		and inst.Name == "Main"
		and inst.Parent == Library.ScreenGui
		and inst:FindFirstChildOfClass("UIStroke")
		and inst:FindFirstChildOfClass("UICorner") then
		ApplyFillGradient(inst, Color3.fromRGB(0, 0, 0))
		local stroke = inst:FindFirstChildOfClass("UIStroke")
		ForceWhiteStroke(stroke, 3.5)
		local bg = stroke:FindFirstChild("YX_BorderGrad")
		if not bg then
			bg = Instance.new("UIGradient")
			bg.Name = "YX_BorderGrad"
			bg.Parent = stroke
		end
		bg.Color = MakeTabBorderGradient()
		BorderGrads[bg] = true
		return
	end

	-- 可拖拽标签（AddDraggableLabel）：TextLabel + AutomaticSize XY + UICorner + UIStroke
	-- 同为极暗底 → 纯黑顶填充 + 黑白渐变边框（注册进 BorderGrads → 与标签页/窗口同步流动）
	if inst:IsA("TextLabel")
		and inst.AutomaticSize == Enum.AutomaticSize.XY
		and inst:FindFirstChildOfClass("UICorner")
		and inst:FindFirstChildOfClass("UIStroke") then
		ApplyFillGradient(inst, Color3.fromRGB(0, 0, 0))
		local stroke = inst:FindFirstChildOfClass("UIStroke")
		ForceWhiteStroke(stroke, 1)
		local bg = stroke:FindFirstChild("YX_BorderGrad")
		if not bg then
			bg = Instance.new("UIGradient")
			bg.Name = "YX_BorderGrad"
			bg.Parent = stroke
		end
		bg.Color = MakeTabBorderGradient()
		BorderGrads[bg] = true
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

	if inst:IsA("Frame") then
		-- 开关（Switch）：圆角拉满的 Frame + UIStroke + UIPadding，宽高比 ≈ 32:18
		local corner = inst:FindFirstChildOfClass("UICorner")
		if corner and corner.CornerRadius.Scale == 1
			and inst:FindFirstChildOfClass("UIStroke")
			and inst:FindFirstChildOfClass("UIPadding")
			and inst.Size.Y.Offset > 0
			and math.abs((inst.Size.X.Offset / inst.Size.Y.Offset) - (32 / 18)) < 0.25 then
			ApplyFillGradient(inst)
			return
		end

		-- 复选框（AddCheckbox）：方形 Frame（RelativeYY）+ UICorner + UIStroke + 对勾 ImageLabel
		-- 小尺寸 + 深色底 → 强规格（顶 40 ≈ 结果 4，底 25，差 21 级，一眼可见的上深下浅）
		if inst.SizeConstraint == Enum.SizeConstraint.RelativeYY
			and inst:FindFirstChildOfClass("UICorner")
			and inst:FindFirstChildOfClass("UIStroke")
			and inst:FindFirstChildOfClass("ImageLabel") then
			ApplyFillGradient(inst, Color3.fromRGB(40, 40, 40))
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

-- 动画连接：tick 驱动 + 活性自检，断开自动重建
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
		-- 保险一：Library.Tabs 表（标准库结构）
		for _, tab in pairs(Library.Tabs or {}) do
			if type(tab) == "table" and tab.Button then
				pcall(StyleTabButton, tab.Button)
			end
		end
		-- 保险二：结构扫描——侧边栏里所有"高 40 的 TextButton、父级是 ScrollingFrame"就是标签页按钮
		-- （不依赖 Tabs 表是否完整 / .Button 字段是否存在，杜绝"只有一个标签被渲染"）
		for _, d in ipairs(Library.ScreenGui:GetDescendants()) do
			if d:IsA("TextButton")
				and d.Size.Y.Offset == 40
				and d.Parent
				and d.Parent:IsA("ScrollingFrame") then
				pcall(StyleTabButton, d)
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
