# metagenomic_mapping
Setting up a pipeline to:
- Download SRA data from ncbi based on search criteria
- Process downloaded fastq files
- Blast against target database
- Map coordinates of hits

## 1. Download SRA libraries
### NCBI Biosample search
Search NCBI Biosample database to identify SRA libraries tagged with geographic coordinates.  
For this specific search the pattern:
```
(16S[All Fields] AND soil[All Fields]) AND "biosample sra"[filter] AND "latitude and longitude"[Attribute Name]
```
was used.

Results were downloaded as full XML file and parsed further in R.

### Create summary table from XML



