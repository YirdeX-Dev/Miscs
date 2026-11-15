-- YX-Theme.lua（链接版）
-- 依赖：主脚本在加载本库之前必须写 _G.WindUI = WindUI
-- 导出：9 个符号到 _G，供主脚本与美化模块使用
local WindUI = _G.WindUI
if not WindUI then
    error("YX-Themes: 缺失 _G.WindUI（主脚本须先写 _G.WindUI = WindUI）")
end

local THEME_FOLDER = "YX-HUB"
local THEME_FILE   = THEME_FOLDER .. "/yx_last_theme.txt"

local ALLOWED_THEMES = { "YX-Wind", "YX-PinkWhite", "YX-PurpleWhite", "YX-CyanWhite", "YX-CrimsonWhite", "YX-GoldWhite" }
local function isAllowedTheme(name)
    return type(name) == "string" and table.find(ALLOWED_THEMES, name) ~= nil
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

local savedTheme = ThemeMemory.load() or "YX-Wind"

local THEME_BACKGROUNDS = {
    ["YX-Wind"]      = {
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/IMG_20261018_172319.jpg",
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/%E3%80%90%E5%93%B2%E9%A3%8E%E5%A3%81%E7%BA%B8%E3%80%91%E4%BA%8C%E6%AC%A1%E5%85%83-%E5%8E%9F%E7%A5%9E-%E6%B0%94%E6%B3%A1.jpg",
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/IMG_20261107_105307.jpg",
    },
    ["YX-PinkWhite"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E5%85%AB%E9%87%8D%E7%A5%9E%E5%AD%90%E6%A8%B1%E8%8A%B14K%E5%A3%81%E7%BA%B8.jpg",
    ["YX-PurpleWhite"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E9%9B%B7%E7%94%B5%E5%B0%86%E5%86%9B%20%E5%8E%9F%E7%A5%9E%204K%20%E5%A3%81%E7%BA%B8.jpg",
    ["YX-CyanWhite"]   = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E7%94%98%E9%9B%A8%20%E5%8E%9F%E7%A5%9E%204K%20%E9%AB%98%E6%B8%85%E5%A3%81%E7%BA%B8.jpg",
    ["YX-CrimsonWhite"] = {
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E8%89%BE%E8%8E%B2%C2%B7%E4%B9%94%E5%A5%B3%E4%BB%86%E5%A3%81%E7%BA%B8%20%E2%80%93%20%E7%BB%9D%E5%8C%BA%E9%9B%B6%204K.jpeg",
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E8%89%BE%E8%8E%B2%C2%B7%E4%B9%94%E5%A5%B3%E4%BB%86%E5%A3%81%E7%BA%B8%20%E2%80%93%20%E7%BB%9D%E5%8C%BA%E9%9B%B6%204K%20(1).jpeg",
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E8%89%BE%E8%8E%B2%C2%B7%E4%B9%94%E5%A5%B3%E4%BB%86%E5%A3%81%E7%BA%B8%20%E7%BB%9D%E5%8C%BA%E9%9B%B6%204K.jpeg",
    },
    ["YX-GoldWhite"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E6%98%9F%E8%A7%81%E9%9B%85%20ZZZ%204K%20%E5%8A%A8%E6%BC%AB%E5%A3%81%E7%BA%B8.jpeg",
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

-- 文本背板透明度（微透磨砂）：0 = 完全不透明，1 = 全透。
-- 作用于 LabelBackground / ElementBackground / SectionBoxBackground，颜色跟随各主题。
-- 组件背景（Panel / Tab / Window / Notification）保持官方默认，不在此调整。
local TEXT_BACKDROP_TRANSPARENCY = 0.30

WindUI:AddTheme({
    Name = "YX-Wind",

    -- 原有配色（渐变字段保留，美化模块与库依赖）
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#00E5FF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#00B0FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#2979FF"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#0D2438"),
    Outline = Color3.fromHex("#448AFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#80D8FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#B3E5FC"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#0A1929"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#0D2137"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#10293F"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#448AFF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#0D47A1"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#00FFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#E0FFFF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- 官方完整字段表（颜色跟随本主题）
    Primary = Color3.fromHex("#448AFF"),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#FFFFFF"),

    PanelBackground = Color3.fromHex("#16324E"),
    PanelBackgroundTransparency = 0.95,
    WindowBackground = Color3.fromHex("#0A1929"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#FFFFFF"),
    WindowTopbarAuthor = Color3.fromHex("#FFFFFF"),
    WindowTopbarIcon = Color3.fromHex("#448AFF"),
    WindowTopbarButtonIcon = Color3.fromHex("#448AFF"),
    WindowSearchBarBackground = Color3.fromHex("#0D2438"),

    TabBackground = Color3.fromHex("#FFFFFF"),
    TabBackgroundHover = Color3.fromHex("#FFFFFF"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#FFFFFF"),
    TabBackgroundActiveTransparency = 0.93,
    TabText = Color3.fromHex("#FFFFFF"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("#448AFF"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,
    TabBorder = Color3.new(1, 1, 1),

    -- 文本背板：微透磨砂（只改这 3 处透明度，颜色跟随本主题）
    ElementBackground = Color3.fromHex("#16324E"),
    ElementBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    ElementBackgroundHover = Color3.fromHex("#22486B"),
    ElementTitle = Color3.fromHex("#FFFFFF"),
    ElementDesc = Color3.fromHex("#FFFFFF"),
    ElementIcon = Color3.fromHex("#448AFF"),

    PopupBackground = Color3.fromHex("#0A1929"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#FFFFFF"),
    PopupContent = Color3.fromHex("#FFFFFF"),
    PopupIcon = Color3.fromHex("#448AFF"),
    DialogBackground = Color3.fromHex("#0D2438"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#FFFFFF"),
    DialogContent = Color3.fromHex("#FFFFFF"),
    DialogIcon = Color3.fromHex("#448AFF"),

    Toggle = Color3.fromHex("#0D47A1"),
    ToggleBar = Color3.new(1, 1, 1),
    Checkbox = Color3.fromHex("#00B0FF"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,
    SliderIcon = Color3.fromHex("#448AFF"),
    Slider = Color3.fromHex("#00B0FF"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#448AFF"),
    SliderIconTo = Color3.fromHex("#448AFF"),

    Tooltip = Color3.fromHex("#4C4C4C"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#00B0FF"),
    TooltipSecondaryText = Color3.new(1, 1, 1),
    TabSectionIcon = Color3.fromHex("#448AFF"),
    SectionIcon = Color3.fromHex("#448AFF"),
    SectionExpandIcon = Color3.fromHex("#448AFF"),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.fromHex("#FFFFFF"),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,

    SectionBoxBackground = Color3.fromHex("#16324E"),
    SectionBoxBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#0A1929"),
    NotificationTitle = Color3.fromHex("#FFFFFF"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#FFFFFF"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,
    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.fromHex("#16324E"),
    LabelBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
})

WindUI:AddTheme({
    Name = "YX-PinkWhite",

    -- 原有配色（渐变字段保留，美化模块与库依赖）
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F8B9C3"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#EA788C"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#DD5B72"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#FDF0F2"),
    Outline = Color3.fromHex("#EA788C"),
    Text = Color3.fromHex("#5C3444"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F5D6E1"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F8B9C3"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FDF0F2"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#F5D6E1"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F8B9C3"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F8C5CF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#EA788C"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF4081"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#FF80AB"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- 官方完整字段表（颜色跟随本主题）
    Primary = Color3.fromHex("#EA788C"),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#5C3444"),

    PanelBackground = Color3.fromHex("#FFFFFF"),
    PanelBackgroundTransparency = 0.95,
    WindowBackground = Color3.fromHex("#FDF0F2"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#5C3444"),
    WindowTopbarAuthor = Color3.fromHex("#5C3444"),
    WindowTopbarIcon = Color3.fromHex("#EA788C"),
    WindowTopbarButtonIcon = Color3.fromHex("#EA788C"),
    WindowSearchBarBackground = Color3.fromHex("#FDF0F2"),

    TabBackground = Color3.fromHex("#5C3444"),
    TabBackgroundHover = Color3.fromHex("#5C3444"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#5C3444"),
    TabBackgroundActiveTransparency = 0.93,
    TabText = Color3.fromHex("#5C3444"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#5C3444"),
    TabIcon = Color3.fromHex("#EA788C"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,
    TabBorder = Color3.new(1, 1, 1),

    -- 文本背板：微透磨砂（只改这 3 处透明度，颜色跟随本主题）
    ElementBackground = Color3.fromHex("#FFFFFF"),
    ElementBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    ElementBackgroundHover = Color3.fromHex("#F8E9EE"),
    ElementTitle = Color3.fromHex("#5C3444"),
    ElementDesc = Color3.fromHex("#5C3444"),
    ElementIcon = Color3.fromHex("#EA788C"),

    PopupBackground = Color3.fromHex("#FDF0F2"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#5C3444"),
    PopupContent = Color3.fromHex("#5C3444"),
    PopupIcon = Color3.fromHex("#EA788C"),
    DialogBackground = Color3.fromHex("#FDF0F2"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#5C3444"),
    DialogContent = Color3.fromHex("#5C3444"),
    DialogIcon = Color3.fromHex("#EA788C"),

    Toggle = Color3.fromHex("#EA788C"),
    ToggleBar = Color3.new(1, 1, 1),
    Checkbox = Color3.fromHex("#EA788C"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,
    SliderIcon = Color3.fromHex("#EA788C"),
    Slider = Color3.fromHex("#EA788C"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#EA788C"),
    SliderIconTo = Color3.fromHex("#EA788C"),

    Tooltip = Color3.fromHex("#4C4C4C"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#EA788C"),
    TooltipSecondaryText = Color3.new(1, 1, 1),
    TabSectionIcon = Color3.fromHex("#EA788C"),
    SectionIcon = Color3.fromHex("#EA788C"),
    SectionExpandIcon = Color3.fromHex("#EA788C"),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.fromHex("#5C3444"),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,

    SectionBoxBackground = Color3.fromHex("#FFFFFF"),
    SectionBoxBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#FDF0F2"),
    NotificationTitle = Color3.fromHex("#5C3444"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#5C3444"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,
    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.fromHex("#FFFFFF"),
    LabelBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
})

WindUI:AddTheme({
    Name = "YX-PurpleWhite",

    -- 原有配色（渐变字段保留，美化模块与库依赖）
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#954AE7"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#7C42D9"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#552DAE"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#262147"),
    Outline = Color3.fromHex("#A770DA"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#C1A3DA"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#EFE5F2"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1F1944"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#31294C"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#3E2B7E"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#7C42D9"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#3E2B7E"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#E040FB"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#EA80FC"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- 官方完整字段表（颜色跟随本主题）
    Primary = Color3.fromHex("#A770DA"),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#FFFFFF"),

    PanelBackground = Color3.fromHex("#3A2D63"),
    PanelBackgroundTransparency = 0.95,
    WindowBackground = Color3.fromHex("#1F1944"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#FFFFFF"),
    WindowTopbarAuthor = Color3.fromHex("#FFFFFF"),
    WindowTopbarIcon = Color3.fromHex("#A770DA"),
    WindowTopbarButtonIcon = Color3.fromHex("#A770DA"),
    WindowSearchBarBackground = Color3.fromHex("#262147"),

    TabBackground = Color3.fromHex("#FFFFFF"),
    TabBackgroundHover = Color3.fromHex("#FFFFFF"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#FFFFFF"),
    TabBackgroundActiveTransparency = 0.93,
    TabText = Color3.fromHex("#FFFFFF"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("#A770DA"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,
    TabBorder = Color3.new(1, 1, 1),

    -- 文本背板：微透磨砂（只改这 3 处透明度，颜色跟随本主题）
    ElementBackground = Color3.fromHex("#3A2D63"),
    ElementBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    ElementBackgroundHover = Color3.fromHex("#4C3D80"),
    ElementTitle = Color3.fromHex("#FFFFFF"),
    ElementDesc = Color3.fromHex("#FFFFFF"),
    ElementIcon = Color3.fromHex("#A770DA"),

    PopupBackground = Color3.fromHex("#1F1944"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#FFFFFF"),
    PopupContent = Color3.fromHex("#FFFFFF"),
    PopupIcon = Color3.fromHex("#A770DA"),
    DialogBackground = Color3.fromHex("#262147"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#FFFFFF"),
    DialogContent = Color3.fromHex("#FFFFFF"),
    DialogIcon = Color3.fromHex("#A770DA"),

    Toggle = Color3.fromHex("#3E2B7E"),
    ToggleBar = Color3.new(1, 1, 1),
    Checkbox = Color3.fromHex("#954AE7"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,
    SliderIcon = Color3.fromHex("#A770DA"),
    Slider = Color3.fromHex("#954AE7"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#A770DA"),
    SliderIconTo = Color3.fromHex("#A770DA"),

    Tooltip = Color3.fromHex("#4C4C4C"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#954AE7"),
    TooltipSecondaryText = Color3.new(1, 1, 1),
    TabSectionIcon = Color3.fromHex("#A770DA"),
    SectionIcon = Color3.fromHex("#A770DA"),
    SectionExpandIcon = Color3.fromHex("#A770DA"),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.fromHex("#FFFFFF"),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,

    SectionBoxBackground = Color3.fromHex("#3A2D63"),
    SectionBoxBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#1F1944"),
    NotificationTitle = Color3.fromHex("#FFFFFF"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#FFFFFF"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,
    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.fromHex("#3A2D63"),
    LabelBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
})

WindUI:AddTheme({
    Name = "YX-CyanWhite",

    -- 原有配色（渐变字段保留，美化模块与库依赖）
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#96BDE1"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#607DB7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#39518A"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#2A386B"),
    Outline = Color3.fromHex("#809BCB"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#809BCB"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#A7BCDE"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#263364"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#39518A"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#4A67A4"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#607DB7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#2A386B"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1A365D"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#607DB7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#A7BCDE"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- 官方完整字段表（颜色跟随本主题）
    Primary = Color3.fromHex("#809BCB"),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#FFFFFF"),

    PanelBackground = Color3.fromHex("#3E5288"),
    PanelBackgroundTransparency = 0.95,
    WindowBackground = Color3.fromHex("#263364"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#FFFFFF"),
    WindowTopbarAuthor = Color3.fromHex("#FFFFFF"),
    WindowTopbarIcon = Color3.fromHex("#809BCB"),
    WindowTopbarButtonIcon = Color3.fromHex("#809BCB"),
    WindowSearchBarBackground = Color3.fromHex("#2A386B"),

    TabBackground = Color3.fromHex("#FFFFFF"),
    TabBackgroundHover = Color3.fromHex("#FFFFFF"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#FFFFFF"),
    TabBackgroundActiveTransparency = 0.93,
    TabText = Color3.fromHex("#FFFFFF"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("#809BCB"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,
    TabBorder = Color3.new(1, 1, 1),

    -- 文本背板：微透磨砂（只改这 3 处透明度，颜色跟随本主题）
    ElementBackground = Color3.fromHex("#3E5288"),
    ElementBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    ElementBackgroundHover = Color3.fromHex("#5068A8"),
    ElementTitle = Color3.fromHex("#FFFFFF"),
    ElementDesc = Color3.fromHex("#FFFFFF"),
    ElementIcon = Color3.fromHex("#809BCB"),

    PopupBackground = Color3.fromHex("#263364"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#FFFFFF"),
    PopupContent = Color3.fromHex("#FFFFFF"),
    PopupIcon = Color3.fromHex("#809BCB"),
    DialogBackground = Color3.fromHex("#2A386B"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#FFFFFF"),
    DialogContent = Color3.fromHex("#FFFFFF"),
    DialogIcon = Color3.fromHex("#809BCB"),

    Toggle = Color3.fromHex("#2A386B"),
    ToggleBar = Color3.new(1, 1, 1),
    Checkbox = Color3.fromHex("#607DB7"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,
    SliderIcon = Color3.fromHex("#809BCB"),
    Slider = Color3.fromHex("#607DB7"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#809BCB"),
    SliderIconTo = Color3.fromHex("#809BCB"),

    Tooltip = Color3.fromHex("#4C4C4C"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#607DB7"),
    TooltipSecondaryText = Color3.new(1, 1, 1),
    TabSectionIcon = Color3.fromHex("#809BCB"),
    SectionIcon = Color3.fromHex("#809BCB"),
    SectionExpandIcon = Color3.fromHex("#809BCB"),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.fromHex("#FFFFFF"),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,

    SectionBoxBackground = Color3.fromHex("#3E5288"),
    SectionBoxBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#263364"),
    NotificationTitle = Color3.fromHex("#FFFFFF"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#FFFFFF"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,
    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.fromHex("#3E5288"),
    LabelBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
})

WindUI:AddTheme({
    Name = "YX-CrimsonWhite",

    -- 原有配色（渐变字段保留，美化模块与库依赖）
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F8E5D4"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#C4845D"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#AC6549"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#24211E"),
    Outline = Color3.fromHex("#AC6549"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#85625A"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#E2C4B7"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1D1C21"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#311F26"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#423A39"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#AC6549"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#81423F"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF7043"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#FFAB91"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- 官方完整字段表（颜色跟随本主题）
    Primary = Color3.fromHex("#AC6549"),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#FFFFFF"),

    PanelBackground = Color3.fromHex("#3A3230"),
    PanelBackgroundTransparency = 0.95,
    WindowBackground = Color3.fromHex("#1D1C21"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#FFFFFF"),
    WindowTopbarAuthor = Color3.fromHex("#FFFFFF"),
    WindowTopbarIcon = Color3.fromHex("#AC6549"),
    WindowTopbarButtonIcon = Color3.fromHex("#AC6549"),
    WindowSearchBarBackground = Color3.fromHex("#24211E"),

    TabBackground = Color3.fromHex("#FFFFFF"),
    TabBackgroundHover = Color3.fromHex("#FFFFFF"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#FFFFFF"),
    TabBackgroundActiveTransparency = 0.93,
    TabText = Color3.fromHex("#FFFFFF"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("#AC6549"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,
    TabBorder = Color3.new(1, 1, 1),

    -- 文本背板：微透磨砂（只改这 3 处透明度，颜色跟随本主题）
    ElementBackground = Color3.fromHex("#3A3230"),
    ElementBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    ElementBackgroundHover = Color3.fromHex("#4E423E"),
    ElementTitle = Color3.fromHex("#FFFFFF"),
    ElementDesc = Color3.fromHex("#FFFFFF"),
    ElementIcon = Color3.fromHex("#AC6549"),

    PopupBackground = Color3.fromHex("#1D1C21"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#FFFFFF"),
    PopupContent = Color3.fromHex("#FFFFFF"),
    PopupIcon = Color3.fromHex("#AC6549"),
    DialogBackground = Color3.fromHex("#24211E"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#FFFFFF"),
    DialogContent = Color3.fromHex("#FFFFFF"),
    DialogIcon = Color3.fromHex("#AC6549"),

    Toggle = Color3.fromHex("#81423F"),
    ToggleBar = Color3.new(1, 1, 1),
    Checkbox = Color3.fromHex("#C4845D"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,
    SliderIcon = Color3.fromHex("#AC6549"),
    Slider = Color3.fromHex("#C4845D"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#AC6549"),
    SliderIconTo = Color3.fromHex("#AC6549"),

    Tooltip = Color3.fromHex("#4C4C4C"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#C4845D"),
    TooltipSecondaryText = Color3.new(1, 1, 1),
    TabSectionIcon = Color3.fromHex("#AC6549"),
    SectionIcon = Color3.fromHex("#AC6549"),
    SectionExpandIcon = Color3.fromHex("#AC6549"),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.fromHex("#FFFFFF"),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,

    SectionBoxBackground = Color3.fromHex("#3A3230"),
    SectionBoxBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#1D1C21"),
    NotificationTitle = Color3.fromHex("#FFFFFF"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#FFFFFF"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,
    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.fromHex("#3A3230"),
    LabelBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
})

WindUI:AddTheme({
    Name = "YX-GoldWhite",

    -- 原有配色（渐变字段保留，美化模块与库依赖）
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F8D050"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#E7B55A"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#BE832B"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#F8F6F2"),
    Outline = Color3.fromHex("#E7B55A"),
    Text = Color3.fromHex("#5A3E1B"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#E7B55A"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F8ECD7"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#F8F6F2"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F8ECD7"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F8D050"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#BE832B"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#8B5A2B"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#D4A373"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F8D050"), Transparency = 0 },
    }, { Rotation = 135 }),

    -- 官方完整字段表（颜色跟随本主题）
    Primary = Color3.fromHex("#E7B55A"),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    BackgroundTransparency = 0,
    Hover = Color3.fromHex("#5A3E1B"),

    PanelBackground = Color3.fromHex("#FFFFFF"),
    PanelBackgroundTransparency = 0.95,
    WindowBackground = Color3.fromHex("#FFFFFF"),
    WindowShadow = Color3.new(0, 0, 0),
    WindowTopbarTitle = Color3.fromHex("#5A3E1B"),
    WindowTopbarAuthor = Color3.fromHex("#5A3E1B"),
    WindowTopbarIcon = Color3.fromHex("#E7B55A"),
    WindowTopbarButtonIcon = Color3.fromHex("#E7B55A"),
    WindowSearchBarBackground = Color3.fromHex("#F8F6F2"),

    TabBackground = Color3.fromHex("#5A3E1B"),
    TabBackgroundHover = Color3.fromHex("#5A3E1B"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#5A3E1B"),
    TabBackgroundActiveTransparency = 0.93,
    TabText = Color3.fromHex("#5A3E1B"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#5A3E1B"),
    TabIcon = Color3.fromHex("#E7B55A"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,
    TabBorder = Color3.new(1, 1, 1),

    -- 文本背板：微透磨砂（只改这 3 处透明度，颜色跟随本主题）
    ElementBackground = Color3.fromHex("#FFFFFF"),
    ElementBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    ElementBackgroundHover = Color3.fromHex("#F8ECD7"),
    ElementTitle = Color3.fromHex("#5A3E1B"),
    ElementDesc = Color3.fromHex("#5A3E1B"),
    ElementIcon = Color3.fromHex("#E7B55A"),

    PopupBackground = Color3.fromHex("#FFFFFF"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle = Color3.fromHex("#5A3E1B"),
    PopupContent = Color3.fromHex("#5A3E1B"),
    PopupIcon = Color3.fromHex("#E7B55A"),
    DialogBackground = Color3.fromHex("#F8F6F2"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle = Color3.fromHex("#5A3E1B"),
    DialogContent = Color3.fromHex("#5A3E1B"),
    DialogIcon = Color3.fromHex("#E7B55A"),

    Toggle = Color3.fromHex("#BE832B"),
    ToggleBar = Color3.new(1, 1, 1),
    Checkbox = Color3.fromHex("#E7B55A"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,
    SliderIcon = Color3.fromHex("#E7B55A"),
    Slider = Color3.fromHex("#E7B55A"),
    SliderThumb = Color3.new(1, 1, 1),
    SliderIconFrom = Color3.fromHex("#E7B55A"),
    SliderIconTo = Color3.fromHex("#E7B55A"),

    Tooltip = Color3.fromHex("#4C4C4C"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#E7B55A"),
    TooltipSecondaryText = Color3.new(1, 1, 1),
    TabSectionIcon = Color3.fromHex("#E7B55A"),
    SectionIcon = Color3.fromHex("#E7B55A"),
    SectionExpandIcon = Color3.fromHex("#E7B55A"),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.fromHex("#5A3E1B"),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,

    SectionBoxBackground = Color3.fromHex("#FFFFFF"),
    SectionBoxBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#FFFFFF"),
    NotificationTitle = Color3.fromHex("#5A3E1B"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#5A3E1B"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,
    DropdownTabBorder = Color3.new(1, 1, 1),

    LabelBackground = Color3.fromHex("#FFFFFF"),
    LabelBackgroundTransparency = TEXT_BACKDROP_TRANSPARENCY,
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

_G.savedTheme        = savedTheme
_G.ALLOWED_THEMES    = ALLOWED_THEMES
_G.isAllowedTheme    = isAllowedTheme
_G.ThemeMemory       = ThemeMemory
_G.THEME_BACKGROUNDS = THEME_BACKGROUNDS
_G.wallpaperFor      = wallpaperFor
_G.onEnterTheme      = onEnterTheme
_G.YXTheme           = YXTheme
_G.addGradientBorder = addGradientBorder

-- 11月16日00时45分
