import qs.services
import qs.ds
import QtQuick
import Quickshell.Widgets
import qs.ds.animations

SequentialAnimation {
    id: root

    property real radius
    required property Item rippleItem
    property real x
    property real y

    PropertyAction {
        property: "x"
        target: root.rippleItem
        value: root.x
    }
    PropertyAction {
        property: "y"
        target: root.rippleItem
        value: root.y
    }
    PropertyAction {
        property: "opacity"
        target: root.rippleItem
        value: 0.08
    }
    BasicNumberAnimation {
        from: 0
        properties: "implicitWidth,implicitHeight"
        target: root.rippleItem
        to: root.radius * 2
    }
    BasicNumberAnimation {
        property: "opacity"
        target: root.rippleItem
        to: 0
    }
}
