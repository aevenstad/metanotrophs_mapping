# Global mapping of methanotrophs
Setting up a pipeline to:
- Download SRA data from ncbi based on search criteria
- Process downloaded fastq files
- Blast against target database (16S rRNA of methanotrophs)
- Map coordinates of hits to assess global distribution

## 1. Get Biosample accessions from NCBI database
### NCBI Biosample search
Search NCBI Biosample database to identify SRA libraries tagged with geographic coordinates. The search pattern used to identify target sequencing archives (SRAs) was:
```
16S[All Fields] AND "biosample sra"[filter] AND "latitude and longitude"[Attribute Name]
```

The criteria for the search were:
- A match for the string "16S" from all search fields in the database
- The resulting biosamples are filtered to only allow samples used by the SRA
- The samples are also filtered to only include samples were the attribute name "latitude and longitude" is filled.

The reuslting list of biosamples were downloaded as full text file and consisted of **313,349** unique samples.

### Further parsing of biosamples
In order to get the resulting biosample information into a more readable format (both human and computer friendly) the resulting text file was transformed into a summary table with a customized R script.  
  
Furthermore, since the field for "latitude and longitude" was sometimes filled but not containing any geographic coordinates the table was further parsed to only contain rows with actual coordinates.

This resulted in **222,264** unique biosamples with geographic coordinates.

In order to exclude samples from sources not relevant for the methanotroph target group a list of keywords was used to remove samples not of interest. 
Mainly, the fields for "Organism", "Isolation source" "environmental medium", "broad scale environmental context" and "local scale environmental context" was used to match keywords.

The "environment" filtering resulted in **113,227** biosamples kept for downloading an further processing.

## 2. Download SRAs from list of biosamples
SRA accessions was extracted from the summary of biosamples and used as input for the nf-core Nextflow pipeline [`fetchngs`](https://nf-co.re/fetchngs/1.12.0/)

Raw fastq files and metadata were downloaded for the SRA accessions. Since the input were SRA sample accessions, for some samples multiple sequencing runs were downloaded.
  
From the **113,227** samples **133,057** sequencing runs were downloaded.


## 3. Process SRA RUN libraries
All downloaded sequencing libraries were processeed with [`taxprofiler`](https://nf-co.re/taxprofiler/1.1.7/) to remove adapter sequence and perform read merging. No actual profiling was performed and the pipeline was only used for the processing and merging of read pairs.










# Links
https://linsalrob.github.io/ComputationalGenomicsManual/Databases/SRA.html
