pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../components"
import "../services" as Services

BasePopup {
    id: root
    anchorMode: "right"
    preferredWidth: Services.Theme.trayPopupWidth
    implicitHeight: Math.min(2 * Services.Theme.popupPadding + headerRow.height + Services.Theme.popupSpacing + Math.max(Services.Theme.rowHeight, root.listHeight), root.availableHeight)

    property int selectedIndex: 0
    property var currentMenu: null
    property var menuOwner: null
    property var menuStack: []
    readonly property ObjectModel trayModel: SystemTray.items
    readonly property var trayItems: root.trayModel.values
    readonly property bool inMenu: root.currentMenu !== null
    readonly property var entries: root.inMenu ? menuOpener.children.values : root.trayItems
    readonly property int listHeight: {
        let height = 0;
        for (const entry of root.entries)
            height += root.rowHeight(entry) + Services.Theme.listSpacing;
        return Math.min(Math.max(0, height - Services.Theme.listSpacing), 6 * Services.Theme.rowHeight + 5 * Services.Theme.listSpacing);
    }

    QsMenuOpener {
        id: menuOpener
        menu: root.currentMenu
    }
    ListNavKeys {
        host: root
        step: root.stepSelection
        confirm: () => root.activateSelected()
    }
    Shortcut { sequence: "h"; enabled: root.visible; onActivated: root.cancelOrClose() }
    Shortcut { sequence: "Left"; enabled: root.visible; onActivated: root.cancelOrClose() }
    Shortcut { sequence: "l"; enabled: root.visible; onActivated: root.openSelectedMenu() }
    Shortcut { sequence: "Right"; enabled: root.visible; onActivated: root.openSelectedMenu() }

    onVisibleChanged: root.reset()
    onEntriesChanged: Qt.callLater(root.clampSelection)
    onSelectedIndexChanged: entryList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
    onTrayItemsChanged: {
        if (root.inMenu && !root.trayItems.includes(root.menuOwner))
            root.reset();
    }

    function reset(): void {
        root.currentMenu = null;
        root.menuOwner = null;
        root.menuStack = [];
        root.selectedIndex = 0;
        entryList.contentY = 0;
    }
    function selectable(entry): bool {
        return !!entry && (!root.inMenu || (!entry.isSeparator && entry.enabled !== false));
    }
    function rowHeight(entry): int {
        return root.inMenu && entry?.isSeparator ? 8 : Services.Theme.rowHeight;
    }
    function clean(text: string): string {
        return (text ?? "").replace(/&&|&/g, match => match === "&&" ? "&" : "").trim();
    }
    function trayLabel(item): string {
        for (const text of [item?.tooltipTitle, item?.title, item?.id]) {
            if ((text ?? "").trim() !== "")
                return text.trim();
        }
        return "Tray app";
    }
    function labelFor(entry): string {
        return root.inMenu ? root.clean(entry?.text ?? "") : root.trayLabel(entry);
    }
    function clampSelection(): void {
        root.selectedIndex = Services.Theme.clamp(root.selectedIndex, 0, Math.max(0, root.entries.length - 1));
        if (!root.selectable(root.entries[root.selectedIndex])) {
            const first = root.entries.findIndex(entry => root.selectable(entry));
            root.selectedIndex = Math.max(0, first);
        }
    }
    function stepSelection(dir: int): void {
        const count = root.entries.length;
        for (let step = 1; step <= count; step++) {
            const next = (root.selectedIndex + dir * step + count) % count;
            if (root.selectable(root.entries[next])) {
                root.selectedIndex = next;
                return;
            }
        }
    }
    function openSelectedMenu(): void {
        const entry = root.entries[root.selectedIndex];
        if (!root.selectable(entry))
            return;
        if (!root.inMenu && entry.hasMenu) {
            root.menuOwner = entry;
            root.menuStack = [];
            root.currentMenu = entry.menu;
        } else if (root.inMenu && entry.hasChildren) {
            root.menuStack = [...root.menuStack, {menu: root.currentMenu, index: root.selectedIndex}];
            root.currentMenu = entry;
        } else {
            return;
        }
        root.selectedIndex = 0;
    }
    function cancelOrClose(): void {
        if (root.menuStack.length > 0) {
            const previous = root.menuStack[root.menuStack.length - 1];
            root.menuStack = root.menuStack.slice(0, -1);
            root.currentMenu = previous.menu;
            root.selectedIndex = previous.index;
        } else if (root.inMenu) {
            const previous = root.trayItems.indexOf(root.menuOwner);
            root.reset();
            root.selectedIndex = Math.max(0, previous);
        } else {
            root.close();
        }
    }
    function activateSelected(button = Qt.NoButton): void {
        const entry = root.entries[root.selectedIndex];
        if (!root.selectable(entry))
            return;
        if (root.inMenu) {
            if (button === Qt.RightButton) {
                root.cancelOrClose();
                return;
            }
            if (button === Qt.MiddleButton)
                return;
            if (entry.hasChildren) {
                root.openSelectedMenu();
                return;
            }
            entry.triggered();
        } else if (button === Qt.MiddleButton) {
            entry.secondaryActivate();
        } else if (entry.hasMenu && (button !== Qt.LeftButton || entry.onlyMenu)) {
            root.openSelectedMenu();
            return;
        } else if (button === Qt.RightButton || entry.onlyMenu) {
            return;
        } else {
            entry.activate();
        }
        root.close();
    }

    Column {
        anchors.fill: parent
        anchors.margins: Services.Theme.popupPadding
        spacing: Services.Theme.popupSpacing
        Row {
            id: headerRow
            width: parent.width
            height: Services.Theme.rowHeight
            spacing: Services.Theme.listSpacing
            PopupButton {
                id: backButton
                visible: root.inMenu
                width: headerRow.height
                label: "󰅁"
                onClicked: root.cancelOrClose()
            }
            Text {
                width: headerRow.width - closeButton.width - headerRow.spacing - (backButton.visible ? backButton.width + headerRow.spacing : 0)
                height: headerRow.height
                text: root.inMenu ? root.trayLabel(root.menuOwner) : "System tray"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                color: Services.Theme.fg
                font.family: Services.Theme.font
                font.pixelSize: Services.Theme.px13
            }
            PopupButton {
                id: closeButton
                width: headerRow.height
                label: "×"
                onClicked: root.close()
            }
        }
        ListView {
            id: entryList
            width: parent.width
            height: Math.max(0, root.height - 2 * Services.Theme.popupPadding - headerRow.height - Services.Theme.popupSpacing)
            model: root.entries
            spacing: Services.Theme.listSpacing
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            onModelChanged: contentY = 0
            delegate: Rectangle {
                id: row
                required property var modelData
                required property int index
                width: entryList.width
                height: root.rowHeight(row.modelData)
                radius: Services.Theme.controlRadius
                readonly property bool separator: root.inMenu && (row.modelData?.isSeparator ?? false)
                readonly property bool selected: row.index === root.selectedIndex && root.selectable(row.modelData)
                readonly property color textColor: row.selected ? Services.Theme.accentFg : root.selectable(row.modelData) ? Services.Theme.fg : Services.Theme.dim
                color: row.separator ? Services.Theme.transparent : row.selected ? Services.Theme.accent : Services.Theme.popupSurface
                Behavior on color { ColorAnimation { duration: Services.Theme.hoverDuration } }

                Rectangle {
                    visible: row.separator
                    anchors.verticalCenter: parent.verticalCenter
                    x: Services.Theme.popupPadding
                    width: parent.width - 2 * x
                    height: 1
                    color: Services.Theme.border
                }
                Row {
                    visible: !row.separator
                    anchors.fill: parent
                    anchors.leftMargin: Services.Theme.popupPadding
                    anchors.rightMargin: Services.Theme.popupPadding
                    spacing: Services.Theme.popupSpacing
                    Item {
                        width: Services.Theme.traySize
                        height: parent.height
                        Image {
                            anchors.centerIn: parent
                            visible: !root.inMenu || row.modelData?.checkState !== Qt.Checked
                            width: Services.Theme.traySize
                            height: width
                            source: row.modelData?.icon ?? ""
                            sourceSize.width: width
                            sourceSize.height: height
                            fillMode: Image.PreserveAspectFit
                        }
                        Text {
                            anchors.centerIn: parent
                            visible: root.inMenu && row.modelData?.checkState === Qt.Checked
                            text: "✓"
                            color: row.textColor
                            font.family: Services.Theme.font
                            font.pixelSize: Services.Theme.px12
                        }
                    }
                    Text {
                        width: parent.width - 2 * Services.Theme.traySize - 2 * parent.spacing
                        height: parent.height
                        text: root.labelFor(row.modelData)
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        color: row.textColor
                        font.family: Services.Theme.font
                        font.pixelSize: Services.Theme.px12
                    }
                    Text {
                        width: Services.Theme.traySize
                        height: parent.height
                        visible: root.inMenu ? (row.modelData?.hasChildren ?? false) : (row.modelData?.hasMenu ?? false)
                        text: "󰅂"
                        verticalAlignment: Text.AlignVCenter
                        color: row.textColor
                        font.family: Services.Theme.font
                        font.pixelSize: Services.Theme.px12
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: root.visible && root.selectable(row.modelData)
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.selectedIndex = row.index
                    onClicked: mouse => {
                        root.selectedIndex = row.index;
                        root.activateSelected(mouse.button);
                    }
                }
            }
            EmptyStateText {
                visible: root.entries.length === 0
                text: root.inMenu ? "No actions available" : "No tray items"
            }
        }
    }
}
