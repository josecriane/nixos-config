import "."

Shortcut {
    property var launcherShortcut

    description: "Interrupt launcher keybind"
    name: "launcherInterrupt"

    onPressed: {
        if (launcherShortcut) {
            launcherShortcut.interrupted = true;
        }
    }
}
