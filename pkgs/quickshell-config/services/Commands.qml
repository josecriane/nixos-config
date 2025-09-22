pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias commands: commandsAdapter.commands
    property alias sessionCommands: sessionCommandsAdapter.commands

    property FileView commandsFile: FileView {
        // path: `${Quickshell.shellDir}/commands.json`
        path: '/home/sito/.config/quickshell/commands.json'
        watchChanges: true

        JsonAdapter {
            id: commandsAdapter
            
            property var commands: []
        }
    }
    
    property FileView sessionCommandsFile: FileView {
        path: '/home/sito/.config/quickshell/session-commands.json'
        watchChanges: true

        JsonAdapter {
            id: sessionCommandsAdapter
            
            property var commands: []
        }
    }
}