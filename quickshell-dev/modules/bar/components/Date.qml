pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick

Row {
    id: root

    property color colour: Colours.palette.m3tertiary

    spacing: Appearance.spacing.small

    StyledText {
        id: text

        anchors.verticalCenter: parent.verticalCenter

        horizontalAlignment: StyledText.AlignHCenter
        text: Time.format("ddd dd MMM  HH:mm")
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        color: root.colour
    }
}
