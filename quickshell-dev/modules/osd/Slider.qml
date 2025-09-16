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
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 2
            anchors.rightMargin: 2

            implicitHeight: root.handle.y + root.handle.implicitWidth / 2

            color: Colours.tPalette.m3surfaceContainer
            radius: parent.radius
        }

        Rectangle {
            id: bottomSide

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 2
            anchors.rightMargin: 2

            y: root.handle.y
            implicitHeight: parent.height - y

            color: Colours.palette.m3primary
            radius: parent.radius
        }
    }

    handle: Item {
        id: handle

        property bool moving

        y: root.visualPosition * (root.availableHeight - height)
        implicitWidth: root.width
        implicitHeight: root.width

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

                animate: true
                text: root.icon
                color: Colours.palette.m3inverseOnSurface
                anchors.centerIn: parent

                Behavior on moving {
                    SequentialAnimation {
                        BasicNumberAnimation {
                            target: icon
                            property: "scale"
                            from: 1
                            to: 0
                            duration: Appearance.anim.durations.normal / 2
                            easing.bezierCurve: Appearance.anim.curves.standardAccel
                        }
                        ScriptAction {
                            script: icon.update()
                        }
                        BasicNumberAnimation {
                            target: icon
                            property: "scale"
                            from: 0
                            to: 1
                            duration: Appearance.anim.durations.normal / 2
                            easing.bezierCurve: Appearance.anim.curves.standardDecel
                        }
                    }
                }
            }
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

    Behavior on value {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.large
        }
    }
}
