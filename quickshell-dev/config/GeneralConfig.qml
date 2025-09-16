import Quickshell.Io

JsonObject {
    property Apps apps: Apps {
    }

    component Apps: JsonObject {
        property list<string> audio: ["pavucontrol"]
        property list<string> terminal: ["foot"]
    }
}
