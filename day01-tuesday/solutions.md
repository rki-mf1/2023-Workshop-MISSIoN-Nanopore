## Excercise

1)

```bash
zcat input-data/eco.nanopore.fastq.gz | head -n 
```

2)

```bash
fastqc --outdir eco-fastqc input-data/eco.nanopore.fastq.gz 
```

3)

```bash
# TODO
```

## Bonus 1

1)

```bash
unzip 2023-08-nanopore-workshop-example-bacteria.zip
mv 2023-08-nanopore-workshop-example-bacteria bacteria
```

2)

```bash
NanoPlot -t 4 --fastq bacteria/fastq/FAU91295_pass_barcode08_690050ad_3ed9c4ae_0.fastq.gz --title "Raw reads" \
    --color darkslategrey --N50 --legacy hex --loglength -f png -o bacteria/nanoplot/raw
```

3)

```bash
conda activate envs/pycoqc
pycoQC -f bacteria/sequencing_summary_small.txt -o bacteria/pycoQC_output.html
```

## Bonus 2 (and a little detour into containers)
