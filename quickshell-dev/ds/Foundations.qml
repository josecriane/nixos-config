pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property Font font: Font {}
    property Radius radius: Radius {}
    property Spacing spacing: Spacing {}

    component Font: QtObject {
        property FontFamily family: FontFamily {}
        property FontSize size: FontSize {}
    }

    component FontFamily: QtObject {
        property string sans: "Rubik"
        property string mono: "CaskaydiaCove NF"
        property string material: "Material Symbols Rounded"
        property string clock: "Rubik"
    }

    component FontSize: QtObject {
        property int xs: 10
        property int s: 12
        property int m: 14
        property int l: 18
        property int xl: 20
    }

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
}
