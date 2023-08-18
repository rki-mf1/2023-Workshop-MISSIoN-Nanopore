## Exercise

```bash
## Call variants with Medaka
##__Important__: Always use the matching `medaka` model based on how the `guppy` basecalling was done! You can check which `medaka` models are available via:
#medaka tools list_models | grep -v Default
#
## first, use the `medaka consensus` command similar to before
## for the Salmonelle ONT data from 2019 MinION device was used and the FAST model!
#medaka consensus <SORTED-BAM-FILE> --model <MODEL> --threads 4 output.consensus.hdf
#
## actually call the variants
#medaka snp <REFERENCE-GENOME> output.consensus.hdf medaka.snp.vcf --verbose
```

* inspect the resulting [VCF file](https://www.ebi.ac.uk/training/online/courses/human-genetic-variation-introduction/variant-identification-and-analysis/understanding-vcf-format/), read about the format and its structure
* how many variants do you find? 
* can you find the called variants that you see in the VCF file also in a genome browser, when you load the mapping file? Do you see any differences/problems?

## Bonus 1

## Bonus 2

```bash
```
