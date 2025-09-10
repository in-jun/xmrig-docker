#!/bin/sh
set -e
if [ "${1#-}" != "$1" ]; then
    set -- xmrig "$@"
fi
if [ "$1" = "xmrig" ]; then
    exec /usr/local/bin/xmrig "$@"
fi
exec "$@"