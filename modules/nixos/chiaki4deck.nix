{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.chiaki4deck;
in

{
  options = {
    programs.chiaki4deck = {
      enable = mkEnableOption (mdDoc "PlayStation Remote Play for Steam Deck");
      package = mkPackageOption pkgs "chiaki4deck" { };
      consoleAddress = mkOption {
        type = types.str;
        description = lib.mdDoc "IP Address of PlayStation";
      };
      consoleType = mkOption {
        type = types.number;
        default = 5;
        description = lib.mdDoc "Type of PlayStation";
      };
      displayMode = mkOption {
        type = types.str;
        default = "fullscreen";
        description = lib.mdDoc "Display mode";
      };
      registrationKeyPath = mkOption {
        type = types.path;
        description = lib.mdDoc "Path to file containing PlayStation Remote Play registration key";
      };
      consoleNickname = mkOption {
        type = types.str;
        description = lib.mdDoc "Nickname of PlayStation to use for launcher as configured in Chiaki UI";
      };
      waitTimeout = mkOption {
        type = types.number;
        default = 35;
        description = lib.mdDoc "Amount of time to wait for PlayStation to wake up";
      };
    };
  };

  config = mkIf cfg.enable (
    let
      consoleType = builtins.toString cfg.consoleType;
      waitTimeout = builtins.toString cfg.waitTimeout;
      launcher = pkgs.writeShellScriptBin "Chiaki-launcher.sh" ''
        connect_error_loc()
        {
            echo "Error: Couldn't connect to your PlayStation console from your local address!" >&2
            echo "Error: Please check that your Steam Deck and PlayStation are on the same network" >&2
            echo "Error: ...and that you have the right PlayStation IP address or hostname!" >&2
            exit 1
        }

        wakeup_error()
        {
            echo "Error: Couldn't wake up PlayStation console from sleep!" >&2
            echo "Error: Please make sure you are using a PlayStation ${consoleType}." >&2
            echo "Error: If not, change the wakeup call to use the number of your PlayStation console" >&2
            exit 2
        }

        timeout_error()
        {
            echo "Error: PlayStation console didn't become ready in ${waitTimeout} seconds!" >&2
            echo "Error: Please change ${waitTimeout} to a higher number in your script if this persists." >&2
            exit 1
        }
        SECONDS=0
        # Wait for console to be in sleep/rest mode or on (otherwise console isn't available)
        ps_status="$(${cfg.package}/bin/chiaki discover -h ${cfg.consoleAddress} 2>/dev/null)"
        while ! echo "$ps_status" | grep -q 'ready\|standby'
        do
            if [ $SECONDS -gt ${waitTimeout} ]
            then
              connect_error_loc
            fi
            sleep 1
            ps_status="$(${cfg.package}/bin/chiaki discover -h ${cfg.consoleAddress} 2>/dev/null)"
        done

        # Wake up console from sleep/rest mode if not already awake
        if ! echo "$ps_status" | grep -q ready
        then
            ${cfg.package}/bin/chiaki wakeup -${consoleType} -h ${cfg.consoleAddress} -r $(cat ${cfg.registrationKeyPath}) 2>/dev/null
        fi

        # Wait for PlayStation to report ready status, exit script on error if it never happens.
        while ! echo "$ps_status" | grep -q ready
        do
            if [ $SECONDS -gt ${waitTimeout} ]
            then
                if echo "$ps_status" | grep -q standby
                then
                    wakeup_error
                else
                    timeout_error
                fi
            fi
            sleep 1
            ps_status="$(${cfg.package}/bin/chiaki discover -h ${cfg.consoleAddress} 2>/dev/null)"
        done

        # Begin playing PlayStation remote play via Chiaki on your Steam Deck :)
        ${cfg.package}/bin/chiaki --${cfg.displayMode} stream $(printf %q "${cfg.consoleNickname}") ${cfg.consoleAddress}
      '';
      desktopItem = pkgs.makeDesktopItem {
        name = "chiaki4deck-launcher";
        desktopName = "chiaki4deck Launcher";
        comment = "Auto-launch chiaki4deck connection to PlayStation";
        icon = "chiaki";
        exec = "Chiaki-launcher.sh";
        categories = [ "Game" ];
      };
    in
    {
      environment.systemPackages = [ cfg.package launcher desktopItem ];
    }
  );
}
