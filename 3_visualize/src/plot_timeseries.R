plot_nwis_timeseries <- function(eval_data, file_outpath, width = 12, height = 7, units = 'in'){
  
    # Function to create plot of NWIS data
  
      ggplot(data = eval_data, aes(x = dateTime, y = water_temperature, color = station_name)) +
        geom_line() + theme_bw()
  
      ggsave(file_outpath, width = width, height = height, units = units)
      
      return(file_outpath)
  
}