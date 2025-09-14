pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import qs.ds.text as Text
import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property color colour: Colours.palette.m3secondary

    color: Colours.tPalette.m3surfaceContainer
    radius: Appearance.rounding.full

    clip: true
    implicitWidth: iconRow.implicitWidth + Appearance.padding.normal * 2

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Niri.spawn("alacritty --class floating -e btop");
        }
    }

    RowLayout {
        id: iconRow

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: Appearance.spacing.normal

        // CPU usage
        ResourceItem {
            icon: "memory"
            value: SystemUsage.cpuPerc
            colour: Colours.palette.m3primary
        }

        // Memory usage
        ResourceItem {
            icon: "memory_alt"
            value: SystemUsage.memPerc
            colour: Colours.palette.m3secondary
        }

        // Storage usage
        ResourceItem {
            icon: "hard_disk"
            value: SystemUsage.storagePerc
            colour: Colours.palette.m3tertiary
        }
    }

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.anim.durations.large
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    component ResourceItem: RowLayout {
        required property string icon
        required property real value
        required property color colour

        spacing: 2

        Text.BodyS {
            text: Math.round(parent.value * 100) + "%"
            color: parent.colour
        }

        MaterialIcon {
            text: parent.icon
            color: parent.colour
            font.pointSize: Appearance.font.size.small
        }

        Behavior on value {
            Anim {
                duration: Appearance.anim.durations.large
            }
        }
    }
}