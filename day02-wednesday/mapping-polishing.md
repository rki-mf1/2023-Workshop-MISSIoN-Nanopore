# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 02

## Long-read mapping, polishing, and variant calling

### Mapping (minimap2)
```bash
minimap2 -ax map-ont assembly-long.fasta clean_reads.fq > mapping.sam
```
[Publication](https://doi.org/10.1093/bioinformatics/bty191) | [Code](https://github.com/lh3/minimap2)

Check the [SAM format specification](https://samtools.github.io/hts-specs/SAMv1.pdf).

### Visualization of mapping (IGV)

```bash
samtools view -bS mapping.sam | samtools sort -@ 8 > mapping.sorted.bam  
samtools index mapping.sorted.bam

# start IGV browser
igv &
```

### Visualization of mapping (Tablet)

```bash
# open the GUI
tablet &

# load mapping file as 'primary assembly'
->  mapping.sam

# load assembly file as 'Reference/consensus file'
->  assembly-long.fasta
```
[Publication](http://dx.doi.org/10.1093/bib/bbs012) | [Code](https://ics.hutton.ac.uk/tablet/)

__An alterantive nice way to visualize such a mapping is given by Geneious! Or IGV (Integrative Genomics Viewer)__

### Assembly polishing (Racon)

```bash
# run racon
racon -t 4 clean_reads.fq mapping.sam assembly-long.fasta > consensus-long.fasta

# map to new consensus
minimap2 -ax map-ont consensus-long.fasta clean_reads.fq > consensus_mapping.sam

# now look at it in tablet again
```
[Publication](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5411768/) | [Code](https://github.com/isovic/racon)

* a common procedure is 2x racon polishing followed by 1x Medaka (see below)


### Assembly polishing and final consensus (Medaka)

* Make a new environment for `medaka` 
    * `medaka` might have many dependencies that conflict 
* an alternative to `conda` is `mamba`
    * `mamba` can be much faster in solving your environment, e.g. here for the tool `medaka`
    * thus, let us install `mamba` via `conda` and then install `medaka`

```bash
conda create -n medaka mamba python=3.8
conda activate medaka
mamba install -c bioconda medaka
```

```bash
# Run Medaka
# ATTENTION: it is always good to assign an appropriate Medaka model based on 
# the performed basecalling! Here, we dont do that for illustration 
# (and because the RKI HPC is restricted and can not download the model when first used ...)
medaka_consensus -i clean_reads.fq -d consensus-long.fasta -o medaka -t 4

# Exercise: look at it in tablet
# Hint: first need a mapping to the new consensus
```
[Code](https://github.com/nanoporetech/medaka)
