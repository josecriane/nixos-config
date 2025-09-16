import qs.services
import qs.config
import qs.ds.list as Lists
import qs.ds.text as Text
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: root

    spacing: Appearance.spacing.small
    width: Math.max(320, implicitWidth)

    ButtonGroup {
        id: layoutGroup

    }
    Text.HeadingS {
        Layout.rightMargin: Appearance.padding.small
        Layout.topMargin: Appearance.padding.normal
        text: qsTr("Keyboard Layout")
    }
    Repeater {
        id: layoutRepeater

        model: Niri.kbLayouts

        Lists.ListItem {
            required property int index
            required property string modelData

            buttonGroup: layoutGroup
            selected: index === Niri.currentKbLayoutIndex
            text: modelData

            onClicked: {
                Niri.switchKbLayout(index);
            }
        }
    }

    // Update selection when layout changes externally
    Connections {
        function onCurrentKbLayoutIndexChanged() {
            for (let i = 0; i < layoutRepeater.count; i++) {
                let item = layoutRepeater.itemAt(i);
                if (item) {
                    item.selected = (i === Niri.currentKbLayoutIndex);
                }
            }
        }

        target: Niri
    }
}
