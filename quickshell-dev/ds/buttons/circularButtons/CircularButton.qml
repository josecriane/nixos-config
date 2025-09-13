import QtQuick
import qs.components
import qs.components.controls
import qs.services
import qs.ds

StyledRect {
    id: root
    
    // Public properties
    property string icon: ""
    property color backgroundColor: "transparent"
    property color foregroundColor: Colours.palette.m3onSurface
    property color activeBackgroundColor: Colours.palette.m3primary
    property color activeForegroundColor: Colours.palette.m3onPrimary
    property bool active: false
    property bool disabled: false
    property bool loading: false
    property real size: Foundations.spacing.l * 2
    
    signal clicked()
    
    // Layout
    implicitWidth: root.size
    implicitHeight: root.size
    
    radius: Foundations.radius.all
    color: root.active ? root.activeBackgroundColor : root.backgroundColor
    
    // Loading indicator
    StyledBusyIndicator {
        visible: root.loading
        anchors.fill: parent
        running: root.loading
        strokeWidth: 2
        bgColour: "transparent"
    }
    
    // Interaction layer
    StateLayer {
        color: root.active ? root.activeForegroundColor : root.foregroundColor
        disabled: root.disabled || root.loading
        
        function onClicked(): void {
            root.clicked();
        }
    }
    
    // Icon
    MaterialIcon {
        anchors.centerIn: parent
        animate: true
        text: root.icon
        color: root.active ? root.activeForegroundColor : root.foregroundColor
        opacity: root.loading ? 0 : 1
        
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    // Color transitions
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }
}