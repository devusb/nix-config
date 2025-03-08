{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };

  environment.systemPackages = with pkgs; [
    (python3.withPackages (py: [
      py.llm
      py.llm-ollama
    ]))
  ];
}
