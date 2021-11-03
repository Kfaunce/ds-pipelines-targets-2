get_site_info_data <- function(eval_data, file_outpath){ 
  
  # function to access and download site information based on unique site numbers from 2_process/out/all_nwisdata.csv
  
    # get site list
      nwisdata <- readr::read_csv(eval_data)
      sites <- unique(nwisdata$site_no) 
  
    # download site info - loop through sites and append to a single dataframe
      data_out <- retry(download_nwis_site_info(sites), maxErrors = 10, sleep = 2)
    
      readr::write_csv(data_out, file_outpath)
      
      return(file_outpath)
  
}



download_nwis_site_info <- function(site_num){ 
  
  # function to access and download site information for set site number
  
    site_info <- dataRetrieval::readNWISsite(site_num)
    
    return(site_info)
  
}
