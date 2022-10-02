#!/bin/bash

cd ~ 
mkdir -p /data/training 
mkdir -p /data/outputs 
mkdir -p /data/models 
mkdir -p /data/datasets
mkdir -p /data/models/custom
if [ ! -f /models/model.ckpt ];
then
	wget --http-user="$HUGGINGFACE_USER" --http-password="$HUGGINGFACE_PASSWORD" \
	https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4-full-ema.ckpt -O /data/models/model.ckpt
fi


cd ~/InvokeAI
python3 scripts/preload_models.py 


cd ~/stable-diffusion-webui
screen ./webui.sh

bash -c "while true; do sleep 1000;done"
