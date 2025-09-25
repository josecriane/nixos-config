pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias enabled: props.enabled

    PersistentProperties {
        id: props

        property bool enabled

        reloadableId: "idleInhibitor"
    }
    Process {
        command: ["systemd-inhibit", "--what=idle", "--who=quickshell", "--why=Idle inhibitor active", "--mode=block", "sleep", "inf"]
        running: root.enabled
    }
}
