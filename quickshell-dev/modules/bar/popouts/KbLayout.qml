import qs.components
import qs.components.controls
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    implicitWidth: layout.implicitWidth + Appearance.padding.normal * 2
    implicitHeight: layout.implicitHeight + Appearance.padding.normal * 2

    ButtonGroup {
        id: layouts
    }

    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        StyledText {
            Layout.bottomMargin: Appearance.spacing.small / 2
            text: qsTr("Keyboard Layout")
            font.weight: 500
        }

        Repeater {
            model: Niri.kbLayouts

            StyledRadioButton {
                required property string modelData
                required property int index

                ButtonGroup.group: layouts
                checked: index === Niri.currentKbLayoutIndex
                onClicked: Niri.switchKbLayout(index)
                text: modelData
            }
        }
    }
}