import QtQuick

QtObject {
    id: style

    readonly property var __base00: "#303446"  // Background
    readonly property var __base01: "#292c3c"  // Lighter background
    readonly property var __base02: "#414559"  // Selection background
    readonly property var __base03: "#51576d"  // Comments
    readonly property var __base04: "#626880"  // Dark foreground
    readonly property var __base05: "#c6d0f5"  // Default foreground
    readonly property var __base06: "#f2d5cf"  // Light foreground
    readonly property var __base07: "#babbf1"  // Lightest foreground

    readonly property var __base08: "#e78284"  // Red
    readonly property var __base09: "#ef9f76"  // Orange
    readonly property var __base0A: "#e5c890"  // Yellow
    readonly property var __base0B: "#a6d189"  // Green
    readonly property var __base0C: "#81c0c8"  // Cyan
    readonly property var __base0D: "#8caaee"  // Blue
    readonly property var __base0E: "#a57fbd"  // Magenta
    readonly property var __base0F: "#ca9ee6"  // Brown

    property QtObject colors: QtObject {
        property string background: style.__base00
        property string surface: style.__base01
        property string surfaceVariant: style.__base03
        property string onBackground: style.__base02
        property string onSurfaceBackground: style.__base06

        property string primary: style.__base05
        property string lighter: style.__base07
        property string secondary: style.__base04

        property string accent: style.__base0D
        property string error: style.__base08
        property string warning: style.__base0A
        property string success: style.__base0B
    }

    property QtObject fonts: QtObject {
        property string monospace: "JetBrains Mono"
        property string emoji: "Noto Color Emoji"
        property string system: "Inter"

        property QtObject size: QtObject {
            property int small: 11
            property int normal: 13
            property int large: 16
            property int extraLarge: 18
        }
    }

    property QtObject spacing: QtObject {
        property int small: 5
        property int normal: 10
        property int large: 15
        property int extraLarge: 20
    }

    property QtObject radius: QtObject {
        property int small: 8
        property int normal: 12
    }

    property QtObject opacity: QtObject {
        property real background: 0.95
    }
}
