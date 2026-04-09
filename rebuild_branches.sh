#!/bin/bash
set -e

# Helper: rebuild a model branch from main with 1 commit
# Usage: rebuild_branch <branch> <model_name> <dl_comment> <wget_url> <ckpt_filename> <quality_tags> <neg_prompt> <steps> <cfg> <handler_desc>
rebuild_branch() {
    local branch="$1"
    local model_name="$2"
    local dl_comment="$3"
    local wget_url="$4"
    local ckpt_filename="$5"
    local quality_tags="$6"
    local neg_prompt="$7"
    local steps="$8"
    local cfg="$9"
    local handler_desc="${10}"

    echo "=== Rebuilding $branch ==="
    git checkout main
    git branch -D "$branch" 2>/dev/null || true
    git checkout -b "$branch"

    # Dockerfile
    sed -i '' "s|# Download Illustrious XL v2.0 (~6.9GB, public, ungated)|# $dl_comment|" Dockerfile
    sed -i '' "s|wget -q https://huggingface.co/OnomaAIResearch/Illustrious-XL-v2.0/resolve/main/Illustrious-XL-v2.0.safetensors|wget -q $wget_url|" Dockerfile
    sed -i '' "s|-O /ComfyUI/models/checkpoints/Illustrious-XL-v2.0.safetensors|-O /ComfyUI/models/checkpoints/$ckpt_filename|" Dockerfile

    # entrypoint.sh
    sed -i '' "s|Illustrious-XL-v2.0.safetensors|$ckpt_filename|" entrypoint.sh

    # handler.py
    sed -i '' "s|Illustrious XL v2.0 Image Generation|$handler_desc Image Generation|" handler.py
    sed -i '' "s|\"worst quality, low quality, normal quality, lowres, bad anatomy, \"|\"$neg_prompt\"|" handler.py
    sed -i '' "s|prompt = f\"{prompt}, masterpiece, best quality, absurdres\"|prompt = f\"$quality_tags\"|" handler.py
    sed -i '' "s|steps\", 28)|steps\", $steps)|" handler.py
    sed -i '' "s|cfg\", 6.0)|cfg\", $cfg)|" handler.py

    # model.json
    sed -i '' "s|Illustrious XL v2.0|$model_name|" model.json
    sed -i '' "s|Illustrious-XL-v2.0.safetensors|$ckpt_filename|" model.json
    sed -i '' "s|\"steps\": 28|\"steps\": $steps|" model.json
    sed -i '' "s|\"cfg\": 6.0|\"cfg\": $cfg|" model.json

    git add -A
    git commit -m "feat: switch to $model_name"
    git push --force-with-lease origin "$branch"
    echo "=== $branch done ==="
    echo
}

# AnimagineXl4.0
rebuild_branch "AnimagineXl4.0" \
    "Animagine XL 4.0" \
    "Download Animagine XL 4.0 (~6.9GB, public)" \
    "https://huggingface.co/cagliostrolab/animagine-xl-4.0/resolve/main/animagine-xl-4.0.safetensors" \
    "animagine-xl-4.0.safetensors" \
    '{prompt}, masterpiece, high score, great score, absurdres' \
    'score_1, score_2, score_3, lowres, bad anatomy, bad hands, text, error, ' \
    "25" "5.0" \
    "Animagine XL 4.0"

# AutismMixPony
rebuild_branch "AutismMixPony" \
    "AutismMix Pony" \
    "Download AutismMix Pony (~6.5GB, public)" \
    "https://huggingface.co/AIWorksMD/autismMix_pony/resolve/main/autismmixSDXL_autismmixPony.safetensors" \
    "autismmixSDXL_autismmixPony.safetensors" \
    'score_9, score_8_up, score_7_up, source_anime, {prompt}' \
    'score_1, score_2, score_3, lowres, bad anatomy, bad hands, text, error, ' \
    "25" "7.0" \
    "AutismMix Pony"

# CyberRealisticPony
rebuild_branch "CyberRealisticPony" \
    "CyberRealistic Pony v16.0" \
    "Download CyberRealistic Pony v16.0 (~6.5GB, public)" \
    "https://huggingface.co/cyberdelia/CyberRealisticPony/resolve/main/CyberRealisticPony_V16.0_FP16.safetensors" \
    "CyberRealisticPony_V16.0_FP16.safetensors" \
    'score_9, score_8_up, score_7_up, {prompt}' \
    'worst quality, low quality, normal quality, lowres, bad anatomy, ' \
    "25" "5.0" \
    "CyberRealistic Pony v16.0"

# MomoiroPony1.5
rebuild_branch "MomoiroPony1.5" \
    "Momoiro Pony v1.5" \
    "Download Momoiro Pony v1.5 (~6.5GB, public)" \
    "https://huggingface.co/Drditone/safetensors/resolve/2221d81ba5e636be82ed93b7021339d0b4dce264/momoiropony_v15.safetensors" \
    "momoiro-pony-v15.safetensors" \
    'score_9, score_8_up, score_7_up, {prompt}' \
    'score_1, score_2, score_3, lowres, bad anatomy, bad hands, text, error, ' \
    "25" "7.0" \
    "Momoiro Pony v1.5"

# NoobAiXl
rebuild_branch "NoobAiXl" \
    "NoobAI XL v1.1" \
    "Download NoobAI XL v1.1 (~6.9GB, public)" \
    "https://huggingface.co/Laxhar/noobai-XL-1.1/resolve/main/NoobAI-XL-v1.1.safetensors" \
    "NoobAI-XL-v1.1.safetensors" \
    'score_9, score_8_up, score_7_up, {prompt}' \
    'score_1, score_2, score_3, lowres, bad anatomy, bad hands, text, error, ' \
    "25" "7.0" \
    "NoobAI XL v1.1"

# StableDiffusionXL
rebuild_branch "StableDiffusionXL" \
    "Stable Diffusion XL Base 1.0" \
    "Download Stable Diffusion XL Base 1.0 (~6.9GB, public)" \
    "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors" \
    "sd_xl_base_1.0.safetensors" \
    'score_9, score_8_up, score_7_up, {prompt}' \
    'score_1, score_2, score_3, lowres, bad anatomy, bad hands, text, error, ' \
    "25" "7.0" \
    "Stable Diffusion XL Base 1.0"

# halcyonSDXL
rebuild_branch "halcyonSDXL" \
    "Halcyon SDXL v1.7" \
    "Download Halcyon SDXL v1.7 (~6.9GB, public)" \
    "https://huggingface.co/Rivaldo/halcyonSDXL_v17/resolve/main/halcyonSDXL_v17.safetensors" \
    "halcyonSDXL_v17.safetensors" \
    '{prompt}, masterpiece, best quality, highly detailed, photorealistic' \
    'worst quality, low quality, normal quality, lowres, bad anatomy, ' \
    "25" "7.0" \
    "Halcyon SDXL v1.7"

# novaXl
rebuild_branch "novaXl" \
    "Nova 3DCG XL Illustrious v3.0" \
    "Download Nova 3DCG XL Illustrious v3.0 (~6.9GB, public)" \
    "https://huggingface.co/datasets/John6666/model-mirror-26/resolve/main/nova3DCGXL_illustriousV30.safetensors" \
    "nova3DCGXL_illustriousV30.safetensors" \
    'score_9, score_8_up, score_7_up, {prompt}' \
    'worst quality, low quality, normal quality, lowres, bad anatomy, ' \
    "25" "4.0" \
    "Nova 3DCG XL Illustrious v3.0"

echo "All branches rebuilt!"
git checkout main
