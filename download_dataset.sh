#!/bin/bash
collection="$1"
conda activate ldm || true
mkdir -P ~/datasets
python3 ~/pinterest-downloader/pinterest-downloader.py $collection -io -d ~/datasets
mogrify -geometry 512x512 ~/datasets/$collection/*.jpg
mogrify -geometry 512x512 ~/datasets/$collection/*.png
rm ~/datasets/$collection/*~
rm ~/datasets/$collection/*.log
rm ~/datasets/$collection/*.urls
