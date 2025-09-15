import qs.services
import QtQuick
import QtQuick.Effects
import qs.ds.animations

RectangularShadow {
    color: Qt.alpha(Colours.palette.m3shadow, 0.75)
    blur: 15
    spread: 1
    offset.x: 4
    offset.y: 4

    Behavior on spread {
        BasicNumberAnimation {}
    }
}