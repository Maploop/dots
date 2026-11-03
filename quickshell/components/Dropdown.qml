import QtQuick
import "../services" as Services
Item {
    id: root
    required property var options
    required property string current
    property bool open: false
    property bool selected: false
    property int cursor: 0
    property bool openUp: false
    property bool enabled: true
    property int maxVisible: 6
    // Keep menus inside a scrolling settings page, opening above when needed.
    property Flickable menuViewport: null
    readonly property real headerTop: root.open && root.menuViewport ? root.mapToItem(root.menuViewport.contentItem, 0, 0).y - root.menuViewport.contentY : 0
    readonly property real spaceAbove: Math.max(0, root.headerTop - Services.Theme.listSpacing)
    readonly property real spaceBelow: root.menuViewport ? Math.max(0, root.menuViewport.height - root.headerTop - root.height - Services.Theme.listSpacing) : root.menuHeight()
    readonly property bool menuOpensUp: root.openUp || (root.menuViewport !== null && root.menuHeight() > root.spaceBelow && root.spaceAbove > root.spaceBelow)
    readonly property real visibleMenuHeight: root.menuViewport ? Math.min(root.menuHeight(), root.menuOpensUp ? root.spaceAbove : root.spaceBelow) : root.menuHeight()
    property real wheelRemainder: 0
    signal headerClicked()
    signal optionClicked(string value)
    signal optionHovered(int index)
    width: parent.width
    height: Services.Theme.rowHeight
    function menuHeight(): int {
        const n = Math.min(root.options.length, root.maxVisible);
        if (n <= 0)
            return 0;
        return n * Services.Theme.rowHeight + (n - 1) * Services.Theme.listSpacing + 8;
    }
    function navigateWheel(event, inMenu: bool): void {
        if (!root.enabled || root.options.length === 0)
            return;
        event.accepted = true;
        root.wheelRemainder += event.pixelDelta.y !== 0 ? -event.pixelDelta.y / Services.Theme.rowHeight : -event.angleDelta.y / 120;
        const steps = Math.trunc(root.wheelRemainder);
        if (steps === 0)
            return;
        root.wheelRemainder -= steps;
        const currentIndex = inMenu || root.open ? root.cursor : Math.max(0, root.options.indexOf(root.current));
        const next = Math.max(0, Math.min(root.options.length - 1, currentIndex + steps));
        if (inMenu || root.open)
            root.optionHovered(next);
        else if (next !== currentIndex)
            root.optionClicked(root.options[next]);
    }
    onCursorChanged: {
        if (root.open)
            optList.positionViewAtIndex(root.cursor, ListView.Contain);
    }
    onOpenChanged: {
        root.wheelRemainder = 0;
        if (root.open)
            optList.positionViewAtIndex(root.cursor, ListView.Contain);
    }
    Rectangle {
        id: header
        width: parent.width
        height: Services.Theme.rowHeight
        color: root.open ? Services.Theme.popupActiveBg : root.selected ? Services.Theme.accent : headerHover.containsMouse ? Services.Theme.popupHoverBg : Services.Theme.popupSurface
        Text {
            id: headerLabel
            anchors {
                left: parent.left
                leftMargin: 10
                right: chevron.left
                rightMargin: 6
                verticalCenter: parent.verticalCenter
            }
            verticalAlignment: Text.AlignVCenter
            text: root.current
            color: root.open ? Services.Theme.fg : root.selected ? Services.Theme.accentFg : Services.Theme.fg
            font.family: Services.Theme.font
            font.pixelSize: Services.Theme.px12
            elide: Text.ElideRight
        }
        Text {
            id: chevron
            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            visible: root.enabled
            width: 14
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            text: root.open ? "▴" : "▾"
            color: root.open ? Services.Theme.dim : root.selected ? Services.Theme.accentFg : Services.Theme.dim
            font.family: Services.Theme.font
            font.pixelSize: Services.Theme.px12
        }
        MouseArea {
            id: headerHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                if (root.enabled)
                    root.headerClicked();
            }
            onWheel: wheel => root.navigateWheel(wheel, false)
        }
    }
    Rectangle {
        visible: root.open && root.enabled && root.options.length > 0
        width: parent.width
        height: root.visibleMenuHeight
        y: root.menuOpensUp ? -(height + Services.Theme.listSpacing) : Services.Theme.rowHeight + Services.Theme.listSpacing
        z: 100
        color: Services.Theme.popupBg
        border.width: 1
        border.color: Services.Theme.border
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
            onPressed: mouse => mouse.accepted = true
            onClicked: mouse => mouse.accepted = true
        }
        WheelHandler {
            target: null
            onWheel: event => root.navigateWheel(event, true)
        }
        ListView {
            id: optList
            anchors.fill: parent
            anchors.margins: 4
            clip: true
            spacing: Services.Theme.listSpacing
            model: root.options
            currentIndex: root.cursor
            delegate: ResultRow {
                required property var modelData
                required property int index
                readonly property bool isCurrent: modelData === root.current
                readonly property bool isCursor: index === root.cursor
                selected: isCursor
                highlighted: isCurrent
                baseColor: Services.Theme.popupSurface
                onHovered: root.optionHovered(index)
                onClicked: root.optionClicked(modelData)
                Text {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 10
                    }
                    verticalAlignment: Text.AlignVCenter
                    text: (parent.isCurrent ? "✓  " : "") + modelData
                    color: parent.selected ? Services.Theme.accentFg : parent.highlighted ? Services.Theme.accent : parent.isHovered ? Services.Theme.fg : Services.Theme.dim
                    font.family: Services.Theme.font
                    font.pixelSize: Services.Theme.px12
                    elide: Text.ElideRight
                }
            }
        }
    }
}
