pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import Quickshell
import Quickshell.Wayland
// import Quickshell.Hyprland  // Disabled - using niri compositor
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property ShellScreen screen
    required property var client  // Changed from HyprlandToplevel for niri compatibility

    Layout.preferredWidth: preview.implicitWidth + Appearance.padding.large * 2
    Layout.fillHeight: true

    StyledClippingRect {
        id: preview

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: label.top
        anchors.topMargin: Appearance.padding.large
        anchors.bottomMargin: Appearance.spacing.normal

        implicitWidth: view.implicitWidth

        color: Colours.tPalette.m3surfaceContainer
        radius: Appearance.rounding.small

        Loader {
            anchors.centerIn: parent
            active: !root.client
            asynchronous: true

            sourceComponent: ColumnLayout {
                spacing: 0

                MaterialIcon {
                    Layout.alignment: Qt.AlignHCenter
                    text: "web_asset_off"
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.extraLarge * 3
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("No active client")
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.extraLarge
                    font.weight: 500
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Try switching to a window")
                    color: Colours.palette.m3outline
                    font.pointSize: Appearance.font.size.large
                }
            }
        }

        ScreencopyView {
            id: view

            anchors.centerIn: parent

            captureSource: root.client?.wayland ?? null
            live: true

            constraintSize.width: root.client ? parent.height * Math.min(root.screen.width / root.screen.height, 16/9) : parent.height  // Simplified for niri
            constraintSize.height: parent.height
        }
    }

    StyledText {
        id: label

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Appearance.padding.large

        animate: true
        text: {
            const client = root.client;
            if (!client)
                return qsTr("No active client");

            // Simplified for niri - no monitor or position info
            return qsTr("%1").arg(client.title || "Unknown window");
        }
    }
}
