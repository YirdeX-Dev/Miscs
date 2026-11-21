--[[
YX · UI 美化模块（精简版）   生成时间：11月21日16时37分
基于：YX-Obsidian_UI美化模块.lua（2898 行原版）

本版按确认只保留两块：
  1) 覆盖主题代码（保留且在用）——沿用原 ApplyPaletteFor 的
     「写 Library.Scheme + UpdateColorsUsingRegistry 刷新」机制；
     配色 = 运行时读取库原生主题色（快照，不写死 RGB、不按背景图取色），
     启动套用一次；并挂 ThemeManager 主题切换后重新套用，保证「主题运用原主题」。
  2) 液态玻璃（重做·更明显通透）——半透明磨砂底 + 斜向高光带 + 细白描边。

已全部删除：窗口/标签页/通知 三处边框渐变(YXGradientBorder)、窗口标题/文本
     渐变流光(YXLibTextFlow)、图标渐变流光、控件填充渐变、背景图及其
     按图取色/自动套用/预取、强制纯白覆盖块、Lock 隐藏块。

加载签名不变：Loader(Library, ThemeManager, SaveManager)
--]]

local Library, ThemeManager, SaveManager = ...

if not Library then
    warn("[YX] UI 美化模块需通过主脚本加载，请勿单独运行")
    return
end

-- ============================================================================
-- 1. 覆盖主题代码（保留且在用 · 主题运用原主题）
-- ============================================================================
do
    local THEME_KEYS = { "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor" }

    -- 「原主题」= 库原生主题色：加载这一刻直接从 Library.Scheme 读取。
    -- 不写死任何 RGB、不按背景图取色，库文件是什么主题就用什么主题。
    local OriginalTheme = {}
    if type(Library.Scheme) == "table" then
        for _, Key in ipairs(THEME_KEYS) do
            OriginalTheme[Key] = Library.Scheme[Key]
        end
    end

    local function Refresh()
        if type(Library.UpdateColorsUsingRegistry) == "function" then
            pcall(Library.UpdateColorsUsingRegistry, Library)
        end
    end

    -- 覆盖主题色：把原主题色写回 Scheme 并刷新（沿用原 ApplyPaletteFor 机制）
    local function ApplyOriginalTheme()
        if type(Library.Scheme) ~= "table" then return end
        for _, Key in ipairs(THEME_KEYS) do
            local C = OriginalTheme[Key]
            if C ~= nil then Library.Scheme[Key] = C end
        end
        Refresh()
    end

    -- 启动即套用一次（覆盖代码「在用」）
    pcall(ApplyOriginalTheme)

    -- 主题切换后重新套用，保证始终是原主题（沿用原模块 Force 语义），
    -- 且不吞掉原 ApplyTheme 的返回值。
    if ThemeManager and type(ThemeManager.ApplyTheme) == "function" then
        local OriginalApplyTheme = ThemeManager.ApplyTheme
        local packf   = table.pack
        local unpackf = table.unpack or unpack
        ThemeManager.ApplyTheme = function(Manager, ...)
            local Results = packf(OriginalApplyTheme(Manager, ...))
            pcall(ApplyOriginalTheme)
            return unpackf(Results, 1, Results.n)
        end
    end
end

-- ============================================================================
-- 2. 液态玻璃（重做 · 更明显通透）
--    · 半透明磨砂底：可见面板底色改为半透明
--    · 斜向高光带：白色斜向 UIGradient，亮带比原版更实（更明显）
--    · 细白描边：UIStroke 细白半透明，勾出玻璃轮廓
--    参数集中在 CFG，想调哪档改这里即可。
-- ============================================================================
do
    local CFG = {
        BaseTransparency   = 0.34,                            -- 磨砂底半透明度
        SheenRotation      = 118,                              -- 斜向高光带角度
        StrokeThickness    = 1.4,                              -- 细白描边粗细
        StrokeTransparency = 0.45,                            -- 描边柔和度
        HighlightColor     = Color3.fromRGB(255, 255, 255),    -- 高光带亮色
        MidColor           = Color3.fromRGB(206, 222, 255),    -- 高光带中段
        ShadowColor        = Color3.fromRGB(30, 38, 66),        -- 高光带暗色
        T0 = 0.55, T1 = 0.80, T2 = 0.96,                        -- 亮带透明度（比原版 0.7 更实）
    }

    local function AddGlassSheen(Parent)
        if not Parent then return end

        local Sheen = Instance.new("Frame")
        Sheen.Name = "YXLiquidGlassSheen"
        Sheen.BackgroundColor3 = CFG.HighlightColor
        Sheen.BackgroundTransparency = 0        -- 由 UIGradient.Transparency 控制亮带
        Sheen.BorderSizePixel = 0
        Sheen.Size = UDim2.fromScale(1, 1)
        Sheen.Active = false
        Sheen.ZIndex = 0
        Sheen.Parent = Parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, Library.CornerRadius or 4)
        Corner.Parent = Sheen
        if type(Library.Corners) == "table" then
            pcall(table.insert, Library.Corners, Corner)
        end

        local Gradient = Instance.new("UIGradient")
        Gradient.Rotation = CFG.SheenRotation
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    CFG.HighlightColor),
            ColorSequenceKeypoint.new(0.42, CFG.MidColor),
            ColorSequenceKeypoint.new(1,    CFG.ShadowColor),
        })
        Gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,    CFG.T0),
            NumberSequenceKeypoint.new(0.42,  CFG.T1),
            NumberSequenceKeypoint.new(1,     CFG.T2),
        })
        Gradient.Parent = Sheen

        local Stroke = Instance.new("UIStroke")
        Stroke.Name = "YXLiquidGlassStroke"
        Stroke.Color = CFG.HighlightColor
        Stroke.Thickness = CFG.StrokeThickness
        Stroke.Transparency = CFG.StrokeTransparency
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Parent = Sheen

        return Sheen
    end

    local function ApplyLiquidGlass(Object)
        if not Object or not Object:IsA("GuiObject") then return end
        if Object.BackgroundTransparency >= 1 then return end          -- 全透明的跳过
        if Object.BackgroundTransparency < CFG.BaseTransparency then   -- 只把实底改半透明
            Object.BackgroundTransparency = CFG.BaseTransparency
        end
    end

    local MainFrame = Library and Library.Window and Library.Window.MainFrame
    if MainFrame then
        pcall(function()
            for _, Object in ipairs(MainFrame:GetDescendants()) do
                pcall(ApplyLiquidGlass, Object)
            end
        end)
        pcall(AddGlassSheen, MainFrame)
    end
end

-- 11月21日16时37分
