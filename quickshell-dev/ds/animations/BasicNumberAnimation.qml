import QtQuick
import qs.config

NumberAnimation {
    duration: 400
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.anim.curves.standard
}
