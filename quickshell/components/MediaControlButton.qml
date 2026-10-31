import QtQuick
import "../services" as Services

Rectangle {
    id: root
    property string label: ""
    property bool usable: true
    property bool selected: false
    property color selectedColor: Services.Theme.accent
    property color selectedTextColor: Services.Theme.accentFg
    signal clicked
    implicitWidth: 42
    implicitHeight: Services.Theme.rowHeight
    color: root.selected ? root.selectedColor : mouse.containsMouse ? Services.Theme.popupHoverBg : Services.Theme.popupSurface
    border.width: root.selected || mouse.containsMouse ? 1 : 0
    border.color: root.selected ? root.selectedColor : Services.Theme.border
    opacity: root.usable ? 1 : 0.35
    Behavior on color { ColorAnimation { duration: Services.Theme.hoverDuration } }
    Text {
        anchors.centerIn: parent
        text: root.label
        color: root.selected ? root.selectedTextColor : Services.Theme.fg
        font.family: Services.Theme.font
        font.pixelSize: Services.Theme.px14
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.usable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
