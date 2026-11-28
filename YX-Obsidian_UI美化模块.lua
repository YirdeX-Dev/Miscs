local RunSvc = game:GetService("RunService")
local Library = getgenv().YX_Library or getgenv().Library

local YXFillTop = Color3.fromRGB(150, 150, 150)
local YXFillBottom = Color3.fromRGB(255, 255, 255)

local function MakeVerticalFill()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, YXFillTop),
		ColorSequenceKeypoint.new(1, YXFillBottom),
	})
end

local function MakeTabBorderGradient()
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 18, 18)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
end

local BorderGrads = Library.__YXBorderGrads
if not BorderGrads then
	BorderGrads = setmetatable({}, { __mode = "k" })
	Library.__YXBorderGrads = BorderGrads
end

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

	ApplyFillGradient(TabButton)
end

local function BeautifyComponent(inst)
	if typeof(inst) ~= "Instance" or not inst:IsA("GuiObject") then return end

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

	if inst:IsA("TextLabel")
		and inst.AutomaticSize == Enum.AutomaticSize.XY
		and inst:FindFirstChildOfClass("UICorner")
		and inst:FindFirstChildOfClass("UIStroke") then
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

	if (inst:IsA("TextButton") or inst:IsA("TextBox"))
		and inst:FindFirstChildOfClass("UIStroke")
		and inst:FindFirstChildOfClass("UICorner") then
		ApplyFillGradient(inst)
		return
	end

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
		local corner = inst:FindFirstChildOfClass("UICorner")
		if corner and corner.CornerRadius.Scale == 1
			and inst:FindFirstChildOfClass("UIStroke")
			and inst:FindFirstChildOfClass("UIPadding")
			and inst.Size.Y.Offset > 0
			and math.abs((inst.Size.X.Offset / inst.Size.Y.Offset) - (32 / 18)) < 0.25 then
			ApplyFillGradient(inst)
			return
		end

		if inst.SizeConstraint == Enum.SizeConstraint.RelativeYY
			and inst:FindFirstChildOfClass("UICorner")
			and inst:FindFirstChildOfClass("UIStroke")
			and inst:FindFirstChildOfClass("ImageLabel") then
			ApplyFillGradient(inst, Color3.fromRGB(40, 40, 40))
			return
		end

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

local function stripAllBeauty()
	pcall(function()
		local c = Library.__YXBorderAnimConn
		if c then c:Disconnect() end
		Library.__YXBorderAnimConn = nil
	end)
	pcall(function()
		if Library.__YXBorderGrads then table.clear(Library.__YXBorderGrads) end
	end)
	pcall(function()
		if not Library.ScreenGui then return end
		for _, d in ipairs(Library.ScreenGui:GetDescendants()) do
			if d.Name == "YX_FillGrad" or d.Name == "YX_BorderGrad"
				or d.Name == "YX_DividerGrad" or d.Name == "YX_TabBorder"
				or d.Name == "YX_TabBorderGrad" then
				d:Destroy()
			end
		end
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

	Library.ScreenGui.DescendantAdded:Connect(function(inst)
		task.defer(function()
			if getgenv().YX_BeautyEnabled == false then return end
			pcall(BeautifyComponent, inst)
			if inst:IsA("TextButton") and inst.Size.Y.Offset == 40 then
				pcall(StyleTabButton, inst)
			end
		end)
	end)

	while true do
		task.wait(3)
		if Library.Unloaded then break end
		if getgenv().YX_BeautyEnabled == false then
			pcall(stripAllBeauty)
		else
			pcall(EnsureBorderAnimation)
			pcall(applyAll)
		end
	end
end)