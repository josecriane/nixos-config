# NixOS Configuration

Personal NixOS/nix-darwin configuration using flakes for cross-platform system management.

## 🏗️ Architecture

This configuration supports multiple hosts with both **Linux (NixOS)** and **macOS (Darwin)** systems using a unified flake-based approach.

### Directory Structure

```
nixos-config/
├── flake.nix                 # Main entry point
├── hosts/                    # Host-specific configurations
│   ├── imre/                # Linux workstation
│   ├── newarre/             # Linux laptop
│   └── macbook-air/         # macOS laptop
├── modules/
│   ├── core/                # System-level configurations
│   │   ├── linux/          # NixOS-specific modules
│   │   └── macos/          # Darwin-specific modules
│   └── home/               # Home Manager configurations
│       ├── all/            # Cross-platform user configs
│       ├── desktop/        # Desktop applications
│       ├── develop/        # Development tools
│       └── wm/             # Window manager (niri)
│           └── niri/
│               ├── composed-ui/    # Traditional UI (waybar, wofi, swaync)
│               └── quickshell-ui/  # Modern Qt-based shell UI
└── pkgs/                   # Custom packages
    └── quickshell-config/  # Quickshell configuration package
        ├── ds/             # Design system components
        ├── modules/        # UI modules (bar, launcher, etc.)
        └── services/       # System services integration
```

## 🚀 Quick Start

### Linux (NixOS)
```bash
# Clone the repository
git clone <repo-url> ~/nixos-config
cd ~/nixos-config

# Build and switch
sudo nixos-rebuild switch --flake ~/nixos-config

# Update and rebuild
sudo nixos-rebuild switch --upgrade
```

### macOS (Darwin)
```bash
# Using the helper script
./assets/scripts-mac/nix-mac -s  # Build and switch
./assets/scripts-mac/nix-mac -l  # List generations
./assets/scripts-mac/nix-mac -r  # Rollback

# Or manually
sudo darwin-rebuild switch --flake ~/nixos-config#MacBookAir10-1-jose-cribeiro
```

## 🎨 Window Manager: niri

This configuration uses **niri**, a scrollable-tiling Wayland compositor, with a custom modular setup.

### Key Features
- **Quickshell** modern Qt-based shell (optional, can be toggled via `quickshell_config_enable`)
  - Custom design system with Stylix integration
  - Modular components (bar, launcher, notifications, dashboard)
  - Interactive command system
- **Waybar** status bar with custom styling (when Quickshell disabled)
- **wofi** application launcher (when Quickshell disabled)
- **swaync** notification center (when Quickshell disabled)
- **GTK** applications ecosystem
- **Adwaita Dark** unified theming

### Keybinds

| Shortcut | Action |
|----------|--------|
| `Meta + Space` | Open application launcher (wofi) |
| `Meta + E` | Emoji picker |
| `Meta + Alt + L` | Lock screen |
| `Meta + Q` | Close window |
| `Meta + Ctrl + Q` | Quit niri |
| `Meta + F` | Maximize column |
| `Meta + Shift + F` | Fullscreen window |

#### Navigation
| Shortcut | Action |
|----------|--------|
| `Meta + ←/→/↑/↓` | Focus column/window |
| `Meta + Shift + ←/→/↑/↓` | Move column/window |
| `Meta + Ctrl + ↑/↓` | Switch workspace |

#### Window Management
| Shortcut | Action |
|----------|--------|
| `Meta + ,` | Merge window into left column |
| `Meta + .` | Split window from column |
| `Meta + R` | Cycle column widths |
| `Meta + -/+` | Resize column width |
| `Meta + Alt + ←/→` | Resize window height |

#### System
| Shortcut | Action |
|----------|--------|
| `Meta + Ctrl + K` | Switch keyboard layout |
| `Meta + Shift + C` | Screenshot |
| `Meta + Alt + C` | Screenshot screen |
| `Meta + Ctrl + C` | Screenshot window |

### Configuration Structure

The niri configuration is modularized for easy customization:

```
modules/home/wm/niri/
├── default.nix          # Main configuration + imports
├── essential-gui/       # GUI applications & utilities
├── keybinds.kdl         # All keyboard shortcuts (composed-ui)
├── composed-ui/         # Traditional UI components (when quickshell disabled)
│   ├── waybar/          # Status bar config + CSS
│   ├── wofi/            # App launcher config + CSS
│   └── swaync/          # Notification center config + CSS
├── quickshell-ui/       # Quickshell integration (when enabled)
│   ├── default.nix      # Quickshell configuration
│   ├── commands.json    # Interactive commands
│   └── keybinds.kdl     # Quickshell keybindings
└── services.nix         # System services configuration
```

## 🛠️ Development Environment

### Included Tools
- **Languages**: Rust, Erlang/Elixir, Android development
- **Editors**: VS Code with Wayland support, Claude CLI
- **Terminal**: Alacritty with nerd fonts
- **Shell**: Zsh with custom configuration
- **Version Control**: Git with enhanced tooling

### Android Development
- Android Studio (Linux only)
- Android SDK with accepted licenses
- Platform-specific toolchains

## 📦 Package Management

### System Packages
- **Core tools**: git, vim, wget, tree, curl
- **Fonts**: All Nerd Fonts installed globally
- **Development**: Language-specific toolchains

### Home Manager
- **User applications**: Modular package organization
- **Dotfiles**: Centralized configuration management
- **Cross-platform**: Shared configs between Linux/macOS

## 🔒 Secrets Management

Uses **agenix** for encrypted secrets with a private git repository.

```bash
# Setup decryption key
./scripts/setup-agenix-key.sh
```

## 🎯 Features

### Security
- **Secure Boot**: Linux systems use lanzaboote
- **Encrypted secrets**: agenix integration
- **Polkit**: Proper privilege escalation

### Cross-Platform
- **Unified configuration**: Shared modules between NixOS/Darwin
- **Machine-specific options**: Host-based customization
- **Consistent tooling**: Same development environment everywhere

## 📝 Code Formatting

```bash
# Format all Nix files
treefmt

# Manual formatting
find . -name "*.nix" -exec nixfmt {} \;
```

## 🔧 Customization

### Adding a New Host
1. Create `hosts/<hostname>/` directory
2. Add `default.nix`, `hardware-configuration.nix`, `options.nix`
3. Update `flake.nix` with new host configuration
4. Set `quickshell_config_enable` in `options.nix` to choose UI system

### Adding Applications
- **System-wide**: Add to appropriate `modules/core/` file
- **User-specific**: Add to relevant `modules/home/` module
- **Window manager specific**: Add to `modules/home/wm/niri/essential-gui/`

### Customizing niri with Quickshell
- **Enable Quickshell**: Set `quickshell_config_enable = true` in host's `options.nix`
- **Commands**: Edit `modules/home/wm/niri/quickshell-ui/commands.json`
- **Excluded apps**: Edit `modules/home/wm/niri/quickshell-ui/excluded-apps.json`
- **Quickshell modules**: Edit files in `pkgs/quickshell-config/modules/`
- **Design system**: Customize `pkgs/quickshell-config/ds/` components

### Customizing niri with traditional UI (Waybar/Wofi/Swaync)
- **Enable traditional UI**: Set `quickshell_config_enable = false` in host's `options.nix`
- **Keybinds**: Edit `modules/home/wm/niri/composed-ui/keybinds.kdl`
- **Styling**: Modify CSS files in `composed-ui/waybar/`, `composed-ui/wofi/`, `composed-ui/swaync/`
- **Applications**: Update files in `essential-gui/`

### Useful Commands
```bash
# Check niri status
niri msg --help

# Restart niri session
systemctl --user restart niri

# View logs
journalctl --user -u niri

# Quickshell commands (when enabled)
quickshell-config                    # Run quickshell with custom config
~/.config/niri/start-quickshell      # Start/restart quickshell
pgrep -af quickshell                 # Check running quickshell processes
```

### Future Work:
- [ ] Quickshell
  - [ ] Connect to new wifi dont ask the password
  - [ ] DS
    - [ ] Review opacity animations
    - [ ] Propagate margin, radius and opacity to all components
  - [ ] Bar
    - [ ] Handle unknown icons
  - [ ] Notifications
    - [ ] Add notificationTime
    - [ ] Don't hide notification when hover
    - [ ] Group notifications
  - [ ] Launcher
    - [ ] Define interactive commands with a json
- [ ] Niri
  - [ ] New keybinds to handle windows{}
- [ ] Finish the initial setup script
- [ ] Remove built in bookmarks on nautilus (Starred, Recent)
- [ ] New hosts:
  - [ ] pihole
  - [ ] server
  - [ ] remote servers
- [ ] Create move-window-or-to-monitor-up/down and move-column-or-monitor-right. See: [focus](https://github.com/YaLTeR/niri/commit/a56e4ff436cc4f36d7cda89e985d51e37f0b4f78)

## 📚 References

### NixOS Resources
* [Nix Cookbook](https://nixos.wiki/wiki/Nix_Cookbook)
* [NixOS with Flakes Guide](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/get-started-with-nixos)
* [NixOS Secure Boot TPM FDE](https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/)

### Darwin Resources
* [NixOS Darwin Config Reference](https://github.com/dustinlyons/nixos-config/blob/main/README.md)

### Package & Options Search
* [NixOS Packages](https://search.nixos.org/packages?channel=25.05)
* [MyNixOS Packages](https://mynixos.com/packages)
* [Nix Darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
* [Home Manager Options](https://home-manager-options.extranix.com/?query=&release=release-25.05)

### WM Configuration
* [Niri Configuration Guide](https://github.com/YaLTeR/niri/wiki/Configuration:-Introduction)

### Quickshell
* [Quickshell](https://quickshell.org/docs/v0.2.0/types/Quickshell.Hyprland/HyprlandWorkspace/)
* [Caelestia-shell](https://github.com/caelestia-dots/shell)
* [Shovel-shell](https://github.com/shovelwithasprout/shovel-shell)

### NerdFonts Search
* [NerdFonts Cheatsheet](https://www.nerdfonts.com/cheat-sheet)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
