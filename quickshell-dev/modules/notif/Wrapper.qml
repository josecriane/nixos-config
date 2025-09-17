import qs.config
import qs.modules.drawers
import Quickshell
import QtQuick

BackgroundWrapper {
    id: root

    required property Item panel
    required property PersistentProperties visibilities

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth
    width: implicitWidth
    height: implicitHeight
    visible: height > 0
    readonly property bool hasCurrent: visible

    Content {
        id: content
    }
}
