pragma Singleton

import qs.components.misc
import Quickshell
import Quickshell.Wayland as Wayland
import QtQuick

Singleton {
    id: root

    // Generic properties that work across compositors
    readonly property var toplevels: Wayland.ToplevelManagement.toplevels ?? []
    readonly property var workspaces: [] // niri doesn't expose workspaces via standard protocols
    readonly property var monitors: [] // could be implemented later
    
    readonly property Wayland.Toplevel activeToplevel: {
        // Find the focused toplevel
        for (const toplevel of toplevels) {
            if (toplevel.activated) {
                return toplevel;
            }
        }
        return null;
    }
    
    readonly property string activeTitle: activeToplevel?.title ?? ""
    readonly property string activeAppId: activeToplevel?.appId ?? ""
    
    // Keyboard layout - simplified for now
    readonly property bool capsLock: false
    readonly property bool numLock: false
    readonly property string kbLayout: "us"
    readonly property string kbLayoutFull: "English (US)"

    function dispatch(request: string): void {
        console.log("Window manager dispatch not implemented for non-Hyprland compositor:", request);
    }

    function monitorFor(screen: ShellScreen): var {
        return null; // Not implemented for generic compositor
    }
    
    // Placeholder for workspace management
    readonly property int activeWsId: 1
}