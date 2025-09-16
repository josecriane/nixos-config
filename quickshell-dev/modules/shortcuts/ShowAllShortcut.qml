import "."
import qs.services

Shortcut {
    name: "showall"
    description: "Toggle launcher, dashboard and osd"
    onPressed: {
        const v = Visibilities.getForActive();
        v.launcher = v.dashboard = v.osd = !(v.launcher || v.dashboard || v.osd);
    }
}
