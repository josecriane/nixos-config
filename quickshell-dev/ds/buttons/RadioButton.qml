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
    property color defaultColor: Colours.palette.m3onSurface

    // Color properties for different states
    property color disabledColor: Colours.palette.m3onSurfaceVariant
    property color focusColor: Colours.palette.m3primary

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
