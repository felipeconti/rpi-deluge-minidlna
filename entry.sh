#!/bin/bash

CONFIGDIR=/config
DELUGECONFIGDIR=$CONFIGDIR/deluge
DATADIR=/data

echo "Creating config and data directories."
mkdir -p $CONFIGDIR
mkdir -p $DELUGECONFIGDIR
mkdir -p $DATADIR

if [ ! -d $CONFIGDIR ]; then
        echo "The config directory does not exist! Please add it as a volume."
        exit 1
fi
if [ ! -d $DATADIR ]; then
        echo "The data directory does not exist! Please add it as a volume."
        exit 1
fi

# Check if the authentication file exists.
if [ ! -f $DELUGECONFIGDIR/auth ]; then
        AUTHMISSING=true
fi

if [ $AUTHMISSING ]; then
        echo "Doing initial setup."
        # Starting deluge
        deluged -c $DELUGECONFIGDIR

        # Wait until auth file created.
        while [ ! -f $DELUGECONFIGDIR/auth ]; do
                sleep 1
        done

        # allow remote access
        deluge-console -c $DELUGECONFIGDIR "config -s allow_remote True"

        # setup default paths to go to the user's defined data folder.
        deluge-console -c $DELUGECONFIGDIR "config -s download_location $DATADIR"
        deluge-console -c $DELUGECONFIGDIR "config -s torrentfiles_location $DATADIR"
        deluge-console -c $DELUGECONFIGDIR "config -s move_completed_path $DATADIR"
        deluge-console -c $DELUGECONFIGDIR "config -s autoadd_location $DATADIR"

        # Stop deluged.
        pkill deluged

        echo "Adding initial authentication details."
        echo deluge:deluge:10 >> $DELUGECONFIGDIR/auth
fi

echo "Starting minidlna."
minidlnad -f /etc/minidlna.conf

echo "Starting deluged and deluge-web."
deluged -c /config
deluge-web -c /config
