pragma ComponentBehavior: Bound

// import Caelestia // Removed Caelestia dependency
import Quickshell.Widgets
import QtQuick

IconImage {
    id: root

    required property color colour
    property color dominantColour: colour // Use provided colour as dominant

    asynchronous: true

    layer.enabled: true
    layer.effect: Colouriser {
        sourceColor: root.dominantColour
        colorizationColor: root.colour
    }
}