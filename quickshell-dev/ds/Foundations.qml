pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property Spacing spacing: Spacing {}
    property Radius radius: Radius {}
    property Font font: Font {}


    component Radius: QtObject {
        property int xxs: 4
        property int xs: 8
        property int s: 12
        property int m: 16
        property int l: 20
        property int xl: 24
        property int all: 500
    }

    component Spacing: QtObject {
        property int xs: 7
        property int s: 10
        property int m: 12
        property int l: 15
        property int xl: 20
    }
    
    component Font: QtObject {
        property int xs: 10
        property int s: 12
        property int m: 14
        property int l: 16
        property int xl: 18
    }
}
