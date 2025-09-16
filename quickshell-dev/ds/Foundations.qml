pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property Duration duration: Duration {
    }
    property Font font: Font {
    }
    property Radius radius: Radius {
    }
    property Spacing spacing: Spacing {
    }

    component Duration: QtObject {
        property int l: 800
        property int m: 400
        property int s: 200
        property int xl: 1200
        property int xs: 50
        property int zero: 0
    }
    component Font: QtObject {
        property FontFamily family: FontFamily {
        }
        property FontSize size: FontSize {
        }
    }
    component FontFamily: QtObject {
        property string clock: "Rubik"
        property string material: "Material Symbols Rounded"
        property string mono: "CaskaydiaCove NF"
        property string sans: "Rubik"
    }
    component FontSize: QtObject {
        property int l: 18
        property int m: 14
        property int s: 12
        property int xl: 20
        property int xs: 10
    }
    component Radius: QtObject {
        property int all: 500
        property int l: 20
        property int m: 16
        property int s: 12
        property int xl: 24
        property int xs: 8
        property int xxs: 4
        property int zero: 0
    }
    component Spacing: QtObject {
        property int l: 15
        property int m: 12
        property int s: 10
        property int xl: 20
        property int xs: 7
        property int xxs: 2
        property int zero: 0
    }
}
