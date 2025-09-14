pragma ComponentBehavior: Bound

import qs.components.containers
import qs.config
import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    required property ShellScreen screen
    required property Item bar

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
        screen: root.screen
        color: "transparent"
        exclusiveZone: Config.border.thickness
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1

        WlrLayershell.namespace: `quickshell-border-exclusion`
    }
}
