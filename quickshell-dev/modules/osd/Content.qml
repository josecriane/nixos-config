pragma ComponentBehavior: Bound

import qs.components
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
        MouseArea {
            implicitWidth: Config.osd.sizes.sliderWidth
            implicitHeight: Config.osd.sizes.sliderHeight

            onWheel: event => {
                if (event.angleDelta.y > 0)
                    Audio.incrementVolume();
                else if (event.angleDelta.y < 0)
                    Audio.decrementVolume();
            }

            Slider {
                anchors.fill: parent

                icon: Utils.Icons.getVolumeIcon(value, Audio.muted)
                value: Audio.volume
                onMoved: Audio.setVolume(value)
            }
        }

        // Microphone volume
        MouseArea {
            implicitWidth: Config.osd.sizes.sliderWidth
            implicitHeight: Config.osd.sizes.sliderHeight

            onWheel: event => {
                if (event.angleDelta.y > 0)
                    Audio.incrementSourceVolume();
                else if (event.angleDelta.y < 0)
                    Audio.decrementSourceVolume();
            }

            Slider {
                anchors.fill: parent

                icon: Utils.Icons.getMicVolumeIcon(value, Audio.sourceMuted)
                value: Audio.sourceVolume
                onMoved: Audio.setSourceVolume(value)
            }
        }

        // Brightness
        MouseArea {
            implicitWidth: Config.osd.sizes.sliderWidth
            implicitHeight: Config.osd.sizes.sliderHeight

            onWheel: event => {
                const monitor = root.monitor;
                if (!monitor)
                    return;
                if (event.angleDelta.y > 0)
                    monitor.setBrightness(monitor.brightness + 0.1);
                else if (event.angleDelta.y < 0)
                    monitor.setBrightness(monitor.brightness - 0.1);
            }

            Slider {
                anchors.fill: parent

                icon: `brightness_${(Math.round(value * 6) + 1)}`
                value: root.monitor?.brightness ?? 0
                onMoved: root.monitor?.setBrightness(value)
            }
        }
    }
}
