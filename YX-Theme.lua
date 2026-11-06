if not WindUI then
    error("YX-Theme: 未找到 WindUI。请在主脚本加载本模块前先写 _G.WindUI = WindUI")
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
    ["YX-Wind"]      = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/IMG_20261018_172319.jpg",
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
        ["0"]   = { Color = Color3.fromHex("#00FFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#80D8FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#E1F5FE"), Transparency = 0 },
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
        ["0"]   = { Color = Color3.fromHex("#EA788C"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#F8B9C3"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
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
        ["0"]   = { Color = Color3.fromHex("#A770DA"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#C1A3DA"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
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
        ["0"]   = { Color = Color3.fromHex("#809BCB"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#A7BCDE"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
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
        ["0"]   = { Color = Color3.fromHex("#C4845D"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#E2C4B7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
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
        ["0"]   = { Color = Color3.fromHex("#E7B55A"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#F8D050"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
    }, { Rotation = 45 }),
})

_G.savedTheme        = savedTheme
_G.ALLOWED_THEMES    = ALLOWED_THEMES
_G.isAllowedTheme    = isAllowedTheme
_G.ThemeMemory       = ThemeMemory
_G.THEME_BACKGROUNDS = THEME_BACKGROUNDS
_G.wallpaperFor      = wallpaperFor
_G.onEnterTheme      = onEnterTheme