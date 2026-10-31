import QtQuick
import "../services" as Services
Rectangle {
    id: root
    anchors.fill: parent
    property int padding: Services.Theme.popupPadding
    default property alias content: column.data
    color: Services.Theme.transparent
    readonly property alias contentHeight: column.implicitHeight
    Column {
        id: column
        anchors.fill: parent
        anchors.margins: root.padding
        spacing: Services.Theme.popupSpacing
    }
}
