pragma Singleton

import Quickshell

Singleton {
    readonly property AppearanceConfig.Anim anim: Config.appearance.anim
    readonly property AppearanceConfig.FontStuff font: Config.appearance.font
    readonly property AppearanceConfig.Padding padding: Config.appearance.padding
    // Literally just here to shorten accessing stuff :woe:
    // Also kinda so I can keep accessing it with `Appearance.xxx` instead of `Config.appearance.xxx`
    readonly property AppearanceConfig.Rounding rounding: Config.appearance.rounding
    readonly property AppearanceConfig.Spacing spacing: Config.appearance.spacing
}
