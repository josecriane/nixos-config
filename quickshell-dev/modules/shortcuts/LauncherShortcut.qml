import "."
import qs.services

Shortcut {
    id: root

    property bool interrupted: false

    description: "Toggle launcher"
    name: "launcher"

    onPressed: {
        root.interrupted = false;
    }
    onReleased: {
        if (!root.interrupted) {
            const visibilities = Visibilities.getForActive();

            if (!visibilities.launcher) {
                // Opening launcher - close all other panels
                visibilities.osd = false;
                visibilities.session = false;
                visibilities.bar = false;
                // Note: popouts are handled separately through popouts.hasCurrent
            }

            visibilities.launcher = !visibilities.launcher;
        }
        root.interrupted = false;
    }
}
