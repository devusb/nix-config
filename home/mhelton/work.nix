{ config, pkgs, ... }:
with pkgs;
let
  python-packages =
    pp: with pp; [
      pyyaml
      boto3
      timedb
    ];
  python-with-packages = python3.withPackages python-packages;

  yamlFormat = formats.yaml { };
in
{
  programs.git = {
    userName = "Morgan Helton";
    userEmail = "morgan@imubit.com";
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    extraConfig.gpg.format = "ssh";
  };

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.admin.imubit.in";
    GL_HOST = "https://imugit.imubit.com";
  };

  programs.zsh = {
    shellAliases = {
      vssh = "${pkgs.vault}/bin/vault ssh -mode=ca -role=infra-admin -private-key-path=~/.ssh/id_ed25519 -public-key-path=~/.ssh/id_ed25519.pub";
    };
    initExtra = pkgs.lib.mkAfter (import ./extra/journalcreds.nix { inherit pkgs; });
  };

  home.packages = with pkgs; [
    python-with-packages
    mpack
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    (ansible.override { windowsSupport = true; })
    postgresql
    pgcli
    dive
    crane
    helm2_15_1
    helm2_13_1
    helm2_16_2
    helm2_17_0
    aws-sso-cli
    pgdiff
    kubectl
    kubectx
    k9s
    kubernetes-helm
    glab
    kubectl-cnpg
    kubent
    kubectl-gadget
    kubie
    pg_activity
    diffr
    vkv
    presenterm
    presenterm-export
    jira-cli-go
    clickhouse
    gitlab-ci-local
  ];

  programs.keychain.keys = [ "id_ed25519" ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        user = "morgan";
      };
    };
  };

  programs.starship.settings = {
    kubernetes.disabled = false;
    aws.disabled = false;
  };

  home.file.".kube/kubie.yaml" = {
    source = yamlFormat.generate "kubie-config" {
      prompt.disable = true;
    };
  };

  programs.nixvim = {
    plugins.codeium-nvim = {
      enable = true;
      settings = {
        virtual_text = {
          enabled = true;
        };
      };
    };
    plugins.cmp.settings.sources = [
      { name = "codeium"; }
    ];
  };

}
