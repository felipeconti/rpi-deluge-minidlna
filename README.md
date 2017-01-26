# rpi-deluge-minidlna

## Docker for rpi-deluge-minidlna

### Build
```sh
docker build -t rpi-deluge-minidlna .
```

### Run
```sh
docker run -d --restart=always -v /home/pi/config/:/config -v /home/pi/hd/:/data -p 58846:58846 -p 80:8112 -p 8200:8200 --name=movies felipeconti/rpi-deluge-minidlna
```
