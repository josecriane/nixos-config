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

    required property ShellScreen screen

    readonly property real nonAnimWidth: hasCurrent ? (children.find(c => c.shouldBeActive)?.implicitWidth ?? content.implicitWidth) : 0
    readonly property real nonAnimHeight: hasCurrent ? (children.find(c => c.shouldBeActive)?.implicitHeight ?? content.implicitHeight) : 0

    property string currentName
    property real currentCenter
    property bool hasCurrent

    property int animLength: Appearance.anim.durations.normal
    property list<real> animCurve: Appearance.anim.curves.emphasized

    visible: width > 0 && height > 0
    clip: true

    implicitWidth: nonAnimWidth
    implicitHeight: nonAnimHeight

    Comp {
        id: content

        shouldBeActive: root.hasCurrent
        asynchronous: true
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        sourceComponent: Content {
            wrapper: root
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

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    Behavior on implicitHeight {
        enabled: root.implicitWidth > 0

        BasicNumberAnimation {
            duration: root.animLength
            easing.bezierCurve: root.animCurve
        }
    }

    component Comp: Loader {
        id: comp

        property bool shouldBeActive

        asynchronous: true
        active: false
        opacity: 0

        states: State {
            name: "active"
            when: comp.shouldBeActive

            PropertyChanges {
                comp.opacity: 1
                comp.active: true
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
