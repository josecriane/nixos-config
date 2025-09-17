import qs.services
import qs.config
import QtQuick
import qs.ds.animations
import qs.ds.text as Text
import qs.ds

Rectangle {
    required property int extra

    anchors.margins: Appearance.padding.normal
    anchors.right: parent.right
    color: Colours.palette.m3tertiary
    implicitHeight: count.implicitHeight + Appearance.padding.small * 2
    implicitWidth: count.implicitWidth + Appearance.padding.normal * 2
    opacity: extra > 0 ? 1 : 0
    radius: Appearance.rounding.small
    scale: extra > 0 ? 1 : 0.5

    Behavior on opacity {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.expressiveFastSpatial
        }
    }
    Behavior on scale {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.expressiveFastSpatial
            easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
        }
    }

    ElevationToken {
        anchors.fill: parent
        opacity: parent.opacity
        radius: parent.radius
        spread: 2
        z: -1
    }
    Text.BodyS {
        id: count

        anchors.centerIn: parent
        color: Colours.palette.m3onTertiary
        text: qsTr("+%1").arg(parent.extra)
    }
}
