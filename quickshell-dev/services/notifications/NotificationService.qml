pragma Singleton
pragma ComponentBehavior: Bound

import qs.services
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    // TODO: Redesign using direct Notification objects
    readonly property list<Notification> notifications: server.trackedNotifications.values
    property list<Notification> popups: []

    property int defaultExpireTimeout: 5000

    function clearNotifications() {
        for (const notification  of root.notifications)
            notification.dismiss()
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: true

        onNotification: notification => {
            console.log("Model data",  JSON.stringify(notification, null, 2))

            notification.tracked = true;

            root.popups.pop(notification)
            const timer = timerComponent.createObject(notification, {
                interval: notification.expireTimeout ?? root.defaultExpireTimeout,
                notification: notification
            });
        }
    }

    // TODO: Remove NotificationModel component - use Notification directly
    // Component {
    //     id: notifComp
    //     NotificationModel {}
    // }

    Component {
        id: timerComponent
        
        Timer {
            property var notification
            
            repeat: false
            onTriggered: {
                const index = root.popups.indexOf(notification);
                root.popups.splice(index, 1);

                if (notification.transient) {
                    notification.dismiss()
                }
            }
        }
    }
}