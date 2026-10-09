import QtQuick
import Quickshell.Hyprland
import "../services" as Services

Text {
    id: root
    required property string screenName
    property var leftItem: null

    anchors {
        left: root.leftItem ? root.leftItem.right : parent.left
        leftMargin: root.leftItem ? Services.Theme.titleMargin : Services.Theme.barMargin
        verticalCenter: parent.verticalCenter
    }

    readonly property string activeTitle: {
        // 1. Get current workspace ID on this specific monitor
        const mons = Hyprland.monitors && Hyprland.monitors.values ? Hyprland.monitors.values : [];
        let activeWsId = null;
        for (const m of mons) {
            if (m && String(m.name) === root.screenName && m.activeWorkspace) {
                activeWsId = m.activeWorkspace.id;
                break;
            }
        }

        // 2. Check the globally active window
        const active = Hyprland.activeToplevel;
        if (active && active.workspace) {
            const m = active.monitor;
            const name = m && m.name ? String(m.name) : "";
            if (name === root.screenName && active.workspace.id === activeWsId) {
                return active.title ?? "";
            }
        }

        // 3. Fallback to active window sitting on this monitor's active workspace
        const all = Hyprland.toplevels && Hyprland.toplevels.values ? Hyprland.toplevels.values : [];
        for (const t of all) {
            if (t && t.workspace) {
                const m = t.monitor;
                const name = m && m.name ? String(m.name) : "";
                if (name === root.screenName && t.workspace.id === activeWsId && t.activated) {
                    return t.title ?? "";
                }
            }
        }

        // 4. Return empty string if no window exists on the active workspace
        return "";
    }

    text: root.activeTitle
    visible: text !== ""
    width: Math.min(implicitWidth, Services.Theme.titleMax)
    color: Services.Theme.fg
    font.family: Services.Theme.font
    font.pixelSize: Services.Theme.px12
    elide: Text.ElideRight
    maximumLineCount: 1
}
