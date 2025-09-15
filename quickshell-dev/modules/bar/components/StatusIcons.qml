pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils as Utils
import qs.config
import qs.ds.text as Text
import qs.ds.icons as Icons
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs.ds.animations

Rectangle {
    id: root

    property color colour: Colours.palette.m3secondary
    readonly property alias items: iconRow

    color: Colours.tPalette.m3surfaceContainer
    radius: Appearance.rounding.full

    clip: true
    implicitWidth: iconRow.implicitWidth + Appearance.padding.normal * 2
    implicitHeight: height

    RowLayout {
        id: iconRow

        anchors.centerIn: parent
        spacing: Appearance.spacing.smaller / 2

        // Audio icon
        WrappedLoader {
            name: "audio"

            sourceComponent: Icons.MaterialFontIcon {
                animate: true
                text: Utils.Icons.getVolumeIcon(Audio.volume, Audio.muted)
                color: root.colour
            }
        }

        // Keyboard layout icon
        WrappedLoader {
            name: "kblayout"

            sourceComponent: Text.BodyM {
                text: {
                    const fullName = Niri.currentKbLayoutName();
                    if (!fullName) return "??";
                    
                    if (fullName.includes("Spanish")) return "ES";
                    if (fullName.includes("English")) return "US";
                    
                    return "??";
                }
                color: root.colour
                font.family: Appearance.font.family.mono
            }
        }

        // Network icon
        WrappedLoader {
            name: "network"

            sourceComponent: Icons.MaterialFontIcon {
                animate: true
                text: Network.active ? Utils.Icons.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
                color: root.colour
            }
        }

        // Bluetooth section
        WrappedLoader {
            name: "bluetooth"

            sourceComponent: RowLayout {
                spacing: Appearance.spacing.smaller / 2

                // Bluetooth icon
                Icons.MaterialFontIcon {
                    animate: true
                    text: {
                        if (!Bluetooth.defaultAdapter?.enabled)
                            return "bluetooth_disabled";
                        if (Bluetooth.devices.values.some(d => d.connected))
                            return "bluetooth_connected";
                        return "bluetooth";
                    }
                    color: root.colour
                }

                // Connected bluetooth devices
                Repeater {
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(d => d.state !== BluetoothDeviceState.Disconnected)
                    }

                    Icons.MaterialFontIcon {
                        id: device

                        required property BluetoothDevice modelData

                        animate: true
                        text: Utils.Icons.getBluetoothIcon(modelData.icon)
                        color: root.colour

                        SequentialAnimation on opacity {
                            running: device.modelData.state !== BluetoothDeviceState.Connected
                            alwaysRunToEnd: true
                            loops: Animation.Infinite

                            BasicNumberAnimation {
                                from: 1
                                to: 0
                                duration: Appearance.anim.durations.large
                                easing.bezierCurve: Appearance.anim.curves.standardAccel
                            }
                            BasicNumberAnimation {
                                from: 0
                                to: 1
                                duration: Appearance.anim.durations.large
                                easing.bezierCurve: Appearance.anim.curves.standardDecel
                            }
                        }
                    }
                }
            }
        }

        // Battery icon
        WrappedLoader {
            name: "battery"

            sourceComponent: Icons.MaterialFontIcon {
                animate: true
                text: {
                    if (!UPower.displayDevice.isLaptopBattery) {
                        if (PowerProfiles.profile === PowerProfile.PowerSaver)
                            return "energy_savings_leaf";
                        if (PowerProfiles.profile === PowerProfile.Performance)
                            return "rocket_launch";
                        return "balance";
                    }

                    const perc = UPower.displayDevice.percentage;
                    const charging = !UPower.onBattery;
                    if (perc === 1)
                        return charging ? "battery_charging_full" : "battery_full";
                    let level = Math.floor(perc * 7);
                    if (charging && (level === 4 || level === 1))
                        level--;
                    return charging ? `battery_charging_${(level + 3) * 10}` : `battery_${level}_bar`;
                }
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? root.colour : Colours.palette.m3error
            }
        }
    }

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.large
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    component WrappedLoader: Loader {
        required property string name

        Layout.alignment: Qt.AlignVCenter
        // asynchronous: true
        visible: active
    }
}
