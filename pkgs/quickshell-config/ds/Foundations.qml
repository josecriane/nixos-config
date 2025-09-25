pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property list<real> animCurve: [0.2, 0, 0, 1, 1, 1]
    property Duration duration: Duration {
    }
    property Font font: Font {
    }
    property ColorBase16 palette: ColorBase16 {
    }
    property Radius radius: Radius {
    }
    property Spacing spacing: Spacing {
    }

    component ColorBase16: QtObject {
        property color base00: "#303446";
        property color base01: "#292c3c";
        property color base02: "#414559";
        property color base03: "#51576d";
        property color base04: "#626880";
        property color base05: "#c6d0f5";
        property color base06: "#f2d5cf";
        property color base07: "#babbf1";
        property color base08: "#e78284";
        property color base09: "#ef9f76";
        property color base0A: "#e5c890";
        property color base0B: "#a6d189";
        property color base0C: "#81c0c8";
        property color base0D: "#8caaee";
        property color base0E: "#a57fbd";
        property color base0F: "#ca9ee6";
    }

    component Duration: QtObject {
        property int slow: 600
        property int standard: 400
        property int fast: 200
        property int fastest: 50
    }
    component Font: QtObject {
        property FontFamily family: FontFamily {
        }
        property FontSize size: FontSize {
        }
    }
    component FontFamily: QtObject {
        property string material: "Material Symbols Rounded"
        property string mono: "MesloLGS Nerd Font"
        property string sans: "NotoSans Nerd Font"
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
        property int xs: 8
    }
    component Spacing: QtObject {
        property int l: 15
        property int m: 12
        property int s: 10
        property int xl: 20
        property int xs: 7
        property int xxs: 5
    }
}
