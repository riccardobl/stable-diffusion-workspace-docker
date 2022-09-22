FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04 

ENV HUGGINGFACE_USER=""
ENV HUGGINGFACE_PASSWORD=""

RUN apt update \
&& apt install git wget nano screen libglib2.0-0 python3 libsm6 imagemagick libxrender1 python3-pip -y \
&& cd /tmp \
&& wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh -O Anaconda.sh \
&& chmod +x Anaconda.sh \
&& ./Anaconda.sh -b \
&& rm ./Anaconda.sh \
&& ~/anaconda3/bin/conda init bash \
&& eval "$(~/anaconda3/bin/conda shell.bash hook)" \
&& cd ~ \
&& git clone https://github.com/basujindal/stable-diffusion.git \
&& git clone https://github.com/invoke-ai/InvokeAI.git \
&& cp -Rf ./stable-diffusion/optimizedSD ./InvokeAI/ \
&& rm -Rf ./stable-diffusion \
&& cd InvokeAI \
&& conda env create -f environment.yaml \
&& conda activate ldm \
&& ln -s ~/models models/ldm/stable-diffusion-v1 \
&& cd ~ \
&& git clone https://github.com/limkokhole/pinterest-downloader.git \
&& cd pinterest-downloader \
&& conda activate ldm \
&& python3 -m pip install -r requirements.txt 

RUN echo "conda activate ldm" >> /root/.bashrc

COPY entrypoint.sh /entrypoint.sh
COPY download_dataset.sh /bin/download_dataset.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /bin/download_dataset.sh

VOLUME /root/InvokeAI/outputs
VOLUME /root/InvokeAI/logs
VOLUME /root/datasets
VOLUME /root/models
WORKDIR /root
ENTRYPOINT /entrypoint.sh


