# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 04

## Hands-on

### Assembly statistics

Use `assembly-stats` to check the quality of some of your assemblies produced during the workshop. Which assembly you produced for _Salmonella_ (considering Illumina and Nanopore data) has the best N50? 

[Code & README](https://github.com/sanger-pathogens/assembly-stats)

```sh
assembly-stats assembly.fasta
```

### Assembly comparison

Use `quast` to compare different statistics for selected assemblies. For example, chose the assemblies you produced with Illumina and Nanopore as an input. Investigate the output and reports. Do you agree with `quast` regarding what the "best" assembly is? 

Check the `--help` and chose appropriate parameters to run the tool.

[Code & REAMDE](https://github.com/ablab/quast)

### Investigation of fragmented ORFs via IDEEL

A neat way to do so is using so-called IDEEL plots as [initially proposed by Mick Watson](http://www.opiniomics.org/a-simple-test-for-uncorrected-insertions-and-deletions-indels-in-bacterial-genomes/). Different people implemented this approach, for example [github.com/phiweger/ideel](https://github.com/phiweger/ideel).

Here, we will combine various tasks to get this approach running. 

Lets first install the code from [this repository](https://github.com/phiweger/ideel) and the necessary dependencies via `mamba`. Then, we generate the protein database index, prepare the input genome files and run the workflow. 

```bash
git clone https://github.com/phiweger/ideel.git
cd ideel

conda create -n ideel mamba
conda activate ideel
mamba install snakemake prodigal diamond r-ggplot2 r-readr

# get a reference database of protein sequences
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
# generate an index with diamond
diamond makedb --in uniprot_sprot.fasta.gz -d database_uniprot

# edit the config.json file that was copied from the ideel github repository
# specifying e.g. the path to the Diamond database.
# open the config.json with any texteditor

# The output of the workflow will be written to --directory. 
mkdir ideel-results
# In there, make a directory called "genomes"
mkdir ideel-results/genomes
# put assemblies in there with .fa file extension
cp /scratch/$USER/workshop/*.fasta ideel-results/genomes/
# The workflow wants the files to have .fa instead of .fasta!
rename 's/\.fasta$/.fa/' ideel-results/genomes/*.fasta

# run the workflow
snakemake --configfile config.json --directory ideel-results --cores 4
```

Investigate the final output plots. How fragmented are your ORFs? Run the workflow on an assembly produced with Illumina and Nanopore. How does the fragmentation of your ORFs change when you polish your assembly? 

### Hybrid assembly

When you have both Nanopore and Illumina data available for the same sample it can be worth to assemble the data "together". Commonly used for this task is (**was**) `Unicycler`.

__Exercise__

* make a `mamba` environment and install `Unicycler`
* check out the [`Unicycler` code repository](https://github.com/rrwick/Unicycler)
* .. and the `--help` to learn how to use the tool
* provide short and long reads as input
    * you can decide to use the raw or length-filtered long reads
    * In the section above about Illumina short-read assembly you will find the paths to the Illumina reads
* how does the resulting assembly compare to the short- and long-read-only assemblies?

**Note** that `Unicycler` internally uses `SPAdes` as a first step. That means that the assembly process will start from short reads. This can introduce problems early that can be also not solved at later steps. Because of that, it can be better to start with an initial long-read assembly (e.g. `flye`) and then introduce the short-read data later for polishing (e.g. `polypolish`) instead of using `Unicycler`. 

Remember that you can compare different assemblies via `quast`!

**Nowadays, Nanopore sequencing improved that much that in many cases it does not make sense anymore to run short-read-first assemblies**. Ryan Wick, the original developer of `Unicycler`, `Polypolish`, `Trycycler`, ... wrote some [very good explanations about this](https://github.com/rrwick/Unicycler#2022-update). 

**[Check out his `Trycycler` tool](https://github.com/rrwick/Trycycler/wiki)!**

__Exercise__

* use `Trycycler` to combine the assembly results you have from different runs of the same sample into a _consensus_ long-read assembly





