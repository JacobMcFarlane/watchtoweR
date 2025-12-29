#' Quick and dirty snapshot testing for a dataframe
#' 
#' Checks the watch_dir for the passed watch name and comapres it against the df or saves a new 
#' snapshot if one is not available
#'
#' @param df object 
#' @param watch_name identifier of object name to check on. Must be a valid filename.
#' @param watch_dir  directory to look for snapshot
#'
#' @returns bool true or false
#'
#' @export 
watch_df <- function(
  df, 
  watch_name = NULL,
  watch_dir = "tower_snaps"
){
  
  if (is.null(watch_name)) {
    watch_name <- rlang::as_name(rlang::enquo(df))
    cli::cli_alert("No watch name provided, using {watch_name}")
  }

  if (!fs::dir_exists(watch_dir)) {
    if (rlang::is_interactive()) {
      res <- menu(
        c("Yes", "No"),
        title="Passed watch dir does not exist, do you want to create it?"
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
    dplyr::arrange(matches, desc("modification_time")),
    1 
  )

  snapshot_df <- readr::read_rds(dplyr::pull(snapshot_path, "path"))

  df <- dplyr::arrange(df, dplyr::everything())
  snapshot_df <- dplyr::arrange(df, dplyr::everything())

  are_both_equal <- all.equal(df, snapshot_df)
  
  return(are_both_equal)
      
}


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