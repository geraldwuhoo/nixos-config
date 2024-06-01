{ ... }:
{
  accounts.email.accounts.mailbox = {
    address = "gerald@geraldwu.com";
    aliases = [
      "gw@geraldwu.com"
      "c068fcb4@mailbox.org"
    ];
    realName = "Gerald Wu";
    primary = true;
    userName = "c068fcb4@mailbox.org";
    gpg = {
      key = "67AA1C627866DE561EA47CFCC6F5F00A84E41D11";
      signByDefault = false;
    };
    imap = {
      host = "imap.mailbox.org";
      port = 993;
      tls = {
        enable = true;
      };
    };
    smtp = {
      host = "smtp.mailbox.org";
      port = 465;
      tls = {
        enable = true;
      };
    };
    thunderbird = {
      enable = true;
      profiles = [ "jerry" ];
    };
  };
}
