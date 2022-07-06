FROM alpine as build

RUN apk --no-cache add git alsa-lib alsa-lib-dev make cmake automake autoconf g++
RUN git clone https://github.com/quiniouben/vban.git
RUN cd vban; \
    ./autogen.sh; \
    ./configure --enable-alsa --disable-pulseaudio --disable-jack; \
    make

FROM alpine

RUN apk --no-cache add alsa-utils alsa-lib alsaconf alsa-ucm-conf openrc; \
    addgroup root audio; \
    rc-update add alsa

COPY --from=build vban/src/vban_receptor /usr/bin/

USER root
ENTRYPOINT ["vban_receptor"]
