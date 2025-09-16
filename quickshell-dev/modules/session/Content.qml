pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.ds.icons as Icons
import qs.ds.buttons as DsButtons
import qs.ds
import Quickshell
import QtQuick

Column {
    id: root

    required property PersistentProperties visibilities

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    padding: Appearance.padding.large
    spacing: Appearance.spacing.large

    SessionButton {
        id: logout

        KeyNavigation.down: shutdown
        command: Config.session.commands.logout
        icon: "logout"

        Connections {
            function onLauncherChanged(): void {
                if (root.visibilities.session && !root.visibilities.launcher)
                    logout.focus = true;
            }
            function onSessionChanged(): void {
                if (root.visibilities.session)
                    logout.focus = true;
            }

            target: root.visibilities
        }
    }
    SessionButton {
        id: shutdown

        KeyNavigation.down: hibernate
        KeyNavigation.up: logout
        command: Config.session.commands.shutdown
        icon: "power_settings_new"
    }
    SessionButton {
        id: hibernate

        KeyNavigation.down: reboot
        KeyNavigation.up: shutdown
        command: Config.session.commands.hibernate
        icon: "downloading"
    }
    SessionButton {
        id: reboot

        KeyNavigation.up: hibernate
        command: Config.session.commands.reboot
        icon: "cached"
    }

    component SessionButton: DsButtons.IconButton {
        id: button

        required property list<string> command

        buttonSize: Config.session.sizes.button

        Keys.onEnterPressed: Quickshell.execDetached(button.command)
        Keys.onEscapePressed: root.visibilities.session = false
        Keys.onPressed: event => {
            if (!Config.session.vimKeybinds)
                return;

            if (event.modifiers & Qt.ControlModifier) {
                if (event.key === Qt.Key_J && KeyNavigation.down) {
                    KeyNavigation.down.focus = true;
                    event.accepted = true;
                } else if (event.key === Qt.Key_K && KeyNavigation.up) {
                    KeyNavigation.up.focus = true;
                    event.accepted = true;
                }
            } else if (event.key === Qt.Key_Tab && KeyNavigation.down) {
                KeyNavigation.down.focus = true;
                event.accepted = true;
            } else if (event.key === Qt.Key_Backtab || (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier))) {
                if (KeyNavigation.up) {
                    KeyNavigation.up.focus = true;
                    event.accepted = true;
                }
            }
        }
        Keys.onReturnPressed: Quickshell.execDetached(button.command)
        onClicked: {
            Quickshell.execDetached(button.command);
        }
    }
}
