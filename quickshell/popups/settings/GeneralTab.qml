pragma ComponentBehavior: Bound

import QtQuick
import "../../components"
import "../../services" as Services

Column {
    id: root
    required property var popup
    property alias wallList: wallList

    visible: popup.tab === 0
    width: parent.width
    spacing: Services.Theme.popupSpacing
    Text {
        width: parent.width
        height: popup.sectionH
        verticalAlignment: Text.AlignVCenter
        text: popup.wpCount > 0 ? "Choose a wallpaper  ·  " + popup.wpCount + " images" : "Wallpaper"
        color: Services.Theme.fg
        font.family: Services.Theme.font
        font.pixelSize: Services.Theme.px13
    }
    Column {
        width: parent.width
        spacing: Services.Theme.listSpacing
        Item {
            width: parent.width
            height: popup.wpListH + popup.wallWrapPad * 2
            visible: popup.wpCount > 0
            Rectangle {
                anchors.fill: parent
                color: Services.Theme.transparent
                radius: Services.Theme.popupRadius
                border.width: popup.wallFocus ? 1 : 0
                border.color: Services.Theme.accent
            }
            GridView {
                id: wallList
                anchors.fill: parent
                anchors.margins: popup.wallWrapPad
                clip: true
                flow: GridView.FlowLeftToRight
                cellWidth: Math.max(1, Math.floor(width / popup.wpCols))
                cellHeight: popup.wpCellH
                boundsBehavior: Flickable.StopAtBounds
                cacheBuffer: popup.wpCellH
                model: Services.Settings.wallpapers
                onCountChanged: popup.syncWallCursor()
                delegate: Item {
                    id: cell
                    required property var modelData
                    required property int index
                    readonly property bool current: modelData === Services.Settings.wallpaperOverride
                    readonly property bool selected: popup.wallFocus && wallList.currentIndex === index
                    width: GridView.view.cellWidth
                    height: GridView.view.cellHeight
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: popup.wpGap / 2
                        radius: Services.Theme.popupRadius
                        color: cell.selected || thumbHover.containsMouse ? Services.Theme.popupHoverBg : Services.Theme.popupSurface
                        border.width: cell.current || cell.selected ? 2 : 1
                        border.color: cell.current || cell.selected ? Services.Theme.accent : Services.Theme.border
                        Behavior on border.color { ColorAnimation { duration: Services.Theme.hoverDuration } }
                        Behavior on color { ColorAnimation { duration: Services.Theme.hoverDuration } }
                        clip: true
                        Image {
                            id: thumbnail
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                bottom: nameLabel.top
                                topMargin: 6
                                leftMargin: 6
                                rightMargin: 6
                                bottomMargin: 6
                            }
                            // Release previews when the gallery is not in use.
                            source: popup.visible && popup.tab === 0 ? "file://" + cell.modelData : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: false
                            smooth: true
                            mipmap: true
                            sourceSize.width: 512
                            sourceSize.height: 288
                            Text {
                                anchors.centerIn: parent
                                visible: thumbnail.status !== Image.Ready
                                text: thumbnail.status === Image.Error ? "Preview unavailable" : "Loading…"
                                color: Services.Theme.dim
                                font.family: Services.Theme.font
                                font.pixelSize: Services.Theme.px11
                            }
                            Rectangle {
                                anchors {
                                    top: parent.top
                                    right: parent.right
                                    margins: 8
                                }
                                visible: cell.current
                                width: currentLabel.implicitWidth + 16
                                height: 24
                                radius: Services.Theme.controlRadius
                                color: Services.Theme.accent
                                Text {
                                    id: currentLabel
                                    anchors.centerIn: parent
                                    text: "✓ Current"
                                    color: Services.Theme.accentFg
                                    font.family: Services.Theme.font
                                    font.pixelSize: Services.Theme.px11
                                }
                            }
                        }
                        Text {
                            id: nameLabel
                            anchors {
                                left: parent.left
                                right: parent.right
                                bottom: parent.bottom
                                leftMargin: 10
                                rightMargin: 10
                                bottomMargin: 6
                            }
                            height: 24
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            text: String(cell.modelData).split("/").pop().replace(/\.[^.]+$/, "").replace(/[_-]+/g, " ")
                            color: cell.selected ? Services.Theme.fg : cell.current ? Services.Theme.accent : thumbHover.containsMouse ? Services.Theme.fg : Services.Theme.dim
                            font.family: Services.Theme.font
                            font.pixelSize: Services.Theme.px12
                            elide: Text.ElideRight
                        }
                        MouseArea {
                            id: thumbHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onContainsMouseChanged: {
                                if (containsMouse) {
                                    wallList.currentIndex = cell.index;
                                    popup.wallCursor = cell.index;
                                    popup.hoverSelect(0);
                                }
                            }
                            onClicked: {
                                wallList.currentIndex = cell.index;
                                popup.wallCursor = cell.index;
                                popup.selectedIndex = 0;
                                popup.wallFocus = false;
                                Services.Settings.setWallpaper(cell.modelData);
                            }
                        }
                    }
                }
            }
        }
        Text {
            width: parent.width
            visible: popup.wpCount === 0
            wrapMode: Text.WordWrap
            text: "Add images to ~/dotfiles/wallpapers or ~/Pictures/Wallpapers"
            color: Services.Theme.dim
            font.family: Services.Theme.font
            font.pixelSize: Services.Theme.px12
        }
        Text {
            width: parent.width
            height: popup.wallHintH
            visible: popup.wpCount > 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            text: popup.wallFocus ? "Arrows move · Enter applies · Esc exits" : "Click to apply · Enter to browse with keyboard"
            color: Services.Theme.dim
            font.family: Services.Theme.font
            font.pixelSize: Services.Theme.px10
        }
    }
    Text {
        width: parent.width
        height: popup.sectionH
        verticalAlignment: Text.AlignVCenter
        text: "Wallpaper colors"
        color: Services.Theme.dim
        font.family: Services.Theme.font
        font.pixelSize: Services.Theme.px11
    }
    Column {
        width: parent.width
        spacing: Services.Theme.listSpacing
        SettingsRow {
            title: "Wallpaper palette"
            value: Services.Settings.wallpaperPaletteEnabled ? "On" : "Off"
            selected: popup.tab === 0 && popup.selectedIndex === popup.paletteEnabledIndex
            onHovered: popup.hoverSelect(popup.paletteEnabledIndex)
            SettingsSwitch {
                on: Services.Settings.wallpaperPaletteEnabled
                onToggled: Services.Settings.setWallpaperPaletteEnabled(!Services.Settings.wallpaperPaletteEnabled)
            }
        }
        SettingsRow {
            title: "Palette style"
            selected: popup.tab === 0 && popup.selectedIndex === popup.paletteModeIndex
            z: popup.paletteDropOpen ? 100 : 0
            onHovered: popup.hoverSelect(popup.paletteModeIndex)
            Dropdown {
                options: Services.Theme.wallpaperPaletteModes
                current: Services.Settings.wallpaperPaletteMode
                open: popup.paletteDropOpen
                selected: popup.tab === 0 && popup.selectedIndex === popup.paletteModeIndex
                cursor: popup.dropCursor
                onHeaderClicked: {
                    popup.selectedIndex = popup.paletteModeIndex;
                    popup.togglePaletteModeDrop();
                }
                onOptionHovered: index => popup.dropCursor = index
                onOptionClicked: value => {
                    popup.selectedIndex = popup.paletteModeIndex;
                    Services.Settings.setWallpaperPaletteMode(value);
                    popup.closeDrop();
                }
            }
        }
    }
    Text {
        width: parent.width
        height: popup.sectionH
        verticalAlignment: Text.AlignVCenter
        text: "Mouse & touchpad"
        color: Services.Theme.dim
        font.family: Services.Theme.font
        font.pixelSize: Services.Theme.px11
    }
    Column {
        width: parent.width
        spacing: Services.Theme.listSpacing
        SettingsSliderRow {
            title: "Sensitivity"
            value: Services.Settings.sensitivity.toFixed(1)
            selected: popup.tab === 0 && popup.selectedIndex === popup.mouseInputBase + 0
            onHovered: popup.hoverSelect(popup.mouseInputBase + 0)
            sliderMinimum: -1
            sliderMaximum: 1
            sliderValue: Services.Settings.sensitivity
            onSliderMoved: value => Services.Settings.setSensitivity(value)
        }
        SettingsSliderRow {
            title: "Touchpad scroll"
            value: Services.Settings.touchScroll.toFixed(1)
            selected: popup.tab === 0 && popup.selectedIndex === popup.mouseInputBase + 1
            onHovered: popup.hoverSelect(popup.mouseInputBase + 1)
            sliderMinimum: 0.1
            sliderMaximum: 2
            sliderValue: Services.Settings.touchScroll
            onSliderMoved: value => Services.Settings.setTouchScroll(value)
        }
        SettingsRow {
            title: "Natural scroll"
            value: Services.Settings.naturalScroll ? "On" : "Off"
            selected: popup.tab === 0 && popup.selectedIndex === popup.mouseInputBase + 2
            onHovered: popup.hoverSelect(popup.mouseInputBase + 2)
            SettingsSwitch {
                on: Services.Settings.naturalScroll
                onToggled: Services.Settings.setNaturalScroll(!Services.Settings.naturalScroll)
            }
        }
    }
}
