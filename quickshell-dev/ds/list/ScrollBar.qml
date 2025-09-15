import QtQuick
import QtQuick.Controls
import qs.ds
import qs.ds.animations
import qs.services

ScrollBar {
    id: root
    
    property color scrollbarColor: Colours.palette.m3secondary

    topPadding: Foundations.spacing.m
    bottomPadding: Foundations.spacing.m
    
    contentItem: Rectangle {
        implicitWidth: 6
        opacity: root.pressed ? 1 : root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1) ? 0.5 : 0
        radius: Foundations.radius.all
        color: root.scrollbarColor
        
        Behavior on opacity {
            BasicNumberAnimation {}
        }
    }

    MouseArea {
        property int scrollAccumulatedY: 0

        z: -1
        anchors.fill: parent

        function onWheel(event: WheelEvent): void {
            if (event.angleDelta.y > 0)
                root.decrease();
            else if (event.angleDelta.y < 0)
                root.increase();
        }

        onWheel: event => {
            // Update accumulated scroll
            if (Math.sign(event.angleDelta.y) !== Math.sign(scrollAccumulatedY))
                scrollAccumulatedY = 0;
            scrollAccumulatedY += event.angleDelta.y;

            // Trigger handler and reset if above threshold
            if (Math.abs(scrollAccumulatedY) >= 120) {
                onWheel(event);
                scrollAccumulatedY = 0;
            }
        }
    }
}