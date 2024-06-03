{ lib, config, ... }:
{
  options = {
    oci.enable = lib.mkEnableOption "enables OCI containers";
  };

  config = lib.mkIf config.oci.enable {
    # OCI stuff
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
    };

    hardware.nvidia-container-toolkit.enable = config.nvidia.enable;
  };
}
