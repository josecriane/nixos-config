pragma Singleton

import ".."
import qs.services
import qs.config
import qs.utils as Utils
import Quickshell
import QtQuick

Utils.Searcher {
    id: root

    property string actionPrefix: ">"

    readonly property list<LauncherItemModel> actions: [
        LauncherItemModel {
            name: qsTr("Calculator")
            subtitle: qsTr("Do simple math equations (powered by Qalc)")
            isAction: true
            fontIcon: "calculate"
            autocompleteText: ">calc "
        },
        LauncherItemModel {
            name: qsTr("Shutdown")
            subtitle: qsTr("Shutdown the system")
            isAction: true
            fontIcon: "power_settings_new"
            onActivate: function () {
                Niri.spawn("systemctl poweroff");
            }
        },
        LauncherItemModel {
            name: qsTr("Reboot")
            subtitle: qsTr("Reboot the system")
            isAction: true
            fontIcon: "cached"
            onActivate: function () {
                Niri.spawn("systemctl reboot");
            }
        },
        LauncherItemModel {
            name: qsTr("Logout")
            subtitle: qsTr("Log out of the current session")
            isAction: true
            fontIcon: "exit_to_app"
            onActivate: function () {
                Niri.spawn("loginctl terminate-user");
            }
        },
        LauncherItemModel {
            name: qsTr("Lock")
            subtitle: qsTr("Lock the current session")
            isAction: true
            fontIcon: "lock"
            onActivate: function () {
                Niri.spawn("loginctl lock-session");
            }
        },
        LauncherItemModel {
            name: qsTr("Sleep")
            subtitle: qsTr("Suspend then hibernate")
            isAction: true
            fontIcon: "bedtime"
            onActivate: function () {
                Niri.spawn("systemctl suspend-then-hibernate");
            }
        }
    ]

    function transformSearch(search: string): string {
        return search.slice(actionPrefix.length);
    }

    function search(search: string): list<var> {
        return query(search);
    }

    list: actions
    useFuzzy: false
}
