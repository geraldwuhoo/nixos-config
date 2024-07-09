{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    nvidia.enable = lib.mkEnableOption "enables nvidia";
  };

  config = lib.mkIf config.nvidia.enable {
    # Hardware acceleration
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    services.xserver.videoDrivers = [ "nvidia" ];

    # NVIDIA settings
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    boot.kernelModules = [ "nvidia_uvm" ];

    environment.systemPackages = with pkgs; [
      gwe
      nvtopPackages.nvidia
    ];
  };
}
