import "."

Shortcut {
    name: "launcherInterrupt"
    description: "Interrupt launcher keybind"

    property var launcherShortcut

    onPressed: {
        if (launcherShortcut) {
            launcherShortcut.interrupted = true;
        }
    }
}
