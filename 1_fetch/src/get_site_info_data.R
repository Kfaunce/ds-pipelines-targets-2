get_site_info_data <- function(eval_data, file_outpath){ 
  
  # function to access and download site information based on unique site numbers from 2_process/out/all_nwisdata.csv
  
    # get site list
      nwisdata <- readr::read_csv(eval_data)
      sites <- unique(nwisdata$site_no) 
  
    # download site info - loop through sites and append to a single dataframe
      data_out <- data.frame()
      
      for (i in sites) {
        
        val <- retry(download_nwis_site_info(i), maxErrors = 10, sleep = 2)
        
        # initial attempts indicated a need to set these columns as a specific data type for binding
        val$coord_acy_cd <- as.character(val$coord_acy_cd)
        val$county_cd <- as.character(val$county_cd)
        
        data_out <- dplyr::bind_rows(data_out, val)
        
      }
    
      readr::write_csv(data_out, file_outpath)
      
      return(file_outpath)
  
}



download_nwis_site_info <- function(site_num){ 
  
  # function to access and download site information for set site number
  
    site_info <- dataRetrieval::readNWISsite(site_num)
    
    return(site_info)
  
}
