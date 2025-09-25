import qs.services
import qs.ds
import QtQuick
import Quickshell.Widgets
import qs.ds.animations

MouseArea {
    id: root

    // Visual properties
    property color color: Foundations.palette.base07

    // Interaction properties
    property bool disabled: false
    property bool hoverEffectEnabled: true
    property real hoverOpacity: 0.08
    property real pressOpacity: 0.1
    property real radius: parent?.radius ?? 0
    property bool rippleEnabled: true

    // Callback
    function onClicked(): void {
    }

    anchors.fill: parent
    cursorShape: enabled ? Qt.PointingHandCursor : undefined
    enabled: !disabled
    hoverEnabled: enabled && root.hoverEffectEnabled

    onClicked: event => enabled && onClicked(event)
    onPressed: event => {
        if (!enabled || !rippleEnabled)
            return;

        rippleAnim.x = event.x;
        rippleAnim.y = event.y;

        const dist = (ox, oy) => ox * ox + oy * oy;
        rippleAnim.radius = Math.sqrt(Math.max(dist(event.x, event.y), dist(event.x, height - event.y), dist(width - event.x, event.y), dist(width - event.x, height - event.y)));

        rippleAnim.restart();
    }

    RippleAnimation {
        id: rippleAnim

        rippleItem: ripple
        running: false
    }
    ClippingRectangle {
        id: hoverLayer

        anchors.fill: parent
        color: {
            if (root.disabled)
                return "transparent";
            if (!root.hoverEffectEnabled)
                return "transparent";

            const alpha = root.pressed ? root.pressOpacity : root.containsMouse ? root.hoverOpacity : 0;
            return Qt.alpha(root.color, alpha);
        }
        radius: root.radius

        Behavior on color {
            BasicColorAnimation {
            }
        }

        Rectangle {
            id: ripple

            color: root.color
            opacity: 0
            radius: Foundations.radius.all
            visible: root.rippleEnabled

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }
}
