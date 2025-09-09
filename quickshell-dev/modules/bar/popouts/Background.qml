import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root

    required property Wrapper wrapper
    readonly property real rounding: Config.border.rounding

    property bool isLeftBorder: wrapper.x <= 0
    property bool isTopBorder: wrapper.y <= 0
    property bool isRightBorder: wrapper.x + wrapper.width + rounding >= parent.width
    property bool isBottomBorder: wrapper.y + wrapper.height + 1 >= parent.height

    property bool invertTopLeft: (isLeftBorder && isTopBorder) || (!isLeftBorder && !isTopBorder)
    property real topLeftFactor: invertTopLeft ? -1 : 1

    property bool invertBottomLeft: isLeftBorder && !isBottomBorder
    property real bottomLeftFactor: invertBottomLeft ? -1 : 1

    property bool invertBottomRight: isRightBorder && !isBottomBorder
    property real bottomRightFactor: invertBottomRight ? 1 : -1

    property bool invertTopRight: (isRightBorder && isTopBorder) || (!isRightBorder && !isTopBorder)
    property real topRightFactor: invertTopRight ? -1 : 1

    strokeWidth: -1
    fillColor: Colours.palette.m3surface

    // Top Left
    PathArc {
        relativeX: rounding * topLeftFactor
        relativeY: rounding
        radiusX: rounding
        radiusY: rounding
        direction: invertTopLeft ? PathArc.Counterclockwise : PathArc.Clockwise
    }

    PathLine {
        relativeX: 0
        relativeY: root.wrapper.height - (invertBottomLeft ? 0 : rounding * 2) // - rounding * 2
    }

    // Bottom Left
    PathArc {
        relativeX: rounding
        relativeY: rounding * bottomLeftFactor
        radiusX: rounding
        radiusY: rounding
        direction: invertBottomLeft ? PathArc.Clockwise : PathArc.Counterclockwise
    }

    PathLine {
        relativeX: root.wrapper.width - rounding * 2
        relativeY: 0
    }

    // Bottom Right
    PathArc {
        relativeX: rounding
        relativeY: rounding * bottomRightFactor
        radiusX: rounding
        radiusY: rounding
        direction: invertBottomRight ? PathArc.Clockwise : PathArc.Counterclockwise
    }

    PathLine {
        relativeX: 0
        relativeY: -root.wrapper.height + (invertBottomRight ? -1 : rounding * 2) 
    }

    // Top Right
    PathArc {
        relativeX: rounding * topRightFactor
        relativeY: -rounding
        radiusX: rounding
        radiusY: rounding
        direction: invertTopRight ? PathArc.Counterclockwise : PathArc.Clockwise
    }

    Behavior on fillColor {
        CAnim {}
    }
}
