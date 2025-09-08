pragma Singleton

import Quickshell

Singleton {
    property var screens: new Map()
    property var bars: new Map()

    function load(screen: ShellScreen, visibilities: var): void {
        screens.set(screen, visibilities);
    }

    function getForActive(): PersistentProperties {
        // Return first screen's visibilities as fallback
        return screens.values().next().value;
    }
}
