# ROC_calc
MATLAB function to calculation of corrected ROI data using ROC data based on NCORR saves

## Idea
Function based on B.Pan et al. generalized compensation method[1]. Is just a MATLAB implementation for use in connection with [J.Blaber et al. Ncorr software](https://github.com/justinblaber/ncorr_2D_matlab)[2].

## Usage
```
correct_dic('*absolute path to ncorr save*')
```
Check prerequisites and warnings before use!

## Other
Code is *work in progress*, built during MS thesis done in [WUT](https://www.pw.edu.pl/engpw) by J.Kowalczyk and A.£abeñska.


***
[1]: [B.Pan et al. *High-accuracy 2D digital image correlation measurements using low-cost imaging lenses: implementation of a generalized compensation method*](http://iopscience.iop.org/article/10.1088/0957-0233/25/2/025001/meta)
[2]: [J.Blaber et al. *Ncorr: Open-Source 2D Digital Image Correlation Matlab Software.*](http://www.ncorr.com/download/publications/blaberncorr.pdf)