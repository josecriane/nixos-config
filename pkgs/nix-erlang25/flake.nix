{
  description = "Erlang 25 build with rebar3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        erlang_25 = pkgs.callPackage ./erlang-builder.nix {
          wxGTK = pkgs.wxGTK32;
          parallelBuild = true;
        };

        # Create a custom beam package set with our Erlang 25
        customBeamPackages = pkgs.beam.packagesWith erlang_25;

        # Use rebar3 from our custom beam packages
        rebar3_with_erlang25 = customBeamPackages.rebar3;
      in
      {
        packages = {
          erlang = erlang_25;
          rebar3 = rebar3_with_erlang25;
          default = erlang_25;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            erlang_25
            rebar3_with_erlang25
          ];

          shellHook = ''
            echo "Erlang 25 development environment"
            echo "Erlang version: $(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell)"
            echo "Rebar3 version: $(rebar3 version)"
          '';
        };
      }
    );
}
