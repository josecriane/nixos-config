import qs.services
import qs.config
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    icon: "coffee"
    backgroundColor: IdleInhibitor.enabled ? Colours.palette.m3primaryContainer : "transparent"
    foregroundColor: IdleInhibitor.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3secondary
    active: IdleInhibitor.enabled

    onClicked: {
        IdleInhibitor.enabled = !IdleInhibitor.enabled;
    }
}
