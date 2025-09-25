pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int currentKbLayoutIndex: 0
    property string focusedOutput: ""
    property int focusedWorkspaceIndex: 0
    property bool inOverview: false
    property list<string> kbLayouts: []
    property list<var> workspaces: []

    // Function to get current layout name
    function currentKbLayoutName(): string {
        if (root.currentKbLayoutIndex >= 0 && root.currentKbLayoutIndex < root.kbLayouts.length) {
            return root.kbLayouts[root.currentKbLayoutIndex];
        }
        return "";
    }
    function spawn(command: string): void {
        spawnProcess.command = ["niri", "msg", "action", "spawn", "--"].concat(command.split(" "));
        spawnProcess.running = false;
        spawnProcess.running = true;
    }

    // Function to switch keyboard layout
    function switchKbLayout(index: int): void {
        switchLayoutProcess.command = ["niri", "msg", "action", "switch-layout", index.toString()];
        switchLayoutProcess.running = false;
        switchLayoutProcess.running = true;
    }
    function updateFocusedOutput(): void {
        focusedOutputProcess.running = false;
        focusedOutputProcess.running = true;
    }

    Component.onCompleted: {
        layoutsInitProcess.running = true;
        updateFocusedOutput();
    }

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
                } else if (event.OverviewOpenedOrClosed) {
                    root.inOverview = event.OverviewOpenedOrClosed.is_open;
                } else if (event.KeyboardLayoutsChanged) {
                    root.kbLayouts = [];
                    root.currentKbLayoutIndex = -1;

                    const layouts = event.KeyboardLayoutsChanged.keyboard_layouts;
                    if (layouts && layouts.names) {
                        root.kbLayouts = layouts.names;
                        root.currentKbLayoutIndex = layouts.current_idx || 0;
                    }
                } else if (event.KeyboardLayoutSwitched) {
                    root.currentKbLayoutIndex = event.KeyboardLayoutSwitched.idx;
                }

                // Update focused output on any event that might change focus
                if (event.WorkspaceActivated || event.WindowFocusChanged || event.WindowOpenedOrClosed) {
                    root.updateFocusedOutput();
                }
            }
        }
    }

    // Process for switching keyboard layout
    Process {
        id: switchLayoutProcess

        running: false
    }

    // Get initial keyboard layouts with a separate Process
    Process {
        id: layoutsInitProcess

        command: ["niri", "msg", "-j", "keyboard-layouts"]
        running: false

        onStdoutChanged: {
            try {
                const data = JSON.parse(stdout.trim());
                if (data.names) {
                    root.kbLayouts = data.names;
                    root.currentKbLayoutIndex = data.current_idx || 0;
                }
            } catch (e) {
                console.log("Error parsing keyboard layouts:", e);
            }
        }
    }
    Process {
        id: spawnProcess

        running: false
    }

    Process {
        id: focusedOutputProcess

        command: ["niri", "msg", "focused-output"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                // Extract the output name from the first line
                const firstLine = text.split("\n")[0];
                const match = firstLine.match(/\(([^)]+)\)/);
                if (match) {
                    root.focusedOutput = match[1];
                }
            }
        }
    }
}
