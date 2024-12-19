# Blast search against 16S methanotrophs

## Files:
* `blastn.sh` batch script to run blastn against methanotroph 16S reference database
* `concat_blast_results.sh` bash script to concatenate blast results into one table
* `methanotrophs_all_hits.blastout.gz` compressed table of all hits from blast results
* `parse_blast_output.Rmd` R script to parse blast results and add metadata. Removes reads with hits to "outgroup" species *Methylocapsa acidiphila* and *Methylosinus trichosporium*.
* `unique_hits_metadata.tsv.gz` Table of hits where each read only had one unique hit
* `multiple_hits_metadata.tsv.gz` Table of hits where each read have multiple hits
* `all_hits_metadata.tsv.gz` Table of all hits
* `upset_plot_for_multiple_hits.png` Upset plot that shows overlap for reads with multiple hits
* `upset_plot_outgroup_hits.png` Upset plot that shows overlap for reads with hits against "outgroup"
* `16S_sequences/` Directory containing 16S reference sequences and blast databases
