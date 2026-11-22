
local Library, _, SaveManager = ...

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
          -- 「轮廓颜色 / 文字颜色」两个主题项按需求设为纯白 #FFFFFF：
          --   对应设置面板里的 OutlineColor / FontColor 两个颜色选择器，
          --   改后全局控件描边与所有文字都会显示为白色。
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
-- 统一主题取色（控件 / 边框共用）
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
    -- Force = true：强制把背景 1 配色重新套回（即使本次已套用过）。
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
--   动态扫描，运行时新增的按钮（含 SaveManager 等生成的）也会自动纳入。
--
--   为什么跟着主题色走：按钮渐变不再写死配色，每 0.05s 读一次
--   Library.Scheme.AccentColor（换背景 / 切换主题都会改它），
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
Bg:SetLibrary(Library)
-- ==================== 模块定义结束 ====================

-- 「背景图片」选择下拉已移除：只保留背景 1，由 Bg:Enable() 自动套用，
--   不在「UI 设置」里再显示切换项。OnSelect 保持默认 nil（模块内部调用都有判空保护）。
Bg:Enable()

SaveManager:LoadAutoloadConfig()

-- ============================================================
-- 轮廓颜色 / 文字颜色：默认主题下强制同步为纯白 #FFFFFF
--   SaveManager:LoadAutoloadConfig() 会用存档里的主题数据覆盖 Library.Scheme
--   和设置面板的颜色选择器（所以截图里「文字颜色」会显示成存档的浅灰）。
--   这里在它之后再同步一次，保证启动时打开设置面板这两个色块一定是纯白。
--   仅默认主题生效：切到别的主题时本段不参与，交给该主题自带的配色
--   （上面的 ApplyTheme 挂钩也只在切回默认主题时重新套用本模块调色板）。
-- ============================================================
do
    local Current = Bg.LastAppliedTheme
    if Current == nil or Bg:IsDefaultTheme(Current) then
        local White = Color3.fromRGB(255, 255, 255)
        -- 先同步两个颜色选择器，让设置面板色块显示纯白
        for _, Key in ipairs({ "OutlineColor", "FontColor" }) do
            local Opt = Library.Options and Library.Options[Key]
            if Opt and Opt.SetValue then pcall(Opt.SetValue, Opt, White) end
        end
        -- 再显式写入精确值，避免颜色选择器 HSV 往返改变最终配色
        if Library.Scheme then
            Library.Scheme.OutlineColor = White
            Library.Scheme.FontColor = White
        end
        if Library.UpdateColorsUsingRegistry then
            pcall(Library.UpdateColorsUsingRegistry, Library)
        end
    end
end
