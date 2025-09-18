pragma ComponentBehavior: Bound

import qs.services as Services
import qs.ds
import qs.ds as Ds
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    property bool isAutoMode: false
    required property var panels
    required property PersistentProperties visibilities
    required property var wrapper

    readonly property int padding: Foundations.spacing.s
    
    readonly property int autoModeHeight: list.contentHeight - padding

    anchors.right: parent.right
    anchors.top: parent.top
    implicitWidth: listWrapper.width + padding * 2
    
    states: [
        State {
            name: "autoMode"
            when: isAutoMode
            PropertyChanges {
                target: root
                height: autoModeHeight
            }
        },
        State {
            name: "normalMode"  
            when: !isAutoMode
            PropertyChanges {
                target: root
                height: parent.height
            }
        }
    ]

    Item {
        id: listWrapper

        anchors.right: parent.right
        anchors.rightMargin: root.padding
        anchors.top: parent.top
        anchors.topMargin: root.padding
        anchors.bottom: root.isAutoMode ? undefined : parent.bottom
        height: root.isAutoMode ? list.contentHeight : undefined
        implicitWidth: list.width

        NotificationList {
            id: list

            isAutoMode: root.isAutoMode
            padding: root.padding
            panels: root.panels
            visibilities: root.visibilities
            wrapper: root.wrapper
        }
    }
}
