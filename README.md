# Stable Diffusion Workspace

A docker container preloaded with stable diffusion and cuda drivers.

I've built this for my personal, don't expect it to be properly documented or supported.

## Requirements
- Linux Host
- Docker
- NVIDIA gpus with proprietary drivers and cuda
- [Huggingface](https://huggingface.co/)'s username and apikey to download the model  (free)
- At least 16 GB for ram
- A decent nvidia GPU with >=8 GB vram 

## Usage / Cheatsheet

### Run workspace

```bash
mkdir -p /ai/outputs/stable-diffusion/
mkdir -p /ai/training/stable-diffusion/
mkdir -p /ai/datasets/stable-diffusion/
mkdir -p /ai/models/stable-diffusion/

docker run  
-eHUGGINGFACE_USER="%%USERNAME%%" \
-eHUGGINGFACE_PASSWORD="%%API_KEY%%" \
-d \
-v /ai/outputs/stable-diffusion/:/root/InvokeAI/outputs \
-v /ai/training/stable-diffusion/:/root/InvokeAI/logs \
-v /ai/datasets/stable-diffusion/:/root/datasets \
-v /ai/models/stable-diffusion:/root/models \
--name="stable-diffusion-workspace" \
--gpus all --shm-size="8g" --ulimit memlock=-1 --ulimit stack=67108864 \
riccardoblb/stable-diffusion-workspace
```

Note: 
- You might want to change the paths  
```
/ai/outputs/stable-diffusion
/ai/training/stable-diffusion
/ai/datasets/stable-diffusion
/ai/models/stable-diffusion
```
- Decrease shm-size if your machine doesn't have enough ram (a shm-size of 1gb should be enough, probably)


### Open a shell inside the workspace
```bash
docker exec -it stable-diffusion-workspace bash
```

### Download a pinterest collection as dataset
```bash
download_dataset.sh user/collection
```


### Fine tuning
Tweak the yaml files `/root/InvokeAI/configs/stable-diffusion/v1-finetune_style.yaml` or  `/root/InvokeAI/configs/stable-diffusion/v1-finetune.yaml` to your liking.

See: https://towardsdatascience.com/how-to-fine-tune-stable-diffusion-using-textual-inversion-b995d7ecc095

and: https://www.youtube.com/watch?v=WsDykBTjo20

to get a better understanding on what to do.

Then run

```bash
cd /root/InvokeAI

python3 main.py --base ./configs/stable-diffusion/v1-finetune_style.yaml -t --actual_resume ~/InvokeAI/models/ldm/stable-diffusion-v1/model.ckpt  -n SOMETHING --data_root ~/datasets/YOUR_DATASET --precision 32 --gpus 0,
```
( --precision 32 is for gpus that don't support half precision (1xxx gpus and <))


### Interactive Terminal
```bash
python3 ./scripts/dream.py 

```
add
```bash
--embedding_path /path/to/embeddings.pt
```
to load the result of your finetuning

Note: use --full_precision for 1x< gpus

### More commands

See [InvokeAI's docs](https://github.com/invoke-ai/InvokeAI)
