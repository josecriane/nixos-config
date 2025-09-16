import qs.services
import qs.config
import QtQuick
import QtQuick.Shapes
import qs.ds.animations
import qs.ds

Shape {
    id: root

    property real value
    property int startAngle: 0
    property int strokeWidth: Foundations.spacing.xs
    property color fgColour: Colours.palette.m3primary
    property color bgColour: "transparent"

    readonly property real size: Math.min(width, height)
    readonly property real arcRadius: (size - padding - strokeWidth) / 2
    readonly property real vValue: value || 1 / 360

    preferredRendererType: Shape.CurveRenderer
    asynchronous: true

    ShapePath {
        fillColor: "transparent"
        strokeColor: root.fgColour
        strokeWidth: root.strokeWidth
        capStyle: ShapePath.RoundCap

        CenterPathAngleArc {
            startAngle: root.startAngle
            sweepAngle: 360 * root.vValue
        }

        Behavior on strokeColor {
            BasicColorAnimation {}
        }
    }

    component CenterPathAngleArc: PathAngleArc {
        radiusX: root.arcRadius
        radiusY: root.arcRadius
        centerX: root.size / 2
        centerY: root.size / 2
    }
}
