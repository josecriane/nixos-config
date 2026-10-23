## Nix

Applies to Nix work: flakes, NixOS and Home Manager modules, package
derivations. Read `rules/engineering-discipline.md` for the language-neutral
rules on results, tests, and verification.

### Commands

- Format: `nix fmt`
- Evaluate and build every output: `nix flake check`
- Read one option: `nix eval --raw .#nixosConfigurations.<host>.config.<option>`
- Update one input: `nix flake update <input>`

### Code Style

- Format with `nix fmt`. The flake declares the formatter.
- `lowerCamelCase` for attribute names, kebab-case for file names.
- Explicit function arguments. No `args: with args;`. No `with pkgs;` at
  file scope. Inside a package list it is fine.
- One module per concern. A setting that belongs to one machine goes under
  that machine. A shared setting goes under the shared modules.

### Comments

No comments, including on an override, a patch or a version pin. Say why in
the reply. `rules/code-comments.md` lists the exceptions.

### Dependencies

The inputs in `flake.nix` and the pins in `flake.lock` change only with
agreement. Name the input, what it buys, and what it pins.

### Verification

`nix fmt`, then `nix flake check`. Read the whole output. An evaluation
warning is a defect.
