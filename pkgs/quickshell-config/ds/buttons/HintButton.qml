import QtQuick
import QtQuick.Layouts
import qs.services
import qs.ds.text as DsText
import qs.ds.icons as Icons
import qs.ds.animations
import qs.ds

Rectangle {
    id: root

    property color buttonColor: Foundations.palette.base00
    property color contentColor: Foundations.palette.base07
    property string hint: ""
    property string icon: ""

    signal clicked

    clip: true
    color: buttonColor
    implicitHeight: Math.max(hintLabel.implicitHeight, iconElement.implicitHeight) + Foundations.spacing.s * 2
    implicitWidth: (interactiveArea.containsMouse ? hintLabel.implicitWidth + hintLabel.anchors.rightMargin : 0) + iconElement.implicitWidth + Foundations.spacing.m * 2
    radius: Foundations.radius.s

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Foundations.duration.fast
        }
    }

    InteractiveArea {
        id: interactiveArea

        function onClicked(): void {
            root.clicked();
        }

        color: root.contentColor
    }
    DsText.BodyM {
        id: hintLabel

        anchors.right: iconElement.left
        anchors.rightMargin: Foundations.spacing.s
        anchors.verticalCenter: parent.verticalCenter
        color: root.contentColor
        opacity: interactiveArea.containsMouse ? 1 : 0
        text: root.hint

        Behavior on opacity {
            BasicNumberAnimation {
            }
        }
    }
    Icons.MaterialFontIcon {
        id: iconElement

        anchors.right: parent.right
        anchors.rightMargin: Foundations.spacing.m
        anchors.verticalCenter: parent.verticalCenter
        color: root.contentColor
        font.pointSize: Foundations.font.size.m
        text: root.icon
    }
}
