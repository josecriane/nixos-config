import QtQuick
import QtQuick.Layouts
import qs.services
import qs.ds.text as DsText
import qs.ds.icons as Icons
import qs.ds.animations
import qs.ds

Rectangle {
    id: root

    property string icon: ""
    property string hint: ""
    property color buttonColor: Colours.palette.m3primaryContainer
    property color contentColor: Colours.palette.m3onPrimaryContainer

    signal clicked

    color: buttonColor
    radius: Foundations.radius.s
    clip: true

    implicitWidth: (interactiveArea.containsMouse ? hintLabel.implicitWidth + hintLabel.anchors.rightMargin : 0) + iconElement.implicitWidth + Foundations.spacing.m * 2
    implicitHeight: Math.max(hintLabel.implicitHeight, iconElement.implicitHeight) + Foundations.spacing.s * 2

    InteractiveArea {
        id: interactiveArea
        color: root.contentColor

        function onClicked(): void {
            root.clicked();
        }
    }

    DsText.BodyM {
        id: hintLabel

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: iconElement.left
        anchors.rightMargin: Foundations.spacing.s

        text: root.hint
        color: root.contentColor

        opacity: interactiveArea.containsMouse ? 1 : 0

        Behavior on opacity {
            BasicNumberAnimation {}
        }
    }

    Icons.MaterialFontIcon {
        id: iconElement

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Foundations.spacing.m

        text: root.icon
        color: root.contentColor
        font.pointSize: Foundations.font.size.m
    }

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Foundations.duration.s
        }
    }
}
