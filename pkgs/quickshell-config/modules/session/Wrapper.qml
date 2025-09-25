import qs.ds
import Quickshell
import QtQuick
import qs.ds.animations
import qs.shell

BackgroundWrapper {
    id: root

    readonly property bool hasCurrent: visibilities.session
    required property PersistentProperties visibilities

    implicitHeight: content.implicitHeight
    implicitWidth: 0
    visible: width > 0

    states: State {
        name: "visible"
        when: root.visibilities.session

        PropertyChanges {
            root.implicitWidth: content.implicitWidth
        }
    }
    transitions: [
        Transition {
            from: ""
            to: "visible"

            BasicNumberAnimation {
                property: "implicitWidth"
                target: root
            }
        },
        Transition {
            from: "visible"
            to: ""

            BasicNumberAnimation {
                property: "implicitWidth"
                target: root
            }
        }
    ]

    Content {
        id: content

        visibilities: root.visibilities
    }
}
