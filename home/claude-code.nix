{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;

    settings = {
      model = "opus";
      effortLevel = "medium";
      theme = "dark-ansi";

      env = {
        # Umbrella: telemetry, error reports, /feedback, updates, release notes, feature flags
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        DISABLE_TELEMETRY = "1";
        DO_NOT_TRACK = "1";
        DISABLE_ERROR_REPORTING = "1";
        DISABLE_GROWTHBOOK = "1";
        DISABLE_FEEDBACK_COMMAND = "1";
        CLAUDE_CODE_SEND_FEEDBACK = "0";
        CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
        DISABLE_AUTOUPDATER = "1";
        CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL = "1";
        # Client version and prompt fingerprint in the system prompt
        CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
        # No transcripts or prompt history on disk; breaks --resume and up-arrow history
        CLAUDE_CODE_SKIP_PROMPT_HISTORY = "1";
        # Also skips the model request that names each session
        CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1";
      };

      feedbackSurveyRate = 0;
      feedbackDrafts = "off";
      # Otherwise every WebFetch hostname is sent to api.anthropic.com first
      skipWebFetchPreflight = true;
      attribution.sessionUrl = false;
      # Minimum allowed; purges existing transcripts older than a day
      cleanupPeriodDays = 1;
      syncClaudeAiSkills = false;
      syncClaudeAiPlugins = false;
      enableArtifact = false;
      disableRemoteControl = true;
    };
  };
}
