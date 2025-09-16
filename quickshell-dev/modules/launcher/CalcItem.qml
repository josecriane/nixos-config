import qs.services
import Quickshell

LauncherInteractiveItem {
    id: root

    readonly property alias math: root.data

    commandPrefix: ">calc "
    hintIcon: "function"
    hintText: qsTr("Open in calculator")
    placeholderText: qsTr("Type an expression to calculate")
    processCommand: ["qalc", "-m", "100"]

    modelData: LauncherItemModel {
        function onActivate() {
            Quickshell.execDetached(["sh", "-c", `qalc -t -m 100 '${root.math}' | wl-copy`]);
            return true;  // Close launcher after copying result
        }

        fontIcon: "function"
        isAction: true
        name: ""
        subtitle: ""
    }

    onHintClicked: function () {
        Niri.spawn(`alacritty -e qalc -i '${root.math}'`);
        return true;
    }
    onProcessOutput: function (output) {
        root.isError = output.includes("error: ") || output.includes("warning: ");
    }
}
