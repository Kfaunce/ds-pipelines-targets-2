library(targets)
source("1_fetch/src/get_nwis_data.R")
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
    site_data,
      for (site_num in site_list) {
        download_nwis_data(
          site_num,
          "1_fetch/out/", # out directory
          startDate,
          endDate,
          parameterCd
        )
      },
    format = "file"
  ),
  tar_target(
    compiled_nwis_data,
    bind_data(
      site_data,
      "nwisdata", # specify which files to combine, filename search string
      "2_process/out/all_nwisdata.csv" # file outpath
    )
  ),
  format = "file"
)


#p2_targets_list <- list(
#  tar_target(
#    site_data_clean, 
#    process_data(site_data)
#  ),
#  tar_target(
#    site_data_annotated,
#    annotate_data(site_data_clean, site_filename = site_info_csv)
#  ),
#  tar_target(
#    site_data_styled,
#    style_data(site_data_annotated)
#  )
#)

#p3_targets_list <- list(
#  tar_target(
#    figure_1_png,
#    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled),
#    format = "file"
#  )
#)

# Return the complete list of targets
c(p1_targets_list)#, p2_targets_list, p3_targets_list)
