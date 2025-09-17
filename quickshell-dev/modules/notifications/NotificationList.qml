pragma ComponentBehavior: Bound

import qs.services.notifications
import qs.config
import qs.ds.list as List
import qs.ds.animations
import qs.ds
import qs.ds.buttons as Buttons
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    required property int padding
    required property var panels
    required property int rounding
    required property PersistentProperties visibilities
    required property var wrapper

    anchors.fill: parent
    implicitWidth: 400

    ColumnLayout {
        anchors.fill: parent
        spacing: Appearance.spacing.small

        Buttons.HintButton {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: root.padding
            Layout.topMargin: root.padding
            
            hint: "Clear all notifications"
            icon: "delete"
            
            onClicked: {
                NotificationService.deleteAllNotifications();
            }
        }

        Flickable {
            Layout.fillHeight: true
            Layout.fillWidth: true
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
}
