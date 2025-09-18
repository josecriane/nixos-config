import QtQuick
import QtQuick.Controls
import qs.ds
import qs.services

Switch {
    id: root

    property color activeBorderColor: activeColor
    property color activeColor: Foundations.palette.base05
    property color activeThumbColor: Foundations.palette.base03
    property color inactiveBorderColor: Foundations.palette.base0D
    property color inactiveColor: Foundations.palette.base04
    property color inactiveThumbColor: Foundations.palette.base0D

    implicitHeight: 25
    implicitWidth: 41

    // Track
    background: Rectangle {
        border.color: root.checked ? root.activeBorderColor : root.inactiveBorderColor
        border.width: 2
        color: root.checked ? root.activeColor : root.inactiveColor
        height: parent.height
        radius: Foundations.radius.all
        width: parent.width

        Behavior on border.color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    // Thumb
    indicator: Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: {
            if (root.checked) {
                return (root.pressed || root.down) ? 18 : 20;
            } else {
                return (root.pressed || root.down) ? 2 : 6;
            }
        }
        anchors.verticalCenter: parent.verticalCenter
        color: root.checked ? root.activeThumbColor : root.inactiveThumbColor
        height: width
        radius: Foundations.radius.all
        width: {
            if (root.pressed || root.down)
                return 22;
            if (root.checked)
                return 19;
            return 12;
        }

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }
}
