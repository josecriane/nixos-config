import QtQuick

Rectangle {
    id: root
    
    Style { id: style }
    
    width: 200
    height: 200
    color: style.colors.surfaceVariant
    opacity: style.opacity.background
    radius: 12
    
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 12
        color: parent.color
    }
    
    Text {
        anchors.centerIn: parent
        text: "Time Widget\n200x200px"
        color: style.colors.primary
        font.pixelSize: 16
        font.family: style.fonts.monospace
        horizontalAlignment: Text.AlignHCenter
    }
}