import qs.components
import qs.services
import qs.config
// import Quickshell.Hyprland  // Disabled - using niri compositor
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    anchors.fill: parent
    spacing: Appearance.spacing.small

    Label {
        Layout.topMargin: Appearance.padding.large * 2

        text: qsTr("No active window")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        font.pointSize: Appearance.font.size.large
        font.weight: 500
    }

    Label {
        text: qsTr("No window class")
        color: Colours.palette.m3tertiary

        font.pointSize: Appearance.font.size.larger
    }

    StyledRect {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        Layout.leftMargin: Appearance.padding.large * 2
        Layout.rightMargin: Appearance.padding.large * 2
        Layout.topMargin: Appearance.spacing.normal
        Layout.bottomMargin: Appearance.spacing.large

        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "location_on"
        text: qsTr("Address: %1").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3primary
    }

    Detail {
        icon: "location_searching"
        text: qsTr("Position: %1, %2").arg("unknown").arg("unknown")  // Disabled for niri
    }

    Detail {
        icon: "resize"
        text: qsTr("Size: %1 x %2").arg("unknown").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3tertiary
    }

    Detail {
        icon: "workspaces"
        text: qsTr("Workspace: %1 (%2)").arg("unknown").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "desktop_windows"
        text: qsTr("Monitor: unknown")  // Disabled for niri
    }

    Detail {
        icon: "page_header"
        text: qsTr("Initial title: %1").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3tertiary
    }

    Detail {
        icon: "category"
        text: qsTr("Initial class: %1").arg("unknown")  // Disabled for niri
    }

    Detail {
        icon: "account_tree"
        text: qsTr("Process id: %1").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3primary
    }

    Detail {
        icon: "picture_in_picture_center"
        text: qsTr("Floating: %1").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "gradient"
        text: qsTr("Xwayland: %1").arg("unknown")  // Disabled for niri
    }

    Detail {
        icon: "keep"
        text: qsTr("Pinned: %1").arg("unknown")  // Disabled for niri
        color: Colours.palette.m3secondary
    }

    Detail {
        icon: "fullscreen"
        text: qsTr("Fullscreen state: unknown")  // Disabled for niri
        color: Colours.palette.m3tertiary
    }

    Item {
        Layout.fillHeight: true
    }

    component Detail: RowLayout {
        id: detail

        required property string icon
        required property string text
        property alias color: icon.color

        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large
        Layout.fillWidth: true

        spacing: Appearance.spacing.smaller

        MaterialIcon {
            id: icon

            Layout.alignment: Qt.AlignVCenter
            text: detail.icon
        }

        StyledText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            text: detail.text
            elide: Text.ElideRight
            font.pointSize: Appearance.font.size.normal
        }
    }

    component Label: StyledText {
        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large
        Layout.fillWidth: true
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        animate: true
    }
}
