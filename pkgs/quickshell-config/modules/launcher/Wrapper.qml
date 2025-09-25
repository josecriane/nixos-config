import qs.ds
import Quickshell
import QtQuick
import qs.ds.animations
import qs.shell

BackgroundWrapper {
    id: root

    readonly property bool hasCurrent: root.visibilities.launcher
    readonly property real nonAnimHeight: hasCurrent ? content.implicitHeight : 0
    readonly property real nonAnimWidth: hasCurrent ? content.implicitWidth : 0
    required property var panels
    required property PersistentProperties visibilities

    clip: true
    implicitHeight: nonAnimHeight
    implicitWidth: nonAnimWidth
    visible: height > 0

    Behavior on implicitHeight {
        BasicNumberAnimation {
        }
    }

    Content {
        id: content

        opacity: root.visibilities.launcher ? 1 : 0
        panels: root.panels
        visibilities: root.visibilities
        wrapper: root

        Behavior on opacity {
            BasicNumberAnimation {
            }
        }
    }
}
