pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias border: adapter.border

    JsonAdapter {
        id: adapter

        property AppearanceConfig appearance: AppearanceConfig {
        }
        property BorderConfig border: BorderConfig {
        }
    }
}
