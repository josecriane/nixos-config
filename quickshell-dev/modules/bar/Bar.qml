pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.modules.popups as BarPopouts
import "components"
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    readonly property int hPadding: Appearance.padding.large
    required property int innerHeight
    required property BarPopouts.Wrapper popouts
    required property ShellScreen screen
    required property PersistentProperties visibilities

    function checkPopout(x: real): void {
        // Check if hovering over the centered Date component
        const dateLeft = date.x;
        const dateRight = date.x + date.width;
        if (x >= dateLeft && x <= dateRight) {
            popouts.currentName = "calendar";
            popouts.currentCenter = Qt.binding(() => date.mapToItem(root, date.width / 2, 0).x);
            popouts.hasCurrent = true;
            return;
        }

        const ch = mainLayout.childAt(x, height / 2) as WrappedLoader;
        if (!ch) {
            popouts.hasCurrent = false;
            return;
        }

        const id = ch.id;
        const left = ch.x;
        const item = ch.item;
        const itemWidth = item.implicitWidth;

        if (id === "statusIcons") {
            const items = item.items;
            const icon = items.childAt(mapToItem(items, x, 0).x, items.height / 2);
            if (icon) {
                popouts.currentName = icon.name;
                popouts.currentCenter = Qt.binding(() => icon.mapToItem(root, icon.implicitWidth / 2, 0).x);
                popouts.hasCurrent = true;
            }
        } else if (id === "tray") {
            const index = Math.floor(((x - left) / itemWidth) * item.items.count);
            const trayItem = item.items.itemAt(index);
            if (trayItem) {
                popouts.currentName = `traymenu${index}`;
                popouts.currentCenter = Qt.binding(() => trayItem.mapToItem(root, trayItem.implicitWidth / 2, 0).x);
                popouts.hasCurrent = true;
            }
        } else if (id === "resources") {
            popouts.currentName = "systemtray";
            popouts.currentCenter = Qt.binding(() => item.mapToItem(root, item.implicitWidth / 2, 0).x);
            popouts.hasCurrent = true;
        }
    }
    function handleWheel(x: real, angleDelta: point): void {
        const ch = childAt(x, height / 2) as WrappedLoader;
        if (ch?.id === "workspaces") {
            // Workspace scroll - disabled for non-Hyprland
            console.log("Workspace scrolling disabled for current compositor");
        } else if (x < screen.width / 2) {
            // Volume scroll on top half
            if (angleDelta.y > 0)
                Audio.incrementVolume();
            else if (angleDelta.y < 0)
                Audio.decrementVolume();
        } else {
            // Brightness scroll on bottom half
            const monitor = Brightness.getMonitorForScreen(screen);
            if (angleDelta.y > 0)
                monitor.setBrightness(monitor.brightness + 0.1);
            else if (angleDelta.y < 0)
                monitor.setBrightness(monitor.brightness - 0.1);
        }
    }

    RowLayout {
        id: mainLayout

        anchors.fill: parent
        spacing: Appearance.spacing.normal

        // Left side
        WrappedLoader {
            id: workspaces

            Layout.leftMargin: root.hPadding

            sourceComponent: Workspaces {
                screen: root.screen
            }
        }
        WrappedLoader {
            id: activeWindow

            sourceComponent: ActiveWindow {
                height: root.innerHeight
                screen: root.screen
            }
        }

        // Center spacer
        WrappedLoader {
            id: spacer

            Layout.fillWidth: true
        }

        // Right side items
        WrappedLoader {
            id: tray

            sourceComponent: Tray {
                height: root.innerHeight
            }
        }
        WrappedLoader {
            id: resources

            sourceComponent: SystemTray {
                height: root.innerHeight
            }
        }
        WrappedLoader {
            id: statusIcons

            sourceComponent: StatusIcons {
                height: root.innerHeight
            }
        }
        WrappedLoader {
            id: idleInhibitor

            sourceComponent: IdleInhibitor {
            }
        }
        WrappedLoader {
            id: notificationToggle

            sourceComponent: NotificationListToggle {
                visibilities: root.visibilities
            }
        }
        WrappedLoader {
            id: power

            Layout.rightMargin: root.hPadding

            sourceComponent: Power {
                visibilities: root.visibilities
            }
        }
    }
    Date {
        id: date

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z: 10
    }

    component WrappedLoader: Loader {
        property string id

        Layout.alignment: Qt.AlignVCenter
        active: true
        visible: true
    }
}
