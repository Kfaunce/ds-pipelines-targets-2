bind_data <- function(...) {
  
  # Function to bind downloaded output files together
    
    # read in all files in out directory and combine
    all_files <- list(...)
    combined_df <- lapply(all_files, readr::read_csv) %>% bind_rows()
    
    return(combined_df)
  
}