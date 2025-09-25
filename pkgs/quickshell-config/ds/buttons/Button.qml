import "."
import QtQuick
import QtQuick.Layouts
import qs.ds.progress
import qs.ds
import qs.ds.text as Text
import qs.ds.icons as Icons
import qs.services

Rectangle {
    id: root

    readonly property int animDuration: 200
    property color backgroundColor: Foundations.palette.base00
    property bool disabled: false
    property color foregroundColor: Foundations.palette.base05
    property string leftIcon: ""
    property bool loading: false
    property int margin: Foundations.spacing.s
    property string rightIcon: ""
    property string text: ""

    signal clicked

    color: backgroundColor
    implicitHeight: contentLayout.implicitHeight + margin * 2
    implicitWidth: contentLayout.implicitWidth + margin * 2
    radius: Foundations.radius.xs

    InteractiveArea {
        function onClicked(): void {
            root.clicked();
        }

        color: foregroundColor
        disabled: root.disabled || root.loading
    }

    // Content
    RowLayout {
        id: contentLayout

        anchors.centerIn: parent
        opacity: root.loading ? 0 : 1
        spacing: Foundations.spacing.xs

        Behavior on opacity {
            NumberAnimation {
                duration: root.animDuration
                easing.type: Easing.InOutQuad
            }
        }

        Icons.MaterialFontIcon {
            animate: true
            color: root.foregroundColor
            text: root.leftIcon
            visible: root.leftIcon !== ""
        }
        Text.BodyM {
            color: root.foregroundColor
            text: root.text
            visible: root.text !== ""
        }
        Icons.MaterialFontIcon {
            animate: true
            color: root.foregroundColor
            text: root.rightIcon
            visible: root.rightIcon !== ""
        }
    }
    CircularProgressIndicator {
        anchors.centerIn: parent
        implicitHeight: parent.implicitHeight - 20
        running: root.loading
        strokeWidth: 2
        visible: root.loading
    }
}
