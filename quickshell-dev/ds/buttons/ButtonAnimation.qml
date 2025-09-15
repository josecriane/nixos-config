import qs.services
import qs.config
import QtQuick
import Quickshell.Widgets
import qs.ds.animations

MouseArea {
    id: root

    property bool disabled
    property color color: Colours.palette.m3onSurface
    property real radius: parent?.radius ?? 0

    function onClicked(): void { }

    anchors.fill: parent

    enabled: !disabled

    cursorShape: enabled ? Qt.PointingHandCursor : undefined
    hoverEnabled: enabled

    onPressed: event => {
        if (!enabled)
            return;

        rippleAnim.x = event.x;
        rippleAnim.y = event.y;

        const dist = (ox, oy) => ox * ox + oy * oy;
        rippleAnim.radius = Math.sqrt(Math.max(dist(event.x, event.y), dist(event.x, height - event.y), dist(width - event.x, event.y), dist(width - event.x, height - event.y)));

        rippleAnim.restart();
    }

    onClicked: event => enabled && onClicked(event)

    RippleAnimation {
        id: rippleAnim

        rippleItem: ripple
    }

    ClippingRectangle {
        id: hoverLayer

        anchors.fill: parent

        color: Qt.alpha(root.color, root.disabled ? 0 : root.pressed ? 0.1 : root.containsMouse ? 0.08 : 0)
        radius: root.radius

        Rectangle {
            id: ripple

            radius: Appearance.rounding.full
            color: root.color
            opacity: 0

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }

        Behavior on color {
            BasicColorAnimation {}
        }
    }
}
