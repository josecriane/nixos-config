pragma ComponentBehavior: Bound

import "services"
import qs.services
import qs.config
import qs.ds as Ds
import qs.ds.icons as Icons
import qs.ds.buttons.circularButtons as CircularButtons
import Quickshell
import QtQuick
import qs.ds.animations

Item {
    id: root

    readonly property int padding: Appearance.padding.large
    required property var panels
    readonly property int rounding: Appearance.rounding.large
    required property PersistentProperties visibilities
    required property var wrapper

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    implicitHeight: searchWrapper.height + listWrapper.height + padding * 2
    implicitWidth: listWrapper.width + padding * 2

    Behavior on implicitHeight {
        enabled: false
    }

    Item {
        id: listWrapper

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: searchWrapper.bottom
        anchors.topMargin: root.padding
        implicitHeight: list.height + root.padding
        implicitWidth: list.width

        ContentList {
            id: list

            padding: root.padding
            panels: root.panels
            rounding: root.rounding
            search: search
            visibilities: root.visibilities
            wrapper: root.wrapper
        }
    }
    Rectangle {
        id: searchWrapper

        anchors.left: parent.left
        anchors.margins: root.padding
        anchors.right: parent.right
        anchors.top: parent.top
        color: Colours.palette.m3surfaceContainer
        implicitHeight: Math.max(searchIcon.implicitHeight, search.implicitHeight, clearIcon.implicitHeight)
        radius: Appearance.rounding.full

        Icons.MaterialFontIcon {
            id: searchIcon

            anchors.left: parent.left
            anchors.leftMargin: root.padding
            anchors.verticalCenter: parent.verticalCenter
            color: Colours.palette.m3onSurfaceVariant
            text: "search"
        }
        Ds.TextField {
            id: search

            anchors.left: searchIcon.right
            anchors.leftMargin: Appearance.spacing.small
            anchors.right: clearIcon.left
            anchors.rightMargin: Appearance.spacing.small
            background: null
            backgroundColor: "transparent"
            borderWidth: 0
            bottomPadding: Appearance.padding.larger
            placeholderText: "Type \">\" for commands"
            topPadding: Appearance.padding.larger

            Keys.onDownPressed: list.currentList?.incrementCurrentIndex()
            Keys.onEscapePressed: root.visibilities.launcher = false
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Return && (event.modifiers & Qt.ShiftModifier)) {
                    // Check if current item is interactive (has a hintButton)
                    const currentItem = list.currentList?.currentItem;
                    if (currentItem && currentItem.hintButton) {
                        currentItem.hintButton.clicked();
                        event.accepted = true;
                    }
                }
            }
            Keys.onUpPressed: list.currentList?.decrementCurrentIndex()
            onAccepted: {
                const currentItem = list.currentList?.currentItem;
                if (currentItem) {
                    currentItem.activate();
                }
            }

            Timer {
                id: focusTimer

                interval: 1
                repeat: true

                onTriggered: {
                    if (search.visible && root.visibilities.launcher) {
                        search.forceActiveFocus();
                        search.focus = true;
                        stop();
                    }
                }
            }
            Connections {
                function onLauncherChanged(): void {
                    if (root.visibilities.launcher) {
                        focusTimer.start();
                    } else {
                        focusTimer.stop();
                        search.text = "";
                        const current = list.currentList;
                        if (current)
                            current.currentIndex = 0;
                    }
                }
                function onSessionChanged(): void {
                    if (root.visibilities.launcher && !root.visibilities.session)
                        focusTimer.start();
                }

                target: root.visibilities
            }
        }
        CircularButtons.M {
            id: clearIcon

            anchors.right: parent.right
            anchors.rightMargin: root.padding
            anchors.verticalCenter: parent.verticalCenter
            icon: "close"
            opacity: search.text ? 1 : 0
            visible: search.text

            Behavior on opacity {
                BasicNumberAnimation {
                    duration: Appearance.anim.durations.small
                }
            }

            onClicked: search.text = ""
        }
    }
}
