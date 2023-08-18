## Excercise

1)

```bash
zcat input-data/eco.nanopore.fastq.gz | head -n 4
```

2)

```bash
conda activate envs/workshop
mkdir eco-fastqc
fastqc --memory 1024 --outdir eco-fastqc input-data/eco.nanopore.fastq.gz
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
conda activate envs/workshop
NanoPlot -t 4 --fastq bacteria/fastq/*.fastq.gz --title "Raw reads" \
    --color darkslategrey --N50 --loglength -f png -o bacteria/nanoplot/raw
```

3)

```bash
conda activate envs/pycoqc
pycoQC -f bacteria/sequencing_summary.txt.gz -o bacteria/pycoQC_output.html
```

## Bonus 2 (and a little detour into containers)
