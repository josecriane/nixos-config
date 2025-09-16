import QtQuick

QtObject {
    property string name: ""
    property string subtitle: ""
    property bool isApp: false
    property bool isAction: false
    property string appIcon: ""      // For app icons
    property string fontIcon: ""     // For font/material icons
    property var onActivate: null    // Function to execute when clicked - returns true to close launcher, false to keep open
    property var originalData: null  // Store original DesktopEntry or Action
    property string autocompleteText: ""  // Text to autocomplete when activated (for actions)
}