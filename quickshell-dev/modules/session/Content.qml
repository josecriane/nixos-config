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

    padding: Appearance.padding.large

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left

    spacing: Appearance.spacing.large

    SessionButton {
        id: logout

        icon: "logout"
        command: Config.session.commands.logout

        KeyNavigation.down: shutdown

        Connections {
            target: root.visibilities

            function onSessionChanged(): void {
                if (root.visibilities.session)
                    logout.focus = true;
            }

            function onLauncherChanged(): void {
                if (root.visibilities.session && !root.visibilities.launcher)
                    logout.focus = true;
            }
        }
    }

    SessionButton {
        id: shutdown

        icon: "power_settings_new"
        command: Config.session.commands.shutdown

        KeyNavigation.up: logout
        KeyNavigation.down: hibernate
    }

    SessionButton {
        id: hibernate

        icon: "downloading"
        command: Config.session.commands.hibernate

        KeyNavigation.up: shutdown
        KeyNavigation.down: reboot
    }

    SessionButton {
        id: reboot

        icon: "cached"
        command: Config.session.commands.reboot

        KeyNavigation.up: hibernate
    }

    component SessionButton: DsButtons.IconButton {
        id: button

        required property list<string> command

        buttonSize: Config.session.sizes.button

        Keys.onEnterPressed: Quickshell.execDetached(button.command)
        Keys.onReturnPressed: Quickshell.execDetached(button.command)
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

        onClicked: {
            Quickshell.execDetached(button.command);
        }
    }
}
