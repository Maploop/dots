import QtQuick
import "../services" as Services
Rectangle {
    id: root
    anchors.fill: parent
    property bool opaque: false
    default property alias content: column.data
    color: root.opaque ? Services.Theme.popupBg : Services.Theme.bg
    Column {
        id: column
        anchors.fill: parent
        anchors.margins: Services.Theme.popupPadding
        spacing: Services.Theme.popupSpacing
    }
}
