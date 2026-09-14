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
  };
}
