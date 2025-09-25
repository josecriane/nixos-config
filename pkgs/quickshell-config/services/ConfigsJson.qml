pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias commands: commandsAdapter.commands
    property alias sessionCommands: sessionCommandsAdapter.commands
    property alias excludedDesktops: excludedDesktopsAdapter.excludedApps

    property FileView commandsFile: FileView {
        path: `${Quickshell.shellDir}/commands.json`
        watchChanges: true

        JsonAdapter {
            id: commandsAdapter
            
            property var commands: []
        }
    }
    
    property FileView sessionCommandsFile: FileView {
        path: `${Quickshell.shellDir}/session-commands.json`
        watchChanges: true

        JsonAdapter {
            id: sessionCommandsAdapter

            property var commands: []
        }
    }

    property FileView excludedDesktopsFile: FileView {
        path: `${Quickshell.shellDir}/excluded-apps.json`
        watchChanges: true


        JsonAdapter {
            id: excludedDesktopsAdapter

            property var excludedApps: []
        }
    }
}