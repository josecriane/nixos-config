pragma Singleton
pragma ComponentBehavior: Bound

import qs.config
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property M3Palette palette: M3Palette {
    }

    component M3Palette: QtObject {
        property color m3background: "#181115"
        property color m3error: "#ffb4ab"
        property color m3errorContainer: "#93000a"
        property color m3inverseOnSurface: "#362e32"
        property color m3inversePrimary: "#864b6e"
        property color m3inverseSurface: "#eddfe4"
        property color m3neutral_paletteKeyColor: "#7f7478"
        property color m3neutral_variant_paletteKeyColor: "#827379"
        property color m3onBackground: "#eddfe4"
        property color m3onError: "#690005"
        property color m3onErrorContainer: "#ffdad6"
        property color m3onPrimary: "#511d3e"
        property color m3onPrimaryContainer: "#ffd8ea"
        property color m3onPrimaryFixed: "#370728"
        property color m3onPrimaryFixedVariant: "#6b3455"
        property color m3onSecondary: "#402a36"
        property color m3onSecondaryContainer: "#fcd9e9"
        property color m3onSecondaryFixed: "#291520"
        property color m3onSecondaryFixedVariant: "#58404c"
        property color m3onSurface: "#eddfe4"
        property color m3onSurfaceVariant: "#d3c2c9"
        property color m3onTertiary: "#4a2713"
        property color m3onTertiaryContainer: "#000000"
        property color m3onTertiaryFixed: "#311302"
        property color m3onTertiaryFixedVariant: "#653d27"
        property color m3outline: "#9c8d93"
        property color m3outlineVariant: "#504349"
        property color m3primary: "#fbb1d8"
        property color m3primaryContainer: "#6b3455"
        property color m3primaryFixed: "#ffd8ea"
        property color m3primaryFixedDim: "#fbb1d8"
        property color m3primary_paletteKeyColor: "#a26387"
        property color m3scrim: "#000000"
        property color m3secondary: "#dfbecd"
        property color m3secondaryContainer: "#5a424f"
        property color m3secondaryFixed: "#fcd9e9"
        property color m3secondaryFixedDim: "#dfbecd"
        property color m3secondary_paletteKeyColor: "#8b6f7d"
        property color m3shadow: "#000000"
        property color m3surface: "#181115"
        property color m3surfaceBright: "#40373b"
        property color m3surfaceContainer: "#251e21"
        property color m3surfaceContainerHigh: "#30282b"
        property color m3surfaceContainerHighest: "#3b3236"
        property color m3surfaceContainerLow: "#211a1d"
        property color m3surfaceContainerLowest: "#130c10"
        property color m3surfaceDim: "#181115"
        property color m3surfaceTint: "#fbb1d8"
        property color m3surfaceVariant: "#504349"
        property color m3tertiary: "#f3ba9c"
        property color m3tertiaryContainer: "#b8856a"
        property color m3tertiaryFixed: "#ffdbca"
        property color m3tertiaryFixedDim: "#f3ba9c"
        property color m3tertiary_paletteKeyColor: "#9c6c53"
        property color term0: "#353434"
        property color term1: "#fe45a7"
        property color term10: "#ffd2d5"
        property color term11: "#fff1f2"
        property color term12: "#babfdd"
        property color term13: "#f3a9cd"
        property color term14: "#ffd1c0"
        property color term15: "#ffffff"
        property color term2: "#ffbac0"
        property color term3: "#ffdee3"
        property color term4: "#b3a2d5"
        property color term5: "#e491bd"
        property color term6: "#ffba93"
        property color term7: "#edd2d5"
        property color term8: "#b29ea1"
        property color term9: "#ff7db7"
    }
}
