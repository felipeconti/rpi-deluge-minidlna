FROM resin/rpi-raspbian:jessie
MAINTAINER Felipe Bonvicini Conti <felipeconti18@gmail.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -qy deluged deluge-web deluge-console
RUN apt-get install -y minidlna

RUN apt-get -y clean
RUN apt-get -y autoclean
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i 's/media_dir=\/var\/lib\/minidlna/media_dir=\/data/' /etc/minidlna.conf
RUN sed -i 's/#root_container=./root_container=V/' /etc/minidlna.conf
RUN sed -i 's/#friendly_name=/friendly_name=Movies/' /etc/minidlna.conf
RUN sed -i 's/#inotify=yes/inotify=yes/' /etc/minidlna.conf

# Deluge
EXPOSE 58846 8112 8200

# MiniDLNA
EXPOSE 8200

VOLUME /config
VOLUME /data

WORKDIR /

ADD entry.sh /entry.sh

CMD ["/entry.sh"]
