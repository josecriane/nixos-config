import qs.services
import qs.ds.icons as Icons
import QtQuick
import QtQuick.Controls
import qs.ds.animations
import qs.ds

Slider {
    id: root

    required property string icon
    property real oldValue

    // ToDo: Review this and osd/Content
    property int slideRadius: Foundations.radius.all
    property int activeSize: Foundations.font.size.xs
    property int inactiveSize: Foundations.font.size.m

    orientation: Qt.Vertical

    background: Rectangle {
        color: "transparent"
        radius: root.slideRadius

        Rectangle {
            id: topSide

            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            color: Foundations.palette.base02
            implicitHeight: root.handle.y + root.handle.implicitWidth / 2
            radius: parent.radius
        }
        Rectangle {
            id: bottomSide

            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            color: Foundations.palette.base05
            implicitHeight: parent.height - y
            radius: parent.radius
            y: root.handle.y
        }
    }
    handle: Item {
        id: handle

        property bool moving

        implicitHeight: root.width
        implicitWidth: root.width
        y: root.visualPosition * (root.availableHeight - height)

        ElevationToken {
            anchors.fill: parent
            radius: rect.radius
            spread: root.handleHovered ? 3 : 1
        }
        Rectangle {
            id: rect

            anchors.fill: parent
            color: Foundations.palette.base07
            radius: slideRadius

            Icons.MaterialFontIcon {
                id: icon

                property bool moving: handle.moving

                function update(): void {
                    animate = !moving;
                    text = moving ? Qt.binding(() => Math.round(root.value * 100)) : Qt.binding(() => root.icon);
                    font.pointSize = moving ? root.activeSize : inactiveSize;
                    font.family = moving ? Foundations.font.family.sans : Foundations.font.family.material;
                }

                anchors.centerIn: parent
                animate: true
                color: Foundations.palette.base02
                text: root.icon

                Behavior on moving {
                    SequentialAnimation {
                        BasicNumberAnimation {
                            duration: Foundations.duration.fast
                            from: 1
                            property: "scale"
                            target: icon
                            to: 0
                        }
                        ScriptAction {
                            script: icon.update()
                        }
                        BasicNumberAnimation {
                            duration: Foundations.duration.fast
                            from: 0
                            property: "scale"
                            target: icon
                            to: 1
                        }
                    }
                }
            }
        }
    }
    Behavior on value {
        BasicNumberAnimation {
            duration: Foundations.duration.slow
        }
    }

    onPressedChanged: handle.moving = pressed
    onValueChanged: {
        if (Math.abs(value - oldValue) < 0.01)
            return;
        oldValue = value;
        handle.moving = true;
        stateChangeDelay.restart();
    }

    Timer {
        id: stateChangeDelay

        interval: 500

        onTriggered: {
            if (!root.pressed)
                handle.moving = false;
        }
    }
}
