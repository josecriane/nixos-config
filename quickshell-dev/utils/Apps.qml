pragma Singleton

import Quickshell

Singleton {
    id: root

    // Map app_id to Nerd Font icons
    readonly property var appIcons: ({
            "firefox": "󰈹",
            "chrome": "",
            "chromium": "",
            "brave": "󰈹",
            "code": "󰨞",
            "codium": "󰨞",
            "vim": "",
            "nvim": "",
            "neovim": "",
            "terminal": "",
            "alacritty": "",
            "discord": "",
            "telegram": "",
            "vlc": "󰕼",
            "teams-for-linux": "󰊻"
        })

    // Common app name suffixes to remove from window titles
    readonly property var titleSuffixes: [" — Mozilla Firefox", " - Visual Studio Code", " — Google Chrome", " - Chromium", " - Brave", " — Discord", " - Telegram", " — Slack", " - Spotify", " — VLC media player", " - Alacritty", " | Microsoft Teams"]

    // Clean window title by removing app name suffixes
    function cleanTitle(title: string): string {
        if (!title)
            return "";

        let cleaned = title;
        for (const suffix of titleSuffixes) {
            if (cleaned.endsWith(suffix)) {
                cleaned = cleaned.slice(0, -suffix.length);
                break;
            }
        }

        return cleaned;
    }

    // Get icon for an app based on its app_id
    function getIcon(appId: string): string {
        if (!appId)
            return "";
        const lower = appId.toLowerCase();

        // Check exact match first
        if (appIcons[lower])
            return appIcons[lower];

        // Check partial matches
        for (const [key, icon] of Object.entries(appIcons)) {
            if (lower.includes(key))
                return icon;
        }

        return "";
    }
}
