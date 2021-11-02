library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/bind_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)

tar_option_set(packages = c(
  "tidyverse", 
  "dataRetrieval",
  "utils",
  "futile.logger"
  )
)

# site number list 
site_list <- c("01427207", "01432160", "01436690", "01466500")

# establish common start date, end date, and parameter code for queries
startDate <- "2014-05-01" 
endDate <- "2015-05-01"
parameterCd <- '00010'

# Create output directories if not included
if(!dir.exists('1_fetch/out/'))
  dir.create(path = '1_fetch/out/')
if(!dir.exists('2_process/out/'))
  dir.create(path = '2_process/out/')
if(!dir.exists('3_visualize/out/'))
  dir.create(path = '3_visualize/out/')



# Download site data and compile files
p1_targets_list <- list(
  tar_target(
    site_1_data,
    download_nwis_data(
      site_list[1],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
  format = "file"
  ),
  tar_target(
    site_2_data,
    download_nwis_data(
      site_list[2],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    site_3_data,
    download_nwis_data(
      site_list[3],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    site_4_data,
    download_nwis_data(
      site_list[4],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    compiled_nwis_data,
    bind_data(
      site_1_data,
      site_2_data,
      site_3_data,
      site_4_data,
      "nwisdata", # specify which files to combine, filename search string
      "2_process/out/all_nwisdata.csv" # file outpath
    ),
  format = "file"
  ),
  tar_target(
    compiled_site_info,
    bind_data(
      site_1_data,
      site_2_data,
      site_3_data,
      site_4_data,
      "siteinfo", # specify which files to combine, filename search string
      "2_process/out/all_siteinfo.csv" # file outpath
    ),
    format = "file"
  )
)


# Clean and format data files
p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(
      compiled_nwis_data,
      compiled_site_info
    )
  )
)


p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(
      site_data_clean,
     "3_visualize/out/figure_1.png" # file outpath
    ),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
