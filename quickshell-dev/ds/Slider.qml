import QtQuick
import QtQuick.Controls
import qs.ds
import qs.services

Slider {
    id: root
    
    property color activeColor: Colours.palette.m3primary
    property color inactiveColor: Colours.palette.m3surfaceContainer
    property color handleColor: Colours.palette.m3primary
    
    // Expose hover state for child components
    readonly property alias handleHovered: mainInteraction.overHandle
    
    signal wheelUp()
    signal wheelDown()
    
    MouseArea {
        id: mainInteraction
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        
        property bool overHandle: {
            if (!containsMouse) return false;
            const handleX = root.handle.x;
            const handleWidth = root.handle.width;
            const localX = mouseX;
            return localX >= handleX && localX <= (handleX + handleWidth);
        }
        
        cursorShape: overHandle ? Qt.PointingHandCursor : Qt.ArrowCursor
        
        onWheel: event => {
            if (event.angleDelta.y > 0)
                root.wheelUp();
            else if (event.angleDelta.y < 0)
                root.wheelDown();
        }
    }
    
    background: Item {
        Rectangle {
            id: leftSide

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            
            implicitWidth: root.handle.x + root.handle.implicitWidth / 2
            
            color: root.activeColor
            radius: Foundations.radius.all
        }
        
        // Inactive track (right side)
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.topMargin: 11
            anchors.bottomMargin: 11
            
            implicitWidth: parent.width - leftSide.implicitWidth

            color: root.inactiveColor
            radius: Foundations.radius.all
        }
    }
    
    handle: Rectangle {

        property int size: root.pressed ? 32 : 28

        x: root.visualPosition * root.availableWidth - implicitWidth / 2
        implicitWidth: size
        implicitHeight: size

        anchors.verticalCenter: root.verticalCenter
        
        border.color: Colours.palette.m3surface
        border.width: 4

        color: root.handleColor

        radius: Foundations.radius.all
                
        Behavior on implicitWidth {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }
}