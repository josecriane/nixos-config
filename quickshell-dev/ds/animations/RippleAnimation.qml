import qs.services
import qs.config
import QtQuick
import Quickshell.Widgets
import qs.ds.animations

SequentialAnimation {
    id: root

    property real x
    property real y
    property real radius

    required property Item rippleItem

    PropertyAction {
        target: root.rippleItem
        property: "x"
        value: root.x
    }
    PropertyAction {
        target: root.rippleItem
        property: "y"
        value: root.y
    }
    PropertyAction {
        target: root.rippleItem
        property: "opacity"
        value: 0.08
    }
    BasicNumberAnimation {
        target: root.rippleItem
        properties: "implicitWidth,implicitHeight"
        from: 0
        to: root.radius * 2
        easing.bezierCurve: Appearance.anim.curves.standardDecel
    }
    BasicNumberAnimation {
        target: root.rippleItem
        property: "opacity"
        to: 0
    }
}