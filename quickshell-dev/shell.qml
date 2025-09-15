//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules/drawers"
import "modules/shortcuts" as Shortcuts
import Quickshell

ShellRoot {
    Drawers {}

    Shortcuts.Handler {}
}