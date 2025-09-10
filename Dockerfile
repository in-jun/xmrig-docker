FROM alpine:latest AS builder
RUN apk add --no-cache git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers
WORKDIR /build
RUN git clone https://github.com/xmrig/xmrig.git
WORKDIR /build/xmrig
RUN sed -i 's/constexpr const int kDefaultDonateLevel = [0-9]*;/constexpr const int kDefaultDonateLevel = 0;/' src/donate.h && sed -i 's/constexpr const int kMinimumDonateLevel = [0-9]*;/constexpr const int kMinimumDonateLevel = 0;/' src/donate.h
WORKDIR /build/xmrig/scripts
RUN ./build_deps.sh
WORKDIR /build/xmrig
RUN mkdir -p build && cd build && cmake .. -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON && make -j$(nproc)

FROM alpine:latest
RUN apk add --no-cache libstdc++ && adduser -D -s /bin/sh xmrig
COPY --from=builder /build/xmrig/build/xmrig /usr/local/bin/xmrig
RUN chmod +x /usr/local/bin/xmrig && mkdir -p /home/xmrig/.config && chown -R xmrig:xmrig /home/xmrig
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
WORKDIR /home/xmrig
USER xmrig
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["xmrig"]