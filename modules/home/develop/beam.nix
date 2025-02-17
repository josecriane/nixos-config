{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Erlang
    erlang_25
    rebar3
    erlang-ls

    # Elixir
    elixir_1_18
    elixir-ls
  ];

  home.sessionVariables = {
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  home.file.".erlang_ls.config".text = 
  ''
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