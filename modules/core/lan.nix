{ lib, ... }:
{
  options = {
    lanInterface = lib.mkOption {
      type = lib.types.str;
      description = "Interface LAN-only services are reachable on";
    };
  };
}
