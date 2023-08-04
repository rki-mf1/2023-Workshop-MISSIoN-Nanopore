# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 01

## Short Linux and bash re-cap (srry, again)

* Linux/Bash basics + conda setup ([slides](https://docs.google.com/presentation/d/14W8YPnMPd0GUmL6HvzHJTCjrigfbz9z1EUHr2P9-200/edit?usp=sharing))
* Another good resource: [Introduction to the UNIX command line](https://ngs-docs.github.io/2021-august-remote-computing/introduction-to-the-unix-command-line.html)
* small Bash cheat sheet:

```bash
# Print your user name
echo $USER
# change directory to your user home directory
cd /home/$USER
# show content of current directory
ls
# make a new directory called 'myfolder'
mkdir myfolder
# make conda environment and activate it
conda create -n nanoplot
conda activate nanoplot
# run a program
NanoPlot reads.fq.gz ...
```

## Install conda (should be already done, skip)

* Conda is a packaging manager that will help us to install bioinformatics tools and to handle their dependencies automatically
* In the terminal enter:

```bash
# Switch to a directory with enough space
cd /scratch/$USER

# make a new folder called 'workshop'
mkdir workshop

# switch to this folder
cd workshop

# Download conda installer
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 

# Run conda installer
bash Miniconda3-latest-Linux-x86_64.sh
# Use space to scroll down the license agreement
# then type 'yes'
# accept the default install location with ENTER
# when asked whether to initialize Miniconda3 type 'yes'
# ATTENTION: the space in your home directory might be limited (e.g. 10 GB) and per default conda installs tools into ~/.conda/envs
# Thus, take care of your disk space! 

# Now start a new shell or simply reload your current shell via
bash

# You should now be able to create environments, install tools and run them
```

* Set up conda

```bash
# add repository channels for bioconda
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

* Create and activate a new conda environment

```bash
# -n parameter to specify the name
conda create -n workshop

# activate this environment
conda activate workshop

# You should now see (workshop) at the start of each line.
# You switched from the default 'base' environment to the 'workshop' environment.
```

__Hint:__ An often faster and more stable alternative to `conda` is `mamba`. Funningly, `mamba` can be installed via `conda` and then used in the similar way. Just replace `conda` then with `mamba` (like shown in the bioinformatics tool slides, linked below).

Next: [Long-read Nanopore Introduction & Quality Control](nanopore.md)
