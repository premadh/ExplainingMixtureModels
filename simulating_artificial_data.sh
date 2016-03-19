#!/bin/bash
#
# (c) Prem Raj Adhikari
#     www.premraj.me
#     August, 2015

# Bash script generate 0-1 data from from a mixture of bernoulli distributions

#Download BernouliMix in the home directory 

cd ~

wget -q http://www.cis.hut.fi/jhollmen/BernoulliMix/release/bmix-1.11.tar.gz

# Extract the contents of the gzipped tar file with the commands

gunzip bmix-1.11.tar.gz
tar xvf bmix-1.11.tar

# Move to the folder 

cd bmix-1.11

# Install BernoulliMix Using 

make

# Now  in folder bmix-1.11/bin contains the compiled binary files of bernoulliMix

# Add bmix-1.11/bin to PATH

PATH="/home/$USER/bmix-1.11/bin:$PATH"

#Now initialize the mixture model with 6 components for 15 dimensional data

bmix_init -c 6 -d 15 -a 0.1 -b 0.9 -o initialized_model.model

# Sample 3000 data points from 

bmix_sample -i initialized_model.model -n 3000 > artificial_data.data



