library(tidyverse)
setwd("metanotrophs_mapping/03_taxprofiler/")

# Replace problematic commas in samplesheet csv, this is commas within a field that should not be interpreted as separator
# Define the PowerShell command as a string
powershell_command <- "powershell -Command \"Get-Content -Path 'samplesheet_taxprofiler.csv' | ForEach-Object { $_ -replace 'CONCAT\\(([^,]*),([^)]*)\\)', 'CONCAT($1$2)' } | Set-Content -Path 'samplesheet_taxprofiler_removed_bad_commas.csv'\""
# Execute the PowerShell command
system(powershell_command)


# Linux version 
# linux_command <-system("sed 's/CONCAT(\\([^,]*\\),\\([^)]*\\))/CONCAT(\\1\\2)/g' samplesheet_taxprofiler.csv > test.csv")
# system(linux_command)


# Read the CSV file
samplesheet_taxprofiler <- read.table("samplesheet_taxprofiler_removed_bad_commas.csv", header = TRUE, quote = '"', sep = ",", fill = TRUE)
samplesheet_taxprofiler <- samplesheet_taxprofiler %>%
  select(c(sample, run_accession, instrument_platform, fastq_1, fastq_2))

# check that instrument platform looks correct
unique(samplesheet_taxprofiler$instrument_platform)

# Write final samplesheet used in taxprofiler pipeline
write.csv(samplesheet_taxprofiler, file = "samplesheet_taxprofiler_final.csv", quote = TRUE, col.names = TRUE, row.names = FALSE)
