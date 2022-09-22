#!/bin/bash
collection="$1"
if [ "$RES" = "" ];
then
	export RES="512x512"
fi
mkdir -P ~/datasets
python3 ~/pinterest-downloader/pinterest-downloader.py $collection -io -d ~/datasets
mogrify -geometry $RES ~/datasets/$collection/*.jpg
mogrify -geometry $RES ~/datasets/$collection/*.png
rm ~/datasets/$collection/*~ || true
rm ~/datasets/$collection/*.log || true
rm ~/datasets/$collection/*.urls || true
mogrify -format png ~/datasets/$collection/*.*
rm ~/datasets/$collection/*.jpg || true
