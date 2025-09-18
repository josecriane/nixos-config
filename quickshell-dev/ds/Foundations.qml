pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property AnimCurves animCurves: AnimCurves {
    }
    property Duration duration: Duration {
    }
    property Font font: Font {
    }
    property Radius radius: Radius {
    }
    property Spacing spacing: Spacing {
    }

    component AnimCurves: QtObject {
        property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> expressive: [0.38, 1.21, 0.22, 1, 1, 1]
        property list<real> standard: [0.2, 0, 0, 1, 1, 1]
    }
    component Duration: QtObject {
        property int slow: 600
        property int standard: 400
        property int fast: 200
        property int fastest: 50
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
        property int xxs: 5
        property int zero: 0
    }
}
