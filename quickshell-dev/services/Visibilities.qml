pragma Singleton

import qs.services
import Quickshell

Singleton {
    property var screens: new Map()
    property var bars: new Map()

    function load(screen: ShellScreen, visibilities: var): void {
        screens.set(screen, visibilities);
    }

    function getForActive(): PersistentProperties {
        const focusedOutput = Niri.focusedOutput;
        
        for (const [screen, visibilities] of screens) {
            if (screen.name === focusedOutput) {
                return visibilities;
            }
        }
        
        return screens.values().next().value;
    }
}
