pragma ComponentBehavior: Bound

import "services"
import qs.services
import qs.config
import qs.ds.list as List
import qs.ds.animations
import Quickshell
import QtQuick
import QtQuick.Controls

ListView {
    id: root

    required property TextField search
    required property PersistentProperties visibilities

    model: ScriptModel {
        id: model

        onValuesChanged: root.currentIndex = 0
    }

    rebound: Transition {
        BasicNumberAnimation {
            properties: "x,y"
        }
    }

    spacing: Appearance.spacing.small
    orientation: Qt.Vertical
    bottomMargin: Appearance.padding.normal
    property int maxShown: 8
    
    property int itemHeight: 57
    
    implicitHeight: (itemHeight + spacing) * Math.min(maxShown, count) - spacing + bottomMargin

    highlightMoveDuration: Appearance.anim.durations.normal
    highlightResizeDuration: 0

    highlight: Rectangle {
        radius: Appearance.rounding.full
        color: Colours.palette.m3onSurface
        opacity: 0.08
    }

    state: {
        const text = search.text;
        const prefix = ">";
        if (text.startsWith(prefix)) {
            for (const action of ["calc"])
                if (text.startsWith(`${prefix}${action} `))
                    return action;

            return "actions";
        }

        return "apps";
    }


    states: [
        State {
            name: "apps"

            PropertyChanges {
                model.values: Apps.search(search.text)
                root.delegate: appItem
            }
        },
        State {
            name: "actions"

            PropertyChanges {
                model.values: Actions.query(search.text)
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
                    target: root
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
                BasicNumberAnimation {
                    target: root
                    property: "scale"
                    from: 1
                    to: 0.9
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
            }
            PropertyAction {
                targets: [model, root]
                properties: "values,delegate"
            }
            ParallelAnimation {
                BasicNumberAnimation {
                    target: root
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
                BasicNumberAnimation {
                    target: root
                    property: "scale"
                    from: 0.9
                    to: 1
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
            }
            PropertyAction {
                target: root
                property: "enabled"
                value: true
            }
        }
    }

    ScrollBar.vertical: List.ScrollBar {}

    add: Transition {
        enabled: !root.state

        BasicNumberAnimation {
            properties: "opacity,scale"
            from: 0
            to: 1
        }
    }

    remove: Transition {
        enabled: !root.state

        BasicNumberAnimation {
            properties: "opacity,scale"
            from: 1
            to: 0
        }
    }

    move: Transition {
        BasicNumberAnimation {
            property: "y"
        }
        BasicNumberAnimation {
            properties: "opacity,scale"
            to: 1
        }
    }

    addDisplaced: Transition {
        BasicNumberAnimation {
            property: "y"
            duration: Appearance.anim.durations.small
        }
        BasicNumberAnimation {
            properties: "opacity,scale"
            to: 1
        }
    }

    displaced: Transition {
        BasicNumberAnimation {
            property: "y"
        }
        BasicNumberAnimation {
            properties: "opacity,scale"
            to: 1
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
            visibilities: root.visibilities
            list: root
        }
    }

    Component {
        id: calcItem

        CalcItem {
            list: root
        }
    }
}
