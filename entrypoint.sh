#!/bin/bash

cd ~ 
mkdir -p models 

if [ ! -f models/model.ckpt ];
then
	wget --http-user="$HUGGINGFACE_USER" --http-password="$HUGGINGFACE_PASSWORD" https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt -O models/model.ckpt
fi

cd ~/InvokeAI
python3 scripts/preload_models.py 

bash -c "while true; do sleep 1000;done"

