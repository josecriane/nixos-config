import QtQuick

// GlobalShortcut disabled for non-Hyprland compositors
Item {
    // Stub properties for compatibility
    property string name: ""
    property string description: ""

    signal pressed
    signal released
}
