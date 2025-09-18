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
    readonly property list<NotificationModel> popups: list.filter(n => n.popup)

    property int defaultExpireTimeout: 5000

    function addNotification(notification) {
        const notif = notifComp.createObject(root, {
            popup: !ScreenShare.isSharing,
            expireTimeout: notification.expireTimeout >= 0 ? notification.expireTimeout : root.defaultExpireTimeout,
            notification: notification
        });

        root.list.push(notif);

        const timer = timerComp.createObject(notif, {
            interval: notif.expireTimeout,
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
    function deleteNotification(notificationModel) {
        const notification = notificationModel.notification
        if (notificationModel.hideTimer) {
            notificationModel.hideTimer.stop();
            notificationModel.hideTimer.destroy();
        }
        if (notification && !notification.destroyed) {
            notification.tracked = false;
        }
        
        const index = root.list.indexOf(notificationModel);
        root.list.splice(index, 1);
        notificationModel.destroy();
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
