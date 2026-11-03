import "../components"
BarIcon {
    id: root
    required property var bar
    required property var clockSource
    anchors.verticalCenter: parent.verticalCenter
    popupActive: root.bar.popupByName("control")?.visible ?? false
    glyph: Qt.formatDateTime(clockSource?.date ?? new Date(), "ddd dd MMM HH:mm")
    onClicked: bar.togglePopup("control")
}
