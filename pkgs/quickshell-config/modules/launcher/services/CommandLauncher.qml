import ".."
import qs.services
import qs.services.search
import Quickshell
import QtQuick

Search {
    id: root

    required property string commandPrefix
    required property var commandList
    property bool useDelayedExecution: false

    function search(search: string): list<var> {
        return query(search);
    }
    
    function transformSearch(search: string): string {
        return search.slice(commandPrefix.length);
    }

    list: variants.instances

    Variants {
        id: variants

        model: commandList

        delegate: LauncherItemModel {
            required property var modelData

            autocompleteText: root.commandPrefix + modelData.name
            fontIcon: modelData.icon
            isAction: true
            name: modelData.name
            originalData: modelData
            subtitle: modelData.description || modelData.command

            onActivate: function () {
                // Check if individual command has delayed property, otherwise use launcher default
                const shouldDelay = modelData.delayed !== undefined ? modelData.delayed : root.useDelayedExecution;

                if (shouldDelay) {
                    const timer = delayedExecutionTimer.createObject(root, {
                        command: originalData.command
                    });
                    timer.start();
                } else {
                    Quickshell.execDetached(["sh", "-c", originalData.command]);
                }
                return true; // Close launcher
            }
        }
    }

    Component {
        id: delayedExecutionTimer

        Timer {
            property string command

            interval: 200
            repeat: false
            onTriggered: {
                Quickshell.execDetached(["sh", "-c", command]);
                destroy();
            }
        }
    }
}