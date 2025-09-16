import QtQuick
import qs.config

ColorAnimation {
    duration: 400
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.anim.curves.standard
}
