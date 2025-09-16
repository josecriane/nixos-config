pragma ComponentBehavior: Bound

import qs.modules.drawers
import qs.services
import qs.config
import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.ds.animations

BackgroundWrapper {
    id: root

    property list<real> animCurve: Appearance.anim.curves.emphasized
    property int animLength: Appearance.anim.durations.normal
    property real currentCenter
    property string currentName
    property bool hasCurrent
    readonly property real nonAnimHeight: hasCurrent ? (children.find(c => c.shouldBeActive)?.implicitHeight ?? content.implicitHeight) : 0
    readonly property real nonAnimWidth: hasCurrent ? (children.find(c => c.shouldBeActive)?.implicitWidth ?? content.implicitWidth) : 0
    required property ShellScreen screen

    clip: true
    implicitHeight: nonAnimHeight
    implicitWidth: nonAnimWidth
    visible: width > 0 && height > 0

    Behavior on implicitHeight {
        enabled: root.implicitWidth > 0

        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }
    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }
    Behavior on x {
        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }
    Behavior on y {
        enabled: root.implicitWidth > 0

        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Comp {
        id: content

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        shouldBeActive: root.hasCurrent

        sourceComponent: Content {
            wrapper: root
        }
    }

    component Comp: Loader {
        id: comp

        property bool shouldBeActive

        active: false
        asynchronous: true
        opacity: 0

        states: State {
            name: "active"
            when: comp.shouldBeActive

            PropertyChanges {
                comp.active: true
                comp.opacity: 1
            }
        }
        transitions: [
            Transition {
                from: ""
                to: "active"

                SequentialAnimation {
                    PropertyAction {
                        property: "active"
                    }
                    BasicNumberAnimation {
                        property: "opacity"
                    }
                }
            },
            Transition {
                from: "active"
                to: ""

                SequentialAnimation {
                    BasicNumberAnimation {
                        property: "opacity"
                    }
                    PropertyAction {
                        property: "active"
                    }
                }
            }
        ]
    }
}
