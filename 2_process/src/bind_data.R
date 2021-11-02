bind_data <- function(eval_1_data, eval_2_data, eval_3_data, eval_4_data, search_string, file_outpath) {
  
  # Function to bind downloaded output files together
  
    # assume common out directory among files
    out_dir <- sub("(/.*?/).*", "\\1", eval_1_data)
  
    # read in all files in out directory matching the search string and combine
    filenames <- list.files(out_dir, pattern = paste0(search_string), full.names = TRUE)
    ldf <- lapply(filenames, readr::read_csv)
    combined_df <- do.call(rbind, ldf)
    
    readr::write_csv(combined_df, file_outpath)
    
    return(file_outpath)
  
}