import QtQuick
import Quickshell.Widgets
import qs.services
import qs.ds.icons as Icons
import qs.ds
import Quickshell

Rectangle {
    id: root

    property color buttonColor: Colours.palette.m3surfaceContainer
    property real buttonSize: 48
    property color focusColor: Colours.palette.m3secondaryContainer
    property color focusIconColor: Colours.palette.m3onSecondaryContainer
    property string icon: ""
    property color iconColor: Colours.palette.m3onSurface
    property string iconPath: ""  // For image file paths
    readonly property bool useImageIcon: iconPath !== ""

    signal clicked
    signal hovered

    color: activeFocus ? focusColor : buttonColor
    implicitHeight: buttonSize
    implicitWidth: buttonSize
    radius: Foundations.radius.l

    InteractiveArea {
        function onClicked(): void {
            root.clicked();
        }
        function onEntered(): void {
            root.hovered();
        }

        color: root.activeFocus ? root.focusIconColor : root.iconColor
        radius: parent.radius
    }

    // Font icon (Material Design)
    Icons.MaterialFontIcon {
        anchors.centerIn: parent
        color: root.activeFocus ? root.focusIconColor : root.iconColor
        font.pointSize: Foundations.font.size.xl
        font.weight: 500
        text: root.icon
        visible: !root.useImageIcon
    }

    // Image icon (for app icons, etc.)
    IconImage {
        anchors.centerIn: parent
        asynchronous: true
        height: root.buttonSize
        source: root.iconPath
        visible: root.useImageIcon
        width: root.buttonSize
    }
}
