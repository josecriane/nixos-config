pragma Singleton

import ".."
import qs.config
import qs.services
import qs.components
import qs.utils as Utils
import Quickshell
import QtQuick

Utils.Searcher {
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
        keys = ["name"];
        weights = [1];
        return query(search);
    }


    list: variants.instances
    useFuzzy: false
    
    Variants {
        id: variants
        
        model: [...DesktopEntries.applications.values].sort((a, b) => a.name.localeCompare(b.name))
        
        delegate: LauncherItemModel {
            required property DesktopEntry modelData
            
            name: modelData.name ?? ""
            subtitle: modelData.comment || modelData.genericName || modelData.name || ""
            isApp: true
            appIcon: modelData.icon ?? ""
            originalData: modelData
            onActivate: function() {
                root.launch(originalData);
            }
        }
    }
}
