import qs.services
import qs.config
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    required property var visibilities

    backgroundColor: "transparent"
    icon: "notifications"

    onClicked: {
        root.visibilities.notifications = !root.visibilities.notifications;
    }
}
