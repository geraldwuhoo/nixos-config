{ pkgs, ... }:
let
  # home/files/ctpv-place.sh fits the image, then writes one icat sequence.
  ctpvPlace = pkgs.writeShellScriptBin "ctpv-place" ''
    export PATH="${
      pkgs.lib.makeBinPath [
        pkgs.imagemagick
        pkgs.coreutils
        pkgs.findutils
        pkgs.python3Minimal
        pkgs.kitty
      ]
    }:$PATH"
    ${builtins.readFile ./files/ctpv-place.sh}
  '';

  # ctpv records $! in the kitty branch and waits, so the patch backgrounds
  # the placer. Python ueberzug crashes; ueberzugpp ships the same command.
  ctpv = (pkgs.ctpv.override { ueberzug = pkgs.ueberzugpp; }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./files/ctpv-ghostty.patch ];
    postPatch = (old.postPatch or "") + ''
      substituteInPlace sh/helpers.sh \
        --replace-fail '@ctpvPlace@' '${ctpvPlace}/bin/ctpv-place'
    '';
  });

  # Ghostty's TERM is xterm-ghostty. KITTY_PID only has to be non-empty.
  ctpvEnv = ''
    export KITTY_PID="''${KITTY_PID:-$PPID}"
    export PATH="${pkgs.kitty}/bin:$PATH"
  '';

  # lf r41 passes the preview mode as a 6th argument. ctpv reads it as the server id.
  ctpvPreviewer = pkgs.writeShellScript "ctpv-previewer" ''
    ${ctpvEnv}
    [ "$#" -gt 5 ] && set -- "$1" "$2" "$3" "$4" "$5"
    exec ${ctpv}/bin/ctpv "$@"
  '';

  ctpvClear = pkgs.writeShellScript "ctpv-clear" ''
    ${ctpvEnv}
    exec ${ctpv}/bin/ctpvclear "$@"
  '';
in
{
  xdg.configFile."lf/icons".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/gokcehan/lf/r32/etc/icons.example";
    sha256 = "0141nzyjr3mybkbn9p0wwv5l0d0scdc2r7pl8s1lgh11wi2l771x";
  };

  home.packages = [ ctpv ];

  programs.lf = {
    enable = true;
    previewer = {
      keybinding = "i";
      source = ctpvPreviewer;
    };
    settings = {
      ratios = [
        1
        2
        3
      ];
      shell = "sh";
      shellopts = "-eu";
      ifs = "\\n";
      scrolloff = 10;
      info = "size";
      icons = true;
    };
    commands = {
      open = ''
        ''${{
          case $(file --mime-type $f -b) in
            text/*) $EDITOR $fx;;
            *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;
          esac
        }}
      '';
      delete = ''
        ''${{
          set -f
          printf "$fx\n"
          printf "delete?[y/n]"
          read ans
          [ $ans = "y" ] && rm -rf $fx
        }}
      '';
      extract = ''
        ''${{
          set -f
          case $f in
            *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
            *.tar.gz|*.tgz) tar xzvf $f;;
            *.tar.xz|*.txz) tar xJvf $f;;
            *.tar.zst|*.tzst) tar -I zstd -xvf $f;;
            *.zip) unzip $f;;
            *.rar) unrar x $f;;
            *.7z) 7z x $f;;
          esac
        }}
      '';
      opti = ''
        ''${{
          set -f
          echo "$fx" | grep -i -e "\\.jpe\?g" | xargs -I{} jpegoptim --strip-all '{}'
          echo "$fx" | grep -i -e "\\.png" | xargs -I{} oxipng --verbose --strip all '{}'
          echo "$fx" | grep -i -e "\\.webp" | xargs -I{} cwebp '{}' -lossless -z 9 -mt -o '{}'
        }}
      '';
      opti2 = ''
        ''${{
          set -f
          echo "$fx" | grep -i -e "\\.jpe\?g" | xargs -I{} sh -c 'jpegoptim --strip-all "{}"; magick "{}" -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB "{}"'
          echo "$fx" | grep -i -e "\\.png" | xargs -I{} pngquant --quality 40-80 '{}'
          echo "$fx" | grep -i -e "\\.webp" | xargs -I{} cwebp '{}' -q 75 -alpha_q 80 -m 6 -mt -o '{}'
        }}
      '';
      tojpg = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; magick "$f" "''${f%.*}.jpg"'
        }}
      '';
      towebp = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; cwebp "$f" -lossless -z 9 -mt -o "''${f%.*}.webp"'
        }}
      '';
      towebp2 = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; cwebp "$f" -q 75 -alpha_q 80 -m 6 -mt -o "''${f%.*}.webp"'
        }}
      '';
      resize = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} magick '{}' -resize ''${1}% '{}'
        }}
      '';
      touch = ''
        ''${{
          set -f
          touch $1
        }}
      '';
      waifu = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; realesrgan-ncnn-vulkan -i "$f" -o "''${f%.*}_2x.''${f##*.}" -n realesrgan-x4plus-anime'
        }}
      '';
      md5 = ''
        ''${{
          set -f
          printf '%s\0' $fx | xargs -0 -I{} sh -c 'f="{}"; mv "$f" $(md5sum "$f" | cut -d" " -f1).''${f##*.}'
        }}
      '';
      sha256 = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; mv "$f" $(sha256sum "$f" | cut -d" " -f1).''${f##*.}'
        }}
      '';
      sha3 = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; mv "$f" $(rhash --sha3-512 "$f" | cut -d" " -f1).''${f##*.}'
        }}
      '';
      exif = ''
        ''${{
          set -f
          echo "$fx" | xargs -I{} sh -c 'f="{}"; exiftool -all= "$f" && rm -f "''${f}_original"'
        }}'';
      av1 = ''
        ''${{
          set -f
          ffmpeg -i "$f" -c:v libsvtav1 -preset 7 -crf "''${1}" -b:v 0 -pass 1 -an -f null /dev/null && ffmpeg -i "$f" -c:a libopus -c:v libsvtav1 -preset 7 -crf "''${1}" -b:v 0 -pass 2 "''${2}"
        }}
      '';
      vp9 = ''
        ''${{
          set -f
          ffmpeg -i "$f" -c:v libvpx-vp9 -row-mt 1 -b:v 0 -crf "''${1}" -pass 1 -an -f null /dev/null && ffmpeg -i "$f" -c:v libvpx-vp9 -row-mt 1 -b:v 0 -crf "''${1}" -pass 2 -c:a libopus "''${2}"
        }}
      '';
      h264 = ''
        ''${{
          set -f
          ffmpeg -i "$f" -c:v h264 -c:a aac -crf "''${1}" -preset slow "''${2}"
        }}
      '';
      cawp = "cd ~/Anime/Wallpaper";
      ct = "cd /scratch";
    };
    keybindings = {
      o = "&mimeopen $fx";
      O = "$mimeopen --ask-default $fx";
      D = "delete";
      "." = "set hidden!";
    };
    extraConfig = ''
      set cleaner ${ctpvClear}
      &${ctpv}/bin/ctpv -s $id
      # Clear now. Quitting the server here races the cleaner and leaks a fifo.
      cmd on-quit %${ctpvClear} $id; rm -rf /tmp/ctpv-fit.$id
      &${ctpv}/bin/ctpvquit $id
    '';
  };
}
