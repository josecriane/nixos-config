pragma ComponentBehavior: Bound

import qs.services as Services
import qs.config
import qs.ds as Ds
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    readonly property int padding: Appearance.padding.normal
    required property var panels
    readonly property int rounding: Appearance.rounding.large
    required property PersistentProperties visibilities
    required property var wrapper

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    implicitHeight: listWrapper.height + padding * 2
    implicitWidth: listWrapper.width + padding * 2

    Behavior on implicitHeight {
        enabled: false
    }

    Item {
        id: listWrapper

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.padding
        implicitHeight: list.height + root.padding
        implicitWidth: list.width

        NotificationList {
            id: list

            padding: root.padding
            panels: root.panels
            rounding: root.rounding
            visibilities: root.visibilities
            wrapper: root.wrapper
        }
    }
}
