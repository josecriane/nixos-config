import qs.services
import qs.config
import QtQuick
import qs.ds.animations
import qs.ds.text as Text
import qs.ds

Rectangle {
    required property int extra

    anchors.right: parent.right
    anchors.margins: Appearance.padding.normal

    color: Colours.palette.m3tertiary
    radius: Appearance.rounding.small

    implicitWidth: count.implicitWidth + Appearance.padding.normal * 2
    implicitHeight: count.implicitHeight + Appearance.padding.small * 2

    opacity: extra > 0 ? 1 : 0
    scale: extra > 0 ? 1 : 0.5

    ElevationToken {
        anchors.fill: parent
        radius: parent.radius
        opacity: parent.opacity
        z: -1
        spread: 2
    }

    Text.BodyS {
        id: count

        anchors.centerIn: parent
        text: qsTr("+%1").arg(parent.extra)
        color: Colours.palette.m3onTertiary
    }

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
}
