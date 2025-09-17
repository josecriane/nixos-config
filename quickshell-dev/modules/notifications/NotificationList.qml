pragma ComponentBehavior: Bound

import qs.services as Services
import qs.config
import qs.ds.list as List
import qs.ds.animations
import qs.ds
import Quickshell
import QtQuick
import QtQuick.Controls

Item {
    id: root

    property int itemHeight: 100
    property int maxShown: 6
    required property int padding
    required property var panels
    required property int rounding
    required property PersistentProperties visibilities
    required property var wrapper

    implicitHeight: Math.min(column.implicitHeight, maxShown * (itemHeight + Appearance.spacing.small)) + padding
    implicitWidth: Config.notifs.sizes.width

    Flickable {
        anchors.fill: parent
        clip: true
        contentHeight: column.implicitHeight
        contentWidth: width

        ScrollBar.vertical: List.ScrollBar {
        }

        Column {
            id: column

            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Appearance.spacing.small

            Repeater {
                model: Services.NotificationService.list.length

                delegate: NotificationItem {
                    required property int index

                    modelData: Services.NotificationService.list[index]
                    width: root.width - root.padding
                }
            }
        }
    }
}
