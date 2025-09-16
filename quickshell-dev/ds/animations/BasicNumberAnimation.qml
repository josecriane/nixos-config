import QtQuick
import qs.config

NumberAnimation {
    duration: 400
    easing.bezierCurve: Appearance.anim.curves.standard
    easing.type: Easing.BezierSpline
}
