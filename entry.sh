#!/bin/bash

CONFIGDIR=/config
DATADIR=/data

echo "Creating config and data directories."
mkdir -p $CONFIGDIR
mkdir -p $DATADIR

if [ ! -d $CONFIGDIR ]; then
        echo "The config directory does not exist! Please add it as a volume."
        exit 1
fi
if [ ! -d $DATADIR ]; then
        echo "The data directory does not exist! Please add it as a volume."
        exit 1
fi

# Check if need to initialize
if [ ! -f $CONFIGDIR/auth ]; then
        echo "Initial setup..."
        # Starting deluge
        deluged -c $CONFIGDIR

        # Wait until auth file created.
        while [ ! -f $CONFIGDIR/auth ]; do
                sleep 1
        done

        # allow remote access
        deluge-console -c $CONFIGDIR "config -s allow_remote True"

        # setup default paths to go to the user's defined data folder.
        deluge-console -c $CONFIGDIR "config -s download_location $DATADIR"
        deluge-console -c $CONFIGDIR "config -s torrentfiles_location $DATADIR"
        deluge-console -c $CONFIGDIR "config -s move_completed_path $DATADIR"
        deluge-console -c $CONFIGDIR "config -s autoadd_location $DATADIR"

        # Stop deluged.
        pkill deluged

        echo "Adding initial authentication details."
        echo deluge:deluge:10 >> $CONFIGDIR/auth
fi

echo "Starting minidlna..."
minidlnad -f /etc/minidlna.conf

echo "Starting deluged and deluge-web..."
deluged -c /config
deluge-web -c /config

echo "All running!"
