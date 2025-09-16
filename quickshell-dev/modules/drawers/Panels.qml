import qs.config
import qs.modules.osd as Osd
import qs.modules.notifications as Notifications
import qs.modules.session as Session
import qs.modules.launcher as Launcher
import qs.modules.bar.popouts as BarPopouts
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property Item bar

    readonly property Osd.Wrapper osd: osd
    readonly property Notifications.Wrapper notifications: notifications
    readonly property Session.Wrapper session: session
    readonly property Launcher.Wrapper launcher: launcher
    readonly property BarPopouts.Wrapper popouts: popouts

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.topMargin: bar.implicitHeight

    Osd.Wrapper {
        id: osd

        clip: root.visibilities.session
        screen: root.screen
        visibilities: root.visibilities

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: session.width
    }

    Notifications.Wrapper {
        id: notifications

        visibilities: root.visibilities
        panel: root

        anchors.top: parent.top
        anchors.right: parent.right
    }

    Session.Wrapper {
        id: session

        visibilities: root.visibilities

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }

    Launcher.Wrapper {
        id: launcher

        visibilities: root.visibilities
        panels: root

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }

    BarPopouts.Wrapper {
        id: popouts

        screen: root.screen

        x: {
            const off = currentCenter - Config.border.thickness - nonAnimWidth / 2;
            const diff = root.width - Math.floor(off + nonAnimWidth);
            if (diff < 0)
                return off + diff;
            return Math.max(off, 0);
        }
        y: 0
    }
}
