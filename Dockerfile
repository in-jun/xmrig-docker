FROM alpine:3.19 AS builder
RUN apk add --no-cache build-base cmake libuv-dev openssl-dev hwloc-dev git
WORKDIR /tmp
RUN git clone https://github.com/xmrig/xmrig.git && cd xmrig && mkdir build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_HWLOC=ON && make -j$(nproc)

FROM alpine:3.19
RUN apk add --no-cache libuv openssl hwloc libgcc libstdc++ && adduser -D -s /bin/sh xmrig
COPY --from=builder /tmp/xmrig/build/xmrig /usr/local/bin/
USER xmrig
WORKDIR /home/xmrig

CMD ["sh", "-c", "echo \"{\\\"pools\\\":[{\\\"coin\\\":\\\"monero\\\",\\\"url\\\":\\\"${POOL_URL:-gulf.moneroocean.stream:10001}\\\",\\\"user\\\":\\\"${WALLET_ADDRESS:-YOUR_WALLET_ADDRESS_HERE}\\\",\\\"rig-id\\\":\\\"${WORKER_ID:-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)}\\\",\\\"keepalive\\\":true}],\\\"randomx\\\":{\\\"1gb-pages\\\":true},\\\"colors\\\":false}\" > config.json && exec xmrig --config=config.json"]