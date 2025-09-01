import QtQuick
import QtQuick.Shapes
import Quickshell
import "." as Local
import "widgets/PowerMenu" as PowerMenuWidget

ShellRoot {
    id: root

    property bool powerMenuVisible: false
    property bool timePopupVisible: false

    TopBar {
        id: topBar
    }

    Local.SidePaddingContainer {
        visible: root.powerMenuVisible
        
        anchors {
            top: true
            right: true
        }
        
        content: PowerMenuWidget.PowerMenuContent {}
    }
    
    Local.SidePaddingContainer {
        id: timePopupContainer
        visible: root.timePopupVisible

        anchors {
            top: true
        }

        content: Local.TimePopup {}
    }
}