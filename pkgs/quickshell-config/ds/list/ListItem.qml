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

    property ButtonGroup buttonGroup: null
    property bool clickable: false
    property color defaultForegroundColor: Foundations.palette.base07
    property bool disabled: false
    property color disabledForegroundColor: Foundations.palette.base04
    property color foregroundColor: disabled ? disabledForegroundColor : (selected ? selectedForegroundColor : defaultForegroundColor)
    property string imageIcon: ""  // For image-based icons (alternative to leftIcon)
    readonly property bool isClickable: clickable || buttonGroup !== null
    property bool keepEmptySpace: false  // Keep space for icons even if not present

    // Public properties
    property string leftIcon: ""
    property real minimumHeight: 0  // Minimum height for the list item
    property bool primaryActionActive: primaryFontIcon !== ""
    property bool primaryActionLoading: false
    property string primaryFontIcon: ""
    property string rightIcon: ""  // Font icon on the far right
    property bool secondaryActionActive: secondaryFontIcon !== ""
    property bool secondaryActionLoading: false
    property string secondaryFontIcon: ""
    property string secondaryIcon: ""
    property bool selected: false
    property color selectedForegroundColor: Foundations.palette.base05
    property string text: ""
    property int textWeight: 400

    // Signals
    signal clicked
    signal primaryActionClicked
    signal secondaryActionClicked

    // Layout properties for when used in a Layout
    Layout.fillWidth: true
    Layout.rightMargin: Foundations.spacing.s
    implicitHeight: Math.max(content.implicitHeight, minimumHeight)
    implicitWidth: content.implicitWidth

    // Entry animation
    opacity: 0

    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuart
        }
    }

    Component.onCompleted: {
        opacity = 1;
    }

    // Ripple effect background for clickable items
    Loader {
        active: root.isClickable
        anchors.fill: parent
        z: 0  // Behind content

        sourceComponent: Component {
            InteractiveArea {
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

                color: root.foregroundColor
                disabled: root.disabled
                radius: Foundations.radius.xs
            }
        }
    }
    RowLayout {
        id: content

        anchors.left: parent.left
        anchors.leftMargin: Foundations.spacing.m
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: Foundations.spacing.s

        // Radio button (if buttonGroup is set)
        DsButtons.RadioButton {
            ButtonGroup.group: root.buttonGroup
            checked: root.selected
            defaultColor: root.defaultForegroundColor
            disabledColor: root.disabledForegroundColor
            enabled: !root.disabled
            focusColor: root.selectedForegroundColor
            visible: root.buttonGroup !== null

            onClicked: {
                root.selected = true;
                root.clicked();
            }
        }

        // Left icon (if no buttonGroup)
        Loader {
            active: (root.leftIcon !== "" || root.imageIcon !== "" || root.keepEmptySpace) && root.buttonGroup === null
            sourceComponent: {
                if (root.imageIcon !== "")
                    return imageIconComponent;
                if (root.leftIcon !== "")
                    return fontIconComponent;
                if (root.keepEmptySpace)
                    return emptySpaceComponent;
                return null;
            }
        }
        Component {
            id: fontIconComponent

            Icons.MaterialFontIcon {
                color: root.foregroundColor
                text: root.leftIcon
            }
        }
        Component {
            id: imageIconComponent

            IconImage {
                asynchronous: true
                implicitHeight: Foundations.font.size.m
                implicitWidth: Foundations.font.size.m
                source: root.imageIcon
            }
        }
        Component {
            id: emptySpaceComponent

            Item {
                implicitHeight: Foundations.font.size.m
                implicitWidth: Foundations.font.size.m
            }
        }

        // Secondary icon (like lock icon)
        Icons.MaterialFontIcon {
            color: root.foregroundColor
            text: root.secondaryIcon
            visible: root.secondaryIcon !== ""
        }

        // Main text
        Item {
            Layout.fillWidth: true
            Layout.leftMargin: Foundations.spacing.xs
            Layout.rightMargin: Foundations.spacing.xs
            implicitHeight: textLabel.implicitHeight
            implicitWidth: textLabel.implicitWidth

            DsText.BodyS {
                id: textLabel

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: root.foregroundColor
                elide: Text.ElideRight
                font.weight: root.selected ? 500 : root.textWeight
                text: root.text
            }
        }

        // Primary action button
        CircularButtons.CircularButton {
            active: root.primaryActionActive
            activeBackgroundColor: root.selectedForegroundColor
            disabled: root.disabled
            foregroundColor: root.selectedForegroundColor
            icon: root.primaryFontIcon
            loading: root.primaryActionLoading
            visible: root.primaryFontIcon !== ""

            onClicked: root.primaryActionClicked()
        }

        // Secondary action button
        CircularButtons.CircularButton {
            active: root.secondaryActionActive
            activeBackgroundColor: root.selectedForegroundColor
            disabled: root.disabled
            foregroundColor: root.selectedForegroundColor
            icon: root.secondaryFontIcon
            loading: root.secondaryActionLoading
            visible: root.secondaryFontIcon !== ""

            onClicked: root.secondaryActionClicked()
        }

        // Right icon (font icon on far right)
        Icons.MaterialFontIcon {
            color: root.foregroundColor
            text: root.rightIcon
            visible: root.rightIcon !== ""
        }
    }
}
