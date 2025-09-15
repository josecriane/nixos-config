import "."
import qs.services
import qs.config
import qs.modules.notifications as Notifications
import qs.modules.launcher as Launcher
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Panels panels
    required property Item bar

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.topMargin: bar.implicitHeight
    preferredRendererType: Shape.CurveRenderer

    Background {
        wrapper: root.panels.osd

        startX: wrapper.x + Config.border.rounding
        startY: wrapper.y
    }

    Notifications.Background {
        wrapper: root.panels.notifications

        startX: root.width
        startY: 0
    }

    Background {
        wrapper: root.panels.session

        startX: wrapper.x + Config.border.rounding
        startY: wrapper.y
    }

    Background {
        wrapper: root.panels.launcher

        startX: (root.width - wrapper.width) / 2 - Config.border.rounding
        startY: 0
    }


    Background {
        wrapper: root.panels.popouts

        startX: wrapper.x - Config.border.rounding
        startY: 0
    }
}
