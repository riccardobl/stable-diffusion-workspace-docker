#!/bin/bash
collection="$1"
if [ "$RES" = "" ];
then
	export RES="512x512"
fi
mkdir -P /data/datasets
rm /data/datasets/$collection/*.* || true
python3 ~/pinterest-downloader/pinterest-downloader.py $collection -f -io -d /data/datasets
mogrify -geometry $RES /data/datasets/$collection/*.jpg
mogrify -geometry $RES /data/datasets/$collection/*.png
rm /data/datasets/$collection/*~ || true
rm /data/datasets/$collection/*.log || true
rm /data/datasets/$collection/*.urls || true
mogrify -format png /data/datasets/$collection/*.*
rm /data/datasets/$collection/*.jpg || true
