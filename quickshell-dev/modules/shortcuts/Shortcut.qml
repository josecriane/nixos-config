import QtQuick

// GlobalShortcut disabled for non-Hyprland compositors
Item {
    property string description: ""
    // Stub properties for compatibility
    property string name: ""

    signal pressed
    signal released
}
