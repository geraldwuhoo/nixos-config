# Ghostty 1.3 shows only a direct single-frame PNG, and only if that
# escape arrives in one write. Fit to the cell box so icat does not scale.
set -u

file=$1
cell_w=$2
cell_h=$3
origin_x=$4
origin_y=$5

# TIOCGWINSZ: columns, rows, width in pixels, height in pixels.
size=$(python3 - 2>/dev/null <<'PY' || true
import fcntl, struct, sys

with open("/dev/tty", "rb") as tty:
    rows, cols, xpix, ypix = struct.unpack("HHHH", fcntl.ioctl(tty, 0x5413, b"\0" * 8))
if not (cols and rows and xpix >= cols and ypix >= rows):
    sys.exit(1)
print(f"{cols},{rows},{xpix},{ypix}")
PY
)

if [ -n "$size" ] && [ -f "$file" ]; then
  IFS=, read -r cols rows xpix ypix <<<"$size"
  if aw=$((cell_w * xpix / cols)) ah=$((cell_h * ypix / rows)) 2>/dev/null &&
    [ "$aw" -ge 1 ] && [ "$ah" -ge 1 ]
  then
    # id is the ctpv server id. A fit older than a minute is from an earlier preview.
    dir=/tmp/ctpv-fit.$id
    mkdir -p -- "$dir"
    find "$dir" -type f -mmin +1 -delete 2>/dev/null || true
    out=$(mktemp "$dir/fit.XXXXXX.png")
    if magick "$file[0]" -auto-orient -strip -resize "${aw}x${ah}>" "png:$out"; then
      file=$out
    else
      rm -f -- "$out"
    fi
  fi
fi

esc=$(mktemp)
trap 'rm -f -- "$esc"' EXIT TERM INT
kitty +kitten icat --silent --stdin no --transfer-mode file --align left \
  ${size:+--use-window-size "$size"} \
  --place "${cell_w}x${cell_h}@${origin_x}x${origin_y}" "$file" </dev/null >"$esc" || true
dd if="$esc" of=/dev/tty bs=1048576 status=none 2>/dev/null || true
