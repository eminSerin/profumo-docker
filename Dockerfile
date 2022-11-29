# PROFUMO
# Framework for variational Bayesian inference of modes from fMRI data

# Slightly different than the original Dockerfile, this one uses 
# Ubuntu and the latest version of FSL. 

# Original Repository: 
# https://git.fmrib.ox.ac.uk/profumo/profumo

# Reference: 
# Harrison, Samuel J., et al. "Large-scale probabilistic functional modes from resting state fMRI." NeuroImage 109 (2015): 217-231.s

# docker build -t profumo .
# docker run -it profumo

# Base image
FROM ubuntu:rolling

# Maintainer
LABEL maintainer="Emin Serin <emin.serin@charite.de>"

# Use login shell 
SHELL ["/bin/bash", "-l", "-c"]
ENV FSLDIR=/opt/fsl \
    FSLCONFDIR=/opt/fsl/config \ 
    PROFUMODIR=/opt/profumo \
    PATH=/opt/profumo/C++/:$PATH \
    PATH=/usr/local/bin/miniconda3/bin:/usr/local/bin/miniconda3/condabin:/opt/profumo/C++/:$PATH

# Install dependencies and Symlink python2.7 to python
RUN apt-get update && apt-get install -y \
    bc bzip2 file git make pv wget \
    build-essential libboost-dev libhdf5-dev libopenblas-dev libarmadillo-dev libznz-dev \
    python2.7 python-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -s /usr/bin/python2.7 /usr/bin/python 

# FSL installation
# Download multiple FSL versions to get around with the error in the original Dockerfile
RUN wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
    python fslinstaller.py -d /opt/fsl -V 6.0.6 && \
    rm fslinstaller.py && \
    rm -rf opt/fsl/config && rm -rf opt/fsl/src && \
    wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.3-centos7_64.tar.gz \
    -O FSL.tar.gz && \
    echo "FSL Downloaded!" && \
    tar -xvf FSL.tar.gz fsl && rm FSL.tar.gz && \
    mv fsl/src /opt/fsl/src && mv fsl/config /opt/fsl/config && \
    rm -rf fsl && \
    echo "FSL Installed!"


# PROFUMO installation (Download codes and compile)
RUN git clone --branch=master --recurse-submodules \
    https://git.fmrib.ox.ac.uk/profumo/profumo.git /opt/profumo && \
    cp -r /opt/fsl/src/NewNifti /opt/profumo/C++/Dependencies/ && \
    cd /opt/profumo/C++/Dependencies/NewNifti && \
    make && \
    cd /opt/profumo/C++ \
    && make all -j4 CXXEXTRAS="-fopenmp" LDEXTRAS="-fopenmp -lopenblas"

# Set up Python environment
RUN cd $HOME/ && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/bin/miniconda3 && \
    conda clean -a -y && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    cd /opt/profumo/Python && \
    conda env create -f environment.yml && \
    conda clean -a -y && \
    source activate profumo










