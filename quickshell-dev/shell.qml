import qs.ds
import qs.modules.drawers
import qs.modules.shortcuts
import Quickshell

ShellRoot {
    id: root

    property int margin: Foundations.spacing.xxs
    property int radius: Foundations.radius.s
    property int barSize: 30

    Drawers {
        marginSize: root.margin
        radiusSize: root.radius
        barSize: root.barSize
    }
    Handler {
    }
}
