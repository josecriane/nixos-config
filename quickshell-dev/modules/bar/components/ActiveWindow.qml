pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils
import qs.config
import QtQuick

Item {
    id: root

    required property var screen
    property color colour: Colours.palette.m3primary

    readonly property int maxWidth: screen.width / 3
    property Title current: text1

    clip: true
    implicitWidth: icon.implicitWidth + current.implicitWidth + current.anchors.leftMargin
    implicitHeight: Math.max(icon.implicitHeight, current.implicitHeight)

    Text {
        id: icon
        
        text: Apps.getIcon(Niri.focusedWindowAppId)
        color: root.colour
        font.family: Appearance.font.family.mono
        font.pointSize: Appearance.font.size.normal
    }

    Title {
        id: text1
    }

    Title {
        id: text2
    }

    TextMetrics {
        id: metrics

        text: Niri.focusedWindowTitle
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

        Behavior on opacity {
            Anim {}
        }
    }
}
