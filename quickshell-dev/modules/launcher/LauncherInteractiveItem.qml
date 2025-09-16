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
    property alias hintButton: hintButton
    
    property string commandPrefix: ""
    property string hintIcon: "open_in_new"
    property string hintText: qsTr("Open")
    property var onHintClicked: function() { return true; }
    
    property var processCommand: ["echo"]
    property string placeholderText: qsTr("Type a command")
    property bool isError: false
    property int elideWidth: 300
    property var onProcessOutput: function(output) {}

    readonly property string input: list.search.text.slice(commandPrefix.length)
    readonly property alias data: root.input
    
    property string resultText: metrics.elidedText
    property color resultColor: {
        if (isError) return Colours.palette.m3error
        if (!input) return Colours.palette.m3onSurfaceVariant
        return Colours.palette.m3onSurface
    }
    
    visibilities: list.visibilities

    modelData: LauncherItemModel {
        name: ""
        subtitle: ""
        isAction: true
        actionIcon: "function"
        
        function onActivate() {
            Quickshell.execDetached(["sh", "-c", `echo '${root.input}' | wl-copy`]);
            return true;
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: Foundations.spacing.m

        DsText.BodyM {
            id: result
            
            color: root.resultColor
            text: root.resultText
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
        }

        DsButtons.HintButton {
            id: hintButton
            Layout.alignment: Qt.AlignVCenter
            
            icon: root.hintIcon
            hint: root.hintText
            
            onClicked: {
                const shouldClose = root.onHintClicked();
                if (shouldClose) {
                    root.list.visibilities.launcher = false;
                }
            }
        }
    }
    
    Process {
        id: process
        
        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished: {
                const output = stdoutCollector.text.trim();
                metrics.text = output;
                
                root.onProcessOutput(output);
            }
        }
    }
    
    TextMetrics {
        id: metrics
        text: root.placeholderText
        elide: Text.ElideRight
        elideWidth: root.elideWidth
    }
    
    Component.onCompleted: {
        metrics.text = root.placeholderText;
    }
    
    onInputChanged: {
        if (input && processCommand.length > 0) {
            process.command = processCommand.concat([input]);
            process.running = true;
        } else if (!input) {
            process.running = false;
            metrics.text = root.placeholderText;
            root.isError = false;
        }
    }
}