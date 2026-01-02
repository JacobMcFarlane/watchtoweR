
# watchtoweR

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml/badge.svghttps://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml/badge.svghttps://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->

WatchtoweR provides file-based snapshot testing for R data frames, allowing you to detect
differences in dataframes when refactoring code or making upstream changes. It automatically
saves timestamped snapshots, compares new results against the most recent snapshot.

## Installation

You can install watchtoweR from cran with

``` r
install.packages("watchtoweR")
```

You can install the development version of watchtoweR from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("JacobMcFarlane/watchtoweR")
```

## Example

Quickly add a snapshot before refactoring R code

``` r
library(watchtoweR)
 my_df <- data.frame("numeric_col" = c(1, 2))
# Fancy code you want to refactor that does stuff to my_df goes here
# Saves first time it's run, returns true afterwards
 
watch_df(basic_df)
diff_df <- dplyr::mutate(basic_df, numeric_col = numeric_col + 1) 
# Returns false and throws a warning
watch_df(basic_df, if_diff = "warn")

# If the df should change, run
reset_watch_snaphsots(watch_name = "basic_df", watch_dir = ".tower_snaps")
```

