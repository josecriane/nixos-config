import qs.config
import Quickshell
import QtQuick
import qs.ds.animations
import qs.modules.drawers

BackgroundWrapper {
    id: root

    property list<real> animCurve: Appearance.anim.curves.standard
    property int animLength: Appearance.anim.durations.normal
    readonly property bool hasCurrent: root.visibilities.notifications
    readonly property real nonAnimWidth: hasCurrent ? content.implicitWidth : 0
    required property var panels
    required property PersistentProperties visibilities

    clip: true
    implicitHeight: parent.height
    implicitWidth: nonAnimWidth
    visible: height > 0

    Behavior on implicitWidth {
        BasicNumberAnimation {
        }
    }

    Content {
        id: content

        opacity: root.visibilities.notifications ? 1 : 0
        panels: root.panels
        visibilities: root.visibilities
        wrapper: root

        Behavior on opacity {
            BasicNumberAnimation {
            }
        }
    }
}
