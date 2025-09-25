import qs.ds
import qs.shell
import qs.services
import Quickshell

ShellRoot {
    id: root

    property int margin: Foundations.spacing.xxs
    property int radius: Foundations.radius.s
    property int barSize: 30

    Shell {
        marginSize: root.margin
        radiusSize: root.radius
        barSize: root.barSize
    }
    IpcHandler {
    }
}
