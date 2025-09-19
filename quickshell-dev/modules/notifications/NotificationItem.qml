pragma ComponentBehavior: Bound

import qs.services.notifications
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

    readonly property color criticalBackgroundColor: Foundations.palette.base08
    readonly property color lowBackgroundColor: Foundations.palette.base03

    anchors.horizontalCenter: parent.horizontalCenter
    color: root.urgency === NotificationUrgency.Critical ? Foundations.palette.base04 : Foundations.palette.base02
    implicitHeight: inner.implicitHeight
    implicitWidth: 400
    radius: Foundations.radius.m

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
                if (actions?.length === 1 && actions[0] && !actions[0].destroyed) {
                    try {
                        actions[0].invoke();
                        NotificationService.deleteNotification(root.modelData);
                    } catch (e) {
                        console.warn("Failed to invoke action:", e);
                        NotificationService.deleteNotification(root.modelData);
                    }
                } else if (actions?.length > 1) {
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
                    color: root.urgency === NotificationUrgency.Critical ? root.criticalBackgroundColor : root.urgency === NotificationUrgency.Low ? Foundations.palette.base04 : Foundations.palette.base04
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
                            color: root.urgency === NotificationUrgency.Critical ? root.criticalBackgroundColor : root.urgency === NotificationUrgency.Low ? Foundations.palette.base07 : Foundations.palette.base0F
                            font.pointSize: Foundations.font.size.l
                            text: Services.IconsService.getNotifIcon(root.summaryStr, root.urgency)
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

                    color: root.urgency === NotificationUrgency.Critical ? Foundations.palette.base0F : Foundations.palette.base07
                    radius: Foundations.radius.all
                }
                Icons.MaterialFontIcon {
                    id: expandIcon

                    anchors.centerIn: parent
                    animate: true
                    font.pointSize: Foundations.font.size.m
                    text: root.expanded ? "expand_less" : "expand_more"
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

                property string hoveredLink

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
                anchors.topMargin: Foundations.spacing.s
                opacity: root.expanded ? 1 : 0
                spacing: Foundations.spacing.xs

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
                        actionData: root.actionsArray[index]
                    }
                }
            }
        }
    }

    component Action: Rectangle {
        id: action

        property var actionData

        Layout.preferredHeight: actionText.height + Foundations.spacing.xxs * 2
        Layout.preferredWidth: actionText.width + Foundations.spacing.s * 2
        color: root.urgency === NotificationUrgency.Critical ? Foundations.palette.base0D : root.lowBackgroundColor
        implicitHeight: actionText.height + Foundations.spacing.xxs * 2
        implicitWidth: actionText.width + Foundations.spacing.s * 2
        radius: Foundations.radius.all

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

            color: root.urgency === NotificationUrgency.Critical ? Foundations.palette.base0E : Foundations.palette.base07
            radius: Foundations.radius.all
        }
        DsText.BodyS {
            id: actionText

            anchors.centerIn: parent
            color: root.urgency === NotificationUrgency.Critical ? Foundations.palette.base0E : Foundations.palette.base04
            text: actionTextMetrics.elidedText
        }
        TextMetrics {
            id: actionTextMetrics

            elide: Text.ElideRight
            elideWidth: {
                const numActions = root.actionsArray.length + 1;
                return (inner.width - actions.spacing * (numActions - 1)) / numActions - Foundations.spacing.s * 2;
            }
            font.family: actionText.font.family
            font.pointSize: actionText.font.pointSize
            text: action.actionData?.text ?? ""
        }
    }
}
