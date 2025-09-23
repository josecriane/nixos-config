pragma Singleton

import ".."
import qs.services
import qs.services.search
import Quickshell
import QtQuick

Search {
    id: root

    function launch(entry: DesktopEntry): void {
        if (entry.runInTerminal) {
            const terminal = "alacritty";
            const terminalCommand = `${terminal} -e ${entry.command.join(" ")}`;
            Niri.spawn(terminalCommand);
        } else {
            Niri.spawn(entry.command.join(" "));
        }
    }
    function search(search: string): list<var> {
        return query(search);
    }

    list: variants.instances
    
    Variants {
        id: variants

        model: [...DesktopEntries.applications.values]
            .filter(app => !ConfigsJson.excludedDesktops.includes(app.id))
            .sort((a, b) => a.name.localeCompare(b.name))

        delegate: LauncherItemModel {
            required property DesktopEntry modelData

            appIcon: modelData?.icon ?? ""
            isApp: true
            name: modelData?.name ?? ""
            originalData: modelData
            subtitle: modelData?.comment || modelData?.genericName || modelData?.name || ""

            onActivate: function () {
                root.launch(originalData);
            }
        }
    }
}
