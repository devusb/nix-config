{ pkgs, ...}: {
  imports = [
    "${fetchTarball { url="https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256="1cszfjwshj6imkwip270ln4l1j328aw2zh9vm26wv3asnqlhdrak";}}/modules/vscode-server/home.nix"
  ]; 
  home.packages = with pkgs; [ 
    ansible
    dig
    yq
  ];

  services.vscode-server.enable = true;
}