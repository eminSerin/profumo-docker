# profumo-docker

This is a Dockerfile to set up a ready-to-use environment to perform 
PRObabilistic FUnctional MOdes (PROFUMO, Harrison et al., 2015) analysis. 
The Docker environment is based on Ubuntu Rolling, and includes the 
FSL version 6.0.6 as well as the latest versions of PROFUMO. 

## Installation
Following cloning this GitHub repository, you can build the Docker image
by running the following command:

    docker build -t profumo .

The building will take 20-30 mins. depending on the speed of your internet
and computer. Once the building is finished, you can run the Docker image
by running the following command:

    docker run -it profumo

## Main Repository
The main repository is available at [PROFUMO](https://git.fmrib.ox.ac.uk/profumo/profumo). 

## References
1) Harrison, Samuel J., et al. "Large-scale probabilistic functional modes from resting state fMRI." NeuroImage 109 (2015): 217-231.

2) Harrison, Samuel J., et al. "Modelling subject variability in the spatial and temporal characteristics of functional modes." NeuroImage 222 (2020): 117226.

