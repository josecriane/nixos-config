import QtQuick

QtObject {
    property string appIcon: ""      // For app icons
    property string autocompleteText: ""  // Text to autocomplete when activated (for actions)
    property string fontIcon: ""     // For font/material icons
    property bool isAction: false
    property bool isApp: false
    property string name: ""
    property var onActivate: null    // Function to execute when clicked - returns true to close launcher, false to keep open
    property var originalData: null  // Store original DesktopEntry or Action
    property string subtitle: ""
}
