pragma ComponentBehavior: Bound

import qs.ds
import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    required property Item bar
    required property ShellScreen screen
    required property int margin

    ExclusionZone {
        anchors.left: true
    }
    ExclusionZone {
        anchors.top: true
        exclusiveZone: root.bar.exclusiveZone
    }
    ExclusionZone {
        anchors.right: true
    }
    ExclusionZone {
        anchors.bottom: true
    }

    component ExclusionZone: PanelWindow {
        WlrLayershell.namespace: `quickshell-border-exclusion`
        color: "transparent"
        exclusiveZone: margin
        implicitHeight: 1
        implicitWidth: 1
        screen: root.screen

        mask: Region {
        }
    }
}
