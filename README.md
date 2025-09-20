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
│       └── wm/             # Window managers (niri, plasma)
└── pkgs/                   # Custom packages
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

This configuration primarily uses **niri**, a scrollable-tiling Wayland compositor, with a custom modular setup.

### Key Features
- **GDM** login manager with Wayland support
- **Waybar** status bar with custom styling
- **wofi** application launcher
- **swaync** notification center
- **GNOME** applications ecosystem
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
├── essential-gui.nix    # GUI applications & utilities
├── themes.nix           # Qt/GTK theming
├── keybinds.kdl         # All keyboard shortcuts
├── waybar/              # Status bar config + CSS
├── wofi/                # App launcher config + CSS
└── swaync/              # Notification center config + CSS
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

### Adding Applications
- **System-wide**: Add to appropriate `modules/core/` file
- **User-specific**: Add to relevant `modules/home/` module
- **Window manager specific**: Add to `modules/home/wm/niri/essential-gui.nix`

### Customizing niri
- **Keybinds**: Edit `modules/home/wm/niri/keybinds.kdl`
- **Styling**: Modify CSS files in `waybar/`, `wofi/`, `swaync/`
- **Applications**: Update `essential-gui.nix`

### Useful Commands
```bash
# Check niri status
niri msg --help

# Restart niri session  
systemctl --user restart niri

# View logs
journalctl --user -u niri
```

### Future Work:
- [ ] Quickshell Redo
  - [ ] Notifications
    - [ ] Refactor notificationItem
  - [ ] Remove old niri components
    - [ ] Waybar
    - [ ] Swaync
    - [ ] Wofi

- [ ] Quickshell work after merge
  - [ ] Add local flake to install Quickshell
  - [ ] Use stylix colors
  - [ ] DS
    - [ ] Review opacity animations
    - [ ] Propagate margin and radius to all components
  - [ ] Notifications
    - [ ] Group notifications
  - [ ] Launcher
    - [ ] Filter .desktop apps
    - [ ] Separate Session commands using !
    - [ ] Launch de shortcut using #
    - [ ] Define commands with a yml or a json

- [ ] Use directory name on zellij tab name
- [ ] Remove Electron alerts (as VSCode)
- [ ] Install steam
- [ ] Take a look at:
  - [ ] https://syncthing.net
- [ ] Finish the initial setup script
- [ ] Remove built in bookmarks on nautilus (Starred, Recent)
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
* [Plasma Manager Options](https://nix-community.github.io/plasma-manager/options.xhtml)
* [Niri Configuration Guide](https://github.com/YaLTeR/niri/wiki/Configuration:-Introduction)

### Quickshell
* [Quickshell](https://quickshell.org/docs/v0.2.0/types/Quickshell.Hyprland/HyprlandWorkspace/)
* [Caelestia-shell](https://github.com/caelestia-dots/shell)
* [Shovel-shell](https://github.com/shovelwithasprout/shovel-shell)

### NerdFonts Search
* [NerdFonts Cheatsheet](https://www.nerdfonts.com/cheat-sheet)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
