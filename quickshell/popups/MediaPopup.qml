pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import "../components"
import "../services" as Services

BasePopup {
    id: root
    anchorMode: "right"
    anchorCenterX: bar.mediaPopupCenterX
    preferredWidth: Services.Theme.mediaPopupWidth
    implicitHeight: Math.min(540, root.availableHeight)
    readonly property int coverSize: 220
    readonly property var player: Services.Media.spotifyPlayer
    readonly property string artworkSource: String(root.player?.trackArtUrl ?? "")
    readonly property string trackTitle: root.player?.trackTitle || "Nothing playing"
    readonly property string artist: root.player?.trackArtist || root.player?.trackAlbumArtist || ""
    readonly property string album: root.player?.trackAlbum || ""
    readonly property color artAccent: root.artworkSource !== "" && Services.Theme.artworkAccentReady && Services.Theme.artworkAccentSource === root.artworkSource ? Services.Theme.artworkAccent : Services.Theme.accent
    property real progressPosition: 0
    property real progressBase: 0
    property double progressClock: 0
    property var cavaLevels: []
    property bool cavaHasData: false
    readonly property bool visualizerVisible: root.visible && root.player?.isPlaying === true && root.cavaHasData

    function accentFor(player): color {
        const source = String(player?.trackArtUrl ?? "");
        if (source !== "" && Services.Theme.artworkAccentReady && Services.Theme.artworkAccentSource === source)
            return Services.Theme.artworkAccent;
        return Services.Theme.accent;
    }
    function refreshArtAccent(): void {
        if (root.artworkSource === "") {
            Services.Theme.clearArtworkAccent();
            return;
        }
        Services.Theme.refreshArtworkAccent(root.artworkSource);
    }
    function parseCavaFrame(frame: string): void {
        const values = String(frame ?? "").trim().split(/[;,\s]+/).filter(v => v !== "").map(v => parseFloat(v));
        const levels = [];
        for (const value of values) {
            if (!isFinite(value))
                continue;
            levels.push(Math.max(0, Math.min(1, value / 100)));
        }
        if (levels.length === 0)
            return;
        root.cavaLevels = levels;
        root.cavaHasData = true;
    }
    function stopVisualizer(): void {
        if (cavaProcess.running)
            cavaProcess.running = false;
        root.cavaLevels = [];
        root.cavaHasData = false;
    }
    function syncVisualizer(): void {
        if (!root.visible || !root.player || root.player.isPlaying !== true) {
            root.stopVisualizer();
            return;
        }
        if (!cavaProcess.running) {
            root.cavaLevels = [];
            root.cavaHasData = false;
            cavaProcess.running = true;
        }
    }
    function formatTime(seconds): string {
        const value = Math.max(0, Math.floor(Number(seconds) || 0));
        const minutes = Math.floor(value / 60);
        return minutes + ":" + String(value % 60).padStart(2, "0");
    }
    function syncProgress(): void {
        const p = root.player;
        const value = Number(p?.position);
        if (!p || !isFinite(value)) {
            root.progressBase = 0;
            root.progressPosition = 0;
            root.progressClock = Date.now();
            return;
        }
        root.progressBase = Math.max(0, value);
        root.progressClock = Date.now();
        root.progressPosition = root.currentPosition();
    }
    function currentPosition(): real {
        const p = root.player;
        if (!p)
            return 0;
        let value = root.progressBase;
        if (p.isPlaying && root.progressClock > 0)
            value += Math.max(0, (Date.now() - root.progressClock) / 1000);
        const length = Number(p.length);
        return isFinite(length) && length > 0 ? Math.max(0, Math.min(length, value)) : Math.max(0, value);
    }
    function seekRatio(): real {
        const p = root.player;
        if (!p || !p.lengthSupported || !isFinite(p.length) || p.length <= 0)
            return 0;
        return Math.max(0, Math.min(1, root.progressPosition / p.length));
    }
    function seekTo(ratio: real): void {
        const p = root.player;
        if (!p || !p.positionSupported || !p.lengthSupported || !isFinite(p.length))
            return;
        const position = Math.max(0, Math.min(1, ratio)) * p.length;
        p.position = position;
        root.progressBase = position;
        root.progressClock = Date.now();
        root.progressPosition = position;
    }

    onPlayerChanged: {
        root.syncProgress();
        root.refreshArtAccent();
        root.syncVisualizer();
    }
    Component.onCompleted: {
        root.syncProgress();
        root.refreshArtAccent();
        root.syncVisualizer();
    }

    onVisibleChanged: {
        if (!visible) {
            Services.Theme.clearArtworkAccent();
            root.stopVisualizer();
            return;
        }
        if (!Services.Media.spotifyAvailable)
            root.close();
        else {
            root.refreshArtAccent();
            root.syncVisualizer();
        }
    }
    Connections {
        target: Services.Media
        function onSpotifyAvailableChanged(): void {
            if (root.visible && !Services.Media.spotifyAvailable)
                root.close();
        }
    }
    Connections {
        target: root.player
        function onPositionChanged(): void { root.syncProgress(); }
        function onIsPlayingChanged(): void {
            root.syncProgress();
            root.syncVisualizer();
        }
        function onTrackArtUrlChanged(): void { root.refreshArtAccent(); }
    }
    Timer {
        interval: 250
        repeat: true
        running: root.visible && root.player?.isPlaying === true
        onTriggered: {
            const p = root.player;
            const value = Number(p?.position);
            if (!p || !isFinite(value))
                return;
            if (!p.isPlaying || Math.abs(value - root.progressBase) > 0.75) {
                root.progressBase = Math.max(0, value);
                root.progressClock = Date.now();
            }
            root.progressPosition = p.isPlaying ? root.currentPosition() : Math.max(0, value);
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: Services.Theme.popupPadding
        spacing: Services.Theme.popupSpacing
        Item {
            width: parent.width
            height: Services.Theme.rowHeight
            Column {
                anchors.fill: parent
                spacing: 1
                Text {
                    width: parent.width
                    text: "NOW PLAYING"
                    color: root.artAccent
                    horizontalAlignment: Text.AlignHCenter
                    font.family: Services.Theme.font
                    font.pixelSize: Services.Theme.px10
                    font.bold: true
                }
            }
        }
        Item {
            width: parent.width
            height: root.coverSize
            Item {
                id: artStage
                width: root.coverSize
                height: root.coverSize
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: coverArt
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    sourceSize.width: root.coverSize * 2
                    sourceSize.height: root.coverSize * 2
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false
                    visible: status === Image.Ready
                }
                Text {
                    anchors.centerIn: parent
                    visible: !coverArt.visible
                    text: "󰝚"
                    color: root.artAccent
                    font.family: Services.Theme.font
                    font.pixelSize: 48
                }
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 1
                    border.color: root.artAccent
                    opacity: 0.7
                }
            }
        }
        Item {
            width: parent.width
            height: 10
        }
        Column {
            width: parent.width
            spacing: Services.Theme.listSpacing
            Text {
                width: parent.width
                text: root.trackTitle
                color: Services.Theme.fg
                horizontalAlignment: Text.AlignHCenter
                font.family: Services.Theme.font
                font.pixelSize: Services.Theme.px14
                font.bold: true
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
            Text {
                width: parent.width
                visible: root.artist !== ""
                text: root.artist
                color: root.artAccent
                horizontalAlignment: Text.AlignHCenter
                font.family: Services.Theme.font
                font.pixelSize: Services.Theme.px12
                elide: Text.ElideRight
            }
            Text {
                width: parent.width
                visible: root.album !== ""
                text: root.album
                color: Services.Theme.dim
                horizontalAlignment: Text.AlignHCenter
                font.family: Services.Theme.font
                font.pixelSize: Services.Theme.px11
                elide: Text.ElideRight
            }
            Item {
                width: parent.width
                height: 1
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.72
                    height: 1
                    color: Services.Theme.withAlpha(root.artAccent, 0.24)
                }
            }
        }
        Item {
            width: parent.width
            height: Services.Theme.rowHeight
            Row {
                anchors.centerIn: parent
                spacing: Services.Theme.listSpacing
                MediaControlButton {
                    width: 48
                    height: Services.Theme.rowHeight
                    label: "󰒮"
                    selectedColor: root.artAccent
                    usable: root.player?.canGoPrevious ?? false
                    onClicked: Services.Media.mediaPrev(root.player)
                }
                MediaControlButton {
                    width: 48
                    height: Services.Theme.rowHeight
                    label: root.player?.isPlaying ? "󰏤" : "󰐊"
                    selectedColor: root.artAccent
                    usable: root.player?.canTogglePlaying ?? false
                    selected: root.player?.isPlaying ?? false
                    onClicked: Services.Media.mediaToggle(root.player)
                }
                MediaControlButton {
                    width: 48
                    height: Services.Theme.rowHeight
                    label: "󰒭"
                    selectedColor: root.artAccent
                    usable: root.player?.canGoNext ?? false
                    onClicked: Services.Media.mediaNext(root.player)
                }
            }
        }
        Item {
            width: parent.width
            height: 40
            visible: root.player?.lengthSupported ?? false
            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: 5
                }
                height: 4
                color: Services.Theme.popupSurface
            }
            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    topMargin: 5
                }
                width: parent.width * root.seekRatio()
                height: 4
                color: root.artAccent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: mouse => root.seekTo(Math.max(0, Math.min(1, mouse.x / width)))
            }
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 16
                text: root.formatTime(root.progressPosition)
                color: Services.Theme.dim
                font.family: Services.Theme.font
                font.pixelSize: Services.Theme.px10
            }
            Text {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 16
                text: root.formatTime(root.player?.length)
                color: Services.Theme.dim
                font.family: Services.Theme.font
                font.pixelSize: Services.Theme.px10
            }
        }
        Item {
            id: visualizer
            width: parent.width
            height: root.visualizerVisible ? 46 : 0
            visible: root.visualizerVisible
            clip: true
            Row {
                id: visualizerRow
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: parent.height
                spacing: 2
                Repeater {
                    model: root.cavaLevels.length
                    delegate: Rectangle {
                        required property int index
                        width: Math.max(1, (visualizerRow.width - (root.cavaLevels.length - 1) * visualizerRow.spacing) / Math.max(1, root.cavaLevels.length))
                        height: Math.max(2, visualizerRow.height * root.cavaLevels[index])
                        anchors.bottom: parent.bottom
                        color: root.artAccent
                        opacity: 0.9
                        Behavior on height {
                            NumberAnimation {
                                duration: 90
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: cavaProcess
        command: ["sh", "-c", "printf '%s\\n' '[general]' 'bars = 28' 'framerate = 30' '[input]' 'method = pipewire' 'source = auto' '[output]' 'method = raw' 'raw_target = /dev/stdout' 'data_format = ascii' 'ascii_max_range = 100' 'bar_delim = 59' 'frame_delim = 10' | cava -p /dev/stdin"]
        stdout: SplitParser {
            onRead: data => root.parseCavaFrame(data)
        }
        onExited: {
            root.cavaLevels = [];
            root.cavaHasData = false;
        }
    }
}
