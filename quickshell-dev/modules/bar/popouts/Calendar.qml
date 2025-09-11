import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Column {
    id: root

    property date currentMonth: new Date()

    width: 300
    height: implicitHeight + Appearance.padding.large
    spacing: Appearance.spacing.small

    RowLayout {
        width: root.width
        Layout.fillWidth: true
        Layout.topMargin: Appearance.padding.large
        Layout.leftMargin: Appearance.padding.large
        Layout.rightMargin: Appearance.padding.large
        
        MaterialIcon {
            text: "chevron_left"
            color: Colours.palette.m3onSurface
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    let newDate = new Date(root.currentMonth);
                    newDate.setMonth(newDate.getMonth() - 1);
                    root.currentMonth = newDate;
                }
            }
        }
        
        StyledText {
            Layout.fillWidth: true
            text: Qt.formatDate(root.currentMonth, "MMMM yyyy")
            font.pointSize: Appearance.font.size.large
            font.weight: 600
            horizontalAlignment: Text.AlignHCenter
        }
        
        MaterialIcon {
            text: "chevron_right"
            color: Colours.palette.m3onSurface
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    let newDate = new Date(root.currentMonth);
                    newDate.setMonth(newDate.getMonth() + 1);
                    root.currentMonth = newDate;
                }
            }
        }
    }

    DayOfWeekRow {
        id: days

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.padding

        delegate: StyledText {
            required property var model

            horizontalAlignment: Text.AlignHCenter
            text: model.shortName
            font.family: Appearance.font.family.sans
            font.weight: 500
        }
    }

    MonthGrid {
        id: grid

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.padding

        month: root.currentMonth.getMonth()
        year: root.currentMonth.getFullYear()
        spacing: 3
        height: Math.max(200, implicitHeight)

        delegate: Item {
            id: day

            required property var model

            implicitWidth: implicitHeight
            implicitHeight: text.implicitHeight + Appearance.padding.small * 2

            StyledRect {
                anchors.centerIn: parent

                implicitWidth: parent.implicitHeight
                implicitHeight: parent.implicitHeight

                radius: Appearance.rounding.full
                color: Qt.alpha(Colours.palette.m3primary, day.model.today ? 1 : 0)

                StyledText {
                    id: text

                    anchors.centerIn: parent

                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(day.model.date, "d")
                    color: day.model.today ? Colours.palette.m3onPrimary : day.model.month === grid.month ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3outline
                }
            }
        }
    }
}