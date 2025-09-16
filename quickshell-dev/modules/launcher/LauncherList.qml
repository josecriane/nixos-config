pragma ComponentBehavior: Bound

import "services"
import qs.services
import qs.config
import qs.ds.list as List
import qs.ds.animations
import qs.ds
import Quickshell
import QtQuick
import QtQuick.Controls

ListView {
    id: root

    property int itemHeight: 57
    property int maxShown: 8
    required property TextField search
    required property PersistentProperties visibilities

    bottomMargin: Appearance.padding.normal
    highlightMoveDuration: Appearance.anim.durations.normal
    highlightResizeDuration: 0
    implicitHeight: (itemHeight + spacing) * Math.min(maxShown, count) - spacing + bottomMargin
    orientation: Qt.Vertical
    spacing: Appearance.spacing.small
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
    addDisplaced: Transition {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.small
            property: "y"
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
    highlight: Rectangle {
        color: Colours.palette.m3onSurface
        opacity: 0.08
        radius: Foundations.radius.xs
    }
    model: ScriptModel {
        id: model

        onValuesChanged: root.currentIndex = 0
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
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                    from: 1
                    property: "opacity"
                    target: root
                    to: 0
                }
                BasicNumberAnimation {
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
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
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                    from: 0
                    property: "opacity"
                    target: root
                    to: 1
                }
                BasicNumberAnimation {
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
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
}
