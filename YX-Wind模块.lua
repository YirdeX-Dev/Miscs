local YXTheme = (function()
    local listeners = {}
    local lastName = nil

    local function getName()
        local Creator = WindUI.Creator
        if Creator and type(Creator.Theme) == "table" and type(Creator.Theme.Name) == "string" then
            return Creator.Theme.Name
        end
        if type(WindUI.Theme) == "table" and type(WindUI.Theme.Name) == "string" then
            return WindUI.Theme.Name
        end
        local ok, name = pcall(function()
            return WindUI:GetCurrentTheme()
        end)
        if ok and type(name) == "string" and name ~= "" then
            return name
        end
        if type(WindUI.CurrentTheme) == "string" then
            return WindUI.CurrentTheme
        end
        if type(WindUI.CurrentTheme) == "table" and WindUI.CurrentTheme.Name then
            return WindUI.CurrentTheme.Name
        end
        return "Dark"
    end

    local function getTable()
        local Creator = WindUI.Creator
        if Creator and type(Creator.Theme) == "table" and Creator.Theme.Name then
            return Creator.Theme
        end
        if type(WindUI.Theme) == "table" and WindUI.Theme.Name then
            return WindUI.Theme
        end
        local name = getName()
        local ok, themes = pcall(function()
            return WindUI:GetThemes()
        end)
        local tbl = (ok and type(themes) == "table" and themes) or WindUI.Themes
        if type(tbl) == "table" and type(tbl[name]) == "table" then
            return tbl[name]
        end
        if type(WindUI.CurrentTheme) == "table" then
            return WindUI.CurrentTheme
        end
        return nil
    end

    local function toColor3(v)
        if typeof(v) == "Color3" then
            return v
        end
        if type(v) == "string" then
            local ok, c = pcall(Color3.fromHex, v)
            if ok and typeof(c) == "Color3" then
                return c
            end
            return nil
        end
        if type(v) == "table" then
            if typeof(v.Color) == "ColorSequence" then
                local kp = v.Color.Keypoints
                if kp and #kp > 0 then
                    local r, g, b = 0, 0, 0
                    for _, k in ipairs(kp) do
                        r = r + k.Value.R
                        g = g + k.Value.G
                        b = b + k.Value.B
                    end
                    return Color3.new(r / #kp, g / #kp, b / #kp)
                end
            end
            if typeof(v.Color) == "Color3" then
                return v.Color
            end
            if type(v["0"]) == "table" and typeof(v["0"].Color) == "Color3" then
                return v["0"].Color
            end
        end
        return nil
    end

    local function getTextColor()
        local theme = getTable()
        if theme and WindUI.Creator and type(WindUI.Creator.GetThemeProperty) == "function" then
            local ok, value = pcall(function()
                return WindUI.Creator:GetThemeProperty("Text", theme)
            end)
            if ok then
                local c = toColor3(value)
                if c then return c end
            end
        end
        if theme then
            local c = toColor3(theme.Text)
            if c then return c end
        end
        if type(WindUI.CurrentTheme) == "table" then
            local c = toColor3(WindUI.CurrentTheme.Text)
            if c then return c end
        end
        return Color3.new(1, 1, 1)
    end

    local function dispatch(name)
        lastName = name
        for _, fn in ipairs(listeners) do
            task.spawn(function()
                pcall(fn, name)
            end)
        end
    end

    local function onChange(fn)
        if type(fn) == "function" then
            table.insert(listeners, fn)
        end
    end

    lastName = getName()

    pcall(function()
        local Creator = WindUI.Creator
        if Creator and type(Creator.OnThemeChange) == "function" then
            Creator:OnThemeChange(function(newTheme)
                local name
                if type(newTheme) == "table" then
                    name = newTheme.Name
                elseif type(newTheme) == "string" then
                    name = newTheme
                end
                dispatch(name or getName())
            end)
        end
    end)

    task.spawn(function()
        while task.wait(0.3) do
            local name = getName()
            if name and name ~= lastName then
                dispatch(name)
            end
        end
    end)

    local PALETTES = {
        ["YX-Wind"] = {
            waveA = Color3.fromHex("#00FFFF"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#00FFFF"),
            tagA = Color3.fromHex("#00B0FF"), tagMid = Color3.fromHex("#00E5FF"), tagB = Color3.fromHex("#00B0FF"),
            openBtnBg = Color3.fromHex("#0A1626"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#00FFFF"),
        },
        ["YX-PinkWhite"] = {
            waveA = Color3.fromHex("#EA788C"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#EA788C"),
            tagA = Color3.fromHex("#F8B9C3"), tagMid = Color3.fromHex("#EA788C"), tagB = Color3.fromHex("#F8B9C3"),
            openBtnBg = Color3.fromHex("#FDF0F2"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#EA788C"),
        },
        ["YX-PurpleWhite"] = {
            waveA = Color3.fromHex("#A770DA"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#7C42D9"),
            tagA = Color3.fromHex("#C1A3DA"), tagMid = Color3.fromHex("#954AE7"), tagB = Color3.fromHex("#C1A3DA"),
            openBtnBg = Color3.fromHex("#1F1944"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#7C42D9"),
        },
        ["YX-CyanWhite"] = {
            waveA = Color3.fromHex("#809BCB"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#607DB7"),
            tagA = Color3.fromHex("#A7BCDE"), tagMid = Color3.fromHex("#809BCB"), tagB = Color3.fromHex("#A7BCDE"),
            openBtnBg = Color3.fromHex("#2A386B"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#607DB7"),
        },
        ["YX-CrimsonWhite"] = {
            waveA = Color3.fromHex("#AC6549"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#AC6549"),
            tagA = Color3.fromHex("#C4845D"), tagMid = Color3.fromHex("#81423F"), tagB = Color3.fromHex("#C4845D"),
            openBtnBg = Color3.fromHex("#1D1C21"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#AC6549"),
        },
        ["YX-GoldWhite"] = {
            waveA = Color3.fromHex("#E7B55A"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#E7B55A"),
            tagA = Color3.fromHex("#F8D050"), tagMid = Color3.fromHex("#BE832B"), tagB = Color3.fromHex("#F8D050"),
            openBtnBg = Color3.fromHex("#F8F6F2"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#E7B55A"),
        },
    }

    local paletteCache = {}

    local function colorToHex(c)
        return string.format("#%02X%02X%02X",
            math.floor(c.R * 255 + 0.5),
            math.floor(c.G * 255 + 0.5),
            math.floor(c.B * 255 + 0.5))
    end

    local function getPalette()
        local name = getName()
        if paletteCache[name] then return paletteCache[name] end

        local p = PALETTES[name]
        if not p then
            local theme = getTable()
            local main = Color3.fromHex("#EA788C")
            if theme and WindUI.Creator and type(WindUI.Creator.GetThemeProperty) == "function" then
                local ok, c = pcall(function()
                    return WindUI.Creator:GetThemeProperty("Outline", theme)
                end)
                if ok and typeof(c) == "Color3" then main = c end
            end
            local white = Color3.fromHex("#FFFFFF")
            p = {
                waveA = main, waveB = white,
                gradEdge = white, gradMid = main,
                tagA = main:Lerp(white, 0.5), tagMid = main, tagB = main:Lerp(white, 0.5),
                openBtnBg = white,
                btnGradA = white, btnGradB = main,
            }
        end

        p.openBtnText = getTextColor()
        paletteCache[name] = p
        return p
    end

    return {
        getName = getName,
        getTable = getTable,
        getTextColor = getTextColor,
        getPalette = getPalette,
        colorToHex = colorToHex,
        onChange = onChange,
    }
end)()

local addGradientBorder
do
    local RunService = game:GetService("RunService")
    local borders = {}
    local Speed = 120
    local last = os.clock()

    local function gradient()
        local p = YXTheme.getPalette()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0,   p.gradEdge),
            ColorSequenceKeypoint.new(0.5, p.gradMid),
            ColorSequenceKeypoint.new(1,   p.gradEdge),
        })
    end

    addGradientBorder = function(target, opts)
        if not target or not opts or not opts.name then return end
        if target:FindFirstChild(opts.name) then return end

        local fitTo = opts.fitTo

        local border = Instance.new("Frame")
        border.Name = opts.name
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 0
        border.Active = false
        if fitTo then
            border.AnchorPoint = Vector2.new(0, 0)
            border.Size = UDim2.fromOffset(0, 0)
            border.Position = UDim2.fromOffset(0, 0)
            border.Visible = false
            border.ZIndex = (fitTo.ZIndex or 1) + 1
        elseif opts.inset then
            border.Size = UDim2.new(1, -opts.inset, 1, -opts.inset)
            border.AnchorPoint = Vector2.new(0.5, 0.5)
            border.Position = UDim2.new(0.5, 0, 0.5, 0)
        else
            border.Size = UDim2.fromScale(1, 1)
        end
        border.Parent = target

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, opts.radius or 16)
        corner.Parent = border

        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = opts.thickness or 2
        stroke.Transparency = opts.transparency or 0
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Parent = border

        local grad = Instance.new("UIGradient")
        grad.Enabled = true
        grad.Color = gradient()
        grad.Parent = stroke

        borders[border] = {
            grad = grad, stroke = stroke,
            thickness = opts.thickness or 2, pulse = opts.pulse, fitTo = fitTo,
        }
    end

    YXTheme.onChange(function()
        local seq = gradient()
        for border, r in pairs(borders) do
            if border.Parent then
                r.grad.Color = seq
            else
                borders[border] = nil
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        local dt = now - last
        last = now
        for border, r in pairs(borders) do
            local alive = border.Parent ~= nil
            if alive and r.fitTo then
                local f = r.fitTo
                if not f.Parent then
                    border:Destroy()
                    borders[border] = nil
                    alive = false
                else
                    local w, h = f.AbsoluteSize.X, f.AbsoluteSize.Y
                    if w >= 40 and h >= 40 then
                        local host = border.Parent
                        border.Size = UDim2.fromOffset(w, h)
                        border.Position = UDim2.fromOffset(
                            f.AbsolutePosition.X - host.AbsolutePosition.X,
                            f.AbsolutePosition.Y - host.AbsolutePosition.Y)
                        border.Visible = true
                    else
                        border.Visible = false
                    end
                end
            end
            if alive then
                r.grad.Rotation = (r.grad.Rotation + Speed * dt) % 360
                if r.pulse then
                    r.stroke.Thickness = r.thickness + math.sin(now * 3) * 0.4
                end
            else
                borders[border] = nil
            end
        end
    end)
end

YXTheme.onChange(function(name)
    if isAllowedTheme(name) then
        ThemeMemory.save(name)
    end
end)

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
            if label and label.TextColor3 ~= p.openBtnText then
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

do
    local guis = {
        WindUI.ScreenGui,
        WindUI.NotificationGui,
        WindUI.DropdownGui,
        WindUI.TooltipGui,
    }

    local function applyThemeText(inst, target)
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
