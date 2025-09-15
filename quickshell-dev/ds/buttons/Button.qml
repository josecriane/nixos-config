import QtQuick
import QtQuick.Layouts
import qs.components
import qs.ds.progress
import qs.ds
import qs.ds.text as Text
import qs.ds.icons as Icons
import qs.services

Rectangle {
    id: root
    
    property string text: ""
    property string leftIcon: ""
    property string rightIcon: ""
    property color backgroundColor: Colours.palette.m3primaryContainer
    property color foregroundColor: Colours.palette.m3onPrimaryContainer
    property bool disabled: false
    property bool loading: false

    readonly property int margin: Foundations.spacing.s
    readonly property int animDuration: 200
    
    signal clicked()
    
    implicitHeight: contentLayout.implicitHeight + margin * 2
    implicitWidth: contentLayout.implicitWidth + margin * 2
    
    radius: Foundations.radius.xs
    color: backgroundColor
    
    StateLayer {
        color: foregroundColor
        disabled: root.disabled || root.loading
        
        function onClicked(): void {
            root.clicked();
        }
    }
    
    // Content
    RowLayout {
        id: contentLayout
        
        anchors.centerIn: parent
        spacing: Foundations.spacing.xs
        opacity: root.loading ? 0 : 1
        
        Icons.MaterialFontIcon {
            visible: root.leftIcon !== ""
            text: root.leftIcon
            color: root.foregroundColor
            animate: true
        }
        
        Text.BodyM {
            visible: root.text !== ""
            text: root.text
            color: root.foregroundColor
        }

        Icons.MaterialFontIcon {
            visible: root.rightIcon !== ""
            text: root.rightIcon
            color: root.foregroundColor
            animate: true
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: root.animDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
    
    CircularProgressIndicator {
        visible: root.loading
        anchors.centerIn: parent
        strokeWidth:  2
        implicitHeight: parent.implicitHeight - 20
        running: root.loading
    }
}