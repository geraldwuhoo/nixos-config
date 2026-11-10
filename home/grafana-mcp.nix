{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets.grafana-mcp-token = { };

  programs.mcp = {
    enable = true;
    servers.grafana = {
      command = lib.getExe pkgs.unstable.mcp-grafana;
      args = [ "--disable-write" ];
      env = {
        GRAFANA_URL = "https://grafana.wuhoo.xyz";
        GRAFANA_SERVICE_ACCOUNT_TOKEN_FILE = config.sops.secrets.grafana-mcp-token.path;
      };
    };
  };

  programs.claude-code.enableMcpIntegration = true;
}
