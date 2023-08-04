# 2023 Workshop MISSIoN Nanopore Bioinformatics - Day 02

## Hands-on

For the following tasks, you can use Nanopore FASTQ data of _Salmonella_ from the European Nucleotide Archive (ENA, project ID https://www.ebi.ac.uk/ena/browser/view/PRJNA887350). The Nanopore data corresponds to the Illumina samples you already worked on. There are three Nanopore samples, you can work on all of them or pick one! The data is a bit older, from 2019 and was sequenced on a MinION flow cell (FLO-MIN106) . Basecalling was done with the `FAST` basecalling model. **You should also find the FASTQ files on your laptops, in case the internet is too slow for downloading.**

* 8640-Nanopore, ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR218/090/SRR21833890/SRR21833890_1.fastq.gz (928 MB file size)
* 9866-12-Nanopore, ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR218/071/SRR21833871/SRR21833871_1.fastq.gz (2.6 GB)
* 8640-41-Nanopore, ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR218/078/SRR21833878/SRR21833878_1.fastq.gz (1.5 GB)

Now, perform quality control on the long reads. How does your data look like? How long are the reads? Do you see any problems? Also try `fastqc` with the appropriate long-read parameter on your sample. What is the GC content? Does it match the expected GC content of _Salmonella_?

Next, filter the long reads via `filtlong`. Choose appropriate parameters. When you run QC again, how does the data compare to the raw data? 

Now we want to assemble the genome. Read the [`flye` paper](https://www.nature.com/articles/s41587-019-0072-8) (**Maybe first start the assembly, then read the paper while it is running**). Install `flye` and run on the filtered reads. Investigate the results via `Bandage`. How good is your assembly? 

Finally, annotate genes in your assembly like learned for Illumina data before (e.g. `Prokka`, `Bakta`, `Abricate` ...). How many genes do you find? Can you compare that to Illumina? Is it better? Worse? 

**Bonus**: Try a different assembly tool, e.g. other long-read assemblers are given and compared here: https://www.frontiersin.org/articles/10.3389/fmicb.2022.796465/full
