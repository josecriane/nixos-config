import qs.services
import QtQuick
import QtQuick.Effects
import qs.ds.animations

RectangularShadow {
    blur: 15
    color: Qt.alpha("#000000", 0.75)
    offset.x: 4
    offset.y: 4
    spread: 1

    Behavior on spread {
        BasicNumberAnimation {
        }
    }
}
