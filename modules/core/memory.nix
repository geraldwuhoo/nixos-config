{ ... }:
{
  # Swap on a ZFS zvol can deadlock under memory pressure
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  boot.kernel.sysctl = {
    # Swapping to zram is cheaper than evicting file-backed pages
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;

    # Reboot on real lockups so systemd-pstore keeps the log
    "kernel.softlockup_panic" = 1;
    "kernel.hardlockup_panic" = 1;
    "kernel.panic" = 10;
  };

  systemd.oomd = {
    enableRootSlice = true;
    enableUserSlices = true;
  };
  # The enable* options only kill on pressure; also kill once zram is 90% full
  systemd.slices."-".sliceConfig.ManagedOOMSwap = "kill";

  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  nix.daemonCPUSchedPolicy = "batch";
  nix.daemonIOSchedClass = "idle";

  # Throttle then oomd-kill builds instead of thrashing the whole system
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "10G";
    MemoryMax = "12G";
    ManagedOOMMemoryPressure = "kill";
  };
}
