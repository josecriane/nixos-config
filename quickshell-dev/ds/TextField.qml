import QtQuick
import QtQuick.Controls
import qs.ds
import qs.services

TextField {
    id: root
    
    property color textColor: Colours.palette.m3onSurface
    property color placeholderColor: Colours.palette.m3outline
    property color cursorColor: Colours.palette.m3primary
    property color backgroundColor: "transparent"
    property color borderColor: Colours.palette.m3outline
    property color focusBorderColor: Colours.palette.m3primary
    property real borderWidth: 1
    
    color: textColor
    placeholderTextColor: placeholderColor
    font.family: Foundations.font.family.sans
    font.pointSize: Foundations.font.size.m
    renderType: TextField.NativeRendering
    cursorVisible: !readOnly
    
    leftPadding: Foundations.spacing.m
    rightPadding: Foundations.spacing.m
    topPadding: Foundations.spacing.s
    bottomPadding: Foundations.spacing.s
    
    background: Rectangle {
        color: root.backgroundColor
        radius: Foundations.radius.m
        border.width: root.borderWidth
        border.color: root.activeFocus ? root.focusBorderColor : root.borderColor
        
        Behavior on border.color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    cursorDelegate: Rectangle {
        id: cursor
        
        property bool disableBlink
        
        implicitWidth: 2
        color: root.cursorColor
        radius: Foundations.radius.s
        
        Connections {
            target: root
            
            function onCursorPositionChanged(): void {
                if (root.activeFocus && root.cursorVisible) {
                    cursor.opacity = 1;
                    cursor.disableBlink = true;
                    enableBlink.restart();
                }
            }
        }
        
        Timer {
            id: enableBlink
            
            interval: 100
            onTriggered: cursor.disableBlink = false
        }
        
        Timer {
            running: root.activeFocus && root.cursorVisible && !cursor.disableBlink
            repeat: true
            triggeredOnStart: true
            interval: 500
            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }
        
        Binding {
            when: !root.activeFocus || !root.cursorVisible
            cursor.opacity: 0
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    
    Behavior on placeholderTextColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
}