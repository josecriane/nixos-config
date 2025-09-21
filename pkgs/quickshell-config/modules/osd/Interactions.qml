import qs.services
import Quickshell
import QtQuick

Scope {
    id: root

    required property bool hovered
    readonly property Brightness.Monitor monitor: Brightness.getMonitorForScreen(screen)
    required property ShellScreen screen
    required property PersistentProperties visibilities

    function show(): void {
        root.visibilities.osd = true;
        timer.restart();
    }

    Connections {
        function onMutedChanged(): void {
            root.show();
        }
        function onVolumeChanged(): void {
            root.show();
        }

        target: Audio
    }
    Connections {
        function onBrightnessChanged(): void {
            root.show();
        }

        target: root.monitor
    }
    Timer {
        id: timer

        interval: 2000

        onTriggered: {
            if (!root.hovered)
                root.visibilities.osd = false;
        }
    }
}
