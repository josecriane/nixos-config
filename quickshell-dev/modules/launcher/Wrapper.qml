import qs.components
import qs.config
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities
    required property var panels

    readonly property bool hasCurrent: height > 0

    property int animLength: Appearance.anim.durations.normal
    property list<real> animCurve: Appearance.anim.curves.standard

    visible: height > 0
    clip: true

    implicitWidth: content.implicitWidth
    implicitHeight: root.visibilities.launcher && Config.launcher.enabled ? content.implicitHeight : 0

    Behavior on implicitHeight {
        Anim {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Content {
        id: content

        wrapper: root
        visibilities: root.visibilities
        panels: root.panels

        opacity: root.visibilities.launcher && Config.launcher.enabled ? 1 : 0

        Behavior on opacity {
            Anim {
                duration: root.animLength * 0.6
                easing.bezierCurve: root.animCurve
            }
        }
    }
}
