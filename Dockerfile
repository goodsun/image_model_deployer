FROM bizenyakiko/genai-base:1.1

# Install ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI && \
    cd /ComfyUI && \
    pip install -r requirements.txt

# Install ComfyUI-Manager
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git && \
    cd ComfyUI-Manager && \
    pip install -r requirements.txt || true

# Install handler dependencies
RUN pip install runpod websocket-client Pillow

# Download Unholy Desire Mix Sinister Aesthetic v8 (~6.9GB, Civitai)
ARG CIVITAI_API_TOKEN
RUN test -n "$CIVITAI_API_TOKEN" || { echo "ERROR: CIVITAI_API_TOKEN is required"; exit 1; } && \
    mkdir -p /ComfyUI/models/checkpoints && \
    wget --progress=dot:giga \
    "https://civitai.com/api/download/models/2824082?token=${CIVITAI_API_TOKEN}" \
    -O /ComfyUI/models/checkpoints/UnholyDesireMixSinisterAesthetic_V8.safetensors && \
    FILESIZE=$(stat -c%s /ComfyUI/models/checkpoints/UnholyDesireMixSinisterAesthetic_V8.safetensors 2>/dev/null || stat -f%z /ComfyUI/models/checkpoints/UnholyDesireMixSinisterAesthetic_V8.safetensors) && \
    test "$FILESIZE" -gt 1000000000 || { echo "ERROR: Downloaded file too small (${FILESIZE} bytes). Civitai token may be invalid or model unavailable."; exit 1; }

# Copy files
COPY handler.py /handler.py
COPY download_lora.py /download_lora.py
COPY model.json /model.json
COPY lora.json /lora.json
COPY extra_model_paths.yaml /ComfyUI/extra_model_paths.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Fallback dummy LoRA for strength=0 passthrough
RUN touch /ComfyUI/models/loras/default.safetensors

ENTRYPOINT ["/entrypoint.sh"]
