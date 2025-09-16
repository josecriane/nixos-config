pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.shortcuts as Shortcuts
import qs.config
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property list<Notif> list: []
    readonly property list<Notif> popups: list.filter(n => n.popup)

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

            root.list.push(notifComp.createObject(root, {
                popup: true,
                notification: notif
            }));
        }
    }
    Shortcuts.Shortcut {
        description: "Clear all notifications"
        name: "clearNotifs"

        onPressed: {
            for (const notif of root.list)
                notif.popup = false;
        }
    }
    IpcHandler {
        function clear(): void {
            for (const notif of root.list)
                notif.popup = false;
        }

        target: "notifs"
    }
    Component {
        id: notifComp

        Notif {
        }
    }

    component Notif: QtObject {
        id: notif

        readonly property list<NotificationAction> actions: notification.actions
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string body: notification.body
        readonly property Connections conn: Connections {
            function onAboutToDestroy(): void {
                notif.destroy();
            }
            function onDropped(): void {
                root.list.splice(root.list.indexOf(notif), 1);
            }

            target: notif.notification.Retainable
        }
        readonly property string image: notification.image
        required property Notification notification
        property bool popup
        readonly property string summary: notification.summary
        readonly property date time: new Date()
        readonly property string timeStr: {
            const diff = Time.date.getTime() - time.getTime();
            const m = Math.floor(diff / 60000);
            const h = Math.floor(m / 60);

            if (h < 1 && m < 1)
                return "now";
            if (h < 1)
                return `${m}m`;
            return `${h}h`;
        }
        readonly property Timer timer: Timer {
            interval: notif.notification.expireTimeout > 0 ? notif.notification.expireTimeout : Config.notifs.defaultExpireTimeout
            running: true

            onTriggered: {
                if (Config.notifs.expire)
                    notif.popup = false;
            }
        }
        readonly property int urgency: notification.urgency
    }
}
