ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE} as buntu-base

WORKDIR /workspace

# Create venv
ENV VIRTUAL_ENV=/workspace/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
RUN pip install git+https://github.com/TencentARC/GFPGAN.git
RUN pip install git+https://github.com/openai/CLIP.git
RUN pip install git+https://github.com/mlfoundations/open_clip.git

RUN pip install https://github.com/ArrowM/xformers/releases/download/xformers-0.0.17-cu118-linux/xformers-0.0.17+7f4fdce.d20230204-cp310-cp310-linux_x86_64.whl
RUN pip install https://download.pytorch.org/whl/nightly/cu118/torch-2.0.0.dev20230202%2Bcu118-cp310-cp310-linux_x86_64.whl https://download.pytorch.org/whl/nightly/cu118/torchvision-0.15.0.dev20230202%2Bcu118-cp310-cp310-linux_x86_64.whl https://download.pytorch.org/whl/nightly/pytorch_triton-2.0.0%2B0d7e753227-cp310-cp310-linux_x86_64.whl

RUN jupyter nbextension enable --py widgetsnbextension

WORKDIR /workspace/
RUN mkdir /workspace/models
RUN wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors -O /workspace/models/v1-5-pruned.safetensors
RUN wget https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-nonema-pruned.safetensors -O /workspace/models/v2-1_768-nonema-pruned.safetensors
RUN wget https://huggingface.co/ckpt/stable-diffusion-2-1/raw/main/v2-inference-v.yaml -O /workspace/models/v2-1_768-nonemaema-pruned.yaml

SHELL ["/bin/bash", "-c"]

ADD start.sh /start.sh
RUN chmod a+x /start.sh
SHELL ["/bin/bash", "--login", "-c"]
