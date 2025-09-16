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

    required property var wrapper
    required property PersistentProperties visibilities
    required property var panels

    readonly property int padding: Appearance.padding.large
    readonly property int rounding: Appearance.rounding.large

    implicitWidth: listWrapper.width + padding * 2
    implicitHeight: searchWrapper.height + listWrapper.height + padding * 2

    Behavior on implicitHeight {
        enabled: false
    }

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        id: listWrapper

        implicitWidth: list.width
        implicitHeight: list.height + root.padding

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: searchWrapper.bottom
        anchors.topMargin: root.padding

        ContentList {
            id: list

            wrapper: root.wrapper
            visibilities: root.visibilities
            panels: root.panels
            search: search
            padding: root.padding
            rounding: root.rounding
        }
    }

    Rectangle {
        id: searchWrapper

        color: Colours.tPalette.m3surfaceContainer
        radius: Appearance.rounding.full

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding

        implicitHeight: Math.max(searchIcon.implicitHeight, search.implicitHeight, clearIcon.implicitHeight)

        Icons.MaterialFontIcon {
            id: searchIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.padding

            text: "search"
            color: Colours.palette.m3onSurfaceVariant
        }

        Ds.TextField {
            id: search

            anchors.left: searchIcon.right
            anchors.right: clearIcon.left
            anchors.leftMargin: Appearance.spacing.small
            anchors.rightMargin: Appearance.spacing.small

            topPadding: Appearance.padding.larger
            bottomPadding: Appearance.padding.larger

            background: null
            backgroundColor: "transparent"
            borderWidth: 0

            placeholderText: "Type \">\" for commands"

            onAccepted: {
                const currentItem = list.currentList?.currentItem;
                if (currentItem) {
                    currentItem.activate();
                }
            }

            Keys.onUpPressed: list.currentList?.decrementCurrentIndex()
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
                target: root.visibilities

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
            }
        }

        CircularButtons.M {
            id: clearIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: root.padding

            icon: "close"
            opacity: search.text ? 1 : 0
            visible: search.text

            onClicked: search.text = ""

            Behavior on opacity {
                BasicNumberAnimation {
                    duration: Appearance.anim.durations.small
                }
            }
        }
    }
}
