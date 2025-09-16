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
    color: "transparent"
    implicitHeight: height
    implicitWidth: layout.implicitWidth + Appearance.padding.small * 2
    radius: Appearance.rounding.full
    visible: width > 0 && height > 0 // To avoid warnings about being visible with no size

    Behavior on implicitHeight {
        BasicNumberAnimation {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }
    Behavior on implicitWidth {
        BasicNumberAnimation {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    Row {
        id: layout

        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        add: Transition {
            BasicNumberAnimation {
                easing.bezierCurve: Appearance.anim.curves.standardDecel
                from: 0
                properties: "scale"
                to: 1
            }
        }
        move: Transition {
            BasicNumberAnimation {
                easing.bezierCurve: Appearance.anim.curves.standardDecel
                properties: "scale"
                to: 1
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

                buttonColor: "transparent"
                buttonSize: Appearance.font.size.small * 2
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
}
