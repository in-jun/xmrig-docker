FROM alpine:3.19 AS builder
RUN apk add --no-cache build-base cmake libuv-dev openssl-dev hwloc-dev git
WORKDIR /tmp
RUN git clone https://github.com/xmrig/xmrig.git && cd xmrig && mkdir build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_HWLOC=ON && make -j$(nproc)

FROM alpine:3.19
RUN apk add --no-cache libuv openssl hwloc libgcc libstdc++ && adduser -D -s /bin/sh xmrig
COPY --from=builder /tmp/xmrig/build/xmrig /usr/local/bin/
USER xmrig
WORKDIR /home/xmrig

CMD ["sh", "-c", "echo \"{\\\"pools\\\":[{\\\"algo\\\":\\\"rx/0\\\",\\\"coin\\\":\\\"monero\\\",\\\"url\\\":\\\"${POOL_URL:-kr.monero.herominers.com:1111}\\\",\\\"user\\\":\\\"${WALLET_ADDRESS:-YOUR_WALLET_ADDRESS_HERE}\\\",\\\"pass\\\":\\\"x\\\",\\\"keepalive\\\":true,\\\"nicehash\\\":false,\\\"enabled\\\":true}],\\\"randomx\\\":{\\\"1gb-pages\\\":true},\\\"colors\\\":false,\\\"print-time\\\":30}\" > config.json && exec xmrig --config=config.json"]