import QtQuick
import QtQuick.Shapes
import Quickshell
import "../.." as Root

// Power menu as a separate panel that doesn't push windows
PanelWindow {
    id: powerMenu

    Root.Style {
        id: style
    }

    visible: root.powerMenuVisible
    color: "transparent"
    
    exclusiveZone: 0
    
    anchors {
        top: true
        right: true
        left: false
        bottom: false
    }
    
    margins.top: 0
    margins.right: 10
    
    implicitWidth: 200
    implicitHeight: powerColumn.height + 20
    
    Rectangle {
        anchors.fill: parent
        color: style.colors.surfaceVariant
        radius: style.radius.normal
        opacity: style.opacity.background
    }
    
    Item {
        anchors.fill: parent
        
        Column {
            id: powerColumn
            anchors.centerIn: parent
            spacing: 5
            width: parent.width - 20
            
            PowerMenuItem {
                icon: "󰍃"
                label: "Logout"
                onClicked: {
                    root.powerMenuVisible = false;
                    Quickshell.execDetached(["loginctl", "terminate-session", "self"]);
                }
            }
            
            PowerMenuItem {
                icon: "󰐥"
                label: "Shutdown"
                onClicked: {
                    root.powerMenuVisible = false;
                    Quickshell.execDetached(["systemctl", "poweroff"]);
                }
            }
            
            PowerMenuItem {
                icon: "󰜉"
                label: "Reboot"
                onClicked: {
                    root.powerMenuVisible = false;
                    Quickshell.execDetached(["systemctl", "reboot"]);
                }
            }
            
            PowerMenuItem {
                icon: "󰒲"
                label: "Suspend"
                onClicked: {
                    root.powerMenuVisible = false;
                    Quickshell.execDetached(["systemctl", "suspend"]);
                }
            }
            
            PowerMenuItem {
                icon: "󰤄"
                label: "Hibernate"
                onClicked: {
                    root.powerMenuVisible = false;
                    Quickshell.execDetached(["systemctl", "hibernate"]);
                }
            }
            
            PowerMenuItem {
                icon: "󰌾"
                label: "Lock"
                onClicked: {
                    root.powerMenuVisible = false;
                    Quickshell.execDetached(["swaylock"]);
                }
            }
        }
    }
}