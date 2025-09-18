pragma ComponentBehavior: Bound

import qs.ds
import qs.modules.popups as BarPopouts
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    readonly property int contentHeight: innerHeight + padding * 2
    readonly property int exclusiveZone: 0
    property bool isHovered
    required property BarPopouts.Wrapper popouts
    required property ShellScreen screen
    readonly property bool shouldBeVisible: true
    required property PersistentProperties visibilities

    // ToDo: review if this will
    property int padding: Foundations.spacing.s
    property int innerHeight: 30

    function checkPopout(x: real): void {
        content.item?.checkPopout(x);
    }
    function handleWheel(x: real, angleDelta: point): void {
        content.item?.handleWheel(x, angleDelta);
    }
    implicitHeight: root.contentHeight
    visible: true

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
