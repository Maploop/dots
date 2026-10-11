import QtQuick
import "../services" as Services
Rectangle {
    id: root
    anchors.fill: parent
    property bool opaque: false
    property bool glassBlur: true
    default property alias content: column.data
    color: root.opaque ? (root.glassBlur ? Services.Theme.glassPopupBg : Services.Theme.popupBg) : (root.glassBlur ? Services.Theme.bg : Services.Theme.solidBg)
    Column {
        id: column
        anchors.fill: parent
        anchors.margins: Services.Theme.popupPadding
        spacing: Services.Theme.popupSpacing
    }
}
