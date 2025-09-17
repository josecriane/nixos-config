pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.ds.text as Text
import qs.ds.icons as Icons
import qs.ds
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.ds.animations

Rectangle {
    id: root

    property color colour: Colours.palette.m3secondary

    clip: true
    color: Colours.palette.m3surfaceContainer
    implicitWidth: iconRow.implicitWidth + Appearance.padding.normal * 2
    radius: Appearance.rounding.full

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.large
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    InteractiveArea {
        function onClicked(): void {
            Niri.spawn("alacritty -e btop");
        }

        radius: parent.radius
    }
    RowLayout {
        id: iconRow

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: Appearance.spacing.normal

        // CPU usage
        ResourceItem {
            colour: Colours.palette.m3primary
            icon: "memory"
            value: SystemUsage.cpuPerc
        }

        // Memory usage
        ResourceItem {
            colour: Colours.palette.m3secondary
            icon: "memory_alt"
            value: SystemUsage.memPerc
        }

        // Storage usage
        ResourceItem {
            colour: Colours.palette.m3tertiary
            icon: "hard_disk"
            value: SystemUsage.storagePerc
        }
    }

    component ResourceItem: RowLayout {
        required property color colour
        required property string icon
        required property real value

        spacing: 2

        Behavior on value {
            BasicNumberAnimation {
                duration: Appearance.anim.durations.large
            }
        }

        Text.BodyS {
            color: parent.colour
            text: Math.round(parent.value * 100) + "%"
        }
        Icons.MaterialFontIcon {
            color: parent.colour
            font.pointSize: Appearance.font.size.small
            text: parent.icon
        }
    }
}
