-- YX-Theme.lua（链接版）
-- 依赖：主脚本在加载本库之前必须写 _G.WindUI = WindUI
-- 导出：9 个符号到 _G，供主脚本与美化模块使用
local WindUI = _G.WindUI
if not WindUI then
    error("YX-Themes: 缺失 _G.WindUI（主脚本须先写 _G.WindUI = WindUI）")
end

local THEME_FOLDER = "YX-HUB"
local THEME_FILE   = THEME_FOLDER .. "/yx_last_theme.txt"

local ALLOWED_THEMES = { "芙宁娜", "黑曜" }
local ALLOWED_THEME_SET = {}
for _, name in ipairs(ALLOWED_THEMES) do
    ALLOWED_THEME_SET[name] = true
end

local function isAllowedTheme(name)
    return type(name) == "string" and ALLOWED_THEME_SET[name] == true
end

local ThemeMemory = {}
do
    function ThemeMemory.load()
        if not (isfile and readfile) then return nil end
        local ok, content = pcall(function()
            if not isfile(THEME_FILE) then return nil end
            return readfile(THEME_FILE)
        end)
        if not ok or type(content) ~= "string" then return nil end
        local name = content:match("^%s*(.-)%s*$")
        if isAllowedTheme(name) then return name end
        return nil
    end

    function ThemeMemory.save(name)
        if not (writefile and isAllowedTheme(name)) then return end
        pcall(function()
            if isfolder and makefolder and not isfolder(THEME_FOLDER) then
                pcall(makefolder, THEME_FOLDER)
            end
            writefile(THEME_FILE, name)
        end)
    end
end

local savedTheme = ThemeMemory.load() or "芙宁娜"

-- 芙宁娜：白字 + 白色边框，统一深蓝底色；浅青与亮青只用于文字流光。
local DEEP_BLUE  = Color3.fromHex("#071D49") -- 统一深蓝底色
local BLUE       = Color3.fromHex("#0E3A8F") -- 仅选中项轻微加亮的深蓝
local PURE_BLUE  = Color3.fromHex("#146CFF") -- 主按钮亮蓝
local DARK_BLUE  = Color3.fromHex("#0D47A1") -- 主按钮深蓝收边
local CYAN       = Color3.fromHex("#00E5FF") -- 边框亮青高光
local LIGHT_CYAN = Color3.fromHex("#CFF8FF") -- 浅青文字流光
local WHITE      = Color3.fromHex("#FFFFFF") -- 正文与边框主色

local THEME_BACKGROUNDS = {
    ["芙宁娜"] = {
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/%E3%80%90%E5%93%B2%E9%A3%8E%E5%A3%81%E7%BA%B8%E3%80%91%E4%BA%8C%E6%AC%A1%E5%85%83-%E5%8E%9F%E7%A5%9E-%E6%B0%94%E6%B3%A1.jpg",
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/IMG_20261107_105307.jpg",
    },
    ["黑曜"] = {
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/%E3%80%90%E5%93%B2%E9%A3%8E%E5%A3%81%E7%BA%B8%E3%80%91%E4%BA%8C%E6%AC%A1%E5%85%83%E5%B0%91%E5%A5%B3-%E5%86%B7%E5%85%89.jpg",
    },
}

local pickedWallpaper = {}
local lastPick        = {}
local enteredTheme    = nil

local function wallpaperFor(name)
    local v = THEME_BACKGROUNDS[name]
    if type(v) == "string" then return v end
    if type(v) ~= "table" or #v == 0 then return nil end
    if pickedWallpaper[name] then return pickedWallpaper[name] end

    local idx = math.random(1, #v)
    if #v > 1 and lastPick[name] and v[idx] == lastPick[name] then
        idx = idx % #v + 1
    end
    local chosen = v[idx]
    pickedWallpaper[name] = chosen
    lastPick[name] = chosen
    return chosen
end

local function onEnterTheme(name)
    if enteredTheme == nil then
        enteredTheme = name
        return
    end
    if enteredTheme ~= name then
        enteredTheme = name
        pickedWallpaper[name] = nil
    end
end

local onUserCardClick = function() end

WindUI:AddTheme({
    Name = "芙宁娜",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = DEEP_BLUE, Transparency = 0 },
        ["50"]  = { Color = BLUE,      Transparency = 0 },
        ["100"] = { Color = DEEP_BLUE, Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = DEEP_BLUE,
    Outline = WHITE,
    Text = WHITE,
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = LIGHT_CYAN, Transparency = 0 },
        ["100"] = { Color = WHITE,      Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = DEEP_BLUE, Transparency = 0 },
        ["50"]  = { Color = DEEP_BLUE, Transparency = 0 },
        ["100"] = { Color = DEEP_BLUE, Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = PURE_BLUE, Transparency = 0 },
        ["100"] = { Color = DARK_BLUE, Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = WHITE, Transparency = 0 },
        ["50"]  = { Color = CYAN,  Transparency = 0 },
        ["100"] = { Color = WHITE, Transparency = 0 },
    }, { Rotation = 135 }),

    -- ================================================================
    -- 扩展控件样式（按用户提供的完整模板，主色保持芙宁娜 白 / 青 / 深蓝）
    -- ================================================================
    Primary = CYAN, -- Checkbox / Slider / TooltipSecondary

    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),

    BackgroundTransparency = 0,
    Hover = WHITE, -- Text

    -- 半透明组件底：模板原为 0.93~0.97（几乎看不见），
    -- 加深至 0.55~0.72——压住壁纸保证轮廓可辨，同时仍透出背景图。
    PanelBackground = WHITE,
    PanelBackgroundTransparency = 0.68,

    WindowBackground = DEEP_BLUE,
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = WHITE,
    WindowTopbarAuthor = WHITE,
    WindowTopbarIcon = LIGHT_CYAN,
    WindowTopbarButtonIcon = LIGHT_CYAN,
    WindowSearchBarBackground = DEEP_BLUE,

    TabBackground = WHITE,
    TabBackgroundHover = WHITE,
    TabBackgroundHoverTransparency = 0.72,
    TabBackgroundActive = WHITE,
    TabBackgroundActiveTransparency = 0.55,
    TabText = WHITE,
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = WHITE,
    TabIcon = CYAN,
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorder = WHITE,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.45,

    ElementBackground = WHITE,
    ElementBackgroundTransparency = 0.66,
    ElementBackgroundHover = (function()
        local ok, v = pcall(function()
            return WindUI.Creator:AddColor("ElementBackground", "#ffffff", 1 / 10)
        end)
        return ok and v or WHITE
    end)(),
    ElementTitle = WHITE,
    ElementDesc = WHITE,
    ElementIcon = LIGHT_CYAN,

    PopupBackground = DEEP_BLUE,
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = WHITE,
    PopupContent = WHITE,
    PopupIcon = LIGHT_CYAN,

    DialogBackground = DEEP_BLUE,
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = WHITE,
    DialogContent = WHITE,
    DialogIcon = LIGHT_CYAN,

    Toggle = BLUE,
    ToggleBar = WHITE,

    Checkbox = CYAN,
    CheckboxIcon = WHITE,
    CheckboxBorder = WHITE,
    CheckboxBorderTransparency = 0.5,

    SliderIcon = LIGHT_CYAN,
    Slider = CYAN,
    SliderThumb = WHITE,
    SliderIconFrom = LIGHT_CYAN,
    SliderIconTo = LIGHT_CYAN,

    Tooltip = DEEP_BLUE,
    TooltipText = WHITE,
    TooltipSecondary = CYAN,
    TooltipSecondaryText = WHITE,

    TabSectionIcon = LIGHT_CYAN,
    SectionIcon = LIGHT_CYAN,
    SectionExpandIcon = WHITE,
    SectionExpandIconTransparency = 0.4,
    SectionBox = WHITE,
    SectionBoxTransparency = 0.66,
    SectionBoxBorder = WHITE,
    SectionBoxBorderTransparency = 0.45,
    SectionBoxBackground = WHITE,
    SectionBoxBackgroundTransparency = 0.66,

    SearchBarBorder = WHITE,
    SearchBarBorderTransparency = 0.5,

    Notification = DEEP_BLUE,
    NotificationTitle = WHITE,
    NotificationTitleTransparency = 0,
    NotificationContent = WHITE,
    NotificationContentTransparency = 0.4,
    NotificationDuration = WHITE,
    NotificationDurationTransparency = 0.95,
    NotificationBorder = WHITE,
    NotificationBorderTransparency = 0.5,

    DropdownTabBorder = WHITE,

    LabelBackground = WHITE,
    LabelBackgroundTransparency = 0.7,
})

-- 黑曜：黑 / 白 / 灰 + 冷色调 + 偏暗黑系（保持原配色）
WindUI:AddTheme({
    Name = "黑曜",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#E8EAED"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#9AA0A6"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#5F6368"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#1A1C20"),
    Outline = Color3.fromHex("#5F6368"),
    Text = Color3.fromHex("#F1F3F4"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#9AA0A6"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#5F6368"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#0B0C0E"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#131519"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1C1F24"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#5F6368"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#2A2D31"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#E8EAED"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#B8BDC2"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- ================================================================
    -- 扩展控件样式（按用户提供的完整模板，主色保持黑曜 黑 / 白 / 冷灰）
    -- ================================================================
    Primary = Color3.fromHex("#a1a1aa"),

    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),

    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#F1F3F4"),

    -- 与芙宁娜一致的加深幅度：轮廓清晰、仍透出壁纸。
    PanelBackground = Color3.new(1, 1, 1),
    PanelBackgroundTransparency = 0.68,

    WindowBackground = Color3.fromHex("#131519"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#F1F3F4"),
    WindowTopbarAuthor = Color3.fromHex("#F1F3F4"),
    WindowTopbarIcon = Color3.fromHex("#a1a1aa"),
    WindowTopbarButtonIcon = Color3.fromHex("#a1a1aa"),
    WindowSearchBarBackground = Color3.fromHex("#131519"),

    TabBackground = Color3.new(1, 1, 1),
    TabBackgroundHover = Color3.new(1, 1, 1),
    TabBackgroundHoverTransparency = 0.72,
    TabBackgroundActive = Color3.new(1, 1, 1),
    TabBackgroundActiveTransparency = 0.55,
    TabText = Color3.fromHex("#F1F3F4"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#F1F3F4"),
    TabIcon = Color3.fromHex("#a1a1aa"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorder = Color3.new(1, 1, 1),
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.45,

    ElementBackground = Color3.new(1, 1, 1),
    ElementBackgroundTransparency = 0.66,
    ElementBackgroundHover = (function()
        local ok, v = pcall(function()
            return WindUI.Creator:AddColor("ElementBackground", "#ffffff", 1 / 10)
        end)
        return ok and v or Color3.new(1, 1, 1)
    end)(),
    ElementTitle = Color3.fromHex("#F1F3F4"),
    ElementDesc = Color3.fromHex("#F1F3F4"),
    ElementIcon = Color3.fromHex("#a1a1aa"),

    PopupBackground = Color3.fromHex("#131519"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#F1F3F4"),
    PopupContent = Color3.fromHex("#F1F3F4"),
    PopupIcon = Color3.fromHex("#a1a1aa"),

    DialogBackground = Color3.fromHex("#1A1C20"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#F1F3F4"),
    DialogContent = Color3.fromHex("#F1F3F4"),
    DialogIcon = Color3.fromHex("#a1a1aa"),

    Toggle = Color3.fromHex("#3C4043"),
    ToggleBar = Color3.new(1, 1, 1),

    Checkbox = Color3.fromHex("#E8EAED"),
    CheckboxIcon = Color3.fromHex("#0B0C0E"),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.5,

    SliderIcon = Color3.fromHex("#a1a1aa"),
    Slider = Color3.fromHex("#E8EAED"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#a1a1aa"),
    SliderIconTo = Color3.fromHex("#a1a1aa"),

    Tooltip = Color3.fromHex("#1A1C20"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#E8EAED"),
    TooltipSecondaryText = Color3.fromHex("#0B0C0E"),

    TabSectionIcon = Color3.fromHex("#a1a1aa"),
    SectionIcon = Color3.fromHex("#a1a1aa"),
    SectionExpandIcon = Color3.new(1, 1, 1),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.new(1, 1, 1),
    SectionBoxTransparency = 0.66,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.45,
    SectionBoxBackground = Color3.new(1, 1, 1),
    SectionBoxBackgroundTransparency = 0.66,

    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.5,

    Notification = Color3.fromHex("#131519"),
    NotificationTitle = Color3.fromHex("#F1F3F4"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#F1F3F4"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.5,

    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.new(1, 1, 1),
    LabelBackgroundTransparency = 0.7,
})

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
        if type(name) ~= "string" or name == "" or name == lastName then return end
        lastName = name
        for _, fn in ipairs(listeners) do
            task.spawn(fn, name)
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
        ["芙宁娜"] = {
            -- 所有动态边框均含白色；文字流光为白 ↔ 浅青，并配深蓝描边。
            waveA = WHITE, waveB = CYAN,
            gradEdge = WHITE, gradMid = CYAN,
            tagA = WHITE, tagMid = CYAN, tagB = WHITE,
            openBtnBg = DEEP_BLUE,
            btnGradA = WHITE, btnGradB = CYAN,
            textFlowA = WHITE, textFlowB = LIGHT_CYAN,
        },
        ["黑曜"] = {
            -- 标签页边框流动：白主色 + 黑带（与文字流光黑白一致）；其余静态渐变仍用下方冷灰
            waveA = Color3.fromHex("#FFFFFF"), waveB = Color3.fromHex("#000000"),
            gradEdge = Color3.fromHex("#E8EAED"), gradMid = Color3.fromHex("#5F6368"),
            tagA = Color3.fromHex("#B8BDC2"), tagMid = Color3.fromHex("#5F6368"), tagB = Color3.fromHex("#9AA0A6"),
            openBtnBg = Color3.fromHex("#1A1C20"),
            btnGradA = Color3.fromHex("#9AA0A6"), btnGradB = Color3.fromHex("#3C4043"),
            textFlowA = Color3.fromHex("#FFFFFF"), textFlowB = Color3.fromHex("#000000"),
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
        local cached = paletteCache[name]
        if cached then return cached end

        local p = {}
        local source = PALETTES[name]
        if source then
            -- 返回独立副本，避免写入 openBtnText 时污染共享配色表。
            for key, value in pairs(source) do
                p[key] = value
            end
        else
            local theme = getTable()
            local main = CYAN
            if theme and WindUI.Creator and type(WindUI.Creator.GetThemeProperty) == "function" then
                local ok, c = pcall(function()
                    return WindUI.Creator:GetThemeProperty("Outline", theme)
                end)
                if ok and typeof(c) == "Color3" then main = c end
            end
            local white = WHITE
            p = {
                waveA = main, waveB = white,
                gradEdge = white, gradMid = main,
                tagA = main:Lerp(white, 0.5), tagMid = main, tagB = main:Lerp(white, 0.5),
                openBtnBg = white,
                btnGradA = white, btnGradB = main,
                textFlowA = main, textFlowB = white,
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
    local INTERVAL = 1 / 30
    local acc = 0

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

    RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < INTERVAL then return end
        local step = acc
        acc = 0
        local pulse = math.sin(os.clock() * 3) * 0.4

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
                        if host then
                            border.Size = UDim2.fromOffset(w, h)
                            border.Position = UDim2.fromOffset(
                                f.AbsolutePosition.X - host.AbsolutePosition.X,
                                f.AbsolutePosition.Y - host.AbsolutePosition.Y)
                            border.Visible = true
                        else
                            alive = false
                        end
                    else
                        border.Visible = false
                    end
                end
            end
            if alive then
                r.grad.Rotation = (r.grad.Rotation + Speed * step) % 360
                if r.pulse then
                    r.stroke.Thickness = r.thickness + pulse
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

_G.savedTheme        = savedTheme
_G.ALLOWED_THEMES    = ALLOWED_THEMES
_G.isAllowedTheme    = isAllowedTheme
_G.ThemeMemory       = ThemeMemory
_G.THEME_BACKGROUNDS = THEME_BACKGROUNDS
_G.wallpaperFor      = wallpaperFor
_G.onEnterTheme      = onEnterTheme
_G.YXTheme           = YXTheme
_G.addGradientBorder = addGradientBorder


-- ================================================================
-- 以下为【YX-WindUI 美化模块】（原独立链接，现与上方主题库融合为单文件）
-- 依赖：主脚本加载本文件前，须先写 _G.WindUI 与 _G.Window
-- 上方主题库已导出本模块所需的全部符号（YXTheme / addGradientBorder /
-- wallpaperFor / onEnterTheme / THEME_BACKGROUNDS），此处直接复用
-- ================================================================
local WindUI = _G.WindUI
if not WindUI then
    error("YX-Beautify: 未找到 WindUI。请先执行主脚本后再加载此模块！")
end

local Window = _G.Window
if not Window then
    error("YX-Beautify: 未找到 _G.Window。请先创建主窗口后再加载此模块！")
end

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
            -- ContentProvider 已负责预加载，不再创建永久残留的隐藏 ImageLabel。
            pcall(function()
                game:GetService("ContentProvider"):PreloadAsync({ asset })
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
            local assetFolder = folder .. "/assets"
            local path = assetFolder .. "/." .. sanitize(url) .. "-" .. urlHash(url) .. extension(url)

            pcall(function()
                if isfolder and makefolder then
                    if not isfolder(folder) then makefolder(folder) end
                    if not isfolder(assetFolder) then makefolder(assetFolder) end
                end

                if isfile and not isfile(path) then
                    local body
                    if game.HttpGet then
                        body = game:HttpGet(url)
                    elseif WindUI.Creator and WindUI.Creator.Request then
                        local response = WindUI.Creator.Request({
                            Url = url,
                            Method = "GET",
                            Headers = { ["User-Agent"] = "Roblox/Exploit" },
                        })
                        body = response and response.Body
                    end
                    if type(body) == "string" and #body > 0 and writefile then
                        writefile(path, body)
                    end
                end
            end)

            local asset = nil
            if getcustomasset and (not isfile or isfile(path)) then
                local ok, result = pcall(getcustomasset, path)
                if ok and type(result) == "string" and result ~= "" then
                    asset = result
                end
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
            -- 深蓝底上轻压暗芙宁娜壁纸，让白字从复杂亮背景中分离；其他主题不处理。
            local targetTransparency = themeName == "芙宁娜" and 0.18 or 0
            if math.abs(img.ImageTransparency - targetTransparency) > 0.001 then
                img.ImageTransparency = targetTransparency
            end
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
        while task.wait(0.25) do
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
-- 2. 标签页边框模块（颜色流动渐变：高光带沿边框流动，Rotation 恒 0、不旋转）
--    色序缓存按配色签名隔离 + 切主题强制刷新：修复切黑曜时闪回芙宁娜青白的残留问题
-- ==========================================
do
    local RunService = game:GetService("RunService")
    local borders = {}

    local GRAD_NAME = "TabBtnFlow"
    local SPEED     = 0.35
    local SEQ_STEPS = 60
    local INTERVAL  = 1 / 30

    -- 按 30 Hz 更新缓存色序：一道高光带沿边框流动（配色跟随主题 waveA/waveB：芙宁娜青白、黑曜黑白），Rotation 固定 0，不旋转方向
    local function flowSequence(p, phase)
        local a, b = p.waveA, p.waveB
        local keys = {}
        for i = 0, 12 do
            local x = i / 12
            local s = math.sin((x - phase) * math.pi * 2)
            local w = (s + 1) / 2
            w = w * w
            keys[i + 1] = ColorSequenceKeypoint.new(x, a:Lerp(b, w))
        end
        return ColorSequence.new(keys)
    end

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
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Parent = border

        local grad = stroke:FindFirstChild(GRAD_NAME)
        if not grad or not grad:IsA("UIGradient") then
            grad = Instance.new("UIGradient")
            grad.Name = GRAD_NAME
            grad.Parent = stroke
        end
        grad.Enabled  = true
        grad.Rotation = 0
        grad.Color    = flowSequence(YXTheme.getPalette(), 0)

        borders[border] = grad
    end

    local known = {}
    local function scan()
        local tabModule = Window.TabModule
        local tabs = tabModule and tabModule.Tabs
        if type(tabs) ~= "table" then return end

        for index, tab in pairs(tabs) do
            -- UI 尚未就绪时保留重试机会，不再提前标记为已处理。
            if not known[index] and tab.UIElements and tab.UIElements.Main then
                addBorder(tab.UIElements.Main)
                known[index] = true
            end
        end
    end

    scan()

    -- 色序按 30 Hz 推进并缓存（Rotation 恒为 0，不旋转）
    local phase, acc, lastQ = 0, 0, -1
    local seqCache = {}

    -- 缓存 key 带配色签名：切主题后 waveA/waveB 变化，旧色序自动失效并重建（同模块9修法）
    local function getSequence(p, q)
        local key = YXTheme.colorToHex(p.waveA) .. "|" .. YXTheme.colorToHex(p.waveB) .. "|" .. q
        local seq = seqCache[key]
        if not seq then
            seq = flowSequence(p, q / SEQ_STEPS)
            seqCache[key] = seq
        end
        return seq
    end

    -- 主题切换时立即刷新，并重置 lastQ 强制心跳下一帧用新配色（避免被 q==lastQ 节流跳过）
    YXTheme.onChange(function()
        for key in pairs(seqCache) do
            seqCache[key] = nil
        end
        local seq = flowSequence(YXTheme.getPalette(), 0)
        for border, grad in pairs(borders) do
            if grad.Parent then
                grad.Color = seq
            else
                borders[border] = nil
            end
        end
        lastQ = -1
    end)

    local scanAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        -- 新标签页只需低频扫描；动画本身仍独立保持 30 Hz。
        scanAcc = scanAcc + dt
        if scanAcc >= 0.25 then
            scanAcc = 0
            scan()
        end

        acc = acc + dt
        if acc < INTERVAL then return end
        local step = acc
        acc = 0

        phase = (phase + step * SPEED) % 1
        local q = math.floor(phase * SEQ_STEPS + 0.5) % SEQ_STEPS
        if q == lastQ then return end
        lastQ = q
        if next(borders) == nil then return end

        local seq = getSequence(YXTheme.getPalette(), q)
        for border, grad in pairs(borders) do
            if grad.Parent then
                grad.Rotation = 0
                grad.Color = seq
            else
                borders[border] = nil
            end
        end
    end)
end

-- ==========================================
-- 2b. 侧边栏章节组件边框（Window:Section）
--     WindUI 的 Window:Section 对象未暴露框架引用，因此通过其固定结构识别：
--     SectionFrame 直属 TextButton 标题行 + Content。边框跟随标题行，展开时不包住正文。
-- ==========================================
do
    local main = Window.UIElements and Window.UIElements.Main
    if not main then return end

    local ATTACHED = "YXSectionHeaderBorderAttached"

    local function looksLikeSidebarSection(holder)
        if not (holder and holder:IsA("Frame") and holder.Parent) then return false end
        local top = holder:FindFirstChildWhichIsA("TextButton", false)
        local content = holder:FindFirstChild("Content", false)
        return top ~= nil and content ~= nil and content:IsA("Frame")
    end

    local function attach(holder)
        if not looksLikeSidebarSection(holder) then return end
        if holder:GetAttribute(ATTACHED) then return end

        local top = holder:FindFirstChildWhichIsA("TextButton", false)
        if not top then return end

        pcall(function() holder:SetAttribute(ATTACHED, true) end)
        addGradientBorder(holder, {
            name = "YXSectionHeaderBorder",
            radius = 10,
            thickness = 2,
            pulse = false,
            fitTo = top,
        })
    end

    local function scanSections()
        for _, desc in ipairs(main:GetDescendants()) do
            attach(desc)
        end
    end

    -- 已创建的章节。
    scanSections()

    -- 延迟几轮，兼容 Section 的 Content / TextButton 分批实例化。
    task.defer(scanSections)
    task.delay(0.2, scanSections)

    -- 后续动态创建的章节：只检查新增对象及其父级，避免每个 UI 创建都全量扫描窗口。
    local function inspectCandidate(inst)
        attach(inst)
        if inst and inst.Parent then
            attach(inst.Parent)
        end
    end

    main.DescendantAdded:Connect(function(desc)
        task.defer(inspectCandidate, desc)
    end)

    -- 如果主脚本在主题模块之后才调用 Window:Section，包装原函数继续覆盖新章节。
    pcall(function()
        local rawSection = Window.Section
        if type(rawSection) == "function" and not rawSection.__YXSectionHeaderBorderWrapped then
            local wrapper = function(self, ...)
                local results = table.pack(rawSection(self, ...))
                task.defer(function()
                    task.wait()
                    scanSections()
                end)
                task.delay(0.2, scanSections)
                return table.unpack(results, 1, results.n)
            end
            wrapper.__YXSectionHeaderBorderWrapped = true
            Window.Section = wrapper
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
            local baseThickness = 4
            local INTERVAL = 1 / 30
            local rot, acc = 0, 0
            local connection
            connection = RunService.Heartbeat:Connect(function(dt)
                if not btn.Parent or not stroke.Parent then
                    connection:Disconnect()
                    return
                end

                acc = acc + dt
                if acc < INTERVAL then return end
                local step = acc
                acc = 0

                rot = (rot + Speed * step) % 360
                if grad and grad.Parent then grad.Rotation = rot end
                stroke.Thickness = baseThickness + math.sin(os.clock() * 3) * 0.4
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
        if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then
            return
        end

        -- 流光文字（Title/Author/打开按钮 Title）由模块 9 接管，跳过主题色与渐变禁用
        if inst:GetAttribute("YXFlowText") then return end

        target = target or YXTheme.getTextColor()

        -- 白字直接叠在亮壁纸上仍会丢失轮廓；芙宁娜使用深蓝描边，其他主题保持原逻辑。
        if YXTheme.getName() == "芙宁娜" then
            if inst.TextStrokeColor3 ~= DEEP_BLUE then
                inst.TextStrokeColor3 = DEEP_BLUE
            end
            if math.abs(inst.TextStrokeTransparency - 0.25) > 0.001 then
                inst.TextStrokeTransparency = 0.25
            end
        elseif inst.TextStrokeTransparency < 0.8 then
            inst.TextStrokeTransparency = 0.85
        end

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

        tagFrame.ImageColor3 = WHITE

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
    local INTERVAL = 1 / 30
    local acc = 0

    RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < INTERVAL then return end
        local step = acc
        acc = 0

        for grad, frame in pairs(tagGrads) do
            if grad.Parent then
                grad.Rotation = (grad.Rotation + Speed * step) % 360
                if frame.ImageColor3 ~= WHITE then
                    frame.ImageColor3 = WHITE
                end
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
-- 9. 标题 / 署名 / 打开按钮 Title 文字流光渐变（跟随主题配色）
--    按 30 Hz 更新缓存 ColorSequence，高光带沿文字循环扫过，Rotation 恒 0 不旋转。
--    配色取自 PALETTES.textFlowA/textFlowB：芙宁娜=白→浅青，黑曜=白→黑。
--    模块 3 / 5 通过 YXFlowText 属性跳过这三处文字。
-- ==========================================
do
    local RunService = game:GetService("RunService")

    local FLOW_ATTR = "YXFlowText"
    local GRAD_NAME = "YXTextFlow"

    local WHITE_BASE = WHITE

    local STEPS     = 12
    local SPEED     = 0.35
    local SEQ_STEPS = 60
    local INTERVAL  = 1 / 30

    local function buildSequence(phase, a, b)
        local keys = {}
        for i = 0, STEPS do
            local x = i / STEPS
            local s = math.sin((x - phase) * math.pi * 2)
            local w = (s + 1) / 2
            w = w * w
            keys[i + 1] = ColorSequenceKeypoint.new(x, a:Lerp(b, w))
        end
        return ColorSequence.new(keys)
    end

    -- 颜色签名进缓存 key：切换主题后配色变化，旧序列自动失效并重建
    local seqCache = {}
    local function getSequence(q)
        local p = YXTheme.getPalette()
        local a = p.textFlowA or CYAN
        local b = p.textFlowB or WHITE
        local key = YXTheme.colorToHex(a) .. "|" .. YXTheme.colorToHex(b) .. "|" .. q
        local seq = seqCache[key]
        if not seq then
            seq = buildSequence(q / SEQ_STEPS, a, b)
            seqCache[key] = seq
        end
        return seq
    end

    local flows = {}

    local function applyTextContrast(label)
        if YXTheme.getName() == "芙宁娜" then
            label.TextStrokeColor3 = DEEP_BLUE
            label.TextStrokeTransparency = 0.25
        elseif label.TextStrokeTransparency < 0.8 then
            label.TextStrokeTransparency = 0.85
        end
    end

    local function attach(label)
        if not label or label:GetAttribute(FLOW_ATTR) then return end
        pcall(function() label:SetAttribute(FLOW_ATTR, true) end)

        label.TextColor3       = WHITE_BASE
        label.TextTransparency = 0
        applyTextContrast(label)

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

    local function collect()
        local out = {}
        local main     = Window.UIElements and Window.UIElements.Main
        local mainMain = main     and main:FindFirstChild("Main")
        local topbar   = mainMain and mainMain:FindFirstChild("Topbar")
        local left     = topbar   and topbar:FindFirstChild("Left")
        local box      = left     and left:FindFirstChild("Title")

        if box then
            for _, name in ipairs({"Title", "Author"}) do
                local t = box:FindFirstChild(name)
                if t and t:IsA("TextLabel") then out[#out + 1] = t end
            end
        else
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

    task.spawn(function()
        while task.wait(1.5) do
            applyAll()
        end
    end)

    local phase, acc, lastQ = 0, 0, -1

    -- 主题切换后立即换色并清理旧色序，避免缓存增长或残留上一主题颜色。
    YXTheme.onChange(function()
        for key in pairs(seqCache) do
            seqCache[key] = nil
        end
        local seq = getSequence(0)
        for grad, label in pairs(flows) do
            if grad.Parent then
                grad.Color = seq
                applyTextContrast(label)
            else
                flows[grad] = nil
            end
        end
        lastQ = -1
    end)

    RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < INTERVAL then return end
        local step = acc
        acc = 0

        phase = (phase + step * SPEED) % 1
        local q = math.floor(phase * SEQ_STEPS + 0.5) % SEQ_STEPS
        if q == lastQ then return end
        lastQ = q
        if next(flows) == nil then return end

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

-- ================================================================
-- 扩展样式修订：芙宁娜 / 黑曜两个主题全面扩展为用户提供的 WindUI 完整模板字段，
-- 主色保持原配色（芙宁娜=白 / 青 / 深蓝，黑曜=黑 / 白 / 冷灰）；
-- 半透明组件底色由模板的 0.93~0.97 加深至 0.45~0.72：压住壁纸、轮廓清晰，同时仍透出背景图；
-- 对话框确定按钮保持亮蓝渐变，并并入侧边栏章节（Window:Section）流动渐变边框模块。
-- 文件交付时间：2026年11月27日 21:49:54（UTC+8）
