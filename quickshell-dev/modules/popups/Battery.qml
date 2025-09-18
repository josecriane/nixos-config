pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.ds.text as Text
import qs.ds.icons as Icons
import Quickshell.Services.UPower
import QtQuick
import qs.ds.animations
import qs.ds.buttons.circularButtons as CircularButtons

Column {
    id: root

    spacing: Foundations.spacing.m

    Text.BodyM {
        text: UPower.displayDevice.isLaptopBattery ? qsTr("Remaining: %1%").arg(Math.round(UPower.displayDevice.percentage * 100)) : qsTr("No battery detected")
    }
    Text.BodyS {
        function formatSeconds(s: int, fallback: string): string {
            const day = Math.floor(s / 86400);
            const hr = Math.floor(s / 3600) % 60;
            const min = Math.floor(s / 60) % 60;

            let comps = [];
            if (day > 0)
                comps.push(`${day} days`);
            if (hr > 0)
                comps.push(`${hr} hours`);
            if (min > 0)
                comps.push(`${min} mins`);

            return comps.join(", ") || fallback;
        }

        text: UPower.displayDevice.isLaptopBattery ? qsTr("Time %1: %2").arg(UPower.onBattery ? "remaining" : "until charged").arg(UPower.onBattery ? formatSeconds(UPower.displayDevice.timeToEmpty, "Calculating...") : formatSeconds(UPower.displayDevice.timeToFull, "Fully charged!")) : qsTr("Power profile: %1").arg(PowerProfile.toString(PowerProfiles.profile))
    }
    Loader {
        active: PowerProfiles.degradationReason !== PerformanceDegradationReason.None
        anchors.horizontalCenter: parent.horizontalCenter
        asynchronous: true
        height: active ? (item?.implicitHeight ?? 0) : 0

        sourceComponent: Rectangle {
            color: Foundations.palette.base08
            implicitHeight: child.implicitHeight + Foundations.spacing.xs * 2
            implicitWidth: child.implicitWidth + Foundations.spacing.s * 2
            radius: Foundations.radius.m

            Column {
                id: child

                anchors.centerIn: parent

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Foundations.spacing.s

                    Icons.MaterialFontIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -font.pointSize / 10
                        color: Foundations.palette.base08
                        text: "warning"
                    }
                    Text.HeadingS {
                        anchors.verticalCenter: parent.verticalCenter
                        color: Foundations.palette.base08
                        font.family: Foundations.font.family.mono
                        text: qsTr("Performance Degraded")
                    }
                    Icons.MaterialFontIcon {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -font.pointSize / 10
                        color: Foundations.palette.base08
                        text: "warning"
                    }
                }
                Text.BodyM {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Foundations.palette.base08
                    text: qsTr("Reason: %1").arg(PerformanceDegradationReason.toString(PowerProfiles.degradationReason))
                }
            }
        }
    }
    Rectangle {
        id: profiles

        property string current: {
            const p = PowerProfiles.profile;
            if (p === PowerProfile.PowerSaver)
                return saver.icon;
            if (p === PowerProfile.Performance)
                return perf.icon;
            return balance.icon;
        }

        anchors.horizontalCenter: parent.horizontalCenter
        color: Foundations.palette.base02
        implicitHeight: Math.max(saver.implicitHeight, balance.implicitHeight, perf.implicitHeight) + Foundations.spacing.xxs * 2
        implicitWidth: saver.implicitHeight + balance.implicitHeight + perf.implicitHeight + Foundations.spacing.s * 2 + Foundations.spacing.l * 2
        radius: Foundations.radius.all

        Rectangle {
            id: indicator

            color: Foundations.palette.base05
            radius: Foundations.radius.all
            state: profiles.current

            states: [
                State {
                    name: saver.icon

                    Fill {
                        item: saver
                    }
                },
                State {
                    name: balance.icon

                    Fill {
                        item: balance
                    }
                },
                State {
                    name: perf.icon

                    Fill {
                        item: perf
                    }
                }
            ]
            transitions: Transition {
                AnchorAnimation {
                    duration: Foundations.duration.standard
                    easing.bezierCurve: Foundations.animCurve
                }
            }
        }
        CircularButtons.L {
            id: saver

            active: profiles.current === icon
            activeForegroundColor: Foundations.palette.base03
            anchors.left: parent.left
            anchors.leftMargin: Foundations.spacing.xxs
            anchors.verticalCenter: parent.verticalCenter
            icon: "energy_savings_leaf"

            onClicked: {
                PowerProfiles.profile = PowerProfile.PowerSaver;
            }
        }
        CircularButtons.L {
            id: balance

            active: profiles.current === icon
            activeForegroundColor: Foundations.palette.base03
            anchors.centerIn: parent
            icon: "balance"

            onClicked: {
                PowerProfiles.profile = PowerProfile.Balanced;
            }
        }
        CircularButtons.L {
            id: perf

            active: profiles.current === icon
            activeForegroundColor: Foundations.palette.base03
            anchors.right: parent.right
            anchors.rightMargin: Foundations.spacing.xxs
            anchors.verticalCenter: parent.verticalCenter
            icon: "rocket_launch"

            onClicked: {
                PowerProfiles.profile = PowerProfile.Performance;
            }
        }
    }

    component Fill: AnchorChanges {
        required property Item item

        anchors.bottom: item.bottom
        anchors.left: item.left
        anchors.right: item.right
        anchors.top: item.top
        target: indicator
    }
}
