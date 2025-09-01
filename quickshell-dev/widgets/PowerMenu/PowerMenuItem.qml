import QtQuick
import "../.." as Root

// Component for power menu items
Rectangle {
    Root.Style {
        id: style
    }
    property string icon
    property string label
    signal clicked

    width: parent.width
    height: 35
    color: menuMouseArea.containsMouse ? style.colors.surface : "transparent"
    radius: style.radius.small

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 10

        Text {
            text: parent.parent.icon
            color: style.colors.error
            font.pixelSize: style.fonts.size.extraLarge
            font.family: style.fonts.emoji
        }

        Text {
            text: parent.parent.label
            color: style.colors.lighter
            font.pixelSize: style.fonts.size.normal
            font.family: style.fonts.monospace
        }
    }

    MouseArea {
        id: menuMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()
    }
}
