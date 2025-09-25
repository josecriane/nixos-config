import qs.ds
import qs.services
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    active: IdleInhibitor.enabled
    backgroundColor: IdleInhibitor.enabled ? Foundations.palette.base00 : "transparent"
    foregroundColor: IdleInhibitor.enabled ? Foundations.palette.base00 : Foundations.palette.base0D
    icon: "coffee"

    onClicked: {
        IdleInhibitor.enabled = !IdleInhibitor.enabled;
    }
}
