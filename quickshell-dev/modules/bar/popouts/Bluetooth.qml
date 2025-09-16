pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.utils as Utils
import qs.ds.list as Lists
import qs.ds.text as Text
import qs.ds as Ds
import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property Item wrapper

    spacing: Appearance.spacing.small

    width: Math.max(320, implicitWidth)

    Text.HeadingS {
        Layout.topMargin: Appearance.padding.normal
        Layout.rightMargin: Appearance.padding.small
        text: qsTr("Bluetooth %1").arg(BluetoothAdapterState.toString(Bluetooth.defaultAdapter?.state).toLowerCase())
    }

    Toggle {
        label: qsTr("Enabled")
        checked: Bluetooth.defaultAdapter?.enabled ?? false
        toggle.onToggled: {
            const adapter = Bluetooth.defaultAdapter;
            if (adapter)
                adapter.enabled = checked;
        }
    }

    Toggle {
        label: qsTr("Discovering")
        checked: Bluetooth.defaultAdapter?.discovering ?? false
        toggle.onToggled: {
            const adapter = Bluetooth.defaultAdapter;
            if (adapter)
                adapter.discovering = checked;
        }
    }

    Text.BodyS {
        Layout.topMargin: Appearance.spacing.small
        Layout.rightMargin: Appearance.padding.small
        text: {
            const devices = Bluetooth.devices.values;
            let available = qsTr("%1 device%2 available").arg(devices.length).arg(devices.length === 1 ? "" : "s");
            const connected = devices.filter(d => d.connected).length;
            if (connected > 0)
                available += qsTr(" (%1 connected)").arg(connected);
            return available;
        }
        disabled: true
    }

    Repeater {
        model: ScriptModel {
            values: [...Bluetooth.devices.values].sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired)).slice(0, 5)
        }

        Lists.ListItem {
            required property BluetoothDevice modelData
            readonly property bool loading: modelData.state === BluetoothDeviceState.Connecting || modelData.state === BluetoothDeviceState.Disconnecting
            
            leftIcon: Utils.Icons.getBluetoothIcon(modelData.icon)
            text: modelData.name
            selected: modelData.connected
            
            primaryFontIcon: modelData.connected ? "link_off" : "link"
            primaryActionActive: modelData.connected
            primaryActionLoading: loading
            
            secondaryFontIcon: modelData.bonded ? "delete" : ""
            secondaryActionActive: !modelData.bonded

            
            onPrimaryActionClicked: {
                modelData.connected = !modelData.connected;
            }
            
            onSecondaryActionClicked: {
                modelData.forget();
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
