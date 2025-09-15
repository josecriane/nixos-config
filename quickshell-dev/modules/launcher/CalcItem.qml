import "services"
import qs.services
import qs.config
import qs.ds.text as DsText
import qs.ds.buttons as DsButtons
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import qs.ds.animations
import qs.ds

LauncherItem {
    id: root

    required property var list
    readonly property string math: list.search.text.slice(">calc ".length)
    
    visibilities: list.visibilities

    // Override LauncherItem properties
    modelData: LauncherItemModel {
        name: ""
        subtitle: ""
        isAction: true
        actionIcon: "function"
        closeLauncher: true
        
        function onActivate() {
            Quickshell.execDetached(["sh", "-c", `qalc -t -m 100 '${root.math}' | wl-copy`]);
        }
    }

    onMathChanged: {
        if (math) {
            qalcProc.command = ["qalc", "-m", "100", math];
            qalcProc.running = true;
        }
    }

    Binding {
        id: binding
        when: root.math.length > 0
        target: metrics
        property: "text"
    }

    Process {
        id: qalcProc
        stdout: StdioCollector {
            onStreamFinished: binding.value = text.trim()
        }
    }

    TextMetrics {
        id: metrics
        text: qsTr("Type an expression to calculate")
        elide: Text.ElideRight
        elideWidth: 300
    }

    RowLayout {
        anchors.fill: parent
        spacing: Foundations.spacing.m

        DsText.BodyM {
            id: result
            
            color: {
                if (metrics.text.includes("error: "))
                    return Colours.palette.m3error;
                if (!root.math)
                    return Colours.palette.m3onSurfaceVariant;
                return Colours.palette.m3onSurface;
            }

            text: metrics.elidedText
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
        }

        DsButtons.HintButton {
            Layout.alignment: Qt.AlignVCenter
            
            icon: "open_in_new"
            hint: qsTr("Open in calculator")
            
            onClicked: {
                root.list.visibilities.launcher = false;
            }
        }
    }
}
