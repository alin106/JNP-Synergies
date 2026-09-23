# JNP-Synergies
This repository contains the code used to reproduce the main statistical results and Figures 6 and 7 in "Muscle synergy analysis reveals sources of variation in upper extremity motor control after stroke."

Author: Adrian Lin

Last updated: 9/17/2026

## Instructions
Download the full repository and run MainScript.m

### About the data
`data.mat` is a struct that contains data for three tasks (Flexor Synergy, Shoulder-Flexion-to-90, Grasp) of two metrics (CS, N-DIEM)

Fields:
- sim_table: N x N table, where N = number of subjects
- dissim_table: N x N table, this is calculated as the complement of sim_table
- subjs: N x 2 cell array, this lists the impairment groups of every subject. Serves as a key for sim_table and dissim_table.
- within_data and ref_data contain cell arrays of similarity values, along with the subject comparisons that lead to each value. These similarity values are derived from sim_table.

Raw electromyography data is available upon reasonable request

### MainScript.m
This script reproduces Figures 6 and 7. This script uses `data.mat`

### permanova
~/permanova contains `permanova.R`, which is used to run PERMANOVA, associated with Figure 6.
This script uses csv's of the dissimilarity matrices and subject groupings. This data is the csv version of the dissim_table fields contained within `data.mat`.

### artanova
~/artanova contains `artanova.R`, which is used to run ART ANOVA, associated with Figure 7B (contrast analysis).
This script uses csv's of the contrast distributions that are created in `runContrast.m`.

### Other Notes
Please note that the code for DIEM can be found here: https://github.com/ftessari23/DIEM.
    Tessari, F., Yao, K., & Hogan, N. (2024). Surpassing Cosine Similarity for Multidimensional Comparisons: Dimension Insensitive Euclidean Metric (DIEM). ArXiv.org. https://arxiv.org/abs/2407.08623
