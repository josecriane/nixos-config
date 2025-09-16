import "."
import qs.services

Shortcut {
    description: "Toggle launcher, dashboard and osd"
    name: "showall"

    onPressed: {
        const v = Visibilities.getForActive();
        v.launcher = v.dashboard = v.osd = !(v.launcher || v.dashboard || v.osd);
    }
}
