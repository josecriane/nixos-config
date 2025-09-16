pragma ComponentBehavior: Bound

import qs.services
import qs.utils as Utils
import qs.config
import qs.ds.text as Text
import QtQuick
import qs.ds.animations
import Quickshell.Wayland

Item {
    id: root

    property string activeAppId: activeToplevel?.appId ?? ""

    // Propiedades que se actualizarán con binding
    property string activeTitle: activeToplevel?.title ?? ""
    property Toplevel activeToplevel: ToplevelManager.activeToplevel
    property color colour: Colours.palette.m3primary
    property Title current: text1
    readonly property int maxWidth: screen.width / 3
    required property var screen

    clip: true
    implicitWidth: Math.min(contentItem.width, maxWidth)

    Behavior on implicitWidth {
        BasicNumberAnimation {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    Component.onCompleted: {
        activeToplevel = Qt.binding(() => {
            const trigger = ToplevelManager.activeToplevel;
            const toplevels = ToplevelManager.toplevels.values;

            if (!toplevels || !toplevels.length) {
                return activeToplevel;
            }

            for (let i = 0; i < toplevels.length; i++) {
                const toplevel = toplevels[i];
                if (toplevel && toplevel.activated) {
                    if (toplevel.screens && toplevel.screens.length > 0) {
                        const toplevelScreen = toplevel.screens[0];
                        if (screen.name === toplevelScreen.name) {
                            return toplevel;
                        }
                    }
                }
            }

            return activeToplevel;
        });
    }

    Item {
        id: contentItem

        anchors.centerIn: parent
        height: Math.max(icon.implicitHeight, current.implicitHeight)
        width: icon.implicitWidth + current.implicitWidth + Appearance.spacing.small

        FontIcon {
            id: icon

            text: Utils.Apps.getIcon(root.activeAppId)
        }
        Title {
            id: text1

        }
        Title {
            id: text2

        }
    }
    TextMetrics {
        id: metrics

        elide: Qt.ElideRight
        elideWidth: root.maxWidth - icon.implicitWidth - Appearance.spacing.small
        font.family: Appearance.font.family.mono
        font.pointSize: Appearance.font.size.smaller
        text: Utils.Apps.cleanTitle(root.activeTitle)

        onElideWidthChanged: root.current.text = elidedText
        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
    }

    component FontIcon: Text.BodyM {
        anchors.verticalCenter: parent.verticalCenter
        primary: true
    }
    component Title: Text.BodyM {
        id: text

        anchors.left: icon.right
        anchors.leftMargin: Appearance.spacing.small
        anchors.verticalCenter: icon.verticalCenter
        opacity: root.current === this ? 1 : 0
        primary: true

        Behavior on opacity {
            BasicNumberAnimation {
            }
        }
    }
}
