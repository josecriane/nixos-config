import "."
import qs.services

Shortcut {
    description: "Toggle session menu"
    name: "session"

    onPressed: {
        const visibilities = Visibilities.getForActive();
        visibilities.session = !visibilities.session;
    }
}
