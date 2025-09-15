import qs.components
import qs.services
import qs.config
import Quickshell.Services.SystemTray
import QtQuick
import qs.ds.animations

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

            TrayItem {}
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
