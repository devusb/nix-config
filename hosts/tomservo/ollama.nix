{ ... }: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    listenAddress = "0.0.0.0";
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };

  virtualisation.oci-containers.containers.open-webui = {
    image = "ghcr.io/open-webui/open-webui:main";
    volumes = [
      "open-webui:/app/backend/data"
    ];
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
    ];
    ports = [
      "127.0.0.1:3000:8080"
    ];
    environment = {
      ENABLE_SIGNUP = "False";
    };
  };

}
