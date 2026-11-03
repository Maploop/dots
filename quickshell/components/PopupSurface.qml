import QtQuick
import QtQuick.Shapes
import "../services" as Services

Item {
    id: root
    property real connectionRadius: 0
    readonly property real shoulder: Math.max(0, Math.min(root.connectionRadius, width / 4, height / 2))
    readonly property real corner: Math.max(0, Math.min(Services.Theme.popupRadius, (width - 2 * shoulder) / 2, height / 2))
    // The top edge joins the bar. Only the exposed sides receive a border.
    readonly property string outline: {
        const r = root.shoulder;
        const b = root.corner;
        const right = width - r - 0.5;
        const left = r + 0.5;
        const bottom = Math.max(r, height - 0.5);
        return "M " + (width - 0.5) + " 0"
            + " A " + r + " " + r + " 0 0 0 " + right + " " + r
            + " L " + right + " " + (bottom - b)
            + " Q " + right + " " + bottom + " " + (right - b) + " " + bottom
            + " L " + (left + b) + " " + bottom
            + " Q " + left + " " + bottom + " " + left + " " + (bottom - b)
            + " L " + left + " " + r
            + " A " + r + " " + r + " 0 0 0 0.5 0";
    }

    Rectangle {
        anchors.fill: parent
        visible: root.shoulder === 0
        radius: Services.Theme.popupRadius
        color: Services.Theme.popupBg
        border.color: Services.Theme.border
    }
    Shape {
        anchors.fill: parent
        visible: root.shoulder > 0
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeWidth: -1
            fillColor: Services.Theme.popupBg
            PathSvg { path: root.outline + " Z" }
        }
        ShapePath {
            strokeWidth: 1
            strokeColor: Services.Theme.border
            fillColor: "transparent"
            PathSvg { path: root.outline }
        }
    }
}
