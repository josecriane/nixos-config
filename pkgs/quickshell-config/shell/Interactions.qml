import qs.services
import qs.ds
import qs.modules.popups as Popups
import qs.modules.osd as Osd
import Quickshell
import QtQuick

MouseArea {
    id: root

    required property Item bar
    property bool osdHovered
    required property Panels panels
    required property Popups.Wrapper popouts
    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property int margin
    required property int radius

    function inBottomPanel(panel: Item, x: real, y: real): bool {
        return y > root.height - root.margin - panel.height - radius && withinPanelWidth(panel, x, y);
    }
    function inLeftPanel(panel: Item, x: real, y: real): bool {
        return x <  root.margin+ panel.x + panel.width && withinPanelHeight(panel, x, y);
    }
    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > root.margin + panel.x && withinPanelHeight(panel, x, y);
    }
    function inTopPanel(panel: Item, x: real, y: real): bool {
        return y < bar.implicitHeight + panel.y + panel.height && withinPanelWidth(panel, x, y);
    }
    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        const panelY = bar.implicitHeight + panel.y;
        return y >= panelY - radius && y <= panelY + panel.height + radius;
    }
    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        const panelX = margin + panel.x;
        return x >= panelX - radius && x <= panelX + panel.width + radius;
    }

    anchors.fill: parent
    hoverEnabled: true

    onContainsMouseChanged: {
        if (!containsMouse) {
            visibilities.osd = false;
            osdHovered = false;
            popouts.hasCurrent = false;
        }
    }
    onPositionChanged: event => {
        const x = event.x;
        const y = event.y;

        // Don't show other panels if launcher is open
        if (visibilities.launcher) {
            return;
        }

        // Show osd on hover
        const showOsd = inRightPanel(panels.osd, x, y);

        visibilities.osd = showOsd;
        osdHovered = showOsd;

        // Show popouts on hover
        if (y < bar.implicitHeight)
            bar.checkPopout(x);
        else if (!popouts.currentName.startsWith("traymenu") && !inTopPanel(panels.popouts, x, y))
            popouts.hasCurrent = false;
    }

    // Monitor individual visibility changes
    Connections {
        function onLauncherChanged() {
            if (root.visibilities.launcher) {
                // Launcher opened - close all other panels
                root.visibilities.osd = false;
                root.visibilities.session = false;
                root.visibilities.bar = false;
                root.popouts.hasCurrent = false;
                root.osdHovered = false;
            } else {
                // Also hide OSD if they're not being hovered
                const inOsdArea = root.inRightPanel(root.panels.osd, root.mouseX, root.mouseY);

                if (!inOsdArea) {
                    root.visibilities.osd = false;
                    root.osdHovered = false;
                }
            }
        }
        function onOsdChanged() {
        }

        target: root.visibilities
    }
    Osd.Interactions {
        hovered: root.osdHovered
        screen: root.screen
        visibilities: root.visibilities
    }
}
