library(targets)

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
if(!dir.exists('3_visualize/out/'))
  dir.create(path = '3_visualize/out/')

# Source makefiles
source("1_fetch.R")
source("2_process.R")
source("3_visualize.R")

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
