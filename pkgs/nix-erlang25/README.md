# Erlang 25 for macOS and Linux

Este flake proporciona Erlang 25.3.2.20 para proyectos que requieren esta versión específica.

## Uso en tu proyecto

### Opción 1: Usando nix develop

```bash
nix develop ~/nixos-config/pkgs/nix-erlang25
```

### Opción 2: Usando direnv

Crea un `.envrc` en tu proyecto:

```bash
use flake ~/nixos-config/pkgs/nix-erlang25
```

Luego ejecuta `direnv allow`.

## Verificar versión

```bash
erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
```