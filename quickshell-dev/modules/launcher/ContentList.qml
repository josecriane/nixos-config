pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Controls

Item {
    id: root

    required property var wrapper
    required property PersistentProperties visibilities
    required property var panels
    required property TextField search
    required property int padding
    required property int rounding

    readonly property Item currentList: appList.item
    
    property int itemWidth: 600
    property int itemHeight: 57

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    clip: true
    state: "apps"

    states: [
        State {
            name: "apps"

            PropertyChanges {
                root.implicitWidth: root.itemWidth
                root.implicitHeight: root.currentList?.count > 0 ? appList.implicitHeight : empty.implicitHeight
                appList.active: true
            }

            AnchorChanges {
                anchors.left: root.parent.left
                anchors.right: root.parent.right
            }
        }
    ]

    Behavior on state {
        SequentialAnimation {
            Anim {
                target: root
                property: "opacity"
                from: 1
                to: 0
                duration: Appearance.anim.durations.small
            }
            PropertyAction {}
            Anim {
                target: root
                property: "opacity"
                from: 0
                to: 1
                duration: Appearance.anim.durations.small
            }
        }
    }

    Loader {
        id: appList

        active: false
        asynchronous: true

        anchors.left: parent.left
        anchors.right: parent.right

        sourceComponent: LauncherList {
            search: root.search
            visibilities: root.visibilities
        }
    }

    Item {
        id: empty

        opacity: root.currentList?.count === 0 ? 1 : 0
        scale: root.currentList?.count === 0 ? 1 : 0.5

        implicitHeight: root.itemHeight * 4
        anchors.left: parent.left
        anchors.right: parent.right

        Row {
            spacing: Appearance.spacing.normal
            
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

        MaterialIcon {
            text: "manage_search"
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: Appearance.font.size.extraLarge

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: qsTr("No results")
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.larger
                font.weight: 500
            }

            StyledText {
                text: qsTr("Try searching for something else")
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.normal
            }
        }
        }

        Behavior on opacity {
            Anim {}
        }

        Behavior on scale {
            Anim {}
        }
    }

    Behavior on implicitWidth {
        enabled: root.visibilities.launcher

        Anim {
            duration: Appearance.anim.durations.large
            easing.bezierCurve: Appearance.anim.curves.emphasizedDecel
        }
    }

    Behavior on implicitHeight {
        enabled: false
    }
}
