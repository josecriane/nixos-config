pragma ComponentBehavior: Bound

import qs.services
import qs.services as Services
import qs.ds
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

    property color colour: Foundations.palette.base0D
    readonly property alias items: iconRow
    readonly property int margin: Foundations.spacing.s
    readonly property int iconSpacing: Foundations.spacing.xxs

    clip: true
    color: Foundations.palette.base02
    implicitHeight: height
    implicitWidth: iconRow.implicitWidth + margin * 2
    radius: Foundations.radius.all

    Behavior on implicitWidth {
        BasicNumberAnimation {
            duration: Foundations.duration.slow
        }
    }

    RowLayout {
        id: iconRow

        anchors.centerIn: parent
        spacing: iconSpacing

        // Audio icon
        WrappedLoader {
            name: "audio"

            sourceComponent: RowLayout {
                spacing: iconSpacing

                Icons.MaterialFontIcon {
                    animate: true
                    color: root.colour
                    text: "screen_record"
                    visible: ScreenShare.isSharing
                }

                Icons.MaterialFontIcon {
                    animate: true
                    color: root.colour
                    text: "mic_off"
                    visible: Audio.sourceMuted
                }

                Icons.MaterialFontIcon {
                    animate: true
                    color: root.colour
                    text: Services.IconsService.getVolumeIcon(Audio.volume, Audio.muted)
                }
            }
        }

        // Keyboard layout icon
        WrappedLoader {
            name: "kblayout"

            sourceComponent: Text.BodyM {
                color: root.colour
                font.family: Foundations.font.family.mono
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
                text: Network.active ? Services.IconsService.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
            }
        }

        // Bluetooth section
        WrappedLoader {
            name: "bluetooth"

            sourceComponent: RowLayout {
                spacing: iconSpacing

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
                        text: Services.IconsService.getBluetoothIcon(modelData.icon)

                        SequentialAnimation on opacity {
                            alwaysRunToEnd: true
                            loops: Animation.Infinite
                            running: device.modelData.state !== BluetoothDeviceState.Connected

                            BasicNumberAnimation {
                                duration: Foundations.duration.slow
                                from: 1
                                to: 0
                            }
                            BasicNumberAnimation {
                                duration: Foundations.duration.slow
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
                color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? root.colour : Foundations.palette.base08
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
