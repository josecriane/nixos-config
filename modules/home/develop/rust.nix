{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    rust-analyzer
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