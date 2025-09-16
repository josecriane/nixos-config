pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.ds.buttons as Buttons
import qs.ds.list as Lists
import qs.ds.text as Text
import qs.ds as Ds
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.ds.animations

Item {
    id: root

    required property var wrapper

    implicitHeight: layout.implicitHeight + Appearance.padding.normal * 2
    implicitWidth: layout.implicitWidth + Appearance.padding.normal * 2

    ButtonGroup {
        id: sinks

    }
    ButtonGroup {
        id: sources

    }
    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Text.HeadingS {
            Layout.bottomMargin: Appearance.spacing.small / 2
            text: qsTr("Output device")
        }
        Repeater {
            id: sinksRepeater

            model: Audio.sinks

            Lists.ListItem {
                required property PwNode modelData

                buttonGroup: sinks
                selected: Audio.sink?.id === modelData.id
                text: modelData.description

                onClicked: {
                    Audio.setAudioSink(modelData);
                }
            }
        }
        Text.HeadingS {
            Layout.bottomMargin: Appearance.spacing.small / 2
            Layout.topMargin: Appearance.spacing.normal
            text: qsTr("Input device")
        }
        Repeater {
            id: sourcesRepeater

            model: Audio.sources

            Lists.ListItem {
                required property PwNode modelData

                buttonGroup: sources
                selected: Audio.source?.id === modelData.id
                text: modelData.description

                onClicked: {
                    Audio.setAudioSource(modelData);
                }
            }
        }
        Text.HeadingS {
            Layout.bottomMargin: Appearance.spacing.small / 2
            Layout.topMargin: Appearance.spacing.normal
            text: qsTr("Volume (%1)").arg(Audio.muted ? qsTr("Muted") : `${Math.round(Audio.volume * 100)}%`)
        }
        Ds.Slider {
            Layout.fillWidth: true
            implicitHeight: Appearance.padding.normal * 3
            value: Audio.volume

            Behavior on value {
                BasicNumberAnimation {
                }
            }

            onMoved: Audio.setVolume(value)
            onWheelDown: Audio.decrementVolume()
            onWheelUp: Audio.incrementVolume()
        }
        Buttons.PrimaryButton {
            Layout.topMargin: Appearance.spacing.normal
            rightIcon: "chevron_right"
            text: qsTr("Open settings")
            visible: Config.general.apps.audio.length > 0

            onClicked: {
                root.wrapper.hasCurrent = false;
                Quickshell.execDetached(["pavucontrol"]);
            }
        }
    }

    // Update selection when audio devices change externally
    Connections {
        function onSinkChanged() {
            for (let i = 0; i < sinksRepeater.count; i++) {
                let item = sinksRepeater.itemAt(i);
                if (item) {
                    item.selected = (Audio.sink?.id === item.modelData.id);
                }
            }
        }
        function onSourceChanged() {
            for (let i = 0; i < sourcesRepeater.count; i++) {
                let item = sourcesRepeater.itemAt(i);
                if (item) {
                    item.selected = (Audio.source?.id === item.modelData.id);
                }
            }
        }

        target: Audio
    }
}
