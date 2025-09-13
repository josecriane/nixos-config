import QtQuick

QtObject {
    property string name: ""
    property string subtitle: ""
    property bool isApp: false
    property bool isAction: false
    property string appIcon: ""      // For app icons
    property string actionIcon: ""   // For action/material icons
    property var onActivate: null    // Function to execute when clicked
    property var originalData: null  // Store original DesktopEntry or Action
    property bool closeLauncher: true  // Whether to close launcher after activation
}