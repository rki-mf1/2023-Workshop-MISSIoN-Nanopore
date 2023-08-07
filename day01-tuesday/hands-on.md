# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 01

TODO NOTES

* Linux practes (do some commands, create the conda environment)
* Get example data
* Inspect file formats (fast5, fastq), differences to Illumina
* basecall a small dataset? Bonus... using container...
* QC, nanoplot, filtering, some other QC tool? 


## Hands-on

### Install and use analysis tools

* Bioinformatics tools overview ([slides](https://docs.google.com/presentation/d/1I3Z2ArbBWAAm3NCVLbldcaByXvVAamyWSe2T-8Q-tDo/edit?usp=sharing))
    * some command are a bit different to the examples here
    * also keep in mind that tools are regulary updated and input parameters can change (use `--help` or `-h` to see the manual for a tool!)
* Install most of them into our environment

```bash
# in activated 'workshop' enviroment!
conda create -n workshop # if not already created
conda activate workshop
conda install nanoplot filtlong flye bandage minimap2 tablet racon samtools igv
# test
NanoPlot --help
flye --version
```

__Reminder: You can also install specific versions of a tool!__
* important for full reproducibility
* e.g. `conda install flye=2.9.0`
* per default, `conda` will try to install the newest tool version based on your configured channels and system architecture and dependencies to other tools

### Get some example long-read data 

We will get some example data and save the path to the read file in a variable called `SAMPLE`. __This is important__! We will use from now on this variable to refer to the read file when we start analyzing it. 

For example, find some public Nanopore read data for _E. coli_ on  [ENA](https://www.ebi.ac.uk/ena/browser/view/SRR12012232).

```bash
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR120/032/SRR12012232/SRR12012232_1.fastq.gz
ls -lah SRR12012232_1.fastq.gz
# You just downloaded 397MB of compressed Nanopore raw reads

SAMPLE=`pwd`/SRR12012232_1.fastq.gz
```

### Quality control (NanoPlot)
```bash
NanoPlot -t 4 --fastq $SAMPLE --title "Raw reads" \
    --color darkslategrey --N50 --plots hex --loglength -f png -o nanoplot/raw 
```
[Publication](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/bty149/4934939) | [Code](https://github.com/wdecoster/NanoPlot)


### Read filtering (Filtlong)
```bash
# we use quite strict parameters here to reduce the sample size and be faster with the assembly. ATTENTION: for your "real" samples other parameters might be better
filtlong --min_length 5000 --keep_percent 90 \
    --target_bases 500000000 $SAMPLE > clean_reads.fq

NanoPlot -t 4 --fastq clean_reads.fq --title "Filtered reads" \
    --color darkslategrey --N50 --plots hex --loglength -f png -o nanoplot/clean 
```
[Code](https://github.com/rrwick/Filtlong)
