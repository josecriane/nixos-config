{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # Erlang
    erlang_28
    beamMinimal28Packages.rebar3

    # ELP compilado desde source (versión 2025-11-04)
    inputs.elp-from-source.packages.${pkgs.system}.default

    # Elixir
    elixir_1_18
    (lib.lowPrio elixir-ls)
  ];

  home.sessionVariables = {
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  home.file.".erlang_ls.config".text = ''
    {
      "include_dirs": [
        "include",
        "_build/default/lib"
      ],
      "deps_dirs": [
        "lib",
        "_build/default/lib"
      ],
      "diagnostics": {
        "enabled": true,
        "disabled": []
      },
      "code_reload": {
        "node": "erlang_ls"
      }
    }
  '';
}
