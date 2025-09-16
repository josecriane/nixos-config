import qs.services
import qs.config
import qs.ds.icons as Icons
import QtQuick
import QtQuick.Controls
import qs.ds.animations
import qs.ds

Slider {
    id: root

    required property string icon
    property real oldValue

    orientation: Qt.Vertical

    background: Rectangle {
        color: "transparent"// Colours.tPalette.m3surfaceContainer
        radius: Appearance.rounding.full

        Rectangle {
            id: topSide

            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            color: Colours.tPalette.m3surfaceContainer
            implicitHeight: root.handle.y + root.handle.implicitWidth / 2
            radius: parent.radius
        }
        Rectangle {
            id: bottomSide

            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            color: Colours.palette.m3primary
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
            color: Colours.palette.m3inverseSurface
            radius: Appearance.rounding.full

            Icons.MaterialFontIcon {
                id: icon

                property bool moving: handle.moving

                function update(): void {
                    animate = !moving;
                    text = moving ? Qt.binding(() => Math.round(root.value * 100)) : Qt.binding(() => root.icon);
                    font.pointSize = moving ? Appearance.font.size.small : Appearance.font.size.larger;
                    font.family = moving ? Appearance.font.family.sans : Appearance.font.family.material;
                }

                anchors.centerIn: parent
                animate: true
                color: Colours.palette.m3inverseOnSurface
                text: root.icon

                Behavior on moving {
                    SequentialAnimation {
                        BasicNumberAnimation {
                            duration: Appearance.anim.durations.normal / 2
                            easing.bezierCurve: Appearance.anim.curves.standardAccel
                            from: 1
                            property: "scale"
                            target: icon
                            to: 0
                        }
                        ScriptAction {
                            script: icon.update()
                        }
                        BasicNumberAnimation {
                            duration: Appearance.anim.durations.normal / 2
                            easing.bezierCurve: Appearance.anim.curves.standardDecel
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
            duration: Appearance.anim.durations.large
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
