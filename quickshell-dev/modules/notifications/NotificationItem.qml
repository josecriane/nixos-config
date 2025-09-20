pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.services as Services
import qs.ds.icons as Icons
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.ds.animations
import qs.ds.text as DsText
import qs.ds.buttons as Buttons
import qs.ds.buttons.circularButtons as CircularButtons

Rectangle {
    id: root

    // ToDo if will be hardcoded
    readonly property color criticalBackgroundColor: Foundations.palette.base08
    readonly property color lowBackgroundColor: Foundations.palette.base03

    required property Notification notification
    required property int notificationWidth 

    property bool expanded
    readonly property bool isCritical: notification.urgency === NotificationUrgency.Critical
    readonly property bool isLow: notification.urgency === NotificationUrgency.Low

    function toggleExpanded() {
        root.expanded = !root.expanded
    }
    
    readonly property bool hasAppIcon: notification.appIcon !== ""
    readonly property bool hasImage: notification.image !== ""
    readonly property int nonAnimHeight: summary.implicitHeight + (root.expanded ? appName.height + body.height + actions.height + actions.anchors.topMargin : bodyPreview.height) + inner.anchors.margins * 2
    
    // Safe properties with defaults
    readonly property string appIconStr: notification.appIcon ?? ""
    readonly property string summaryStr: notification.summary ?? ""
    readonly property string imageStr: notification?.image ?? ""
    readonly property string appNameStr: notification?.appName ?? ""
    readonly property string bodyStr: notification?.body ?? ""
    readonly property string timeStr: notification?.timeStr ?? ""

    anchors.horizontalCenter: parent.horizontalCenter
    color: root.isCritical ? Foundations.palette.base04 : Foundations.palette.base02
    implicitHeight: inner.implicitHeight
    implicitWidth: notificationWidth
    radius: Foundations.radius.m

    MouseArea {
        acceptedButtons: Qt.LeftButton
        anchors.fill: parent
        cursorShape: root.expanded && body.hoveredLink ? Qt.PointingHandCursor : pressed ? Qt.ClosedHandCursor : undefined
        hoverEnabled: true
        preventStealing: true

        onClicked: event => {
            if (event.button !== Qt.LeftButton)
                return;

            switch (root.notification.actions.length) {
                case 0:
                    root.notification.dismiss()
                    return
                case 1:
                    root.notification.actions.invoke()
                    return
                default:
                    root.toggleExpanded()
            }
        }
        // onEntered: {
        //     if (root.modelData && root.modelData.hideTimer)
        //         root.modelData.hideTimer.stop();
        // }
        // onExited: {
        //     if (!pressed && root.modelData && root.modelData.hideTimer)
        //         root.modelData.hideTimer.start();
        // }
        Item {
            id: inner

            anchors.left: parent.left
            anchors.margins: Foundations.spacing.s
            anchors.right: parent.right
            anchors.top: parent.top
            implicitHeight: root.nonAnimHeight

            Behavior on implicitHeight {
                BasicNumberAnimation {
                }
            }

            Loader {
                id: image

                active: root.hasImage
                anchors.left: parent.left
                anchors.top: parent.top
                asynchronous: true
                height: 41
                visible: root.hasImage || root.hasAppIcon
                width: 41

                sourceComponent: ClippingRectangle {
                    implicitHeight: 41
                    implicitWidth: 41
                    radius: Foundations.radius.all

                    Image {
                        anchors.fill: parent
                        asynchronous: true
                        cache: false
                        fillMode: Image.PreserveAspectCrop
                        source: Qt.resolvedUrl(root.imageStr)
                    }
                }
            }
            Loader {
                id: appIcon

                active: root.hasAppIcon || !root.hasImage
                anchors.bottom: root.hasImage ? image.bottom : undefined
                anchors.horizontalCenter: root.hasImage ? undefined : image.horizontalCenter
                anchors.right: root.hasImage ? image.right : undefined
                anchors.verticalCenter: root.hasImage ? undefined : image.verticalCenter
                asynchronous: true

                sourceComponent: Rectangle {
                    color: root.isCritical ? root.criticalBackgroundColor : Foundations.palette.base04
                    implicitHeight: root.hasImage ? 20 : 41
                    implicitWidth: root.hasImage ? 20 : 41
                    radius: Foundations.radius.all

                    Loader {
                        id: icon

                        active: root.hasAppIcon
                        anchors.centerIn: parent
                        asynchronous: true
                        height: Math.round(parent.width * 0.6)
                        width: Math.round(parent.width * 0.6)

                        sourceComponent: IconImage {
                            anchors.fill: parent
                            asynchronous: true
                            source: Quickshell.iconPath(root.appIconStr)
                        }
                    }
                    Loader {
                        active: !root.hasAppIcon
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -Foundations.font.size.l * 0.02
                        anchors.verticalCenterOffset: Foundations.font.size.l * 0.02
                        asynchronous: true

                        sourceComponent: Icons.MaterialFontIcon {
                            color: root.isCritical ? root.criticalBackgroundColor : root.isLow? Foundations.palette.base07 : Foundations.palette.base0F
                            font.pointSize: Foundations.font.size.l
                            text: Services.IconsService.getNotifIcon(root.isCritical ? "critical" : root.summaryStr)
                        }
                    }
                }
            }
            DsText.BodyS {
                id: appName

                anchors.left: image.right
                anchors.leftMargin: Foundations.spacing.xs
                anchors.top: parent.top
                color: Foundations.palette.base04
                maximumLineCount: 1
                opacity: root.expanded ? 1 : 0
                text: appNameMetrics.elidedText

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }
            }
            TextMetrics {
                id: appNameMetrics

                elide: Text.ElideRight
                elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Foundations.spacing.s * 3
                font.family: appName.font.family
                font.pointSize: appName.font.pointSize
                text: root.appNameStr
            }
            DsText.BodyM {
                id: summary

                anchors.left: image.right
                anchors.leftMargin: Foundations.spacing.xs
                anchors.top: parent.top
                height: implicitHeight
                maximumLineCount: 1
                text: summaryMetrics.elidedText

                Behavior on height {
                    BasicNumberAnimation {
                    }
                }
                states: State {
                    name: "expanded"
                    when: root.expanded

                    PropertyChanges {
                        summary.maximumLineCount: undefined
                    }
                    AnchorChanges {
                        anchors.top: appName.bottom
                        target: summary
                    }
                }
                transitions: Transition {
                    PropertyAction {
                        property: "maximumLineCount"
                        target: summary
                    }
                    AnchorAnimation {
                        duration: Foundations.duration.standard
                        easing.bezierCurve: Foundations.animCurve
                        easing.type: Easing.BezierSpline
                    }
                }
            }
            TextMetrics {
                id: summaryMetrics

                elide: Text.ElideRight
                elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Foundations.spacing.s * 3
                font.family: summary.font.family
                font.pointSize: summary.font.pointSize
                text: root.summaryStr
            }
            DsText.BodyS {
                id: timeSep

                anchors.left: summary.right
                anchors.leftMargin: Foundations.spacing.s
                anchors.top: parent.top
                color: Foundations.palette.base04
                text: "•"

                states: State {
                    name: "expanded"
                    when: root.expanded

                    AnchorChanges {
                        anchors.left: appName.right
                        target: timeSep
                    }
                }
                transitions: Transition {
                    AnchorAnimation {
                        duration: Foundations.duration.standard
                        easing.bezierCurve: Foundations.animCurve
                        easing.type: Easing.BezierSpline
                    }
                }
            }
            DsText.BodyS {
                id: time

                anchors.left: timeSep.right
                anchors.leftMargin: Foundations.spacing.s
                anchors.top: parent.top
                color: Foundations.palette.base04
                horizontalAlignment: Text.AlignLeft
                text: root.timeStr
            }
            CircularButtons.S {
                id: expandBtn

                anchors.right: parent.right
                anchors.top: parent.top

                icon: root.expanded ? "expand_less" : "expand_more"

                onClicked: {
                    root.toggleExpanded()
                }
            }
            DsText.BodyS {
                id: bodyPreview

                anchors.left: summary.left
                anchors.right: expandBtn.left
                anchors.rightMargin: Foundations.spacing.s
                anchors.top: summary.bottom
                color: Foundations.palette.base04
                opacity: root.expanded ? 0 : 1
                text: bodyPreviewMetrics.elidedText
                textFormat: Text.MarkdownText

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }
            }
            TextMetrics {
                id: bodyPreviewMetrics

                elide: Text.ElideRight
                elideWidth: bodyPreview.width
                font.family: bodyPreview.font.family
                font.pointSize: bodyPreview.font.pointSize
                text: root.bodyStr
            }
            DsText.BodyS {
                id: body

                anchors.left: summary.left
                anchors.right: expandBtn.left
                anchors.rightMargin: Foundations.spacing.s
                anchors.top: summary.bottom
                color: Foundations.palette.base04
                height: text ? implicitHeight : 0
                opacity: root.expanded ? 1 : 0
                text: root.bodyStr
                textFormat: Text.MarkdownText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }
            }
            RowLayout {
                id: actions

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: body.bottom
                anchors.topMargin: Foundations.spacing.s
                opacity: root.expanded ? 1 : 0
                spacing: Foundations.spacing.xs

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }

                ActionButton {
                    text: qsTr("Close")
                    leftIcon: "close"
                    visible: true

                    onClicked: {
                        root.notification.dismiss()
                    }
                }

                Repeater {
                    model: root.notification.actions

                    ActionButton {
                        required property NotificationAction modelData

                        text: qsTr(modelData?.text ?? "")
                        leftIcon: ""
                        visible: true

                        onClicked: {
                            modelData.invoke()
                        }
                    }
                }
            }
        }
    }

    component ActionButton: Buttons.PrimaryButton {
        id: actionButton

        property color backgroundColor: root.isCritical ? Foundations.palette.base09 : Foundations.palette.base07
        property color foregroundColor: root.isCritical ? Foundations.palette.base01 : Foundations.palette.base04
    }
}
