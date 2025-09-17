import qs.services
import qs.config
import qs.ds.text as Text
import QtQuick
import QtQuick.Layouts
import qs.ds.animations

RowLayout {
    id: root

    readonly property int padding: Appearance.padding.large

    function displayTemp(temp: real): string {
        return `${Math.ceil(temp)}°C`;
    }

    spacing: Appearance.spacing.large * 3

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.bottomMargin: root.padding
        Layout.leftMargin: root.padding * 2
        Layout.topMargin: root.padding
        label1: root.displayTemp(SystemUsage.gpuTemp)
        label2: `${Math.round(SystemUsage.gpuPerc * 100)}%`
        sublabel1: qsTr("GPU temp")
        sublabel2: qsTr("Usage")
        value1: Math.min(1, SystemUsage.gpuTemp / 90)
        value2: SystemUsage.gpuPerc
    }
    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.bottomMargin: root.padding
        Layout.topMargin: root.padding
        label1: root.displayTemp(SystemUsage.cpuTemp)
        label2: `${Math.round(SystemUsage.cpuPerc * 100)}%`
        primary: true
        sublabel1: qsTr("CPU temp")
        sublabel2: qsTr("Usage")
        value1: Math.min(1, SystemUsage.cpuTemp / 90)
        value2: SystemUsage.cpuPerc
    }
    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.bottomMargin: root.padding
        Layout.rightMargin: root.padding * 3
        Layout.topMargin: root.padding
        label1: {
            const fmt = SystemUsage.formatKib(SystemUsage.memUsed);
            return `${+fmt.value.toFixed(1)}${fmt.unit}`;
        }
        label2: {
            const fmt = SystemUsage.formatKib(SystemUsage.storageUsed);
            return `${Math.floor(fmt.value)}${fmt.unit}`;
        }
        sublabel1: qsTr("Memory")
        sublabel2: qsTr("Storage")
        value1: SystemUsage.memPerc
        value2: SystemUsage.storagePerc
    }

    component Resource: Item {
        id: res

        property color bg1: Colours.palette.m3primaryContainer
        property color bg2: Colours.palette.m3secondaryContainer
        property color fg1: Colours.palette.m3primary
        property color fg2: Colours.palette.m3secondary
        required property string label1
        required property string label2
        property bool primary
        readonly property real primaryMult: primary ? 1.2 : 1
        required property string sublabel1
        required property string sublabel2
        readonly property real thickness: 10 * primaryMult
        required property real value1
        required property real value2

        implicitHeight: 200 * primaryMult
        implicitWidth: 200 * primaryMult

        Behavior on bg1 {
            BasicColorAnimation {
            }
        }
        Behavior on bg2 {
            BasicColorAnimation {
            }
        }
        Behavior on fg1 {
            BasicColorAnimation {
            }
        }
        Behavior on fg2 {
            BasicColorAnimation {
            }
        }
        Behavior on value1 {
            BasicNumberAnimation {
            }
        }
        Behavior on value2 {
            BasicNumberAnimation {
            }
        }

        onBg1Changed: canvas.requestPaint()
        onBg2Changed: canvas.requestPaint()
        onFg1Changed: canvas.requestPaint()
        onFg2Changed: canvas.requestPaint()
        onValue1Changed: canvas.requestPaint()
        onValue2Changed: canvas.requestPaint()

        Column {
            anchors.centerIn: parent

            Text.HeadingL {
                anchors.horizontalCenter: parent.horizontalCenter
                text: res.label1
            }
            Text.HeadingS {
                anchors.horizontalCenter: parent.horizontalCenter
                text: res.sublabel1
            }
        }
        Column {
            anchors.horizontalCenter: parent.right
            anchors.horizontalCenterOffset: -res.thickness / 2
            anchors.top: parent.verticalCenter
            anchors.topMargin: res.thickness / 2 + Appearance.spacing.small

            Text.HeadingS {
                anchors.horizontalCenter: parent.horizontalCenter
                text: res.label2
            }
            Text.BodyS {
                anchors.horizontalCenter: parent.horizontalCenter
                text: res.sublabel2
            }
        }
        Canvas {
            id: canvas

            readonly property real arc1End: degToRad(220)
            readonly property real arc1Start: degToRad(45)
            readonly property real arc2End: degToRad(360)
            readonly property real arc2Start: degToRad(230)
            readonly property real centerX: width / 2
            readonly property real centerY: height / 2

            function degToRad(deg: int): real {
                return deg * Math.PI / 180;
            }

            anchors.fill: parent

            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();

                ctx.lineWidth = res.thickness;
                ctx.lineCap = Appearance.rounding.scale === 0 ? "square" : "round";

                const radius = (Math.min(width, height) - ctx.lineWidth) / 2;
                const cx = centerX;
                const cy = centerY;
                const a1s = arc1Start;
                const a1e = arc1End;
                const a2s = arc2Start;
                const a2e = arc2End;

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a1s, a1e, false);
                ctx.strokeStyle = res.bg1;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a1s, (a1e - a1s) * res.value1 + a1s, false);
                ctx.strokeStyle = res.fg1;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a2s, a2e, false);
                ctx.strokeStyle = res.bg2;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a2s, (a2e - a2s) * res.value2 + a2s, false);
                ctx.strokeStyle = res.fg2;
                ctx.stroke();
            }
        }
    }
}
