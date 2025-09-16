import QtQuick
import qs.config

ColorAnimation {
    duration: 400
    easing.bezierCurve: Appearance.anim.curves.standard
    easing.type: Easing.BezierSpline
}
