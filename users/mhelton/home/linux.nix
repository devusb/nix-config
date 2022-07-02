{ pkgs, ... }: {
  imports = [
    "${fetchTarball { url="https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256="0a62zj4vlcxjmn7a30gkpq3zbfys3k1d62d9nn2mi42yyv2hcrm1";}}/modules/vscode-server/home.nix"
  ];
  home.packages = with pkgs; [
    dig
  ];

  services.vscode-server.enable = true;

  home.sessionVariables = {
    DOTFILES = "/dotfiles/";
  };
}
