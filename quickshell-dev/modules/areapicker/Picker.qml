pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
// import Caelestia // Removed Caelestia dependency
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

MouseArea {
    id: root

    required property LazyLoader loader
    required property ShellScreen screen

    property int borderWidth
    property int rounding

    property bool onClient

    property real realBorderWidth: onClient ? borderWidth : 2
    property real realRounding: onClient ? rounding : 0

    property real ssx
    property real ssy

    property real sx: 0
    property real sy: 0
    property real ex: screen.width
    property real ey: screen.height

    property real rsx: Math.min(sx, ex)
    property real rsy: Math.min(sy, ey)
    property real sw: Math.abs(sx - ex)
    property real sh: Math.abs(sy - ey)

    property list<var> clients: []  // No client info in niri

    function checkClientRects(x: real, y: real): void {
        for (const client of clients) {
            if (!client)
                continue;

            let {
                at: [cx, cy],
                size: [cw, ch]
            } = client.lastIpcObject;
            cx -= screen.x;
            cy -= screen.y;
            if (cx <= x && cy <= y && cx + cw >= x && cy + ch >= y) {
                onClient = true;
                sx = cx;
                sy = cy;
                ex = cx + cw;
                ey = cy + ch;
                break;
            }
        }
    }

    function save(): void {
        const tmpfile = `file:///tmp/caelestia-picker-${Quickshell.processId}-${Date.now()}.png`;
        // Simplified screenshot save without CUtils
        // TODO: Implement screenshot functionality
        Quickshell.execDetached(["grim", "-g", `${Math.ceil(rsx)},${Math.ceil(rsy)} ${Math.floor(sw)}x${Math.floor(sh)}`, "-", "|", "swappy", "-f", "-"]);
        closeAnim.start();
    }

    onClientsChanged: checkClientRects(mouseX, mouseY)

    anchors.fill: parent
    opacity: 0
    hoverEnabled: true
    cursorShape: Qt.CrossCursor

    Component.onCompleted: {
        // Break binding if frozen
        if (loader.freeze)
            clients = clients;

        opacity = 1;

        // No clients in niri, use default selection area
        sx = screen.width / 2 - 100;
        sy = screen.height / 2 - 100;
        ex = screen.width / 2 + 100;
        ey = screen.height / 2 + 100;
        
        // Set default border values (previously from hyprctl)
        borderWidth = 2;
        rounding = 0;
    }

    onPressed: event => {
        ssx = event.x;
        ssy = event.y;
    }

    onReleased: {
        if (closeAnim.running)
            return;

        if (root.loader.freeze) {
            save();
        } else {
            overlay.visible = border.visible = false;
            screencopy.visible = false;
            screencopy.active = true;
        }
    }

    onPositionChanged: event => {
        const x = event.x;
        const y = event.y;

        if (pressed) {
            onClient = false;
            sx = ssx;
            sy = ssy;
            ex = x;
            ey = y;
        } else {
            checkClientRects(x, y);
        }
    }

    focus: true
    Keys.onEscapePressed: closeAnim.start()

    SequentialAnimation {
        id: closeAnim

        PropertyAction {
            target: root.loader
            property: "closing"
            value: true
        }
        ParallelAnimation {
            Anim {
                target: root
                property: "opacity"
                to: 0
                duration: Appearance.anim.durations.large
            }
            ExAnim {
                target: root
                properties: "rsx,rsy"
                to: 0
            }
            ExAnim {
                target: root
                property: "sw"
                to: root.screen.width
            }
            ExAnim {
                target: root
                property: "sh"
                to: root.screen.height
            }
        }
        PropertyAction {
            target: root.loader
            property: "activeAsync"
            value: false
        }
    }

    // Hyprctl processes disabled for niri - values set in main Component.onCompleted

    Loader {
        id: screencopy

        anchors.fill: parent

        active: root.loader.freeze
        asynchronous: true

        sourceComponent: ScreencopyView {
            captureSource: root.screen

            onHasContentChanged: {
                if (hasContent && !root.loader.freeze) {
                    overlay.visible = border.visible = true;
                    root.save();
                }
            }
        }
    }

    StyledRect {
        id: overlay

        anchors.fill: parent
        color: Colours.palette.m3secondaryContainer
        opacity: 0.3

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: selectionWrapper
            maskEnabled: true
            maskInverted: true
            maskSpreadAtMin: 1
            maskThresholdMin: 0.5
        }
    }

    Item {
        id: selectionWrapper

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            id: selectionRect

            radius: root.realRounding
            x: root.rsx
            y: root.rsy
            implicitWidth: root.sw
            implicitHeight: root.sh
        }
    }

    Rectangle {
        id: border

        color: "transparent"
        radius: root.realRounding > 0 ? root.realRounding + root.realBorderWidth : 0
        border.width: root.realBorderWidth
        border.color: Colours.palette.m3primary

        x: selectionRect.x - root.realBorderWidth
        y: selectionRect.y - root.realBorderWidth
        implicitWidth: selectionRect.implicitWidth + root.realBorderWidth * 2
        implicitHeight: selectionRect.implicitHeight + root.realBorderWidth * 2

        Behavior on border.color {
            CAnim {}
        }
    }

    Behavior on opacity {
        Anim {
            duration: Appearance.anim.durations.large
        }
    }

    Behavior on rsx {
        enabled: !root.pressed

        ExAnim {}
    }

    Behavior on rsy {
        enabled: !root.pressed

        ExAnim {}
    }

    Behavior on sw {
        enabled: !root.pressed

        ExAnim {}
    }

    Behavior on sh {
        enabled: !root.pressed

        ExAnim {}
    }

    component ExAnim: Anim {
        duration: Appearance.anim.durations.expressiveDefaultSpatial
        easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
    }
}
