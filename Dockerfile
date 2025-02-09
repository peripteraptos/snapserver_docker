# Install SnapServer on minimal OS
FROM amd64/alpine:latest

MAINTAINER inoni
WORKDIR /root

RUN apk -U add git bash build-base asio-dev avahi-dev flac-dev libvorbis-dev alsa-lib-dev opus-dev soxr-dev cmake \
 && git clone --recursive https://github.com/badaix/snapcast.git \
 && make -C snapcast/server \
 && cp snapcast/server/snapserver /usr/local/bin

RUN git clone https://github.com/badaix/snapweb \
 && mkdir -p /var/www/html \
 && apk add nodejs npm && npm install -g typescript \
 && cd snapweb && make && cd .. \
 && cp -r snapweb/dist/* /var/www/html \
 && wget -O /etc/snapserver.conf https://raw.githubusercontent.com/Saiyato/snapserver_docker/master/snapserver/snapserver.conf \ 
 && apk --purge del git build-base asio-dev avahi-dev flac-dev libvorbis-dev alsa-lib-dev opus-dev soxr-dev cmake \
 && apk add avahi-libs flac libvorbis opus soxr alsa-lib \
 && rm -rf /etc/ssl /var/cache/apk/* /lib/apk/db/* snapcast snapweb

EXPOSE 1704
EXPOSE 1705
EXPOSE 1780

ENTRYPOINT ["snapserver"]
