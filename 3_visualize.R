# Functions
source("3_visualize/src/plot_timeseries.R")

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