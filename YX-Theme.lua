--[[YirdeX制作 | 开源 | 适配Wind UI美化模块
请不要当卑鄙的盗用者或者倒卖者]]


local WindUI = _G.WindUI
if not WindUI then
    error("YX-Beautify: 未找到 WindUI。请先执行主脚本后再加载此模块！")
end

local Window = _G.Window
local YXTheme = _G.YXTheme
local addGradientBorder = _G.addGradientBorder
local wallpaperFor = _G.wallpaperFor
local onEnterTheme = _G.onEnterTheme
local THEME_BACKGROUNDS = _G.THEME_BACKGROUNDS

-- ==========================================
-- 1. 背景图自动加载与切换
-- ==========================================
do
    local assetCache   = {}
    local pending      = {}
    local appliedTheme = nil
    local targetAsset  = nil

    local function sanitize(url)
        local name = url:match("([^/]+)$") or url
        name = name:gsub("%.[^%.]+$", "")
        name = name:gsub("[^%w%-_]", "_")
        if #name > 50 then name = name:sub(1, 50) end
        return name
    end

    local function extension(url)
        local clean = url:match("^([^?#]+)") or url
        local ext = clean:match("%.(%w+)$")
        if ext then
            ext = ext:lower()
            if ext == "jpg" or ext == "jpeg" or ext == "png" or ext == "webp" then
                return "." .. ext
            end
        end
        return ".png"
    end

    local function urlHash(s)
        local h = 5381
        for i = 1, #s do
            h = (h * 33 + s:byte(i)) % 1000000007
        end
        return tostring(math.floor(h))
    end

    local preloaded = {}
    local function preloadAsset(asset)
        if type(asset) ~= "string" or asset == "" or asset:match("^https?://") or preloaded[asset] then return end
        preloaded[asset] = true

        task.spawn(function()
            pcall(function()
                game:GetService("ContentProvider"):PreloadAsync({ asset })
            end)
            pcall(function()
                local gui = WindUI.ScreenGui
                if not gui then return end
                local probe = Instance.new("ImageLabel")
                probe.Name = "YXThemePreload"
                probe.Image = asset
                probe.Size = UDim2.fromOffset(1, 1)
                probe.Position = UDim2.fromOffset(-20, -20)
                probe.BackgroundTransparency = 1
                probe.BorderSizePixel = 0
                probe.Parent = gui
            end)
        end)
    end

    local function resolveAsset(url, callback)
        if url == "" then
            callback("")
            return
        end
        if not url:match("^https?://") then
            preloadAsset(url)
            callback(url)
            return
        end
        if assetCache[url] then
            preloadAsset(assetCache[url])
            callback(assetCache[url])
            return
        end
        if pending[url] then
            table.insert(pending[url], callback)
            return
        end
        pending[url] = { callback }

        task.spawn(function()
            local folder = Window.Folder or "Temp"
            local path = folder .. "/assets/." .. sanitize(url) .. "-" .. urlHash(url) .. extension(url)

            pcall(function()
                if isfile and not isfile(path) then
                    local body
                    if game.HttpGet then
                        body = game:HttpGet(url)
                    elseif WindUI.Creator and WindUI.Creator.Request then
                        body = WindUI.Creator.Request({
                            Url = url,
                            Method = "GET",
                            Headers = { ["User-Agent"] = "Roblox/Exploit" },
                        }).Body
                    end
                    if body and writefile then
                        writefile(path, body)
                    end
                end
            end)

            local asset = nil
            if getcustomasset then
                local ok, result = pcall(getcustomasset, path)
                if ok then asset = result end
            end
            if not asset then asset = url end

            assetCache[url] = asset
            local queue = pending[url]
            pending[url] = nil
            preloadAsset(asset)
            for _, cb in ipairs(queue or {}) do
                pcall(cb, asset)
            end
        end)
    end

    local function getBgImage()
        local main = Window.UIElements and Window.UIElements.Main
        if not main then return nil end

        local holder = main:FindFirstChild("Background") or main:FindFirstChild("Background", true)
        if holder then
            local img = holder:FindFirstChild("ImageLabel", true)
            if img and img:IsA("ImageLabel") then return img end
            for _, d in ipairs(holder:GetDescendants()) do
                if d:IsA("ImageLabel") and d.Size.X.Scale >= 0.9 and d.Size.Y.Scale >= 0.9 then
                    return d
                end
            end
        end

        for _, d in ipairs(main:GetDescendants()) do
            if d:IsA("ImageLabel") and d.Name ~= "Background"
                and d.Size.X.Scale >= 0.9 and d.Size.Y.Scale >= 0.9 then
                return d
            end
        end
        return nil
    end

    local function applyBackground(themeName)
        onEnterTheme(themeName)
        local url = wallpaperFor(themeName)
        if url == nil then
            if appliedTheme == nil then
                appliedTheme = themeName
                return
            end
            url = ""
        end
        resolveAsset(url, function(asset)
            if YXTheme.getName() ~= themeName then return end

            targetAsset = asset
            appliedTheme = themeName

            local img = getBgImage()
            if not img or not img:IsA("ImageLabel") then return end

            if asset == "" then
                if img.Visible then img.Visible = false end
                if img.Image ~= "" then img.Image = "" end
                return
            end

            if not img.Visible then img.Visible = true end
            if img.Image ~= asset then
                pcall(function()
                    img.Image = asset
                end)
            end
        end)
    end

    YXTheme.onChange(function(name)
        applyBackground(name)
    end)

    applyBackground(YXTheme.getName())

    task.spawn(function()
        for _, entry in pairs(THEME_BACKGROUNDS) do
            local list = type(entry) == "table" and entry or { entry }
            for _, url in ipairs(list) do
                resolveAsset(url, function(asset)
                    preloadAsset(asset)
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.15) do
            local name = YXTheme.getName()
            if name ~= appliedTheme then
                applyBackground(name)
            elseif targetAsset and targetAsset ~= "" then
                local img = getBgImage()
                if img and img:IsA("ImageLabel") and img.Image ~= targetAsset then
                    pcall(function() img.Image = targetAsset end)
                end
            end
        end
    end)
end

-- ==========================================
-- 2. 标签页边框模块
-- ==========================================
do
    local RunService = game:GetService("RunService")
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
        local p = YXTheme.getPalette()
        local wave = (math.sin(os.clock() * 2) + 1) / 2
        local color = p.waveA:Lerp(p.waveB, wave)
        for border, stroke in pairs(borders) do
            if border.Parent then
                stroke.Color = color
            else
                borders[border] = nil
            end
        end
    end)
end

-- ==========================================
-- 3. 打开按钮模块
-- ==========================================
do
    local RunService = game:GetService("RunService")
    local btn = Window.OpenButtonMain and Window.OpenButtonMain.Button
    if btn then
        local label = btn:FindFirstChild("TextLabel", true)
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        local grad = stroke and stroke:FindFirstChildOfClass("UIGradient")
        if stroke and not grad then
            grad = Instance.new("UIGradient")
            grad.Parent = stroke
        end

        local function applyPalette()
            local p = YXTheme.getPalette()
            if btn.BackgroundColor3 ~= p.openBtnBg then
                btn.BackgroundColor3 = p.openBtnBg
            end
            -- YX 流光文字（打开按钮 Title）由模块 9 接管，跳过主题色，避免破坏白基底
            if label and not label:GetAttribute("YXFlowText") and label.TextColor3 ~= p.openBtnText then
                label.TextColor3 = p.openBtnText
            end
            if grad then
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,   p.gradEdge),
                    ColorSequenceKeypoint.new(0.5, p.gradMid),
                    ColorSequenceKeypoint.new(1,   p.gradEdge),
                })
            end
        end

        btn.BackgroundTransparency = 0.15
        applyPalette()
        YXTheme.onChange(applyPalette)

        if stroke then
            local Speed = 120
            local baseThickness = stroke.Thickness
            task.spawn(function()
                local rot = 0
                while btn.Parent do
                    local dt = RunService.RenderStepped:Wait()
                    rot = (rot + Speed * dt) % 360
                    if grad then grad.Rotation = rot end
                    stroke.Thickness = baseThickness + math.sin(os.clock() * 3) * 0.4
                end
            end)
        end
    end
end

-- ==========================================
-- 4. 窗口边框模块
-- ==========================================
do
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

    addGradientBorder(main, {
        name = "YXBorder", radius = 16, thickness = 4, pulse = true,
    })
end

-- ==========================================
-- 5. 文字颜色自适应
-- ==========================================
do
    local guis = {
        WindUI.ScreenGui,
        WindUI.NotificationGui,
        WindUI.DropdownGui,
        WindUI.TooltipGui,
    }

    local function applyThemeText(inst, target)
        -- YX 流光文字（Title / Author / 打开按钮 Title）由模块 9 接管，跳过主题色与渐变禁用
        if inst:GetAttribute("YXFlowText") then return end
        if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then
            return
        end

        target = target or YXTheme.getTextColor()

        if inst.RichText and string.find(inst.Text, "<font color=", 1, true) then
            local hex = YXTheme.colorToHex(target)
            local text = inst.Text
            text = text:gsub('<font color="#[Ff][Ff][Ff][Ff][Ff][Ff]">', '<font color="' .. hex .. '">')
            text = text:gsub('<font color="rgb%(255,255,255%)">', '<font color="' .. hex .. '">')
            if text ~= inst.Text then inst.Text = text end
            return
        end

        if inst.TextColor3 ~= target then
            inst.TextColor3 = target
        end
        if inst.TextTransparency ~= 0 then
            inst.TextTransparency = 0
        end
        if inst.TextStrokeTransparency < 0.8 then
            inst.TextStrokeTransparency = 0.85
        end
        for _, child in ipairs(inst:GetChildren()) do
            if child:IsA("UIGradient") and child.Enabled then
                child.Enabled = false
            end
        end
    end

    local function sweep(gui)
        if not gui then return end
        local target = YXTheme.getTextColor()
        for _, desc in ipairs(gui:GetDescendants()) do
            applyThemeText(desc, target)
        end
    end

    local function sweepAll()
        for _, gui in ipairs(guis) do
            sweep(gui)
        end
    end

    sweepAll()

    for _, gui in ipairs(guis) do
        if gui then
            gui.DescendantAdded:Connect(function(desc)
                task.defer(applyThemeText, desc)
            end)
        end
    end

    YXTheme.onChange(function()
        task.defer(sweepAll)
    end)
end

-- ==========================================
-- 6. 通知美化模块
-- ==========================================
do
    local holder = WindUI.NotificationGui and WindUI.NotificationGui:FindFirstChildWhichIsA("Frame")
    if holder then
        local function tryAdd(u)
            if u:IsA("Frame") and u:FindFirstChild("DurationFrame", true) then
                addGradientBorder(u, {
                    name = "NotifyBorder", radius = 18, thickness = 1.5,
                    transparency = 0.1, inset = 3,
                })
            end
        end
        for _, child in holder:GetChildren() do
            tryAdd(child)
        end
        holder.ChildAdded:Connect(function(child)
            task.defer(function() tryAdd(child) end)
        end)
    end
end

-- ==========================================
-- 7. 顶栏标签渐变模块
-- ==========================================
do
    local RunService = game:GetService("RunService")
    local holder = Window.UIElements.Main.Main.Topbar.Center.Holder
    local tagGrads = {}

    local function tagSequence()
        local p = YXTheme.getPalette()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0,   p.tagA),
            ColorSequenceKeypoint.new(0.5, p.tagMid),
            ColorSequenceKeypoint.new(1,   p.tagB),
        })
    end

    local function applyGradient(tagFrame)
        if not tagFrame or tagFrame:FindFirstChild("TagGrad") then return end

        tagFrame.ImageColor3 = Color3.new(1, 1, 1)

        local grad = Instance.new("UIGradient")
        grad.Name = "TagGrad"
        grad.Color = tagSequence()
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

    YXTheme.onChange(function()
        local seq = tagSequence()
        for grad in pairs(tagGrads) do
            if grad.Parent then
                grad.Color = seq
            else
                tagGrads[grad] = nil
            end
        end
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
                frame.ImageColor3 = Color3.new(1, 1, 1)
            else
                tagGrads[grad] = nil
            end
        end
    end)
end

-- ==========================================
-- 8. 对话框专属边框模块
-- ==========================================
do
    local seq = 0
    local ATTACHED = "YXDialogBorderAttached"

    local function attach(panel)
        if not panel or not panel.Parent then return end
        if panel:GetAttribute(ATTACHED) then return end
        pcall(function() panel:SetAttribute(ATTACHED, true) end)
        seq = seq + 1
        addGradientBorder(panel.Parent, {
            name = "YXDialogBorder" .. seq,
            radius = 28, thickness = 3,
            fitTo = panel,
        })
    end

    local mainMain = Window.UIElements and Window.UIElements.Main and Window.UIElements.Main.Main

    pcall(function()
        local rawDialog = Window.Dialog
        if type(rawDialog) == "function" then
            Window.Dialog = function(self, ...)
                local dlg = rawDialog(self, ...)
                pcall(function()
                    if dlg and type(dlg) == "table" and dlg.UIElements then
                        attach(dlg.UIElements.MainContainer)
                    end
                end)
                return dlg
            end
        end
    end)

    if mainMain then
        local function looksLikeDialog(child)
            if not (child:IsA("ImageLabel") or child:IsA("Frame")) then return false end
            if (child.ZIndex or 0) < 9999 then return false end
            if child.AnchorPoint ~= Vector2.new(0.5, 0.5) then return false end
            return child:FindFirstChildWhichIsA("UIPadding", true) ~= nil
                or child:FindFirstChildWhichIsA("UIListLayout", true) ~= nil
        end

        mainMain.ChildAdded:Connect(function(child)
            task.defer(function()
                pcall(function()
                    if child.Parent == mainMain and looksLikeDialog(child) then
                        attach(child)
                    end
                end)
            end)
        end)
    end
end

-- ==========================================
-- 9. 标题 / 署名 / 打开按钮 Title 青白流光渐变
--    仿 Obsidian 库 MakeVioletBlackGradient 原理：每帧重建 ColorSequence，
--    一道白色高光带沿文字左右循环扫过，主色青色。
-- ==========================================
do
    local RunService = game:GetService("RunService")

    local FLOW_ATTR = "YXFlowText"        -- 模块 3 / 5 据此跳过这三处文字
    local GRAD_NAME = "YXTextFlow"

    -- 配色：青 -> 白（仅这两色，不掺其它颜色）
    local CYAN       = Color3.fromRGB(72, 219, 251)
    local WHITE      = Color3.new(1, 1, 1)
    local WHITE_BASE = Color3.new(1, 1, 1)   -- 文字白基底，让 UIGradient 原色完整呈现

    local STEPS     = 12       -- 色序关键点分段数
    local SPEED     = 0.35     -- 高光扫动速度（每秒循环圈数）
    local SEQ_STEPS = 60       -- 相位量化档数（缓存，避免每帧分配）
    local INTERVAL  = 1 / 30   -- 30fps 降频

    -- 每帧重建的色序：高光带位置随 phase 平移，青为主、白为扫过的高光
    local function buildSequence(phase)
        local keys = {}
        for i = 0, STEPS do
            local x = i / STEPS
            local s = math.sin((x - phase) * math.pi * 2)
            local w = (s + 1) / 2
            w = w * w                      -- 收窄白高光，使青色占主导
            keys[i + 1] = ColorSequenceKeypoint.new(x, CYAN:Lerp(WHITE, w))
        end
        return ColorSequence.new(keys)
    end

    local seqCache = {}
    local function getSequence(q)
        local seq = seqCache[q]
        if not seq then
            seq = buildSequence(q / SEQ_STEPS)
            seqCache[q] = seq
        end
        return seq
    end

    local flows = {}   -- [UIGradient] = TextLabel

    local function attach(label)
        if not label or label:GetAttribute(FLOW_ATTR) then return end
        pcall(function() label:SetAttribute(FLOW_ATTR, true) end)

        label.TextColor3       = WHITE_BASE
        label.TextTransparency = 0

        local grad = label:FindFirstChild(GRAD_NAME)
        if not grad or not grad:IsA("UIGradient") then
            grad = Instance.new("UIGradient")
            grad.Name   = GRAD_NAME
            grad.Parent = label
        end
        grad.Enabled  = true
        grad.Rotation = 0
        grad.Color    = getSequence(0)
        flows[grad]   = label
    end

    -- 精确定位三处文字（路径与模块 7 / 3 一致），并带轻量兜底
    local function collect()
        local out = {}
        local main     = Window.UIElements and Window.UIElements.Main
        local mainMain = main     and main:FindFirstChild("Main")
        local topbar   = mainMain and mainMain:FindFirstChild("Topbar")
        local left     = topbar   and topbar:FindFirstChild("Left")
        local box      = left     and left:FindFirstChild("Title")   -- 容器 Frame

        if box then
            for _, name in ipairs({"Title", "Author"}) do
                local t = box:FindFirstChild(name)
                if t and t:IsA("TextLabel") then out[#out + 1] = t end
            end
        else
            -- 兜底：仅认「父级是 Title 容器」的 Title，及独一无二的 Author，避免误伤标签页
            if main then
                for _, d in ipairs(main:GetDescendants()) do
                    if d:IsA("TextLabel") and
                       (d.Name == "Author" or (d.Name == "Title" and d.Parent and d.Parent.Name == "Title")) then
                        out[#out + 1] = d
                    end
                end
            end
        end

        local btn = Window.OpenButtonMain and Window.OpenButtonMain.Button
        if btn then
            local t = btn:FindFirstChild("TextLabel", true)
            if t and t:IsA("TextLabel") then out[#out + 1] = t end
        end
        return out
    end

    local function applyAll()
        for _, label in ipairs(collect()) do
            attach(label)
        end
    end

    applyAll()

    -- 低频兜底：捕获 SetAuthor 后补建、EditOpenButton 重设、对象被替换
    task.spawn(function()
        while task.wait(1.5) do
            applyAll()
        end
    end)

    -- 每帧推进相位；仅在量化档变化时写一次 Color（脏标记 + 30fps 降频）
    local phase, acc, lastQ, last = 0, 0, -1, os.clock()

    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        local dt  = now - last
        last = now
        acc  = acc + dt
        if acc < INTERVAL then return end
        local step = acc
        acc = 0

        phase = (phase + step * SPEED) % 1
        local q = math.floor(phase * SEQ_STEPS + 0.5) % SEQ_STEPS
        if q == lastQ then return end
        lastQ = q

        local seq = getSequence(q)
        for grad in pairs(flows) do
            if grad.Parent then
                grad.Color = seq
            else
                flows[grad] = nil
            end
        end
    end)
end

-- YX | 11月15日23时37分
