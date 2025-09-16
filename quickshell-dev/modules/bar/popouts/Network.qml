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
        Layout.rightMargin: Appearance.padding.small
        Layout.topMargin: Appearance.padding.normal
        text: qsTr("Wifi %1").arg(Network.wifiEnabled ? "enabled" : "disabled")
    }
    Toggle {
        checked: Network.wifiEnabled
        label: qsTr("Enabled")

        toggle.onToggled: Network.enableWifi(checked)
    }
    Text.BodyS {
        Layout.rightMargin: Appearance.padding.small
        Layout.topMargin: Appearance.spacing.small
        disabled: true
        text: qsTr("%1 networks available").arg(Network.networks.length)
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
            readonly property bool isConnecting: root.connectingToSsid === modelData.ssid
            required property Network.AccessPoint modelData

            disabled: !Network.wifiEnabled
            leftIcon: Utils.Icons.getNetworkIcon(modelData.strength)
            primaryActionActive: modelData.active
            primaryActionLoading: isConnecting
            primaryFontIcon: modelData.active ? "link_off" : "link"
            secondaryIcon: modelData.isSecure ? "lock" : ""
            selected: modelData.active
            text: modelData.ssid

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
        Layout.fillWidth: true
        Layout.topMargin: Appearance.spacing.small
        disabled: !Network.wifiEnabled
        leftIcon: "wifi_find"
        loading: Network.scanning
        text: qsTr("Rescan networks")

        onClicked: Network.rescanWifi()
    }

    // Reset connecting state when network changes
    Connections {
        function onActiveChanged(): void {
            if (Network.active && root.connectingToSsid === Network.active.ssid) {
                root.connectingToSsid = "";
            }
        }

        target: Network
    }

    component Toggle: RowLayout {
        property alias checked: toggle.checked
        required property string label
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
