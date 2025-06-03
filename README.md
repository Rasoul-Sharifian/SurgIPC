This repository provides the official implementation for the paper:

> **SurgIPC: a Convex Image Perspective Correction Method to Boost Surgical Keypoint Matching**  
> *Rasoul Sharifian, Adrien Bartoli*  
> Published in *International Journal of Computer Assisted Radiology and Surgery (IJCARS), 2025*  


📄 [Read the Paper](https://encov.ip.uca.fr/publications/pubfiles/2025_Sharifian_etal_IJCARS_flattening.pdf)  
🎥 [IPCAI Short Presentation](to be published)
🎥 [IPCAI Long Presentation](to be published)


![Teaser](images/teaser.png)  
*SurgIPC cancels the effect of perspective and boosts the number of correct correspondences. In this example, SurgIPC is added to SuperPoint-SuperGlue and boosts matching by 66\% (correspondences validated using  the camera ground-truth).*


---

## 🧠 Overview
Keypoint detection and matching is a fundamental component of surgical image analysis. However, existing methods lack perspective invariance and their performance degrades with increasing surgical camera motion. A common workaround is to warp the image prior to keypoint detection. Unfortunately, existing warping methods are unsuitable for surgical settings, as they rely on assumptions such as scene planarity that do not hold in practice.

We introduce **Surgical Image Perspective Correction (SurgIPC)**, a convex linear least-squares (LLS) approach that overcomes these limitations. Given a depth map, SurgIPC warps the image to correct for perspective distortion. The method builds upon **conformal flattening theory**, aiming to preserve angles measured in the depth map after warping, while also minimising the adverse effects of image resampling.


---

## 🗂️ Repository Structure

```bash
SurgIPC/
├── 1_DataPreparation/               # required input data
├── 2_DataPreprocessing/              # generating requested masks and grids
├── 3_Flattening/                # LLS
├── 4_Warping/                # warping the images
├── 5_Evaluation/               # Keypoint matching evaluation
├── images/                 # images used in this repo
```
--- 

## 📌 Citation
If you find this work useful, please consider citing:
```bash
@article{sharifian2025surgipc,
  title     = {SurgIPC: a Convex Image Perspective Correction Method to Boost Surgical Keypoint Matching},
  author    = {Sharifian, Rasoul and Bartoli, Adrien},
  journal   = {International Journal of Computer Assisted Radiology and Surgery},
  year      = {2025}
}

