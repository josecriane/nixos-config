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
        if (isTopBorder && !isLeftBorder)
            return Background.CornerType.InvertedTopLeft;
        if (!isTopBorder && isLeftBorder)
            return Background.CornerType.InvertedBottomRight;
        if (!isTopBorder && !isLeftBorder)
            return Background.CornerType.TopLeft;
        return Background.CornerType.NoShape;
    }

    property int bottomLeftCorner: {
        if (isBottomBorder && !isLeftBorder)
            return Background.CornerType.InvertedBottomLeft;
        if (!isBottomBorder && isLeftBorder)
            return Background.CornerType.InvertedTopRight;
        if (!isBottomBorder && !isLeftBorder)
            return Background.CornerType.BottomLeft;
        return Background.CornerType.NoShape;
    }

    property int bottomRightCorner: {
        if (isBottomBorder && !isRightBorder)
            return Background.CornerType.InvertedBottomRight;
        if (!isBottomBorder && isRightBorder)
            return Background.CornerType.InvertedTopLeft;
        if (!isBottomBorder && !isRightBorder)
            return Background.CornerType.BottomRight;
        return Background.CornerType.NoShape;
    }

    property int topRightCorner: {
        if (isTopBorder && !isRightBorder)
            return Background.CornerType.InvertedTopRight;
        if (!isTopBorder && isRightBorder)
            return Background.CornerType.InvertedBottomLeft;
        if (!isTopBorder && !isRightBorder)
            return Background.CornerType.TopRight;
        return Background.CornerType.NoShape;
    }

    readonly property int inside: PathArc.Counterclockwise
    readonly property int outside: PathArc.Clockwise

    strokeWidth: -1
    fillColor: wrapper.hasCurrent ? Colours.palette.m3surface : "transparent"

    CornerPathArc {
        cornerType: topLeftCorner
    }

    VerticalPathLine {
        startCornerType: topLeftCorner
        endCornerType: bottomLeftCorner

        upToDown: true
    }

    CornerPathArc {
        cornerType: bottomLeftCorner
    }

    HorizontalPathLine {
        startCornerType: bottomLeftCorner
        endCornerType: bottomRightCorner
    }

    CornerPathArc {
        cornerType: bottomRightCorner
    }

    VerticalPathLine {
        startCornerType: bottomRightCorner
        endCornerType: topRightCorner

        upToDown: false
    }

    CornerPathArc {
        cornerType: topRightCorner
    }

    // Components
    component CornerPathArc: PathArc {
        required property int cornerType

        relativeX: {
            switch (cornerType) {
            case Background.CornerType.InvertedTopLeft:
                return rounding;
            case Background.CornerType.InvertedBottomLeft:
                return -rounding;
            case Background.CornerType.InvertedBottomRight:
                return -rounding;
            case Background.CornerType.InvertedTopRight:
                return rounding;
            case Background.CornerType.TopLeft:
                return -rounding;
            case Background.CornerType.BottomLeft:
                return rounding;
            case Background.CornerType.BottomRight:
                return rounding;
            case Background.CornerType.TopRight:
                return -rounding;
            default:
                return 0;
            }
        }

        relativeY: {
            switch (cornerType) {
            case Background.CornerType.InvertedTopLeft:
                return rounding;
            case Background.CornerType.InvertedBottomLeft:
                return rounding;
            case Background.CornerType.InvertedBottomRight:
                return -rounding;
            case Background.CornerType.InvertedTopRight:
                return -rounding;
            case Background.CornerType.TopLeft:
                return rounding;
            case Background.CornerType.BottomLeft:
                return rounding;
            case Background.CornerType.BottomRight:
                return -rounding;
            case Background.CornerType.TopRight:
                return -rounding;
            default:
                return 0;
            }
        }

        radiusX: cornerType === Background.CornerType.NoShape ? 0 : rounding
        radiusY: cornerType === Background.CornerType.NoShape ? 0 : rounding

        direction: {
            switch (cornerType) {
            case Background.CornerType.InvertedTopLeft:
                return outside;
            case Background.CornerType.InvertedBottomLeft:
                return outside;
            case Background.CornerType.InvertedBottomRight:
                return outside;
            case Background.CornerType.InvertedTopRight:
                return outside;
            case Background.CornerType.TopLeft:
                return inside;
            case Background.CornerType.BottomLeft:
                return inside;
            case Background.CornerType.BottomRight:
                return inside;
            case Background.CornerType.TopRight:
                return inside;
            default:
                return outside;
            }
        }
    }

    component HorizontalPathLine: PathLine {
        required property int startCornerType
        required property int endCornerType

        relativeX: {
            function relativeX(cornerType) {
                switch (startCornerType) {
                case Background.CornerType.InvertedTopLeft:
                    return -rounding;
                // case Background.CornerType.InvertedBottomLeft: return -rounding
                // case Background.CornerType.InvertedBottomRight: return rounding
                // case Background.CornerType.InvertedTopRight: return rounding
                // case Background.CornerType.TopLeft: return -rounding
                case Background.CornerType.BottomLeft:
                    return -rounding;
                case Background.CornerType.BottomRight:
                    return rounding;
                // case Background.CornerType.TopRight: return rounding
                default:
                    return 0;
                }
            }
            let startX = relativeX(startCornerType);
            let endX = relativeX(endCornerType);

            return root.wrapper.width + startX + endX;
        }
        relativeY: 0
    }

    component VerticalPathLine: PathLine {
        required property int startCornerType
        required property int endCornerType
        required property bool upToDown

        readonly property int direction: upToDown ? 1 : -1

        relativeX: 0
        relativeY: {
            function relativeY(cornerType) {
                switch (startCornerType) {
                case Background.CornerType.InvertedTopLeft:
                    return -rounding;
                case Background.CornerType.InvertedBottomLeft:
                    return -rounding;
                case Background.CornerType.InvertedBottomRight:
                    return rounding;
                case Background.CornerType.InvertedTopRight:
                    return rounding;
                case Background.CornerType.TopLeft:
                    return -rounding;
                case Background.CornerType.BottomLeft:
                    return -rounding;
                case Background.CornerType.BottomRight:
                    return rounding;
                case Background.CornerType.TopRight:
                    return rounding;
                default:
                    return 0;
                }
            }
            let startY = relativeY(startCornerType);
            let endY = relativeY(endCornerType);

            return direction * root.wrapper.height + startY + endY;
        }
    }

    Behavior on fillColor {
        BasicColorAnimation {}
    }
}
