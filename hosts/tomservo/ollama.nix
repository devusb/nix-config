{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
    package = pkgs.ollama-rocm.overrideAttrs (old: rec {
      version = "0.11.2";
      src = old.src.override {
        tag = "v${version}";
        hash = "sha256-NZaaCR6nD6YypelnlocPn/43tpUz0FMziAlPvsdCb44=";
      };
    });
    host = "0.0.0.0";
  };

  environment.systemPackages = with pkgs; [
    (python3.withPackages (py: [
      py.llm
      py.llm-ollama
    ]))
  ];

  services.open-webui = {
    enable = false;
    host = "0.0.0.0";
  };
}
