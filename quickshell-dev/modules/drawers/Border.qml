pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property Item bar

        // ToDo: This params must override
    property int margin: Foundations.spacing.s
    property int radius: Foundations.radius.l

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Colours.palette.m3surface
        layer.enabled: true

        layer.effect: MultiEffect {
            maskEnabled: true
            maskInverted: true
            maskSource: mask
            maskSpreadAtMin: 1
            maskThresholdMin: 0.5
        }
    }
    Item {
        id: mask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: root.margin
            anchors.topMargin: root.bar.implicitHeight
            radius: root.radius
        }
    }
}
