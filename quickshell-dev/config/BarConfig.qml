import Quickshell.Io

JsonObject {
    property bool persistent: true
    property bool showOnHover: true
    property int dragThreshold: 20
    property Tray tray: Tray {}
    property Status status: Status {}
    property Clock clock: Clock {}
    property Sizes sizes: Sizes {}

    property list<var> entries: [
        {
            id: "workspaces",
            enabled: true
        },
        {
            id: "spacer",
            enabled: true
        },
        {
            id: "spacer",
            enabled: true
        },
        {
            id: "tray",
            enabled: true
        },
        {
            id: "idleInhibitor",
            enabled: true
        },
        {
            id: "clock",
            enabled: true
        },
        {
            id: "statusIcons",
            enabled: true
        },
        {
            id: "power",
            enabled: true
        }
    ]

    component Tray: JsonObject {
        property bool background: false
        property bool recolour: false
    }

    component Status: JsonObject {
        property bool showAudio: true
        property bool showKbLayout: true
        property bool showNetwork: true
        property bool showBluetooth: true
        property bool showBattery: true
    }

    component Clock: JsonObject {
        property bool showIcon: true
    }

    component Sizes: JsonObject {
        property int innerWidth: 40
        property int windowPreviewSize: 400
        property int trayMenuWidth: 300
        property int batteryWidth: 250
        property int networkWidth: 320
    }
}
