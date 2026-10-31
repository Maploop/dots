import QtQuick
import "../services" as Services

Item {
    id: root
    required property var bar
    readonly property var player: Services.Media.spotifyPlayer
    readonly property bool available: Services.Media.spotifyAvailable
    readonly property bool expanded: root.bar.popupByName("media")?.visible ?? false
    readonly property string title: root.player?.trackTitle || root.player?.identity || "Spotify"
    readonly property string artSource: root.player?.trackArtUrl ?? ""
    visible: root.available
    implicitWidth: root.available ? mediaRow.width + 4 : 0
    implicitHeight: root.available ? Math.max(Services.Theme.traySize, mediaRow.height) : 0
    width: implicitWidth
    height: implicitHeight

    Row {
        id: mediaRow
        anchors.centerIn: parent
        spacing: Services.Theme.tightSpacing
        Image {
            width: 18
            height: 18
            anchors.verticalCenter: parent.verticalCenter
            source: root.artSource
            sourceSize.width: 36
            sourceSize.height: 36
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
            visible: status === Image.Ready
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.player?.isPlaying ? "󰏤" : "󰐊"
            color: root.expanded ? Services.Theme.accent : Services.Theme.dim
            font.family: Services.Theme.font
            font.pixelSize: Services.Theme.px12
        }
        Text {
            width: Math.min(132, implicitWidth)
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            elide: Text.ElideRight
            color: root.expanded ? Services.Theme.fg : Services.Theme.dim
            font.family: Services.Theme.font
            font.pixelSize: Services.Theme.px11
        }
    }
    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: 1
        color: Services.Theme.accent
        opacity: root.expanded ? 0.95 : 0.35
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.bar.togglePopup("media")
    }
}
