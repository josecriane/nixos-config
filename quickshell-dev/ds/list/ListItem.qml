import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import qs.ds
import qs.ds.buttons.circularButtons as CircularButtons
import qs.ds.buttons as DsButtons
import qs.ds.text as DsText
import qs.ds.icons as Icons
import qs.ds.animations
import qs.services

Item {
    id: root
    
    // Public properties
    property string leftIcon: ""
    property string imageIcon: ""  // For image-based icons (alternative to leftIcon)
    property string secondaryIcon: ""
    property string rightIcon: ""  // Font icon on the far right
    property string text: ""
    property color disabledForegroundColor: Colours.palette.m3onSurfaceVariant
    property color defaultForegroundColor: Colours.palette.m3onSurface
    property color selectedForegroundColor: Colours.palette.m3primary
    property int textWeight: 400

    property bool primaryActionActive: primaryFontIcon !== ""
    property string primaryFontIcon: ""
    property bool primaryActionLoading: false

    property bool secondaryActionActive: secondaryFontIcon !== ""
    property string secondaryFontIcon: ""
    property bool secondaryActionLoading: false
    
    property bool disabled: false
    property bool selected: false
    property bool clickable: false
    property bool keepEmptySpace: false  // Keep space for icons even if not present
    property real minimumHeight: 0  // Minimum height for the list item
    property ButtonGroup buttonGroup: null
    
    property color foregroundColor: disabled ? disabledForegroundColor : (selected ? selectedForegroundColor : defaultForegroundColor)
    readonly property bool isClickable: clickable || buttonGroup !== null

    // Signals
    signal clicked()
    signal primaryActionClicked()
    signal secondaryActionClicked()
    
    // Layout properties for when used in a Layout
    Layout.fillWidth: true
    Layout.rightMargin: Foundations.spacing.s
    
    implicitHeight: Math.max(content.implicitHeight, minimumHeight)
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
    
    // Ripple effect background for clickable items
    Loader {
        active: root.isClickable
        anchors.fill: parent
        z: 0  // Behind content
        
        sourceComponent: Component {
            InteractiveArea {
                disabled: root.disabled
                color: root.foregroundColor
                radius: Foundations.radius.xs
                
                function onClicked(event): void {
                    // Check if click is on action buttons area
                    const buttonAreaWidth = 80; // Approximate width of button area
                    if (event.x > width - buttonAreaWidth) {
                        return; // Don't handle clicks on button area
                    }
                    
                    if (root.buttonGroup) {
                        root.selected = true;
                    }
                    root.clicked();
                }
            }
        }
    }
    
    RowLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Foundations.spacing.m
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
        Loader {
            active: (root.leftIcon !== "" || root.imageIcon !== "" || root.keepEmptySpace) && root.buttonGroup === null
            
            sourceComponent: {
                if (root.imageIcon !== "") return imageIconComponent;
                if (root.leftIcon !== "") return fontIconComponent;
                if (root.keepEmptySpace) return emptySpaceComponent;
                return null;
            }
        }
        
        Component {
            id: fontIconComponent
            Icons.MaterialFontIcon {
                text: root.leftIcon
                color: root.foregroundColor
            }
        }
        
        Component {
            id: imageIconComponent
            IconImage {
                source: root.imageIcon
                implicitWidth: Foundations.font.size.m
                implicitHeight: Foundations.font.size.m
                asynchronous: true
            }
        }
        
        Component {
            id: emptySpaceComponent
            Item {
                implicitWidth: Foundations.font.size.m
                implicitHeight: Foundations.font.size.m
            }
        }
        
        // Secondary icon (like lock icon)
        Icons.MaterialFontIcon {
            visible: root.secondaryIcon !== ""
            text: root.secondaryIcon
            color: root.foregroundColor
        }
        
        // Main text
        Item {
            Layout.leftMargin: Foundations.spacing.xs
            Layout.rightMargin: Foundations.spacing.xs
            Layout.fillWidth: true
            implicitHeight: textLabel.implicitHeight
            implicitWidth: textLabel.implicitWidth
            
            DsText.BodyS {
                id: textLabel

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                
                text: root.text
                elide: Text.ElideRight
                font.weight: root.selected ? 500 : root.textWeight
                color: root.foregroundColor
            }
        }
        
        // Primary action button
        CircularButtons.CircularButton {
            visible: root.primaryFontIcon !== ""
            icon: root.primaryFontIcon
            foregroundColor: root.selectedForegroundColor
            activeBackgroundColor: root.selectedForegroundColor
            active: root.primaryActionActive
            disabled: root.disabled
            loading: root.primaryActionLoading
            
            onClicked: root.primaryActionClicked()
        }
        
        // Secondary action button
        CircularButtons.CircularButton {
            visible: root.secondaryFontIcon !== ""
            icon: root.secondaryFontIcon
            foregroundColor: root.selectedForegroundColor
            activeBackgroundColor: root.selectedForegroundColor
            active: root.secondaryActionActive
            disabled: root.disabled
            loading: root.secondaryActionLoading
            
            onClicked: root.secondaryActionClicked()
        }
        
        // Right icon (font icon on far right)
        Icons.MaterialFontIcon {
            visible: root.rightIcon !== ""
            text: root.rightIcon
            color: root.foregroundColor
        }
    }
}