pragma ComponentBehavior: Bound

import qs.services.notifications
import qs.services
import qs.config
import qs.utils as Utils
import qs.ds.icons as Icons
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.ds.animations
import qs.ds
import qs.ds.text as DsText

Rectangle {
    id: root

    property bool expanded
    readonly property bool hasAppIcon: modelData?.appIcon?.length > 0
    readonly property bool hasImage: modelData?.image?.length > 0
    required property NotificationModel modelData
    readonly property int nonAnimHeight: summary.implicitHeight + (root.expanded ? appName.height + body.height + actions.height + actions.anchors.topMargin : bodyPreview.height) + inner.anchors.margins * 2
    
    // Safe properties with defaults
    readonly property int urgency: modelData?.urgency ?? NotificationUrgency.Normal
    readonly property string appIconStr: modelData?.appIcon ?? ""
    readonly property string summaryStr: modelData?.summary ?? ""
    readonly property var actionsArray: modelData?.actions ?? []
    readonly property string imageStr: modelData?.image ?? ""
    readonly property string appNameStr: modelData?.appName ?? ""
    readonly property string bodyStr: modelData?.body ?? ""
    readonly property string timeStr: modelData?.timeStr ?? ""

    anchors.horizontalCenter: parent.horizontalCenter
    color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3secondaryContainer : Colours.palette.m3surfaceContainer
    implicitHeight: inner.implicitHeight
    implicitWidth: 400
    radius: Appearance.rounding.normal

    MouseArea {
        property int startY

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        anchors.fill: parent
        cursorShape: root.expanded && body.hoveredLink ? Qt.PointingHandCursor : pressed ? Qt.ClosedHandCursor : undefined
        hoverEnabled: true
        preventStealing: true

        onClicked: event => {
            if (event.button !== Qt.LeftButton)
                return;

            if (root.modelData) {
                const actions = root.actionsArray;
                if (Config.notifs.actionOnClick && actions?.length === 1 && actions[0] && !actions[0].destroyed) {
                    try {
                        actions[0].invoke();
                        NotificationService.deleteNotification(root.modelData);
                    } catch (e) {
                        console.warn("Failed to invoke action:", e);
                        NotificationService.deleteNotification(root.modelData);
                    }
                } else if (Config.notifs.actionOnClick && actions?.length > 1) {
                    // Show actions (expand if not already expanded)
                    root.expanded = true;
                } else {
                    // Default behavior: just dismiss
                    NotificationService.deleteNotification(root.modelData);
                }
            }
        }
        onEntered: {
            if (root.modelData && root.modelData.hideTimer)
                root.modelData.hideTimer.stop();
        }
        onExited: {
            if (!pressed && root.modelData && root.modelData.hideTimer)
                root.modelData.hideTimer.start();
        }
        onPressed: event => {
            if (root.modelData && root.modelData.hideTimer)
                root.modelData.hideTimer.stop();
            startY = event.y;
            if (event.button === Qt.MiddleButton && root.modelData)
                NotificationService.deleteNotification(root.modelData);
        }
        onReleased: event => {
            if (!containsMouse && root.modelData && root.modelData.hideTimer)
                root.modelData.hideTimer.start();
        }

        Item {
            id: inner

            anchors.left: parent.left
            anchors.margins: Appearance.padding.normal
            anchors.right: parent.right
            anchors.top: parent.top
            implicitHeight: root.nonAnimHeight

            Behavior on implicitHeight {
                BasicNumberAnimation {
                    duration: Appearance.anim.durations.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
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
                    radius: Appearance.rounding.full

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
                    color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3error : root.urgency === NotificationUrgency.Low ? Colours.palette.m3surfaceContainerHighest : Colours.palette.m3secondaryContainer
                    implicitHeight: root.hasImage ? 20 : 41
                    implicitWidth: root.hasImage ? 20 : 41
                    radius: Appearance.rounding.full

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
                        anchors.horizontalCenterOffset: -Appearance.font.size.large * 0.02
                        anchors.verticalCenterOffset: Appearance.font.size.large * 0.02
                        asynchronous: true

                        sourceComponent: Icons.MaterialFontIcon {
                            color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3onError : root.urgency === NotificationUrgency.Low ? Colours.palette.m3onSurface : Colours.palette.m3onSecondaryContainer
                            font.pointSize: Appearance.font.size.large
                            text: Utils.Icons.getNotifIcon(root.summaryStr, root.urgency)
                        }
                    }
                }
            }
            DsText.BodyS {
                id: appName

                anchors.left: image.right
                anchors.leftMargin: Appearance.spacing.smaller
                anchors.top: parent.top
                color: Colours.palette.m3onSurfaceVariant
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
                elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Appearance.spacing.small * 3
                font.family: appName.font.family
                font.pointSize: appName.font.pointSize
                text: root.appNameStr
            }
            DsText.BodyM {
                id: summary

                anchors.left: image.right
                anchors.leftMargin: Appearance.spacing.smaller
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
                        duration: Appearance.anim.durations.normal
                        easing.bezierCurve: Appearance.anim.curves.standard
                        easing.type: Easing.BezierSpline
                    }
                }
            }
            TextMetrics {
                id: summaryMetrics

                elide: Text.ElideRight
                elideWidth: expandBtn.x - time.width - timeSep.width - summary.x - Appearance.spacing.small * 3
                font.family: summary.font.family
                font.pointSize: summary.font.pointSize
                text: root.summaryStr
            }
            DsText.BodyS {
                id: timeSep

                anchors.left: summary.right
                anchors.leftMargin: Appearance.spacing.small
                anchors.top: parent.top
                color: Colours.palette.m3onSurfaceVariant
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
                        duration: Appearance.anim.durations.normal
                        easing.bezierCurve: Appearance.anim.curves.standard
                        easing.type: Easing.BezierSpline
                    }
                }
            }
            DsText.BodyS {
                id: time

                anchors.left: timeSep.right
                anchors.leftMargin: Appearance.spacing.small
                anchors.top: parent.top
                color: Colours.palette.m3onSurfaceVariant
                horizontalAlignment: Text.AlignLeft
                text: root.timeStr
            }
            Item {
                id: expandBtn

                anchors.right: parent.right
                anchors.top: parent.top
                implicitHeight: expandIcon.height
                implicitWidth: expandIcon.height

                InteractiveArea {
                    function onClicked() {
                        root.expanded = !root.expanded;
                    }

                    color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
                    radius: Appearance.rounding.full
                }
                Icons.MaterialFontIcon {
                    id: expandIcon

                    anchors.centerIn: parent
                    animate: true
                    font.pointSize: Appearance.font.size.normal
                    text: root.expanded ? "expand_less" : "expand_more"
                }
            }
            DsText.BodyS {
                id: bodyPreview

                anchors.left: summary.left
                anchors.right: expandBtn.left
                anchors.rightMargin: Appearance.spacing.small
                anchors.top: summary.bottom
                color: Colours.palette.m3onSurfaceVariant
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

                property string hoveredLink

                anchors.left: summary.left
                anchors.right: expandBtn.left
                anchors.rightMargin: Appearance.spacing.small
                anchors.top: summary.bottom
                color: Colours.palette.m3onSurfaceVariant
                height: text ? implicitHeight : 0
                opacity: root.expanded ? 1 : 0
                text: root.bodyStr
                textFormat: Text.MarkdownText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }

                onLinkActivated: link => {
                    if (!root.expanded)
                        return;

                    Quickshell.execDetached(["app2unit", "-O", "--", link]);
                    NotificationService.deleteNotification(root.modelData);
                }
            }
            RowLayout {
                id: actions

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: body.bottom
                anchors.topMargin: Appearance.spacing.small
                opacity: root.expanded ? 1 : 0
                spacing: Appearance.spacing.smaller

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }

                Action {
                    actionData: QtObject {
                        readonly property string text: qsTr("Close")

                        function invoke(): void {
                            if (root.modelData) {
                                NotificationService.deleteNotification(root.modelData);
                            }
                        }
                    }
                }
                Repeater {
                    model: root.actionsArray

                    delegate: Action {
                        actionData: modelData
                    }
                }
            }
        }
    }

    component Action: Rectangle {
        id: action

        property var actionData

        Layout.preferredHeight: actionText.height + Appearance.padding.small * 2
        Layout.preferredWidth: actionText.width + Appearance.padding.normal * 2
        color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3secondary : Colours.palette.m3surfaceContainerHigh
        implicitHeight: actionText.height + Appearance.padding.small * 2
        implicitWidth: actionText.width + Appearance.padding.normal * 2
        radius: Appearance.rounding.full

        InteractiveArea {
            function onClicked(): void {
                if (action.actionData && !action.actionData.destroyed) {
                    try {
                        action.actionData.invoke();
                    } catch (e) {
                        console.warn("Failed to invoke action:", e);
                    }
                }
            }

            color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3onSecondary : Colours.palette.m3onSurface
            radius: Appearance.rounding.full
        }
        DsText.BodyS {
            id: actionText

            anchors.centerIn: parent
            color: root.urgency === NotificationUrgency.Critical ? Colours.palette.m3onSecondary : Colours.palette.m3onSurfaceVariant
            text: actionTextMetrics.elidedText
        }
        TextMetrics {
            id: actionTextMetrics

            elide: Text.ElideRight
            elideWidth: {
                const numActions = root.actionsArray.length + 1;
                return (inner.width - actions.spacing * (numActions - 1)) / numActions - Appearance.padding.normal * 2;
            }
            font.family: actionText.font.family
            font.pointSize: actionText.font.pointSize
            text: action.actionData?.text ?? ""
        }
    }
}
