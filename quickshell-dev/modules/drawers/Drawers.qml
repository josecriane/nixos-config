pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.modules.bar
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import qs.ds.animations

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        // ToDo: This params must override
        property int margin: Foundations.spacing.s

        Exclusions {
            bar: bar
            screen: scope.modelData
        }
        PanelWindow {
            id: win

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: visibilities.launcher || visibilities.notifications || visibilities.session ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            WlrLayershell.namespace: `quickshell-drawers`
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
            anchors.top: true
            color: "transparent"
            screen: scope.modelData

            mask: Region {
                height: win.height - bar.implicitHeight - margin
                intersection: Intersection.Xor
                regions: regions.instances
                width: win.width - margin * 2
                x: margin
                y: bar.implicitHeight
            }

            Variants {
                id: regions

                model: panels.children

                Region {
                    required property Item modelData

                    height: modelData.visible ? modelData.height : 0
                    intersection: Intersection.Subtract
                    width: modelData.visible ? modelData.width : 0
                    x: modelData.x + margin
                    y: modelData.y + bar.implicitHeight
                }
            }
            Rectangle {
                anchors.fill: parent
                color: Colours.palette.m3scrim
                opacity: visibilities.session ? 0.5 : 0

                Behavior on opacity {
                    BasicNumberAnimation {
                    }
                }
            }
            Item {
                anchors.fill: parent
                layer.enabled: true
                opacity: 1

                layer.effect: MultiEffect {
                    blurMax: 15
                    shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
                    shadowEnabled: true
                }

                Border {
                    bar: bar
                }
                Backgrounds {
                    bar: bar
                    panels: panels
                }
            }
            PersistentProperties {
                id: visibilities

                property bool bar
                property bool launcher
                property bool notifications
                property bool osd
                property bool session

                Component.onCompleted: Visibilities.load(scope.modelData, this)
            }
            Interactions {
                bar: bar
                panels: panels
                popouts: panels.popouts
                screen: scope.modelData
                visibilities: visibilities

                Panels {
                    id: panels

                    bar: bar
                    screen: scope.modelData
                    visibilities: visibilities
                }
                BarWrapper {
                    id: bar

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    popouts: panels.popouts
                    screen: scope.modelData
                    visibilities: visibilities

                    Component.onCompleted: Visibilities.bars.set(scope.modelData, this)
                }
            }
        }
    }
}
