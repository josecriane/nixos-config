import "."
import qs.services
import qs.config
import qs.ds.animations
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    readonly property int padding: Appearance.padding.large
    required property Item panel
    required property PersistentProperties visibilities

    anchors.fill: parent
    implicitHeight: parent.height
    implicitWidth: Config.notifs.sizes.width + padding * 2

    Behavior on implicitHeight {
        Anim {
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
                    Anim {
                        duration: Appearance.anim.durations.normal
                        easing.bezierCurve: Appearance.anim.curves.emphasized
                        property: "x"
                        target: notif
                        to: (notif.x >= 0 ? Config.notifs.sizes.width : -Config.notifs.sizes.width) * 2
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

                    Notification {
                        id: notif

                        modelData: wrapper.modelData
                    }
                }
            }
            displaced: Transition {
                Anim {
                    property: "y"
                }
            }
            model: ScriptModel {
                values: [...NotificationService.popups].reverse()
            }
            move: Transition {
                Anim {
                    property: "y"
                }
            }
            rebound: Transition {
                BasicNumberAnimation {
                    properties: "x,y"
                }
            }

            ExtraIndicator {
                anchors.top: parent.top
                extra: {
                    const count = list.count;
                    if (count === 0)
                        return 0;

                    const scrollY = list.contentY;

                    let height = 0;
                    for (let i = 0; i < count; i++) {
                        height += (list.itemAtIndex(i)?.nonAnimHeight ?? 0) + Appearance.spacing.smaller;

                        if (height - Appearance.spacing.smaller >= scrollY)
                            return i;
                    }

                    return count;
                }
            }
            ExtraIndicator {
                anchors.bottom: parent.bottom
                extra: {
                    const count = list.count;
                    if (count === 0)
                        return 0;

                    const scrollY = list.contentHeight - (list.contentY + list.height);

                    let height = 0;
                    for (let i = count - 1; i >= 0; i--) {
                        height += (list.itemAtIndex(i)?.nonAnimHeight ?? 0) + Appearance.spacing.smaller;

                        if (height - Appearance.spacing.smaller >= scrollY)
                            return count - i - 1;
                    }

                    return 0;
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.expressiveDefaultSpatial
        easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        easing.type: Easing.BezierSpline
    }
}
