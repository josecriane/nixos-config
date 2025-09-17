import "."
import qs.services
import qs.config
import qs.modules.notif as Notifications
import qs.modules.launcher as Launcher
import qs.modules.notifications as NotificationsList
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Item bar
    required property Panels panels

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.topMargin: bar.implicitHeight
    preferredRendererType: Shape.CurveRenderer

    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x + Config.border.rounding
        startY: wrapper.y
        wrapper: root.panels.osd
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - Config.border.rounding
        startY: 0
        wrapper: root.panels.notif
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x + Config.border.rounding
        startY: wrapper.y
        wrapper: root.panels.session
    }
    Background {
        maxAvailableHeight: root.height
        startX: (root.width - wrapper.width) / 2 - Config.border.rounding
        startY: 0
        wrapper: root.panels.launcher
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - Config.border.rounding
        startY: 0
        wrapper: root.panels.notifications
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - Config.border.rounding
        startY: 0
        wrapper: root.panels.popouts
    }
}
