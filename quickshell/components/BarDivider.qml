import QtQuick
import "../services" as Services

Item {
    id: root
    property string screenName: ""
    readonly property var popup: Services.Bars.attachedPopup
    readonly property bool connected: root.popup !== null && root.popup.anchorScreenName === root.screenName
    readonly property real joinLeft: root.connected ? Math.max(0, root.popup.anchor.rect.x) : width
    readonly property real joinRight: root.connected ? Math.min(width, root.popup.anchor.rect.x + root.popup.width) : width
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    height: 1
    Rectangle {
        width: root.joinLeft
        height: parent.height
        color: Services.Theme.border
    }
    Rectangle {
        x: root.joinRight
        width: Math.max(0, root.width - x)
        height: parent.height
        color: Services.Theme.border
    }
}
