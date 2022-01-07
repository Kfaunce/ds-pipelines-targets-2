# Functions
source("1_fetch/src/get_nwis_data.R")
source("1_fetch/src/retry.R")
source("1_fetch/src/bind_data.R")
source("1_fetch/src/get_site_info_data.R")

# Download NWIS and site info data and compile files
p1_targets_list <- list(
  tar_target(
    p1_site_1_data_csv,
    get_nwis_data(
      site_list[1],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    p1_site_2_data_csv,
    get_nwis_data(
      site_list[2],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    p1_site_3_data_csv,
    get_nwis_data(
      site_list[3],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    p1_site_4_data_csv,
    get_nwis_data(
      site_list[4],
      "1_fetch/out/", # out directory
      startDate,
      endDate,
      parameterCd
    ),
    format = "file"
  ),
  tar_target(
    p1_compiled_nwis_data_object,
    bind_data(
      p1_site_1_data_csv,
      p1_site_2_data_csv,
      p1_site_3_data_csv,
      p1_site_4_data_csv
    )
  ),
  tar_target(
    p1_compiled_site_info_object,
    get_site_info_data(
      p1_compiled_nwis_data_object,
      site_list
    )
  )
)