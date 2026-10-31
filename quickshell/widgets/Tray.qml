import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../components"
import "../services" as Services

BarIcon {
    id: root
    required property var bar
    anchors.verticalCenter: parent.verticalCenter
    readonly property bool expanded: root.bar.popupByName("tray")?.visible ?? false
    readonly property ObjectModel trayModel: SystemTray.items
    visible: root.trayModel.values.length > 0
    glyph: root.expanded ? "󰅃" : "󰅀"
    glyphColor: root.expanded ? Services.Theme.accent : Services.Theme.fg
    tipText: "System tray"
    tipAnchor: root.bar
    hPadding: 4
    onClicked: root.bar.togglePopup("tray")
}
