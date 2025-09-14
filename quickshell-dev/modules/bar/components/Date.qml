pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.ds.text as Text
import QtQuick

Row {
    id: root

    property color colour: Colours.palette.m3tertiary

    spacing: Foundations.spacing.s

    Text.BodyM {
        id: text

        anchors.verticalCenter: parent.verticalCenter

        text: Time.format("ddd dd MMM  HH:mm")
        font.family: Foundations.font.family.mono
    }
}
