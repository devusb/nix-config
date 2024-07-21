{ ... }: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
  virtualisation.containers.containersConf.settings = {
    containers.pids_limit = 0;
  };
  virtualisation.oci-containers.backend = "podman";
}
