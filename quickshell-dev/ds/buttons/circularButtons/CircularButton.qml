import ".."
import QtQuick
import qs.ds.progress
import qs.services
import qs.ds
import qs.ds.icons as Icons

Rectangle {
    id: root

    property bool active: false
    property color activeBackgroundColor: Foundations.palette.base05
    property color activeForegroundColor: Foundations.palette.base03
    property color backgroundColor: "transparent"
    property bool disabled: false
    property color foregroundColor: Foundations.palette.base07

    // Public properties
    property string icon: ""
    property bool loading: false
    property real size: Foundations.spacing.l * 2

    signal clicked

    color: root.active ? root.activeBackgroundColor : root.backgroundColor
    implicitHeight: root.size

    // Layout
    implicitWidth: root.size
    radius: Foundations.radius.all

    // Color transitions
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    CircularProgressIndicator {
        anchors.fill: parent
        running: root.loading
        strokeWidth: 2
        visible: root.loading
    }
    InteractiveArea {
        function onClicked(): void {
            root.clicked();
        }

        color: root.active ? root.activeForegroundColor : root.foregroundColor
        disabled: root.disabled || root.loading
    }

    // Icon
    Icons.MaterialFontIcon {
        anchors.centerIn: parent
        animate: true
        color: root.active ? root.activeForegroundColor : root.foregroundColor
        opacity: root.loading ? 0 : 1
        text: root.icon

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
