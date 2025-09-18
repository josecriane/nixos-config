import qs.services
import qs.config
import qs.modules.popups as Popups
import qs.modules.osd as Osd
import Quickshell
import QtQuick

MouseArea {
    id: root

    required property Item bar
    property bool osdHovered
    property bool osdShortcutActive
    required property Panels panels
    required property Popups.Wrapper popouts
    required property ShellScreen screen
    required property PersistentProperties visibilities

    function inBottomPanel(panel: Item, x: real, y: real): bool {
        return y > root.height - Config.border.thickness - panel.height - Config.border.rounding && withinPanelWidth(panel, x, y);
    }
    function inLeftPanel(panel: Item, x: real, y: real): bool {
        return x < Config.border.thickness + panel.x + panel.width && withinPanelHeight(panel, x, y);
    }
    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > Config.border.thickness + panel.x && withinPanelHeight(panel, x, y);
    }
    function inTopPanel(panel: Item, x: real, y: real): bool {
        return y < bar.implicitHeight + panel.y + panel.height && withinPanelWidth(panel, x, y);
    }
    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        const panelY = bar.implicitHeight + panel.y;
        return y >= panelY - Config.border.rounding && y <= panelY + panel.height + Config.border.rounding;
    }
    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        const panelX = Config.border.thickness + panel.x;
        return x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
    }

    anchors.fill: parent
    hoverEnabled: true

    onContainsMouseChanged: {
        if (!containsMouse) {
            // Only hide if not activated by shortcut
            if (!osdShortcutActive) {
                visibilities.osd = false;
                osdHovered = false;
            }

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

        // Always update visibility based on hover if not in shortcut mode
        if (!osdShortcutActive) {
            visibilities.osd = showOsd;
            osdHovered = showOsd;
        } else if (showOsd) {
            // If hovering over OSD area while in shortcut mode, transition to hover control
            osdShortcutActive = false;
            osdHovered = true;
        }

        // Show popouts on hover
        if (y < bar.implicitHeight)
            bar.checkPopout(x);
        else if (!popouts.currentName.startsWith("traymenu") && !inTopPanel(panels.popouts, x, y))
            popouts.hasCurrent = false;
    }
    onWheel: event => {
        if (event.y < bar.implicitHeight) {
            bar.handleWheel(event.x, event.angleDelta);
        }
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
                root.osdShortcutActive = false;
                root.osdHovered = false;
            } else {
                // If launcher is hidden, clear shortcut flags for OSD
                root.osdShortcutActive = false;

                // Also hide OSD if they're not being hovered
                const inOsdArea = root.inRightPanel(root.panels.osd, root.mouseX, root.mouseY);

                if (!inOsdArea) {
                    root.visibilities.osd = false;
                    root.osdHovered = false;
                }
            }
        }
        function onOsdChanged() {
            if (root.visibilities.osd) {
                // OSD became visible, immediately check if this should be shortcut mode
                const inOsdArea = root.inRightPanel(root.panels.osd, root.mouseX, root.mouseY);
                if (!inOsdArea) {
                    root.osdShortcutActive = true;
                }
            } else {
                // OSD hidden, clear shortcut flag
                root.osdShortcutActive = false;
            }
        }

        target: root.visibilities
    }
    Osd.Interactions {
        hovered: root.osdHovered
        screen: root.screen
        visibilities: root.visibilities
    }
}
