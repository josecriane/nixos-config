import "."
import qs.services
import qs.ds
import qs.modules.launcher as Launcher
import qs.modules.notifications as NotificationsList
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Item bar
    required property Panels panels
    required property int margin
    required property int radius

    anchors.fill: parent
    anchors.margins: margin
    anchors.topMargin: bar.implicitHeight
    preferredRendererType: Shape.CurveRenderer

    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x + root.radius
        startY: wrapper.y
        wrapper: root.panels.osd
        radius: root.radius
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x + root.radius
        startY: wrapper.y
        wrapper: root.panels.session
        radius: root.radius
    }
    Background {
        maxAvailableHeight: root.height
        startX: (root.width - wrapper.width) / 2 - root.radius
        startY: 0
        wrapper: root.panels.launcher
        radius: root.radius
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - root.radius
        startY: 0
        wrapper: root.panels.notifications
        radius: root.radius
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - root.radius
        startY: 0
        wrapper: root.panels.popouts
        radius: root.radius
    }
}
