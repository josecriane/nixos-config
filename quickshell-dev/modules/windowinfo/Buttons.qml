import qs.components
import qs.services
import qs.config
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property bool moveToWsExpanded

    anchors.fill: parent
    spacing: Appearance.spacing.small

    RowLayout {
        Layout.topMargin: Appearance.padding.large
        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large

        spacing: Appearance.spacing.normal

        StyledText {
            Layout.fillWidth: true
            text: qsTr("Move to workspace")
            elide: Text.ElideRight
        }

        StyledRect {
            color: Colours.palette.m3primary
            radius: Appearance.rounding.small

            implicitWidth: moveToWsIcon.implicitWidth + Appearance.padding.small * 2
            implicitHeight: moveToWsIcon.implicitHeight + Appearance.padding.small

            StateLayer {
                color: Colours.palette.m3onPrimary

                function onClicked(): void {
                    root.moveToWsExpanded = !root.moveToWsExpanded;
                }
            }

            MaterialIcon {
                id: moveToWsIcon

                anchors.centerIn: parent

                animate: true
                text: root.moveToWsExpanded ? "expand_more" : "keyboard_arrow_right"
                color: Colours.palette.m3onPrimary
                font.pointSize: Appearance.font.size.large
            }
        }
    }

    WrapperItem {
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.large * 2
        Layout.rightMargin: Appearance.padding.large * 2

        Layout.preferredHeight: root.moveToWsExpanded ? implicitHeight : 0
        clip: true

        topMargin: Appearance.spacing.normal
        bottomMargin: Appearance.spacing.normal

        GridLayout {
            id: wsGrid

            rowSpacing: Appearance.spacing.smaller
            columnSpacing: Appearance.spacing.normal
            columns: 5

            Repeater {
                model: 10

                Button {
                    required property int index
                    readonly property int wsId: index + 1  // Simplified for niri
                    readonly property bool isCurrent: false  // Disabled for niri

                    color: isCurrent ? Colours.tPalette.m3surfaceContainerHighest : Colours.palette.m3tertiaryContainer
                    onColor: isCurrent ? Colours.palette.m3onSurface : Colours.palette.m3onTertiaryContainer
                    text: wsId
                    disabled: isCurrent

                    function onClicked(): void {
                        console.log("Move to workspace disabled for niri compositor");
                    }
                }
            }
        }

        Behavior on Layout.preferredHeight {
            Anim {}
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large
        Layout.bottomMargin: Appearance.padding.large

        spacing: Appearance.spacing.normal  // Simplified for niri

        Button {
            color: Colours.palette.m3secondaryContainer
            onColor: Colours.palette.m3onSecondaryContainer
            text: qsTr("Float")  // Simplified for niri

            function onClicked(): void {
                console.log("Toggle floating disabled for niri compositor");
            }
        }

        Loader {
            active: false  // Disabled for niri
            asynchronous: true
            Layout.fillWidth: active
            Layout.leftMargin: active ? 0 : -parent.spacing
            Layout.rightMargin: active ? 0 : -parent.spacing

            sourceComponent: Button {
                color: Colours.palette.m3secondaryContainer
                onColor: Colours.palette.m3onSecondaryContainer
                text: qsTr("Pin")  // Simplified for niri

                function onClicked(): void {
                    console.log("Pin/unpin disabled for niri compositor");
                }
            }
        }

        Button {
            color: Colours.palette.m3errorContainer
            onColor: Colours.palette.m3onErrorContainer
            text: qsTr("Kill")

            function onClicked(): void {
                console.log("Kill window disabled for niri compositor");
            }
        }
    }

    component Button: StyledRect {
        property color onColor: Colours.palette.m3onSurface
        property alias disabled: stateLayer.disabled
        property alias text: label.text

        function onClicked(): void {
        }

        radius: Appearance.rounding.small

        Layout.fillWidth: true
        implicitHeight: label.implicitHeight + Appearance.padding.small * 2

        StateLayer {
            id: stateLayer

            color: parent.onColor

            function onClicked(): void {
                parent.onClicked();
            }
        }

        StyledText {
            id: label

            anchors.centerIn: parent

            animate: true
            color: parent.onColor
            font.pointSize: Appearance.font.size.normal
        }
    }
}
