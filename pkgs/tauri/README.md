# Tauri Development Environment

Este flake proporciona un entorno de desarrollo completo para proyectos Tauri con todas las dependencias necesarias.

## Uso en tu proyecto

### Opción 1: Usando nix develop

```bash
# En el directorio de tu proyecto
nix develop ~/nixos-config/pkgs/tauri
```

### Opción 2: Usando direnv

Crea un `.envrc` en tu proyecto:

```bash
use flake ~/nixos-config/pkgs/tauri
```

Luego ejecuta `direnv allow`.

## Verificar instalación

```bash
# Verificar Rust
rustc --version

# Verificar Cargo
cargo --version

# Verificar las herramientas de Tauri
cargo tauri --version
```

## Crear un nuevo proyecto Tauri

```bash
cargo create-tauri-app
```