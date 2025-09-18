pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.services as Services
import QtQuick
import QtQuick.Layouts
import qs.ds.animations
import "." as Osd

Item {
    id: root

    required property Brightness.Monitor monitor
    readonly property int sliderHeight: 150
    readonly property int sliderWidth: 30
    required property var visibilities

    property int margin: Foundations.spacing.l
    property int spacingItems: Foundations.spacing.m

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: layout.implicitHeight + margin * 2
    implicitWidth: layout.implicitWidth + margin * 2

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: root.spacingItems

        // Speaker volume
        Osd.Slider {
            icon: Services.IconsService.getVolumeIcon(value, Audio.muted)
            implicitHeight: root.sliderHeight
            implicitWidth: root.sliderWidth
            value: Audio.volume

            onMoved: Audio.setVolume(value)
            onWheelDown: Audio.decrementVolume()
            onWheelUp: Audio.incrementVolume()
        }

        // Microphone volume
        Osd.Slider {
            icon: Services.IconsService.getMicVolumeIcon(value, Audio.sourceMuted)
            implicitHeight: root.sliderHeight
            implicitWidth: root.sliderWidth
            value: Audio.sourceVolume

            onMoved: Audio.setSourceVolume(value)
            onWheelDown: Audio.decrementSourceVolume()
            onWheelUp: Audio.incrementSourceVolume()
        }

        // Brightness
        Osd.Slider {
            icon: `brightness_${(Math.round(value * 6) + 1)}`
            implicitHeight: root.sliderHeight
            implicitWidth: root.sliderWidth
            value: root.monitor?.brightness ?? 0

            onMoved: root.monitor?.setBrightness(value)
            onWheelDown: {
                const monitor = root.monitor;
                if (monitor)
                    monitor.setBrightness(monitor.brightness - 0.1);
            }
            onWheelUp: {
                const monitor = root.monitor;
                if (monitor)
                    monitor.setBrightness(monitor.brightness + 0.1);
            }
        }
    }
}
