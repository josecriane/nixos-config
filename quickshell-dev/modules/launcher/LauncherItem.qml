import "services"
import qs.services
import qs.config
import qs.ds.text as DsText
import qs.ds.icons as Icons
import qs.ds
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property LauncherItemModel modelData
    property PersistentProperties visibilities
    property var list

    property int itemHeight: 57
    implicitHeight: itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    default property alias customContent: textContainer.data

    function activate(): void {
        if (root.modelData.autocompleteText) {
            root.list.search.text = root.modelData.autocompleteText;
        }

        if (root.modelData.onActivate) {
            let shouldClose = root.modelData.onActivate();

            if (shouldClose === undefined || shouldClose === null) {
                shouldClose = true;
            }

            if (shouldClose) {
                root.visibilities.launcher = false;
            }
        }
    }

    InteractiveArea {
        radius: Foundations.radius.xs

        function onClicked(): void {
            root.activate();
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Appearance.padding.larger
        anchors.rightMargin: Appearance.padding.larger
        anchors.margins: Appearance.padding.smaller

        // Icon - Apps use IconImage, Actions use MaterialIcon
        IconImage {
            id: appIcon
            visible: root.modelData?.isApp ?? false
            source: visible ? Quickshell.iconPath(root.modelData?.appIcon, "image-missing") : ""
            width: root.itemHeight * 0.6
            height: root.itemHeight * 0.6
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Icons.MaterialFontIcon {
            id: fontIcon
            visible: root.modelData?.isAction ?? false
            text: visible ? (root.modelData?.fontIcon ?? "") : ""
            font.pointSize: Appearance.font.size.extraLarge
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: textContainer
            anchors.left: appIcon.visible ? appIcon.right : fontIcon.right
            anchors.right: parent.right
            anchors.leftMargin: Appearance.spacing.normal
            anchors.verticalCenter: parent.verticalCenter

            height: name.height + subtitle.height

            DsText.BodyM {
                id: name
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                text: root.modelData?.name ?? ""
                elide: Text.ElideRight
            }

            DsText.BodyS {
                id: subtitle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: name.bottom

                text: root.modelData?.subtitle ?? ""

                elide: Text.ElideRight
                disabled: true
            }
        }
    }
}
