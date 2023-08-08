# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 01

**Note**: If internet connection is slow, we can also distribute the example data via an USB stick (ask your instructor ;) ). 

**General**: We will usually start with an "Hands-on" part that will guide you through some of the content from the lectures. Then, there is an "Excercise" part with more open questions. Lastly, there might be "Bonus" questions that require some additional knowledge and research. If you can not make it to the "Bonus", dont worry. The "Hands-on" and "Excercise" parts are most important and will be discussed the next day.

**Example data**: We will work with three different example data sets to showcase different usecases. 

1) To match the _Salmonella_ Illumina data that you already analyzed, you will find corresponding nanopore data on your machines. You can analyze all files or pick one. Note that this nanopore sequencing data is already a few years old. It is also available from the European Nucleotide Archive (ENA, project ID https://www.ebi.ac.uk/ena/browser/view/PRJNA887350)
2) Besides, we will use a public available _E. coli_ nanopore sample from [ENA](https://www.ebi.ac.uk/ena/browser/view/SRR12012232). 
3) Our last example data set was recently sequenced with up-to-date nanopore chemistry (R10.4.1) and includes also raw signal FAST5 data.  

:bulb: Think about a good and descriptive folder and file structure when working on the data!

## Hands-on

### Install and use analysis tools

* **Note**: Bioinformatics tools are regulary updated and input parameters might change (use `--help` or `-h` to see the manual for a tool!)
* Install most of them into our environment
    * we will already install many tools that we will use over the next days!

```bash
# in activated 'workshop' enviroment!
conda create -n workshop # if not already created for you! 
conda activate workshop
conda install fastqc nanoplot filtlong flye bandage minimap2 tablet racon samtools igv
# test
NanoPlot --help
flye --version
```

__Reminder: You can also install specific versions of a tool!__
* important for full reproducibility
* e.g. `conda install flye==2.9.0`
* per default, `conda` will try to install the newest tool version based on your configured channels and system architecture and dependencies to other tools

### Create a folder for the hands-on work

Below are just example paths, you can also adjust them and use other folder names! Assuming you are on a Linux system on a local machine (lpatop, workstation):

```bash
# Switch to a path on your system where you want to store your data and results
cd /scratch/$USER
# Create new folder
mkdir nanopore-workshop
cd nanopore-workshop
```

### Get some example long-read data 

Get some example data. For example, find some public Nanopore read data for _E. coli_ on  [ENA](https://www.ebi.ac.uk/ena/browser/view/SRR12012232).

```bash
wget "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/032/SRR12012232/SRR12012232_1.fastq.gz"
ls -lah SRR12012232_1.fastq.gz
# You just downloaded 397MB of compressed Nanopore raw reads
# Let's place this file in a new folder to keep a clean folder structure
# Are you still in your workshop folder that you just created? 
pwd
# If so, make a new folder and move/rename the downloaded file:
mkdir input-data
mv SRR12012232_1.fastq.gz input-data/eco.nanopore.fastq.gz
# double-check that everything is in place:
ls -lah input data/
# all good? Let's move on to QC!
```

### Quality control (NanoPlot)

```bash
NanoPlot -t 4 --fastq input-data/eco.nanopore.fastq.gz --title "Raw reads" \
    --color darkslategrey --N50 --plots hex --loglength -f png -o nanoplot/raw 
```
[Publication](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/bty149/4934939) | [Code](https://github.com/wdecoster/NanoPlot)

**Note**: The `\` at the end of a line is only for convenience to write a long command into several lines. It tells the command-line that all lines still belong together although they are separated by "enter" keys. However, if you type all of the command, i.e., paths etc, in one line do not copy/type the backslash at the end of the lines.

### Read filtering (Filtlong)

```bash
# we use quite strict parameters here to reduce the sample size and be faster with the assembly. ATTENTION: for your "real" samples other parameters might be better
filtlong --min_length 5000 --keep_percent 90 \
    --target_bases 500000000 input-data/eco.nanopore.fastq.gz > eco-filtered.fastq

# Check the quality again:
NanoPlot -t 4 --fastq eco-filtered.fastq --title "Filtered reads" \
    --color darkslategrey --N50 --plots hex --loglength -f png -o nanoplot/clean 
```
[Code](https://github.com/rrwick/Filtlong)


## Excercise

1) Investigate the content of the FASTQ file you downloaded: `input-data/eco.nanopore.fastq.gz`. What are the first four lines telling you? What do you need to do to make the content of the file "human readable"? 
2) Try `FastQC` on the _E. coli_ example FASTQ. Inspect the output. 
2) Now, use the example data for _Salmonella_ on your system; for the same samples you analyzed short-read Illumina data. Pick one of the _Salmonella_ nanopore FASTQ files. Create a decent folder structure to work with the data. Check the quality. Is read length filtering necessary? If so, do a read length filtering and compare the results. How long are the reads? Do you see any problems? Also try `fastqc` with the appropriate long-read parameter on your sample. What is the GC content? Does it match the expected GC content of _Salmonella_?

## Bonus 1

1) Download another data set: 
```bash
wget --no-check-certificate https://osf.io/jcsfb/download -O 2023-08-nanopore-workshop-example-bacteria.zip
```
(or copy it from an USB stick). 

Make a new subfolder in `nanopore-workshop` (or however you named your workshop directory) and place the downloaded `zip` archive here. Unzip the archive you just downloaded. Inspect the content. There is a MinKNOW summary report HTML file. Open it and inspect it. What can you tell about the nanopore sequencing run? Did it work well? 

2) Investigate the quality using `NanoPlot` and, if you think it's necessary, lenght-filter the FASTQ file. 
3) Use `PycoQC` to generate qc plots for the data set. Install `PycoQC` via Conda or use an available environment. In difference to `NanoPlot`, `PycoQC` needs as input a file called `sequencing_summary.txt` or similar. This is provided after the basecalling alongside with the FASTQ files. (_Note that the `sequencing_summary.txt` was downsampled for the purpose of this workshop_)

**Note on installing `PycoQC`**: On my system it was a pain to install `PycoQC`. I finally managed using mamba:

```bash
mamba create -n pycoqc pycoqc
```

If that doesn't work you might need to:

* creating a new conda environment and installing `mamba` and Python version 3.7 into it
* activating the new environment
* then installing `PycoQC` and explicitly defining the newest version 2.5.2 (as of 2023-08-07)

Older versions might not work correctly with the input FAST5 data! Maybe you have better luck in installing a newer version of `PycoQC` w/o the hussle... 

## Bonus 2 (and a little detour into containers)

Do basecalling by your own. 

**Note that this can be quite tricky and involves deeper Linux knowledge. Usually, you will be fine with the FASTQ and the already basecalled data that comes out of MinKNOW.**

This might not work well on all systems. A good internet connection is needed as well as some basic knowledge in Docker container usage. Also, good hardware and in the best case a GPU are recommended. 

Another nice overview (even though might be slightly outdated) is provided here: [Basecalling with Guppy](https://timkahlke.github.io/LongRead_tutorials/BS_G.html).

1) You can also find raw signal FAST5 data in the downloaded folder from _Bonus 1)_. Re-basecall the signal data to generate a FASTQ output with `guppy`. Chose an appropriate basecalling model (check for details in the MinKNOW report). Unfortunately, `guppy` can not be installed via Conda and is only provided via the ONT community which needs an account. However, the tool can be installed in a so-called Docker container and then run. If you never used [Docker](https://www.docker.com/products/docker-desktop/), here are some [introductory slides](content/container-wms.pdf). A few other good resources:

* [The dark secret about containers in Bioinformatics](https://www.happykhan.com/posts/dark-secret-about-containers/)
* [Container Introduction Training](https://github.com/sib-swiss/containers-introduction-training)

```bash
# Assuming that you have Docker installed and configured
# Get a container image with guppy
docker pull nanozoo/guppy_gpu:6.4.6-1--2c17584

# Navigate to the folder where you have your raw FAST5 data located, e.g. in a folder called 'fast5'. 
# Then start an interactive session from the container and mount the folder you are currently in *into* the container. 
# Otherwise your local files would not be visible from inside of the container.
docker run --rm -it -w $PWD -v $PWD:$PWD nanozoo/guppy_gpu:6.4.6-1--2c17584 /bin/bash

# list the available flowcell and library kits, so you can pick an appropriate basecalling model
guppy_basecaller --print_workflows

# run basecalling, here we're using as an example a model for R10.4.1 flow cell, 
# run with 260 bp/s translocation speed (which was discontinued in summer 2023, now 400 bp/s is default) 
# and the super-acc SUP model
guppy_basecaller –i ./fast5 –s ./guppy_out –c dna_r10.4.1_e8.2_260bps_sup.cfg \
    --num_callers 48 --cpu_threads_per_caller 1

# Attention! This will take ages even on a small FAST5 like in this example. You can also cancel that with "ctrl C". 
# In this example, I ran on 48 cores (num_callers) and for the small example FAST5 this took 13 h for 40% of the reads basecalled.
# You should really run basecalling on a GPU, if possible.  

# Here is an example command using a GPU and some additional qc parameters. 
guppy_basecaller -i ./fast5 -s ./guppy_out_gpu -c dna_r10.4.1_e8.2_260bps_sup.cfg \
    -x auto -r --trim_strategy dna -q 0 --disable_pings

# On the RKI High-Performance Cluster, this command took 2 minutes for basecalling the example data. 
```

**Note**: An alternative to Docker is Singularity. The commands are slightly different then. However, on some systems (e.g. a High-performance cluster) it is not possible to use Docker due to permission settings and then Singularity is an option. Luckily, Docker containers can be easily (and automatically) converted into Singularity.
