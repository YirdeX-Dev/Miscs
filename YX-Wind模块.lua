--[[YirdeX制作 | 开源 | 适配Wind UI美化模块
请不要当卑鄙的盗用者或者倒卖者]]


-- YX-Theme.lua（链接版）
-- 依赖：主脚本在加载本库之前必须写 _G.WindUI = WindUI
-- 导出：9 个符号到 _G，供主脚本与美化模块使用
local WindUI = _G.WindUI
if not WindUI then
    error("YX-Themes: 缺失 _G.WindUI（主脚本须先写 _G.WindUI = WindUI）")
end

local THEME_FOLDER = "YX-HUB"
local THEME_FILE   = THEME_FOLDER .. "/yx_last_theme.txt"

local ALLOWED_THEMES = { "芙宁娜", "深海蓝", "星云紫", "极光绿", "烈焰橙", "冰霜青", "玫瑰金", "午夜靛", "柠檬黄", "森林绿", "水晶蓝" }
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

local savedTheme = ThemeMemory.load() or "芙宁娜"

local THEME_BACKGROUNDS = {
    ["芙宁娜"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E5%85%AB%E9%87%8D%E7%A5%9E%E5%AD%90%E6%A8%B1%E8%8A%B14K%E5%A3%81%E7%BA%B8.jpg",
    ["深海蓝"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E9%9B%B7%E7%94%B5%E5%B0%86%E5%86%9B%20%E5%8E%9F%E7%A5%9E%204K%20%E5%A3%81%E7%BA%B8.jpg",
    ["星云紫"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E6%98%9F%E8%A7%81%E9%9B%85%20ZZZ%204K%20%E5%8A%A8%E6%BC%AB%E5%A3%81%E7%BA%B8.jpeg",
    ["极光绿"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/%E3%80%90%E5%93%B2%E9%A3%8E%E5%A3%81%E7%BA%B8%E3%80%91%E4%BA%8C%E6%AC%A1%E5%85%83-%E5%8E%9F%E7%A5%9E-%E6%B0%94%E6%B3%A1.jpg",
    ["烈焰橙"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/IMG_20261107_105307.jpg",
    ["冰霜青"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E7%94%98%E9%9B%A8%20%E5%8E%9F%E7%A5%9E%204K%20%E9%AB%98%E6%B8%85%E5%A3%81%E7%BA%B8.jpg",
    ["玫瑰金"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E8%89%BE%E8%8E%B2%C2%B7%E4%B9%94%E5%A5%B3%E4%BB%86%E5%A3%81%E7%BA%B8%20%E2%80%93%20%E7%BB%9D%E5%8C%BA%E9%9B%B6%204K.jpeg",
    ["午夜靛"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E6%98%9F%E8%A7%81%E9%9B%85%20ZZZ%204K%20%E5%8A%A8%E6%BC%AB%E5%A3%81%E7%BA%B8.jpeg",
    ["柠檬黄"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E7%94%98%E9%9B%A8%20%E5%8E%9F%E7%A5%9E%204K%20%E9%AB%98%E6%B8%85%E5%A3%81%E7%BA%B8.jpg",
    ["森林绿"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/%E3%80%90%E5%93%B2%E9%A3%8E%E5%A3%81%E7%BA%B8%E3%80%91%E4%BA%8C%E6%AC%A1%E5%85%83-%E5%8E%9F%E7%A5%9E-%E6%B0%94%E6%B3%A1.jpg",
    ["水晶蓝"] = "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/Wallpaper%20Alchemy%20-%20%E9%9B%B7%E7%94%B5%E5%B0%86%E5%86%9B%20%E5%8E%9F%E7%A5%9E%204K%20%E5%A3%81%E7%BA%B8.jpg",
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
})

WindUI:AddTheme({
    Name = "深海蓝",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#4FC3FF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#1E90FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#0D47A1"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#0A1B33"),
    Outline = Color3.fromHex("#1E90FF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#81D4FA"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#29B6F6"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#071426"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#0D2442"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#143A63"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#2196F3"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#0D47A1"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#29B6F6"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#81D4FA"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "星云紫",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#D08AFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#A020F0"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#6A0DAD"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#1B0B2E"),
    Outline = Color3.fromHex("#A020F0"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#E1BEE7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#BA68C8"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#12081F"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#211038"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#331A54"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#9C27B0"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#6A0DAD"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#CE93D8"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#E1BEE7"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "极光绿",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#69F0AE"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#00C957"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#00897B"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#08221A"),
    Outline = Color3.fromHex("#00C957"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#A7FFEB"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1DE9B6"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#061A13"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#0B3024"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#114737"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#00C957"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#00796B"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1DE9B6"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#A7FFEB"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "烈焰橙",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFB74D"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#FF7F00"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#D84315"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#2B1405"),
    Outline = Color3.fromHex("#FF7F00"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFCC80"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FF9800"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1F0E03"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#331A08"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#4A2A10"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF7F00"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#BF360C"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF9800"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#FFCC80"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "冰霜青",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#80DEEA"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#00ACC1"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#00838F"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#E0F7FA"),
    Outline = Color3.fromHex("#00ACC1"),
    Text = Color3.fromHex("#0A3A42"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#B2EBF2"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#4DD0E1"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#E0F7FA"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#B2EBF2"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#00ACC1"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#006064"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#26C6DA"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#80DEEA"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "玫瑰金",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#E6B0AA"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#C4857A"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#A0564B"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#FFF5F3"),
    Outline = Color3.fromHex("#C4857A"),
    Text = Color3.fromHex("#4A2320"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#F5CCC4"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#DC9A8F"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#FFF5F3"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F9E3DC"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#C4857A"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#8E4B42"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#DC9A8F"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#F5CCC4"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "午夜靛",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#7986CB"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#3F51B5"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1A237E"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#0D0B24"),
    Outline = Color3.fromHex("#3F51B5"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#9FA8DA"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#5C6BC0"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#08071A"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#121030"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1E1A4A"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#3F51B5"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1A237E"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#5C6BC0"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#9FA8DA"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "柠檬黄",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFE082"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#FFC107"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FF8F00"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#FFFDF0"),
    Outline = Color3.fromHex("#FFC107"),
    Text = Color3.fromHex("#4A3800"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFE57F"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFD54F"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#FFFDF0"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FFF3C4"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFC107"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#FF8F00"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFD54F"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#FFE082"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "森林绿",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#81C784"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#2E7D32"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1B5E20"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#0A1C0C"),
    Outline = Color3.fromHex("#2E7D32"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#A5D6A7"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#4CAF50"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#061206"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#0F2810"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#17401A"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#2E7D32"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#1B5E20"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#4CAF50"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#A5D6A7"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
})

WindUI:AddTheme({
    Name = "水晶蓝",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#B3E5FC"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#29B6F6"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#0288D1"), Transparency = 0 },
    }, { Rotation = 45 }),
    Dialog = Color3.fromHex("#F0F8FF"),
    Outline = Color3.fromHex("#29B6F6"),
    Text = Color3.fromHex("#0D3347"),
    Placeholder = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#D4ECF8"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#81D4FA"), Transparency = 0 },
    }, { Rotation = 0 }),
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#F0F8FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#D7EEF8"), Transparency = 0 },
    }, { Rotation = 90 }),
    Button = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#29B6F6"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#0277BD"), Transparency = 0 },
    }, { Rotation = 135 }),
    Icon = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#4FC3F7"), Transparency = 0 }, 
        ["50"]  = { Color = Color3.fromHex("#B3E5FC"), Transparency = 0 }, 
        ["100"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 }, 
    }, { Rotation = 135 }),
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
        ["芙宁娜"] = {
            waveA = Color3.fromHex("#EA788C"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#EA788C"),
            tagA = Color3.fromHex("#F8B9C3"), tagMid = Color3.fromHex("#EA788C"), tagB = Color3.fromHex("#F8B9C3"),
            openBtnBg = Color3.fromHex("#FDF0F2"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#EA788C"),
        },
        ["深海蓝"] = {
            waveA = Color3.fromHex("#1E90FF"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#1E90FF"),
            tagA = Color3.fromHex("#4FC3FF"), tagMid = Color3.fromHex("#1E90FF"), tagB = Color3.fromHex("#4FC3FF"),
            openBtnBg = Color3.fromHex("#071426"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#1E90FF"),
        },
        ["星云紫"] = {
            waveA = Color3.fromHex("#A020F0"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#A020F0"),
            tagA = Color3.fromHex("#D08AFF"), tagMid = Color3.fromHex("#A020F0"), tagB = Color3.fromHex("#D08AFF"),
            openBtnBg = Color3.fromHex("#12081F"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#A020F0"),
        },
        ["极光绿"] = {
            waveA = Color3.fromHex("#00C957"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#00C957"),
            tagA = Color3.fromHex("#69F0AE"), tagMid = Color3.fromHex("#00C957"), tagB = Color3.fromHex("#69F0AE"),
            openBtnBg = Color3.fromHex("#061A13"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#00C957"),
        },
        ["烈焰橙"] = {
            waveA = Color3.fromHex("#FF7F00"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#FF7F00"),
            tagA = Color3.fromHex("#FFB74D"), tagMid = Color3.fromHex("#FF7F00"), tagB = Color3.fromHex("#FFB74D"),
            openBtnBg = Color3.fromHex("#1F0E03"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#FF7F00"),
        },
        ["冰霜青"] = {
            waveA = Color3.fromHex("#00ACC1"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#00ACC1"),
            tagA = Color3.fromHex("#80DEEA"), tagMid = Color3.fromHex("#00ACC1"), tagB = Color3.fromHex("#80DEEA"),
            openBtnBg = Color3.fromHex("#E0F7FA"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#00ACC1"),
        },
        ["玫瑰金"] = {
            waveA = Color3.fromHex("#C4857A"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#C4857A"),
            tagA = Color3.fromHex("#E6B0AA"), tagMid = Color3.fromHex("#C4857A"), tagB = Color3.fromHex("#E6B0AA"),
            openBtnBg = Color3.fromHex("#FFF5F3"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#C4857A"),
        },
        ["午夜靛"] = {
            waveA = Color3.fromHex("#3F51B5"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#3F51B5"),
            tagA = Color3.fromHex("#7986CB"), tagMid = Color3.fromHex("#3F51B5"), tagB = Color3.fromHex("#7986CB"),
            openBtnBg = Color3.fromHex("#08071A"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#3F51B5"),
        },
        ["柠檬黄"] = {
            waveA = Color3.fromHex("#FFC107"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#FFC107"),
            tagA = Color3.fromHex("#FFE082"), tagMid = Color3.fromHex("#FFC107"), tagB = Color3.fromHex("#FFE082"),
            openBtnBg = Color3.fromHex("#FFFDF0"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#FFC107"),
        },
        ["森林绿"] = {
            waveA = Color3.fromHex("#2E7D32"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#2E7D32"),
            tagA = Color3.fromHex("#81C784"), tagMid = Color3.fromHex("#2E7D32"), tagB = Color3.fromHex("#81C784"),
            openBtnBg = Color3.fromHex("#061206"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#2E7D32"),
        },
        ["水晶蓝"] = {
            waveA = Color3.fromHex("#29B6F6"), waveB = Color3.fromHex("#FFFFFF"),
            gradEdge = Color3.fromHex("#FFFFFF"), gradMid = Color3.fromHex("#29B6F6"),
            tagA = Color3.fromHex("#B3E5FC"), tagMid = Color3.fromHex("#29B6F6"), tagB = Color3.fromHex("#B3E5FC"),
            openBtnBg = Color3.fromHex("#F0F8FF"),
            btnGradA = Color3.fromHex("#FFFFFF"), btnGradB = Color3.fromHex("#29B6F6"),
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

-- YX-WindUI 主题库（11 主题：芙宁娜 + 10 渐变主题）+ 美化模块 融合版 生成时间：11月20日18时46分
