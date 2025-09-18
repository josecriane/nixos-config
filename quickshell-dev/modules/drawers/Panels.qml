import qs.ds
import qs.modules.osd as Osd
import qs.modules.notifications as NotificationsList
import qs.modules.session as Session
import qs.modules.launcher as Launcher
import qs.modules.popups as Popups
import Quickshell
import QtQuick

Item {
    id: root

    required property Item bar
    readonly property Launcher.Wrapper launcher: launcher
    readonly property NotificationsList.Wrapper notifications: notifications
    readonly property Osd.Wrapper osd: osd
    readonly property Popups.Wrapper popouts: popouts
    required property ShellScreen screen
    readonly property Session.Wrapper session: session
    required property PersistentProperties visibilities
    required property int margin

    anchors.fill: parent
    anchors.margins: margin
    anchors.topMargin: bar.implicitHeight

    Osd.Wrapper {
        id: osd

        anchors.right: parent.right
        anchors.rightMargin: session.width
        anchors.verticalCenter: parent.verticalCenter
        clip: root.visibilities.session
        screen: root.screen
        visibilities: root.visibilities
    }
    Session.Wrapper {
        id: session

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        visibilities: root.visibilities
    }
    Launcher.Wrapper {
        id: launcher

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        panels: root
        visibilities: root.visibilities
    }
    NotificationsList.Wrapper {
        id: notifications

        anchors.right: parent.right
        anchors.top: parent.top
        panels: root
        visibilities: root.visibilities
    }
    Popups.Wrapper {
        id: popouts

        screen: root.screen
        x: {
            const off = currentCenter - root.margin - nonAnimWidth / 2;
            const diff = root.width - Math.floor(off + nonAnimWidth);
            if (diff < 0)
                return off + diff;
            return Math.max(off, 0);
        }
        y: 0
    }
}
