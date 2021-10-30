bind_data <- function(eval_data, search_string, file_outpath) {
  
  # Function to bind downloaded output files together
  
    filenames <- list.files(eval_data, pattern = paste0(search_string), full.names = TRUE)
    ldf <- lapply(filenames, readr::read_csv)
    combined_df <- do.call(rbind, ldf)
    
    readr::write_csv(file_outpath)
    
    return(file_outpath)
  
}