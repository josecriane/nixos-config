import qs.services
import QtQuick
import QtQuick.Shapes
import qs.ds.animations
import qs.ds

Shape {
    id: root

    readonly property real arcRadius: (size - padding - strokeWidth) / 2
    property color bgColour: "transparent"
    property color fgColour: Foundations.palette.base05
    readonly property real size: Math.min(width, height)
    property int startAngle: 0
    property int strokeWidth: Foundations.spacing.xs
    readonly property real vValue: value || 1 / 360
    property real value

    asynchronous: true
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        capStyle: ShapePath.RoundCap
        fillColor: "transparent"
        strokeColor: root.fgColour
        strokeWidth: root.strokeWidth

        Behavior on strokeColor {
            BasicColorAnimation {
            }
        }

        CenterPathAngleArc {
            startAngle: root.startAngle
            sweepAngle: 360 * root.vValue
        }
    }

    component CenterPathAngleArc: PathAngleArc {
        centerX: root.size / 2
        centerY: root.size / 2
        radiusX: root.arcRadius
        radiusY: root.arcRadius
    }
}
