import "."
import qs.services
import qs.config
import QtQuick
import QtQuick.Shapes
import qs.ds.animations

ShapePath {
    id: root

    enum CornerType {
        NoShape,
        InvertedTopLeft,
        InvertedTopRight,
        InvertedBottomLeft,
        InvertedBottomRight,
        TopLeft,
        TopRight,
        BottomLeft,
        BottomRight
    }

    required property BackgroundWrapper wrapper
    readonly property real rounding: Config.border.rounding

    property bool isLeftBorder: wrapper.x <= 0
    property bool isTopBorder: wrapper.y <= 0
    property bool isRightBorder: wrapper.x + wrapper.width + rounding >= parent.width
    property bool isBottomBorder: wrapper.y + wrapper.height + 1 >= parent.height

    property int topLeftCorner: {
        if (isTopBorder && !isLeftBorder) return Background.CornerType.InvertedTopLeft
        if (!isTopBorder && isLeftBorder) return Background.CornerType.InvertedBottomRight
        if (!isTopBorder && !isLeftBorder) return Background.CornerType.TopLeft
        return Background.CornerType.NoShape
    }

    property int bottomLeftCorner: {
        if (isBottomBorder && !isLeftBorder) return Background.CornerType.InvertedBottomLeft
        if (!isBottomBorder && isLeftBorder) return Background.CornerType.InvertedTopRight
        if (!isBottomBorder && !isLeftBorder) return Background.CornerType.BottomLeft
        return Background.CornerType.NoShape
    }

    property int bottomRightCorner: {
        if (isBottomBorder && !isRightBorder) return Background.CornerType.InvertedBottomRight
        if (!isBottomBorder && isRightBorder) return Background.CornerType.InvertedTopLeft
        if (!isBottomBorder && !isRightBorder) return Background.CornerType.BottomRight
        return Background.CornerType.NoShape
    }

    property int topRightCorner: {
        if (isTopBorder && !isRightBorder) return Background.CornerType.InvertedTopRight
        if (!isTopBorder && isRightBorder) return Background.CornerType.InvertedBottomLeft
        if (!isTopBorder && !isRightBorder) return Background.CornerType.TopRight
        return Background.CornerType.NoShape
    }

    readonly property int inside: PathArc.Counterclockwise
    readonly property int outside: PathArc.Clockwise

    strokeWidth: -1
    fillColor: wrapper.hasCurrent ? Colours.palette.m3surface : "transparent"  

    // Top Left
    PathArc {
        relativeX: {
            switch (topLeftCorner) {
                case Background.CornerType.InvertedTopLeft: return rounding
                // case Background.CornerType.InvertedBottomRight: return rounding
                case Background.CornerType.TopLeft: return -rounding
                default: return 0
            }
        }
        relativeY: {
            switch (topLeftCorner) {
                case Background.CornerType.InvertedTopLeft: return rounding
                // case Background.CornerType.InvertedBottomRight: return rounding
                case Background.CornerType.TopLeft: return rounding
                default: return 0
            }
        }
        radiusX: topLeftCorner === Background.CornerType.NoShape ? 0 : rounding
        radiusY: topLeftCorner === Background.CornerType.NoShape ? 0 : rounding
        direction: {
            switch (topLeftCorner) {
                case Background.CornerType.InvertedTopLeft: return outside
                // case Background.CornerType.InvertedBottomRight: return inside
                case Background.CornerType.TopLeft: return inside
                default: return inside
            }
        }
    }

    PathLine {
        relativeX: 0
        relativeY: {
            let topLeftY = 0
            switch (topLeftCorner) {
                case Background.CornerType.InvertedTopLeft: topLeftY = -rounding; break
                // case Background.CornerType.InvertedBottomRight: topLeftY = -rounding; break
                case Background.CornerType.TopLeft: topLeftY = -rounding; break
                default: topLeftY = 0; break
            }

            let bottomLeftY = 0
            switch (bottomLeftCorner) {
                // case Background.CornerType.InvertedBottomLeft: bottomLeftY = -rounding; break
                // case Background.CornerType.InvertedTopRight: bottomLeftY = rounding; break
                case Background.CornerType.BottomLeft: bottomLeftY = -rounding; break
                default: bottomLeftY = 0; break
            }

            return root.wrapper.height + topLeftY + bottomLeftY
        }
    }

    // Bottom Left
    PathArc {
        relativeX: {
            switch (bottomLeftCorner) {
                // case Background.CornerType.InvertedBottomLeft: return rounding
                // case Background.CornerType.InvertedTopRight: return -rounding
                case Background.CornerType.BottomLeft: return rounding
                default: return 0
            }
        }
        relativeY: {
            switch (bottomLeftCorner) {
                // case Background.CornerType.InvertedBottomLeft: return -rounding
                // case Background.CornerType.InvertedTopRight: return rounding
                case Background.CornerType.BottomLeft: return rounding
                default: return 0
            }
        }
        radiusX: bottomLeftCorner === Background.CornerType.NoShape ? 0 : rounding
        radiusY: bottomLeftCorner === Background.CornerType.NoShape ? 0 : rounding
        direction: {
            switch (bottomLeftCorner) {
                // case Background.CornerType.InvertedBottomLeft: return outside
                // case Background.CornerType.InvertedTopRight: return inside
                case Background.CornerType.BottomLeft: return inside
                default: return outside
            }
        }
    }

    PathLine {
        relativeX: {
            let bottomLeftX = 0
            switch (bottomLeftCorner) {
                // case Background.CornerType.InvertedBottomLeft: bottomLeftX = rounding; break
                // case Background.CornerType.InvertedTopRight: bottomLeftX = -rounding; break
                case Background.CornerType.BottomLeft: bottomLeftX = -rounding; break
                default: bottomLeftX = 0; break
            }

            let bottomRightX = 0
            switch (bottomRightCorner) {
                // case Background.CornerType.InvertedBottomRight: bottomRightX = rounding; break
                case Background.CornerType.InvertedTopLeft: bottomRightX = -rounding; break
                case Background.CornerType.BottomRight: bottomRightX = -rounding; break
                default: bottomRightX = 0; break
            }

            return root.wrapper.width + bottomLeftX + bottomRightX
        }
        relativeY: 0
    }

    // Bottom Right
    PathArc {
        relativeX: {
            switch (bottomRightCorner) {
                // case Background.CornerType.InvertedBottomRight: return rounding
                case Background.CornerType.InvertedTopLeft: return rounding
                case Background.CornerType.BottomRight: return rounding
                default: return 0
            }
        }
        relativeY: {
            switch (bottomRightCorner) {
                // case Background.CornerType.InvertedBottomRight: return rounding
                case Background.CornerType.InvertedTopLeft: return rounding
                case Background.CornerType.BottomRight: return -rounding
                default: return 0
            }
        }
        radiusX: bottomRightCorner === Background.CornerType.NoShape ? 0 : rounding
        radiusY: bottomRightCorner === Background.CornerType.NoShape ? 0 : rounding
        direction: {
            switch (bottomRightCorner) {
                // case Background.CornerType.InvertedBottomRight: return outside
                case Background.CornerType.InvertedTopLeft: return outside
                case Background.CornerType.BottomRight: return inside
                default: return outside
            }
        }
    }

    PathLine {
        relativeX: 0
        relativeY: {
            let bottomRightY = 0
            switch (bottomRightCorner) {
                // case Background.CornerType.InvertedBottomRight: bottomRightY = rounding; break
                case Background.CornerType.InvertedTopLeft: bottomRightY = -rounding; break
                case Background.CornerType.BottomRight: bottomRightY = rounding; break
                default: bottomRightY = 0; break
            }

            let topRightY = 0
            switch (topRightCorner) {
                case Background.CornerType.InvertedTopRight: topRightY = rounding; break
                case Background.CornerType.InvertedBottomLeft: topRightY = -rounding; break
                case Background.CornerType.TopRight: topRightY = rounding; break
                default: topRightY = 0; break
            }

            return -root.wrapper.height + bottomRightY + topRightY
        }
    }

    // Top Right
    PathArc {
        relativeX: {
            switch (topRightCorner) {
                case Background.CornerType.InvertedTopRight: return rounding
                case Background.CornerType.InvertedBottomLeft: return -rounding
                case Background.CornerType.TopRight: return -rounding
                default: return 0
            }
        }
        relativeY: {
            switch (topRightCorner) {
                case Background.CornerType.InvertedTopRight: return -rounding
                case Background.CornerType.InvertedBottomLeft: return rounding
                case Background.CornerType.TopRight: return -rounding
                default: return 0
            }
        }
        radiusX: topRightCorner === Background.CornerType.NoShape ? 0 : rounding
        radiusY: topRightCorner === Background.CornerType.NoShape ? 0 : rounding
        direction: {
            switch (topRightCorner) {
                case Background.CornerType.InvertedTopRight: return outside
                case Background.CornerType.InvertedBottomLeft: return outside
                case Background.CornerType.TopRight: return inside
                default: return outside
            }
        }
    }

    Behavior on fillColor {
        BasicColorAnimation {}
    }
}
