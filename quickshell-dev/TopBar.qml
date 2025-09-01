import QtQuick
import Quickshell

PanelWindow {
    id: panel

    Style {
        id: style
    }

    anchors {
        left: true
        right: true
        top: true
    }
    implicitHeight: 40

    Rectangle {
        id: barBackground
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 40
        color: style.colors.surfaceVariant
        opacity: style.opacity.background

        Row {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 10
            }
            spacing: 15

            Text {
                text: "󰣇"
                color: style.colors.success
                font.pixelSize: 16
                font.family: style.fonts.emoji
            }

            Text {
                text: "Quickshell"
                color: style.colors.primary
                font.pixelSize: 14
                font.bold: true
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: timeText.width + 20
            height: 30
            color: style.colors.surfaceVariant
            radius: 15

            Text {
                id: timeText
                anchors.centerIn: parent
                text: new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
                color: style.colors.primary
                font.pixelSize: 13
                font.family: style.fonts.monospace

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: parent.text = new Date().toLocaleTimeString(Qt.locale(), "hh:mm")
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.timePopupVisible = !root.timePopupVisible;
                }
            }
        }

        Row {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 10
            }
            spacing: 10

            Text {
                text: "󰍛"
                color: style.colors.warning
                font.pixelSize: 16
                font.family: style.fonts.emoji

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Network clicked")
                }
            }

            Text {
                text: "󰕾"
                color: style.colors.accent
                font.pixelSize: 16
                font.family: style.fonts.emoji

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Audio clicked")
                }
            }

            Text {
                id: powerButton
                text: "󰐥"
                color: style.colors.error
                font.pixelSize: 16
                font.family: style.fonts.emoji

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Power button clicked, current visibility:", root.powerMenuVisible);
                        root.powerMenuVisible = !root.powerMenuVisible;
                        console.log("New visibility:", root.powerMenuVisible);
                    }
                }
            }
        }
    }
}
