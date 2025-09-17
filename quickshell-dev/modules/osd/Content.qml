pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.utils as Utils
import QtQuick
import QtQuick.Layouts
import qs.ds.animations

Item {
    id: root

    required property Brightness.Monitor monitor
    readonly property int sliderHeight: 150
    readonly property int sliderWidth: 30
    required property var visibilities

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: layout.implicitHeight + Appearance.padding.large * 2
    implicitWidth: layout.implicitWidth + Appearance.padding.large * 2

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Appearance.spacing.normal

        // Speaker volume
        Slider {
            icon: Utils.Icons.getVolumeIcon(value, Audio.muted)
            implicitHeight: root.sliderHeight
            implicitWidth: root.sliderWidth
            value: Audio.volume

            onMoved: Audio.setVolume(value)
            onWheelDown: Audio.decrementVolume()
            onWheelUp: Audio.incrementVolume()
        }

        // Microphone volume
        Slider {
            icon: Utils.Icons.getMicVolumeIcon(value, Audio.sourceMuted)
            implicitHeight: root.sliderHeight
            implicitWidth: root.sliderWidth
            value: Audio.sourceVolume

            onMoved: Audio.setSourceVolume(value)
            onWheelDown: Audio.decrementSourceVolume()
            onWheelUp: Audio.incrementSourceVolume()
        }

        // Brightness
        Slider {
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
