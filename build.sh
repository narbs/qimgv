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

# install under /usr/local (cmake's default prefix) so pacman's qimgv package
# never clobbers it. /usr/local/bin precedes /usr/bin in PATH, and the mpv
# plugin lands in /usr/local/lib/qimgv — the first dir the binary searches.
sudo cmake --install build
