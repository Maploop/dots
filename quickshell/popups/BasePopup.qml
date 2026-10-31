import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "../services" as Services
PopupWindow {
    id: base
    required property var bar
    property real preferredWidth: Services.Theme.popupWidth
    implicitWidth: Math.min(base.preferredWidth, base.availableWidth)
    property string anchorMode: "middle"
    // Optional center point in the bar window for popups tied to a specific bar item.
    property real anchorCenterX: -1
    property bool attachToBar: true
    property int extraTop: 0
    property bool useGrab: true
    property bool preventClose: false
    readonly property bool pickerActive: (bar?.screenshotTool?.pickerActive) === true
    property int busyMs: 1500
    function kickBusy(): void {
        base.preventClose = true;
        base.regrab();
        busySettle.restart();
    }
    function calmBusy(): void {
        busySettle.stop();
        base.preventClose = false;
    }
    property var returnTo: null
    property var extraGrabWindows: []
    readonly property var effectiveGrabWindows: [base].concat(extraGrabWindows ?? [])
    property Item focusTarget: null
    property double openedAt: 0
    function focusTargetNow(): void {
        if (base.focusTarget && base.visible)
            base.focusTarget.forceActiveFocus();
    }
    function regrab(): void {
        if (base.pickerActive)
            return;
        if (!grab.active && base.visible)
            grab.active = true;
    }
    function kickGrab(): void {
        if (base.pickerActive)
            return;
        if (base.visible && base.useGrab)
            grabTimer.restart();
    }
    function forceGrab(): void {
        grab.active = false;
        grab.active = true;
    }
    function close(): void {
        const hadGrab = grab.active;
        const back = base.returnTo;
        base.returnTo = null;
        base.visible = false;
        if (back) {
            back.visible = true;
            if (hadGrab && back.useGrab !== false && typeof back.regrab === "function")
                back.regrab();
        }
    }
    function escArmed(): bool {
        return true;
    }
    function quitArmed(): bool {
        return true;
    }
    function quitAction(): void {
        base.close();
    }
    function cancelOrClose(): void {
        base.close();
    }
    function stepListView(view, dir: int, stride: int): void {
        if (!view || view.count === 0)
            return;
        view.currentIndex = Services.Theme.clamp(view.currentIndex + dir * (stride ?? 1), 0, view.count - 1);
        view.positionViewAtIndex(view.currentIndex, ListView.Contain);
    }
    function clampListView(view): void {
        if (!view)
            return;
        if (view.currentIndex >= view.count)
            view.currentIndex = Math.max(0, view.count - 1);
    }
    function selectInList(view, i: int): void {
        if (!view)
            return;
        view.currentIndex = Services.Theme.clamp(i, 0, Math.max(0, view.count - 1));
        view.positionViewAtIndex(view.currentIndex, ListView.Contain);
    }
    Shortcut {
        sequence: "Escape"
        enabled: base.visible && base.escArmed()
        onActivated: base.cancelOrClose()
    }
    Shortcut {
        sequence: "q"
        enabled: base.visible && base.quitArmed()
        onActivated: base.quitAction()
    }
    anchor.window: bar
    readonly property var anchorWin: base.anchor.window ?? bar
    readonly property real anchorWidth: anchorWin && anchorWin.width ? anchorWin.width : (bar && bar.width ? bar.width : 0)
    readonly property real anchorScreenHeight: anchorWin && anchorWin.screen && anchorWin.screen.height ? anchorWin.screen.height : (bar && bar.screen && bar.screen.height ? bar.screen.height : 0)
    readonly property real availableWidth: Math.max(1, base.anchorWidth - 2 * Services.Theme.popupMargin)
    readonly property real availableHeight: Math.max(1, base.anchorScreenHeight - (base.attachToBar ? base.attachedTop + Services.Theme.popupMargin : 2 * Services.Theme.popupMargin))
    readonly property string anchorScreenName: anchorWin && anchorWin.screen && anchorWin.screen.name ? anchorWin.screen.name : (bar && bar.screen && bar.screen.name ? bar.screen.name : "")
    readonly property bool anchorFullscreen: Services.Bars.isAnyFullscreen(base.anchorScreenName)
    readonly property real attachedTop: (base.anchorFullscreen ? 0 : Services.Theme.barHeight) + Services.Theme.popupBarGap + base.extraTop
    readonly property real centeredTop: Math.max(Services.Theme.popupMargin, (base.anchorScreenHeight - base.height) / 2)
    anchor.rect.x: base.anchorCenterX >= 0 ? Math.max(Services.Theme.popupMargin, Math.min(anchorWidth - width - Services.Theme.popupMargin, base.anchorCenterX - width / 2)) : base.anchorMode === "middle" ? anchorWidth / 2 - width / 2 : anchorWidth - width - Services.Theme.popupMargin
    anchor.rect.y: base.attachToBar ? base.attachedTop : base.centeredTop
    visible: false
    color: Services.Theme.transparent
    BackgroundEffect.blurRegion: Services.Theme.popupBlur ? popupBlurRegion : null
    Region {
        id: popupBlurRegion
        item: popupBackground
        radius: Services.Theme.popupRadius
    }
    Rectangle {
        id: popupBackground
        parent: base.contentItem
        anchors.fill: parent
        z: -1
        radius: Services.Theme.popupRadius
        color: Services.Theme.popupBg
        border.color: Services.Theme.border
    }
    function startOpenTransition(): void {
        if (base.visible)
            openTransition.restart();
    }
    ParallelAnimation {
        id: openTransition
        NumberAnimation {
            target: base.contentItem
            property: "opacity"
            from: 0
            to: 1
            duration: Services.Theme.motionDuration
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: base.contentItem
            property: "scale"
            from: 0.985
            to: 1
            duration: Services.Theme.motionDuration
            easing.type: Easing.OutCubic
        }
    }
    onPickerActiveChanged: {
        if (!base.pickerActive && base.visible && base.useGrab)
            base.kickGrab();
    }
    onVisibleChanged: {
        if (!base.visible) {
            openTransition.stop();
            grab.active = false;
            grabTimer.stop();
            focusRetry.stop();
        } else {
            base.contentItem.transformOrigin = base.attachToBar ? Item.Top : Item.Center;
            base.contentItem.opacity = 0;
            base.contentItem.scale = 0.985;
            Qt.callLater(base.startOpenTransition);
            base.openedAt = Date.now();
            base.kickGrab();
            base.focusTargetNow();
        }
    }
    HyprlandFocusGrab {
        id: grab
        windows: base.effectiveGrabWindows
        onActiveChanged: {
            if (grab.active && base.visible) {
                base.focusAttempts = 0;
                base.focusTargetNow();
                if (base.focusTarget && !base.focusTarget.activeFocus)
                    focusRetry.restart();
            } else {
                focusRetry.stop();
            }
        }
        onCleared: {
            if (grab.active)
                return;
            if (!base.visible)
                return;
            if (base.pickerActive)
                return;
            if (base.preventClose) {
                base.regrab();
                return;
            }
            if (Date.now() - base.openedAt < 250) {
                base.regrab();
                return;
            }
            base.close();
        }
    }
    property int focusAttempts: 0
    Timer {
        id: focusRetry
        interval: 50
        running: false
        repeat: false
        onTriggered: {
            if (!base.visible || !grab.active || !base.focusTarget) {
                base.focusAttempts = 0;
                return;
            }
            if (base.focusTarget.activeFocus) {
                base.focusAttempts = 0;
                return;
            }
            if (base.focusAttempts >= 5) {
                base.focusAttempts = 0;
                return;
            }
            base.focusAttempts += 1;
            base.focusTargetNow();
            focusRetry.restart();
        }
    }
    Timer {
        id: grabTimer
        interval: Services.Theme.grabDelay
        running: false
        repeat: false
        onTriggered: grab.active = true
    }
    Timer {
        id: busyKeep
        interval: 200
        repeat: true
        running: base.preventClose && base.visible && !base.pickerActive
        onTriggered: base.regrab()
    }
    Timer {
        id: busySettle
        interval: base.busyMs
        repeat: false
        onTriggered: {
            base.preventClose = false;
            if (base.visible && !base.pickerActive)
                base.regrab();
        }
    }
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged(): void {
            if (base.pickerActive)
                return;
            if (base.visible && base.useGrab) {
                grab.active = false;
                base.kickGrab();
            }
        }
    }
    Connections {
        target: base
        function onWindowConnected(): void {
            if (base.pickerActive)
                return;
            if (base.visible && base.useGrab)
                base.kickGrab();
        }
    }
}
