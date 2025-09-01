import QtQuick
import QtQuick.Shapes
import Quickshell

// Reusable container that adds padding to the sides of any PanelWindow
PanelWindow {
    id: root

    Style {
        id: style
    }
    
    readonly property int __sidePadding: backgroundRadius

    property alias content: contentLoader.sourceComponent
    property color backgroundColor: style.colors.surfaceVariant
    property real backgroundOpacity: style.opacity.background
    property real backgroundRadius: style.radius.normal
    
    implicitWidth: contentLoader.implicitWidth + __sidePadding * 2
    implicitHeight: contentLoader.implicitHeight
    
    margins.top: 0
    color: "transparent"
    exclusiveZone: 0
    
    Shape {
        opacity: root.backgroundOpacity
        
        ShapePath {
            strokeWidth: -1
            fillColor: root.backgroundColor
            
            PathMove { x: 0; y: 0 }
            
            PathLine { x: __sidePadding; y: 0 }
            
            PathLine { x: __sidePadding; y: __sidePadding }
            
            PathArc {
                x: 0
                y: 0
                radiusX: root.backgroundRadius
                radiusY: root.backgroundRadius
                direction: PathArc.Counterclockwise
            }
        }
    }

    Shape {
        opacity: root.backgroundOpacity
        
        ShapePath {
            strokeWidth: -1
            fillColor: root.backgroundColor

            PathMove { x: root.implicitWidth - root.__sidePadding; y: 0 }

            PathLine { x: root.implicitWidth; y: 0 }

            PathArc {
                x: root.implicitWidth - root.__sidePadding
                y: root.__sidePadding
                radiusX: root.backgroundRadius
                radiusY: root.backgroundRadius
                direction: PathArc.Counterclockwise
            }
        }
    }
    
    Loader {
        id: contentLoader
        anchors.centerIn: parent
    }
}