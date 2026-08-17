#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# wipe the cache so a stale Qt5 configure doesn't stick around
rm -rf build

# use the system pkg-config, not linuxbrew's — brew's copy doesn't see
# /usr/lib/pkgconfig, so exiv2/mpv come up missing
cmake -B build -DCMAKE_BUILD_TYPE=Release -DUSE_QT5=OFF \
    -DPKG_CONFIG_EXECUTABLE=/usr/bin/pkg-config
cmake --build build -j"$(nproc)"

sudo cp build/qimgv/qimgv /usr/bin/qimgv
# mpv plugin — qimgv looks for it in /usr/lib/qimgv (videoplayerinitproxy.cpp)
sudo install -Dm755 build/plugins/player_mpv/player_mpv.so /usr/lib/qimgv/player_mpv.so
