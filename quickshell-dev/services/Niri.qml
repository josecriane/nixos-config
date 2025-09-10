pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
    id: root

    property list<var> workspaces: []
    property int focusedWorkspaceIndex: 0
    property list<var> windows: []
    property int focusedWindowIndex: 0
    property bool inOverview: false

    // Reactive property for focused window title
    property string focusedWindowTitle: "(No active window)"
    property string focusedWindowAppId: ""

    // Update the focusedWindowTitle whenever relevant properties change
    function updateFocusedWindowTitle() {
        if (focusedWindowIndex >= 0 && focusedWindowIndex < windows.length) {
            const rawTitle = windows[focusedWindowIndex].title || "";
            focusedWindowTitle = Apps.cleanTitle(rawTitle);
            focusedWindowAppId = windows[focusedWindowIndex].app_id || "";
        } else {
            focusedWindowTitle = "";
            focusedWindowAppId = "";
        }
    }

    // Call updateFocusedWindowTitle on changes
    onWindowsChanged: updateFocusedWindowTitle()
    onFocusedWindowIndexChanged: updateFocusedWindowTitle()

    Process {
        command: ["niri", "msg", "-j", "event-stream"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                const event = JSON.parse(data.trim());

                if (event.WorkspacesChanged) {
                    root.workspaces = [...event.WorkspacesChanged.workspaces].sort((a, b) => a.idx - b.idx);
                    root.focusedWorkspaceIndex = root.workspaces.findIndex(w => w.is_focused);
                    if (root.focusedWorkspaceIndex < 0) {
                        root.focusedWorkspaceIndex = 0;
                    }
                } else if (event.WorkspaceActivated) {
                    root.focusedWorkspaceIndex = root.workspaces.findIndex(w => w.id === event.WorkspaceActivated.id);
                    if (root.focusedWorkspaceIndex < 0) {
                        root.focusedWorkspaceIndex = 0;
                    }
                } else if (event.WindowsChanged) {
                    root.windows = [...event.WindowsChanged.windows].sort((a, b) => a.id - b.id);
                } else if (event.WindowClosed) {
                    root.windows = [...root.windows.filter(w => w.id !== event.WindowClosed.id)];
                } else if (event.WindowFocusChanged) {
                    if (event.WindowFocusChanged.id) {
                        root.focusedWindowIndex = root.windows.findIndex(w => w.id === event.WindowFocusChanged.id);
                        if (root.focusedWindowIndex < 0) {
                            root.focusedWindowIndex = 0;
                        }
                        const focusedWin = root.windows[root.focusedWindowIndex];
                                    "title:", focusedWin ? `"${focusedWin.title}"` : "<none>";
                    } else {
                        root.focusedWindowIndex = -1;
                    }
                } else if (event.OverviewOpenedOrClosed) {
                    root.inOverview = event.OverviewOpenedOrClosed.is_open;
                }
            }
        }
    }
}