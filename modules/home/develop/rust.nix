{ pkgs, ... }:
let
  # Apply the fix from PR #433196
  rust-analyzer-fixed = pkgs.rust-analyzer.override {
    rust-analyzer-unwrapped = pkgs.rust-analyzer-unwrapped.overrideAttrs (oldAttrs: {
      src = oldAttrs.src.overrideAttrs (srcAttrs: {
        outputHash = "sha256-fuHLsvM5z5/5ia3yL0/mr472wXnxSrtXECa+pspQchA=";
      });
    });
  };
in
{
  home.packages = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    rust-analyzer-fixed
    clippy

    # Additional tools
    cargo-watch
    cargo-edit
    cargo-expand
  ];

  home.sessionVariables = {
    RUST_BACKTRACE = "1";
  };
}
