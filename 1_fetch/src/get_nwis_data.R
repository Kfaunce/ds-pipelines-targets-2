download_nwis_data <- function(site_num, out_dir, startDate, endDate, parameterCd){
  
  # function to simultaneously download site information and data for set parameter
  
    # create the file name needed for download_nwis_site_data
      download_file <- file.path(out_dir, paste0("nwis_", site_num, "_nwisdata.csv"))
        
    # download parameter data
      val <- retry(download_nwis_site_data(download_file, startDate, endDate, parameterCd = parameterCd), maxErrors = 10, sleep = 2)
        
    # download site info
      val <- retry(download_nwis_site_info(site_num, out_dir), maxErrors = 10, sleep = 2)
        
      return(paste0(out_dir, "nwis_", site_num, "_nwisdata.csv"))
  
}



download_nwis_site_info <- function(site_num, out_dir){ 
  
  # function to access and download site information for set site number
      
      site_info <- dataRetrieval::readNWISsite(site_num)
      readr::write_csv(site_info, paste0(out_dir, "nwis_", site_num, "_siteinfo.csv"))
      return(paste0(out_dir, "nwis_", site_num, "_siteinfo.csv"))
  
}



download_nwis_site_data <- function(filepath, parameterCd, startDate, endDate){ 
  
  # function to access and download data for set parameter
  
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



retry <- function(expr, isError=function(x) "try-error" %in% class(x), maxErrors, sleep) { 
  
  # function to retry downloads within set number of attempts and wait period
  
      attempts = 0
      retval = try(eval(expr))
      
      while (isError(retval)) {
        
        attempts = attempts + 1
        if (attempts >= maxErrors) {
          msg = sprintf("retry: too many retries [[%s]]", capture.output(str(retval)))
          flog.fatal(msg)
          stop(msg)
          
        } else {
          
          msg = sprintf("retry: error in attempt %i/%i [[%s]]", attempts, maxErrors, capture.output(str(retval)))
          futile.logger::flog.error(msg)
          warning(msg)
          
        }
        
        if (sleep > 0) Sys.sleep(sleep)
        retval = try(eval(expr))
        
      }
      
      return(retval)
  
}
