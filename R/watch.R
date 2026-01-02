#' Create a snapshot of a dataframe or check against an existing snapshot
#' 
#' If a snapshot exists with the passed watch_name in watch_dir, this function compares the snapshot to the passed dataframe using all.equal
#' after standardizing row and column order.
#'
#' @param df Dataframe to snapshot test.
#' @param watch_name Slug to identify snapshot. If NULL, the name of the object is used.
#' @param watch_dir  Snapshot directory.
#' @param if_diff Desired behaviour if dataframes are not the same.
#'
#' @returns boolean, true if no snapshot or snapshot is identical.
#' @examples
#' \dontrun{
#' my_df <- data.frame("numeric_col" = c(1, 2))
#' # Fancy code you want to refactor that does stuff to my_df goes here
#' # Saves first time it's run, returns true afterwards
#' 
#' watch_df(basic_df)
#' diff_df <- dplyr::mutate(basic_df, numeric_col = numeric_col + 1) 
#'# Returns false and throws a warning
#'  watch_df(
#'    diff_df,
#'    watch_name = "basic_df",
#'    if_diff = "warn"
#'  )
#' }
#' @export 
watch_df <- function(
  df, 
  watch_name = NULL,
  watch_dir = ".tower_snaps",
  if_diff = c("error", "warn", "silent")
){
  if_diff <- rlang::arg_match(if_diff)
  if (is.null(watch_name)) {
    watch_name <- rlang::as_name(rlang::enquo(df))
    cli::cli_alert("No watch name provided, using {watch_name}")
  }

  if (!fs::dir_exists(watch_dir)) {
    if (rlang::is_interactive()) {
      res <- utils::menu(
        c("Yes", "No"),
        title=glue::glue("Directory {watch_dir} does not exist, do you want to create it?")
      )

      if (res == 1) {
        fs::dir_create(watch_dir, recurse = TRUE)
      } else {
        cli::cli_abort("{watch_dir} must exist")
      }

    } else {
      cli::cli_abort("{watch_dir} must exist if `watch_df` not run interactively")
    }
  }

  matches <- list_watch_df_snapshots(watch_name, watch_dir)

  if (nrow(matches) == 0) {
    cli::cli_alert("No match found for {watch_name} in {watch_dir}, creating new snapshot")
    readr::write_rds(
       x = df,
       fs::path_join(c(watch_dir, build_watch_filename(watch_name)))
    )
    return(TRUE)
  }

  snapshot_path <- dplyr::slice(
    dplyr::arrange(matches, dplyr::desc("modification_time")),
    1 
  )

  snapshot_df <- readr::read_rds(dplyr::pull(snapshot_path, "path"))

  df <- prep_df_for_comparison(df)
  snapshot_df <- prep_df_for_comparison(snapshot_df)

  are_both_equal <- isTRUE(all.equal(df, snapshot_df))

  if (!are_both_equal) {
    msg <- c("input is not equal to snapshot")

      if (if_diff == "error") {
        cli::cli_abort(
          msg
        )
      } 

      if (if_diff == "warn") {
        cli::cli_warn(
          msg
        )
      } 
  }
  
  are_both_equal
      
  }

# Alphabetize columns, arrange rows based on all row values
prep_df_for_comparison <- function(df){
  df = dplyr::arrange(df, dplyr::across(dplyr::everything()))
  df = dplyr::select(df, order(colnames(df)))
  df
}

#' Check available snapshots
#' @inheritParams watch_df
#' @returns a df with information about saved snapshots for the watched item.
#' @examples
#' list_watch_df_snapshots(watch_name = "my_df", watch_dir = "watch_dir")
#' @export
list_watch_df_snapshots <- function(watch_name, watch_dir) {
  watch_name <- fs::path_sanitize(watch_name)
  regex = paste0(
        "\\d{4}-\\d{2}-\\d{2}T\\d{6}_",
        watch_name,
        "\\.rds$"
    )
    
  fs::dir_info(watch_dir, regexp = regex, perl = TRUE) 
}

build_watch_filename <- function(watch_name) {
  iso_time_stamp <- lubridate::format_ISO8601(
    lubridate::now(tzone = 'UTC'), precision ='ymdhms'
  )
  
  file_name <- glue::glue("{iso_time_stamp}_{watch_name}.rds")
  fs::path_sanitize(file_name)
}

#' Delete all existing snapshots for a watched object
#' This function is useful for reseting the snapshot when an intended change is made.
#' @inheritParams watch_df
#' @returns NULL
#' @examples
#' reset_watch_snaphsots(watch_name = "my_df", watch_dir = "watch_dir")
#' @export
reset_watch_snaphsots <- function(watch_name, watch_dir){

  df_snapshots <- list_watch_df_snapshots(watch_name, watch_dir) 
  df_snapshots_filepaths <- dplyr::pull(df_snapshots, "path")
  fs::file_delete(df_snapshots_filepaths)
}