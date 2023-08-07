# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 01

TODO NOTES

* Linux practes (do some commands, create the conda environment). Use a variable name SAMPLE
* Get example data
* Inspect file formats (fast5, fastq), differences to Illumina
* basecall a small dataset? Bonus... using container...
* QC, nanoplot, filtering, some other QC tool? 


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
* e.g. `conda install flye=2.9.0`
* per default, `conda` will try to install the newest tool version based on your configured channels and system architecture and dependencies to other tools

### Create a folder for the hands-on work

Below are just example paths, you can also adjust them and use other folder names! Assuming you are on a Linux system on a local machine (lpatop, workstation):

```bash
# Switch to a path on your system where you want to store your data and results
cd /home/$USER/
# Create new folder
mkdir nanopore-workshop
cd nanopore-workshop
```

### Get some example long-read data 

Get some example data. For example, find some public Nanopore read data for _E. coli_ on  [ENA](https://www.ebi.ac.uk/ena/browser/view/SRR12012232).

```bash
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/032/SRR12012232/SRR12012232_1.fastq.gz
ls -lah SRR12012232_1.fastq.gz
# You just downloaded 397MB of compressed Nanopore raw reads
# Let's place this file in a new folder to keep a clean folder structure
# Are you still in your workshop folder that you just created? 
pwd
# If so, make a new folder and move/rename the downloaded file:
mkdir input-data
mv SRR12012232_1.fastq.gz input-data/eco.nanopore.fastq.gz
```

### Quality control (NanoPlot)

```bash
NanoPlot -t 4 --fastq input-data/eco.nanopore.fastq.gz --title "Raw reads" \
    --color darkslategrey --N50 --plots hex --loglength -f png -o nanoplot/raw 
```
[Publication](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/bty149/4934939) | [Code](https://github.com/wdecoster/NanoPlot)

**Note**: The `\`` at the end of a line is only for convenience to write a long command into several lines. It tells the command-line that all lines still belong together although they are separated by "enter" keys. However, if you type all of the command, i.e., paths etc, in one line do not copy/type the backslash at the end of the lines.

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