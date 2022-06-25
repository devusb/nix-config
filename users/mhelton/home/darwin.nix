{ pkgs, config, system, ...}: {
  xdg.configFile."iterm2/com.googlecode.iterm2.plist".source = ./extra/iterm2.conf;
  home.packages = with pkgs; [ 
    
  ];
}