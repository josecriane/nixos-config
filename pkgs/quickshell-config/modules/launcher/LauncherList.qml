pragma ComponentBehavior: Bound

import qs.services
import qs.ds.list as List
import qs.ds.animations
import qs.ds
import qs.modules.launcher.services as LauncheServices
import Quickshell
import QtQuick
import QtQuick.Controls

ListView {
    id: root
    
    // Command launchers
    property LauncheServices.CommandLauncher commandsLauncher: LauncheServices.CommandLauncher {
        commandPrefix: "!"
        commandList: ConfigsJson.commands
    }
    
    property LauncheServices.CommandLauncher sessionCommandsLauncher: LauncheServices.CommandLauncher {
        commandPrefix: "#"
        commandList: ConfigsJson.sessionCommands
    }
    required property TextField search
    required property PersistentProperties visibilities

    // ToDo: review
    property int itemHeight: 57
    property int maxShown: 8
    property int margin: Foundations.spacing.s

    bottomMargin: margin
    highlightMoveDuration: Foundations.duration.standard
    highlightResizeDuration: 0
    implicitHeight: (itemHeight + margin) * Math.min(maxShown, count)
    orientation: Qt.Vertical
    state: {
        const text = search.text;
        const actionsPrefix = ">";
        const commandsPrefix = "!";
        const sessionCommandsPrefix = "#";
        
        if (text.startsWith(actionsPrefix)) {
            for (const action of ["calc"])
                if (text.startsWith(`${actionsPrefix}${action} `))
                    return action;

            return "actions";
        }
        
        if (text.startsWith(commandsPrefix)) {
            return "commands";
        }
        
        if (text.startsWith(sessionCommandsPrefix)) {
            return "sessionCommands";
        }

        return "apps";
    }

    ScrollBar.vertical: List.ScrollBar {
    }
    add: Transition {
        enabled: !root.state

        BasicNumberAnimation {
            from: 0
            properties: "opacity,scale"
            to: 1
        }
    }
    addDisplaced: ItemTransition {
    }
    displaced: ItemTransition {
    }
    highlight: Rectangle {
        color: Foundations.palette.base07
        opacity: 0.08
        radius: Foundations.radius.xs
    }
    model: ScriptModel {
        id: model

        onValuesChanged: root.currentIndex = count > 0 ? 0 : -1
    }
    move: ItemTransition {
    }
    rebound: Transition {
        BasicNumberAnimation {
            properties: "x,y"
        }
    }
    remove: Transition {
        enabled: !root.state

        BasicNumberAnimation {
            from: 1
            properties: "opacity,scale"
            to: 0
        }
    }
    states: [
        State {
            name: "apps"

            PropertyChanges {
                model.values: LauncheServices.Apps.search(search.text)
                root.delegate: appItem
            }
        },
        State {
            name: "actions"

            PropertyChanges {
                model.values: LauncheServices.Actions.search(search.text)
                root.delegate: actionItem
            }
        },
        State {
            name: "commands"

            PropertyChanges {
                model.values: root.commandsLauncher.search(search.text)
                root.delegate: actionItem
            }
        },
        State {
            name: "sessionCommands"

            PropertyChanges {
                model.values: root.sessionCommandsLauncher.search(search.text)
                root.delegate: actionItem
            }
        },
        State {
            name: "calc"

            PropertyChanges {
                model.values: [0]
                root.delegate: calcItem
            }
        }
    ]
    transitions: Transition {
        SequentialAnimation {
            ParallelAnimation {
                BasicNumberAnimation {
                    duration: Foundations.duration.fast
                    from: 1
                    property: "opacity"
                    target: root
                    to: 0
                }
                BasicNumberAnimation {
                    duration: Foundations.duration.fast
                    from: 1
                    property: "scale"
                    target: root
                    to: 0.9
                }
            }
            PropertyAction {
                properties: "values,delegate"
                targets: [model, root]
            }
            ParallelAnimation {
                BasicNumberAnimation {
                    duration: Foundations.duration.fast
                    from: 0
                    property: "opacity"
                    target: root
                    to: 1
                }
                BasicNumberAnimation {
                    duration: Foundations.duration.fast
                    from: 0.9
                    property: "scale"
                    target: root
                    to: 1
                }
            }
            PropertyAction {
                property: "enabled"
                target: root
                value: true
            }
        }
    }

    Component {
        id: appItem

        LauncherItem {
            visibilities: root.visibilities
        }
    }
    Component {
        id: actionItem

        LauncherItem {
            list: root
            visibilities: root.visibilities
        }
    }
    Component {
        id: calcItem

        CalcItem {
            list: root
        }
    }

    component ItemTransition: Transition {
        BasicNumberAnimation {
            duration: Foundations.duration.fast
            property: "y"
        }
        BasicNumberAnimation {
            properties: "opacity,scale"
            to: 1
        }
    }
}
