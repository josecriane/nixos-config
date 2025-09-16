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
    IpcHandler {
        function disable(): void {
            root.enabled = false;
        }
        function enable(): void {
            root.enabled = true;
        }
        function isEnabled(): bool {
            return root.enabled;
        }
        function toggle(): void {
            root.enabled = !root.enabled;
        }

        target: "idleInhibitor"
    }
}
