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
        const notif = notifComp.createObject(root, {
            popup: true,
            notification: notification
        });
        
        root.list.push(notif);

        const popupTimeout = Config.notifs.defaultExpireTimeout;
        
        const timer = timerComp.createObject(notif, {
            interval: popupTimeout,
            notifModel: notif
        });
        timer.start();
        
        notif.hideTimer = timer;
    }
    function deleteAllNotifications() {
        for (const notif of root.list) {
            if (notif.hideTimer) {
                notif.hideTimer.stop();
                notif.hideTimer.destroy();
            }
            if (notif.notification && !notif.notification.destroyed) {
                notif.notification.tracked = false;
            }
            notif.destroy();
        }
        root.list = [];
    }
    function deleteNotification(notification) {
        const index = root.list.findIndex(n => n.notification === notification);
        if (index !== -1) {
            const notif = root.list[index];
            if (notif.hideTimer) {
                notif.hideTimer.stop();
                notif.hideTimer.destroy();
            }
            if (notification && !notification.destroyed) {
                notification.tracked = false;
            }
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
    Component {
        id: timerComp
        
        Timer {
            property var notifModel
            
            repeat: false
            onTriggered: {
                if (notifModel) {
                    notifModel.hide();
                }
                if (notifModel.isTransient) {
                    root.deleteNotification(notifModel)
                }
                destroy();
            }
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
