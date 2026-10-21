{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = [ pkgs.unstable.grok-build ];

  home.file.".grok/config.toml".source = tomlFormat.generate "grok-config.toml" {
    models = {
      default = "grok-4.7";
      default_reasoning_effort = "medium";
    };

    ui = {
      theme = "terminal";
      # Auto-review: routine tool calls pass a safety check; the rest still prompt
      permission_mode = "auto";
    };

    features = {
      # Still rolling out; otherwise ui.theme = "terminal" falls back to the default
      terminal_theme = true;
      telemetry = "off";
      feedback = false;
      feedback_trace_card = false;
      campaigns = false;
      title_refresh = false;
      turn_summary = false;
      session_recap = false;
    };

    telemetry = {
      trace_upload = false;
      otel_enabled = false;
    };

    cli = {
      auto_update = false;
      show_tips = false;
    };

    memory.enabled = false;
    relay.enabled = false;

    # 0 disables cleanup rather than keeping nothing
    storage.cleanup_ttl_days = 1;
  };

  home.sessionVariables = {
    GROK_TELEMETRY_ENABLED = "0";
    GROK_TELEMETRY_TRACE_UPLOAD = "0";
    GROK_TELEMETRY_MIXPANEL_ENABLED = "0";
    GROK_DISABLE_AUTOUPDATER = "1";
    GROK_FEEDBACK_ENABLED = "0";
    GROK_CAMPAIGNS = "0";
  };
}
