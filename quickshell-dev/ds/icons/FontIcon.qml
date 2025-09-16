import QtQuick
import qs.ds
import qs.ds.text
import qs.services
import qs.config

Text {
    id: root

    property bool animate: false
    property real animateDuration: Appearance.anim.durations.normal
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
                easing.bezierCurve: Appearance.anim.curves.standardAccel
                to: root.animateFrom
            }
            PropertyAction {
            }
            Anim {
                easing.bezierCurve: Appearance.anim.curves.standardDecel
                to: root.animateTo
            }
        }
    }

    component Anim: NumberAnimation {
        duration: root.animateDuration / 2
        easing.type: Easing.BezierSpline
        property: root.animateProp
        target: root
    }
}
