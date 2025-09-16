import qs.services
import qs.config
import Quickshell.Services.SystemTray
import QtQuick
import qs.ds.animations
import qs.ds.buttons

Rectangle {
    id: root

    readonly property alias items: items

    clip: true
    visible: width > 0 && height > 0 // To avoid warnings about being visible with no size

    implicitWidth: layout.implicitWidth + Appearance.padding.small * 2
    implicitHeight: height

    color: "transparent"
    radius: Appearance.rounding.full

    Row {
        id: layout

        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        add: Transition {
            BasicNumberAnimation {
                properties: "scale"
                from: 0
                to: 1
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
        }

        move: Transition {
            BasicNumberAnimation {
                properties: "scale"
                to: 1
                easing.bezierCurve: Appearance.anim.curves.standardDecel
            }
            BasicNumberAnimation {
                properties: "x,y"
            }
        }

        Repeater {
            id: items

            model: SystemTray.items

            IconButton {
                id: iconButton

                required property SystemTrayItem modelData

                buttonSize: Appearance.font.size.small * 2
                buttonColor: "transparent"
                focusColor: "transparent"
                iconColor: "transparent"

                // Process the icon to extract the path
                iconPath: {
                    let icon = iconButton.modelData.icon;
                    if (icon.includes("?path=")) {
                        const [name, path] = icon.split("?path=");
                        return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                    }
                    return icon;
                }

                onClicked: {
                    iconButton.modelData.activate();
                }

                onHovered: {
                    iconButton.modelData.secondaryActivate();
                }
            }
        }
    }

    Behavior on implicitWidth {
        BasicNumberAnimation {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    Behavior on implicitHeight {
        BasicNumberAnimation {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }
}
