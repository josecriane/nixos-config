import qs.modules.notifications as NotificationsList
import qs.services.notifications
import qs.config
import qs.ds.animations
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    readonly property int padding: Appearance.padding.large

    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.top: parent.top
    implicitHeight: {
        const count = list.count;
        if (count === 0)
            return 0;

        let height = (count - 1) * Appearance.spacing.smaller;
        for (let i = 0; i < count; i++)
            height += list.itemAtIndex(i)?.nonAnimHeight ?? 0;

        const maxHeight = (QsWindow.window?.screen?.height ?? 0) - Config.border.thickness * 2;
        return Math.min(maxHeight, height + padding * 2);
    }
    implicitWidth: 400 + padding * 2

    Behavior on implicitHeight {
        BasicNumberAnimation {
        }
    }

    ClippingWrapperRectangle {
        anchors.fill: parent
        anchors.margins: root.padding
        color: "transparent"
        radius: Appearance.rounding.normal

        ListView {
            id: list

            anchors.fill: parent
            cacheBuffer: QsWindow.window?.screen.height ?? 0
            orientation: Qt.Vertical
            spacing: 0

            delegate: Item {
                id: wrapper

                property int idx
                required property int index
                required property NotificationModel modelData
                readonly property alias nonAnimHeight: notif.nonAnimHeight

                implicitHeight: notif.implicitHeight + (idx === 0 ? 0 : Appearance.spacing.smaller)
                implicitWidth: notif.implicitWidth

                ListView.onRemove: removeAnim.start()
                onIndexChanged: {
                    if (index !== -1)
                        idx = index;
                }

                SequentialAnimation {
                    id: removeAnim

                    PropertyAction {
                        property: "ListView.delayRemove"
                        target: wrapper
                        value: true
                    }
                    PropertyAction {
                        property: "enabled"
                        target: wrapper
                        value: false
                    }
                    PropertyAction {
                        property: "implicitHeight"
                        target: wrapper
                        value: 0
                    }
                    PropertyAction {
                        property: "z"
                        target: wrapper
                        value: 1
                    }
                    BasicNumberAnimation {
                        duration: Appearance.anim.durations.normal
                        easing.bezierCurve: Appearance.anim.curves.emphasized
                        property: "opacity"
                        target: notif
                        to: 0
                    }
                    PropertyAction {
                        property: "ListView.delayRemove"
                        target: wrapper
                        value: false
                    }
                }
                ClippingRectangle {
                    anchors.top: parent.top
                    anchors.topMargin: wrapper.idx === 0 ? 0 : Appearance.spacing.smaller
                    color: "transparent"
                    implicitHeight: notif.implicitHeight
                    implicitWidth: notif.implicitWidth
                    radius: notif.radius

                    NotificationsList.NotificationItem {
                        id: notif

                        modelData: wrapper.modelData
                    }
                }
            }
            displaced: Transition {
                BasicNumberAnimation {
                    property: "y"
                }
            }
            model: ScriptModel {
                values: [...NotificationService.popups].reverse()
            }
            move: Transition {
                BasicNumberAnimation {
                    property: "y"
                }
            }
            rebound: Transition {
                BasicNumberAnimation {
                    properties: "y"
                }
            }
        }
    }
}
