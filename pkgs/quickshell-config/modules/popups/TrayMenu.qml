pragma ComponentBehavior: Bound

import qs.services
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
    property real totalHeight: calculateMaxHeight(mainMenu)
    property real totalWidth: calculateTotalWidth(mainMenu)
    required property QsMenuHandle trayItem

    function calculateMaxHeight(menu) {
        if (!menu)
            return 0;
        let height = menu.implicitHeight || menu.height || 0;
        if (menu.activeSubMenu) {
            height = Math.max(height, calculateMaxHeight(menu.activeSubMenu));
        }
        return height;
    }
    function calculateTotalWidth(menu) {
        if (!menu)
            return 0;
        let width = menu.implicitWidth || menu.width || 0;
        if (menu.activeSubMenu) {
            width += calculateTotalWidth(menu.activeSubMenu) - 10;
        }
        return width;
    }

    implicitHeight: totalHeight
    implicitWidth: totalWidth

    Behavior on implicitHeight {
        BasicNumberAnimation {
            duration: Foundations.duration.fastest
        }
    }
    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Foundations.duration.fastest
        }
    }

    SubMenu {
        id: mainMenu

        anchors.left: parent.left
        anchors.top: parent.top
        handle: root.trayItem
        level: 0
    }
    Component {
        id: subMenuComponent

        SubMenu {
        }
    }

    component SubMenu: Column {
        id: menu

        property var activeSubMenu: null
        required property QsMenuHandle handle
        property int hoveredIndex: -1
        required property int level
        property bool shown: false

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

        opacity: shown ? 1 : 0
        padding: Foundations.spacing.xs
        scale: shown ? 1 : 0.8
        spacing: Foundations.spacing.xxs

        Behavior on opacity {
            BasicNumberAnimation {
            }
        }
        Behavior on scale {
            BasicNumberAnimation {
            }
        }

        Component.onCompleted: shown = true

        QsMenuOpener {
            id: menuOpener

            menu: menu.handle
        }
        Repeater {
            id: repeater

            model: menuOpener.children

            delegate: Item {
                required property int index
                required property QsMenuEntry modelData

                implicitHeight: {
                    if (modelData.isSeparator)
                        return 1;
                    if (!modelData.enabled)
                        return headingText.implicitHeight;
                    return listItem.implicitHeight;
                }
                implicitWidth: 300

                // Separator
                Rectangle {
                    anchors.fill: parent
                    color: Foundations.palette.base04
                    visible: modelData.isSeparator
                }

                // Header for disabled items
                DsText.HeadingS {
                    id: headingText

                    anchors.fill: parent
                    anchors.leftMargin: Foundations.spacing.m
                    anchors.rightMargin: Foundations.spacing.m
                    text: modelData.text
                    verticalAlignment: Text.AlignVCenter
                    visible: !modelData.isSeparator && !modelData.enabled
                }

                // List item for enabled items
                Lists.ListItem {
                    id: listItem

                    anchors.fill: parent
                    clickable: true
                    imageIcon: modelData.icon
                    keepEmptySpace: true
                    minimumHeight: 25
                    rightIcon: modelData.hasChildren ? "chevron_right" : ""
                    selected: menu.hoveredIndex === index && modelData.hasChildren
                    text: modelData.text
                    visible: !modelData.isSeparator && modelData.enabled

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
}
