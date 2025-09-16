import QtQuick
import QtQuick.Controls
import qs.ds

RadioButton {
    id: root

    // Color properties for different states
    property color disabledColor: Colours.palette.m3onSurfaceVariant
    property color defaultColor: Colours.palette.m3onSurface
    property color focusColor: Colours.palette.m3primary

    // Computed color based on state
    property color currentColor: {
        if (!enabled)
            return disabledColor;
        if (checked || hovered || activeFocus)
            return focusColor;
        return defaultColor;
    }

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20

        radius: Foundations.radius.all
        color: "transparent"
        border.width: 2
        border.color: root.currentColor

        anchors.verticalCenter: parent.verticalCenter

        // Inner dot for checked state
        Rectangle {
            anchors.centerIn: parent
            implicitWidth: 8
            implicitHeight: 8

            radius: Foundations.radius.all
            color: root.currentColor

            visible: root.checked
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }

    contentItem: null
}
