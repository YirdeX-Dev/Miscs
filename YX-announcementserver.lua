return function(ServerTab, Library, ThemeManager, SaveManager)
    local YXannouncement = ServerTab:AddGroupbox({
        Side = "Right",
        Name = "更新公告",
        Description = "YX-SCRPIT公告",
        IconName = "megaphone",
        Visible = true,
        Collapsed = false,
        DisableCollapsing = false,
    })

    YXannouncement:AddLabel("<font color=\"rgb(0, 255, 0)\">添加了ESP方框</font>")
    YXannouncement:AddLabel("<font color=\"rgb(0, 255, 0)\">修复了技能在某些地图内会出现错误问题</font>")
YXannouncement:AddLabel("<font color=\"rgb(0, 255, 0)\">修复了Azure植物范围在某些地图内会出现错误问题</font>")
YXannouncement:AddLabel("<font color=\"rgb(0, 255, 0)\">修复了反效果中约翰多的技能</font>")

    local server = ServerTab:AddRightTabbox()

    local serverlist = server:AddTab("服务器状态")
    serverlist:AddLabel("Forsaken 🟢")    

    local serverstatus = server:AddTab("状态指示")
    serverstatus:AddLabel("🟢 正常使用")
    serverstatus:AddLabel("🟡 维护中")
    serverstatus:AddLabel("🔴 已检测")
    serverstatus:AddLabel("🔵 预更新")
    serverstatus:AddLabel("⭐ 开源")
    serverstatus:AddLabel("⚫ 停用")
end