{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  # Edit and Write are separate tool names. ** crosses directories, and a
  # leading ** matches both /home/jerry/... and a literal ~/.
  # An Edit deny also rejects shell commands that touch the path.
  fileDeny =
    builtins.concatMap
      (p: [
        "Edit(${p})"
        "Write(${p})"
      ])
      [
        "/mnt/cephfs/**"
        "**/zroot.jwe"
        "**/sops/**"
        "**/.ssh/**"
        "**/Nextcloud/**"
        "**/Documents/**"
        "**/Downloads/**"
        "**/Pictures/**"
        "**/Videos/**"
        "**/Camera/**"
        "**/Anime/**"
        "**/.gnupg/**"
        "**/.thunderbird/**"
        "**/.mozilla/firefox/**"
        "**/joplin-desktop/**"
        "**/Joplin/**"
        "**/kopia/**"
        "**/rbw/**"
        "**/calendars/**"
        "**/contacts/**"
        "**/.config/Signal/**"
        "**/.config/Element/**"
        "**/.config/Bitwarden/**"
        "**/kwalletd/**"
        "**/.config/syncthing/**"
        "**/libvirt/**"
      ];

  blockDevDeny =
    builtins.concatMap
      (dev: [
        "Bash(*cp */dev/${dev}*)"
        "Bash(*tee */dev/${dev}*)"
      ])
      [
        "sd"
        "nvme"
        "vd"
        "mapper"
        "disk"
        "zvol"
      ];

  # One pattern covers the bare command, sudo, doas, and a full path.
  # A command that contains the phrase matches, including a search for it.
  phrase = builtins.map (body: "Bash(*${body})");
in
{
  sops.secrets.grafana-mcp-token = { };

  home.packages = [
    pkgs.unstable.grok-build
    pkgs.unstable.mcp-grafana
  ];

  home.file.".grok/config.toml".source = tomlFormat.generate "grok-config.toml" {
    models = {
      default = "grok-4.7";
      default_reasoning_effort = "high";
    };

    ui = {
      theme = "terminal";
      compact_mode = true;
      # Ordinary tool calls run. Shell ask rules still prompt; deny rejects outright.
      permission_mode = "always-approve";
      # Ghost text is another model call with the prompt
      prompt_suggestions = false;
    };

    # Bash globs: * crosses spaces and slashes. Deny wins over ask.
    # One deny pattern covers sudo, doas, and a full path. Rules load at session start.
    # Absolute recursive rm is denied. `rm ./build` still only asks.
    # Personal files are Edit/Write denies. Those also block shell commands
    # that touch the path, so each folder is not repeated as a shell rule.
    permission = {
      ask = [
        # Removals. /bin/rm is the slash form. command/busybox/xargs do not start with rm.
        "Bash(rm *)"
        "Bash(*/rm *)"
        "Bash(command rm *)"
        "Bash(busybox rm *)"
        "Bash(toybox rm *)"
        "Bash(xargs *rm *)"
        "Bash(rmdir *)"
        "Bash(rmmod *)"
        "Bash(unlink *)"
        "Bash(shred *)"
        "Bash(truncate *)"
        "Bash(wipe *)"
        "Bash(srm *)"
        "Bash(git clean *)"
        "Bash(git rm *)"
        "Bash(git reset *--hard*)"
        "Bash(find *-delete*)"
        "Bash(find *-exec*rm*)"
        "Bash(rsync *--delete*)"
        "Bash(rsync *--remove-source-files*)"
        "Bash(tar *--remove-files*)"
        "Bash(mogrify *)"
        "Bash(exiftool *)"

        # `su *` does not match sudo. `kill*` also matches killall.
        "Bash(chmod *)"
        "Bash(chown *)"
        "Bash(chgrp *)"
        "Bash(chattr *)"
        "Bash(kill*)"
        "Bash(pkill *)"
        "Bash(git push)"
        "Bash(sudo *)"
        "Bash(doas *)"
        "Bash(pkexec *)"
        "Bash(su *)"
        "Bash(nsenter *)"
        "Bash(chroot *)"
        "Bash(unshare *)"
        "Bash(user[adm]*)"
        "Bash(group[adm]*)"
        "Bash(passwd*)"
        "Bash(chpasswd)"

        # ssh* is ssh, ssh-keygen, ssh-add, ssh-copy-id, and sshpass.
        "Bash(ssh*)"
        "Bash(scp *)"
        "Bash(sftp *)"

        # kubectl get, describe, and logs stay approved. Mutations prompt.
        # A leading * also matches `k3s kubectl`.
        "Bash(*kubectl *delete *)"
        "Bash(*kubectl *exec *)"
        "Bash(*kubectl *debug *)"
        "Bash(*kubectl *attach *)"
        "Bash(*kubectl *port-forward *)"
        "Bash(*kubectl *proxy *)"
        "Bash(*kubectl *cp *)"
        "Bash(*kubectl *drain *)"
        "Bash(*kubectl *cordon *)"
        "Bash(*kubectl *taint *)"
        "Bash(*kubectl *scale *)"
        "Bash(*kubectl *rollout *)"
        "Bash(*kubectl *apply *)"
        "Bash(*kubectl *patch *)"
        "Bash(*kubectl *replace *)"
        "Bash(*kubectl *create *)"
        "Bash(*kubectl *edit *)"
        "Bash(*kubectl *label *)"
        "Bash(*kubectl *annotate *)"
        "Bash(*kubectl *expose *)"
        "Bash(*kubectl *run *)"
        "Bash(*kubectl *auth *)"
        "Bash(*kubectl *certificate *)"
        "Bash(*kubectl *config *)"
        "Bash(*kubectl *get *secret*)"

        "Bash(helm *)"
        "Bash(flux *)"
        "Bash(cilium *)"
        "Bash(linkerd *)"
        "Bash(velero *)"
        "Bash(k3d *delete*)"
        "Bash(kind delete *)"
        "Bash(kubectx *)"
        "Bash(kubie ctx *)"
        "Bash(crictl *rm*)"

        # build and dry-build stay approved.
        "Bash(nixos-rebuild switch)"
        "Bash(nixos-rebuild boot)"
        "Bash(nixos-rebuild test)"
        "Bash(home-manager switch)"
        "Bash(nix-collect-garbage)"
        "Bash(nix store *)"
        "Bash(nix-store --*)"
        "Bash(nix profile *)"
        "Bash(nix-env -e)"
        "Bash(nix-env *--delete-generations*)"
        "Bash(home-manager expire-generations)"

        "Bash(git restore *)"
        "Bash(git checkout -- *)"
        "Bash(git checkout -f*)"
        "Bash(git checkout *--force*)"
        "Bash(git branch *-[Dd]*)"
        "Bash(git filter-*)"
        "Bash(git config *)"
        "Bash(git stash [dc]*)"
        "Bash(git update-ref *)"
        "Bash(git prune*)"
        "Bash(git gc *--prune*)"
        "Bash(git reflog [ed]*)"

        "Bash(sops *)"
        "Bash(age *)"
        "Bash(gpg *--export-secret*)"
        "Bash(secret-tool [cs]*)"
        "Bash(rbw [rpe]*)"
        "Bash(bleachbit)"
        "Bash(gio trash *)"
        "Bash(trash*)"
        "Bash(syncthing cli)"
        "Bash(nextcloudcmd)"

        # copy stays approved. plan and validate stay approved.
        "Bash(rclone [smdp]*)"
        "Bash(rclone *--delete*)"
        "Bash(aws *)"
        "Bash(s3cmd *)"
        "Bash(hcloud *)"
        "Bash(tofu [ad]*)"
        "Bash(terraform [ad]*)"
        "Bash(ansible*)"

        "Bash(kopia *)"
        "Bash(restic [fp]*)"
        "Bash(borg [dp]*)"
        "Bash(virsh *)"
        "Bash(qemu-img *)"
        "Bash(virt-sysprep *)"
        "Bash(rbd *)"
        "Bash(rados *)"
        "Bash(docker *)"
        "Bash(podman *)"
        "Bash(*compose down*)"
        "Bash(adb [spu]*)"

        # list and get stay approved. snapshot, send, and share prompt.
        "Bash(zfs [rusmci]*)"
        "Bash(zpool [doriec]*)"
        "Bash(psql *)"
        "Bash(mysql *)"
        "Bash(mariadb *)"
        "Bash(sqlite3 *)"

        # *fdisk* is fdisk, sfdisk, and cfdisk. *gdisk* is gdisk and sgdisk.
        # *mount* is mount and umount.
        "Bash(*fdisk *)"
        "Bash(*gdisk *)"
        "Bash(parted *)"
        "Bash(efibootmgr *)"
        "Bash(*mount *)"
        "Bash(dd *)"
        "Bash(sysctl -*)"
        "Bash(modprobe *)"
        "Bash(insmod *)"
        "Bash(qmk flash*)"
        "Bash(fastboot *)"
        "Bash(*fsck *)"
        "Bash(xfs_repair *)"
        "Bash(lvr*)"
        "Bash(debugfs *)"
        "Bash(cryptsetup *)"
        "Bash(grub-install)"

        # status and start stay approved. stop and start share their first letters.
        "Bash(systemctl stop)"
        "Bash(systemctl disable)"
        "Bash(systemctl mask)"
        "Bash(systemctl restart)"
        "Bash(systemctl isolate)"
        "Bash(systemctl emergency)"
        "Bash(systemctl rescue)"
        "Bash(systemctl kexec)"
        "Bash(nft *)"
        "Bash(iptables *)"
        "Bash(ip6tables *)"
        "Bash(crontab *)"
        "Bash(systemd-run *)"
        "Bash(journalctl *--vacuum*)"
        "Bash(*etcd-snapshot delete*)"

        # `| sh*` would also match sha256sum.
        "Bash(*| sh)"
        "Bash(*| sh *)"
        "Bash(*| bash)"
        "Bash(*| bash *)"
        "Bash(*| zsh)"
        "Bash(*| zsh *)"
        "Bash(*<(curl*)"
        "Bash(*<(wget*)"
        "Bash(*rmtree*)"
        "Bash(*os.remove*)"
        "Bash(*os.rmdir*)"
        "Bash(*os.unlink*)"
        "Bash(*fs.rm*)"
        "Bash(*fs.unlink*)"
        "Bash(*rimraf*)"
        "Bash(*rm_rf*)"

        "Bash(*reboot*)"
        "Bash(*poweroff*)"
        "Bash(*[Ss]hutdown*)"
        "Bash(*halt*)"
      ];

      deny =
        phrase [
          # -r/-R/-f in either order, of /... or ~ or $HOME. Not ./relative.
          "rm *-[rRf]* [/~$]*"
          "rm *--recursive* [/~$]*"
          "rm *--no-preserve-root*"
          "chmod *-[Rr]* [/~$]*"
          "chmod *--recursive* [/~$]*"
          "chown *-[Rr]* [/~$]*"
          "chown *--recursive* [/~$]*"
          "rm */nix/store*"
          "rm */boot*"
          "shred */boot*"
          "truncate */boot*"
          "dd *of=/boot*"
          "dd *of=/nix*"
          "dd *of=/dev/*"
          "dd *of=/mnt/cephfs*"
          "shred */dev/*"
          "mkfs*"
          "mkswap *"
          "wipefs *"
          "blkdiscard *"
          "badblocks *-w *"
          "nvme *format*"
          "nvme *sanitize*"
          "nvme *delete-ns*"
          "hdparm *--security-erase*"
          "cryptsetup *luksFormat*"
          "cryptsetup *luksErase*"
          "cryptsetup *erase*"
          "zfs destroy*"
          "zpool destroy*"
          "zpool labelclear*"
          "zpool create*"
          "zfs program*"
          "zfs rollback*zroot*"
          "zfs rollback -[rR]*"
          "zfs receive*-F*"
          "zfs receive*--force*"
          "[lvp][vg]remove*"
          "k3s-uninstall*"
          "k3s-killall*"
          "nft *flush ruleset*"
          "ip*tables *-F*"
          "ip*tables *--flush*"
          "find /*-delete*"
          "find ~*-delete*"
          "find /*-exec*rm*"
          "find ~*-exec*rm*"
          "rsync *--delete* [/~]*"
          "rsync * [/~]*--delete*"
          "rclone [smdp]* */mnt/cephfs*"
          "rclone [smdp]* */Nextcloud*"
          "rclone [smdp]* */Documents*"
          "rmtree([/~]*"
          "rm_rf([/~]*"
          "fs.rmSync([/~]*"
          "fs.rm([/~]*"
          "os.remove([/~]*"
          "os.unlink([/~]*"
          "parted *mklabel*"
          "parted *rm *"
          "sgdisk *-[zZo]*"
          "sgdisk *--clear*"
          "sfdisk *--delete*"
          "flashrom *-[we]*"
          "system reset*"
          "efibootmgr *-B*"
          "efibootmgr *--delete-bootnum*"
          "userdel *-r*"
          "deluser *--remove-home*"
          "destroy*-auto-approve*"
          "-auto-approve*destroy*"
          "crictl *--all*"
          "age-keygen*keys.txt*"
          "dropdb*"
          "mysqladmin *drop*"
          "[Dd][Rr][Oo][Pp] [Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee]*"
          "-cli *[Ff][Ll][Uu][Ss][Hh]*"
          "gpg *--delete-secret*"
          "clevis *unbind*"
          "mdadm *--zero-superblock*"
          "mdadm *--create*"
          "dmsetup *wipe_table*"
          "dmsetup *remove_all*"
          "btrfs *delete*"
          "btrfs *remove*"
          "btrfs *--repair*"
          "rados *rmpool*"
          "rados *purge*"
          "ceph *fs *rm*"
          "ceph *osd *purge*"
          "ceph *osd *destroy*"
          # LocalCommand also matches PermitLocalCommand.
          "ProxyCommand*"
          "LocalCommand*"
          "RemoteCommand*"
        ]
        ++ [
          # --all must stay its own flag. *--all* also matches --allow-missing.
          "Bash(*kubectl *delete *namespace*)"
          "Bash(*kubectl *delete ns*)"
          "Bash(*kubectl *delete *--all)"
          "Bash(*kubectl *delete *--all *)"
          "Bash(*kubectl *delete *--all=*)"
          "Bash(*kubectl *delete *--all-*)"
          "Bash(*kubectl *delete * -A*)"
          "Bash(*kubectl *delete node*)"
          "Bash(*kubectl *delete pv)"
          "Bash(*kubectl *delete pv *)"
          "Bash(*kubectl *delete persistentvolume)"
          "Bash(*kubectl *delete persistentvolume *)"
          "Bash(*kubectl *delete persistentvolumes*)"
          "Bash(*kubectl *delete crd*)"
          "Bash(*kubectl *delete customresourcedefinition*)"
          "Bash(*kubectl *delete clusterrole*)"
          "Bash(*kubectl *delete *webhookconfiguration*)"
          "Bash(*kubectl *apply *--prune*)"
          "Bash(*kubectl *drain *--delete-*)"
        ]
        ++ fileDeny
        ++ blockDevDeny;
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

    mcp_servers.grafana = {
      command = lib.getExe pkgs.unstable.mcp-grafana;
      args = [ "--disable-write" ];
      env = {
        GRAFANA_URL = "https://grafana.wuhoo.xyz";
        GRAFANA_SERVICE_ACCOUNT_TOKEN_FILE = config.sops.secrets.grafana-mcp-token.path;
      };
    };
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
