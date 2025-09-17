import qs.config
import Quickshell
import QtQuick

Item {
    id: root

    required property Item panel
    required property PersistentProperties visibilities

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth
    visible: height > 0

    Content {
        id: content

        panel: root.panel
        visibilities: root.visibilities
    }
}
