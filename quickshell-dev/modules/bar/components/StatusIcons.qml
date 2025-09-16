pragma ComponentBehavior: Bound

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

    clip: true
    color: Colours.tPalette.m3surfaceContainer
    implicitHeight: height
    implicitWidth: iconRow.implicitWidth + Appearance.padding.normal * 2
    radius: Appearance.rounding.full

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Appearance.anim.durations.large
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }
    }

    RowLayout {
        id: iconRow

        anchors.centerIn: parent
        spacing: Appearance.spacing.smaller / 2

        // Audio icon
        WrappedLoader {
            name: "audio"

            sourceComponent: Icons.MaterialFontIcon {
                animate: true
                color: root.colour
                text: Utils.Icons.getVolumeIcon(Audio.volume, Audio.muted)
            }
        }

        // Keyboard layout icon
        WrappedLoader {
            name: "kblayout"

            sourceComponent: Text.BodyM {
                color: root.colour
                font.family: Appearance.font.family.mono
                text: {
                    const fullName = Niri.currentKbLayoutName();
                    if (!fullName)
                        return "??";

                    if (fullName.includes("Spanish"))
                        return "ES";
                    if (fullName.includes("English"))
                        return "US";

                    return "??";
                }
            }
        }

        // Network icon
        WrappedLoader {
            name: "network"

            sourceComponent: Icons.MaterialFontIcon {
                animate: true
                color: root.colour
                text: Network.active ? Utils.Icons.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
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
                    color: root.colour
                    text: {
                        if (!Bluetooth.defaultAdapter?.enabled)
                            return "bluetooth_disabled";
                        if (Bluetooth.devices.values.some(d => d.connected))
                            return "bluetooth_connected";
                        return "bluetooth";
                    }
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
                        color: root.colour
                        text: Utils.Icons.getBluetoothIcon(modelData.icon)

                        SequentialAnimation on opacity {
                            alwaysRunToEnd: true
                            loops: Animation.Infinite
                            running: device.modelData.state !== BluetoothDeviceState.Connected

                            BasicNumberAnimation {
                                duration: Appearance.anim.durations.large
                                easing.bezierCurve: Appearance.anim.curves.standardAccel
                                from: 1
                                to: 0
                            }
                            BasicNumberAnimation {
                                duration: Appearance.anim.durations.large
                                easing.bezierCurve: Appearance.anim.curves.standardDecel
                                from: 0
                                to: 1
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
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? root.colour : Colours.palette.m3error
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
            }
        }
    }

    component WrappedLoader: Loader {
        required property string name

        Layout.alignment: Qt.AlignVCenter
        // asynchronous: true
        visible: active
    }
}
