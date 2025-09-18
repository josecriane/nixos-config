import qs.services
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    required property var visibilities
    readonly property bool enabled: root.visibilities.notifications

    icon: "notifications"

    backgroundColor: enabled ? Colours.palette.m3primaryContainer : "transparent"
    foregroundColor: enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3secondary

    active: enabled

    onClicked: {
        root.visibilities.notifications = !root.visibilities.notifications;
    }
}
