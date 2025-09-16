import QtQuick
import qs.ds
import qs.ds.text
import qs.services
import qs.config

Text {
    id: root

    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property real animateDuration: Appearance.anim.durations.normal

    renderType: Text.NativeRendering
    textFormat: Text.PlainText

    font.pointSize: Foundations.font.size.m
    font.family: Foundations.font.family.material

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing.bezierCurve: Appearance.anim.curves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animateProp
        duration: root.animateDuration / 2
        easing.type: Easing.BezierSpline
    }
}
