import qs.services
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    active: IdleInhibitor.enabled
    backgroundColor: IdleInhibitor.enabled ? Colours.palette.m3primaryContainer : "transparent"
    foregroundColor: IdleInhibitor.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3secondary
    icon: "coffee"

    onClicked: {
        IdleInhibitor.enabled = !IdleInhibitor.enabled;
    }
}
