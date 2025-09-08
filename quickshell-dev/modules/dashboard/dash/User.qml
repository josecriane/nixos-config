import qs.components
import qs.components.effects
import qs.components.images
import qs.services
import qs.config
import qs.utils
import Quickshell
import QtQuick

Row {
    id: root

    required property PersistentProperties visibilities
    required property PersistentProperties state

    padding: Appearance.padding.large
    spacing: Appearance.spacing.normal

    Column {
        id: info

        anchors.verticalCenter: parent.verticalCenter
        spacing: Appearance.spacing.normal

        Item {
            id: line

            implicitWidth: icon.implicitWidth + text.width + text.anchors.leftMargin
            implicitHeight: Math.max(icon.implicitHeight, text.implicitHeight)

            ColouredIcon {
                id: icon

                anchors.left: parent.left
                anchors.leftMargin: (Config.dashboard.sizes.infoIconSize - implicitWidth) / 2

                source: SysInfo.osLogo
                implicitSize: Math.floor(Appearance.font.size.normal * 1.34)
                colour: Colours.palette.m3primary
            }

            StyledText {
                id: text

                anchors.verticalCenter: icon.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: icon.anchors.leftMargin
                text: `:  ${SysInfo.osPrettyName || SysInfo.osName}`
                font.pointSize: Appearance.font.size.normal

                width: Config.dashboard.sizes.infoWidth
                elide: Text.ElideRight
            }
        }

        InfoLine {
            icon: "select_window_2"
            text: SysInfo.wm
            colour: Colours.palette.m3secondary
        }

        InfoLine {
            id: uptime

            icon: "timer"
            text: qsTr("up %1").arg(SysInfo.uptime)
            colour: Colours.palette.m3tertiary
        }
    }

    component InfoLine: Item {
        id: line

        required property string icon
        required property string text
        required property color colour

        implicitWidth: icon.implicitWidth + text.width + text.anchors.leftMargin
        implicitHeight: Math.max(icon.implicitHeight, text.implicitHeight)

        MaterialIcon {
            id: icon

            anchors.left: parent.left
            anchors.leftMargin: (Config.dashboard.sizes.infoIconSize - implicitWidth) / 2

            fill: 1
            text: line.icon
            color: line.colour
            font.pointSize: Appearance.font.size.normal
        }

        StyledText {
            id: text

            anchors.verticalCenter: icon.verticalCenter
            anchors.left: icon.right
            anchors.leftMargin: icon.anchors.leftMargin
            text: `:  ${line.text}`
            font.pointSize: Appearance.font.size.normal

            width: Config.dashboard.sizes.infoWidth
            elide: Text.ElideRight
        }
    }
}
