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

WindUI:AddTheme({
    Name = "YX-Wind",
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
        ["0"]   = { Color = Color3.fromHex("#05222E"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#093E55"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#0D5B7D"), Transparency = 0 },
    }, { Rotation = 45 }),
})

WindUI:AddTheme({
    Name = "YX-PinkWhite",
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
        ["0"]   = { Color = Color3.fromHex("#280B15"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#6D1F39"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#B2335E"), Transparency = 0 },
    }, { Rotation = 45 }),
})

WindUI:AddTheme({
    Name = "YX-PurpleWhite",
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
        ["0"]   = { Color = Color3.fromHex("#B481E4"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#CFAFEE"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#EBDDF8"), Transparency = 0 },
    }, { Rotation = 45 }),
})

WindUI:AddTheme({
    Name = "YX-CyanWhite",
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
        ["0"]   = { Color = Color3.fromHex("#09162A"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#163669"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#2457A8"), Transparency = 0 },
    }, { Rotation = 45 }),
})

WindUI:AddTheme({
    Name = "YX-CrimsonWhite",
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
        ["0"]   = { Color = Color3.fromHex("#ECBB97"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#F2D2BA"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F9E8DC"), Transparency = 0 },
    }, { Rotation = 45 }),
})

WindUI:AddTheme({
    Name = "YX-GoldWhite",
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
        ["0"]   = { Color = Color3.fromHex("#271B0C"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#5E411C"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#95672D"), Transparency = 0 },
    }, { Rotation = 45 }),
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
