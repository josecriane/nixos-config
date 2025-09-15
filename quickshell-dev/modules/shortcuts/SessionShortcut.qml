import "."
import qs.services

Shortcut {
    name: "session"
    description: "Toggle session menu"
    onPressed: {
        const visibilities = Visibilities.getForActive();
        visibilities.session = !visibilities.session;
    }
}