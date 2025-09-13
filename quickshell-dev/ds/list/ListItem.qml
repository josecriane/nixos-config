import QtQuick
import QtQuick.Layouts
import qs.components
import qs.components.controls
import qs.ds
import qs.ds.buttons.circularButtons as CircularButtons
import qs.services

RowLayout {
    id: root
    
    // Public properties
    property string leftIcon: ""
    property string secondaryIcon: ""
    property string text: ""
    property color disabledForegroundColor: Colours.palette.m3onSurfaceVariant
    property color defaultForegroundColor: Colours.palette.m3onSurface
    property color selectedForegroundColor: Colours.palette.m3primary
    property int textWeight: 400

    property bool primaryActionActive: primaryActionIcon !== ""
    property string primaryActionIcon: ""
    property bool primaryActionLoading: false

    property bool secondaryActionActive: secondaryActionIcon !== ""
    property string secondaryActionIcon: ""
    property bool secondaryActionLoading: false
    
    property bool disabled: false
    property bool selected: false
    
    property color foregroundColor: disabled ? disabledForegroundColor : (selected ? selectedForegroundColor : defaultForegroundColor)

    // Signals
    signal primaryActionClicked()
    signal secondaryActionClicked()
    
    // Layout
    Layout.fillWidth: true
    Layout.rightMargin: Foundations.spacing.s
    spacing: Foundations.spacing.s
    
    // Entry animation
    opacity: 0
    
    Component.onCompleted: {
        opacity = 1;
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuart
        }
    }
    
    // Left icon
    MaterialIcon {
        visible: root.leftIcon !== ""
        text: root.leftIcon
        color: root.foregroundColor
    }
    
    // Secondary icon (like lock icon)
    MaterialIcon {
        visible: root.secondaryIcon !== ""
        text: root.secondaryIcon
        color: root.foregroundColor
    }
    
    // Main text
    StyledText {
        Layout.leftMargin: Foundations.spacing.xs
        Layout.rightMargin: Foundations.spacing.xs
        Layout.fillWidth: true
        text: root.text
        elide: Text.ElideRight
        font.weight: root.selected ? 500 : root.textWeight
        color: root.foregroundColor
    }
    
    // Primary action button
    CircularButtons.CircularButton {
        visible: root.primaryActionIcon !== ""
        icon: root.primaryActionIcon
        foregroundColor: root.selectedForegroundColor
        activeBackgroundColor: root.selectedForegroundColor
        active: root.primaryActionActive
        disabled: root.disabled
        loading: root.primaryActionLoading
        
        onClicked: root.primaryActionClicked()
    }
    
    // Secondary action button
    CircularButtons.CircularButton {
        visible: root.secondaryActionIcon !== ""
        icon: root.secondaryActionIcon
        foregroundColor: root.selectedForegroundColor
        activeBackgroundColor: root.selectedForegroundColor
        active: root.secondaryActionActive
        disabled: root.disabled
        loading: root.secondaryActionLoading
        
        onClicked: root.secondaryActionClicked()
    }
}