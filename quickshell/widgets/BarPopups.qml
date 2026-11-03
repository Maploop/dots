import QtQuick
import Quickshell
import "../popups"
import "../services" as Services

Item {
    id: root
    required property var bar
    required property var clock

    readonly property var bodyPanel: controlPanelPopup.body
    readonly property alias controlPanel: controlPanelPopup

    property bool settingsRequested: false
    property bool launcherRequested: false
    property bool clipboardRequested: false
    property bool emojiRequested: false
    property bool trayRequested: false
    property bool mediaRequested: false
    property string pendingOpen: ""
    property var pendingReturnTo: null
    property var coveredPopups: []
    readonly property var screenshotTool: root.bar?.screenshotTool ?? null
    readonly property bool pickerActive: (root.screenshotTool?.pickerActive) === true
    readonly property bool pickerCovered: (root.screenshotTool?.pickerCovered) === true
    onPickerCoveredChanged: {
        if (root.pickerCovered)
            root.parkForCover();
    }
    onPickerActiveChanged: {
        if (!root.pickerActive)
            root.restoreAfterCover();
    }
    function parkForCover(): void {
        const vis = [];
        for (const p of root.exclusivePopups) {
            if (p && p.visible) {
                vis.push(p);
                p.visible = false;
            }
        }
        root.coveredPopups = vis;
    }
    function restoreAfterCover(): void {
        const vis = root.coveredPopups ?? [];
        root.coveredPopups = [];
        if (vis.length > 0) {
            const anchor = root.bar.currentPopupAnchor();
            for (const p of vis) {
                if (!p || p.visible)
                    continue;
                if (p.anchor && anchor)
                    p.anchor.window = anchor;
                p.visible = true;
            }
        }
        root.flushPending();
    }

    readonly property var settingsPopup: settingsLoader.item
    readonly property var launcherPopup: launcherLoader.item
    readonly property var clipboardPopup: clipboardLoader.item
    readonly property var emojiPopup: emojiLoader.item
    readonly property var trayPopup: trayLoader.item
    readonly property var mediaPopup: mediaLoader.item

    readonly property var allPopups: root.exclusivePopups
    readonly property var attachedPopup: root.allPopups.find(p => p && p.visible && p.joinsBar && p.connectionRadius > 0) ?? null
    onAttachedPopupChanged: Services.Bars.attachedPopup = root.attachedPopup
    Component.onDestruction: {
        if (Services.Bars.attachedPopup === root.attachedPopup)
            Services.Bars.attachedPopup = null;
    }
    readonly property var exclusivePopups: [controlPanelPopup, wifiPopup, bluetoothPopup, powerPopup, root.settingsPopup, root.launcherPopup, root.clipboardPopup, root.emojiPopup, root.trayPopup, root.mediaPopup]
    readonly property var rightPopups: root.allPopups.filter(p => p && p.anchorMode === "right")

    property int rightPopupBottom: {
        let bottom = 0;
        for (const p of root.rightPopups) {
            // Notification offsets are measured from the bottom of the bar.
            if (p && p.visible && p.height > 0)
                bottom = Math.max(bottom, p.anchor.rect.y + p.height - (p.anchorFullscreen ? 0 : Services.Theme.barHeight));
        }
        return bottom;
    }
    property int rightPopupWidth: {
        let w = 0;
        for (const p of root.rightPopups) {
            if (p && p.visible)
                w = Math.max(w, p.width);
        }
        return w > 0 ? w : Services.Theme.popupWidth;
    }

    function popupByName(name: string): var {
        switch (name) {
        case "control": return controlPanelPopup;
        case "wifi": return wifiPopup;
        case "bluetooth": return bluetoothPopup;
        case "power": return powerPopup;
        case "settings": return root.settingsPopup;
        case "launcher": return root.launcherPopup;
        case "clipboard": return root.clipboardPopup;
        case "emoji": return root.emojiPopup;
        case "tray": return root.trayPopup;
        case "media": return root.mediaPopup;
        default: return null;
        }
    }
    function ensurePopup(name: string): var {
        if (name === "settings")
            root.settingsRequested = true;
        else if (name === "launcher")
            root.launcherRequested = true;
        else if (name === "clipboard")
            root.clipboardRequested = true;
        else if (name === "emoji")
            root.emojiRequested = true;
        else if (name === "tray")
            root.trayRequested = true;
        else if (name === "media")
            root.mediaRequested = true;
        return root.popupByName(name);
    }
    function flushPending(): void {
        if (root.pendingOpen === "")
            return;
        if (root.pickerActive)
            return;
        const target = root.popupByName(root.pendingOpen);
        if (!target)
            return;
        const back = root.pendingReturnTo;
        root.pendingOpen = "";
        root.pendingReturnTo = null;
        root.openExclusive(target, back);
    }
    function closePopups(): void {
        for (const p of root.exclusivePopups) {
            if (p)
                p.visible = false;
        }
        if (root.pickerCovered)
            root.coveredPopups = (root.coveredPopups ?? []).filter(p => p && p.visible);
    }
    function closeForPicker(name: string, returnTo = null): void {
        const current = root.popupByName(name);
        if (current && current.visible)
            root.openExclusive(current, returnTo);
    }
    function togglePopup(name: string): void {
        if (root.pickerActive) {
            root.closeForPicker(name);
            return;
        }
        if (name === "media" && !Services.Media.spotifyAvailable)
            return;
        const target = root.ensurePopup(name);
        if (target) {
            root.pendingOpen = "";
            root.pendingReturnTo = null;
            root.openExclusive(target);
        } else {
            root.pendingOpen = name;
            root.pendingReturnTo = null;
        }
    }
    function openFromPanel(name: string): void {
        if (root.pickerActive) {
            root.closeForPicker(name, controlPanelPopup);
            return;
        }
        if (name === "media" && !Services.Media.spotifyAvailable)
            return;
        const target = root.ensurePopup(name);
        if (target) {
            root.pendingOpen = "";
            root.pendingReturnTo = null;
            root.openExclusive(target, controlPanelPopup);
        } else {
            root.pendingOpen = name;
            root.pendingReturnTo = controlPanelPopup;
        }
    }
    function openExclusive(target, returnTo = null): void {
        if (!target)
            return;
        if (target === root.mediaPopup && !Services.Media.spotifyAvailable)
            return;
        const open = !target.visible;
        if (open && root.pickerActive)
            return;
        root.closePopups();
        if (open) {
            if (returnTo && returnTo.anchor && returnTo.anchor.window)
                target.anchor.window = returnTo.anchor.window;
            else
                target.anchor.window = root.bar.currentPopupAnchor();
        }
        target.returnTo = open ? returnTo : null;
        target.visible = open;
        if (open && target.useGrab !== false && typeof target.regrab === "function")
            target.regrab();
    }
    function followPopupAnchor(anchor): void {
        const pickerOpen = root.pickerActive;
        for (const p of root.allPopups) {
            if (!p || !p.anchor || p.anchor.window === anchor)
                continue;
            if (!p.visible) {
                p.anchor.window = anchor;
                continue;
            }
            if (pickerOpen) {
                p.anchor.window = anchor;
                continue;
            }
            p.visible = false;
            p.anchor.window = anchor;
            p.visible = true;
            if (typeof p.regrab === "function")
                p.regrab();
        }
    }
    function revealHistory(i: int): void {
        root.bodyPanel.revealAt(i);
    }

    ControlPanelPopup {
        id: controlPanelPopup
        bar: root.bar
        clock: root.clock
    }
    WifiPopup {
        id: wifiPopup
        bar: root.bar
    }
    BluetoothPopup {
        id: bluetoothPopup
        bar: root.bar
    }
    PowerPopup {
        id: powerPopup
        bar: root.bar
    }
    LazyLoader {
        id: mediaLoader
        active: root.mediaRequested
        component: Component {
            MediaPopup {
                bar: root.bar
            }
        }
        onItemChanged: root.flushPending()
    }
    LazyLoader {
        id: trayLoader
        active: root.trayRequested
        component: Component {
            TrayPopup {
                bar: root.bar
            }
        }
        onItemChanged: root.flushPending()
    }
    LazyLoader {
        id: settingsLoader
        active: root.settingsRequested
        component: Component {
            SettingsPopup {
                bar: root.bar
            }
        }
        onItemChanged: root.flushPending()
    }
    LazyLoader {
        id: launcherLoader
        active: root.launcherRequested
        component: Component {
            LauncherPopup {
                bar: root.bar
            }
        }
        onItemChanged: root.flushPending()
    }
    LazyLoader {
        id: clipboardLoader
        active: root.clipboardRequested
        component: Component {
            ClipboardPopup {
                bar: root.bar
            }
        }
        onItemChanged: root.flushPending()
    }
    LazyLoader {
        id: emojiLoader
        active: root.emojiRequested
        component: Component {
            EmojiPopup {
                bar: root.bar
            }
        }
        onItemChanged: root.flushPending()
    }
}
