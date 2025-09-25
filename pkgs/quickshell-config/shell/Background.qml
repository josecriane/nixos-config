import "."
import qs.services
import qs.ds
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

    required property real radius

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
    readonly property int inside: PathArc.Counterclockwise
    property real maxAvailableHeight: parent.height
    property bool isBottomBorder: wrapper.y + wrapper.implicitHeight + radius + 1 >= maxAvailableHeight
    property bool isLeftBorder: wrapper.x <= 0
    property bool isRightBorder: wrapper.x + wrapper.width + radius >= parent.width
    property bool isTopBorder: wrapper.y <= 0
    readonly property int outside: PathArc.Clockwise
    property int topLeftCorner: {
        if (isTopBorder && !isLeftBorder)
            return Background.CornerType.InvertedTopLeft;
        if (!isTopBorder && isLeftBorder)
            return Background.CornerType.InvertedBottomRight;
        if (!isTopBorder && !isLeftBorder)
            return Background.CornerType.TopLeft;
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
    required property BackgroundWrapper wrapper

    fillColor: wrapper.hasCurrent ?  Qt.alpha(Foundations.palette.base01, 0.95) : "transparent"
    strokeWidth: -1

    Behavior on fillColor {
        BasicColorAnimation {
        }
    }

    CornerPathArc {
        cornerType: topLeftCorner
    }
    VerticalPathLine {
        endCornerType: bottomLeftCorner
        startCornerType: topLeftCorner
        upToDown: true
    }
    CornerPathArc {
        cornerType: bottomLeftCorner
    }
    HorizontalPathLine {
        endCornerType: bottomRightCorner
        startCornerType: bottomLeftCorner
    }
    CornerPathArc {
        cornerType: bottomRightCorner
    }
    VerticalPathLine {
        endCornerType: topRightCorner
        startCornerType: bottomRightCorner
        upToDown: false
    }
    CornerPathArc {
        cornerType: topRightCorner
    }

    // Components
    component CornerPathArc: PathArc {
        required property int cornerType

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
        radiusX: cornerType === Background.CornerType.NoShape ? 0 : radius
        radiusY: cornerType === Background.CornerType.NoShape ? 0 : radius
        relativeX: {
            switch (cornerType) {
            case Background.CornerType.InvertedTopLeft:
                return radius;
            case Background.CornerType.InvertedBottomLeft:
                return -radius;
            case Background.CornerType.InvertedBottomRight:
                return -radius;
            case Background.CornerType.InvertedTopRight:
                return radius;
            case Background.CornerType.TopLeft:
                return -radius;
            case Background.CornerType.BottomLeft:
                return radius;
            case Background.CornerType.BottomRight:
                return radius;
            case Background.CornerType.TopRight:
                return -radius;
            default:
                return 0;
            }
        }
        relativeY: {
            switch (cornerType) {
            case Background.CornerType.InvertedTopLeft:
                return radius;
            case Background.CornerType.InvertedBottomLeft:
                return radius;
            case Background.CornerType.InvertedBottomRight:
                return -radius;
            case Background.CornerType.InvertedTopRight:
                return -radius;
            case Background.CornerType.TopLeft:
                return radius;
            case Background.CornerType.BottomLeft:
                return radius;
            case Background.CornerType.BottomRight:
                return -radius;
            case Background.CornerType.TopRight:
                return -radius;
            default:
                return 0;
            }
        }
    }
    component HorizontalPathLine: PathLine {
        required property int endCornerType
        required property int startCornerType

        relativeX: {
            function relativeX(cornerType) {
                switch (startCornerType) {
                case Background.CornerType.InvertedTopLeft:
                    return -radius;
                case Background.CornerType.InvertedBottomLeft:
                    return radius
                case Background.CornerType.InvertedBottomRight:
                    return radius
                // case Background.CornerType.InvertedTopRight: return radius
                // case Background.CornerType.TopLeft: return -radius
                case Background.CornerType.BottomLeft:
                    return -radius;
                case Background.CornerType.BottomRight:
                    return radius;
                // case Background.CornerType.TopRight: return radius
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
        readonly property int direction: upToDown ? 1 : -1
        required property int endCornerType
        required property int startCornerType
        required property bool upToDown

        relativeX: 0
        relativeY: {
            function relativeY(cornerType) {
                switch (startCornerType) {
                case Background.CornerType.InvertedTopLeft:
                    return -radius;
                case Background.CornerType.InvertedBottomLeft:
                    return -radius;
                case Background.CornerType.InvertedBottomRight:
                    return radius;
                case Background.CornerType.InvertedTopRight:
                    return radius;
                case Background.CornerType.TopLeft:
                    return -radius;
                case Background.CornerType.BottomLeft:
                    return -radius;
                case Background.CornerType.BottomRight:
                    return radius;
                case Background.CornerType.TopRight:
                    return radius;
                default:
                    return 0;
                }
            }
            let startY = relativeY(startCornerType);
            let endY = relativeY(endCornerType);

            return direction * root.wrapper.height + startY + endY;
        }
    }
}
