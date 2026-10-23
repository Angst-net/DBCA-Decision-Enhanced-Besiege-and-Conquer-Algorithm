# 🏳️‍🌈 DBCA

This is the official code of the paper [DBCA: A cost-benefit decision-enhanced Besiege and Conquer algorithm for global optimization](https://www.sciencedirect.com/science/article/abs/pii/S0957417426035128).

The paper is published in Expert Systems with Applications, the link as: https://doi.org/10.1016/j.eswa.2026.134608.


## 📃 Abstract

The Besiege and Conquer Algorithm (BCA) organizes agent soldiers into armies to perform guerrilla-style search. However, its reliance on a single best guidance and greedy selection leads to premature convergence and poor diversity. We propose a Decision-oriented BCA (DBCA), which addresses these issues by adopting a cost–benefit decision framework. Unlike conventional meta-heuristics that accept any fitness-improving move, DBCA jointly evaluates the fitness benefits and movement costs of candidate solutions to determine optimal update positions. Specifically, The three candidate solution generators include: adaptive elite weighting, fitness-feedback step control, and periodic harmonic exploration. Meanwhile, DBCA updates individuals that maximize net profit and simultaneously penalizes overly large jumps that disrupt search continuity. A systematic ablation study with 10 variants verifies the contributions of the four mechanisms. Extensive experiments on 59 CEC benchmark functions demonstrate the effectiveness of DBCA. DBCA achieves the best performance on both CEC2017 and CEC2014 benchmarks and outperforms LSHADE_cnEpSin and JADE, respectively. Under an equal function evaluation budget on CEC2017 100D, DBCA follows FBCA in performance while outperforming LSHADE_cnEpSin. DBCA also achieved excellent performance on six constrained engineering problems, photovoltaic parameter identification, and multi-UAV problems.


## 🌳 Code Strucutre

```matlab
.
├── DBCA.m  % matlab code of FBCA
└── Readme.md
```

## 🧩 Citation

If you find this repository helpful, please consider citing our paper:
Bibtex:

```
@article{GUO2027134608,
author = {Chenxu Guo and Jianhua Jiang and Shuxin Guo and Zhuo Li and Weihua Li},
title = {DBCA: A cost-benefit decision-enhanced Besiege and Conquer algorithm for global optimization},
journal = {Expert Systems with Applications},
volume = {334},
pages = {134608},
year = {2027},
issn = {0957-4174},
doi = {https://doi.org/10.1016/j.eswa.2026.134608},
url = {https://www.sciencedirect.com/science/article/pii/S0957417426035128}
}
```
APA Style:
```
Guo, C., Jiang, J., Guo, S., Li, Z., & Li, W. (2027). DBCA: A cost–benefit decision-enhanced Besiege and Conquer algorithm for global optimization. Expert Systems with Applications, 334, 134608. https://doi.org/10.1016/j.eswa.2026.134608
```
