pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils
import qs.config
import QtQuick
import Quickshell.Wayland

Item {
    id: root

    required property var screen
    property color colour: Colours.palette.m3primary

    readonly property int maxWidth: screen.width / 3
    property Title current: text1

    property Toplevel activeToplevel: ToplevelManager.activeToplevel
    
    // Propiedades que se actualizarán con binding
    property string activeTitle: activeToplevel?.title ?? ""
    property string activeAppId: activeToplevel?.appId ?? ""
    
    Component.onCompleted: {
        activeToplevel = Qt.binding(() => {
            const trigger = ToplevelManager.activeToplevel;
            const toplevels = ToplevelManager.toplevels.values

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

    clip: true
    implicitWidth: Math.min(contentItem.width, maxWidth)

    Item {
        id: contentItem
        anchors.centerIn: parent
        width: icon.implicitWidth + current.implicitWidth + Appearance.spacing.small
        height: Math.max(icon.implicitHeight, current.implicitHeight)
        
        FontIcon {
            id: icon
            
            text: Apps.getIcon(root.activeAppId)
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

        text: Apps.cleanTitle(root.activeTitle)
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        elide: Qt.ElideRight
        elideWidth: root.maxWidth - icon.implicitWidth - Appearance.spacing.small

        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
        onElideWidthChanged: root.current.text = elidedText
    }

    Behavior on implicitWidth {
        Anim {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    component Title: StyledText {
        id: text

        anchors.verticalCenter: icon.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: Appearance.spacing.small

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.colour
        opacity: root.current === this ? 1 : 0

        Behavior on opacity {
            Anim {}
        }
    }

    component FontIcon: Text {
        anchors.verticalCenter: parent.verticalCenter
        color: root.colour
        font.family: Appearance.font.family.mono
        font.pointSize: Appearance.font.size.normal
    }
}
