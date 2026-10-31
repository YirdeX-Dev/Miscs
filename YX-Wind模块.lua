--标签页边框模块 (自动检测新标签)
do
    local RunService = game:GetService("RunService")
    local cyan = Color3.fromHex("#00FFFF")
    local white = Color3.fromHex("#FFFFFF")

    local borders = {}

    local function addBorder(tabBtn)
        if not tabBtn or tabBtn:FindFirstChild("TabBtnBorder") then return end

        local border = Instance.new("Frame")
        border.Name = "TabBtnBorder"
        border.Size = UDim2.new(1, -3, 1, -3)
        border.AnchorPoint = Vector2.new(0.5, 0.5)
        border.Position = UDim2.new(0.5, 0, 0.5, 0)
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 0
        border.Parent = tabBtn

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 9)
        corner.Parent = border

        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 1.5
        stroke.Transparency = 0.1
        stroke.Parent = border

        borders[border] = stroke
    end

    local known = {}
    local function scan()
        for index, tab in pairs(Window.TabModule.Tabs) do
            if not known[index] then
                known[index] = true
                if tab.UIElements and tab.UIElements.Main then
                    addBorder(tab.UIElements.Main)
                end
            end
        end
    end

    scan()

    RunService.Heartbeat:Connect(function()
        scan()
        local wave = (math.sin(os.clock() * 2) + 1) / 2
        local color = cyan:Lerp(white, wave)
        for border, stroke in pairs(borders) do
            if border.Parent then
                stroke.Color = color
            else
                borders[border] = nil
            end
        end
    end)
end

--打开按钮模块
do
    local RunService = game:GetService("RunService")
    local btn = Window.OpenButtonMain and Window.OpenButtonMain.Button
    if btn then
        btn.BackgroundColor3 = Color3.fromHex("#0A1626")
        btn.BackgroundTransparency = 0.15
        local label = btn:FindFirstChildOfClass("TextLabel")
        if label then
            label.TextColor3 = Color3.new(1, 1, 1)
        end
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if stroke then
            local grad = stroke:FindFirstChildOfClass("UIGradient")
            if not grad then
                grad = Instance.new("UIGradient")
                grad.Parent = stroke
            end
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#00FFFF")),
                ColorSequenceKeypoint.new(1,   Color3.fromHex("#FFFFFF")),
            })

            local Speed = 120
            local baseThickness = stroke.Thickness

            task.spawn(function()
                local rot = 0
                while btn.Parent do
                    local dt = RunService.RenderStepped:Wait()
                    rot = (rot + Speed * dt) % 360
                    grad.Rotation = rot
                    stroke.Thickness = baseThickness + math.sin(os.clock() * 3) * 0.4
                end
            end)
        end
    end
end

--窗口边框模块
do
    local RunService = game:GetService("RunService")
    local main = Window.UIElements.Main

    for _, name in {"YXBorder", "RainbowStroke"} do
        local old = main:FindFirstChild(name)
        if old then old:Destroy() end
    end
    local bgImg = main:FindFirstChild("Background")
    if bgImg then
        local oldStroke = bgImg:FindFirstChildOfClass("UIStroke")
        if oldStroke then oldStroke:Destroy() end
    end

    local border = Instance.new("Frame")
    border.Name = "YXBorder"
    border.Size = UDim2.fromScale(1, 1)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 0
    border.Parent = main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = border

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 4
    stroke.Transparency = 0
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = border

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#00FFFF")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#FFFFFF")),
    })
    grad.Enabled = true
    grad.Parent = stroke

    local Speed = 120
    local baseThickness = 4

    task.spawn(function()
        local rot = 0
        while border.Parent do
            local dt = RunService.RenderStepped:Wait()
            rot = (rot + Speed * dt) % 360
            grad.Rotation = rot
            stroke.Thickness = baseThickness + math.sin(os.clock() * 3) * 0.4
        end
    end)
end

do
    local RunService = game:GetService("RunService")

    local guis = {
        WindUI.ScreenGui,
        WindUI.NotificationGui,
        WindUI.DropdownGui,
        WindUI.TooltipGui,
    }

    local function forceWhite(inst)
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            inst.TextColor3 = Color3.new(1, 1, 1)
            inst.TextTransparency = 0
        end
        if inst:IsA("TextBox") then
            inst.PlaceholderColor3 = Color3.new(1, 1, 1)
        end
    end

    local function sweep(gui)
        if not gui then return end
        for _, desc in gui:GetDescendants() do
            forceWhite(desc)
        end
    end

    for _, gui in ipairs(guis) do
        sweep(gui)
        if gui then
            gui.DescendantAdded:Connect(function(desc)
                task.defer(forceWhite, desc)
            end)
        end
    end

    RunService.Heartbeat:Connect(function()
        for _, gui in ipairs(guis) do
            sweep(gui)
        end
    end)
end


--通知美化模块
do
    local RunService = game:GetService("RunService")
    local cyan = Color3.fromHex("#00FFFF")
    local white = Color3.fromHex("#FFFFFF")

    local notifyBorders = {}

    local function addNotifyBorder(u)
        if not u or u:FindFirstChild("NotifyBorder") then return end
        if not u:FindFirstChild("DurationFrame", true) then return end

        local border = Instance.new("Frame")
        border.Name = "NotifyBorder"
        border.Size = UDim2.new(1, -3, 1, -3)
        border.AnchorPoint = Vector2.new(0.5, 0.5)
        border.Position = UDim2.new(0.5, 0, 0.5, 0)
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 0
        border.Parent = u

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 18)
        corner.Parent = border

        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 1.5
        stroke.Transparency = 0.1
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Parent = border

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#00FFFF")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#FFFFFF")),
        })
        grad.Enabled = true
        grad.Parent = stroke

        notifyBorders[border] = { stroke = stroke, grad = grad }
    end

    local holder = WindUI.NotificationGui and WindUI.NotificationGui:FindFirstChildWhichIsA("Frame")
    if holder then
        for _, child in holder:GetChildren() do
            if child:IsA("Frame") then
                addNotifyBorder(child)
            end
        end
        holder.ChildAdded:Connect(function(child)
            task.defer(function()
                if child:IsA("Frame") then
                    addNotifyBorder(child)
                end
            end)
        end)
    end

    local Speed = 120

    RunService.Heartbeat:Connect(function()
        local dt = RunService.Heartbeat:Wait()
        for border, parts in pairs(notifyBorders) do
            if border.Parent then
                parts.grad.Rotation = (parts.grad.Rotation + Speed * dt) % 360
            else
                notifyBorders[border] = nil
            end
        end
    end)
end
--顶栏标签渐变模块
do
    local RunService = game:GetService("RunService")
    local white = Color3.fromHex("#FFFFFF")
    local cyan = Color3.fromHex("#00FFFF")

    local holder = Window.UIElements.Main.Main.Topbar.Center.Holder
    local tagGrads = {}

    local function applyGradient(tagFrame)
        if not tagFrame or tagFrame:FindFirstChild("TagGrad") then return end

        tagFrame.ImageColor3 = Color3.new(1, 1, 1)   -- 基础色置白, 渐变乘算显色

        local grad = Instance.new("UIGradient")
        grad.Name = "TagGrad"
                grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#00B0FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#00E5FF")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#00B0FF")),
        })
        grad.Parent = tagFrame

        tagGrads[grad] = tagFrame
    end

    local function scan()
        for _, child in holder:GetChildren() do
            if child:IsA("ImageLabel") then
                applyGradient(child)
            end
        end
    end

    scan()
    holder.ChildAdded:Connect(function(child)
        task.defer(function()
            if child:IsA("ImageLabel") then
                applyGradient(child)
            end
        end)
    end)

    local Speed = 120
    local last = os.clock()

    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        local dt = now - last
        last = now

        for grad, frame in pairs(tagGrads) do
            if grad.Parent then
                grad.Rotation = (grad.Rotation + Speed * dt) % 360
                frame.ImageColor3 = Color3.new(1, 1, 1)   -- 防库的主题刷新覆盖底色
            else
                tagGrads[grad] = nil
            end
        end
    end)
end
