import Quickshell.Io

JsonObject {
    property Commands commands: Commands {
    }
    property bool enabled: true
    property Sizes sizes: Sizes {
    }
    property bool vimKeybinds: false

    component Commands: JsonObject {
        property list<string> hibernate: ["systemctl", "hibernate"]
        property list<string> logout: ["loginctl", "terminate-user", ""]
        property list<string> reboot: ["systemctl", "reboot"]
        property list<string> shutdown: ["systemctl", "poweroff"]
    }
    component Sizes: JsonObject {
        property int button: 80
    }
}
