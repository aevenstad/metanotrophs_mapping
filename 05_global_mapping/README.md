# Plotting methanotroph blast hits 

## Files:
* `plot_maps.Rmd` R script to plot hits from blast results. Input is table of all blast hits with metadata, output is maps with hits for:
   * `unique_hits` maps for each species based on reads with only unique hits
   * `multiple_hits` maps for each species based on reads with multiple hits
   * `environment` maps for each environmental category based on hits for all species
