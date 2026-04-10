# Image Model Deployer

Unholy Desire Mix - Sinister Aesthetic v8 による画像生成API（RunPod Serverless）

## 概要

テキストプロンプトから画像を生成するAPI。ComfyUIバックエンドでUnholy Desire Mix - Sinister Aesthetic v8（SDXLベース）モデルを使用し、RunPod Serverless上で動作する。

## 機能

- テキストから画像生成
- 自動品質タグ付与（score_9, score_8_up, score_7_up）
- LoRA対応（URL指定で動的ロード、最大10個チェーン）
- JPEG出力（品質指定可能）

## API パラメータ

| パラメータ | 型 | デフォルト | 説明 |
|-----------|-----|-----------|------|
| `prompt` | string | (必須) | 生成プロンプト |
| `negative_prompt` | string | (auto) | ネガティブプロンプト |
| `width` | int | 1024 | 画像幅（8の倍数に自動調整） |
| `height` | int | 1024 | 画像高さ（8の倍数に自動調整） |
| `steps` | int | 20 | 推論ステップ数 |
| `seed` | int | 42 | ランダムシード |
| `cfg` | float | 2.5 | CFGスケール |
| `quality` | int | 90 | JPEG品質 (1-100) |
| `no_quality_tags` | bool | false | 品質タグ自動付与を無効化 |
| `loras` | array | - | LoRA配列 `[{"url": "https://...", "strength": 0.8}]` |

## ビルド

```bash
docker build --build-arg CIVITAI_API_TOKEN=your-token -t image-model-deployer .
```

## 構成

| コンポーネント | 詳細 |
|--------------|------|
| 生成モデル | Unholy Desire Mix - Sinister Aesthetic v8 (SDXL, 6.9GB, Civitai (要トークン)) |
| CLIP Skip | 2 |
| サンプラー | Euler Ancestral (Normal) |
| バックエンド | ComfyUI |
| GPU | NVIDIA 8GB+ |
| 出力形式 | JPEG (Base64) |

## 他モデルブランチ

各ブランチはmainから1コミット分の差分で、モデル固有の設定のみ変更しています。

| ブランチ | モデル | ソース |
|---------|--------|--------|
| `main` / `IllustriousXl2.0` | Illustrious XL v2.0 | HuggingFace |
| `PonyDiffusionV6` | Pony Diffusion V6 XL | HuggingFace |
| `AnimagineXl4.0` | Animagine XL 4.0 | HuggingFace |
| `AutismMixPony` | AutismMix Pony | HuggingFace |
| `CyberRealisticPony` | CyberRealistic Pony v16.0 | HuggingFace |
| `halcyonSDXL` | Halcyon SDXL v1.7 | HuggingFace |
| `MomoiroPony1.5` | Momoiro Pony v1.5 | HuggingFace |
| `NoobAiXl` | NoobAI XL v1.1 | HuggingFace |
| `novaXl` | Nova 3DCG XL Illustrious v3.0 | HuggingFace |
| `StableDiffusionXL` | Stable Diffusion XL Base 1.0 | HuggingFace |
| `RealisticFreedom` | Realistic Freedom Omega | Civitai (要トークン) |
| `PerfectDeliberate` | PerfectDeliberate v9.0 | Civitai (要トークン) |
| `UnholyDesireMix-SinisterAestheticV8` | Unholy Desire Mix v8 | Civitai (要トークン) |
| `WAI-Illustrious-SDXL` | WAI-illustrious-SDXL v16.0 | Civitai (要トークン) |

Civitaiモデルのビルドには `--build-arg CIVITAI_API_TOKEN=...` が必要です。

## ライセンス

GPL-3.0 — 詳細は [LICENSE](LICENSE) を参照。
第三者コンポーネントのライセンスは [NOTICE](NOTICE) を参照。
