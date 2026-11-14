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

    YXannouncement:AddLabel("<font color=\"rgb(0, 255, 0)\">无</font>")
    YXannouncement:AddLabel("<font color=\"rgb(255,0, 0)\">无</font>")

    local server = ServerTab:AddRightTabbox()

    local serverlist = server:AddTab("服务器状态")
    serverlist:AddLabel("Forsaken 🟢")

    local serverstatus = server:AddTab("状态指示")
    serverstatus:AddLabel("🟢 正常使用")
    serverstatus:AddLabel("🟡 可执行，维护中")
    serverstatus:AddLabel("🟠 关闭，维护中")
    serverstatus:AddLabel("🔴 已检测")
    serverstatus:AddLabel("🔵 预更新")
    serverstatus:AddLabel("⚫ 停用")
end