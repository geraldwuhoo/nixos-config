{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.key = "gerald@geraldwu.com";
    settings = {
      user = {
        name = "geraldwuhoo";
        email = "gerald@geraldwu.com";
      };
      # signing.signByDefault would also force tag.gpgSign on lightweight tags
      commit.gpgSign = true;
      tag.forceSignAnnotated = true;
      format.signoff = true;
      pull.rebase = false;
      url."git@github.com:".insteadOf = "https://github.com/";
      # gitFull is cached; git with withLibsecret is not
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
  };
}
