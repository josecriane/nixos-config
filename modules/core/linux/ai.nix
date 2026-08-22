{ pkgs, ... }:
{
  # Local LLM engine. Vulkan backend instead of ROCm: on RDNA 3.5 (gfx1151,
  # Radeon 890M) RADV is more stable and usually faster, and it needs no
  # HSA_OVERRIDE_GFX_VERSION workaround. hardware.graphics already ships
  # Mesa + vulkan-loader from gaming.nix, so nothing else is needed.
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    host = "127.0.0.1";
    port = 11434;
    # Uncomment to pre-download models during the rebuild instead of `ollama pull`.
    # loadModels = [ "qwen3.6:35b-a3b" ];
  };

  # Let the iGPU address enough unified memory for 30B+ models with a wide
  # context window. Without this a 30B model at 16k context hits the default
  # UMA ceiling and fails to load. gttsize is in MB (40 GB), ttm.pages_limit
  # in 4K pages (56 GB).
  boot.kernelParams = [
    "amdgpu.gttsize=40960"
    "ttm.pages_limit=14680064"
  ];

  # The nixpkgs module leaves Restart unset, so a crashed daemon stays down
  # until the next boot.
  systemd.services.ollama.serviceConfig.Restart = "on-failure";
}
