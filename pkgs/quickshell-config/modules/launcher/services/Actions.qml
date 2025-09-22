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
