import qs.services
import qs.config
import QtQuick
import Quickshell.Widgets
import qs.ds.animations

MouseArea {
    id: root

    // Interaction properties
    property bool disabled: false
    property bool rippleEnabled: true
    property bool hoverEffectEnabled: true

    // Visual properties
    property color color: Colours.palette.m3onSurface
    property real radius: parent?.radius ?? 0
    property real hoverOpacity: 0.08
    property real pressOpacity: 0.1

    // Callback
    function onClicked(): void {
    }

    anchors.fill: parent

    enabled: !disabled
    cursorShape: enabled ? Qt.PointingHandCursor : undefined
    hoverEnabled: enabled && root.hoverEffectEnabled

    onPressed: event => {
        if (!enabled || !rippleEnabled)
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

        Rectangle {
            id: ripple
            radius: Appearance.rounding.full
            color: root.color
            opacity: 0
            visible: root.rippleEnabled

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
