import qs.services
import qs.config
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick

CircularButtons.S {
    id: root

    required property PersistentProperties visibilities

    icon: "power_settings_new"
    foregroundColor: Colours.palette.m3error
    backgroundColor: "transparent"
    
    onClicked: {
        root.visibilities.session = !root.visibilities.session;
    }
}
