pragma ComponentBehavior: Bound

import qs.config
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick

QtObject {
    id: notif

    readonly property list<NotificationAction> actions: notification ? notification.actions : []
    readonly property string appIcon: notification ? notification.appIcon : ""
    readonly property string appName: notification ? notification.appName : ""
    readonly property string body: notification ? notification.body : ""
    readonly property RetainableLock lock: RetainableLock {
        locked: true
        object: notif.notification
    }
    readonly property Connections retainableConn: Connections {
        function onAboutToDestroy(): void {
            // Don't destroy, just mark as dismissed
            notif.popup = false;
            notif.dismissed = true;
        }
        function onDropped(): void {
            // Don't remove from list, just mark as dismissed
            notif.popup = false;
            notif.dismissed = true;
        }

        target: notif.notification ? notif.notification.Retainable : null
    }
    readonly property Connections notificationConn: Connections {
        function onClosed(reason): void {
            // Notification was closed by the system or user
            // The service will handle deletion
            notif.popup = false;
            notif.dismissed = true;
            console.log("Notification closed with reason:", reason);
        }

        target: notif.notification
    }
    readonly property date created: new Date()
    property bool dismissed: false
    property var hideTimer: null
    readonly property string image: notification ? notification.image : ""
    required property Notification notification
    property bool popup: false
    readonly property string summary: notification ? notification.summary : ""
    readonly property date time: new Date()
    readonly property string timeStr: {
        if (!time)
            return "";
        const diff = Time.date.getTime() - time.getTime();
        const m = Math.floor(diff / 60000);
        const h = Math.floor(m / 60);

        if (h < 1 && m < 1)
            return "now";
        if (h < 1)
            return `${m}m`;
        return `${h}h`;
    }
    readonly property bool isTransient: notification ? notification.transient : false
    readonly property int urgency: notification ? notification.urgency : NotificationUrgency.Normal

    function hide() {
        // Just hide from popup view, don't dismiss
        popup = false;
    }
}
