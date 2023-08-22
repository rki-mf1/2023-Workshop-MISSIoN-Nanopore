# Workshop, Linux re-cap

## Short Linux and bash re-cap

* Linux/Bash basics + conda setup ([slides](https://docs.google.com/presentation/d/14xELo7lDbd-FYuy144ZDK1tV_ZBdBYun_COelrKYWps/edit?usp=sharing))
* Another good resource: [Introduction to the UNIX command line](https://ngs-docs.github.io/2021-august-remote-computing/introduction-to-the-unix-command-line.html)
* Cheat sheet for Bash: [github.com/RehanSaeed/Bash-Cheat-Sheet](https://github.com/RehanSaeed/Bash-Cheat-Sheet)

A (very short) cheat sheet:
```bash
# Print your user name
echo $USER
# change directory to your user home directory (all of these are the same)
cd /home/$USER
cd $HOME
cd ~  # <- the shortest version, I like this one
# show content of current directory
ls
# make a new directory called 'myfolder'
mkdir myfolder
# make conda environment and activate it
conda create -n nanoplot
conda activate nanoplot
conda install nanoplot
# run a program
NanoPlot reads.fq.gz ...
```

## (H)PC setup

If you are using your own (Linux) laptop or one provided for the workshops you are good to go. If you are using an RKI Windows laptop, you have to connect to the Linux High-Performance Cluster (HPC). You also need an account that you can request via an IT ticket. 

### HPC access

* Install `MobaXterm` via the RKI Software Kiosk
* Open `MobaXterm`
* Connect to the HPC login node, your instructors will tell you the name
    * Select "Session": "SSH"
    * "Remote host": "provided login node name" 
    * "Username": RKI account name

### HPC usage

* Detailed information on HPC infrastructure and usage can be found in the RKI Confluence, search for:
    * "HPC Aufbau"
    * "HPC Nutzung"
    * "HPC FAQ"
* Opening an interactive Shell
    * On the HPC we have login and compute nodes. We dont want to compute on login nodes.
    * An interactive shell is simply any shell process that you use to type commands, and get back output from those commands. That is, a shell with which you interact. We want to connect to a compute node for the workshop.
    * Open `MobaXterm`` and connect to one of the login nodes (ask instructors)

Opening an interactive shell on the RKI HPC:
```sh
#start an interactive bash session using the default ressources
srun --pty bash -i

#start an interactive bash session using 8 CPUs, 40GB RAM, 30GB HDD
srun --cpus-per-task=8 --mem=40GB --gres=local:30 --pty bash -i

#start an interactive bash session using 10 CPUs, 80GB RAM, 50GB HDD, 1GPU
srun --cpus-per-task=10 --mem=80GB --gres=local:50 --gpus=1 --pty bash -i

#IMPORTANT to free the blocked resources after our work is done close the interactive shell via:
exit
```
Due to competing requests it may take some time until the requested resources can be provided by the system. Therefore, wait patiently until the prompt appears. Reducing requested resources might help as well.


## Install conda (if done already on your machine: skip)

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
