import "."
import qs.services

Shortcut {
    id: root
    
    property bool interrupted: false
    
    name: "launcher"
    description: "Toggle launcher"
    
    onPressed: {
        root.interrupted = false;
    }
    
    onReleased: {
        if (!root.interrupted) {
            const visibilities = Visibilities.getForActive();
            visibilities.launcher = !visibilities.launcher;
        }
        root.interrupted = false;
    }
}