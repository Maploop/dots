pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Static values are the fallback used when wallpaper theming is disabled,
    // unavailable, or pointed at an invalid image.
    readonly property string staticBarBg: "#D9141415"
    readonly property string staticBg: "#141415"
    readonly property string staticSurface: "#1c1c24"
    readonly property string staticHoverBg: "#252530"
    readonly property string staticActiveBg: "#252530"
    readonly property string staticBorder: "#26CDCDCD"
    readonly property string staticFg: "#cdcdcd"
    readonly property string staticDim: "#878787"
    readonly property string staticAccent: "#aeaed1"
    readonly property string staticAccentFg: "#141415"
    readonly property string staticSecondary: "#b7b8d8"
    readonly property string staticTertiary: "#d6b8d8"
    readonly property string staticWarn: "#f3be7c"
    readonly property string staticDanger: "#d8647e"
    readonly property string staticWhite: "#ffffff"

    property string barBg: root.staticBarBg
    property string bg: root.staticBg
    property string surface: root.staticSurface
    property string hoverBg: root.staticHoverBg
    property string activeBg: root.staticActiveBg
    property string border: root.staticBorder
    property string fg: root.staticFg
    property string dim: root.staticDim
    property string accent: root.staticAccent
    property string accentFg: root.staticAccentFg
    property string secondary: root.staticSecondary
    property string tertiary: root.staticTertiary
    property string white: root.staticWhite
    property string transparent: "transparent"

    // Wallpaper palette settings. These are intentionally kept in Theme.qml
    // so changing either value immediately affects the complete shell.
    readonly property var wallpaperPaletteModes: [
        "m3-tonal-spot",
        "m3-content",
        "m3-fruit-salad",
        "m3-rainbow",
        "m3-monochrome"
    ]
    property bool wallpaperPaletteEnabled: true // Set false to keep the static colors above.
    property string wallpaperPaletteMode: "m3-tonal-spot" // One of wallpaperPaletteModes.
    property bool wallpaperPaletteReady: false
    property string wallpaperPaletteSource: ""
    property string wallpaperPaletteError: ""
    property var wallpaperPalette: ({})
    readonly property var palette: root.wallpaperPalette
    // The media popup uses this separate request so album art cannot race a
    // wallpaper palette refresh.
    property color artworkAccent: root.accent
    property bool artworkAccentReady: false
    property string artworkAccentSource: ""
    property string artworkAccentError: ""
    property var artworkAccentCache: ({})
    property int artworkAccentCacheLimit: 24
    property int _paletteRequestToken: 0
    property string _paletteRequestedPath: ""
    property string _paletteRequestedSource: ""
    property bool _paletteRestartQueued: false
    property real popupOpacity: 0.85
    property bool popupBlur: true
    readonly property color popupBg: root.withAlpha(root.bg, root.popupOpacity)
    readonly property color popupSurface: root.withAlpha(root.surface, 0.26)
    readonly property color popupHoverBg: root.withAlpha(root.hoverBg, 0.5)
    readonly property color popupActiveBg: root.withAlpha(root.activeBg, 0.6)
    // Corners stay square unless a radius is explicitly enabled here.
    property int popupRadius: 12
    // Curves only where attached popups meet the bar; 0 disables them.
    property int popupConnectionRadius: 0
    property int popupSlideDistance: 8
    // "current" keeps the subtle fade; "slide-from-top" drops down from the bar.
    // The launcher always keeps its current animation.
    readonly property var popupAnimationStyles: ["current", "slide-from-top"]
    property string popupAnimationStyle: "current"
    property int controlRadius: 0
    property int indicatorRadius: 0
    property int motionDuration: 160
    property int hoverDuration: 100
    property string warn: root.staticWarn
    property string danger: root.staticDanger
    property string font: "JetbrainsMono Nerd Font"

    property int px10: 10
    property int px11: 11
    property int px12: 12
    property int px13: 13
    property int px14: 14

    property int popupWidth: 340
    property int controlCenterWidth: 400
    property int trayPopupWidth: 300
    property int mediaPopupWidth: 420
    property int settingsWidth: 400
    property int wallpaperSelectorWidth: 760
    property int launcherWidth: 480
    property bool launcherAttachedToBar: false
    property bool launcherShowIcons: true
    property int barMargin: 6
    property int popupMargin: 6
    property int popupTopGap: 6
    property int popupBarGap: 8 // Space between the bar and its popups.
    property int popupPadding: 8
    property int popupSpacing: 8
    property int rowHeight: 36
    property int listRowHeight: 40
    property int toastWidth: 300
    property int osdWidth: 150
    property int osdBottomMargin: 20
    property int barHeight: 34
    property bool workspacesOnLeft: true
    property bool powerShowShortcuts: true
    property int groupSpacing: 16
    property int tightSpacing: 8
    property int barIconPadding: 0
    property int listSpacing: 4
    property int traySize: 14
    property int titleMax: 420
    property int titleMargin: 10
    property int listVisible: 7
    property int resultMax: 40
    property int tileHeight: 40

    property int grabDelay: 100
    property int focusDelay: root.grabDelay + 50
    property int refilterDelay: 90
    property int scanTimeout: 15000
    property int toastTimeout: 5000
    property int osdTimeout: 1500
    property int lowToastTimeout: 3000
    property int criticalToastTimeout: 30000
    property int toastMax: 5
    property int historyMax: 20
    property int toastBodyMaxLines: 3
    property int historyBodyMaxLines: 4

    property real volumeMax: 1.5
    property real volumeStep: 0.02
    property int brightnessStep: 5
    property int brightnessMin: 0

    property real sigHigh: 0.75
    property real sigMed: 0.5
    property real sigLow: 0.25

    onWallpaperPaletteEnabledChanged: root.refreshFromWallpaper(root.wallpaperPaletteSource)
    onWallpaperPaletteModeChanged: {
        root.refreshFromWallpaper(root.wallpaperPaletteSource);
        if (root.artworkAccentSource !== "")
            root.refreshArtworkAccent(root.artworkAccentSource);
    }

    function withAlpha(value: color, alpha: real): color {
        return Qt.rgba(value.r, value.g, value.b, alpha);
    }
    function clamp(x, a, b): real {
        return Math.max(a, Math.min(b, x));
    }
    function clamp01(x): real {
        return Math.max(0, Math.min(1, x));
    }

    function _normalizeHue(value): real {
        let hue = Number(value) % 360;
        if (isNaN(hue))
            hue = 0;
        return hue < 0 ? hue + 360 : hue;
    }

    function _byte(value): int {
        return Math.round(clamp01(value) * 255);
    }

    function _hexByte(value): string {
        const result = _byte(value).toString(16).toUpperCase();
        return result.length === 1 ? "0" + result : result;
    }

    function _rgbHex(rgb): string {
        return "#" + _hexByte(rgb.r) + _hexByte(rgb.g) + _hexByte(rgb.b);
    }

    function _rgbaHex(rgb, alpha): string {
        return "#" + _hexByte(alpha) + _hexByte(rgb.r) + _hexByte(rgb.g) + _hexByte(rgb.b);
    }

    function _hueToRgb(p, q, t): real {
        let value = t;
        if (value < 0)
            value += 1;
        if (value > 1)
            value -= 1;
        if (value < 1 / 6)
            return p + (q - p) * 6 * value;
        if (value < 1 / 2)
            return q;
        if (value < 2 / 3)
            return p + (q - p) * (2 / 3 - value) * 6;
        return p;
    }

    function _hslToRgb(hue, saturation, lightness): var {
        const h = _normalizeHue(hue) / 360;
        const s = clamp01(saturation);
        const l = clamp01(lightness);
        if (s === 0)
            return {r: l, g: l, b: l};
        const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        const p = 2 * l - q;
        return {
            r: _hueToRgb(p, q, h + 1 / 3),
            g: _hueToRgb(p, q, h),
            b: _hueToRgb(p, q, h - 1 / 3)
        };
    }

    function _rgbToHsl(r, g, b): var {
        const max = Math.max(r, g, b);
        const min = Math.min(r, g, b);
        const lightness = (max + min) / 2;
        const delta = max - min;
        if (delta === 0)
            return {h: 0, s: 0, l: lightness};
        const saturation = lightness > 0.5 ? delta / (2 - max - min) : delta / (max + min);
        let hue;
        if (max === r)
            hue = (g - b) / delta + (g < b ? 6 : 0);
        else if (max === g)
            hue = (b - r) / delta + 2;
        else
            hue = (r - g) / delta + 4;
        return {h: hue * 60, s: saturation, l: lightness};
    }

    function _parseSample(value): var {
        const text = String(value ?? "").trim();
        // ImageMagick's histogram is sorted by color value, so select the
        // most frequent quantized color before building the tonal palette.
        let candidate = text;
        let bestCount = -1;
        let bestHex = "";
        const lines = text.split("\n");
        for (let i = 0; i < lines.length; i++) {
            const countMatch = lines[i].match(/^\s*(\d+):/);
            const lineHexMatch = lines[i].match(/#([0-9a-fA-F]{6,8})/);
            if (!countMatch || !lineHexMatch)
                continue;
            const count = parseInt(countMatch[1]);
            if (!isNaN(count) && count > bestCount) {
                bestCount = count;
                bestHex = lineHexMatch[1];
            }
        }
        if (bestHex !== "")
            candidate = bestHex;
        const hexMatch = candidate.match(/#([0-9a-fA-F]{6,8})/);
        const rawHexMatch = candidate.match(/^([0-9a-fA-F]{6,8})$/);
        if (hexMatch || rawHexMatch) {
            let hex = hexMatch ? hexMatch[1] : rawHexMatch[1];
            if (hex.length === 8)
                hex = hex.slice(2);
            if (hex.length === 6) {
                return {
                    r: parseInt(hex.slice(0, 2), 16) / 255,
                    g: parseInt(hex.slice(2, 4), 16) / 255,
                    b: parseInt(hex.slice(4, 6), 16) / 255
                };
            }
        }
        const rgbMatch = candidate.match(/srgb\(\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,\s*([0-9.]+)/i);
        if (rgbMatch) {
            return {
                r: clamp01(parseFloat(rgbMatch[1]) / 255),
                g: clamp01(parseFloat(rgbMatch[2]) / 255),
                b: clamp01(parseFloat(rgbMatch[3]) / 255)
            };
        }
        return null;
    }

    function _wallpaperPath(source): string {
        let value = String(source ?? "").trim();
        if (value.startsWith("file://")) {
            value = value.slice(7);
            if (value.startsWith("localhost/"))
                value = value.slice(9);
            try {
                value = decodeURIComponent(value);
            } catch (_) {
                return "";
            }
        }
        return value.startsWith("/") ? value : "";
    }

    function _imageSource(source): string {
        let value = String(source ?? "").trim();
        if (value.startsWith("file://")) {
            value = value.slice(7);
            if (value.startsWith("localhost/"))
                value = value.slice(9);
            try {
                value = decodeURIComponent(value);
            } catch (_) {
                return "";
            }
        }
        if (value.startsWith("/") || value.startsWith("http://") || value.startsWith("https://"))
            return value;
        return "";
    }

    function _modeProfile(mode, sourceHsl): var {
        let hue = sourceHsl.h;
        let saturation = sourceHsl.s;
        if (mode === "m3-tonal-spot") {
            saturation = clamp(Math.max(saturation * 0.55, 0.18), 0.18, 0.48);
        } else if (mode === "m3-content") {
            saturation = clamp(Math.max(saturation * 0.95, 0.24), 0.24, 0.9);
        } else if (mode === "m3-fruit-salad") {
            hue = _normalizeHue(hue + 34);
            saturation = clamp(Math.max(saturation * 0.82, 0.42), 0.42, 0.86);
        } else if (mode === "m3-rainbow") {
            saturation = clamp(Math.max(saturation * 1.15, 0.5), 0.5, 0.95);
        } else if (mode === "m3-monochrome") {
            saturation = 0;
        }
        return {
            hue: hue,
            saturation: saturation,
            neutralSaturation: mode === "m3-monochrome" ? 0 : clamp(saturation * 0.16, 0.02, 0.11),
            mode: mode
        };
    }

    function _applyWallpaperPalette(rgb, source, mode): void {
        const sourceHsl = _rgbToHsl(rgb.r, rgb.g, rgb.b);
        const profile = _modeProfile(mode, sourceHsl);
        const hue = profile.hue;
        const saturation = profile.saturation;
        const neutral = profile.neutralSaturation;
        const primaryRgb = _hslToRgb(hue, saturation, 0.74);
        const secondaryRgb = _hslToRgb(hue + (mode === "m3-rainbow" ? 120 : 60), clamp(saturation * 0.7, 0.18, 0.72), 0.7);
        const tertiaryRgb = _hslToRgb(hue + (mode === "m3-rainbow" ? 240 : 180), clamp(saturation * 0.62, 0.15, 0.64), 0.72);
        const primaryContainerRgb = _hslToRgb(hue, clamp(saturation * 0.8, 0.12, 0.72), 0.28);
        const secondaryContainerRgb = _hslToRgb(hue + (mode === "m3-rainbow" ? 120 : 60), clamp(saturation * 0.5, 0.1, 0.48), 0.26);
        const tertiaryContainerRgb = _hslToRgb(hue + (mode === "m3-rainbow" ? 240 : 180), clamp(saturation * 0.46, 0.08, 0.42), 0.3);
        const backgroundRgb = _hslToRgb(hue, neutral, 0.065);
        const surfaceRgb = _hslToRgb(hue, neutral, 0.105);
        const surfaceVariantRgb = _hslToRgb(hue, clamp(neutral * 2, 0.03, 0.2), 0.22);
        const hoverRgb = _hslToRgb(hue, clamp(neutral * 1.5, 0.03, 0.16), 0.155);
        const activeRgb = _hslToRgb(hue, clamp(neutral * 1.8, 0.04, 0.2), 0.205);
        const foregroundRgb = _hslToRgb(hue, clamp(neutral * 0.8, 0.01, 0.08), 0.9);
        const dimRgb = _hslToRgb(hue, clamp(neutral * 0.9, 0.01, 0.09), 0.66);
        const outlineRgb = _hslToRgb(hue, clamp(neutral * 1.4, 0.02, 0.16), 0.57);
        const accentForegroundRgb = _hslToRgb(hue, clamp(saturation * 0.25, 0, 0.3), 0.16);
        const warningRgb = _hslToRgb(42, 0.65, 0.75);
        const errorRgb = _hslToRgb(5, 0.64, 0.72);
        const errorForegroundRgb = _hslToRgb(5, 0.34, 0.18);

        root.barBg = _rgbaHex(backgroundRgb, 0.85);
        root.bg = _rgbHex(backgroundRgb);
        root.surface = _rgbHex(surfaceRgb);
        root.hoverBg = _rgbHex(hoverRgb);
        root.activeBg = _rgbHex(activeRgb);
        root.border = _rgbaHex(foregroundRgb, 0.16);
        root.fg = _rgbHex(foregroundRgb);
        root.dim = _rgbHex(dimRgb);
        root.accent = _rgbHex(primaryRgb);
        root.accentFg = _rgbHex(accentForegroundRgb);
        root.secondary = _rgbHex(secondaryRgb);
        root.tertiary = _rgbHex(tertiaryRgb);
        root.warn = _rgbHex(warningRgb);
        root.danger = _rgbHex(errorRgb);
        root.wallpaperPalette = ({
            source: source,
            mode: mode,
            seed: _rgbHex(rgb),
            primary: root.accent,
            onPrimary: _rgbHex(accentForegroundRgb),
            primaryContainer: _rgbHex(primaryContainerRgb),
            onPrimaryContainer: _rgbHex(foregroundRgb),
            secondary: root.secondary,
            onSecondary: _rgbHex(accentForegroundRgb),
            secondaryContainer: _rgbHex(secondaryContainerRgb),
            onSecondaryContainer: _rgbHex(foregroundRgb),
            tertiary: root.tertiary,
            onTertiary: _rgbHex(accentForegroundRgb),
            tertiaryContainer: _rgbHex(tertiaryContainerRgb),
            onTertiaryContainer: _rgbHex(foregroundRgb),
            background: root.bg,
            onBackground: root.fg,
            surface: root.surface,
            onSurface: root.fg,
            surfaceVariant: _rgbHex(surfaceVariantRgb),
            onSurfaceVariant: _rgbHex(dimRgb),
            outline: _rgbHex(outlineRgb),
            error: _rgbHex(errorRgb),
            onError: _rgbHex(errorForegroundRgb),
            foreground: root.fg
        });
        root.wallpaperPaletteReady = true;
        root.wallpaperPaletteError = "";
    }

    function _restoreStaticPalette(): void {
        root.barBg = root.staticBarBg;
        root.bg = root.staticBg;
        root.surface = root.staticSurface;
        root.hoverBg = root.staticHoverBg;
        root.activeBg = root.staticActiveBg;
        root.border = root.staticBorder;
        root.fg = root.staticFg;
        root.dim = root.staticDim;
        root.accent = root.staticAccent;
        root.accentFg = root.staticAccentFg;
        root.secondary = root.staticSecondary;
        root.tertiary = root.staticTertiary;
        root.warn = root.staticWarn;
        root.danger = root.staticDanger;
        root.wallpaperPalette = ({
            source: root.wallpaperPaletteSource,
            mode: "static",
            seed: "",
            primary: root.accent,
            onPrimary: root.accentFg,
            secondary: root.secondary,
            tertiary: root.tertiary,
            background: root.bg,
            onBackground: root.fg,
            surface: root.surface,
            onSurface: root.fg,
            foreground: root.fg
        });
        root.wallpaperPaletteReady = false;
    }

    function _paletteFailed(message): void {
        root._restoreStaticPalette();
        root.wallpaperPaletteError = String(message);
    }

    function _applyArtworkAccent(rgb, source): void {
        const sourceHsl = _rgbToHsl(rgb.r, rgb.g, rgb.b);
        const configuredMode = _artworkAccentMode();
        const profile = _modeProfile(configuredMode, sourceHsl);
        const neutralSeed = sourceHsl.s < 0.04 || configuredMode === "m3-monochrome";
        const saturation = neutralSeed ? 0 : clamp(Math.max(profile.saturation, 0.36), 0.36, 0.9);
        const lightness = sourceHsl.l < 0.42 ? 0.68 : clamp(sourceHsl.l, 0.55, 0.76);
        const accent = _rgbHex(_hslToRgb(profile.hue, saturation, lightness));
        root._rememberArtworkAccent(source, accent);
        if (root.artworkAccentSource !== source)
            return;
        root.artworkAccent = accent;
        root.artworkAccentReady = true;
        root.artworkAccentError = "";
    }

    function _artworkAccentFailed(message): void {
        root.artworkAccent = root.accent;
        root.artworkAccentReady = false;
        root.artworkAccentError = String(message);
    }

    function _artworkAccentMode(): string {
        return root.wallpaperPaletteModes.indexOf(root.wallpaperPaletteMode) >= 0 ? root.wallpaperPaletteMode : "m3-content";
    }

    function _artworkAccentCacheKey(source): string {
        return "artwork:" + _artworkAccentMode() + ":" + String(source ?? "");
    }

    function _cachedArtworkAccent(source): string {
        const value = root.artworkAccentCache[_artworkAccentCacheKey(source)];
        return typeof value === "string" ? value : "";
    }

    function _rememberArtworkAccent(source, accent): void {
        const cache = Object.assign({}, root.artworkAccentCache ?? {});
        const key = _artworkAccentCacheKey(source);
        cache[key] = accent;
        const keys = Object.keys(cache);
        while (keys.length > root.artworkAccentCacheLimit) {
            delete cache[keys.shift()];
        }
        root.artworkAccentCache = cache;
    }

    function _startArtworkAccent(path, token): void {
        artworkAccentProcess.requestToken = token;
        artworkAccentProcess.requestPath = path;
        artworkAccentProcess.outputApplied = false;
        artworkAccentProcess.command = ["magick", path, "-thumbnail", "64x64", "-colorspace", "sRGB", "-colors", "8", "-format", "%c", "histogram:info:-"];
        artworkAccentProcess.running = true;
    }

    function _handleArtworkAccentOutput(value): void {
        if (artworkAccentProcess.requestToken !== root._artworkAccentRequestToken
                || artworkAccentProcess.requestPath !== root._artworkAccentRequestedPath)
            return;
        const rgb = _parseSample(value);
        if (!rgb) {
            _artworkAccentFailed("ImageMagick returned no usable artwork color");
            return;
        }
        artworkAccentProcess.outputApplied = true;
        _applyArtworkAccent(rgb, root._artworkAccentRequestedSource);
    }

    function clearArtworkAccent(): void {
        root._artworkAccentRestartQueued = false;
        root.artworkAccentSource = "";
        root.artworkAccent = root.accent;
        root.artworkAccentReady = false;
        root.artworkAccentError = "";
    }

    function refreshArtworkAccent(source): void {
        const sourceValue = String(source ?? "");
        const path = _imageSource(sourceValue);
        if (path !== "" && sourceValue === root._artworkAccentRequestedSource
                && path === root._artworkAccentRequestedPath && artworkAccentProcess.running) {
            root.artworkAccentSource = sourceValue;
            root.artworkAccentReady = false;
            root.artworkAccentError = "";
            return;
        }
        root.artworkAccentSource = sourceValue;
        root._artworkAccentRequestToken += 1;
        root._artworkAccentRequestedPath = path;
        root._artworkAccentRequestedSource = sourceValue;
        if (path === "") {
            root._artworkAccentRestartQueued = false;
            if (artworkAccentProcess.running)
                artworkAccentProcess.running = false;
            root.artworkAccent = root.accent;
            root.artworkAccentReady = false;
            root.artworkAccentError = "";
            return;
        }

        const cached = root._cachedArtworkAccent(sourceValue);
        if (cached !== "") {
            root._artworkAccentRestartQueued = false;
            if (artworkAccentProcess.running)
                artworkAccentProcess.running = false;
            root.artworkAccent = cached;
            root.artworkAccentReady = true;
            root.artworkAccentError = "";
            return;
        }

        root.artworkAccentReady = false;
        root.artworkAccentError = "";
        if (artworkAccentProcess.running) {
            root._artworkAccentRestartQueued = true;
            artworkAccentProcess.running = false;
            return;
        }
        root._artworkAccentRestartQueued = false;
        root._startArtworkAccent(path, root._artworkAccentRequestToken);
    }

    function _startPalette(path, token): void {
        paletteProcess.requestToken = token;
        paletteProcess.requestPath = path;
        paletteProcess.outputApplied = false;
        paletteProcess.command = ["magick", path, "-thumbnail", "64x64", "-colorspace", "sRGB", "-colors", "8", "-format", "%c", "histogram:info:-"];
        paletteProcess.running = true;
    }

    function _handlePaletteOutput(value): void {
        if (paletteProcess.requestToken !== root._paletteRequestToken
                || paletteProcess.requestPath !== root._paletteRequestedPath)
            return;
        const rgb = _parseSample(value);
        if (!rgb) {
            _paletteFailed("ImageMagick returned no usable wallpaper color");
            return;
        }
        paletteProcess.outputApplied = true;
        _applyWallpaperPalette(rgb, root._paletteRequestedSource, root.wallpaperPaletteMode);
    }

    function refreshFromWallpaper(source): void {
        const sourceValue = String(source ?? "");
        const path = _wallpaperPath(sourceValue);
        root.wallpaperPaletteSource = sourceValue;
        root._paletteRequestToken += 1;
        root._paletteRequestedPath = path;
        root._paletteRequestedSource = sourceValue;

        const mode = root.wallpaperPaletteMode;
        const validMode = root.wallpaperPaletteModes.indexOf(mode) >= 0;
        if (!root.wallpaperPaletteEnabled || !validMode || path === "") {
            root._paletteRestartQueued = false;
            if (paletteProcess.running)
                paletteProcess.running = false;
            root._restoreStaticPalette();
            if (!validMode && mode !== "")
                root.wallpaperPaletteError = "Unsupported wallpaper palette mode: " + mode;
            else
                root.wallpaperPaletteError = "";
            return;
        }

        root.wallpaperPaletteReady = false;
        root.wallpaperPaletteError = "";
        if (paletteProcess.running) {
            root._paletteRestartQueued = true;
            paletteProcess.running = false;
            return;
        }
        root._paletteRestartQueued = false;
        root._startPalette(path, root._paletteRequestToken);
    }
    function listHeight(rows): int {
        return rows * root.rowHeight + Math.max(0, rows - 1) * root.listSpacing;
    }

    Process {
        id: paletteProcess
        property int requestToken: 0
        property string requestPath: ""
        property bool outputApplied: false
        stdout: StdioCollector {
            onStreamFinished: root._handlePaletteOutput(text)
        }
        onExited: exitCode => {
            if (root._paletteRestartQueued) {
                root._paletteRestartQueued = false;
                root._startPalette(root._paletteRequestedPath, root._paletteRequestToken);
                return;
            }
            if (requestToken !== root._paletteRequestToken || requestPath !== root._paletteRequestedPath)
                return;
            if (exitCode !== 0 && !outputApplied)
                root._paletteFailed("Unable to read the wallpaper with ImageMagick");
        }
    }

    property int _artworkAccentRequestToken: 0
    property string _artworkAccentRequestedPath: ""
    property string _artworkAccentRequestedSource: ""
    property bool _artworkAccentRestartQueued: false
    Process {
        id: artworkAccentProcess
        property int requestToken: 0
        property string requestPath: ""
        property bool outputApplied: false
        stdout: StdioCollector {
            onStreamFinished: root._handleArtworkAccentOutput(text)
        }
        onExited: exitCode => {
            if (root._artworkAccentRestartQueued) {
                root._artworkAccentRestartQueued = false;
                root._startArtworkAccent(root._artworkAccentRequestedPath, root._artworkAccentRequestToken);
                return;
            }
            if (requestToken !== root._artworkAccentRequestToken || requestPath !== root._artworkAccentRequestedPath)
                return;
            if (exitCode !== 0 && !outputApplied)
                root._artworkAccentFailed("Unable to read the artwork with ImageMagick");
        }
    }
}
