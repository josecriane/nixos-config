pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick

// Simplified wallpaper - just a solid color background
StyledRect {
    id: root
    
    anchors.fill: parent
    
    // Using a dark background color
    color: Colours.palette.m3surfaceContainer
}