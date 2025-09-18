import QtQuick
import qs.ds
import qs.ds.text
import qs.services

Text {
    id: root

    property bool animate: false
    property real animateFrom: 0
    property string animateProp: "scale"
    property real animateTo: 1

    font.family: Foundations.font.family.material
    font.pointSize: Foundations.font.size.m
    renderType: Text.NativeRendering
    textFormat: Text.PlainText

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
            }
            PropertyAction {
            }
            Anim {
                to: root.animateTo
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Foundations.duration.fast
        easing.bezierCurve: Foundations.animCurve
        property: root.animateProp
        target: root
    }
}
