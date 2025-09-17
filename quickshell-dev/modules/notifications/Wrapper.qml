import qs.config
import qs.services.notifications
import Quickshell
import QtQuick
import qs.ds.animations
import qs.modules.drawers

BackgroundWrapper {
    id: root

    property list<real> animCurve: Appearance.anim.curves.standard
    property int animLength: Appearance.anim.durations.normal
    readonly property bool hasCurrent: root.visibilities.notifications || isAutoMode
    readonly property real nonAnimWidth: hasCurrent ? content.implicitWidth : 0
    property bool isAutoMode: false
    required property var panels
    required property PersistentProperties visibilities

    clip: true
    implicitHeight: isAutoMode ? content.implicitHeight : parent.height
    implicitWidth: nonAnimWidth
    visible: height > 0

    focus: root.visibilities.notifications
    Keys.enabled: root.visibilities.notifications
    Keys.onEscapePressed: {
        root.visibilities.notifications = false;
        root.isAutoMode = false;
    }

    Connections {
        target: NotificationService
        
        function onPopupsChanged() {
            if (!root.visibilities.notifications) {
                if (NotificationService.popups.length > 0) {
                    root.isAutoMode = true;
                } else {
                    root.isAutoMode = false;
                }
            }
        }
    }
    
    Connections {
        target: root.visibilities
        
        function onNotificationsChanged() {
            if (root.visibilities.notifications) {
                root.isAutoMode = false;
            }
        }
    }

    Behavior on implicitWidth {
        BasicNumberAnimation {
        }
    }

    Content {
        id: content

        isAutoMode: root.isAutoMode
        opacity: (root.visibilities.notifications || root.isAutoMode) ? 1 : 0
        panels: root.panels
        visibilities: root.visibilities
        wrapper: root
    }
}
