pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import qs.ds.buttons as Buttons
import qs.ds.list as Lists
import qs.ds.text as Text
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root

    required property var wrapper

    implicitWidth: layout.implicitWidth + Appearance.padding.normal * 2
    implicitHeight: layout.implicitHeight + Appearance.padding.normal * 2

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

                text: modelData.description
                selected: Audio.sink?.id === modelData.id
                buttonGroup: sinks
                
                onClicked: {
                    Audio.setAudioSink(modelData);
                }
            }
        }

        Text.HeadingS {
            Layout.topMargin: Appearance.spacing.normal
            Layout.bottomMargin: Appearance.spacing.small / 2
            text: qsTr("Input device")
        }

        Repeater {
            id: sourcesRepeater
            model: Audio.sources

            Lists.ListItem {
                required property PwNode modelData

                text: modelData.description
                selected: Audio.source?.id === modelData.id
                buttonGroup: sources
                
                onClicked: {
                    Audio.setAudioSource(modelData);
                }
            }
        }

        Text.HeadingS {
            Layout.topMargin: Appearance.spacing.normal
            Layout.bottomMargin: Appearance.spacing.small / 2
            text: qsTr("Volume (%1)").arg(Audio.muted ? qsTr("Muted") : `${Math.round(Audio.volume * 100)}%`)
        }

        CustomMouseArea {
            Layout.fillWidth: true
            implicitHeight: Appearance.padding.normal * 3

            onWheel: event => {
                if (event.angleDelta.y > 0)
                    Audio.incrementVolume();
                else if (event.angleDelta.y < 0)
                    Audio.decrementVolume();
            }

            StyledSlider {
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: parent.implicitHeight

                value: Audio.volume
                onMoved: Audio.setVolume(value)

                Behavior on value {
                    Anim {}
                }
            }
        }

        Buttons.PrimaryButton {
            Layout.topMargin: Appearance.spacing.normal
            visible: Config.general.apps.audio.length > 0
            
            text: qsTr("Open settings")
            rightIcon: "chevron_right"
            
            onClicked: {
                root.wrapper.hasCurrent = false;
                Quickshell.execDetached(["pavucontrol"]);
            }
        }
    }
    
    // Update selection when audio devices change externally
    Connections {
        target: Audio
        
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
    }
}
