pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils
import qs.config
import QtQuick

Item {
    id: root

    required property var bar
    required property Brightness.Monitor monitor
    property color colour: Colours.palette.m3primary

    readonly property int maxWidth: {
        const otherModules = bar.children.filter(c => c.id && c.item !== this && c.id !== "spacer");
        const otherWidth = otherModules.reduce((acc, curr) => acc + curr.width, 0);
        // Length - 2 cause repeater counts as a child
        return bar.width - otherWidth - bar.spacing * (bar.children.length - 1) - bar.hPadding * 2;
    }
    property Title current: text1

    clip: true
    implicitWidth: icon.implicitWidth + current.implicitWidth + current.anchors.leftMargin
    implicitHeight: Math.max(icon.implicitHeight, current.implicitHeight)

    MaterialIcon {
        id: icon

        anchors.verticalCenter: parent.verticalCenter

        animate: true
        text: Icons.getAppCategoryIcon("", "desktop_windows")
        color: root.colour
    }

    Title {
        id: text1
    }

    Title {
        id: text2
    }

    TextMetrics {
        id: metrics

        text: "Desktop"
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        elide: Qt.ElideRight
        elideWidth: root.maxWidth - icon.width

        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
        onElideWidthChanged: root.current.text = elidedText
    }

    Behavior on implicitWidth {
        Anim {
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    component Title: StyledText {
        id: text

        anchors.verticalCenter: icon.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: Appearance.spacing.small

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.colour
        opacity: root.current === this ? 1 : 0

        // No rotation needed for horizontal layout

        Behavior on opacity {
            Anim {}
        }
    }
}
