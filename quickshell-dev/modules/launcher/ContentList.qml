pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import qs.ds.text as DsText
import qs.ds.icons as Icons
import Quickshell
import QtQuick
import QtQuick.Controls
import qs.ds.animations

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
            BasicNumberAnimation {
                target: root
                property: "opacity"
                from: 1
                to: 0
                duration: Appearance.anim.durations.small
            }
            PropertyAction {}
            BasicNumberAnimation {
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

        Icons.MaterialFontIcon {
            text: "manage_search"
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: Appearance.font.size.extraLarge

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            DsText.HeadingM {
                text: qsTr("No results")
            }

            DsText.BodyM {
                text: qsTr("Try searching for something else")
                disabled: true
            }
        }
        }

        Behavior on opacity {
            BasicNumberAnimation {}
        }

        Behavior on scale {
            BasicNumberAnimation {}
        }
    }

    Behavior on implicitWidth {
        enabled: root.visibilities.launcher

        BasicNumberAnimation {
            duration: Appearance.anim.durations.large
            easing.bezierCurve: Appearance.anim.curves.emphasizedDecel
        }
    }

    Behavior on implicitHeight {
        enabled: false
    }
}
