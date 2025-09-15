import qs.config
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    required property PersistentProperties visibilities
    required property var panels

    readonly property bool hasCurrent: root.visibilities.launcher
    readonly property real nonAnimWidth: hasCurrent ? content.implicitWidth : 0
    readonly property real nonAnimHeight: hasCurrent ? content.implicitHeight : 0

    property int animLength: Appearance.anim.durations.normal
    property list<real> animCurve: Appearance.anim.curves.standard

    visible: height > 0
    clip: true

    implicitWidth: nonAnimWidth
    implicitHeight: nonAnimHeight

    Behavior on implicitHeight {
        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Content {
        id: content

        wrapper: root
        visibilities: root.visibilities
        panels: root.panels

        opacity: root.visibilities.launcher ? 1 : 0

        Behavior on opacity {
            BasicNumberAnimation {
                duration: root.animLength * 0.6
                easing.bezierCurve: root.animCurve
            }
        }
    }
}
