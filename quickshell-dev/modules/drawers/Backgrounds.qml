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

    // ToDo: This params must override
    property int margin: Foundations.spacing.s
    property int radius: Foundations.radius.l

    anchors.fill: parent
    anchors.margins: margin
    anchors.topMargin: bar.implicitHeight
    preferredRendererType: Shape.CurveRenderer

    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x + root.radius
        startY: wrapper.y
        wrapper: root.panels.osd
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x + root.radius
        startY: wrapper.y
        wrapper: root.panels.session
    }
    Background {
        maxAvailableHeight: root.height
        startX: (root.width - wrapper.width) / 2 - root.radius
        startY: 0
        wrapper: root.panels.launcher
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - root.radius
        startY: 0
        wrapper: root.panels.notifications
    }
    Background {
        maxAvailableHeight: root.height
        startX: wrapper.x - root.radius
        startY: 0
        wrapper: root.panels.popouts
    }
}
