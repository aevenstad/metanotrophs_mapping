# NCBI search

## Files:
* `biosample_search.txt` search term used to identify samples (biosample) of interest from NCBI.
* `biosample_results.txt.gz` compressed text file with metadata for all biosamples of interest.
* `parse_biosample_results.R` R script to parse `biosample_results.txt` into a data frame contianing only samples with geographic coordinates.
* `biosample_summary_lat_lon.txt.gz` Output data frame from `parse_biosample_results.R`
* `biosample_environmental_category.tsv` data frame with environmental categories for biosamples. Categories was assigned based on other metadata through chatGPT.
* `fix_env_category_and_coordinates.Rmd` script that adds environmental categories to the summary data frame and also fixes format of coordinates.
* `summary_table_final.txt.gz` final summary data frame
