FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04 

ENV HUGGINGFACE_USER=""
ENV HUGGINGFACE_PASSWORD=""

RUN \
mkdir -p /data \
&&mkdir -p /data/training \
&&mkdir -p /data/outputs \
&&mkdir -p /data/models \
&&mkdir -p /data/datasets \
&&useradd -m -s /bin/bash nonroot \
&&chown nonroot:nonroot /data -Rvf 


RUN  \
apt update  \
&&apt install git wget nano screen libglib2.0-0 python3 libsm6 imagemagick libxrender1 python3-pip libglu1-mesa libxi-dev libxmu-dev libglu1-mesa-dev screen -y 


USER nonroot

# InvokeAI
RUN \
cd /tmp  \
&&wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh -O Anaconda.sh  \
&&chmod +x Anaconda.sh  \
&&./Anaconda.sh -b  \
&&rm ./Anaconda.sh  \
&&~/anaconda3/bin/conda init bash  \
&&eval "$(~/anaconda3/bin/conda shell.bash hook)"  \
&&cd ~  \
&&git clone https://github.com/invoke-ai/InvokeAI.git  \
&&rm -Rf ./stable-diffusion  \
&&cd InvokeAI \
&&conda env create -f environment.yaml  \
&&conda activate ldm  \
&&conda install pytorch==1.11.0 torchvision==0.12.0 cudatoolkit=11.3 -c pytorch && conda clean -a -y  \
&&ln -s /data/models models/ldm/stable-diffusion-v1  \
&&ln -s /data/training logs  \
&&ln -s /data/outputs  outputs  


# Native Training
# && cd ~ 
# && git clone https://github.com/justinpinkney/stable-diffusion \
# && cd stable-diffusion \
# && ln -s ~/models models/ldm/stable-diffusion-v1 \
# && ln -s ~/training logs \
# && ln -s ~/outputs  outputs \
# && python3 -m pip install -r requirements.txt 


# Dataset downloader
COPY pinterest-downloader /home/nonroot/pinterest-downloader

RUN \
cd ~  \
&&~/anaconda3/bin/conda init bash  \
&&eval "$(~/anaconda3/bin/conda shell.bash hook)"  \
&&cd pinterest-downloader  \
&&conda activate ldm  \
&&python3 -m pip install -r requirements.txt 



# WebUI
RUN \
cd ~ \ 
&&git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git \
&&cd stable-diffusion-webui \
&&rm -Rvf models \
&&ln -s /data/models models \
&&echo 'export COMMANDLINE_ARGS="--listen  --embeddings-dir /data/models/custom  --gfpgan-model  /data/models/GFPGAN/GFPGANv1.3.pth  --esrgan-models-path /data/models/ESRGAN/"' >> webui-user.sh



RUN echo "conda activate ldm" >> ~/.bashrc

USER root
COPY entrypoint.sh /entrypoint.sh
COPY download_dataset.sh /bin/download_dataset.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /bin/download_dataset.sh
USER nonroot 
VOLUME /data
WORKDIR /home/nonroot

EXPOSE 7860
ENTRYPOINT /entrypoint.sh


