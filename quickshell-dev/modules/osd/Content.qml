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
    required property var visibilities

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left

    implicitWidth: layout.implicitWidth + Appearance.padding.large * 2
    implicitHeight: layout.implicitHeight + Appearance.padding.large * 2

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Appearance.spacing.normal

        // Speaker volume
        Slider {
            implicitWidth: Config.osd.sizes.sliderWidth
            implicitHeight: Config.osd.sizes.sliderHeight

            icon: Utils.Icons.getVolumeIcon(value, Audio.muted)
            value: Audio.volume
            onMoved: Audio.setVolume(value)
            onWheelUp: Audio.incrementVolume()
            onWheelDown: Audio.decrementVolume()
        }

        // Microphone volume
        Slider {
            implicitWidth: Config.osd.sizes.sliderWidth
            implicitHeight: Config.osd.sizes.sliderHeight

            icon: Utils.Icons.getMicVolumeIcon(value, Audio.sourceMuted)
            value: Audio.sourceVolume
            onMoved: Audio.setSourceVolume(value)
            onWheelUp: Audio.incrementSourceVolume()
            onWheelDown: Audio.decrementSourceVolume()
        }

        // Brightness
        Slider {
            implicitWidth: Config.osd.sizes.sliderWidth
            implicitHeight: Config.osd.sizes.sliderHeight

            icon: `brightness_${(Math.round(value * 6) + 1)}`
            value: root.monitor?.brightness ?? 0
            onMoved: root.monitor?.setBrightness(value)
            onWheelUp: {
                const monitor = root.monitor;
                if (monitor) monitor.setBrightness(monitor.brightness + 0.1);
            }
            onWheelDown: {
                const monitor = root.monitor;
                if (monitor) monitor.setBrightness(monitor.brightness - 0.1);
            }
        }
    }
}
