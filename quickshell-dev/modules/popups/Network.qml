pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.services as Services
import qs.ds.buttons as Buttons
import qs.ds.list as Lists
import qs.ds.text as Text
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string connectingToSsid: ""

    // ToDo: Review
    property int margin: Foundations.spacing.xxs

    spacing: margin
    width: Math.max(320, implicitWidth)

    Text.HeadingS {
        Layout.rightMargin: root.margin
        Layout.topMargin: root.margin
        text: qsTr("Wifi %1").arg(Network.wifiEnabled ? "enabled" : "disabled")
    }
    Toggle {
        checked: Network.wifiEnabled
        label: qsTr("Enabled")

        toggle.onToggled: Network.enableWifi(checked)
    }
    Text.BodyS {
        Layout.rightMargin: root.margin
        Layout.topMargin: root.margin
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
            leftIcon: Services.IconsService.getNetworkIcon(modelData.strength)
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
        Layout.topMargin: root.margin
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
        Layout.rightMargin: root.margin
        spacing: root.margin

        Text.BodyM {
            Layout.fillWidth: true
            text: parent.label
        }
        Switch {
            id: toggle
        }
    }
}
