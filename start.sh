#!/bin/bash
cd "$(dirname "$0")"

mkdir -p /home/runner/extlibs

if [ ! -f /home/runner/extlibs/libssl.so.1.1 ]; then
  echo "Downloading OpenSSL 1.1.1..."
  curl -sL "http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb" -o /tmp/ssl111.deb
  dpkg -x /tmp/ssl111.deb /tmp/ssl111_extract
  cp /tmp/ssl111_extract/usr/lib/x86_64-linux-gnu/libssl.so.1.1 /home/runner/extlibs/
  cp /tmp/ssl111_extract/usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /home/runner/extlibs/
  echo "OpenSSL done."
fi

if [ ! -f /home/runner/extlibs/libz.so.1 ]; then
  echo "Downloading libz..."
  curl -sL "https://archive.ubuntu.com/ubuntu/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2ubuntu9.2_amd64.deb" -o /tmp/zlib.deb
  dpkg -x /tmp/zlib.deb /tmp/zlib_extract
  cp /tmp/zlib_extract/lib/x86_64-linux-gnu/libz.so.1.2.11 /home/runner/extlibs/libz.so.1
  echo "libz done."
fi


if [ ! -f /home/runner/extlibs/libstdc++.so.6 ]; then
  STDCXX_SRC="/nix/store/055bzdrski1dwqa4km1gxpcjhpn73mng-gcc-10.3.0-lib/lib/libstdc++.so.6.0.28"
  if [ -f "$STDCXX_SRC" ]; then
    cp "$STDCXX_SRC" /home/runner/extlibs/libstdc++.so.6
    echo "libstdc++ done."
  else
    echo "WARNING: libstdc++ not found at expected path, bot may fail."
  fi
fi

echo "Libs ready: $(ls /home/runner/extlibs/)"


BOT_TOKEN="${BOT_TOKEN}"
if [ -n "$BOT_TOKEN" ] && [ -n "$SUDO_ID" ] && [ -n "$USER_SUDO" ]; then
  BOT_USERNAME=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
  cat > ./Information.lua << EOF
return {
Token = "${BOT_TOKEN}",
UserBot = "${BOT_USERNAME}",
UserSudo = "${USER_SUDO}",
SudoId = ${SUDO_ID}
}
EOF
  echo "Information.lua created from environment secrets."
elif [ ! -f ./Information.lua ]; then
  echo "ERROR: BOT_TOKEN, SUDO_ID, and USER_SUDO are required."
  exit 1
fi


REDIS_BIN=$(which redis-server 2>/dev/null || echo "/nix/store/pnc74r60iz1g5bpqv4qh76a8cc3g0n97-redis-7.2.10/bin/redis-server")
REDIS_CLI=$(which redis-cli 2>/dev/null || echo "/nix/store/pnc74r60iz1g5bpqv4qh76a8cc3g0n97-redis-7.2.10/bin/redis-cli")

if ! "$REDIS_CLI" ping 2>/dev/null | grep -q PONG; then
  echo "Starting Redis..."
  "$REDIS_BIN" --daemonize yes --logfile /tmp/redis.log
  
  for i in $(seq 1 10); do
    sleep 1
    if "$REDIS_CLI" ping 2>/dev/null | grep -q PONG; then
      echo "Redis is ready."
      break
    fi
    echo "Waiting for Redis... ($i/10)"
  done
else
  echo "Redis already running."
fi

LUA_BIN=$(which lua5.3 2>/dev/null || which lua 2>/dev/null || echo "/nix/store/j6ascsn1lm31m7386iznbjjak3m41760-lua-5.3.6/bin/lua")

# ─── تثبيت yt-dlp إذا لم يكن موجوداً ──────────────────────────
if ! command -v yt-dlp &>/dev/null && [ ! -f /home/runner/.local/bin/yt-dlp ]; then
  echo "Installing yt-dlp..."
  mkdir -p /home/runner/.local/bin
  curl -sL "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" -o /home/runner/.local/bin/yt-dlp
  chmod +x /home/runner/.local/bin/yt-dlp
  echo "yt-dlp installed."
else
  echo "yt-dlp already installed."
fi
export PATH="/home/runner/.local/bin:$PATH"

chmod +x ./yt-dlp-wrapper.sh 2>/dev/null || true

echo "Starting RonyBot..."
LD_LIBRARY_PATH="/home/runner/extlibs" "$LUA_BIN" Mero.lua
