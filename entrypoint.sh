#!/bin/bash

cd ~ 
mkdir -p /data/training 
mkdir -p /data/outputs 
mkdir -p /data/models 
mkdir -p /data/datasets
mkdir -p /data/models/custom

if [ ! -f /data/models/model.ckpt ];
then
    aria2c --seed-time=0 \
    "magnet:?xt=urn:btih:3a4a612d75ed088ea542acac52f9f45987488d1c&dn=sd-v1-4.ckpt&tr=udp%3a%2f%2ftracker.openbittorrent.com%3a6969%2fannounce&tr=udp%3a%2f%2ftracker.opentrackr.org%3a1337" \
    -d /data/models/
fi

ln -s /data/models/sd-v1-4.ckpt /data/models/model.ckpt 

mkdir -p /data/models/Stable-diffusion/
if [ ! -f /models/Stable-diffusion/sd-v1-4.ckpt ];
then
    ln -s /data/models/sd-v1-4.ckpt /models/Stable-diffusion/sd-v1-4.ckpt
fi

# if [ ! -f /models/model.ckpt ];
# then
# 	wget --http-user="$HUGGINGFACE_USER" --http-password="$HUGGINGFACE_PASSWORD" \
# 	https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4-full-ema.ckpt -O /data/models/model.ckpt
# fi


cd ~/InvokeAI
python3 scripts/preload_models.py 


cd ~/stable-diffusion-webui
./webui.sh

bash -c "while true; do sleep 1000;done"
