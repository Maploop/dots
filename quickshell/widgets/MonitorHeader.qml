import QtQuick

Item {
    id: root
    required property string screenName
    anchors.fill: parent
    Workspaces {
        id: workspaces
        screenName: root.screenName
    }
    WindowTitle {
        screenName: root.screenName
        leftItem: workspaces
    }
}
