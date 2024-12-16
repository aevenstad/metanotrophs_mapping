#!/usr/bin/env Rscript


# Set path for installed libraries
.libPaths(c("/cluster/projects/nn9858k/packages/R"))


# Load the relevant libraries
library(foreach)
library(doParallel)
library(dplyr)

# Set working directory
setwd("/cluster/work/users/andreeve/alex_project/all_envs_dataset/parallel_test")

# Set up parallel backend
cores <- 20  # Use one less core than available to avoid overloading the system
cl <- parallel::makeCluster(cores, setup_strategy = "sequential")
registerDoParallel(cl)

# Ensure all necessary libraries and objects are loaded and exported on each worker
clusterEvalQ(cl, {
  library(stringr)
  library(dplyr)
})

# Read the text file into memory
ncbi_full_text <- readLines("/cluster/work/users/andreeve/alex_project/all_envs_dataset/biosample_result.txt")

# Define patterns
patterns <- c("BioSample: (\\w+);", "Sample name: ([^;]+);", "SRA: (\\w+)", "Organism: ([^;]+)", "/isolation source=\"([^\"]*)\"", "/collection date=\"([^\"]*)\"", "/geographic location=\"([^\"]*)\"", "/latitude and longitude=\"([^\"]*)\"", "/sample material processing=\"([^\"]*)\"", "Accession: (\\w+)", "/environmental medium=\"([^\"]*)\"", "/depth=\"([^\"]*)\"", "/broad-scale environmental context=\"([^\"]*)\"", "/local-scale environmental context=\"([^\"]*)\"", "/elevation=\"([^\"]*)\"", "/pH=\"([^\"]*)\"", "/current vegetation=\"([^\"]*)\"", "/treatment=\"([^\"]*)\"", "/soil type=\"([^\"]*)\"")

# Export necessary objects to each worker
clusterExport(cl, list("ncbi_full_text", "patterns"))
clusterEvalQ(cl, .libPaths("/cluster/projects/nn9858k/packages/R"))

# Load function to process chunks
source("process_chunks.R")


# Split data into chunks for parallel processing
chunk_size <- ceiling(length(ncbi_full_text) / cores)
chunks <- split(ncbi_full_text, ceiling(seq_along(ncbi_full_text) / chunk_size))

# Process the chunks in parallel
results <- foreach(chunk = chunks, .combine = rbind, .packages = "stringr") %dopar% {
  process_chunk(chunk, patterns)
}


# Convert results to data frame and handle column types
summary_table <- as.data.frame(results, stringsAsFactors = FALSE)


# Print the structure of results_df to debug
print(str(summary_table))

# Ensure it is a data frame before proceeding
if (!is.data.frame(summary_table)) {
  stop("summary_table is not a data frame")
}

# Filter and clean up the data
summary_table <- summary_table %>% select(-Sample_Number)

# Save the summary table as a table (tsv file)
write.table(summary_table, "summary_table.tsv", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)

# Rows where BioSample is not identical to Accession
#chunk_test <- summary_table %>% filter(BioSample != Accession)
#chunk_test2 <- summary_table %>% filter(is.na(BioSample))

# Remove samples without geographic coordinates
lat_lon_no_int <- unique(summary_table$Latitude_and_longitude[!grepl("[0-9]", summary_table$Latitude_and_longitude)])

biosample_df_lat_lon <- summary_table %>%
    filter(! SRA == "NA") %>%
    filter(!is.na(Latitude_and_longitude),
           !Latitude_and_longitude %in% lat_lon_no_int)

biosample_df_geo_loc <- summary_table %>%
    filter(! SRA == "NA") %>%
    filter(is.na(Latitude_and_longitude) | Latitude_and_longitude %in% lat_lon_no_int) %>%
    filter(! Geographic_location == "not applicable",
           ! Geographic_location == "missing",
           ! Geographic_location == "not collected",
           ! Geographic_location == "NA",
           ! Geographic_location == "Missing",
           ! Geographic_location == "restricted access",
           ! Geographic_location == "n/a")

biosample_df_no_SRA <- summary_table %>%
    filter(SRA == "NA")

print("Number of SRA identifiers:")
length(unique(summary_table$SRA))
print("Number of SRA identifiers with geographic coordinates:")
nrow(biosample_df_lat_lon)
print("Number of SRA identifiers with geographic location but no coordinates:")
nrow(biosample_df_geo_loc)
print("Number of samples without SRA:")
nrow(biosample_df_no_SRA)

write.table(biosample_df_geo_loc$SRA, "SRA_IDs_no_lat_lon.csv", row.names = FALSE, col.names = FALSE, quote = FALSE)
write.table(biosample_df_lat_lon, "biosample_summary_lat_lon.txt", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
write.table(biosample_df_geo_loc, "biosample_summary_no_lat_lon.txt", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)

# Output session information
sessionInfo()

# Stop the parallel backend
stopCluster(cl)
