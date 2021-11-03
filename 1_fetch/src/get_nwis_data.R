get_nwis_data <- function(site_num, out_dir, startDate, endDate, parameterCd){
  
  # function to download nwis data for set parameter and write file
  
    # create the file name needed for download_nwis_site_data
      download_file <- file.path(out_dir, paste0("nwis_", site_num, "_nwisdata.csv"))
        
    # download parameter data
      val <- retry(download_nwis_site_data(download_file, startDate, endDate, parameterCd = parameterCd), maxErrors = 10, sleep = 2)
        
      return(paste0(out_dir, "nwis_", site_num, "_nwisdata.csv"))
  
}



download_nwis_site_data <- function(filepath, parameterCd, startDate, endDate){ 
  
  # function to access and return data for set parameter
  
      site_num <- basename(filepath) %>% 
        stringr::str_extract(pattern = "(?:[0-9]+)")
      
      data_out <- dataRetrieval::readNWISdata(
        sites=site_num, 
        service="iv", 
        parameterCd = parameterCd, 
        startDate = startDate, 
        endDate = endDate
        )
  
    # -- simulating a failure-prone web-service here, do not edit --
      set.seed(Sys.time())
      if (sample(c(T,F,F,F), 1)){
        stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
      }
    # -- end of do-not-edit block
    
      readr::write_csv(data_out, filepath)
      return(filepath)
    
}
