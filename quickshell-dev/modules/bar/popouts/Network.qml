pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.utils as Utils
import qs.ds.buttons as Buttons
import qs.ds.list as Lists
import qs.ds.text as Text
import qs.ds as Ds
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string connectingToSsid: ""

    spacing: Appearance.spacing.small
    width: Math.max(320, implicitWidth)

    Text.HeadingS {
        Layout.topMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.small
        text: qsTr("Wifi %1").arg(Network.wifiEnabled ? "enabled" : "disabled")
    }

    Toggle {
        label: qsTr("Enabled")
        checked: Network.wifiEnabled
        toggle.onToggled: Network.enableWifi(checked)
    }

    Text.BodyS {
        Layout.topMargin: Appearance.spacing.small
        Layout.rightMargin: Appearance.padding.small
        text: qsTr("%1 networks available").arg(Network.networks.length)
        disabled: true
    }

    Repeater {
        model: ScriptModel {
            values: [...Network.networks].sort((a, b) => {
                if (a.active !== b.active)
                    return b.active - a.active;
                return b.strength - a.strength;
            }).slice(0, 8)
        }

        Lists.ListItem {
            required property Network.AccessPoint modelData
            readonly property bool isConnecting: root.connectingToSsid === modelData.ssid

            leftIcon: Utils.Icons.getNetworkIcon(modelData.strength)
            secondaryIcon: modelData.isSecure ? "lock" : ""
            text: modelData.ssid
            selected: modelData.active
            primaryFontIcon: modelData.active ? "link_off" : "link"
            primaryActionActive: modelData.active
            primaryActionLoading: isConnecting
            disabled: !Network.wifiEnabled

            onPrimaryActionClicked: {
                if (modelData.active) {
                    Network.disconnectFromNetwork();
                } else {
                    root.connectingToSsid = modelData.ssid;
                    Network.connectToNetwork(modelData.ssid, "");
                }
            }
        }
    }

    Buttons.PrimaryButton {
        Layout.topMargin: Appearance.spacing.small
        Layout.fillWidth: true

        text: qsTr("Rescan networks")
        leftIcon: "wifi_find"
        disabled: !Network.wifiEnabled
        loading: Network.scanning

        onClicked: Network.rescanWifi()
    }

    // Reset connecting state when network changes
    Connections {
        target: Network

        function onActiveChanged(): void {
            if (Network.active && root.connectingToSsid === Network.active.ssid) {
                root.connectingToSsid = "";
            }
        }
    }

    component Toggle: RowLayout {
        required property string label
        property alias checked: toggle.checked
        property alias toggle: toggle

        Layout.fillWidth: true
        Layout.rightMargin: Appearance.padding.small
        spacing: Appearance.spacing.normal

        Text.BodyM {
            Layout.fillWidth: true
            text: parent.label
        }

        Ds.Switch {
            id: toggle
        }
    }
}
