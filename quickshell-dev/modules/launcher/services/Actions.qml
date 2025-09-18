pragma Singleton

import qs.services.search
import qs.services
import qs.modules.launcher
import Quickshell
import QtQuick

Search {
    id: root

    property string actionPrefix: ">"
    readonly property list<LauncherItemModel> actions: [
        LauncherItemModel {
            autocompleteText: ">calc "
            fontIcon: "calculate"
            isAction: true
            name: qsTr("Calculator")
            subtitle: qsTr("Do simple math equations (powered by Qalc)")
        },
        LauncherItemModel {
            fontIcon: "power_settings_new"
            isAction: true
            name: qsTr("Shutdown")
            subtitle: qsTr("Shutdown the system")

            onActivate: function () {
                Niri.spawn("systemctl poweroff");
            }
        },
        LauncherItemModel {
            fontIcon: "cached"
            isAction: true
            name: qsTr("Reboot")
            subtitle: qsTr("Reboot the system")

            onActivate: function () {
                Niri.spawn("systemctl reboot");
            }
        },
        LauncherItemModel {
            fontIcon: "exit_to_app"
            isAction: true
            name: qsTr("Logout")
            subtitle: qsTr("Log out of the current session")

            onActivate: function () {
                Niri.spawn("loginctl terminate-user");
            }
        },
        LauncherItemModel {
            fontIcon: "lock"
            isAction: true
            name: qsTr("Lock")
            subtitle: qsTr("Lock the current session")

            onActivate: function () {
                Niri.spawn("loginctl lock-session");
            }
        },
        LauncherItemModel {
            fontIcon: "bedtime"
            isAction: true
            name: qsTr("Sleep")
            subtitle: qsTr("Suspend then hibernate")

            onActivate: function () {
                Niri.spawn("systemctl suspend-then-hibernate");
            }
        }
    ]

    function search(search: string): list<var> {
        return query(search);
    }
    function transformSearch(search: string): string {
        return search.slice(actionPrefix.length);
    }

    list: actions
}
