pragma ComponentBehavior: Bound

import qs.services
import qs.ds.text as Text
import qs.ds.icons as Icons
import qs.ds
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.ds.animations

Rectangle {
    id: root

    property color colour: Foundations.palette.base0D

    // ToDo: Reviow (maybe review all margin/paddings)
    property int margin: Foundations.spacing.s
    property int spacingItems: Foundations.spacing.m

    clip: true
    color: Foundations.palette.base02
    implicitWidth: iconRow.implicitWidth + margin * 2
    radius: Foundations.radius.all

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Foundations.duration.slow
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
        spacing: root.spacingItems

        // CPU usage
        ResourceItem {
            colour: Foundations.palette.base0D
            icon: "memory"
            value: SystemUsage.cpuPerc
        }

        // Memory usage
        ResourceItem {
            colour: Foundations.palette.base0D
            icon: "memory_alt"
            value: SystemUsage.memPerc
        }

        // Storage usage
        ResourceItem {
            colour: Foundations.palette.base0D
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
                duration: Foundations.duration.slow
            }
        }

        Text.BodyS {
            color: parent.colour
            text: Math.round(parent.value * 100) + "%"
        }
        Icons.MaterialFontIcon {
            color: parent.colour
            font.pointSize: Foundations.font.size.xs
            text: parent.icon
        }
    }
}
