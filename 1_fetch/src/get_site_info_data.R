get_site_info_data <- function(eval_data){ 
  
  # function to access and download site information based on unique site numbers
  
      sites <- unique(eval_data$site_no)
  
    # download site info - loop through sites and append to a single dataframe
      data_out <- retry(download_nwis_site_info(sites), maxErrors = 10, sleep = 2)
      
      return(data_out)
  
}



download_nwis_site_info <- function(site_num){ 
  
  # function to access and download site information for set site number
  
    site_info <- dataRetrieval::readNWISsite(site_num)
    
    return(site_info)
  
}
