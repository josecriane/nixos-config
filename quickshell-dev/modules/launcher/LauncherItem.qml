import "services"
import qs.components
import qs.services
import qs.config
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property LauncherItemModel modelData
    property PersistentProperties visibilities
    property var list  // For actions that need access to the list
    
    property int itemHeight: 57
    implicitHeight: itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right
    
    function activate(): void {
        if (root.modelData.onActivate) {
            if (root.modelData.onActivate.length > 0) {
                root.modelData.onActivate(root.list);
            } else {
                root.modelData.onActivate();
            }
        
            if (root.modelData.closeLauncher && root.visibilities) {
                root.visibilities.launcher = false;
            }
        }
    }

    StateLayer {
        radius: Appearance.rounding.full

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

        MaterialIcon {
            id: actionIcon
            visible: root.modelData?.isAction ?? false
            text: visible ? (root.modelData?.actionIcon ?? "") : ""
            font.pointSize: Appearance.font.size.extraLarge
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: textContainer
            anchors.left: appIcon.visible ? appIcon.right : actionIcon.right
            anchors.right: parent.right
            anchors.leftMargin: Appearance.spacing.normal
            anchors.verticalCenter: parent.verticalCenter

            height: name.height + subtitle.height

            StyledText {
                id: name
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                text: root.modelData?.name ?? ""
                font.pointSize: Appearance.font.size.normal
                elide: Text.ElideRight
            }

            StyledText {
                id: subtitle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: name.bottom

                text: root.modelData?.subtitle ?? ""
                font.pointSize: Appearance.font.size.small
                color: Colours.palette.m3outline
                elide: Text.ElideRight
            }
        }
    }
}