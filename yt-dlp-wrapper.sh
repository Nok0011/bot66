#!/bin/bash
# yt-dlp wrapper — يبحث عن yt-dlp في أماكن متعددة
# Used by Music.lua

YTDLP=""

# Check common locations
for p in \
    /home/runner/.local/bin/yt-dlp \
    /usr/local/bin/yt-dlp \
    /usr/bin/yt-dlp \
    ./yt-dlp \
    yt-dlp; do
    if command -v "$p" &>/dev/null 2>&1 || [ -x "$p" ]; then
        YTDLP="$p"
        break
    fi
done

if [ -z "$YTDLP" ]; then
    echo "ERROR: yt-dlp not found. Install it with: pip install yt-dlp" >&2
    exit 1
fi

exec "$YTDLP" "$@"
