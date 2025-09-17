pragma ComponentBehavior: Bound

import qs.services as Services
import qs.config
import qs.ds as Ds
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    property bool isAutoMode: false
    readonly property int padding: Appearance.padding.normal
    required property var panels
    readonly property int rounding: Appearance.rounding.large
    required property PersistentProperties visibilities
    required property var wrapper
    
    readonly property int autoModeHeight: list.contentHeight - padding

    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitHeight: isAutoMode ? autoModeHeight : parent.height
    implicitWidth: listWrapper.width + padding * 2

    Item {
        id: listWrapper

        anchors.right: parent.right
        anchors.rightMargin: root.padding
        anchors.top: parent.top
        anchors.topMargin: root.padding
        anchors.bottom: parent.bottom
        implicitHeight: root.isAutoMode ? autoModeHeight : parent.height
        implicitWidth: list.width

        NotificationList {
            id: list

            isAutoMode: root.isAutoMode
            padding: root.padding
            panels: root.panels
            rounding: root.rounding
            visibilities: root.visibilities
            wrapper: root.wrapper
        }
    }
}
