import qs.services
import qs.config
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    required property PersistentProperties visibilities

    backgroundColor: "transparent"
    foregroundColor: Colours.palette.m3error
    icon: "power_settings_new"

    onClicked: {
        root.visibilities.session = !root.visibilities.session;
    }
}
