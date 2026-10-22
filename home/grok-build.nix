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
      # Ghost text is another model call with the prompt
      prompt_suggestions = false;
    };

    features = {
      # Still rolling out; otherwise ui.theme = "terminal" falls back to the default
      terminal_theme = true;
      telemetry = "off";
      feedback = false;
      feedback_trace_card = false;
      campaigns = false;
      # A fetched requirements pin would outrank the telemetry settings below
      managed_config = false;
      title_refresh = false;
      turn_summary = false;
      session_recap = false;
    };

    telemetry = {
      trace_upload = false;
      mixpanel_enabled = false;
      otel_enabled = false;
      otel_metrics_exporter = "none";
      otel_logs_exporter = "none";
      otel_log_user_prompts = false;
      otel_log_assistant_responses = false;
      otel_log_tool_details = false;
      otel_log_tool_content = false;
      otel_metrics_include_session_id = false;
    };

    cli = {
      auto_update = false;
      show_tips = false;
      session_registry = false;
    };

    harness = {
      disable_codebase_upload = true;
      disable_workspace_teleport = true;
    };

    diagnostics.crash_handler = false;

    # Login env can carry secrets into bash tool calls
    toolset.bash.login_shell_capture = false;

    memory.enabled = false;
    memory_v2 = {
      enabled = false;
      rollout = "off";
      batch_dream_enabled = false;
      file_writes_enabled = false;
      compact_index_enabled = false;
    };
    relay.enabled = false;

    # Store symlink, so the in-app buttons cannot persist this dismissal
    privacy.privacy_banner_acked = "2026-10-21T00:00:00Z";

    # 0 disables cleanup rather than keeping nothing
    storage.cleanup_ttl_days = 1;
  };

  home.sessionVariables = {
    DISABLE_TELEMETRY = "1";
    GROK_TELEMETRY_ENABLED = "0";
    GROK_TELEMETRY_TRACE_UPLOAD = "0";
    GROK_TELEMETRY_MIXPANEL_ENABLED = "0";
    GROK_EXTERNAL_OTEL = "0";
    GROK_DISABLE_AUTOUPDATER = "1";
    GROK_FEEDBACK_ENABLED = "0";
    GROK_FEEDBACK_TRACE_CARD = "0";
    GROK_CAMPAIGNS = "0";
    GROK_MEMORY = "0";
    GROK_SESSION_REGISTRY = "0";
    GROK_RELAY_SYNC_ENABLED = "0";
    GROK_CRASH_HANDLER = "0";
    GROK_PROMPT_SUGGESTIONS = "0";
    GROK_OFFICIAL_MARKETPLACE_AUTO_REGISTER = "0";
    GROK_NON_GIT_WORKSPACE_CAPTURE = "0";
    GROK_WORKSPACE_DATA_COLLECTION_DISABLED = "1";
    GROK_WORKSPACE_UPLOAD_QUEUE_ENABLED = "0";
    GROK_LOGIN_ENV = "0";
  };
}
