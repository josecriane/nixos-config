pragma ComponentBehavior: Bound

import qs.services
import qs.ds
import qs.ds.text as Text
import QtQuick

Item {
    id: root

    signal clicked()

    implicitWidth: dateText.implicitWidth
    implicitHeight: dateText.implicitHeight

    Text.BodyM {
        id: dateText

        font.family: Foundations.font.family.mono
        text: Time.format("ddd dd MMM  HH:mm")
        interactive: true
        
        onClicked: root.clicked()
    }
}
