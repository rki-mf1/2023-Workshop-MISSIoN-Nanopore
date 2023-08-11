## Exercise

```bash
wget "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR218/090/SRR21833890/SRR21833890_1.fastq.gz" -O input-data/sal1.fastq.gz
# Length filter reads
filtlong --min_length 5000 --keep_percent 90 \
    --target_bases 500000000 input-data/sal1.fastq.gz > sal1-filtered.fastq
# Assemble
flye --nano-raw sal1-filtered.fastq -o flye-output-sal1 -t 4 --meta --genome-size 5M
# TODO: annotate genes
```

## Bonus 1

## Bonus 2

```bash
unzip 2023-08-nanopore-workshop-example-bacteria.zip
# Length filter reads
filtlong --min_length 5000 --keep_percent 90 \
    --target_bases 500000000 2023-08-nanopore-workshop-example-bacteria/fastq/FAU91295_pass_barcode08_690050ad_3ed9c4ae_0.fastq.gz  > bacteria-filtered.fastq
flye --nano-raw bacteria-filtered.fastq -o flye-output-bacteria -t 4 --meta --genome-size 5M
```

## Bonus 3

Download the E. coli reference and annotations:

```bash
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz" -O ecoli-reference.fna.gz
wget "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz" -O ecoli-annotation.gff.gz
gunzip ecoli-reference.fna.gz
gunzip ecoli-annotation.gff.gz
```

Map our reads to the reference we just downloaded:

```bash
minimap2 -ax map-ont ecoli-reference.fna eco-filtered.fastq > eco-mapping-ref.sam
samtools view -bS eco-mapping-ref.sam | samtools sort -@ 4 > eco-mapping-ref.sorted.bam  
samtools index eco-mapping-ref.sorted.bam
igv &
```
