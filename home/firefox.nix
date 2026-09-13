{ lib, config, inputs, ... }:
{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.firefox.enable {
    # Would inject font prefs into user.js
    stylix.targets.firefox.enable = false;

    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      profiles = {
        default = {
          path = "xb6yebs4.default";
          preConfig = builtins.readFile "${inputs.arkenfox}/user.js";
          settings = {
            # New tab
            "browser.startup.page" = 1; # 0102
            "browser.startup.homepage" = "about:newtab"; # 0103

            # Handled by MAC and TC
            "privacy.clearOnShutdown.cookies" = false; # 2803
            "privacy.clearOnShutdown.offlineApps" = false; # 2803
            "privacy.clearOnShutdown.sessions" = false; # 2803
            "privacy.clearOnShutdown.siteSettings" = false; # 2803
            "privacy.clearOnShutdown_v2.siteSettings" = false; # 2803
            "privacy.clearOnShutdown_v2.cookiesAndStorage" = false; # 2803
            "privacy.clearSiteData.cookiesAndStorage" = false; # 2820

            # Disable letterboxing
            "privacy.resistFingerprinting.letterboxing" = false; # 4504

            # Allow searching from urlbar
            "keyword.enabled" = true; # 0801

            # Allow cookies and site data to persist
            "network.cookie.lifetimePolicy" = 0;

            # Allow WebAssembly
            "javascript.options.wasm" = true; # 5506

            # Move cache to memory
            "browser.cache.disk.enable" = false;
            "browser.cache.memory.enable" = true;

            # Enable Kyber PQ
            "security.tls.enable_kyber" = true;

            # Use self-hosted syncserver
            "identity.sync.tokenserver.uri" = "https://firefoxsync.wuhoo.xyz/token/1.0/sync/1.5";

            # Enable service workers
            "dom.serviceWorkers.enabled" = true;
          };
        };
      };
    };
  };
}
