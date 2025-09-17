pragma Singleton
pragma ComponentBehavior: Bound

import qs.services
import qs.modules.shortcuts as Shortcuts
import qs.config
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property list<NotificationModel> list: []
    readonly property list<NotificationModel> popups: list.filter(n => n.popup && !n.dismissed)

    function addNotification(notification) {
        root.list.push(notifComp.createObject(root, {
            popup: true,
            notification: notification
        }));
    }
    function deleteAllNotifications() {
        for (const notif of root.list) {
            notif.dismiss();
            notif.destroy();
        }
        root.list = [];
    }
    function deleteNotification(notification) {
        const index = root.list.findIndex(n => n.notification === notification);
        if (index !== -1) {
            const notif = root.list[index];
            notif.dismiss();
            root.list.splice(index, 1);
            notif.destroy();
        }
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: false

        onNotification: notif => {
            notif.tracked = true;
            root.addNotification(notif);
        }
    }
    Component {
        id: notifComp

        NotificationModel {
        }
    }
    Shortcuts.Shortcut {
        description: "Clear all notif"
        name: "clearNotifs"

        onPressed: {
            root.deleteAllNotifications();
        }
    }
    IpcHandler {
        function clear(): void {
            root.deleteAllNotifications();
        }

        target: "notifs"
    }
}
