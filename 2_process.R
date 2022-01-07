# Functions
source("2_process/src/process_and_style.R")

# Clean and format data files
p2_targets_list <- list(
  tar_target(
    p2_site_data_clean, 
    process_data(
      p1_compiled_nwis_data_object,
      p1_compiled_site_info_object
    )
  )
)