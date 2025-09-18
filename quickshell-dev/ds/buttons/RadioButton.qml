import QtQuick
import QtQuick.Controls
import qs.ds

RadioButton {
    id: root

    // Computed color based on state
    property color currentColor: {
        if (!enabled)
            return disabledColor;
        if (checked || hovered || activeFocus)
            return focusColor;
        return defaultColor;
    }
    property color defaultColor: Foundations.palette.base07

    // Color properties for different states
    property color disabledColor: Foundations.palette.base04
    property color focusColor: Foundations.palette.base05

    contentItem: null

    indicator: Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        border.color: root.currentColor
        border.width: 2
        color: "transparent"
        implicitHeight: 20
        implicitWidth: 20
        radius: Foundations.radius.all

        Behavior on border.color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }

        // Inner dot for checked state
        Rectangle {
            anchors.centerIn: parent
            color: root.currentColor
            implicitHeight: 8
            implicitWidth: 8
            radius: Foundations.radius.all
            visible: root.checked
        }
    }
}
