# Introduction

This repository presents the simulation code of paper T-SP-26702-2020, which is currently under review. The simulation is based on Matlab code.

# Algorithm with Fusion Center

## Algorithm Design

The simulation begins with a data generation script named `generate_gaussian_data.m`.
This script generates a matrix that stores the observations of all sensors. The size of the matrix is `package_size` $\times$ `length`. The data is drawn from the Gaussian distribution whose parameter is in the paper. The matrix is stored as

`'gaussain_H0_<index>_<package_size>_<length>.mat`

or

`'gaussain_H1_<index>_<package_size>_<length>.mat`,

where `package_size` means the number of sample tracks, `length` means the length(time steps) in a sample track, and `index` means the index number in a series of data matrix (The data is stored in several matrices for faster processing).

For the case with flip-attack, part of the samples is generated from the opposite distribution, as demonstrated in the paper. For example, if 10 sensors' background hypothesis are:

sensors $1-2$: $H_1$, sensors $3-9$: $H_0$, sensors $10$: $H_1$,

the data file is named as

`gaussain_attack_2H1_7H0_1H1_<package_size>_<length>.mat`.

## Algorithm Running

1. Set parameter and generate data using `generate_gaussian_data.m`.

2. Calculate error probability and delay using `VSPRT.m` which calls `VSPRT_erro.m` and `VSPRT_delay.m` and records values for plotting.

Other Fusion Center algorithms are similar.

# Fully Distributed Algorithm

## Algorithm Design

After the same procedure of data generation as in the last section, the sample is processed through `sample_resequence.m` to simulate the delay in a fully-distributed network. In this script, the samples are shifted along the time index. The number of steps shifted is the path length to the decider sensor from every senor.

In the real sensor network, this delay should be at the process of voting transmission. However, in order to reuse the previous code in Fusion Center formulation, we produce the samples with corresponding delay, which is the same as the case where the delay is at the process of voting transmission.

After the procedure which we call "sample resequence", the corresponding cumulative log-likelihood ratio is calculated, and the error probability and delay are recorded for a specific threshold. The data are recorded for figure plotting.

## Algorithm Running
