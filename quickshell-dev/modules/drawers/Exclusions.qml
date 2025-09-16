pragma ComponentBehavior: Bound

import qs.config
import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    required property Item bar
    required property ShellScreen screen

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
        exclusiveZone: Config.border.thickness
        implicitHeight: 1
        implicitWidth: 1
        screen: root.screen

        mask: Region {
        }
    }
}
