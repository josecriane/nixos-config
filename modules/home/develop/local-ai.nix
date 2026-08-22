{
  config,
  pkgs,
  ...
}:
let
  # Ollama exposes both an OpenAI- and an Anthropic-compatible API here.
  ollamaUrl = "http://127.0.0.1:11434";

  # MoE with ~3B active params, so it stays fast on the iGPU while keeping
  # tool-calling and a 256K context. Use qwen3.8:27b instead when quality or
  # vision matters more than tokens/s.
  defaultModel = "qwen3.6:35b-a3b";

  # Separate entry point so the cloud `claude` keeps working untouched.
  claude-local = pkgs.writeShellScriptBin "claude-local" ''
    export ANTHROPIC_BASE_URL="${ollamaUrl}"
    export ANTHROPIC_AUTH_TOKEN="ollama"
    export ANTHROPIC_MODEL="${defaultModel}"
    # Claude Code falls back to a small model for cheap subtasks; point it at
    # the same local one so it never reaches for the cloud.
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="${defaultModel}"
    export ANTHROPIC_SMALL_FAST_MODEL="${defaultModel}"
    exec ${config.programs.claude-code.finalPackage}/bin/claude "$@"
  '';
in
{
  home.packages = [
    pkgs.opencode
    claude-local
  ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = "ollama/${defaultModel}";
    provider.ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options.baseURL = "${ollamaUrl}/v1";
      models = {
        "qwen3.6:35b-a3b".name = "Qwen3.6 35B-A3B";
        "qwen3.8:27b".name = "Qwen3.8 27B";
        "qwen3-coder:30b".name = "Qwen3 Coder 30B";
      };
    };
  };
}
