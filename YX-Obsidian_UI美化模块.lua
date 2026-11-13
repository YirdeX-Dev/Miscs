--[[YirdeX制作 | 开源 | 适配Obsidian_UI美化模块 可以二改 ，请不要当卑鄙的盗用者或者倒卖者]]


local Library, ThemeManager, SaveManager = ...

if not Library then
    warn("[YX] UI 美化模块需通过主脚本加载，请勿单独运行")
    return
end

do
    local function IsLockButton(Obj)
        if not (Obj and Obj:IsA("TextButton")) then return false end
        local Ok, T = pcall(function() return Obj.Text end)
        return Ok and (T == "Lock" or T == "Unlock")
    end
    local function Watch(Obj)
        if not (Obj and Obj:IsA("TextButton")) then return end
        pcall(function()
            Obj:GetPropertyChangedSignal("Text"):Connect(function()
                if IsLockButton(Obj) then Obj.Visible = false end
            end)
        end)
        if IsLockButton(Obj) then Obj.Visible = false end
    end
    local Floats = Library.Floats
    if Floats then
        pcall(function()
            for _, Child in ipairs(Floats:GetChildren()) do Watch(Child) end
            Floats.ChildAdded:Connect(Watch)
        end)
    end
end

local DefaultThemeBackground = {
    Library = nil,
    ThemeManager = nil,
    Images = {
        "https://raw.githubusercontent.com/YirdeX-Dev/Miscs/refs/heads/main/IMG_20261107_105307.jpg",
    },

    -- 只保留「背景 1」，启动即用它（已删除背景 2 / 背景 3 及其切换逻辑）
    StartupImageIndex = 1,

    -- 主题切换触发
    TriggerNames = { "Default" },  -- 视为「默认主题」的主题名
    MatchAssignedDefault = true,   -- 同时匹配被「设为默认」的主题名
    AvoidRepeat = true,            -- 不连续抽到同一张
    RollOnFirstApply = false,      -- 首次进入默认主题是否换图
    NotifyOnSwitch = false,        -- 换图时是否弹通知
    NotifyTitle = "默认主题背景",

    -- 选择持久化（记住最后一次背景，下次启动不回到默认图）
    PersistSelection = true,
    PersistFolder = "MyScriptHub",
    PersistFile = "MyScriptHub/yx_background.txt",

    -- 延迟优化：预缓存背景图 + 绕过库对自定义图的强制重下载
    PrefetchImages = true,         -- 后台预下载背景图
    BypassRedownload = true,       -- 拦截 DownloadAsset(FileName, true) 的同步 HttpGet

    -- 配色与渐变
    ApplyPalette = true,           -- 按背景图套用配套主题色
    TintIcons = true,              -- 图标统一青色
    EnableGradient = true,         -- 图标叠加 UIGradient 渐变
    GradientRotation = 45,

    -- 按钮底色「填充」渐变（作用于按钮本体，不是描边）
    EnableButtonGradient = true,     -- 给 AddButton 创建的按钮底色加渐变
    -- 渐变轴角度，通用/CSS 语义：180 = 垂直「上 -> 下」（即向下加深的 180 度）
    --   Roblox UIGradient.Rotation 以「左->右」为 0 顺时针增加，
    --   内部换算：180(上->下)->90，0(下->上)->270，90(左->右)->0，270(右->左)->180
    --   若要直接指定 Roblox 原生角度，设 ButtonGradientRotationOverride = 数值
    ButtonGradientAngle = 180,
    ButtonGradientRotationOverride = nil,
    -- 规则：亮主题色 -> 上=主题色(限亮)，下=加深          =>「向下加深」
    --       偏黑主题 -> 上=提亮(黑->灰)，下=主题色加深    =>「向上变亮」
    ButtonGradientDarkAmount = 0.45,     -- 向下加深幅度（下端 = 上端 x 此值，越小越深）
    ButtonGradientLightAmount = 0.45,    -- 向上提亮幅度（黑 -> 灰）
    ButtonGradientDarkThreshold = 0.18,  -- 主题色感知亮度低于此值 => 判定偏黑，改走提亮
    ButtonGradientTextSafeLum = 0.15,    -- 渐变亮端亮度上限，保证白色文字对比度 >= 4.5
    ButtonGradientBrightness = 1.0,      -- 整体亮度微调（1 = 不变，<1 更暗）

    -- 强调色填充（开关底色 / 滑块填充 / 通知进度条）：与按钮同款主题色自适应。
    --   方向默认自动：开关这种矮胖胶囊用竖向（圆点盖住右半边，横向渐变只剩左半截，看不出），
    --   滑块填充 / 通知进度条这种细长条用水平；把 AutoOrient 关掉则统一听 AccentGradientAngle
    -- 滑块填充渐变：改成约 45° 斜向（不再是纯水平/纯垂直），亮暗沿对角线分布，
    --   右端不会整条压暗发灰；配合下面把末端压暗幅度调高，解决「拖到后面不明显」。
    AccentGradientAngle = 45,   -- 45=斜向渐变（细长条滑块/进度条用；开关仍自动走竖向）
    AccentGradientDarkAmount = 0.72, -- 末端 = 亮端 x 此值（原 0.40 太暗 -> 0.72 右端更明显）
    AccentGradientSafeLum = 0.62,    -- 强调色填充亮端亮度上限；按钮为了白字压到 0.15，
                                     --   开关没有文字，放宽到 0.62，亮端保持主题色本身的鲜艳度
    AccentGradientAutoOrient = true, -- 自动选方向：矮胖控件(开关胶囊)用竖向，细长条(滑块/进度条)用水平

    -- 下拉菜单（Dropdown）：触发按钮 + 展开面板都跟随主题色
    EnableDropdownGradient = true,   -- 关掉则下拉框保持库的纯色（MainColor / BackgroundColor）
    DropdownGradientAngle = 180,     -- 触发按钮角度（180 = 垂直上->下，和按钮一致）
    DropdownMenuTint = 0.35,         -- 展开面板混入主题色的比例（0 = 不染，1 = 整块主题色）
    DropdownMenuAngle = 180,         -- 面板角度（180 = 垂直上->下）
    DropdownMenuDarkAmount = 0.55,   -- 面板下端亮度 = 上端 x 此值（越小越黑）

    -- 滑块：轨道（未填充的右半段）也跟随主题色，与填充形成同色系明暗对比
    EnableSliderTrackGradient = true,
    SliderTrackTint = 0.22,          -- 轨道混入主题色的比例（比填充低，才不会和已填段糊在一起）
    SliderTrackAngle = 45,           -- 轨道与填充统一约 45° 斜向，避免两条渐变方向打架
    SliderTrackDarkAmount = 0.68,    -- 轨道末端亮度（原 0.35 太暗 -> 0.68 到后面仍看得清）
    -- 青 -> 蓝 -> 靛（仅图标使用；按钮和开关都改成跟随主题色了）
    GradientStops = {
        { 0.0, { 34, 211, 238 } },   -- #22D3EE 青
        { 0.5, { 56, 132, 255 } },   -- #3884FF 蓝
        { 1.0, { 99, 102, 241 } },   -- #6366F1 靛
    },

    -- 只保留「背景 1」一套主题色（已删除背景 2 / 背景 3 及其相关主题代码）
    -- 字段：Background / Main / Accent / Outline / Font / Icon，均为 {R,G,B}
    Palettes = {
        { -- 背景 1：整体提亮一档的浅蓝灰（唯一保留的配色，作为启动默认）
          -- 背景/主色/强调色保持明亮档；轮廓(Outline)与字体(Font)按要求改成纯白
            Background = { 32, 44, 64 }, Main = { 46, 62, 88 },
            Accent = { 130, 200, 248 }, Outline = { 255, 255, 255 },
            Font = { 255, 255, 255 }, Icon = { 120, 220, 250 },
        },
    },

    -- 控件填充色（按钮 / 开关 / 滑块填充 / 下拉）默认跟随主题强调色，切主题一起变。
    --   想强制固定一个颜色时，填 {R,G,B}（0~255）；nil = 跟随主题。
    ControlAccent = nil,
    -- 雾蓝调和：跟随主题的同时把青绿偏色拉回雾蓝、略降饱和，和偏亮低饱和的背景图协调。
    --   设为 false 则完全使用主题原色，不做任何调和。
    MistTint = true,

    -- 可选：背景变化时的回调 (Index, Url)
    OnSelect = nil,

    -- 运行时状态
    LastIndex = nil,
    LastUrl = nil,
    LastAppliedTheme = nil,
    Enabled = false,
    _OriginalApplyTheme = nil,
    _OriginalDownloadAsset = nil,
    _OriginalSetBackground = nil,
    _SkipFirstApply = false,
    _CachedAssets = {},      -- FileName -> true
    _GradientObjects = {},   -- 已插入的 UIGradient
    _RegistryBackup = {},    -- Instance -> { {Property, Value, Kind}, ... }
    _SchemeBackup = nil,     -- 应用配色前的 Scheme
    _TargetsCollected = false,
    _IconsTinted = false,

    -- 动态底色渐变同步（开关在运行时开启 / 关闭也能保持渐变）
    _GradientSyncConn = nil,  -- RunService.Heartbeat 连接
    _DynamicTargets = {},     -- [Inst] = true，已被渐变接管的开关 / 强调底色
    _StopsSignature = nil,    -- 上次应用的渐变配置签名（检测配置变更）

    -- 按钮底色渐变（与图标/开关渐变完全隔离，互不干扰）
    _ButtonTargets = {},          -- [Base] = true，已被接管的按钮底色
    _ButtonGradientObjects = {},  -- 按钮专用 UIGradient 列表
    _ButtonSignature = nil,       -- 按钮渐变配置签名（含亮度）

    -- 下拉菜单 / 滑块轨道渐变（同样独立，互不接管）
    _ElemTargets = {},            -- [Inst] = 渐变名（YXDropdownGradient / YXMenuGradient / YXSliderTrackGradient）
    _ElemOrigins = {},            -- [Inst] = 接管前的注册键（MainColor / BackgroundColor）
    _ElemGradientObjects = {},    -- 本路 UIGradient 列表
    _ElemSignature = nil,         -- 本路配置签名
}

local RNG = (Random and Random.new) and Random.new() or nil
local function RandomInt(Min, Max)
    if RNG then return RNG:NextInteger(Min, Max) end
    return math.random(Min, Max)
end

local ConfigKeys = {
    "Images", "StartupImageIndex", "TriggerNames", "MatchAssignedDefault",
    "AvoidRepeat", "RollOnFirstApply", "NotifyOnSwitch", "NotifyTitle",
    "PersistSelection", "PersistFolder", "PersistFile", "PrefetchImages",
    "BypassRedownload", "ApplyPalette", "TintIcons", "EnableGradient",
    "GradientRotation", "GradientStops", "Palettes", "ControlAccent", "MistTint", "OnSelect",
    "EnableButtonGradient", "ButtonGradientBrightness",
    "ButtonGradientAngle", "ButtonGradientRotationOverride",
    "ButtonGradientDarkAmount", "ButtonGradientLightAmount",
    "ButtonGradientDarkThreshold", "ButtonGradientTextSafeLum",
    "AccentGradientAngle", "AccentGradientDarkAmount", "AccentGradientSafeLum",
    "AccentGradientAutoOrient",
    "EnableDropdownGradient", "DropdownGradientAngle", "DropdownMenuTint",
    "DropdownMenuAngle", "DropdownMenuDarkAmount",
    "EnableSliderTrackGradient", "SliderTrackTint", "SliderTrackAngle", "SliderTrackDarkAmount",
}

-- 复刻库 Window:SetBackgroundImage 里的文件名提取规则，
-- 保证预注册的 AssetName 与库内部使用的完全一致。
local function AssetFileName(Url)
    if type(Url) ~= "string" then return nil end
    return Url:match("([^/]+)$")
end

local function RGB(Table)
    if not (Color3 and Color3.fromRGB) then return nil end
    local Ok, Color = pcall(Color3.fromRGB, Table[1], Table[2], Table[3])
    return Ok and Color or nil
end

-- ============================================================
-- 按钮渐变：主题色自适应明暗工具（颜色分量统一为 0~1 的 sRGB 编码值）
--   Color3.fromRGB 得到的 .R/.G/.B 就是 0~1，这里所有运算都在此空间完成，
--   与 RGB({0..255}) 的写法等价，实测与游戏内渲染吻合。
-- ============================================================
local function YXReadColor3(C)
    if type(C) ~= "userdata" and type(C) ~= "table" then return nil end
    local Ok, R, G, B = pcall(function() return C.R, C.G, C.B end)
    if not (Ok and type(R) == "number" and type(G) == "number" and type(B) == "number") then
        return nil
    end
    local Scale = (R > 1 or G > 1 or B > 1) and 255 or 1  -- 兼容少数 0~255 执行器
    local function Bound(V)
        if V < 0 then return 0 end
        if V > 1 then return 1 end
        return V
    end
    return { Bound(R / Scale), Bound(G / Scale), Bound(B / Scale) }
end

local function YXLuminance(C)
    local function F(V)
        if V <= 0.04045 then return V / 12.92 end
        return ((V + 0.055) / 1.055) ^ 2.4
    end
    return 0.2126 * F(C[1]) + 0.7152 * F(C[2]) + 0.0722 * F(C[3])
end

-- 保持色相，仅按统一系数把亮度压到 MaxL 以内（二分求系数）
local function YXClampLuminance(C, MaxL)
    if YXLuminance(C) <= MaxL then return { C[1], C[2], C[3] } end
    local Lo, Hi = 0, 1
    for _ = 1, 20 do
        local M = (Lo + Hi) / 2
        local T = { C[1] * M, C[2] * M, C[3] * M }
        if YXLuminance(T) > MaxL then Hi = M else Lo = M end
    end
    return { C[1] * Lo, C[2] * Lo, C[3] * Lo }
end

-- 线性混色：T=0 取 A，T=1 取 B（三个分量都在 0~1 空间）
local function YXMix(A, B, T)
    T = tonumber(T) or 0
    if T < 0 then T = 0 elseif T > 1 then T = 1 end
    return {
        A[1] + (B[1] - A[1]) * T,
        A[2] + (B[2] - A[2]) * T,
        A[3] + (B[3] - A[3]) * T,
    }
end

-- ============================================================
-- 统一主题取色（控件 / 边框 / 辉光共用）
--   背景图实测主色 RGB(170,179,198)、色相 221°、低饱和、偏亮，是雾蓝灰。
--   因此在「跟随主题强调色」基础上做一次雾蓝调和：
--     * 青绿偏色（约 140°~205°）拉回雾蓝色相 215°，避免再次发绿；
--     * 其余色相保留，仅轻微降饱和；
--     * 亮度沿用主题本身，不强行压暗。
-- ============================================================
local function YXMistTint(C)
    if not (Color3 and Color3.new and Color3.fromHSV) then return C end
    local Ok, Out = pcall(function()
        local H, S, V = Color3.new(C[1], C[2], C[3]):ToHSV()
        local Deg = H * 360
        if Deg >= 140 and Deg <= 205 then
            Deg = 215
            S = math.min(S, 0.45)
        else
            S = S * 0.85
        end
        -- 只强制调和青绿偏色；其余色相仅 *0.85，不再统一压上限，避免把鲜艳主题色调得过淡
        S = math.max(0.12, S)
        local R = Color3.fromHSV(Deg / 360, S, V)
        return { R.R, R.G, R.B }
    end)
    return (Ok and Out) or C
end

-- 读当前主题强调色并做雾蓝调和，返回 {r,g,b}（0~1）。Mist=false 可关闭调和。
local function YXThemeAccentRGB(Lib, Mist)
    local Base = YXReadColor3(Lib and Lib.Scheme and Lib.Scheme.AccentColor)
    if not Base then Base = { 130 / 255, 200 / 255, 248 / 255 } end
    if Mist ~= false then Base = YXMistTint(Base) end
    return Base
end

function DefaultThemeBackground:SetLibrary(Lib)
    self.Library = Lib
    return self
end

function DefaultThemeBackground:SetThemeManager(Manager)
    self.ThemeManager = Manager
    return self
end

function DefaultThemeBackground:SetImages(Images)
    assert(type(Images) == "table" and #Images > 0, "图片列表必须是非空数组")
    self.Images = Images
    self.LastIndex = nil
    return self
end

function DefaultThemeBackground:Configure(Config)
    if type(Config) ~= "table" then return self end
    for _, Key in ipairs(ConfigKeys) do
        if Config[Key] ~= nil then self[Key] = Config[Key] end
    end
    return self
end

function DefaultThemeBackground:IndexOfUrl(Url)
    for Index, Item in ipairs(self.Images) do
        if Item == Url then return Index end
    end
    return nil
end

function DefaultThemeBackground:IsDefaultTheme(ThemeName)
    if type(ThemeName) ~= "string" then return false end
    for _, Name in ipairs(self.TriggerNames) do
        if ThemeName == Name then return true end
    end
    if self.MatchAssignedDefault and self.ThemeManager then
        local Assigned = self.ThemeManager.DefaultThemeName
        if Assigned and ThemeName == Assigned then return true end
    end
    return false
end

--// 选择持久化 //--
function DefaultThemeBackground:ReadSelection()
    if not (self.PersistSelection and readfile and isfile) then return nil end
    local OkExists, Exists = pcall(isfile, self.PersistFile)
    if not (OkExists and Exists) then return nil end
    local OkRead, Content = pcall(readfile, self.PersistFile)
    if not OkRead then return nil end
    local Index = tonumber(tostring(Content):match("%d+"))
    if Index and Index >= 1 and Index <= #self.Images then return Index end
    return nil
end

function DefaultThemeBackground:SaveSelection(Index)
    if not (self.PersistSelection and writefile) then return false end
    if type(Index) ~= "number" then return false end
    return pcall(function()
        if makefolder and isfolder then
            local Ok, Exists = pcall(isfolder, self.PersistFolder)
            if not (Ok and Exists) then pcall(makefolder, self.PersistFolder) end
        end
        writefile(self.PersistFile, tostring(math.floor(Index)))
    end)
end

--// 延迟优化：预注册缓存 + 拦截强制重下载 //--
function DefaultThemeBackground:InstallCacheOptimizer()
    local IM = self.Library and self.Library.ImageManager
    if not (IM and type(IM.AddAsset) == "function" and type(IM.DownloadAsset) == "function") then
        return false
    end

    if self.BypassRedownload and not self._OriginalDownloadAsset then
        local Original = IM.DownloadAsset
        self._OriginalDownloadAsset = Original
        local Module = self
        IM.DownloadAsset = function(Name, ForceRedownload, ...)
            -- 库每次设置 URL 背景都会传 true 强制重新下载；对已缓存图片直接跳过
            if ForceRedownload == true and Module._CachedAssets[Name] then
                return true, nil
            end
            return Original(Name, ForceRedownload, ...)
        end
    end

    if not self.PrefetchImages then return true end

    local Module = self
    local function Register(Url)
        local Name = AssetFileName(Url)
        if not Name then return end
        pcall(function()
            if not IM.GetAsset or not IM.GetAsset(Name) then
                pcall(IM.AddAsset, Name, 0, Url)   -- 首次注册并下载一次
            end
        end)
        Module._CachedAssets[Name] = true
    end

    local Urls = {}
    for _, Url in ipairs(self.Images) do Urls[#Urls + 1] = Url end
    local function Work()
        for _, Url in ipairs(Urls) do Register(Url) end
    end
    if task and task.spawn then pcall(task.spawn, Work) else Work() end
    return true
end

--// 监听一切背景设置（含用户在「背景图片」输入框手动粘贴 URL）//--
function DefaultThemeBackground:InstallBackgroundTracker()
    local Lib = self.Library
    if not (Lib and type(Lib.SetBackgroundImage) == "function") then return false end
    if self._OriginalSetBackground then return true end

    local Original = Lib.SetBackgroundImage
    self._OriginalSetBackground = Original
    local Module = self
    Lib.SetBackgroundImage = function(LibSelf, Image, ...)
        local Results = table.pack(Original(LibSelf, Image, ...))
        pcall(function()
            if type(Image) == "string" then
                local Index = Module:IndexOfUrl(Image)
                if Index and Index ~= Module.LastIndex then
                    Module.LastIndex = Index
                    Module.LastUrl = Module.Images[Index]
                    Module:SaveSelection(Index)
                    if Module.ApplyPalette then pcall(Module.ApplyPaletteFor, Module, Index) end
                    if type(Module.OnSelect) == "function" then
                        pcall(Module.OnSelect, Index, Module.LastUrl)
                    end
                end
            end
        end)
        return table.unpack(Results, 1, Results.n)
    end
    return true
end

--// 应用背景 URL //--
function DefaultThemeBackground:ApplyUrl(Url)
    local Lib = self.Library
    if not Lib or type(Url) ~= "string" or Url == "" then return false end

    local Option = Lib.Options and Lib.Options.BackgroundImage
    local Applied = false
    if Option and Option.SetValue then
        local Ok = pcall(function() Option:SetValue(Url) end)
        Applied = Ok and Lib.Scheme ~= nil and Lib.Scheme.BackgroundImage == Url
    end
    if not Applied then
        pcall(function() Lib:SetBackgroundImage(Url) end)
    end
    return true
end

--// 配色 / 图标青色 / 渐变 //--
function DefaultThemeBackground:ApplyPaletteFor(Index, Force)
    local Lib = self.Library
    if not (self.ApplyPalette and Lib and Lib.Scheme) then return end
    -- 默认只把「背景 1」配色套用一次（启动时）。切到别的主题时不再用固定调色板
    --   覆盖主题自身的 AccentColor / BackgroundColor，渐变才能实时跟随当前主题。
    -- Force = true：用于「从别的主题切回默认主题」。ThemeManager 刚用它自己的主题数据
    --   整表覆盖了 Scheme，必须重新把背景 1 配色套回去，否则回切后配色不是启动那套默认值。
    if self._PaletteApplied and not Force then return end
    self._PaletteApplied = true
    local P = self.Palettes[Index] or self.Palettes[1]
    if not P then return end

    if not self._SchemeBackup then
        self._SchemeBackup = {}
        for _, Key in ipairs({ "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor" }) do
            self._SchemeBackup[Key] = Lib.Scheme[Key]
        end
        self._SchemeBackup.IconColor = Lib.Scheme.IconColor
    end

    -- Scheme 键 -> 配色表字段
    local PaletteMap = {
        { "BackgroundColor", "Background" },
        { "MainColor", "Main" },
        { "AccentColor", "Accent" },
        { "OutlineColor", "Outline" },
        { "FontColor", "Font" },
    }
    local function Set(Key, ValueTable)
        local Color = RGB(ValueTable)
        if Color then Lib.Scheme[Key] = Color end
    end

    -- 先同步颜色选择器（其 OnChanged 会触发 ThemeUpdate 回写 Scheme）
    for _, Pair in ipairs(PaletteMap) do
        local Color = RGB(P[Pair[2]])
        local Opt = Lib.Options and Lib.Options[Pair[1]]
        if Opt and Opt.SetValue and Color then
            pcall(Opt.SetValue, Opt, Color)
        end
    end

    -- 再显式写入精确值，避免颜色选择器 HSV 往返与回调副作用改变最终配色
    Set("BackgroundColor", P.Background)
    Set("MainColor", P.Main)
    Set("AccentColor", P.Accent)
    Set("OutlineColor", P.Outline)
    Set("FontColor", P.Font)
    if self.TintIcons then Set("IconColor", P.Icon) end

    self:ApplyIconTint()
    self:ApplyGradient()
    if Lib.UpdateColorsUsingRegistry then pcall(Lib.UpdateColorsUsingRegistry, Lib) end
end

-- 收集需要染色的元素：图标（ImageColor3=FontColor）与强调色元素（AccentColor 系）
function DefaultThemeBackground:CollectTargets()
    local Lib = self.Library
    if not (Lib and Lib.Registry) then return end
    if self._TargetsCollected then return end
    self._TargetsCollected = true

    for Inst, Props in pairs(Lib.Registry) do
        local List = {}
        for Property, Index in pairs(Props) do
            if type(Index) == "string" then
                local Kind = nil
                if Index == "FontColor" and Property == "ImageColor3" then
                    Kind = "Icon"
                elseif Index == "AccentColor" and (Property == "BackgroundColor3" or Property == "ImageColor3") then
                    Kind = "Accent"
                end
                if Kind then
                    table.insert(List, { Property = Property, Value = Index, Kind = Kind })
                end
            end
        end
        if #List > 0 then self._RegistryBackup[Inst] = List end
    end
end

function DefaultThemeBackground:ApplyIconTint()
    local Lib = self.Library
    if not (self.TintIcons and Lib and Lib.Registry) then return end
    self:CollectTargets()
    if self._IconsTinted then return end
    self._IconsTinted = true
    for Inst, List in pairs(self._RegistryBackup) do
        local Props = Lib.Registry[Inst]
        if Props then
            for _, Entry in ipairs(List) do
                if Entry.Kind == "Icon" then
                    Props[Entry.Property] = "IconColor"  -- 先统一青色；渐变成功时再改白色基底
                end
            end
        end
    end
end

-- 构建渐变色序列（图标 / 强调色 / 开关底色共用同一套）
function DefaultThemeBackground:GetGradientStops()
    local Ok, Stops = pcall(function()
        local Keypoints = {}
        for _, Stop in ipairs(self.GradientStops) do
            local Color = RGB(Stop[2])
            if Color then
                table.insert(Keypoints, ColorSequenceKeypoint.new(Stop[1], Color))
            end
        end
        if #Keypoints == 0 then return nil end
        return ColorSequence.new(Keypoints)
    end)
    return Ok and Stops or nil
end

function DefaultThemeBackground:GetGradientWhite()
    if Color3 and Color3.fromRGB then return Color3.fromRGB(255, 255, 255) end
    if Color3 and Color3.new then return Color3.new(1, 1, 1) end
    return nil
end

-- 配置签名：GradientStops / Rotation 变化时可刷新所有已建渐变
function DefaultThemeBackground:StopsSignature()
    local Parts = {}
    for _, Stop in ipairs(self.GradientStops) do
        local C = Stop[2] or {}
        Parts[#Parts + 1] = string.format("%s:%s,%s,%s", tostring(Stop[1]),
            tostring(C[1]), tostring(C[2]), tostring(C[3]))
    end
    return table.concat(Parts, "|") .. "@" .. tostring(self.GradientRotation)
end

-- 强调色填充的签名：主题色 + 自适应参数 + 角度；任一变化即刷新开关/滑块/进度条渐变
function DefaultThemeBackground:AccentStopsSignature()
    local C = self:GetThemeColor()
    return string.format("%.4f,%.4f,%.4f", C[1], C[2], C[3])
        .. "#AA" .. tostring(self.AccentGradientAngle)
        .. "#DA" .. tostring(self.ButtonGradientDarkAmount)
        .. "#LA" .. tostring(self.ButtonGradientLightAmount)
        .. "#TH" .. tostring(self.ButtonGradientDarkThreshold)
        .. "#SL" .. tostring(self.ButtonGradientTextSafeLum)
        .. "#BR" .. tostring(self.ButtonGradientBrightness)
        .. "#AD" .. tostring(self.AccentGradientDarkAmount)
        .. "#AS" .. tostring(self.AccentGradientSafeLum)
end

function DefaultThemeBackground:RememberDynamicBackup(Inst, Property, Value)
    local List = self._RegistryBackup[Inst]
    if not List then List = {}; self._RegistryBackup[Inst] = List end
    for _, Entry in ipairs(List) do
        if Entry.Property == Property then return end   -- 已有原值更权威，不覆盖
    end
    table.insert(List, { Property = Property, Value = Value, Kind = "Dynamic" })
end

function DefaultThemeBackground:ApplyGradient()
    local Lib = self.Library
    if not (self.EnableGradient and Lib and Lib.Scheme and Lib.Registry) then return end
    if not (Instance and Instance.new) then return end
    if #self._GradientObjects > 0 then return end  -- 已插入
    self:CollectTargets()

    -- 库的 Registry 只支持单一 Color3，主题色本身无法设成渐变；
    -- 这里只给「图标」叠加固定青->蓝->靛渐变（YXThemeGradient）。
    --   强调色元素（开关开启时的底色 / 滑块填充 / 通知进度条）不再在这里接管，
    --   改由 SyncDynamicGradients 每帧扫描 Registry 的 "AccentColor" 来接管：
    --   这样即便库的 Toggle:Display 每帧把开关底色索引改回 "AccentColor"，
    --   也不会和我们的自定义白键互相覆盖；运行时开启的开关也能立即拿到渐变，
    --   且渐变颜色每帧用实时主题色重算，自动跟随主题切换。
    local Stops = self:GetGradientStops()
    local White = self:GetGradientWhite()
    if not (Stops and White) then return end
    Lib.Scheme.IconGradientBase = White

    local Gradientable = {}
    for Inst, List in pairs(self._RegistryBackup) do
        local Props = Lib.Registry[Inst]
        if Props then
            for _, Entry in ipairs(List) do
                if Entry.Kind == "Icon" then
                    Props[Entry.Property] = "IconGradientBase"
                    table.insert(Gradientable, Inst)
                    break
                end
            end
        end
    end

    for _, Inst in ipairs(Gradientable) do
        pcall(function()
            local Grad = Instance.new("UIGradient")
            Grad.Name = "YXThemeGradient"
            Grad.Rotation = self.GradientRotation
            Grad.Color = Stops
            Grad.Parent = Inst
            table.insert(self._GradientObjects, Grad)
        end)
    end

    -- 立即按新注册表键刷新一次，让白基底当场生效（原版依赖外部回写，单独调用会失效）
    if Lib.UpdateColorsUsingRegistry then pcall(Lib.UpdateColorsUsingRegistry, Lib) end
    self:InstallGradientSync()
end

-- ============================================================
-- 动态底色渐变同步器
--   库的 Toggle:Display() 每次都会直接写 Switch.BackgroundColor3（纯色），
--   并把 Registry 标签在 "MainColor" / "AccentColor" 之间来回改：
--       启动时关闭的开关 -> 标签是 "MainColor"，CollectTargets 收不到
--       后来开启 / 反复切换 -> 库刷回纯 AccentColor，白基底与渐变一起丢失
--   所以只靠启动时分类一次不够。这里低频扫描 Registry：
--     · 当前为强调色底色的对象 -> 补渐变 + 白基底 + 自定义白键
--     · 变回非强调色（开关关闭）-> 禁用渐变，交还库按原配色渲染
--   同时覆盖运行时新增控件、主题回写、换背景后的配色刷新。
-- ============================================================
function DefaultThemeBackground:SyncDynamicGradients()
    local Lib = self.Library
    if not (self.EnableGradient and Lib and Lib.Registry and Lib.Scheme) then return end
    if not (Instance and Instance.new) then return end

    local White = self:GetGradientWhite()
    if not White then return end
    local IconRot = self.GradientRotation

    -- 切主题 / 换背景会整表替换 Library.Scheme，自定义键 IconGradientBase 会一起丢。
    --   丢了之后，运行时新开启的开关只能拿到 AccentColor 当基底，
    --   渐变一叠上去就被压成发黑的一坨（同一个开关一半亮一半暗的元凶）。这里每轮补回。
    if Lib.Scheme.IconGradientBase ~= White then
        Lib.Scheme.IconGradientBase = White
    end

    -- 先算签名（便宜）：主题色/配置没变就复用缓存的 ColorSequence，不再每轮新建。
    local IconSig   = self:StopsSignature()        -- 青蓝固定 + 45 度
    local AccentSig = self:AccentStopsSignature()  -- 主题色 + 参数 + 角度
    local IconChanged   = (IconSig   ~= self._IconStopsSignature)
    local AccentChanged = (AccentSig ~= self._AccentStopsSignature)
    self._IconStopsSignature   = IconSig
    self._AccentStopsSignature = AccentSig

    -- 图标路：青 -> 蓝 -> 靛 固定渐变（缓存）
    local IconStops = self._CachedIconStops
    if IconChanged or not IconStops then
        IconStops = self:GetGradientStops()
        self._CachedIconStops = IconStops
    end
    if not IconStops then return end

    -- 强调色路：主题色自适应（开关底色 / 滑块填充 / 通知进度条 / 运行时新增），缓存
    --   方向不写死：每个对象按自己的形状取（开关竖向、细长条水平），见 GetAccentRotationFor
    local AccentStops = self._CachedAccentStops
    if AccentChanged or not AccentStops then
        AccentStops = self:GetAccentGradientStops()
        self._CachedAccentStops = AccentStops
    end

    -- 已 Dismiss/Destroy 的临时控件（通知进度条等）跳过：库 Registry 不自动清理死对象，
    --   不处理会反复为"尸体"建渐变并永不清登记（内存泄漏）。
    local function IsDead(O)
        -- 【真机根因】Roblox 的 Instance 是 userdata，读不存在的自定义成员
        -- （旧写法里的 O._destroyed）会直接抛错，pcall 吞掉后 Ok=false -> 判死，
        -- 整批真实控件被误杀，渐变一个都不建。这份文件里开关全靠 SyncDynamicGradients
        -- 接管，所以默认开启和运行时开启的开关都没有渐变。
        -- 只读 Instance 一定存在的标准属性 ClassName：读得出来就一律视为存活。
        -- 仅在清理登记时调用（次数极少），宽进不误杀。
        if O == nil then return true end
        local Ok = pcall(function() return O.ClassName end)
        return not Ok
    end
    -- 1) 强调色底色对象（含本次刚开启的开关 / 运行时通知进度条 / 滑块填充）
    --    -> 补主题色自适应渐变 + 白基底 + 自定义白键
    for Inst, Props in pairs(Lib.Registry) do
        -- 不再对每个对象 pcall 判活：Registry 里都是库登记的控件，全量扫描上百个对象、
        -- 每个一次 pcall 很费。个别已销毁对象由下面的 pcall 兜底，不会中断整批。
        if Props then
        pcall(function()
        local Idx = Props.BackgroundColor3
        if Idx == "AccentColor" or Idx == "IconGradientBase" then
            local IsNew = (Idx == "AccentColor")
            local Rot = self:GetAccentRotationFor(Inst)
            local OkFind, Grad = pcall(function() return Inst:FindFirstChild("YXAccentGradient") end)
            if not (OkFind and Grad) then
                pcall(function()
                    local G = Instance.new("UIGradient")
                    G.Name = "YXAccentGradient"
                    G.Rotation = Rot
                    G.Color = AccentStops
                    G.Parent = Inst
                    table.insert(self._GradientObjects, G)
                end)
                OkFind, Grad = pcall(function() return Inst:FindFirstChild("YXAccentGradient") end)
                if not (OkFind and Grad) then Grad = nil end
            end
            if Grad and AccentStops then
                Grad.Enabled = true
                -- 强调色每帧用实时主题色：新建即写入，主题/配置变化(AccentChanged)统一刷新
                if IsNew or AccentChanged then
                    Grad.Color = AccentStops
                end
                -- 窗口缩放 / 首次布局后尺寸才有效，每轮校正方向
                if Grad.Rotation ~= Rot then
                    Grad.Rotation = Rot
                end
                if Inst.BackgroundColor3 ~= White then Inst.BackgroundColor3 = White end
                -- 不再把 Registry 索引改写成自定义键：库的 Toggle:Display 每帧会把开关
                -- 底色索引改回 "AccentColor"，改写它只会反复互踩。不透明 UIGradient 会完整
                -- 覆盖 BackgroundColor3，所以无需抢白基底，库按原索引渲染底色即可，渐变照样显示。
                self._DynamicTargets[Inst] = true
            end
        end
        end)
        end
    end

    -- 2) 之前接管过、现在变回非强调色（开关关闭 / 滑块 disabled / 进度条消失）
    --    -> 禁用渐变，交还库按原配色渲染
    for Inst in pairs(self._DynamicTargets) do
        local Props = Lib.Registry[Inst]
        if not Props then
            self._DynamicTargets[Inst] = nil
        else
            local Idx = Props.BackgroundColor3
            if Idx == nil then
                -- 非底色对象（图标等）不再跟踪，但不动它的渐变
                self._DynamicTargets[Inst] = nil
            elseif Idx ~= "IconGradientBase" and Idx ~= "AccentColor" then
                local OkFind, Grad = pcall(function()
                    return Inst:FindFirstChild("YXAccentGradient") or Inst:FindFirstChild("YXThemeGradient")
                end)
                if OkFind and Grad then Grad.Enabled = false end
                local C = (type(Idx) == "string") and Lib.Scheme[Idx] or nil
                if C then
                    pcall(function()
                        if Inst.BackgroundColor3 == White then Inst.BackgroundColor3 = C end
                    end)
                end
                self._DynamicTargets[Inst] = nil
            end
        end
    end

    -- 3) 配置变化 -> 刷新所有已建渐变（图标 / 强调色分别按各自签名）
    if IconChanged then
        for _, Grad in ipairs(self._GradientObjects) do
            if Grad.Name == "YXThemeGradient" then
                Grad.Color = IconStops
                Grad.Rotation = IconRot
            end
        end
    end
    if AccentChanged then
        for _, Grad in ipairs(self._GradientObjects) do
            if Grad.Name == "YXAccentGradient" then
                Grad.Color = AccentStops
                local OkP, Parent = pcall(function() return Grad.Parent end)
                Grad.Rotation = self:GetAccentRotationFor(OkP and Parent or nil)
            end
        end
    end
end


-- ============================================================
-- 按钮底色渐变（填充渐变，作用于按钮本体；不是 UIStroke 描边）
--
--   为什么不能按 Registry 标签抓：库里 "MainColor" 有几十处，分组框、
--   输入框、下拉框、标签按钮、Toggle 外层按钮都用它，一律接管会染花半个 UI。
--   所以走库的一等公民对象模型：
--       Library.Tabs → Tab.Groupboxes / Tabboxes / DependencyGroupboxes
--                    → Groupbox.Elements → Type=="Button" / "SubButton" → .Base
--   动态扫描，运行时新增的按钮（含 SaveManager/ThemeManager 生成的）也会自动纳入。
--
--   为什么跟着主题色走：按钮渐变不再写死配色，每 0.05s 读一次
--   Library.Scheme.AccentColor（换背景 / ThemeManager 切主题都会改它），
--   由它实时生成同色相的垂直渐变；签名变化即刷新所有按钮。
--
--   方向规则（ButtonGradientAngle = 180，垂直「上 -> 下」）：
--     主题色较亮       -> 上 = 主题色(限亮)，下 = 加深   =>「向下加深」
--     主题色偏黑(近黑) -> 上 = 提亮成灰，下 = 主题色加深 =>「向上变亮」
--   两端都经 YXClampLuminance 限亮，保证按钮白色文字对比度 >= 4.5。
--
--   为什么独立：用独立白键 ButtonGradientBase、独立对象表 _ButtonTargets /
--   _ButtonGradientObjects，避免和开关同步器(_DynamicTargets / _GradientObjects)
--   互相接管或误禁用；库 UpdateColorsUsingRegistry 回写时会按白键刷成白色，
--   不会把渐变冲成纯色。
-- ============================================================
-- 取「控件填充渐变基色」：跟随主题强调色（Scheme.AccentColor），切主题自动换色，
--   再经 YXMistTint 做雾蓝调和，避免青绿偏色、并和背景图的雾蓝灰协调。
--   ControlAccent 填 {R,G,B} 可强制固定；MistTint=false 可关闭调和。
function DefaultThemeBackground:GetThemeColor()
    local Base
    local C = self.ControlAccent
    if type(C) == "table" and C[1] then
        Base = { (C[1] or 0) / 255, (C[2] or 0) / 255, (C[3] or 0) / 255 }
    else
        local Lib = self.Library
        Base = YXReadColor3(Lib and Lib.Scheme and Lib.Scheme.AccentColor)
        if not Base then
            -- 回退：当前背景配套的 Accent
            local P = self.Palettes[self.LastIndex or 1] or self.Palettes[1]
            if P and P.Accent then
                Base = { (P.Accent[1] or 0) / 255, (P.Accent[2] or 0) / 255, (P.Accent[3] or 0) / 255 }
            else
                Base = { 0.20, 0.40, 0.70 }
            end
        end
    end
    if self.MistTint ~= false then Base = YXMistTint(Base) end
    return Base
end

-- 通用/CSS 渐变角度 -> Roblox UIGradient.Rotation
function DefaultThemeBackground:GetButtonGradientRotation()
    local Override = self.ButtonGradientRotationOverride
    if type(Override) == "number" then return Override % 360 end
    local A = tonumber(self.ButtonGradientAngle) or 180
    return (A - 90) % 360
end

-- 强调色填充渐变角度（开关 / 滑块 / 进度条）；默认水平(0)，可与按钮视觉分离
function DefaultThemeBackground:GetAccentGradientRotation()
    local A = tonumber(self.AccentGradientAngle)
    if A == nil then return self.GradientRotation end
    return (tonumber(A) or 0) % 360
end

-- 实际角度：开关是矮胖胶囊，圆点盖住右半边，横向渐变只剩左半截 -> 看不出；
--   这类控件改竖向，露出来的左半区正好走完 亮 -> 暗 的整条渐变。
--   滑块填充 / 通知进度条是细长条，用配置的基础角度（当前 45° 斜向）。
function DefaultThemeBackground:GetAccentRotationFor(Inst)
    local Base = self:GetAccentGradientRotation()
    if not self.AccentGradientAutoOrient or not Inst then return Base end
    local Ok, Size = pcall(function() return Inst.AbsoluteSize end)
    if Ok and Size and Size.X ~= nil and Size.Y ~= nil then
        local SX = tonumber(Size.X) or 0
        local SY = tonumber(Size.Y) or 0
        -- 高度够、且宽高比接近方形/矮胖 => 开关类，竖向
        if SY >= 10 and SX > 0 and SX <= SY * 2.2 then
            return 90
        end
    end
    return Base
end

-- 依据当前主题色生成按钮渐变（垂直 上 -> 下）
--   亮色：上 = 主题色(限亮)，下 = 加深         -> 向下加深
--   偏黑：上 = 提亮(黑->灰)，下 = 主题色加深   -> 向上变亮
function DefaultThemeBackground:GetButtonGradientStops(DarkAmtOverride, SafeLumOverride)
    local function Num(V, Def)
        V = tonumber(V)
        if not V then return Def end
        if V < 0 then return 0 end
        if V > 1 then return 1 end
        return V
    end
    local DarkAmt   = Num(DarkAmtOverride or self.ButtonGradientDarkAmount, 0.45)
    local LightAmt  = Num(self.ButtonGradientLightAmount, 0.45)
    local Threshold = Num(self.ButtonGradientDarkThreshold, 0.18)
    local SafeLum   = Num(SafeLumOverride or self.ButtonGradientTextSafeLum, 0.15)
    local Overall   = tonumber(self.ButtonGradientBrightness) or 1.0
    if Overall < 0 then Overall = 0 end

    local Theme  = self:GetThemeColor()
    local IsDark = (YXLuminance(Theme) < Threshold)
    local Base   = YXClampLuminance(Theme, SafeLum)

    local Bottom = { Base[1] * DarkAmt, Base[2] * DarkAmt, Base[3] * DarkAmt }
    local Top
    if IsDark then
        -- 黑 -> 灰：朝白色方向提亮，再限亮保证白字可读
        local Lift = {
            Base[1] + (1 - Base[1]) * LightAmt,
            Base[2] + (1 - Base[2]) * LightAmt,
            Base[3] + (1 - Base[3]) * LightAmt,
        }
        Top = YXClampLuminance(Lift, SafeLum)
    else
        Top = Base
    end

    local A = { Top[1] * Overall, Top[2] * Overall, Top[3] * Overall }
    local B = { Bottom[1] * Overall, Bottom[2] * Overall, Bottom[3] * Overall }
    local Mid = { (A[1] + B[1]) / 2, (A[2] + B[2]) / 2, (A[3] + B[3]) / 2 }
    local function ToColor(C)
        return RGB({
            math.floor(C[1] * 255 + 0.5),
            math.floor(C[2] * 255 + 0.5),
            math.floor(C[3] * 255 + 0.5),
        })
    end
    local Ok, Stops = pcall(function()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, ToColor(A)),
            ColorSequenceKeypoint.new(0.5, ToColor(Mid)),
            ColorSequenceKeypoint.new(1.0, ToColor(B)),
        })
    end)
    return Ok and Stops or nil
end

-- 强调色填充（开关 / 滑块 / 进度条）用的渐变：
--   算法与按钮完全一致（亮色向下加深、偏黑向上提亮），只是加深幅度单独配置，
--   因为这些控件没有白色文字，不需要压到按钮那么暗。
function DefaultThemeBackground:GetAccentGradientStops()
    return self:GetButtonGradientStops(self.AccentGradientDarkAmount, self.AccentGradientSafeLum)
end

function DefaultThemeBackground:ButtonStopsSignature()
    local C = self:GetThemeColor()
    return string.format("%.4f,%.4f,%.4f", C[1], C[2], C[3])
        .. "#A" .. tostring(self.ButtonGradientAngle)
        .. "#O" .. tostring(self.ButtonGradientRotationOverride)
        .. "#D" .. tostring(self.ButtonGradientDarkAmount)
        .. "#L" .. tostring(self.ButtonGradientLightAmount)
        .. "#T" .. tostring(self.ButtonGradientDarkThreshold)
        .. "#S" .. tostring(self.ButtonGradientTextSafeLum)
        .. "#B" .. tostring(self.ButtonGradientBrightness)
end

-- 收集所有「按钮底色实例」；白名单字段递归，避免遍历到 Connections/Tween 等无关表
function DefaultThemeBackground:CollectButtonBases()
    local Lib = self.Library
    local Found, Seen = {}, {}
    if not (Lib and Lib.Registry and type(Lib.Tabs) == "table") then return Found end

    local Fields = { "Elements", "Groupboxes", "Tabboxes", "Tabs",
                     "DependencyGroupboxes", "SubButton" }

    local function Walk(Node, Depth)
        if type(Node) ~= "table" or Depth > 8 or Seen[Node] then return end
        Seen[Node] = true

        if (Node.Type == "Button" or Node.Type == "SubButton") and Node.Base then
            local Base = Node.Base
            local Props = Lib.Registry[Base]
            if Props then
                local Idx = Props.BackgroundColor3
                if Idx == "MainColor" or Idx == "BackgroundColor"
                   or Idx == "ButtonGradientBase" then
                    Found[Base] = true
                end
            end
        end

        for _, Key in ipairs(Fields) do
            local Child = Node[Key]
            if type(Child) == "table" then
                if Child.Type ~= nil then
                    Walk(Child, Depth + 1)             -- 单个对象（如 SubButton）
                else
                    for _, V in pairs(Child) do         -- 容器（数组或字典）
                        if type(V) == "table" then Walk(V, Depth + 1) end
                    end
                end
            end
        end
    end

    for _, V in pairs(Lib.Tabs) do
        if type(V) == "table" then Walk(V, 0) end
    end
    return Found
end

function DefaultThemeBackground:SyncButtonGradients()
    local Lib = self.Library
    if not (self.EnableButtonGradient and Lib and Lib.Registry and Lib.Scheme) then return end
    if not (Instance and Instance.new) then return end
    local White = self:GetGradientWhite()
    if not White then return end
    local Rot = self:GetButtonGradientRotation()
    Lib.Scheme.ButtonGradientBase = White

    local Signature = self:ButtonStopsSignature()
    local ConfigChanged = (Signature ~= self._ButtonSignature)
    self._ButtonSignature = Signature

    -- 色标缓存：配置/主题未变就复用，不再每轮新建 ColorSequence
    local Stops = self._CachedButtonStops
    if ConfigChanged or not Stops then
        Stops = self:GetButtonGradientStops()
        self._CachedButtonStops = Stops
    end
    if not Stops then return end

    -- 结构遍历（递归整个 Tabs）是最大热点：缓存结果，每 0.5s 才重建一次
    local Now = os.clock()
    local Bases = self._CachedButtonBases
    if (not Bases) or (Now - (self._ButtonBasesAt or 0) >= 0.5) then
        Bases = self:CollectButtonBases()
        self._CachedButtonBases = Bases
        self._ButtonBasesAt = Now
    end

    for Base in pairs(Bases) do
        local Props = Lib.Registry[Base]
        if Props then
            local Idx = Props.BackgroundColor3
            if Idx == "BackgroundColor" then
                -- 按钮被 SetDisabled(true)：禁用渐变，把底色交还库按 BackgroundColor 渲染
                local OkF, G = pcall(function() return Base:FindFirstChild("YXButtonGradient") end)
                if OkF and G then G.Enabled = false end
                pcall(function()
                    if Base.BackgroundColor3 == White then
                        Base.BackgroundColor3 = Lib.Scheme.BackgroundColor
                    end
                end)
                self._ButtonTargets[Base] = nil
            else
                local OkF, G = pcall(function() return Base:FindFirstChild("YXButtonGradient") end)
                if not (OkF and G) then
                    pcall(function()
                        local Grad = Instance.new("UIGradient")
                        Grad.Name = "YXButtonGradient"
                        Grad.Rotation = Rot
                        Grad.Color = Stops
                        Grad.Parent = Base
                        table.insert(self._ButtonGradientObjects, Grad)
                    end)
                    OkF, G = pcall(function() return Base:FindFirstChild("YXButtonGradient") end)
                    if not (OkF and G) then G = nil end
                end
                if G then
                    G.Enabled = true
                    if ConfigChanged then
                        G.Color = Stops
                        G.Rotation = Rot
                    end
                    pcall(function()
                        if Base.BackgroundColor3 ~= White then Base.BackgroundColor3 = White end
                    end)
                    if Idx ~= "ButtonGradientBase" then
                        self:RememberDynamicBackup(Base, "BackgroundColor3", Idx)
                        Props.BackgroundColor3 = "ButtonGradientBase"
                    end
                    self._ButtonTargets[Base] = true
                end
            end
        end
    end

    -- 已接管的按钮若已不在对象模型（被销毁/移除）或标签被外部改走，清登记
    for Base in pairs(self._ButtonTargets) do
        if not Bases[Base] then
            local Props = Lib.Registry[Base]
            if not Props or Props.BackgroundColor3 ~= "ButtonGradientBase" then
                self._ButtonTargets[Base] = nil
            end
        end
    end
end


-- ============================================================
-- 下拉菜单 / 滑块轨道渐变（第三路，与图标-强调色、按钮完全隔离）
--
--   为什么不能按 Registry 键抓：
--     下拉触发按钮、滑块轨道、分组框、输入框、Tab 按钮全都注册成 "MainColor"；
--     下拉面板注册成 "BackgroundColor"（窗口背景、右键菜单也是它）。
--     一律接管会染花半个 UI。所以走对象模型：
--        Library.Tabs → ... → Elements → Type=="Dropdown" → .Container（触发按钮）
--                                                       → .Menu.Menu（展开面板）
--                                       Type=="Slider"  → .Holder 里的 TextButton（轨道）
--   为什么用渐变：
--     库只给单色。"MainColor" 的轨道和"BackgroundColor"的面板都是很深的底色，
--     直接把主题色铺上去会整块变蓝、白字发灰。所以这里把主题色当"染色剂"，
--     按比例混进背景色：面板/轨道仍是深色，但一眼能看出是当前主题的色系。
-- ============================================================

-- 面板底色：下拉菜单 / 滑块轨道的"底"，主题色只往上混
function DefaultThemeBackground:GetPanelBaseColor()
    local Lib = self.Library
    local Read = YXReadColor3(Lib and Lib.Scheme and Lib.Scheme.BackgroundColor)
    if Read then return Read end
    local P = self.Palettes[self.LastIndex or 1] or self.Palettes[1]
    if P and P.Background then
        return { (P.Background[1] or 0) / 255, (P.Background[2] or 0) / 255, (P.Background[3] or 0) / 255 }
    end
    return { 0.05, 0.07, 0.12 }
end

-- 上 / 中 / 下 三色标（中间取两端均值，避免两色标在短控件上出现断带）
function DefaultThemeBackground:MakeStops(Top, Bottom)
    local function ToColor(C)
        local function B(V)
            if V < 0 then return 0 elseif V > 1 then return 1 end
            return V
        end
        return RGB({
            math.floor(B(C[1]) * 255 + 0.5),
            math.floor(B(C[2]) * 255 + 0.5),
            math.floor(B(C[3]) * 255 + 0.5),
        })
    end
    local Mid = { (Top[1] + Bottom[1]) / 2, (Top[2] + Bottom[2]) / 2, (Top[3] + Bottom[3]) / 2 }
    local Ok, Seq = pcall(function()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, ToColor(Top)),
            ColorSequenceKeypoint.new(0.5, ToColor(Mid)),
            ColorSequenceKeypoint.new(1.0, ToColor(Bottom)),
        })
    end)
    return Ok and Seq or nil
end

-- 下拉展开面板：深色板 + 主题色调，上亮下暗
function DefaultThemeBackground:GetMenuGradientStops()
    local function Num(V, Def)
        V = tonumber(V); if not V then return Def end
        if V < 0 then return 0 elseif V > 1 then return 1 end
        return V
    end
    local Tint = Num(self.DropdownMenuTint, 0.35)
    local Dark = Num(self.DropdownMenuDarkAmount, 0.55)
    local Bg    = self:GetPanelBaseColor()
    local Theme = self:GetThemeColor()
    local Top    = YXMix(Bg, Theme, Tint)
    local DarkBg = { Bg[1] * Dark, Bg[2] * Dark, Bg[3] * Dark }
    local Bottom = YXMix(DarkBg, Theme, Tint * 0.40)
    return self:MakeStops(Top, Bottom)
end

-- 滑块轨道：同色系，左亮右暗（横条方向）
function DefaultThemeBackground:GetSliderTrackStops()
    local function Num(V, Def)
        V = tonumber(V); if not V then return Def end
        if V < 0 then return 0 elseif V > 1 then return 1 end
        return V
    end
    local Tint = Num(self.SliderTrackTint, 0.34)
    local Dark = Num(self.SliderTrackDarkAmount, 0.45)
    local Bg    = self:GetPanelBaseColor()
    local Theme = self:GetThemeColor()
    local Top    = YXMix(Bg, Theme, Tint)
    local DarkBg = { Bg[1] * Dark, Bg[2] * Dark, Bg[3] * Dark }
    local Bottom = YXMix(DarkBg, Theme, Tint * 0.45)
    return self:MakeStops(Top, Bottom)
end

function DefaultThemeBackground:ElementStopsSignature()
    local C = self:GetThemeColor()
    local B = self:GetPanelBaseColor()
    return string.format("%.4f,%.4f,%.4f", C[1], C[2], C[3])
        .. string.format("|%.4f,%.4f,%.4f", B[1], B[2], B[3])
        .. "#DT" .. tostring(self.DropdownMenuTint)
        .. "#DD" .. tostring(self.DropdownMenuDarkAmount)
        .. "#DA" .. tostring(self.DropdownGradientAngle)
        .. "#MA" .. tostring(self.DropdownMenuAngle)
        .. "#TT" .. tostring(self.SliderTrackTint)
        .. "#TD" .. tostring(self.SliderTrackDarkAmount)
        .. "#TA" .. tostring(self.SliderTrackAngle)
end

-- 收集三个目标集合：下拉触发按钮 / 下拉展开面板 / 滑块轨道
function DefaultThemeBackground:CollectElementGradients()
    local Lib = self.Library
    local Out = { Dropdown = {}, Menu = {}, Track = {} }
    if not (Lib and Lib.Registry and type(Lib.Tabs) == "table") then return Out end

    local Seen = {}
    local Fields = { "Elements", "Groupboxes", "Tabboxes", "Tabs",
                     "DependencyGroupboxes", "SubButton" }

    -- Holder 里第一个 TextButton 就是控件主体（Slider 的轨道 Bar / Dropdown 的触发按钮）
    local function FirstButton(Holder)
        if type(Holder) ~= "table" then return nil end
        local Ok, R = pcall(function() return Holder:FindFirstChildWhichIsA("TextButton") end)
        if Ok and R then return R end
        local OkC, Kids = pcall(function() return Holder:GetChildren() end)
        if OkC and type(Kids) == "table" then
            for _, K in ipairs(Kids) do
                if K.ClassName == "TextButton" then return K end
            end
        end
        return nil
    end

    local function Walk(Node, Depth)
        if type(Node) ~= "table" or Depth > 8 or Seen[Node] then return end
        Seen[Node] = true

        if Node.Type == "Dropdown" then
            if Node.Container then Out.Dropdown[Node.Container] = true end
            local MT = Node.Menu
            if type(MT) == "table" and MT.Menu then Out.Menu[MT.Menu] = true end
        elseif Node.Type == "Slider" then
            local Bar = FirstButton(Node.Holder)
            if Bar then Out.Track[Bar] = true end
        end

        for _, Key in ipairs(Fields) do
            local Child = Node[Key]
            if type(Child) == "table" then
                if Child.Type ~= nil then
                    Walk(Child, Depth + 1)          -- 单个对象（如 SubButton）
                else
                    for _, V in pairs(Child) do     -- 容器（数组或字典）
                        if type(V) == "table" then Walk(V, Depth + 1) end
                    end
                end
            end
        end
    end

    for _, V in pairs(Lib.Tabs) do
        if type(V) == "table" then Walk(V, 0) end
    end
    return Out
end

function DefaultThemeBackground:SyncElementGradients()
    local Lib = self.Library
    if not (Lib and Lib.Registry and Lib.Scheme) then return end
    if not (Instance and Instance.new) then return end

    local WantDrop  = self.EnableDropdownGradient and true or false
    local WantTrack = self.EnableSliderTrackGradient and true or false

    local White = self:GetGradientWhite()
    if not White then return end
    -- 白键：让渐变完整呈现；切主题会整表替换 Scheme，每轮补回
    if Lib.Scheme.YXElemBase ~= White then Lib.Scheme.YXElemBase = White end

    local Sig = self:ElementStopsSignature()
    local Changed = (Sig ~= self._ElemSignature)
    self._ElemSignature = Sig

    -- 结构遍历（递归整个 Tabs）缓存 + 降频：每 0.5s 才重建一次
    local Now = os.clock()
    local Sets = self._CachedElemSets
    if (not Sets) or (Now - (self._ElemSetsAt or 0) >= 0.5) then
        Sets = self:CollectElementGradients()
        self._CachedElemSets = Sets
        self._ElemSetsAt = Now
    end

    -- 色标缓存：签名未变就复用，避免每轮新建 3 个 ColorSequence
    local DropStops  = self._CachedDropStops
    local MenuStops  = self._CachedMenuStops
    local TrackStops = self._CachedTrackStops
    if Changed or not (DropStops and MenuStops and TrackStops) then
        DropStops  = self:GetButtonGradientStops()   -- 触发按钮有白字，沿用按钮那套限亮
        MenuStops  = self:GetMenuGradientStops()
        TrackStops = self:GetSliderTrackStops()
        self._CachedDropStops  = DropStops
        self._CachedMenuStops  = MenuStops
        self._CachedTrackStops = TrackStops
    end

    -- 通用/CSS 角度 -> Roblox：180(上->下)=90，0(下->上)=270
    local function CSSDeg(A, Def)
        local V = tonumber(A); if not V then V = Def end
        return (V - 90) % 360
    end
    local DropRot  = CSSDeg(self.DropdownGradientAngle, 180)
    local MenuRot  = CSSDeg(self.DropdownMenuAngle, 180)
    local TrackRot = (tonumber(self.SliderTrackAngle) or 0) % 360

    local function IsDead(O)
        -- 【真机根因】Roblox 的 Instance 是 userdata，读不存在的自定义成员
        -- （旧写法里的 O._destroyed）会直接抛错，pcall 吞掉后 Ok=false -> 判死，
        -- 整批真实控件被误杀，渐变一个都不建。这份文件里开关全靠 SyncDynamicGradients
        -- 接管，所以默认开启和运行时开启的开关都没有渐变。
        -- 只读 Instance 一定存在的标准属性 ClassName：读得出来就一律视为存活。
        -- 仅在清理登记时调用（次数极少），宽进不误杀。
        if O == nil then return true end
        local Ok = pcall(function() return O.ClassName end)
        return not Ok
    end

    local function Handle(Inst, GName, Stops, Rot, Want)
        if not Inst or IsDead(Inst) then return end
        local Props = Lib.Registry[Inst]
        if not Props then return end

        local OkF, Grad = pcall(function() return Inst:FindFirstChild(GName) end)
        local WasNew = false
        if not (OkF and Grad) then
            if Want and Stops then
                pcall(function()
                    local G = Instance.new("UIGradient")
                    G.Name = GName
                    G.Rotation = Rot
                    G.Color = Stops
                    G.Parent = Inst
                    table.insert(self._ElemGradientObjects, G)
                end)
                OkF, Grad = pcall(function() return Inst:FindFirstChild(GName) end)
                if OkF and Grad then WasNew = true else Grad = nil end
            else
                Grad = nil
            end
        end

        if not (Want and Stops and Grad) then
            -- 关闭 / 无渐变：停用渐变，并把注册键、底色一并交还库按原配色渲染
            if Grad then Grad.Enabled = false end
            local Origin = self._ElemOrigins[Inst]
            if Origin and Props.BackgroundColor3 == "YXElemBase" then
                Props.BackgroundColor3 = Origin
                local C = (type(Origin) == "string") and Lib.Scheme[Origin] or nil
                if C then pcall(function() Inst.BackgroundColor3 = C end) end
            end
            self._ElemTargets[Inst] = nil
            self._ElemOrigins[Inst] = nil
            return
        end

        -- 与「按钮」那路一致的双保险：白基底 + 自定义白键。
        --   库的 UpdateColorsUsingRegistry / 主题切换会把底色刷回 MainColor /
        --   BackgroundColor（深色）；底色不是白的时，渐变与底色叠加会发暗、
        --   看起来就是一块纯色平底。把注册键改成指向白色的 "YXElemBase"
        --   （Lib.Scheme.YXElemBase 每轮补回白色），库回写时也会刷成白色，渐变才稳定可见。
        --   下拉触发条 / 面板 / 滑块轨道的注册键不会被库像 Toggle:Display 那样反复改回，
        --   所以这里改写是安全的，不会互踩。
        local Idx = Props.BackgroundColor3
        if Idx ~= "YXElemBase" then
            self._ElemOrigins[Inst] = Idx
            Props.BackgroundColor3 = "YXElemBase"
        end
        pcall(function()
            if Inst.BackgroundColor3 ~= White then Inst.BackgroundColor3 = White end
        end)

        Grad.Enabled = true
        if WasNew or Changed then Grad.Color = Stops end   -- 创建即写入；主题/背景变化统一刷新
        if Grad.Rotation ~= Rot then Grad.Rotation = Rot end
        self._ElemTargets[Inst] = GName
    end

    for Inst in pairs(Sets.Dropdown) do
        Handle(Inst, "YXDropdownGradient", DropStops, DropRot, WantDrop)
    end
    for Inst in pairs(Sets.Menu) do
        Handle(Inst, "YXMenuGradient", MenuStops, MenuRot, WantDrop)
    end
    for Inst in pairs(Sets.Track) do
        Handle(Inst, "YXSliderTrackGradient", TrackStops, TrackRot, WantTrack)
    end

    -- 已接管的实例若被销毁 / 移出对象模型，清登记（库 Registry 不自动清理死对象）
    for Inst in pairs(self._ElemTargets) do
        if IsDead(Inst) then
            self._ElemTargets[Inst] = nil
            self._ElemOrigins[Inst] = nil
        end
    end
end

function DefaultThemeBackground:InstallGradientSync()
    if not ((self.EnableGradient or self.EnableButtonGradient
             or self.EnableDropdownGradient or self.EnableSliderTrackGradient) and self.Library) then return end
    if self._GradientSyncConn then return end
    local OkSvc, RunService = pcall(function() return game:GetService("RunService") end)
    if not (OkSvc and RunService and RunService.Heartbeat) then return end
    local Module = self
    local Acc = 0
    -- 渐变是静态贴图，无需 20Hz 刷新；默认降到约 8Hz，开关/主题响应仍在 0.12s 内，无感。
    -- 配合下方色标/结构缓存，整体 CPU 占用大幅下降，缓解掉帧。可用 GradientSyncInterval 调整。
    local Interval = tonumber(self.GradientSyncInterval) or 0.12
    local OkConn, Conn = pcall(function()
        return RunService.Heartbeat:Connect(function(dt)
            Acc = Acc + (type(dt) == "number" and dt or 0.016)
            if Acc < Interval then return end
            Acc = 0
            pcall(function() Module:SyncDynamicGradients() end)
            pcall(function() Module:SyncButtonGradients() end)
            pcall(function() Module:SyncElementGradients() end)
        end)
    end)
    if OkConn then self._GradientSyncConn = Conn end
    -- 安装后三路都立即跑一次，启动即生效（不必等首个心跳）：
    --   默认开启的开关、滑块填充也要在首帧就带上渐变。
    pcall(function() self:SyncDynamicGradients() end)
    pcall(function() self:SyncButtonGradients() end)
    pcall(function() self:SyncElementGradients() end)
end

--// 换图 //--
function DefaultThemeBackground:Select(Index)
    local Count = #self.Images
    if Count == 0 then return false, "图片列表为空" end
    if type(Index) ~= "number" then return false, "索引必须是数字" end
    Index = math.max(1, math.min(Count, math.floor(Index)))

    self.LastIndex = Index
    self.LastUrl = self.Images[Index]
    self:ApplyUrl(self.LastUrl)
    if self.ApplyPalette then self:ApplyPaletteFor(Index) end
    self:SaveSelection(Index)
    if type(self.OnSelect) == "function" then pcall(self.OnSelect, Index, self.LastUrl) end
    return true, self.LastUrl
end

function DefaultThemeBackground:Roll()
    local Lib = self.Library
    if not Lib then return false, "尚未调用 SetLibrary" end
    local Count = #self.Images
    if Count == 0 then return false, "图片列表为空" end

    local Index
    if Count == 1 then
        Index = 1
    elseif self.AvoidRepeat and self.LastIndex then
        Index = RandomInt(1, Count - 1)
        if Index >= self.LastIndex then Index = Index + 1 end
    else
        Index = RandomInt(1, Count)
    end

    local Url = self.Images[Index]
    self.LastIndex = Index
    self.LastUrl = Url
    self:ApplyUrl(Url)
    if self.ApplyPalette then self:ApplyPaletteFor(Index) end
    self:SaveSelection(Index)
    if type(self.OnSelect) == "function" then pcall(self.OnSelect, Index, Url) end

    if self.NotifyOnSwitch and Lib.Notify then
        pcall(function()
            Lib:Notify({
                Title = self.NotifyTitle,
                Description = string.format("已切换背景图（第 %d / %d 张）", Index, Count),
                Time = 3,
            })
        end)
    end
    return true, Url
end

--// 挂载 //--
function DefaultThemeBackground:Enable()
    if self.Enabled then return self end
    assert(self.Library, "请先调用 SetLibrary(Library)")
    assert(self.ThemeManager and type(self.ThemeManager.ApplyTheme) == "function", "请先调用 SetThemeManager(ThemeManager)")

    self:InstallCacheOptimizer()
    self:InstallBackgroundTracker()

    -- 启动背景：优先上次保存的选择，否则用默认第 1 张（仅保留背景 1）
    local Startup = self:ReadSelection() or self.StartupImageIndex
    Startup = math.max(1, math.min(#self.Images, Startup))
    self.LastIndex = Startup
    self.LastUrl = self.Images[Startup]
    self:ApplyUrl(self.LastUrl)
    if self.ApplyPalette then self:ApplyPaletteFor(Startup) end
    self:SaveSelection(Startup)

    local Module = self
    local Original = self.ThemeManager.ApplyTheme
    self._OriginalApplyTheme = Original
    self._SkipFirstApply = (self.ThemeManager.AppliedToTab ~= true)

    self.ThemeManager.ApplyTheme = function(Manager, ThemeName, ...)
        local Results = table.pack(Original(Manager, ThemeName, ...))

        if Module.Enabled and type(ThemeName) == "string" and ThemeName ~= "" then
            local Previous = Module.LastAppliedTheme
            local IsFirst = (Previous == nil)
            local Changed = (Previous ~= ThemeName)
            local SkipFirst = IsFirst and Module._SkipFirstApply

            Module.LastAppliedTheme = ThemeName

            if Module:IsDefaultTheme(ThemeName) then
                -- 主题应用会把 BackgroundImage 清空（内置主题数据带 ""），贴回当前背景
                if Changed and not IsFirst then
                    -- 从别的主题「切回默认主题」：ThemeManager 刚用它自己的主题数据
                    -- 整表覆盖了 Scheme，必须强制把「背景 1」配色重新套回，否则回切后
                    -- 停留的是 ThemeManager 的默认主题配色，不是启动时那套默认配色。
                    pcall(function()
                        if Module.LastUrl then Module:ApplyUrl(Module.LastUrl) end
                        if Module.ApplyPalette then
                            Module:ApplyPaletteFor(Module.LastIndex, true)
                        end
                    end)
                elseif Changed and (not SkipFirst or Module.RollOnFirstApply) then
                    pcall(function() Module:Roll() end)
                elseif Module.LastUrl then
                    pcall(function()
                        Module:ApplyUrl(Module.LastUrl)
                        if Module.ApplyPalette then Module:ApplyPaletteFor(Module.LastIndex) end
                    end)
                end
            end

            -- 主题色刚变（切到别的主题 / 切回默认）立即重算各路渐变与白基底，
            -- 不必等下个 0.05s 心跳，切换瞬间配色就跟上。
            if Changed then
                pcall(function() Module:SyncDynamicGradients() end)
                pcall(function() Module:SyncElementGradients() end)
                pcall(function() Module:SyncButtonGradients() end)
            end
        end

        return table.unpack(Results, 1, Results.n)
    end

    self.Enabled = true
    self:InstallGradientSync()
    return self
end

function DefaultThemeBackground:Disable()
    if not self.Enabled then return self end

    if self._GradientSyncConn then
        pcall(function() self._GradientSyncConn:Disconnect() end)
        self._GradientSyncConn = nil
    end

    if self.ThemeManager and self._OriginalApplyTheme then
        self.ThemeManager.ApplyTheme = self._OriginalApplyTheme
    end
    local Lib = self.Library
    local IM = Lib and Lib.ImageManager
    if IM and self._OriginalDownloadAsset then
        IM.DownloadAsset = self._OriginalDownloadAsset
    end
    if Lib and self._OriginalSetBackground then
        Lib.SetBackgroundImage = self._OriginalSetBackground
    end

    if self._SchemeBackup and Lib and Lib.Scheme then
        for Key, Value in pairs(self._SchemeBackup) do
            Lib.Scheme[Key] = Value
        end
        -- 自定义键原本可能不存在（备份值为 nil），pairs 遍历不到，需显式清除
        Lib.Scheme.IconColor = self._SchemeBackup.IconColor
        Lib.Scheme.IconGradientBase = nil
        if Lib.UpdateColorsUsingRegistry then
            pcall(Lib.UpdateColorsUsingRegistry, Lib)
        end
    end
    -- 无论是否走过 ApplyPaletteFor，都清掉自定义 Scheme 键（ApplyGradient 会设置它）
    if Lib and Lib.Scheme then
        Lib.Scheme.IconGradientBase = nil
        Lib.Scheme.ButtonGradientBase = nil
        Lib.Scheme.YXElemBase = nil
    end
    if Lib and Lib.Registry then
        for Inst, List in pairs(self._RegistryBackup) do
            if Lib.Registry[Inst] then
                for _, Entry in ipairs(List) do
                    Lib.Registry[Inst][Entry.Property] = Entry.Value
                end
            end
        end
    end
    -- 下拉触发按钮 / 面板 / 滑块轨道：白键换回原键（MainColor / BackgroundColor）
    if Lib and Lib.Registry then
        for Inst, Origin in pairs(self._ElemOrigins or {}) do
            local Props = Lib.Registry[Inst]
            if Props and Props.BackgroundColor3 == "YXElemBase" then
                Props.BackgroundColor3 = Origin
            end
        end
    end
    for _, Grad in ipairs(self._GradientObjects) do
        pcall(function() Grad:Destroy() end)
    end
    for _, Grad in ipairs(self._ButtonGradientObjects or {}) do
        pcall(function() Grad:Destroy() end)
    end
    for _, Grad in ipairs(self._ElemGradientObjects or {}) do
        pcall(function() Grad:Destroy() end)
    end
    -- 注册表已恢复，再回写一次，把白基底刷回各元素的原始配色
    if Lib and Lib.UpdateColorsUsingRegistry then
        pcall(Lib.UpdateColorsUsingRegistry, Lib)
    end

    self._OriginalApplyTheme = nil
    self._OriginalDownloadAsset = nil
    self._OriginalSetBackground = nil
    self._SchemeBackup = nil
    self._RegistryBackup = {}
    self._GradientObjects = {}
    self._CachedAssets = {}
    self._TargetsCollected = false
    self._IconsTinted = false
    self._DynamicTargets = {}
    self._StopsSignature = nil
    self._IconStopsSignature = nil
    self._AccentStopsSignature = nil
    self._ButtonTargets = {}
    self._ButtonGradientObjects = {}
    self._ButtonSignature = nil
    self._ElemTargets = {}
    self._ElemOrigins = {}
    self._ElemGradientObjects = {}
    self._ElemSignature = nil
    self._PaletteApplied = nil
    self.LastAppliedTheme = nil
    self.Enabled = false
    return self
end

local Bg = DefaultThemeBackground
Bg:SetLibrary(Library):SetThemeManager(ThemeManager)
-- ==================== 模块定义结束 ====================

-- 「背景图片」选择下拉已移除：只保留背景 1，由 Bg:Enable() 自动套用，
--   不在「UI 设置」里再显示切换项。OnSelect 保持默认 nil（模块内部调用都有判空保护）。
Bg:Enable()

SaveManager:LoadAutoloadConfig()

--    YXGradientBorder:Enable()          -- 窗口 + 标签页一起开（默认）
--    YXGradientBorder:Disable()         -- 全部关闭
--    YXGradientBorder:EnableTabs()      -- 只开标签页边框
--    YXGradientBorder:DisableTabs()     -- 只关标签页边框
--    YXGradientBorder:EnableWindow()    -- 只开窗口边框
--    YXGradientBorder:DisableWindow()   -- 只关窗口边框
--    YXGradientBorder:SetColors(Color3, Color3)   -- 端点 / 中点（覆盖默认的 亮青/浅青）
--    YXGradientBorder:SetSpeed(90)     -- 窗口渐变速度（度/秒）
--    YXGradientBorder:SetThickness(4)  -- 窗口描边粗细
--    YXGradientBorder:SetPulse(true)   -- 窗口描边呼吸
--    YXGradientBorder:SetTabSpeed(90)             -- 标签页渐变速度
--    YXGradientBorder:SetTabThickness(2, 3)       -- 未选中 / 选中粗细
--    YXGradientBorder:SetTabIdleTransparency(0.5) -- 未选中淡化程度
--    YXGradientBorder:SetTabRadius(8)             -- 圆角；传 nil 恢复自动跟随
--    YXGradientBorder:SetTabOnlyActive(true)      -- 只给选中的标签显示
--    YXGradientBorder:SetTabIncludeContent(true)  -- 连标签内容区也加
--    YXGradientBorder:EnableNotifs()   -- 只开通知流动渐变描边（Enable 时已自动开）
--    YXGradientBorder:DisableNotifs()  -- 只关通知描边
--    YXGradientBorder:SetNotifSpeed(90)       -- 通知渐变旋转速度
--    YXGradientBorder:SetNotifThickness(2)    -- 通知描边粗细
--  通知由库动态创建/销毁，模块每 0.2s 差量扫描 Library.Notifications，自动挂载与清理。
--  窗口 / 标签页 / 通知边框统一「跟随主题强调色 + 雾蓝调和」，切主题一起换色，不再写死青色。
--  窗口辉光「采用库自带 WindowGlow」：
--    贴图资源复刻库 CustomImageManager.GetAsset("Glow")：优先库本地 Glow.png
--    （getcustomasset "Obsidian/assets/Glow.png"），失败回退 RobloxId；颜色沿用库
--    GetBetterColor(AccentColor, -1) 微调，挂 ScreenGui 作窗口同级兄弟、跟随窗口。
--  【灰框修复】库 Glow.png 中心约 90% 是实心、仅最外约 5% 羽化；库靠「不透明窗口」
--    盖住实心中心只露一圈柔光。本脚本窗口带背景图偏透明，实心中心透出来就是一整块
--    灰蓝矩形（灰框）。故在「辉光(最底) / 遮心板 / 窗口(最上)」之间补一层与窗口等大、
--    不透明的窗口底色板：只留窗口边框外扩一圈羽化可见 = 真正的边框辉光，灰块消失。
--  这是「辉光贴图」，不是背景图：不铺内容、不遮控件、不挡点击（Active=false）。
--  改 YXGradientBorder.Glow.xxx 调整：Offset / LocalPath / Image / Transparency /
--    FollowAccent / MaskColor / Radius；运行时开关 YXGradientBorder:SetGlow(true / false)
--  也可直接改 YXGradientBorder.Tabs.xxx / Notifs.xxx（见下方配置表）后即生效。
-- ============================================================

local YXGradientBorder = (function(Library)
    local M = {}

    -- Library 由末尾 (...)(Library) 显式传入，避免 local 作用域歧义
    local RunService = game:GetService("RunService")

    -- ===== 窗口边框参数（v1 保持兼容）=====
    M.Radius       = 12     -- 与 Window:SetCornerRadius(12) 保持一致
    M.Thickness    = 4
    M.Transparency = 0
    M.Speed        = 120
    M.Pulse        = true
    M.Name         = "YXGradientBorder"
    -- 边框颜色默认跟随主题强调色（雾蓝调和），切主题自动换色。
    --   想固定颜色：把下面两行填成 Color3.fromRGB(...)，并把 FollowTheme 设为 false。
    --   也可运行时调 YXGradientBorder:SetColors(Color3, Color3) 临时覆盖。
    M.FollowTheme  = true   -- true = 边框跟随主题强调色；false = 用下面两个固定色
    M.EdgeColor    = nil    -- 端点：默认由主题色压暗得到
    M.MidColor     = nil    -- 中点：默认由主题色提亮得到的高光

    -- ===== 标签页边框参数 =====
    M.Tabs = {
        Enabled            = false,
        AutoEnable         = true,   -- Enable() 时自动一并开启标签页
        Radius             = nil,    -- nil = 自动跟随按钮自带 UICorner；填数字覆盖
        Thickness          = 2,      -- 未选中标签描边粗细
        ActiveThickness    = 3,      -- 选中标签描边粗细
        IdleTransparency   = 0.5,    -- 未选中标签描边淡化（0=实色 1=全隐）
        ActiveTransparency = 0,      -- 选中标签描边透明度
        Speed              = 120,    -- 标签渐变旋转速度（度/秒）
        OnlyActive         = false,  -- true = 只有选中的标签显示边框
        IncludeContent     = false,  -- true = 连 Tab.Container 内容区也加边框
        ContentThickness   = 2,
        ContentRadius      = 8,
        Name               = "YXGradientBorder_Tab",
    }

    -- ===== 通知边框参数（流动渐变描边，动态出现的通知自动挂上）=====
    M.Notifs = {
        Enabled        = false,
        AutoEnable     = true,   -- Enable() 时自动一并开启
        Radius         = nil,    -- nil = 自动跟随通知自带 UICorner
        Thickness      = 2,
        Transparency   = 0,
        Speed          = 120,    -- 渐变旋转速度（度/秒）
        Name           = "YXGradientBorder_Notif",
    }

    -- ===== 窗口辉光（采用库 WindowGlow + 遮心板修灰框，只作用于窗口）=====
    --   层级（ScreenGui 同级、Sibling 按 ZIndex）：辉光(mfz-2) < 遮心板(mfz-1) < 窗口(mfz)
    --   辉光：库 Glow.png 贴图，对齐「窗口 + 外扩 Offset」，跟随窗口拖动 / 缩放 / 显隐。
    --   遮心板：与窗口等大、不透明、窗口底色、同圆角 —— 盖住辉光贴图的实心中心，
    --     只留窗口外扩一圈的羽化边可见。库靠不透明窗口盖中心，这里补这块板补上同一前提，
    --     窗口带背景图半透明也不会再透出灰蓝矩形（灰框）。
    M.Glow = {
        Enabled      = true,
        Offset       = 30,    -- 向外扩展像素（辉光比窗口大 Offset*2，露出的就是这一圈）
        LocalPath    = "Obsidian/assets/Glow.png",      -- 库 CustomImageManager 下载到本地的路径
        Image        = "rbxassetid://88645182616510",  -- 库 assets/Glow.png 的 RobloxId（回退）
        Transparency = 0,     -- 贴图透明度（库窗口版默认 0；调大更淡）
        FollowAccent = true,  -- 跟随 Scheme.AccentColor；关掉则固定为创建时的颜色
        MaskColor    = nil,   -- 遮心板颜色；nil = 自动跟随当前主题 BackgroundColor
        Name         = "YXWindowGlow",
    }

    M.Enabled = false   -- 窗口边框状态（标签页状态见 M.Tabs.Enabled / M.Notifs.Enabled）

    -- ===== 运行时 =====
    local winFrame, winCorner, winStroke, winGrad = nil, nil, nil, nil
    local winGlow = nil            -- 窗口辉光 ImageLabel（仅窗口有）
    local winGlowMask = nil        -- 遮心板 Frame（盖住辉光实心中心，消除灰框）
    local winGlowMaskColor = nil   -- 上次写入遮心板的底色，避免重复赋值
    local winMainFrame = nil       -- 窗口 MainFrame 引用，供辉光跟随位置/尺寸/显隐
    local winGlowColor = nil       -- 上次写入的 ImageColor3，避免每帧重复赋值
    local winConn, tabConn = nil, nil
    local winLast, tabLast, tabAngle, scanAcc = 0, 0, 0, 0
    local glowAcc = 0             -- 辉光取色降频累加器（0.12s 一次）
    local manualSeq = nil
    local tabItems = {}   -- [目标对象] = {frame, corner, stroke, grad, kind, tab}
    local notifItems = {} -- [通知 Holder] = {frame, corner, stroke, grad}
    local notifConn = nil
    local notifLast, notifAngle, notifScanAcc = 0, 0, 0

    local function clamp01(v)
        if v < 0 then return 0 elseif v > 1 then return 1 end
        return v
    end
    local function shade(c, factor)
        -- factor>1 提亮，<1 压暗；限制到 [0,1]
        return Color3.new(
            clamp01(c.R * factor),
            clamp01(c.G * factor),
            clamp01(c.B * factor)
        )
    end

    -- 读取主题强调色并做雾蓝调和（与控件、边框同一套取色），
    --   再经库自带的 GetBetterColor 微调，和 NOL 版辉光保持一致。
    local function ReadAccentColor()
        local Base = YXThemeAccentRGB(Library, true)
        local Col = Color3.new(Base[1], Base[2], Base[3])
        local Better = Library and Library.GetBetterColor
        if type(Better) == "function" then
            local Ok, C = pcall(Better, Library, Col, -1)
            if Ok and C then return C end
        end
        return Col
    end

    -- 采用库自带辉光资源：复刻库 CustomImageManager.GetAsset("Glow") 的取图逻辑，
    --   优先库下载到本地的 Glow.png（getcustomasset），失败再回退同一 RobloxId。
    local function ResolveGlowImage()
        local Path = (M.Glow and M.Glow.LocalPath) or "Obsidian/assets/Glow.png"
        if type(getcustomasset) == "function" then
            local Ok, Id = pcall(getcustomasset, Path)
            if Ok and Id and Id ~= "" then return Id end
        end
        return (M.Glow and M.Glow.Image) or "rbxassetid://88645182616510"
    end

    -- 遮心板底色：跟随当前主题的窗口背景色（切主题自动变），回退 MainFrame 背景色。
    local function ReadWindowBg(mf)
        local C = nil
        pcall(function()
            if Library and Library.Scheme then C = Library.Scheme.BackgroundColor end
        end)
        if C then return C end
        if mf then pcall(function() C = mf.BackgroundColor3 end) end
        return C or Color3.fromRGB(20, 28, 42)
    end

    -- 边框配色：跟随主题强调色（雾蓝调和），主题变化即重建序列，不再写死青色。
    --   端点 = 主题色压暗，中点 = 主题色提亮降饱和的高光；0 与 1 端点相同，旋转接缝平滑。
    --   窗口 / 标签页 / 通知三处每帧都取本函数返回值，主题一变三处一起更新。
    --   签名计算降频到 0.12s，平时直接返回缓存，不增加每帧开销。
    --   SetColors() 的 manualSeq 优先级最高，仍可运行时覆盖。
    local function BuildThemeColors()
        if M.FollowTheme == false then
            return M.EdgeColor or Color3.fromRGB(140, 180, 220),
                   M.MidColor  or Color3.fromRGB(190, 215, 240)
        end
        local Base = YXThemeAccentRGB(Library, true)
        local H, S, V = Color3.new(Base[1], Base[2], Base[3]):ToHSV()
        local Edge = M.EdgeColor or Color3.fromHSV(H, S, math.min(V, 0.80))
        local Mid  = M.MidColor  or Color3.fromHSV(H, math.max(0.10, S * 0.55), math.min(1, V + 0.12))
        return Edge, Mid
    end

    local themeSeq, themeSig, themeCheckAt = nil, nil, 0
    local function buildSequence()
        if manualSeq then return manualSeq end
        local now = os.clock()
        if themeSeq and (now - themeCheckAt) < 0.12 then return themeSeq end
        themeCheckAt = now
        local Edge, Mid = BuildThemeColors()
        local Sig = string.format("%.4f,%.4f,%.4f|%.4f,%.4f,%.4f",
            Edge.R, Edge.G, Edge.B, Mid.R, Mid.G, Mid.B)
        if Sig ~= themeSig then
            themeSig = Sig
            themeSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Edge),
                ColorSequenceKeypoint.new(0.30, Edge),
                ColorSequenceKeypoint.new(0.50, Mid),
                ColorSequenceKeypoint.new(0.70, Edge),
                ColorSequenceKeypoint.new(1.00, Edge),
            })
        end
        return themeSeq
    end

    local function getMainFrame()
        if not Library then return nil end
        local w = Library.Window
        local mf = w and w.MainFrame
        if mf and mf.Parent then return mf end
        return nil
    end

    -- 通用：在 parent 内建一层透明描边框（所有目标共用这一套机制）
    local function newBorder(parent, radius, thickness, inset, name)
        local f = Instance.new("Frame")
        f.Name = name or "YXGradientBorder"
        f.Size = UDim2.new(1, -inset * 2, 1, -inset * 2)
        f.Position = UDim2.fromOffset(inset, inset)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.Active = false                 -- 不挡点击
        f.ZIndex = 999                  -- 盖在内容之上
        f.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 0)
        c.Parent = f

        local s = Instance.new("UIStroke")
        s.Name = "GradientStroke"
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Thickness = thickness
        s.Transparency = 0
        s.Color = Color3.new(1, 1, 1)    -- 白基底仅用于让 UIGradient 完整显色，不是可见白色
        s.Parent = f

        local g = Instance.new("UIGradient")
        g.Name = "BorderGradient"
        g.Enabled = true
        g.Color = buildSequence()
        g.Rotation = 0
        g.Parent = s

        return { frame = f, corner = c, stroke = s, grad = g }
    end

    -- ========================================================
    -- 窗口辉光：采用库 WindowGlow 贴图 + 遮心板消除灰框。
    --   Glow.png 中心约 90% 实心、仅最外约 5% 羽化。库把整张图垫在「不透明窗口」后，
    --   中心被窗口盖住，只露外扩一圈羽化 = 边框柔光。本脚本窗口带背景图偏透明，
    --   实心中心会透成一整块灰蓝矩形（灰框），故补一层「遮心板」补上这个前提：
    --     辉光(ZIndex=mfz-2) < 遮心板(mfz-1) < 窗口(mfz)
    --   遮心板与窗口等大、不透明、窗口底色、同圆角，盖住实心中心；只有超出窗口边缘
    --   的外扩一圈羽化可见。三者均挂 ScreenGui 同级，由 syncGlowBounds 每帧跟随。
    --   这是辉光贴图，不是背景图：不铺内容、不遮控件、不挡点击（Active=false）。
    -- ========================================================
    local function newGlow(mf)
        if not (M.Glow and M.Glow.Enabled) then return nil end
        local Host = mf.Parent          -- ScreenGui：与 MainFrame 同级
        if not Host then return nil end
        local Off = M.Glow.Offset or 10
        local mfz = 1
        pcall(function() mfz = mf.ZIndex or 1 end)
        local Ok, L = pcall(function()
            local G = Instance.new("ImageLabel")
            G.Name = M.Glow.Name or "YXWindowGlow"
            G.BackgroundTransparency = 1
            G.BorderSizePixel = 0
            G.Image = ResolveGlowImage()   -- 采用库 Glow 资源（本地优先 / RobloxId 回退）
            G.ImageTransparency = M.Glow.Transparency or 0
            G.ImageColor3 = ReadAccentColor() or Color3.fromRGB(130, 200, 248)
            G.Active = false
            G.ZIndex = math.max(-2, mfz - 2)   -- 最底层：辉光
            local ap, as = mf.AbsolutePosition, mf.AbsoluteSize
            G.Position = UDim2.fromOffset(ap.X - Off, ap.Y - Off)
            G.Size = UDim2.fromOffset(as.X + Off * 2, as.Y + Off * 2)
            G.Visible = mf.Visible
            G.Parent = Host
            return G
        end)
        if not (Ok and L) then return nil end

        -- 遮心板：与窗口等大、不透明、窗口底色、同圆角，盖住辉光实心中心。
        --   介于辉光与窗口之间，窗口半透明也不会再透出灰蓝实心块（灰框）。
        pcall(function()
            local Mask = Instance.new("Frame")
            Mask.Name = (M.Glow.Name or "YXWindowGlow") .. "Mask"
            Mask.BorderSizePixel = 0
            Mask.BackgroundTransparency = 0
            Mask.BackgroundColor3 = (M.Glow.MaskColor ~= nil and M.Glow.MaskColor) or ReadWindowBg(mf)
            Mask.Active = false
            Mask.ZIndex = math.max(-1, mfz - 1)   -- 高于辉光、低于窗口
            local ap, as = mf.AbsolutePosition, mf.AbsoluteSize
            Mask.Position = UDim2.fromOffset(ap.X, ap.Y)
            Mask.Size = UDim2.fromOffset(as.X, as.Y)
            Mask.Visible = mf.Visible
            Mask.Parent = Host
            local mc = Instance.new("UICorner")
            mc.CornerRadius = UDim.new(0, M.Radius or 12)
            mc.Parent = Mask
            winGlowMask = Mask
            winGlowMaskColor = Mask.BackgroundColor3
        end)

        winMainFrame = mf
        winGlowColor = L.ImageColor3
        return L
    end

    -- 每 0.12s 取一次主题色，仅在颜色变化时写入 ImageColor3（不产生每帧赋值）
    local function syncGlowColor()
        if not (M.Glow and M.Glow.FollowAccent and winGlow) then return end
        local C = ReadAccentColor()
        if C and C ~= winGlowColor then
            winGlowColor = C
            pcall(function() winGlow.ImageColor3 = C end)
        end
    end

    -- 遮心板底色跟随主题（切主题时窗口底色变了，遮心板要一起变，避免露出旧色块）
    local function syncGlowMaskColor()
        if not winGlowMask then return end
        local Bg = (M.Glow and M.Glow.MaskColor ~= nil and M.Glow.MaskColor) or ReadWindowBg(winMainFrame)
        if Bg and Bg ~= winGlowMaskColor then
            winGlowMaskColor = Bg
            pcall(function() winGlowMask.BackgroundColor3 = Bg end)
        end
    end

    -- 辉光跟随窗口：位置 / 尺寸 / 显隐。Sibling 模式下辉光是窗口同级兄弟，
    -- 不会随 MainFrame 自动变换，需按 AbsolutePosition/AbsoluteSize 对齐。
    -- 每帧调用但带变化判断，仅在窗口拖动 / 缩放 / 显隐变化时才写属性。
    local function syncGlowBounds()
        if not (winGlow and winMainFrame) then return end
        pcall(function()
            local mf = winMainFrame
            local ap, as = mf.AbsolutePosition, mf.AbsoluteSize
            local Off = (M.Glow and M.Glow.Offset) or 10
            local pos = UDim2.fromOffset(ap.X - Off, ap.Y - Off)
            local size = UDim2.fromOffset(as.X + Off * 2, as.Y + Off * 2)
            if winGlow.Position ~= pos then winGlow.Position = pos end
            if winGlow.Size ~= size then winGlow.Size = size end
            if winGlow.Visible ~= mf.Visible then winGlow.Visible = mf.Visible end
            if winGlowMask then
                local mpos = UDim2.fromOffset(ap.X, ap.Y)
                local msize = UDim2.fromOffset(as.X, as.Y)
                if winGlowMask.Position ~= mpos then winGlowMask.Position = mpos end
                if winGlowMask.Size ~= msize then winGlowMask.Size = msize end
                if winGlowMask.Visible ~= mf.Visible then winGlowMask.Visible = mf.Visible end
            end
        end)
    end

    -- ========================================================
    -- 窗口边框
    -- ========================================================
    function M:EnableWindow()
        if winFrame and winFrame.Parent then return self end
        local mf = getMainFrame()
        if not mf then
            warn("YXGradientBorder: 未找到 Library.Window.MainFrame，请在 CreateWindow 之后调用 Enable()")
            return self
        end

        local b = newBorder(mf, M.Radius, M.Thickness, 0, M.Name)
        winFrame, winCorner, winStroke, winGrad = b.frame, b.corner, b.stroke, b.grad
        winStroke.Transparency = M.Transparency
        winGlow = newGlow(mf)
        M.Enabled = true
        winLast = os.clock()

        winConn = RunService.Heartbeat:Connect(function()
            if not (winFrame and winFrame.Parent) then M:DisableWindow(); return end
            local now = os.clock()
            local dt = now - winLast
            winLast = now
            if not manualSeq then
                local seq = buildSequence()
                winGrad.Color = seq
            end
            local rot = (winGrad.Rotation + M.Speed * dt) % 360
            winGrad.Rotation = rot
            syncGlowBounds()            -- 辉光跟随窗口（拖动 / 缩放 / 显隐）
            glowAcc = glowAcc + dt
            if glowAcc >= 0.12 then
                glowAcc = 0
                syncGlowColor()
                syncGlowMaskColor()
            end
            if M.Pulse then
                winStroke.Thickness = M.Thickness + math.sin(now * 3) * 0.4
            end
        end)
        return self
    end

    function M:DisableWindow()
        if winConn then pcall(function() winConn:Disconnect() end); winConn = nil end
        if winFrame then pcall(function() winFrame:Destroy() end) end
        if winGlowMask then pcall(function() winGlowMask:Destroy() end) end
        winGlowMask = nil
        winGlowMaskColor = nil
        if winGlow then pcall(function() winGlow:Destroy() end) end
        winGlow = nil
        winGlowColor = nil
        winMainFrame = nil
        winFrame, winCorner, winStroke, winGrad = nil, nil, nil, nil
        M.Enabled = false
        return self
    end

    -- ========================================================
    -- 标签页边框
    -- ========================================================
    local function buttonRadius(btn)
        local r = M.Tabs.Radius
        if type(r) == "number" then return r end
        -- 库默认 TabButtonsStyle.CornerRadius = 0；跟随按钮自身 UICorner 最稳
        local ok, c = pcall(function()
            return btn.FindFirstChildOfClass and btn:FindFirstChildOfClass("UICorner")
        end)
        if ok and c and c.CornerRadius then return c.CornerRadius.Offset or 0 end
        return 0
    end

    -- 收集当前所有标签目标（同时覆盖普通 Tab 与 KeyTab）
    local function collectTargets()
        local out = {}
        if not (Library and type(Library.Tabs) == "table") then return out end
        for _, tab in pairs(Library.Tabs) do
            if type(tab) == "table" then
                if tab.Button then
                    out[#out + 1] = { tab = tab, obj = tab.Button, kind = "button" }
                end
                if M.Tabs.IncludeContent and tab.Container then
                    out[#out + 1] = { tab = tab, obj = tab.Container, kind = "content" }
                end
            end
        end
        return out
    end

    -- 差量同步：新标签自动挂上，已销毁 / 不再需要的自动移除
    local function syncTargets()
        local seen = {}
        for _, t in ipairs(collectTargets()) do
            local obj = t.obj
            seen[obj] = true
            local item = tabItems[obj]
            if not item then
                local radius, thick
                if t.kind == "button" then
                    radius, thick = buttonRadius(obj), M.Tabs.Thickness
                else
                    radius, thick = M.Tabs.ContentRadius, M.Tabs.ContentThickness
                end
                item = newBorder(obj, radius, thick, 1, M.Tabs.Name)
                item.kind = t.kind
                tabItems[obj] = item
            end
            item.tab = t.tab   -- 选中态判断每次刷新
        end
        for obj, item in pairs(tabItems) do
            if not seen[obj] then
                pcall(function() item.frame:Destroy() end)
                tabItems[obj] = nil
            end
        end
    end

    function M:EnableTabs()
        if M.Tabs.Enabled then return self end
        M.Tabs.Enabled = true
        tabLast = os.clock()
        scanAcc = 0
        syncTargets()

        tabConn = RunService.Heartbeat:Connect(function()
            local now = os.clock()
            local dt = now - tabLast
            tabLast = now
            local seq = buildSequence()
            tabAngle = (tabAngle + M.Tabs.Speed * dt) % 360

            -- 每 0.2s 扫一次新增/销毁的标签（切页无需每帧扫）
            scanAcc = scanAcc + dt
            if scanAcc >= 0.2 then scanAcc = 0; syncTargets() end

            local activeTab = Library and Library.ActiveTab
            for obj, item in pairs(tabItems) do
                if item.frame and item.frame.Parent then
                    item.grad.Color = seq
                    item.grad.Rotation = tabAngle
                    if item.kind == "button" then
                        local active = (item.tab == activeTab)
                        local show = active or not M.Tabs.OnlyActive
                        item.stroke.Thickness = active
                            and M.Tabs.ActiveThickness or M.Tabs.Thickness
                        item.stroke.Transparency = show
                            and (active and M.Tabs.ActiveTransparency
                                       or M.Tabs.IdleTransparency)
                            or 1
                    else
                        item.stroke.Thickness = M.Tabs.ContentThickness
                        item.stroke.Transparency = 0
                    end
                end
            end
        end)
        return self
    end

    function M:DisableTabs()
        if tabConn then pcall(function() tabConn:Disconnect() end); tabConn = nil end
        for obj, item in pairs(tabItems) do
            pcall(function() item.frame:Destroy() end)
            tabItems[obj] = nil
        end
        M.Tabs.Enabled = false
        return self
    end

    -- ========================================================
    -- 通知边框（流动渐变描边）
    --   通知由 Library:Notify 动态创建、几秒后销毁，存在 Library.Notifications 里
    --   （key = FakeBackground，value = Data，Data.Holder 是通知主体 Frame）。
    --   因此照标签页那套做差量同步：每 0.2s 扫一次，新通知自动挂、销毁的自动清。
    -- ========================================================
    local function notifRadius(holder)
        local r = M.Notifs.Radius
        if type(r) == "number" then return r end
        local ok, c = pcall(function()
            return holder.FindFirstChildOfClass and holder:FindFirstChildOfClass("UICorner")
        end)
        if ok and c and c.CornerRadius then return c.CornerRadius.Offset or 0 end
        return 0
    end

    local function collectNotifs()
        local out = {}
        if not (Library and type(Library.Notifications) == "table") then return out end
        for _, Data in pairs(Library.Notifications) do
            if type(Data) == "table" and Data.Holder then
                local holder = Data.Holder
                local ok, parent = pcall(function() return holder.Parent end)
                if ok and parent then out[#out + 1] = holder end
            end
        end
        return out
    end

    local function syncNotifs()
        local seen = {}
        for _, holder in ipairs(collectNotifs()) do
            seen[holder] = true
            local item = notifItems[holder]
            if not item then
                item = newBorder(holder, notifRadius(holder), M.Notifs.Thickness, 0, M.Notifs.Name)
                item.stroke.Transparency = M.Notifs.Transparency
                notifItems[holder] = item
            end
        end
        for holder, item in pairs(notifItems) do
            if not seen[holder] then
                pcall(function() item.frame:Destroy() end)
                notifItems[holder] = nil
            end
        end
    end

    function M:EnableNotifs()
        if M.Notifs.Enabled then return self end
        M.Notifs.Enabled = true
        notifLast = os.clock()
        notifScanAcc = 0
        syncNotifs()
        notifConn = RunService.Heartbeat:Connect(function()
            local now = os.clock()
            local dt = now - notifLast
            notifLast = now
            local seq = buildSequence()   -- 已按主题色缓存，不会每帧新建
            notifAngle = (notifAngle + M.Notifs.Speed * dt) % 360
            notifScanAcc = notifScanAcc + dt
            if notifScanAcc >= 0.2 then notifScanAcc = 0; syncNotifs() end
            for _, item in pairs(notifItems) do
                if item.frame and item.frame.Parent then
                    item.grad.Color = seq
                    item.grad.Rotation = notifAngle
                end
            end
        end)
        return self
    end

    function M:DisableNotifs()
        if notifConn then pcall(function() notifConn:Disconnect() end); notifConn = nil end
        for holder, item in pairs(notifItems) do
            pcall(function() item.frame:Destroy() end)
            notifItems[holder] = nil
        end
        M.Notifs.Enabled = false
        return self
    end

    -- ========================================================
    -- 统一开关 + Setter
    -- ========================================================
    function M:Enable()
        M:EnableWindow()
        if M.Tabs.AutoEnable ~= false then M:EnableTabs() end
        if M.Notifs.AutoEnable ~= false then M:EnableNotifs() end
        return self
    end

    function M:Disable()
        M:DisableNotifs()
        M:DisableTabs()
        M:DisableWindow()
        return self
    end

    function M:SetColors(edge, mid)
        -- 传 nil, nil 恢复「跟随主题强调色」的默认边框配色
        if edge == nil and mid == nil then
            manualSeq = nil
            themeSig = nil      -- 强制下一轮按当前主题重建
            themeCheckAt = 0
        else
            edge = edge or Color3.fromRGB(34, 211, 238)
            mid  = mid  or edge
            manualSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   edge),
                ColorSequenceKeypoint.new(0.5, mid),
                ColorSequenceKeypoint.new(1,   edge),
            })
        end
        local seq = buildSequence()
        if winGrad then winGrad.Color = seq end
        -- 窗口辉光跟 Scheme.AccentColor，不跟边框色序列，这里不动它
        for _, item in pairs(tabItems) do
            if item.grad then item.grad.Color = seq end
        end
        for _, item in pairs(notifItems) do
            if item.grad then item.grad.Color = seq end
        end
        return self
    end

    -- 对应库自带的 Library:SetGlow / Window:SetGlow：运行时开关窗口辉光
    function M:SetGlow(State)
        M.Glow.Enabled = State and true or false
        if not M.Glow.Enabled then
            if winGlowMask then pcall(function() winGlowMask:Destroy() end) end
            winGlowMask = nil
            winGlowMaskColor = nil
            if winGlow then pcall(function() winGlow:Destroy() end) end
            winGlow = nil
            winGlowColor = nil
        elseif not winGlow and M.Enabled then
            local mf = getMainFrame()
            if mf then winGlow = newGlow(mf) end
        end
        return self
    end

    function M:SetSpeed(v)   if type(v) == "number" then M.Speed = v end; return self end
    function M:SetThickness(v)
        if type(v) == "number" then
            M.Thickness = v
            if winStroke then winStroke.Thickness = v end
        end
        return self
    end
    function M:SetPulse(v)   M.Pulse = v and true or false; return self end

    function M:SetTabSpeed(v)
        if type(v) == "number" then M.Tabs.Speed = v end
        return self
    end
    function M:SetTabThickness(idle, active)
        if type(idle) == "number" then M.Tabs.Thickness = idle end
        if type(active) == "number" then M.Tabs.ActiveThickness = active end
        return self
    end
    function M:SetTabIdleTransparency(v)
        if type(v) == "number" then M.Tabs.IdleTransparency = clamp01(v) end
        return self
    end
    function M:SetTabRadius(v)
        -- nil = 恢复自动跟随按钮自身 UICorner
        M.Tabs.Radius = (type(v) == "number") and v or nil
        if M.Tabs.Enabled then
            for obj, item in pairs(tabItems) do
                if item.kind == "button" and item.corner then
                    item.corner.CornerRadius = UDim.new(0, buttonRadius(obj))
                end
            end
        end
        return self
    end
    function M:SetTabOnlyActive(v)
        M.Tabs.OnlyActive = v and true or false
        return self
    end
    function M:SetTabIncludeContent(v)
        M.Tabs.IncludeContent = v and true or false
        if M.Tabs.Enabled then syncTargets() end
        return self
    end
    function M:SetNotifSpeed(v)
        if type(v) == "number" then M.Notifs.Speed = v end
        return self
    end
    function M:SetNotifThickness(v)
        if type(v) == "number" then
            M.Notifs.Thickness = v
            if M.Notifs.Enabled then
                for _, item in pairs(notifItems) do item.stroke.Thickness = v end
            end
        end
        return self
    end

    return M
end)(Library)

YXGradientBorder:Enable()
-- ============================================================================
-- 窗口标题 / 页脚「逐词流光渐变」：接管 CreateWindow 生成的 WindowTitle 与
--   FooterLabel 这两个 TextLabel（文字本身不被修改）。
--   · 逐词渐变：原来一整条 UIGradient 横跨整串文字，靠后的词只能分到渐变的一小段，
--     看起来发暗。现在把文字按词拆开，每个词一个 TextLabel、各自挂一条 UIGradient，
--     于是每个词内部都能完整走一遍渐变（YX-SCRPIT => "YX-" 一条、"SCRPIT" 一条）。
--   · 流动：所有词共用同一个相位，UIGradient.Offset 同步位移，高光带沿文字横向
--     循环扫过；M.WordPhaseStep 可让词与词错开相位，形成波浪。
--   · 实现方式：在原来那个 TextLabel 内部挂一个尺寸 1:1 的透明子 Frame，把原文
--     字设成全透明，子 Frame 里用 UIListLayout 横向排布每个词。
--     原 Label 不移位、不缩放、不销毁 —— 库的 Window:ChangeTitle / Window:SetFooter
--     以及侧边栏收缩时对 Visible 的切换全部照常生效（子 Frame 是它的子物体，
--     Label 隐身时跟着隐身），窗口布局一点不受影响。
--   · 颜色：取自 Library.Scheme.AccentColor，复用模块顶部同一套雾蓝调和，切换主题
--     时和边框 / 按钮 / 滑块一起变，不写死青色。
--   · 回退：文字里含富文本标记、开了 TextScaled、或拆不出 2 个词以上时，自动退回
--     「整串一条渐变」的老实现，不会出错。
-- ============================================================================
local YXTitleFlow = (function(Library)
    local M = {}

    -- 可调配置 -------------------------------------------------------------
    M.Enabled                = true
    M.WordSplit              = true            -- true=每个词各自一条渐变；false=整串一条（旧行为）
    M.WordSeparators         = { " ", "-" }    -- 分词符（分隔符留在前一个词末尾，不丢字符）
    M.WordPhaseStep          = 0               -- 词与词的相位错开量（0=完全同步，0.12≈波浪）
    M.FooterEnabled          = true            -- 页脚 Footer 也逐词渐变
    M.FooterTextTransparency = 0               -- 仅回退路径使用（整串渐变时页脚原 0.5 太淡）
    M.Speed                  = 0.45            -- 流光速度：每秒扫过多少个文字宽度
    M.Interval               = 1 / 30          -- 属性写入间隔（计时逐帧，写入约 30Hz）
    M.ThemeCheckInterval     = 0.12            -- 主题色签名检查间隔
    M.RetryInterval          = 0.25            -- 窗口尚未创建 / 文字刚变过时的重建间隔
    M.Rotation               = 0               -- 渐变角度（0 = 水平扫过）
    M.BaseWhite              = 0.28            -- 常态文字色向白色靠拢比例（保留主题色相）
    M.HighWhite              = 0.88            -- 高光带向白色靠拢比例（接近白）
    M.BandWidth              = 0.20            -- 高光带半宽（相对单条渐变）
    M.Name                   = "YXTitleFlow"

    -- 结尾的普通空格在部分字体下会被裁掉，换成不换行空格保证词间距不丢
    local NBSP = "\xC2\xA0"

    local OkRun, RunService = pcall(function() return game:GetService("RunService") end)
    local Heartbeat = (OkRun and RunService and RunService.Heartbeat) or nil

    local Conn = nil
    local BoundMF = nil         -- 当前接管的窗口 MainFrame（窗口被重建时换新）
    local Targets = {}          -- 每个接管对象：{ Label, Row, Words, Grad, OrigTT, OrigText }
    local Seq, Sig, AppliedSeq = nil, nil, nil
    local Phase, LastFrame = 0, 0
    local WriteAcc, ThemeAcc, RetryAcc = 0, 0, 0

    local function Clamp(V, Lo, Hi)
        if V < Lo then return Lo end
        if V > Hi then return Hi end
        return V
    end

    -- 只靠 Parent 判断存活，不用 IsDescendantOf(game)（真机 UI 不在 game 下会被误杀）
    local function IsAlive(O)
        if not O then return false end
        local Ok, P = pcall(function() return O.Parent end)
        return Ok and P ~= nil
    end

    local function GetMainFrame()
        if not (Library and Library.Window) then return nil end
        local mf = Library.Window.MainFrame
        if mf and mf.Parent then return mf end
        return nil
    end

    -- 取当前主题强调色（与边框 / 控件同一套雾蓝调和函数）
    local function AccentColor()
        local Ok, C = pcall(function()
            local RGB = YXThemeAccentRGB(Library, true)
            return Color3.new(RGB[1], RGB[2], RGB[3])
        end)
        if Ok and C then return C end
        local F = Library and Library.Scheme and Library.Scheme.AccentColor
        return F or Color3.fromRGB(130, 200, 248)
    end

    local function MixWhite(C, T)
        return Color3.new(C.R + (1 - C.R) * T,
                          C.G + (1 - C.G) * T,
                          C.B + (1 - C.B) * T)
    end

    -- 常态色 = 主题色提亮；高光色 = 更接近白。0 与 1 端点同色，扫过循环无接缝。
    local function BuildSequence()
        local Base = AccentColor()
        local NewSig = string.format("%.4f,%.4f,%.4f", Base.R, Base.G, Base.B)
        if Seq and NewSig == Sig then return Seq end
        Sig = NewSig
        local Edge = MixWhite(Base, Clamp(M.BaseWhite, 0, 1))
        local Hi   = MixWhite(Base, Clamp(M.HighWhite, 0, 1))
        local W    = Clamp(M.BandWidth, 0.05, 0.45)
        local L    = 0.5 - W
        local R    = 0.5 + W
        Seq = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Edge),
            ColorSequenceKeypoint.new(L,    Edge),
            ColorSequenceKeypoint.new(0.50, Hi),
            ColorSequenceKeypoint.new(R,    Edge),
            ColorSequenceKeypoint.new(1.00, Edge),
        })
        return Seq
    end

    -- 按分隔符切词：分隔符留在前一个词末尾，不丢字符
    --   "YX-SCRPIT"            -> { "YX-", "SCRPIT" }
    --   "YX-Loader | YirdeX开发" -> { "YX-", "Loader ", "| ", "YirdeX开发" }
    local function Tokenize(Text)
        local Sep = {}
        for _, C in ipairs(M.WordSeparators or {}) do Sep[C] = true end
        local Out, Buf = {}, {}
        local Ok = pcall(function()
            for _, Code in utf8.codes(Text) do
                local Ch = utf8.char(Code)
                Buf[#Buf + 1] = Ch
                if Sep[Ch] then
                    Out[#Out + 1] = table.concat(Buf)
                    Buf = {}
                end
            end
        end)
        if not Ok then return {} end
        if #Buf > 0 then Out[#Out + 1] = table.concat(Buf) end
        local Clean = {}
        for _, T in ipairs(Out) do
            if T ~= "" then Clean[#Clean + 1] = T end
        end
        return Clean
    end

    local function KeepTrailingSpaces(S)
        local Ok, Out = pcall(function()
            return (S:gsub("( +)$", function(M2) return string.rep(NBSP, #M2) end))
        end)
        return (Ok and Out) or S
    end

    -- 定位标题：MainFrame -> TopBar(48px) -> TitleHolder(水平 UIListLayout) -> TextLabel
    local function FindTitleLabel()
        if not (Library and Library.Window) then return nil end
        local mf = Library.Window.MainFrame
        if not (mf and mf.Parent) then return nil end
        local Ok, Found = pcall(function()
            local TopBar = nil
            for _, C in ipairs(mf:GetChildren()) do
                if C:IsA("Frame") and C.Size and C.Size.X and C.Size.Y
                   and C.Size.Y.Offset == 48 and C.Size.X.Scale == 1 then
                    TopBar = C; break
                end
            end
            if not TopBar then return nil end
            local function BestIn(Node)
                local Best, BestSize = nil, -1
                for _, C in ipairs(Node:GetChildren()) do
                    if C:IsA("TextLabel") and C.Visible ~= false
                       and type(C.Text) == "string" and #C.Text > 1 then
                        local Sz = tonumber(C.TextSize) or 0
                        if Sz > BestSize then Best, BestSize = C, Sz end
                    end
                end
                return Best
            end
            for _, C in ipairs(TopBar:GetChildren()) do
                if C:IsA("Frame") and C.FindFirstChildOfClass
                   and C:FindFirstChildOfClass("UIListLayout") then
                    local B = BestIn(C)
                    if B then return B end
                end
            end
            local Best, BestSize = nil, -1
            for _, C in ipairs(TopBar:GetDescendants()) do
                if C:IsA("TextLabel") and C.Visible ~= false
                   and type(C.Text) == "string" and #C.Text > 1 then
                    local Sz = tonumber(C.TextSize) or 0
                    if Sz > BestSize then Best, BestSize = C, Sz end
                end
            end
            return Best
        end)
        return (Ok and Found) or nil
    end

    -- 定位页脚：MainFrame -> BottomBar(20px / 底部锚点 / 全透明) -> TextLabel
    local function FindFooterLabel()
        if not (Library and Library.Window) then return nil end
        local mf = Library.Window.MainFrame
        if not (mf and mf.Parent) then return nil end
        local Ok, Found = pcall(function()
            local BottomBar = nil
            for _, C in ipairs(mf:GetChildren()) do
                if C:IsA("Frame") and C.Size and C.Size.Y and C.Size.Y.Offset == 20
                   and C.AnchorPoint and C.AnchorPoint.Y == 1
                   and C.BackgroundTransparency == 1 then
                    BottomBar = C; break
                end
            end
            if BottomBar then
                local Best, BestSize = nil, -1
                for _, C in ipairs(BottomBar:GetChildren()) do
                    if C:IsA("TextLabel") and C.Visible ~= false
                       and type(C.Text) == "string" and #C.Text > 0 then
                        local Sz = tonumber(C.TextSize) or 0
                        if Sz > BestSize then Best, BestSize = C, Sz end
                    end
                end
                if Best then return Best end
            end
            local Best = nil
            for _, C in ipairs(mf:GetDescendants()) do
                if C:IsA("TextLabel") and C.Visible ~= false
                   and type(C.Text) == "string" and #C.Text > 0
                   and tonumber(C.TextSize) == 14
                   and type(C.TextTransparency) == "number"
                   and C.TextTransparency > 0.2 then
                    Best = C; break
                end
            end
            return Best
        end)
        return (Ok and Found) or nil
    end

    local function CollectLabels()
        local Out = {}
        local T = FindTitleLabel()
        if T then Out[#Out + 1] = T end
        if M.FooterEnabled then
            local F = FindFooterLabel()
            if F and F ~= T then Out[#Out + 1] = F end
        end
        return Out
    end

    -- 回退路径：整串一条渐变（老实现）
    local function AttachSingle(Label)
        local OrigTT = nil
        pcall(function()
            if type(Label.TextTransparency) == "number" then
                OrigTT = Label.TextTransparency
                if OrigTT > 0.01 then Label.TextTransparency = M.FooterTextTransparency end
            end
        end)
        local G = Instance.new("UIGradient")
        G.Name     = M.Name
        G.Rotation = M.Rotation
        G.Offset   = Vector2.new(0.5, 0)
        G.Color    = BuildSequence()
        G.Parent   = Label
        -- 白基底 + 固定 Registry 登记：主题切换不再把文字色改回 FontColor
        pcall(function() Label.TextColor3 = Color3.new(1, 1, 1) end)
        pcall(function()
            local Reg = Library.Registry and Library.Registry[Label]
            if type(Reg) == "table" then Reg.TextColor3 = Color3.new(1, 1, 1) end
        end)
        return { Label = Label, Grad = G, Words = nil, OrigTT = OrigTT, OrigText = Label.Text }
    end

    -- 逐词路径：原 Label 内挂 1:1 透明子 Frame，里面每个词一个 TextLabel + 各自渐变
    local function AttachWords(Label, Tokens)
        local OrigTT = nil
        pcall(function()
            if type(Label.TextTransparency) == "number" then
                OrigTT = Label.TextTransparency
            end
        end)

        local Row = Instance.new("Frame")
        Row.Name = M.Name .. "_Row"
        Row.BackgroundTransparency = 1
        Row.BorderSizePixel = 0
        Row.Position = UDim2.fromOffset(0, 0)
        Row.Size = UDim2.fromScale(1, 1)
        Row.ClipsDescendants = false
        Row.ZIndex = Label.ZIndex

        local List = Instance.new("UIListLayout")
        List.Name = M.Name .. "_List"
        List.FillDirection = Enum.FillDirection.Horizontal
        List.SortOrder = Enum.SortOrder.LayoutOrder
        List.Padding = UDim.new(0, 0)
        List.VerticalAlignment = Enum.VerticalAlignment.Center
        -- 跟随原 Label 的横向对齐（库没设，默认 Center）
        local XAlign = nil
        pcall(function() XAlign = Label.TextXAlignment end)
        local HAlign = Enum.HorizontalAlignment.Center
        if XAlign == Enum.TextXAlignment.Left then
            HAlign = Enum.HorizontalAlignment.Left
        elseif XAlign == Enum.TextXAlignment.Right then
            HAlign = Enum.HorizontalAlignment.Right
        end
        List.HorizontalAlignment = HAlign
        List.Parent = Row

        local Words = {}
        for I, T in ipairs(Tokens) do
            local W = Instance.new("TextLabel")
            W.Name = string.format("%s_W%d", M.Name, I)
            W.BackgroundTransparency = 1
            W.BorderSizePixel = 0
            W.Text = KeepTrailingSpaces(T)
            W.TextSize = Label.TextSize
            W.TextColor3 = Color3.new(1, 1, 1)
            W.TextXAlignment = Enum.TextXAlignment.Left
            W.TextYAlignment = Enum.TextYAlignment.Center
            W.RichText = false
            W.LayoutOrder = I
            W.AutomaticSize = Enum.AutomaticSize.X
            W.Size = UDim2.new(0, 0, 1, 0)
            W.ZIndex = Label.ZIndex
            -- 字体族 / 字重跟着原 Label，避免宽度和字形走样
            pcall(function() W.Font = Label.Font end)
            pcall(function() if Label.FontFace ~= nil then W.FontFace = Label.FontFace end end)
            W.Parent = Row

            local G = Instance.new("UIGradient")
            G.Name     = M.Name
            G.Rotation = M.Rotation
            G.Offset   = Vector2.new(0.5, 0)
            G.Color    = BuildSequence()
            G.Parent   = W

            Words[#Words + 1] = { Label = W, Grad = G }
        end

        Row.Parent = Label
        -- 原文字全透明，只留我们的逐词副本显示（文字内容本身保留，库随时能读）
        pcall(function() Label.TextTransparency = 1 end)

        return { Label = Label, Row = Row, Words = Words, Grad = nil,
                 OrigTT = OrigTT, OrigText = Label.Text }
    end

    local function Attach(Label)
        local Text = nil
        pcall(function() Text = Label.Text end)
        local CanSplit = M.WordSplit
            and type(Text) == "string" and #Text > 0 and not Text:find("<", 1, true)
        local Scaled = false
        pcall(function() Scaled = Label.TextScaled == true end)
        if CanSplit and not Scaled then
            local Tokens = Tokenize(Text)
            if #Tokens >= 2 then
                local Ok, Item = pcall(AttachWords, Label, Tokens)
                if Ok and Item then return Item end
            end
        end
        return AttachSingle(Label)
    end

    local function ReleaseItem(Item)
        pcall(function()
            if Item.Row then
                Item.Row:Destroy()          -- 连同每个词的 TextLabel / UIGradient
            end
            if Item.Grad then
                Item.Grad:Destroy()
            end
            if type(Item.OrigTT) == "number" then
                Item.Label.TextTransparency = Item.OrigTT
            end
            if not Item.Words then
                local Reg = Library.Registry and Library.Registry[Item.Label]
                if type(Reg) == "table" then Reg.TextColor3 = "FontColor" end
                local F = Library.Scheme and Library.Scheme.FontColor
                if F then Item.Label.TextColor3 = F end
            end
        end)
    end

    local function Release()
        for _, Item in ipairs(Targets) do
            ReleaseItem(Item)
        end
        Targets = {}
    end

    local function Rebuild()
        Release()
        BoundMF = GetMainFrame()
        for _, L in ipairs(CollectLabels()) do
            local Ok, Item = pcall(Attach, L)
            if Ok and Item then Targets[#Targets + 1] = Item end
        end
        AppliedSeq = Seq
        return #Targets > 0
    end

    local function AllAlive()
        if #Targets == 0 then return false end
        for _, Item in ipairs(Targets) do
            if not IsAlive(Item.Label) then return false end
            if Item.Row then
                if not IsAlive(Item.Row) then return false end
                for _, W in ipairs(Item.Words) do
                    if not (IsAlive(W.Label) and IsAlive(W.Grad)) then return false end
                end
            elseif not IsAlive(Item.Grad) then
                return false
            end
        end
        return true
    end

    -- 文字被 ChangeTitle / SetFooter 改过：需要按新词重拆
    local function TextChanged()
        for _, Item in ipairs(Targets) do
            local Ok, T = pcall(function() return Item.Label.Text end)
            if not Ok or T ~= Item.OrigText then return true end
        end
        return false
    end

    local function Tick(dt)
        if not M.Enabled then return end
        local Now  = os.clock()
        local Step = (type(dt) == "number" and dt > 0 and dt) or (Now - LastFrame)
        if Step < 0 then Step = 0 end
        if Step > 0.1 then Step = 0.1 end   -- 卡顿后不跳一大截
        LastFrame = Now
        Phase    = (Phase + Step * M.Speed) % 1
        WriteAcc = WriteAcc + Step
        ThemeAcc = ThemeAcc + Step
        RetryAcc = RetryAcc + Step

        -- 窗口被重建（MainFrame 换新）：立刻重新接管，不等旧的自己死掉
        local mf = GetMainFrame()
        if mf ~= BoundMF then
            RetryAcc = 0
            Rebuild()
            return
        end

        -- 窗口重建 / 文字被改 / 目标被销毁：按 RetryInterval 重新接管
        if (not AllAlive()) or TextChanged() then
            if RetryAcc < M.RetryInterval then return end
            RetryAcc = 0
            Rebuild()
            return
        end

        if WriteAcc < M.Interval then return end
        WriteAcc = 0

        -- 白基底守卫（回退路径生效；逐词路径文字本来是全透明）
        for _, Item in ipairs(Targets) do
            if Item.Words then
                pcall(function()
                    if Item.Label.TextTransparency < 0.999 then
                        Item.Label.TextTransparency = 1
                    end
                end)
            else
                local L = Item.Label
                pcall(function()
                    local C = L.TextColor3
                    if not (C and C.R and C.R > 0.999 and C.G > 0.999 and C.B > 0.999) then
                        L.TextColor3 = Color3.new(1, 1, 1)
                    end
                end)
            end
        end

        -- 主题签名变化才重建色序列，平时零写入
        if ThemeAcc >= M.ThemeCheckInterval then
            ThemeAcc = 0
            local S = BuildSequence()
            if S ~= AppliedSeq then
                AppliedSeq = S
                for _, Item in ipairs(Targets) do
                    if Item.Words then
                        for _, W in ipairs(Item.Words) do
                            pcall(function() W.Grad.Color = S end)
                        end
                    elseif Item.Grad then
                        pcall(function() Item.Grad.Color = S end)
                    end
                end
            end
        end

        -- 流光位移：每个词各自位移，相位可由 WordPhaseStep 错开
        for _, Item in ipairs(Targets) do
            if Item.Words then
                for I, W in ipairs(Item.Words) do
                    local Off = 0.5 - Phase + (I - 1) * (M.WordPhaseStep or 0)
                    pcall(function() W.Grad.Offset = Vector2.new(Off, 0) end)
                end
            elseif Item.Grad then
                pcall(function() Item.Grad.Offset = Vector2.new(0.5 - Phase, 0) end)
            end
        end
    end

    function M:Enable()
        M.Enabled = true
        if not Heartbeat or Conn then return self end
        LastFrame = os.clock()
        local Ok, C = pcall(function()
            return Heartbeat:Connect(function(dt) pcall(Tick, dt) end)
        end)
        if Ok then Conn = C end
        -- 立即接管一次，启动即生效；窗口尚未创建时交给心跳重试
        Rebuild()
        return self
    end

    function M:Disable()
        M.Enabled = false
        if Conn then pcall(function() Conn:Disconnect() end); Conn = nil end
        Release()
        Seq, Sig, AppliedSeq = nil, nil, nil
        return self
    end

    function M:SetSpeed(V)
        if type(V) == "number" then M.Speed = V end
        return self
    end

    function M:SetWordSplit(V)
        M.WordSplit = V and true or false
        if M.Enabled then Rebuild() end
        return self
    end

    function M:SetFooterEnabled(V)
        M.FooterEnabled = V and true or false
        if M.Enabled then Rebuild() end
        return self
    end

    return M
end)(Library)

YXTitleFlow:Enable()
-- ============================================================================
-- 液态玻璃（移植自 SyndromeXph/Obsidian 新版库 Library.lua 的 "Liquid Glass"）
--   库内位置：294-301 行配置 / 1593-1644 行 ApplyLiquidGlass + AddGlassSheen /
--             1646-1681 行 SetWorldGlass / 1789-1821 行 Lighting 特效。
--   本次按需求只采用其中两块，不做「世界模糊 / 压暗」（不创建 BlurEffect、
--     ColorCorrectionEffect，也不改 Lighting）：
--     1) AddGlassSheen    -> 窗口 MainFrame 上的斜向玻璃高光层（完全照搬库实现）
--     2) ApplyLiquidGlass -> 窗口内 BackgroundColor / MainColor 面板半透明化
--   当前主脚本用的是 deividcomsono 旧库，没有内建这些；ApplyLiquidGlass 原本挂在
--   库内部 New() 上，外部拦不到，这里改成「低频扫描窗口后代 + 双路判定」近似复刻：
--     · 路 A：读 Library.Registry[obj].BackgroundColor3 的键（与库原版判定一致）
--     · 路 B：底色是否接近 Library.Scheme.BackgroundColor / MainColor
--             （美化模块会改写部分 Registry 键，路 B 保证这种情况仍能命中）
--   不碰窗口 MainFrame 本体：它后面有辉光遮心板（不透明），半透过去也看不到效果。
-- ============================================================================
local YXLiquidGlass = (function(Library)
    local M = {}

    M.Glass = {
        Enabled           = true,

        -- 1) 面板半透明化 -------------------------------------------------
        Transparency      = 0.5,   -- 与库 GlassTransparency 一致
        IncludeMainFrame  = false, -- 窗口本体后面有辉光遮心板，半透也看不到效果
        OnlyOpaque        = true,  -- 只接管当前完全不透明的面板，不破坏控件自设透明度
        ScanInterval      = 0.35,  -- 运行时新增控件（下拉 / 通知等）补扫间隔
        ColorTolerance    = 0.08,  -- 主题底色近似匹配容差

        -- 2) 窗口玻璃高光层 ---------------------------------------------
        SheenEnabled      = true,
        SheenName         = "YXLiquidGlassSheen",
        SheenZIndex       = 0,     -- 与库一致；若被背景图压住可调到 990 左右
        SheenRotation     = 112,   -- 库原版斜向角度
        SheenColors       = { { 255, 255, 255 }, { 200, 214, 255 }, { 36, 42, 70 } },
        SheenStops        = { 0, 0.4, 1 },
        SheenTransparency = { { 0, 0.7 }, { 0.42, 0.88 }, { 1, 0.97 } },
        SheenFollowTheme  = false, -- 玻璃反光是中性高光，默认不随主题；true 则混入主题强调色
    }

    local OkRun, RunService = pcall(function() return game:GetService("RunService") end)
    local Heartbeat = (OkRun and RunService and RunService.Heartbeat) or nil

    local Conn = nil
    local Sheen, SheenCorner, SheenGrad = nil, nil, nil
    local BoundMF, SheenSig = nil, nil
    local Processed = setmetatable({}, { __mode = "k" })
    local Origins   = setmetatable({}, { __mode = "k" })
    local ScanAcc, LastFrame = 0, 0

    local function GetMainFrame()
        if not (Library and Library.Window) then return nil end
        local mf = Library.Window.MainFrame
        if mf and mf.Parent then return mf end
        return nil
    end

    local function IsAlive(O)
        if not O then return false end
        local Ok, P = pcall(function() return O.Parent end)
        return Ok and P ~= nil
    end

    -- 面板判定：Registry 键（库原版逻辑） + 当前底色接近主题 BackgroundColor / MainColor
    local function IsPanel(Obj)
        local Reg = Library.Registry and Library.Registry[Obj]
        local Key = Reg and Reg.BackgroundColor3
        if type(Key) == "function" then return true end
        if type(Key) == "string" and (Key == "BackgroundColor" or Key == "MainColor") then
            return true
        end
        local C, S = Obj.BackgroundColor3, Library.Scheme
        if not (C and S) then return false end
        local Tol = M.Glass.ColorTolerance or 0.08
        for _, Name in ipairs({ "BackgroundColor", "MainColor" }) do
            local T = S[Name]
            if T and math.abs(C.R - T.R) < Tol
                  and math.abs(C.G - T.G) < Tol
                  and math.abs(C.B - T.B) < Tol then
                return true
            end
        end
        return false
    end

    -- 返回 true = 以后不用再判断这个对象；false = 属性还没就绪，下轮重试
    local function ApplyOne(Obj, mf)
        if Obj == mf and not M.Glass.IncludeMainFrame then return true end
        if Obj == Sheen then return true end
        local Ok, Handled = pcall(function()
            if not Obj:IsA("GuiObject") then return true end
            local BT = Obj.BackgroundTransparency
            if type(BT) ~= "number" then return false end
            if BT >= 1 then return true end                       -- 本来就全透，跳过
            if M.Glass.OnlyOpaque and BT > 0.01 then return true end -- 控件自设透明度，别动
            if not IsPanel(Obj) then return true end
            Origins[Obj] = BT
            Obj.BackgroundTransparency = M.Glass.Transparency
            return true
        end)
        return (Ok and Handled) or false
    end

    local function Scan()
        local mf = GetMainFrame()
        if not mf then return end
        BoundMF = mf
        pcall(function()
            for _, Obj in ipairs(mf:GetDescendants()) do
                if not Processed[Obj] then
                    if ApplyOne(Obj, mf) then Processed[Obj] = true end
                end
            end
        end)
    end

    local function BuildSheenColors()
        local C = M.Glass.SheenColors
        local function ToColor(T) return Color3.fromRGB(T[1], T[2], T[3]) end
        local A, B, D = ToColor(C[1]), ToColor(C[2]), ToColor(C[3])
        if M.Glass.SheenFollowTheme then
            local Ok, RGB = pcall(function() return YXThemeAccentRGB(Library, true) end)
            if Ok and RGB then
                local Acc = Color3.new(RGB[1], RGB[2], RGB[3])
                B = Color3.new((B.R + Acc.R) / 2, (B.G + Acc.G) / 2, (B.B + Acc.B) / 2)
            end
        end
        return A, B, D
    end

    local function NewSheen(mf)
        local G = M.Glass
        local S = Instance.new("Frame")
        S.Name = G.SheenName
        S.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        S.BackgroundTransparency = 0
        S.BorderSizePixel = 0
        S.Size = UDim2.fromScale(1, 1)
        S.Active = false
        S.ZIndex = G.SheenZIndex
        S.Parent = mf

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, Library.CornerRadius or 4)
        Corner.Parent = S
        if type(Library.Corners) == "table" then
            table.insert(Library.Corners, Corner)
        end

        local A, B, D = BuildSheenColors()
        local St, Tr = G.SheenStops, G.SheenTransparency
        local Grad = Instance.new("UIGradient")
        Grad.Rotation = G.SheenRotation
        Grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(St[1], A),
            ColorSequenceKeypoint.new(St[2], B),
            ColorSequenceKeypoint.new(St[3], D),
        })
        Grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(Tr[1][1], Tr[1][2]),
            NumberSequenceKeypoint.new(Tr[2][1], Tr[2][2]),
            NumberSequenceKeypoint.new(Tr[3][1], Tr[3][2]),
        })
        Grad.Parent = S
        return S, Corner, Grad
    end

    local function RemoveSheen()
        if SheenCorner and type(Library.Corners) == "table" then
            for i = #Library.Corners, 1, -1 do
                if Library.Corners[i] == SheenCorner then
                    table.remove(Library.Corners, i)
                end
            end
        end
        if Sheen then pcall(function() Sheen:Destroy() end) end
        Sheen, SheenCorner, SheenGrad = nil, nil, nil
    end

    local function Restore()
        for Obj, Old in pairs(Origins) do
            pcall(function() Obj.BackgroundTransparency = Old end)
            Origins[Obj] = nil
        end
        Processed = setmetatable({}, { __mode = "k" })
    end

    local function ThemeSignature()
        if not M.Glass.SheenFollowTheme then return nil end
        local Ok, RGB = pcall(function() return YXThemeAccentRGB(Library, true) end)
        if not (Ok and RGB) then return nil end
        return string.format("%.3f,%.3f,%.3f", RGB[1], RGB[2], RGB[3])
    end

    local function Tick(dt)
        if not M.Glass.Enabled then return end
        local Now = os.clock()
        local Step = (type(dt) == "number" and dt > 0 and dt) or (Now - LastFrame)
        if Step < 0 then Step = 0 end
        if Step > 0.2 then Step = 0.2 end
        LastFrame = Now
        ScanAcc = ScanAcc + Step
        if ScanAcc < M.Glass.ScanInterval then return end
        ScanAcc = 0

        local mf = GetMainFrame()
        if not mf then
            RemoveSheen(); BoundMF = nil
            return
        end
        if BoundMF ~= mf then               -- 窗口被重建
            RemoveSheen()
            Processed = setmetatable({}, { __mode = "k" })
            Origins   = setmetatable({}, { __mode = "k" })
            BoundMF = mf
        end
        if M.Glass.SheenEnabled and not IsAlive(Sheen) then
            Sheen, SheenCorner, SheenGrad = NewSheen(mf)
        elseif not M.Glass.SheenEnabled and IsAlive(Sheen) then
            RemoveSheen()
        end
        Scan()
        if SheenGrad and M.Glass.SheenFollowTheme then
            local Sig = ThemeSignature()
            if Sig and Sig ~= SheenSig then
                SheenSig = Sig
                local A, B, D = BuildSheenColors()
                local St = M.Glass.SheenStops
                pcall(function()
                    SheenGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(St[1], A),
                        ColorSequenceKeypoint.new(St[2], B),
                        ColorSequenceKeypoint.new(St[3], D),
                    })
                end)
            end
        end
    end

    function M:Enable()
        M.Glass.Enabled = true
        if not Heartbeat or Conn then return self end
        LastFrame = os.clock()
        local Ok, C = pcall(function()
            return Heartbeat:Connect(function(dt) pcall(Tick, dt) end)
        end)
        if Ok then Conn = C end
        local mf = GetMainFrame()
        if mf then
            BoundMF = mf
            if M.Glass.SheenEnabled then
                Sheen, SheenCorner, SheenGrad = NewSheen(mf)
            end
            Scan()
        end
        return self
    end

    function M:Disable()
        M.Glass.Enabled = false
        if Conn then pcall(function() Conn:Disconnect() end); Conn = nil end
        RemoveSheen()
        Restore()
        BoundMF, SheenSig = nil, nil
        return self
    end

    function M:SetTransparency(V)
        if type(V) == "number" then
            M.Glass.Transparency = V
            for Obj in pairs(Origins) do
                pcall(function() Obj.BackgroundTransparency = V end)
            end
        end
        return self
    end

    return M
end)(Library)

YXLiquidGlass:Enable()
-- ============================================================================
-- ① 其它文字「亮光带扫过」流动（替换上一版 YXAllFlow 的 Offset 平移方案）
--
-- 上一版为什么「硬邦邦」：靠 UIGradient.Offset 平移色带，但 Roblox 渐变采样
--   超出 [0,1] 的部分会被 clamp 成端点色，高光带一跑出文字范围就整片消失，
--   于是大部分时间文字是一整片死色，只有偶尔一瞬有光。
-- 这一版：不再挪 Offset，而是每次写入时按当前相位【重建色带】，把若干条
--   「彩色底 -> 纯白亮带 -> 彩色底」的峰值放在移动的位置上。亮带始终在
--   文字内部循环（相位 0 与 1 图案完全一致，无缝），所以一直能看到光在流。
--   · 普通文字：彩色底取饱和化后的主题强调色，切主题一起变；纯白亮带是
--     相乘的恒等元，扫到哪哪就恢复文字自身颜色，因此白字/主题色字都保留色相。
--   · 含 <font color> 的开发者名单：不接管，交给下面的 ② YXCharFlow。
--   · 控件填充渐变（按钮/下拉/菜单/滑块）：仍用 Offset 缓慢正弦往返。
--     边框 / 玻璃高光 / 标题逐词渐变各有自己的动画，白名单之外一律不碰。
-- 不拆 RichText、不改 TextColor3、不动 Registry、不改布局。
-- ============================================================================
local YXAllFlow = (function(Library)
    local M = {}

    -- 可调配置 -------------------------------------------------------------
    M.Enabled             = true
    M.TextEnabled         = true    -- 其它文字的亮光扫过
    M.GradientEnabled     = true    -- 填充渐变一起缓慢流动
    M.Speed               = 0.42    -- 亮带流动速度（每秒走多少轮）
    M.GradientSpeed       = 0.22    -- 控件渐变往返速度
    M.GradientAmplitude   = 0.45    -- 控件渐变 Offset 摆动幅度
    M.Interval            = 1 / 18  -- 色带重建 + 属性写入频率（降频）
    M.ScanInterval        = 0.6     -- 新控件 / 动态标签补扫间隔
    M.ThemeCheckInterval  = 0.15    -- 主题色签名检查间隔
    M.BandWidth           = 0.09    -- 亮带半宽（相对整条色带，越小越细）
    M.Peaks               = 3       -- 同时几条亮带在文字上流动
    M.Rotation            = 0       -- 色带角度（0 = 水平）
    M.PlainSaturation     = 0.62    -- 彩色底饱和度（0 = 灰度，即更老一版效果）
    M.MaxTextGradients    = 600     -- 文字渐变数量上限，防通知刷屏堆积
    M.SkipTextBox         = true
    M.SkipNames           = {
        YXTitleFlow   = true,      -- 标题 / 页脚逐词渐变自己在动
        YXAllFlowText = true,      -- 本模块新建
        YXFlowText    = true,      -- 兼容旧独立片段
    }
    M.GradientNames       = {
        YXButtonGradient      = true,
        YXDropdownGradient    = true,
        YXMenuGradient        = true,
        YXSliderTrackGradient = true,
    }
    M.Name                = "YXAllFlowText"

    local OkRun, RunService = pcall(function() return game:GetService("RunService") end)
    local Heartbeat = (OkRun and RunService and RunService.Heartbeat) or nil

    local function Clamp(V, Lo, Hi)
        if V < Lo then return Lo end
        if V > Hi then return Hi end
        return V
    end
    local function KP(T, C) return ColorSequenceKeypoint.new(T, C) end
    local White = Color3.new(1, 1, 1)

    -- 主题强调色 -> 饱和化彩色底（保留色相，拉大与纯白的差）
    local function PlainEdge()
        local Ok, RGB = pcall(function() return YXThemeAccentRGB(Library, true) end)
        local C = (Ok and RGB) or { 130 / 255, 200 / 255, 248 / 255 }
        local S = Clamp(M.PlainSaturation, 0, 1)
        local L = 0.2126 * C[1] + 0.7152 * C[2] + 0.0722 * C[3]
        if S <= 0 then return Color3.new(L, L, L) end
        local K = 1 + S * 1.6
        local function Ch(V) return Clamp(L + (V - L) * K, 0.04, 1) end
        return Color3.new(Ch(C[1]), Ch(C[2]), Ch(C[3]))
    end

    local function ThemeSignature()
        local Ok, RGB = pcall(function() return YXThemeAccentRGB(Library, true) end)
        local C = (Ok and RGB) or { 130 / 255, 200 / 255, 248 / 255 }
        return string.format("%.4f,%.4f,%.4f,%.3f", C[1], C[2], C[3], M.PlainSaturation)
    end

    -- 按相位重建色带：亮峰位置 = (Phase + k) / Peaks，k = 0..Peaks
    -- Phase 从 0 到 1 时每个峰右移 1/Peaks，图案与 Phase=0 完全一致 => 无缝循环
    local function BuildMovingSeq(Edge, Phase)
        local W = Clamp(M.BandWidth, 0.02, 0.20)
        local P = math.max(1, math.floor(M.Peaks or 3))
        local Pts = {}
        for k = 0, P do
            local p = (Phase + k) / P
            local a, b = p - W, p + W
            if a > 0 and a < 1 then Pts[#Pts + 1] = { a, Edge } end
            if p > 0 and p < 1 then Pts[#Pts + 1] = { p, White } end
            if b > 0 and b < 1 then Pts[#Pts + 1] = { b, Edge } end
        end
        table.sort(Pts, function(X, Y) return X[1] < Y[1] end)
        local Kps, Last = { KP(0, Edge) }, 0
        for _, Q in ipairs(Pts) do
            if Q[1] > Last + 1e-4 and Q[1] < 1 - 1e-4 then
                Kps[#Kps + 1] = KP(Q[1], Q[2])
                Last = Q[1]
            end
        end
        Kps[#Kps + 1] = KP(1, Edge)   -- 两端同色，边界不跳色
        return ColorSequence.new(Kps)
    end

    local Items = setmetatable({}, { __mode = "k" })  -- [UIGradient] = {OX,OY,Kind}
    local Seen  = setmetatable({}, { __mode = "k" })
    local Owned = setmetatable({}, { __mode = "k" })
    local OwnedCount = 0

    local Edge, EdgeSig, PhaseT = nil, nil, 0

    local function RefreshEdge(Force)
        local Sig = ThemeSignature()
        if Force or Sig ~= EdgeSig then EdgeSig = Sig; Edge = PlainEdge() end
    end

    local function GetRoot()
        local Ok, Root = pcall(function()
            if typeof(Library.ScreenGui) == "Instance" then return Library.ScreenGui end
            local Reg = Library.Registry
            if type(Reg) == "table" then
                for Inst in pairs(Reg) do
                    if typeof(Inst) == "Instance" then
                        local R = Inst:FindFirstAncestorOfClass("ScreenGui")
                        if R then return R end
                    end
                end
            end
        end)
        return (Ok and Root) or nil
    end

    local function Register(Grad, Kind, Own)
        if Items[Grad] then return end
        local OX, OY = 0, 0
        pcall(function()
            local O = Grad.Offset
            if O then OX, OY = O.X or 0, O.Y or 0 end
        end)
        Items[Grad] = { OX = OX, OY = OY, Kind = Kind }
        if Own then Owned[Grad] = true; OwnedCount = OwnedCount + 1 end
    end

    local function ChildGradient(O)
        local Ok, Found = pcall(function()
            for _, C in ipairs(O:GetChildren()) do
                if C:IsA("UIGradient") then return C end
            end
        end)
        return (Ok and Found) or nil
    end

    local function IsText(O)
        return O:IsA("TextLabel") or O:IsA("TextButton") or O:IsA("TextBox")
    end

    -- 开发者名单这类逐字染色的 RichText 交给 ②，这里不挂 UIGradient
    local function IsCharFlowTarget(T)
        return T:find("<font", 1, true) ~= nil and T:find("rgb(", 1, true) ~= nil
    end

    local function Process(O)
        if Seen[O] then return end

        if IsText(O) then
            if M.SkipTextBox and O:IsA("TextBox") then Seen[O] = true; return end
            local T, TT = nil, 0
            pcall(function() T = O.Text; TT = O.TextTransparency end)
            if type(T) ~= "string" or T == "" then return end
            if type(TT) == "number" and TT >= 0.99 then Seen[O] = true; return end
            if IsCharFlowTarget(T) then Seen[O] = true; return end

            local Grad = ChildGradient(O)
            if Grad then
                if M.SkipNames[Grad.Name] then Seen[O] = true; return end
                if M.GradientNames[Grad.Name] and M.GradientEnabled then
                    Register(Grad, "grad", false)
                end
                Seen[O] = true
                return
            end
            if not M.TextEnabled then return end
            if OwnedCount >= M.MaxTextGradients then Seen[O] = true; return end
            local G = Instance.new("UIGradient")
            G.Name     = M.Name
            G.Rotation = M.Rotation
            G.Color    = BuildMovingSeq(Edge, PhaseT)
            G.Offset   = Vector2.new(0, 0)   -- 固定，流动靠重建色带
            G.Parent   = O
            Register(G, "text", true)
            Seen[O] = true
            return
        end

        if O:IsA("UIGradient") then
            if M.GradientNames[O.Name] and M.GradientEnabled then
                Register(O, "grad", false)
            end
            Seen[O] = true
            return
        end
        Seen[O] = true
    end

    local function Scan()
        local Root = GetRoot()
        if not Root then return end
        pcall(function()
            for _, O in ipairs(Root:GetDescendants()) do Process(O) end
        end)
    end

    local PhaseG = 0
    local WriteAcc, ScanAcc, ThemeAcc, Last = 0, 0, 0, os.clock()
    local Conn, AddedConn

    local function Tick(Dt)
        if not M.Enabled then return end
        local Now  = os.clock()
        local Step = (type(Dt) == "number" and Dt > 0 and Dt) or (Now - Last)
        if Step < 0 then Step = 0 end
        if Step > 0.1 then Step = 0.1 end
        Last = Now

        PhaseT = (PhaseT + Step * M.Speed) % 1
        PhaseG = (PhaseG + Step * M.GradientSpeed) % 1
        WriteAcc, ScanAcc, ThemeAcc = WriteAcc + Step, ScanAcc + Step, ThemeAcc + Step

        if ScanAcc >= M.ScanInterval then ScanAcc = 0; Scan() end
        if ThemeAcc >= M.ThemeCheckInterval then ThemeAcc = 0; RefreshEdge(false) end
        if WriteAcc < M.Interval then return end
        WriteAcc = 0

        local Seq = BuildMovingSeq(Edge, PhaseT)
        local ShiftG = math.sin(PhaseG * 2 * math.pi) * M.GradientAmplitude
        for Grad, Info in pairs(Items) do
            if Info.Kind == "text" and M.TextEnabled then
                pcall(function() Grad.Color = Seq end)
            elseif Info.Kind == "grad" and M.GradientEnabled then
                pcall(function() Grad.Offset = Vector2.new(Info.OX + ShiftG, Info.OY) end)
            end
        end
    end

    function M:Enable()
        M.Enabled = true
        RefreshEdge(true)
        Scan()
        if not Heartbeat or Conn then return self end
        Last = os.clock()
        local Root = GetRoot()
        if Root and Root.DescendantAdded then
            pcall(function()
                AddedConn = Root.DescendantAdded:Connect(function(O) pcall(Process, O) end)
            end)
        end
        local Ok, C = pcall(function()
            return Heartbeat:Connect(function(Dt) pcall(Tick, Dt) end)
        end)
        if Ok then Conn = C end
        return self
    end

    function M:Stop()
        M.Enabled = false
        if Conn then pcall(function() Conn:Disconnect() end); Conn = nil end
        if AddedConn then pcall(function() AddedConn:Disconnect() end); AddedConn = nil end
        for Grad, Info in pairs(Items) do
            pcall(function() Grad.Offset = Vector2.new(Info.OX, Info.OY) end)
        end
        for Grad in pairs(Owned) do pcall(function() Grad:Destroy() end) end
        Items = setmetatable({}, { __mode = "k" })
        Seen  = setmetatable({}, { __mode = "k" })
        Owned = setmetatable({}, { __mode = "k" })
        OwnedCount = 0
        return self
    end

    function M:SetSaturation(V)
        if type(V) == "number" then M.PlainSaturation = V; RefreshEdge(true) end
        return self
    end

    return M
end)(Library)

YXAllFlow:Enable()


-- ============================================================================
-- ② 开发者名单「逐字母单独染色 + 滚动流动」
--
-- 把 [<font color="rgb(0,255,255)">YirdeX</font>] 主创开发者 这类 RichText
--   解析成「可见字符 + 每字符原本的颜色」，再重建为你要的形式：
--     <font color="rgb(0, 255, 255)">Y</font><font color="rgb(0, 200, 210)">i</font>...
--   每个字母 / 符号 / 汉字都是独立的 <font color> 标签。
-- 流动：每字符颜色 = 原色在「暗版 <-> 亮版」之间按正弦取值，取样的位置
--   = (字符序号 / 总数 * Cycles - Phase)，Phase 随时间推进，亮带就沿字符
--   从左往右滚动。青还是青、紫还是紫、黄还是黄 —— 按当前染上的颜色流动，
--   不会被统一刷成一种色。
-- 只接管界面里原本就含 <font color="rgb(...)"> 的那几行（即开发者名单），
--   其它文字由 ① 负责。原文会保存，Stop 可完整还原。
-- ============================================================================
local YXCharFlow = (function(Library)
    local M = {}

    M.Enabled       = true
    M.Speed         = 0.35    -- 颜色沿字符滚动速度（每秒多少轮）
    M.Interval      = 1 / 12  -- 文本重建频率（重写 RichText 较重，别太高）
    M.ScanInterval  = 0.8     -- 新标签补扫间隔
    M.Cycles        = 1.6     -- 一行里同时有几条亮带（越大越密）
    M.DarkAmount    = 0.42    -- 暗版 = 原色 * 该系数
    M.BrightWhite   = 0.72    -- 亮版向白靠拢比例
    M.KeepBold      = true    -- 外层保留 <b> 加粗
    M.KeepStroke    = false   -- 外层补回原 <stroke> 黑描边（默认关 = 纯 <font> 格式）
    M.MaxTargets    = 40      -- 最多接管多少行
    M.Name          = "YXCharFlow"

    local OkRun, RunService = pcall(function() return game:GetService("RunService") end)
    local Heartbeat = (OkRun and RunService and RunService.Heartbeat) or nil

    local Targets = setmetatable({}, { __mode = "k" })  -- [Label] = {Chars, Orig, OrigRich}
    local Seen    = setmetatable({}, { __mode = "k" })
    local Count   = 0

    local function Clamp(V, Lo, Hi)
        if V < Lo then return Lo end
        if V > Hi then return Hi end
        return V
    end

    local function Escape(Ch)
        if Ch == "&" then return "&amp;" end
        if Ch == "<" then return "&lt;" end
        if Ch == ">" then return "&gt;" end
        return Ch
    end

    -- 解析 RichText：返回 { {Ch=字符, R/G/B = 0..255}, ... }
    -- 只认 <font color="rgb(r,g,b)"> 与 </font>，其余标签（<b>/<stroke>）跳过
    local function ParseRich(Text)
        local Out, Stack = {}, { { 255, 255, 255 } }
        local Stroke = nil
        local i, n = 1, #Text
        while i <= n do
            local b = Text:byte(i)
            if b == 60 then  -- '<'
                local j = Text:find(">", i + 1, true)
                if j then
                    local Tag  = Text:sub(i, j)
                    local Low  = Tag:lower()
                    if not Stroke and Low:find("<stroke", 1, true)
                       and not Low:find("</", 1, true) then
                        Stroke = Tag
                    end
                    if Low:find("</font", 1, true) then
                        if #Stack > 1 then table.remove(Stack) end
                    elseif Low:find("<font", 1, true) then
                        local r, g, bl = Tag:match("rgb%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)")
                        if r then
                            Stack[#Stack + 1] = { tonumber(r), tonumber(g), tonumber(bl) }
                        else
                            Stack[#Stack + 1] = Stack[#Stack]
                        end
                    end
                    i = j + 1
                else
                    local C = Stack[#Stack]
                    Out[#Out + 1] = { Ch = "<", R = C[1], G = C[2], B = C[3] }
                    i = i + 1
                end
            else
                local L = 1
                if b >= 0xF0 then L = 4
                elseif b >= 0xE0 then L = 3
                elseif b >= 0xC0 then L = 2 end
                if i + L - 1 > n then L = 1 end
                local C = Stack[#Stack]
                Out[#Out + 1] = { Ch = Text:sub(i, i + L - 1), R = C[1], G = C[2], B = C[3] }
                i = i + L
            end
        end
        return Out, Stroke
    end

    local function BuildText(Chars, Phase, Stroke)
        local N = #Chars
        if N == 0 then return "" end
        local Dark, BW = M.DarkAmount, M.BrightWhite
        local Out = {}
        for I, It in ipairs(Chars) do
            local T = (I - 1) / math.max(1, N - 1)
            local Wave = 0.5 + 0.5 * math.sin(2 * math.pi * (T * M.Cycles - Phase))
            local r, g, b = It.R, It.G, It.B
            local dr, dg, db = r * Dark, g * Dark, b * Dark
            local br, bg, bb = r + (255 - r) * BW, g + (255 - g) * BW, b + (255 - b) * BW
            local cr = math.floor(Clamp(dr + (br - dr) * Wave, 0, 255) + 0.5)
            local cg = math.floor(Clamp(dg + (bg - dg) * Wave, 0, 255) + 0.5)
            local cb = math.floor(Clamp(db + (bb - db) * Wave, 0, 255) + 0.5)
            Out[#Out + 1] = ('<font color="rgb(%d, %d, %d)">%s</font>')
                :format(cr, cg, cb, Escape(It.Ch))
        end
        local S = table.concat(Out)
        if M.KeepStroke and Stroke then S = Stroke .. S .. "</stroke>" end
        if M.KeepBold then S = "<b>" .. S .. "</b>" end
        return S
    end

    local function IsTarget(O)
        if not (O:IsA("TextLabel") or O:IsA("TextButton")) then return false end
        local T = nil
        pcall(function() T = O.Text end)
        return type(T) == "string" and T:find("<font", 1, true) ~= nil
               and T:find("rgb(", 1, true) ~= nil
    end

    local function Attach(O)
        if Count >= M.MaxTargets then return end
        local T, Rich = nil, nil
        pcall(function() T = O.Text; Rich = O.RichText end)
        if type(T) ~= "string" or T == "" then return end
        local Chars, Stroke = ParseRich(T)
        if #Chars < 2 then return end
        Targets[O] = { Chars = Chars, Orig = T, OrigRich = Rich, Stroke = Stroke }
        pcall(function() O.RichText = true end)
        pcall(function() O.Text = BuildText(Chars, 0, Stroke) end)
        Count = Count + 1
    end

    local function GetRoot()
        local Ok, Root = pcall(function()
            if typeof(Library.ScreenGui) == "Instance" then return Library.ScreenGui end
            local Reg = Library.Registry
            if type(Reg) == "table" then
                for Inst in pairs(Reg) do
                    if typeof(Inst) == "Instance" then
                        local R = Inst:FindFirstAncestorOfClass("ScreenGui")
                        if R then return R end
                    end
                end
            end
        end)
        return (Ok and Root) or nil
    end

    local function Scan()
        local Root = GetRoot()
        if not Root then return end
        pcall(function()
            for _, O in ipairs(Root:GetDescendants()) do
                if not Seen[O] then
                    if IsTarget(O) then
                        local Ok = pcall(Attach, O)
                        if Ok then Seen[O] = true end
                    else
                        Seen[O] = true
                    end
                end
            end
        end)
    end

    local Phase, WriteAcc, ScanAcc, Last = 0, 0, 0, os.clock()
    local Conn, AddedConn

    local function Tick(Dt)
        if not M.Enabled then return end
        local Now  = os.clock()
        local Step = (type(Dt) == "number" and Dt > 0 and Dt) or (Now - Last)
        if Step < 0 then Step = 0 end
        if Step > 0.1 then Step = 0.1 end
        Last = Now
        Phase = (Phase + Step * M.Speed) % 1
        WriteAcc, ScanAcc = WriteAcc + Step, ScanAcc + Step
        if ScanAcc >= M.ScanInterval then ScanAcc = 0; Scan() end
        if WriteAcc < M.Interval then return end
        WriteAcc = 0
        for Label, Info in pairs(Targets) do
            local Alive = false
            pcall(function() Alive = Label.Parent ~= nil end)
            if not Alive then
                Targets[Label] = nil
                Count = math.max(0, Count - 1)
            else
                pcall(function() Label.Text = BuildText(Info.Chars, Phase, Info.Stroke) end)
            end
        end
    end

    function M:Enable()
        M.Enabled = true
        Scan()
        if not Heartbeat or Conn then return self end
        Last = os.clock()
        local Root = GetRoot()
        if Root and Root.DescendantAdded then
            pcall(function()
                AddedConn = Root.DescendantAdded:Connect(function(O)
                    pcall(function()
                        if not Seen[O] and IsTarget(O) then
                            Attach(O); Seen[O] = true
                        end
                    end)
                end)
            end)
        end
        local Ok, C = pcall(function()
            return Heartbeat:Connect(function(Dt) pcall(Tick, Dt) end)
        end)
        if Ok then Conn = C end
        return self
    end

    function M:Stop()
        M.Enabled = false
        if Conn then pcall(function() Conn:Disconnect() end); Conn = nil end
        if AddedConn then pcall(function() AddedConn:Disconnect() end); AddedConn = nil end
        for Label, Info in pairs(Targets) do
            pcall(function()
                Label.Text = Info.Orig
                if Info.OrigRich ~= nil then Label.RichText = Info.OrigRich end
            end)
            Targets[Label] = nil
        end
        Seen = setmetatable({}, { __mode = "k" })
        Count = 0
        return self
    end

    function M:SetSpeed(V)
        if type(V) == "number" then M.Speed = V end
        return self
    end

    return M
end)(Library)

YXCharFlow:Enable()
