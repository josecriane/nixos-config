pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias border: adapter.border
    property alias general: adapter.general
    property alias notifs: adapter.notifs
    property alias osd: adapter.osd
    property alias services: adapter.services
    property alias session: adapter.session

    JsonAdapter {
        id: adapter

        property AppearanceConfig appearance: AppearanceConfig {
        }
        property BorderConfig border: BorderConfig {
        }
        property GeneralConfig general: GeneralConfig {
        }
        property NotifsConfig notifs: NotifsConfig {
        }
        property OsdConfig osd: OsdConfig {
        }
        property ServiceConfig services: ServiceConfig {
        }
        property SessionConfig session: SessionConfig {
        }
    }
}
