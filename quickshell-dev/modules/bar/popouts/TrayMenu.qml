pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.ds.text as DsText
import qs.ds.icons as Icons
import qs.ds.list as Lists
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs.ds.animations
import qs.ds

Item {
    id: root

    required property Item popouts
    required property QsMenuHandle trayItem

    function calculateTotalWidth(menu) {
        if (!menu)
            return 0;
        let width = menu.implicitWidth || menu.width || 0;
        if (menu.activeSubMenu) {
            width += calculateTotalWidth(menu.activeSubMenu) - 10;
        }
        return width;
    }

    function calculateMaxHeight(menu) {
        if (!menu)
            return 0;
        let height = menu.implicitHeight || menu.height || 0;
        if (menu.activeSubMenu) {
            height = Math.max(height, calculateMaxHeight(menu.activeSubMenu));
        }
        return height;
    }

    property real totalWidth: calculateTotalWidth(mainMenu)
    property real totalHeight: calculateMaxHeight(mainMenu)

    implicitWidth: totalWidth
    implicitHeight: totalHeight

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Foundations.duration.xs
        }
    }

    Behavior on implicitHeight {
        BasicNumberAnimation {
            duration: Foundations.duration.xs
        }
    }

    SubMenu {
        id: mainMenu
        anchors.left: parent.left
        anchors.top: parent.top
        handle: root.trayItem
        level: 0
    }

    component SubMenu: Column {
        id: menu

        required property QsMenuHandle handle
        required property int level
        property bool shown: false
        property var activeSubMenu: null
        property int hoveredIndex: -1

        padding: Appearance.padding.smaller
        spacing: Foundations.spacing.xxs

        opacity: shown ? 1 : 0
        scale: shown ? 1 : 0.8

        Component.onCompleted: shown = true

        Behavior on opacity {
            BasicNumberAnimation {}
        }

        Behavior on scale {
            BasicNumberAnimation {}
        }

        // Show submenu at specific position
        function showSubMenu(menuHandle, itemY, itemHeight, index) {
            if (activeSubMenu) {
                activeSubMenu.destroy();
                activeSubMenu = null;
            }

            hoveredIndex = -1;
            hoveredIndex = index;

            activeSubMenu = subMenuComponent.createObject(root, {
                "handle": menuHandle,
                "level": menu.level + 1,
                "shown": true,
                "x": menu.x + menu.width - 10 // Slight overlap
                ,
                "y": Math.max(0, Math.min(menu.y + itemY, root.height - 200)) // Ensure it fits
            });
        }

        QsMenuOpener {
            id: menuOpener

            menu: menu.handle
        }

        Repeater {
            id: repeater
            model: menuOpener.children

            delegate: Item {
                required property QsMenuEntry modelData
                required property int index

                implicitWidth: 300
                implicitHeight: {
                    if (modelData.isSeparator)
                        return 1;
                    if (!modelData.enabled)
                        return headingText.implicitHeight;
                    return listItem.implicitHeight;
                }

                // Separator
                Rectangle {
                    visible: modelData.isSeparator
                    anchors.fill: parent
                    color: Colours.palette.m3outlineVariant
                }

                // Header for disabled items
                DsText.HeadingS {
                    id: headingText
                    visible: !modelData.isSeparator && !modelData.enabled
                    anchors.fill: parent
                    anchors.leftMargin: Foundations.spacing.m
                    anchors.rightMargin: Foundations.spacing.m

                    text: modelData.text
                    verticalAlignment: Text.AlignVCenter
                }

                // List item for enabled items
                Lists.ListItem {
                    id: listItem

                    visible: !modelData.isSeparator && modelData.enabled
                    anchors.fill: parent

                    clickable: true
                    keepEmptySpace: true
                    selected: menu.hoveredIndex === index && modelData.hasChildren

                    imageIcon: modelData.icon
                    text: modelData.text
                    minimumHeight: 25
                    rightIcon: modelData.hasChildren ? "chevron_right" : ""

                    onClicked: {
                        if (modelData.hasChildren) {
                            menu.showSubMenu(modelData, listItem.y, listItem.height, index);
                        } else {
                            modelData.triggered();
                            root.popouts.hasCurrent = false;
                        }
                    }
                }
            }
        }
    }

    Component {
        id: subMenuComponent
        SubMenu {}
    }
}
