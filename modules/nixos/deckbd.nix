{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.boot.initrd.deckbd;
in
{
  options = {
    boot.initrd.deckbd = {
      enable = mkEnableOption (mdDoc "deckbd to use Steam Deck controller for LUKS passphrase");
      package = mkPackageOption pkgs "deckbd" { };
    };
  };

  config = mkIf cfg.enable (
    {
      boot.initrd.kernelModules = [ "uinput" "evdev" "hid_steam" ];
      boot.initrd.preLVMCommands =
        let
          deckbd = "${pkgs.deckbd}/bin/deckbd";
        in
        ''
          try=10
          while true;do
            ${deckbd} query && break
            if test $try -le 0;then break; fi
            sleep 1
            echo "Waiting for controller to appear, $try retry remains..."
            try=$((try - 1))
          done
          echo "Initialise deckbd";
          ${deckbd} &
          DECKBD_PID=$!
        '';
      boot.initrd.postMountCommands = ''
        kill $DECKBD_PID
      '';
    }
  );
}
