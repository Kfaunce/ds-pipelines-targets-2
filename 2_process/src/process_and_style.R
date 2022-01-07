process_data <- function(nwis_data, siteinfo_data){
  
  # Function to format data columns and merge data files

    # clean nwis data columns
    nwis_data_clean <- rename(nwis_data, water_temperature = X_00010_00000) %>% 
      select(-agency_cd, -X_00010_00000_cd, -tz_cd)
    
    # add site info
    nwis_data_annotated <- annotate_data(nwis_data_clean, siteinfo_data)
    
    # ensure correct data type of station name column
    nwis_data_styled <- style_data(nwis_data_annotated)
    
    return(nwis_data_styled)
  
}

annotate_data <- function(nwis_data_clean, siteinfo_data){
  
  # Function to add site info to NWIS data and clean data columns
  
    annotated_data <- merge(nwis_data_clean, siteinfo_data, by = "site_no", all.x = TRUE)
      
    annotated_data <- merge(nwis_data_clean, siteinfo_data, by = "site_no") %>% 
        select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va)
      
    return(annotated_data)
    
}


style_data <- function(site_data_annotated){
  
    styled_data <- mutate(site_data_annotated, station_name = as.factor(station_name))
    
    return(styled_data)
  
}











