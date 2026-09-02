{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # Erlang
    beam28Packages.erlang
    beamMinimal28Packages.rebar3
    erlang-language-platform

    # Elixir
    beamPackages.elixir_1_18
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
