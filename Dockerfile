FROM resin/rpi-raspbian:jessie
MAINTAINER Felipe Bonvicini Conti <felipeconti18@gmail.com>

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -qy deluged deluge-web deluge-console && \
  apt-get install -y minidlna && \
  apt-get -y clean && \
  apt-get -y autoclean && \
  apt-get -y autoremove && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i 's/media_dir=\/var\/lib\/minidlna/media_dir=\/data/' /etc/minidlna.conf
RUN sed -i 's/#root_container=./root_container=V/' /etc/minidlna.conf
RUN sed -i 's/#friendly_name=/friendly_name=Movies/' /etc/minidlna.conf
RUN sed -i 's/#inotify=yes/inotify=yes/' /etc/minidlna.conf

# Deluge and MiniDLNA
EXPOSE 58846 8112 8200

VOLUME /config
VOLUME /data

WORKDIR /

ADD entry.sh /entry.sh

CMD ["/entry.sh"]
