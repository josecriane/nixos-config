import QtQuick
import QtQuick.Controls
import qs.ds
import qs.services

TextField {
    id: root

    property color backgroundColor: "transparent"
    property color borderColor: Colours.palette.m3outline
    property real borderWidth: 1
    property color cursorColor: Colours.palette.m3primary
    property color focusBorderColor: Colours.palette.m3primary
    property color placeholderColor: Colours.palette.m3outline
    property color textColor: Colours.palette.m3onSurface

    bottomPadding: Foundations.spacing.s
    color: textColor
    cursorVisible: !readOnly
    font.family: Foundations.font.family.sans
    font.pointSize: Foundations.font.size.m
    leftPadding: Foundations.spacing.m
    placeholderTextColor: placeholderColor
    renderType: TextField.NativeRendering
    rightPadding: Foundations.spacing.m
    topPadding: Foundations.spacing.s

    background: Rectangle {
        border.color: root.activeFocus ? root.focusBorderColor : root.borderColor
        border.width: root.borderWidth
        color: root.backgroundColor
        radius: Foundations.radius.m

        Behavior on border.color {
            ColorAnimation {
                duration: 200
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
    cursorDelegate: Rectangle {
        id: cursor

        property bool disableBlink

        color: root.cursorColor
        implicitWidth: 2
        radius: Foundations.radius.s

        Behavior on opacity {
            NumberAnimation {
                duration: 150
                easing.type: Easing.InOutQuad
            }
        }

        Connections {
            function onCursorPositionChanged(): void {
                if (root.activeFocus && root.cursorVisible) {
                    cursor.opacity = 1;
                    cursor.disableBlink = true;
                    enableBlink.restart();
                }
            }

            target: root
        }
        Timer {
            id: enableBlink

            interval: 100

            onTriggered: cursor.disableBlink = false
        }
        Timer {
            interval: 500
            repeat: true
            running: root.activeFocus && root.cursorVisible && !cursor.disableBlink
            triggeredOnStart: true

            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }
        Binding {
            cursor.opacity: 0
            when: !root.activeFocus || !root.cursorVisible
        }
    }
    Behavior on placeholderTextColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
}
