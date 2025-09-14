import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components
import qs.components.controls
import qs.ds
import qs.ds.buttons.circularButtons as CircularButtons
import qs.ds.buttons as DsButtons
import qs.ds.text as DsText
import qs.services

Item {
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
    property ButtonGroup buttonGroup: null
    
    property color foregroundColor: disabled ? disabledForegroundColor : (selected ? selectedForegroundColor : defaultForegroundColor)

    // Signals
    signal clicked()
    signal primaryActionClicked()
    signal secondaryActionClicked()
    
    // Layout properties for when used in a Layout
    Layout.fillWidth: true
    Layout.rightMargin: Foundations.spacing.s
    
    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth
    
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
    
    // MouseArea for clickable items
    MouseArea {
        anchors.fill: parent
        enabled: !root.disabled
        z: 1  // Above content but below action buttons
        
        onClicked: {
            if (root.buttonGroup) {
                root.selected = true;
            }
            root.clicked();
        }
    }
    
    RowLayout {
        id: content
        anchors.fill: parent
        spacing: Foundations.spacing.s
        
        // Radio button (if buttonGroup is set)
        DsButtons.RadioButton {
            visible: root.buttonGroup !== null
            checked: root.selected
            enabled: !root.disabled
            ButtonGroup.group: root.buttonGroup
            disabledColor: root.disabledForegroundColor
            defaultColor: root.defaultForegroundColor
            focusColor: root.selectedForegroundColor
            
            onClicked: {
                root.selected = true;
                root.clicked();
            }
        }
        
        // Left icon (if no buttonGroup)
        MaterialIcon {
            visible: root.leftIcon !== "" && root.buttonGroup === null
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
        DsText.BodyM {
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
            z: 2  // Above MouseArea
            
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
            z: 2  // Above MouseArea
            
            onClicked: root.secondaryActionClicked()
        }
    }
}