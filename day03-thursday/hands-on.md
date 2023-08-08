# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 03

## Hands-on

### Polishing

Polish the _E. coli_ assembly you produced yesterday with `flye`. Use the filtered long-read data. Do this in two steps: using `racon` followed by `medaka`. This will also involve mapping again the long reads to your calculated assemblies! 

#### Mapping (minimap2)

**You already did this mapping yesterday to look at the SAM/BAM file in IGV and/or tablet! If you still have the files, you dont need to redo the following steps!**

```bash
# map
minimap2 -ax map-ont flye_output/assembly.fasta eco-filtered.fastq > eco-mapping.sam
# first, we need to convert the SAM file into a sorted BAM file to load it subsequently in IGV
samtools view -bS eco-mapping.sam | samtools sort -@ 4 > eco-mapping.sorted.bam  
samtools index eco-mapping.sorted.bam
```

#### Assembly polishing (Racon)

```bash
# run racon, as input you need the reads, the mapping file, and the assembly you want to polish
racon -t 4 eco-filtered.fastq eco-mapping.sam flye_output/assembly.fasta > eco-consensus-racon.fasta

# map to new consensus
minimap2 -ax map-ont eco-consensus-racon eco-filtered.fastq > eco-consensus-mapping.sam

# now look at it in tablet or IGV again
```
[Publication](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5411768/) | [Code](https://github.com/isovic/racon)

* a common practice is 2x `racon` polishing followed by 1x `Medaka` (see below)
* for practice, 1x `racon` is fine
* with the newest R10 chemistry and recent basecalling models, it seems that `racon` is also not necessary anymore and people switch to only polish via `Medaka`

### Assembly polishing and final consensus (Medaka)

`Medaka` is not in your current `workshop` environment because it was conflicting with the other tools. That's why we need a separate Conda environment for `Medaka`:

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
# the performed basecalling! Here, we dont do that for illustration and because for the E. coli 
# data the used basecalling model ist not directly provided. You can do that better in the following Exercise! :) 
# If you are on the RKI HPC: due to restrictions it might be even difficult to run other Medaka models because 
# they need to be downloaded first. 
medaka_consensus -i eco-filtered.fastq -d eco-consensus-racon.fasta -o eco-medaka -t 4

# Exercise: look at it in tablet or IGV
# Hint: first need a mapping to the new consensus again to generate the SAM/BAM file!
```
[Code](https://github.com/nanoporetech/medaka)



## Exercise

Now, use again the _Salmonella_ data. You already calculated the assembly with `flye`. Remember, basecalling was done with the `FAST` basecalling model and with `Guppy` in 2019. 

Now polish the genome using `racon` and `medaka`. Try to chose an approriate `medaka` model. You can use the following command to list `medaka` models:

```bash
medaka tools list_models | grep -v Default
```

Did the per-base quality improve? Annotate genes again (e.g. using `Bakta`)! How many genes (CDS) do you find now in comparison to the _de novo_ assembly without any polishing? 

Now, we want to call variants for your Nanopore sample in comparison to a reference sequence (**not** using the _de novo_ assembly!).

* To do so, download a reference genome for _Salmonella_ from [NCBI](https://www.ncbi.nlm.nih.gov/genome/)
* Map the Nanopore reads of your _Salmonella_ sample against the reference genome
* use `Medaka` now for variant calling and not directly for consensus calculation, here are some hints (that you can/must adjust! Check also https://github.com/nanoporetech/medaka):

```bash
# Call variants with Medaka
#__Important__: Always use the matching `medaka` model based on how the `guppy` basecalling was done! You can check which `medaka` models are available via:
medaka tools list_models | grep -v Default

# first, use the `medaka consensus` command similar to before
# for the Salmonelle ONT data from 2019 MinION device was used and the FAST model!
medaka consensus <SORTED-BAM-FILE> --model <MODEL> --threads 4 output.consensus.hdf

# actually call the variants
medaka snp <REFERENCE-GENOME> output.consensus.hdf medaka.snp.vcf --verbose
```

* inspect the resulting [VCF file](https://www.ebi.ac.uk/training/online/courses/human-genetic-variation-introduction/variant-identification-and-analysis/understanding-vcf-format/), read about the format and its structure
* how many variants do you find? 
* can you find the called variants that you see in the VCF file also in a genome browser, when you load the mapping file? Do you see any differences/problems?

## Bonus 1

Try different allele frequency cutoffs with `Medaka` for the variant calling: `--threshold 0.1` How do the results change?
