## 📄 Paper

This repository provides the official implementation for the following paper:

> **SurgIPC: a Convex Image Perspective Correction Method to Boost Surgical Keypoint Matching**  
> *Rasoul Sharifian, Adrien Bartoli*  
> Published in *International Journal of Computer Assisted Radiology and Surgery (IJCARS), 2025*  

📄 [Read the Paper](https://encov.ip.uca.fr/publications/pubfiles/2025_Sharifian_etal_IJCARS_flattening.pdf)  
🎥 [Presentation Video (optional)](https://link-to-video.com)

![Teaser](images/teaser.png)  
*SurgIPC mitigates perspective distortion and significantly improves keypoint correspondences.  
In this example, adding SurgIPC to SuperPoint–SuperGlue results in a 66% increase in correct matches, validated using camera ground truth.*

---

## 🧠 Overview

Keypoint detection and matching is a fundamental component of surgical image analysis. However, existing methods lack perspective invariance and their performance degrades with increasing surgical camera motion. A common workaround is to warp the image prior to keypoint detection. Unfortunately, existing warping methods are unsuitable for surgical settings, as they rely on assumptions such as scene planarity that do not hold in practice.

We introduce **Surgical Image Perspective Correction (SurgIPC)**, a convex linear least-squares (LLS) approach that overcomes these limitations. Given a depth map, SurgIPC warps the image to correct for perspective distortion. The method builds upon **conformal flattening theory**, aiming to preserve angles measured in the depth map after warping, while also minimizing the adverse effects of image resampling.

---

## 🗂️ Repository Structure

```bash
SurgIPC/
├── 1_DataPreparation/        # Input data setup
├── 2_DataPreprocessing/      # Mask generation and preprocessing
├── 3_Flattening/             # Perspective flattening module
├── 4_Warping/                # Image warping procedures
├── 5_Evaluation/             # Keypoint matching and evaluation scripts
├── images/                   # Sample input/output visualizations
