pragma ComponentBehavior: Bound

import qs.config
import "popouts" as BarPopouts
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    readonly property int contentHeight: innerHeight + padding * 2
    readonly property int exclusiveZone: 0 //Change to de innerHeight
    readonly property int innerHeight: 30
    property bool isHovered
    readonly property int padding: Math.max(Appearance.padding.smaller, Config.border.thickness)
    required property BarPopouts.Wrapper popouts
    required property ShellScreen screen
    readonly property bool shouldBeVisible: true
    required property PersistentProperties visibilities

    function checkPopout(x: real): void {
        content.item?.checkPopout(x);
    }
    function handleWheel(x: real, angleDelta: point): void {
        content.item?.handleWheel(x, angleDelta);
    }

    implicitHeight: Config.border.thickness
    visible: height > Config.border.thickness

    states: State {
        name: "visible"
        when: root.shouldBeVisible

        PropertyChanges {
            root.implicitHeight: root.contentHeight
        }
    }
    transitions: [
        Transition {
            from: ""
            to: "visible"

            BasicNumberAnimation {
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
                property: "implicitHeight"
                target: root
            }
        },
        Transition {
            from: "visible"
            to: ""

            BasicNumberAnimation {
                easing.bezierCurve: Appearance.anim.curves.emphasized
                property: "implicitHeight"
                target: root
            }
        }
    ]

    Loader {
        id: content

        active: root.shouldBeVisible || root.visible
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        sourceComponent: Bar {
            height: root.contentHeight
            innerHeight: root.innerHeight
            popouts: root.popouts
            screen: root.screen
            visibilities: root.visibilities
            width: parent.width
        }
    }
}
