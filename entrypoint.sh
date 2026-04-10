#!/bin/bash
set -e

# Verify checkpoint exists and is valid
CKPT_PATH="/ComfyUI/models/checkpoints/RealisticFreedom_Omega.safetensors"
if [ ! -f "$CKPT_PATH" ]; then
    echo "ERROR: Checkpoint not found at $CKPT_PATH. Rebuild the image."
    exit 1
fi
CKPT_SIZE=$(stat -c%s "$CKPT_PATH" 2>/dev/null || stat -f%z "$CKPT_PATH")
if [ "$CKPT_SIZE" -lt 1000000000 ]; then
    echo "ERROR: Checkpoint is only ${CKPT_SIZE} bytes (expected >1GB). File may be corrupted or an error page. Rebuild the image with a valid CIVITAI_API_TOKEN."
    exit 1
fi
echo "Checkpoint present ($(du -h "$CKPT_PATH" | cut -f1))"

echo "Preparing default LoRA..."
python3 /download_lora.py

echo "Starting ComfyUI server..."
python /ComfyUI/main.py --listen --port 8188 &

echo "Waiting for ComfyUI to be ready..."
MAX_WAIT=120
WAITED=0
until curl -s http://127.0.0.1:8188/system_stats > /dev/null 2>&1; do
    sleep 1
    WAITED=$((WAITED + 1))
    if [ $WAITED -ge $MAX_WAIT ]; then
        echo "ERROR: ComfyUI failed to start within ${MAX_WAIT} seconds"
        exit 1
    fi
done
echo "ComfyUI is ready (waited ${WAITED}s)"

echo "Starting RunPod handler..."
exec python /handler.py
