
# watchtoweR

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml/badge.svghttps://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml/badge.svghttps://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JacobMcFarlane/watchtoweR/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->

The goal of watchtoweR is to enable quick and easy snapshot testing for the output of R scripts. Simply add a call to `watch_df` at the end of your script and call a 

## Installation

You can install the development version of watchtoweR from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("JacobMcFarlane/watchtoweR")
```

## Example

Quickly add a snapshot before refactoring R code

``` r
library(watchtoweR)

x <- tibble::tibble(a = 1)

# Code goes here.

watch_df(x)
```

