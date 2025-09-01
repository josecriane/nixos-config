import QtQuick
import Quickshell
import "../.." as Root

// Power menu content without PanelWindow wrapper
Rectangle {
    id: powerMenuContent

    Root.Style {
        id: style
    }

    width: 200
    height: powerColumn.height + 20
    
    color: style.colors.surfaceVariant
    radius: style.radius.normal
    opacity: style.opacity.background
    
    // Cover top corners to make them straight
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: style.radius.normal
        color: parent.color
        opacity: parent.opacity
    }
    
    // Container for menu items
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