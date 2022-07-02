{ pkgs, ... }: {
  programs.micro = {
    enable = true;
    settings = {
      softwrap = true;
    };
  };

  xdg.configFile = {
    "micro/syntax/terraform.yaml".source =
      pkgs.fetchFromGitHub
        {
          owner = "devusb";
          repo = "micro-terraform-syntax";
          rev = "master";
          sha256 = "sha256-2R6Lo4ZvglNMzfkjDYqt19Az2oBSsth6WhHZtiVylx4=";
        } + "/terraform.micro";
    "micro/plug/editorconfig".source =
      pkgs.fetchFromGitHub
        {
          owner = "10sr";
          repo = "editorconfig-micro";
          rev = "v1.0.0";
          sha256 = "sha256-ZNq2QH4TnmJkkV6aSoNNGUAB/M7wJuTNVU1539mLAOk=";
        };
  };


}
