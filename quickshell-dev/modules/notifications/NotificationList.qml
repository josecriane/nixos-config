pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.ds.list as List
import qs.ds.animations
import qs.ds
import Quickshell
import QtQuick
import QtQuick.Controls

Item {
    id: root

    required property int padding
    required property var panels
    required property int rounding
    required property PersistentProperties visibilities
    required property var wrapper

    anchors.fill: parent
    implicitWidth: Config.notifs.sizes.width

    Flickable {
        anchors.fill: parent
        clip: true
        contentHeight: column.implicitHeight + root.padding
        contentWidth: width

        ScrollBar.vertical: List.ScrollBar {
        }

        Column {
            id: column

            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Appearance.spacing.small

            Repeater {
                model: NotificationService.list.length

                delegate: NotificationItem {
                    required property int index

                    modelData: NotificationService.list[index]
                    width: root.width - root.padding
                }
            }
        }
    }
}
