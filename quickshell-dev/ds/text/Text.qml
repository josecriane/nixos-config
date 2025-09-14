import QtQuick
import qs.ds
import qs.services

Text {
    id: root
    
    // Color properties for different states
    property color disabledColor: Colours.palette.m3onSurfaceVariant
    property color defaultColor: Colours.palette.m3onSurface
    property color primaryColor: Colours.palette.m3primary
    
    // State properties
    property bool disabled: false
    property bool primary: false
    
    // Computed color based on state
    color: {
        if (disabled) return disabledColor;
        if (primary) return primaryColor;
        return defaultColor;
    }
    
    // Default font settings
    font.family: Foundations.font.family.sans
    font.pointSize: Foundations.font.size.xl
    font.weight: 400

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }
}