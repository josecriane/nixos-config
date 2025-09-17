import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.ds.animations

ShapePath {
    id: root

    readonly property bool flatten: wrapper.height < rounding * 2
    property real fullHeightRounding: wrapper.height >= QsWindow.window?.height - Config.border.thickness * 2 ? -rounding : rounding
    readonly property real rounding: Config.border.rounding
    readonly property real roundingY: flatten ? wrapper.height / 2 : rounding
    required property Wrapper wrapper

    fillColor: Colours.palette.m3surface
    strokeWidth: -1

    Behavior on fillColor {
        BasicColorAnimation {
        }
    }
    Behavior on fullHeightRounding {
        BasicNumberAnimation {
        }
    }

    PathLine {
        relativeX: -(root.wrapper.width + root.rounding)
        relativeY: 0
    }
    PathArc {
        radiusX: root.rounding
        radiusY: Math.min(root.rounding, root.wrapper.height)
        relativeX: root.rounding
        relativeY: root.roundingY
    }
    PathLine {
        relativeX: 0
        relativeY: root.wrapper.height - root.roundingY * 2
    }
    PathArc {
        direction: root.fullHeightRounding < 0 ? PathArc.Clockwise : PathArc.Counterclockwise
        radiusX: Math.abs(root.fullHeightRounding)
        radiusY: Math.min(root.rounding, root.wrapper.height)
        relativeX: root.fullHeightRounding
        relativeY: root.roundingY
    }
    PathLine {
        relativeX: root.wrapper.height > 0 ? root.wrapper.width - root.rounding - root.fullHeightRounding : root.wrapper.width
        relativeY: 0
    }
    PathArc {
        radiusX: root.rounding
        radiusY: root.rounding
        relativeX: root.rounding
        relativeY: root.rounding
    }
}
