pragma Singleton

import qs.config
import qs.utils
import qs.services
import Quickshell
import QtQuick

Searcher {
    id: root

    function launch(entry: DesktopEntry): void {
        if (entry.runInTerminal) {
            const terminalCommand = Config.general.apps.terminal.concat([entry.command.join(" ")]).join(" ");
            Niri.spawn(terminalCommand);
        } else {
            Niri.spawn(entry.command.join(" "));
        }
    }

    function search(search: string): list<var> {
        keys = ["name"];
        weights = [1];
        return query(search);
    }

    function selector(item: var): string {
        return item.name;
    }

    list: [...DesktopEntries.applications.values].sort((a, b) => a.name.localeCompare(b.name))
    useFuzzy: false
}
