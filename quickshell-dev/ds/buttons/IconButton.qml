import QtQuick
import Quickshell.Widgets
import qs.services
import qs.ds.icons as Icons
import qs.ds
import Quickshell

Rectangle {
    id: root

    property string icon: ""
    property string iconPath: ""  // For image file paths
    property color buttonColor: Colours.tPalette.m3surfaceContainer
    property color focusColor: Colours.palette.m3secondaryContainer
    property color iconColor: Colours.palette.m3onSurface
    property color focusIconColor: Colours.palette.m3onSecondaryContainer
    property real buttonSize: 48

    readonly property bool useImageIcon: iconPath !== ""

    signal clicked
    signal hovered

    implicitWidth: buttonSize
    implicitHeight: buttonSize

    radius: Foundations.radius.l
    color: activeFocus ? focusColor : buttonColor

    InteractiveArea {
        radius: parent.radius
        color: root.activeFocus ? root.focusIconColor : root.iconColor

        function onClicked(): void {
            root.clicked();
        }

        function onEntered(): void {
            root.hovered();
        }
    }

    // Font icon (Material Design)
    Icons.MaterialFontIcon {
        anchors.centerIn: parent
        visible: !root.useImageIcon

        text: root.icon
        color: root.activeFocus ? root.focusIconColor : root.iconColor
        font.pointSize: Foundations.font.size.xl
        font.weight: 500
    }

    // Image icon (for app icons, etc.)
    IconImage {
        anchors.centerIn: parent
        visible: root.useImageIcon

        source: root.iconPath
        width: root.buttonSize
        height: root.buttonSize
        asynchronous: true
    }
}
