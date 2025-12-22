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

  if (length(matches) == 0) {
    cli::cli_alert("No match found for {watch_name} in {watch_dir}, creating new snapshot")
    readr::write_rds(
       x = df,
       fs::path_join(c(watch_dir, build_watch_filename(watch_name)))
    )
  }

  # Check if watch_name is in watch_dir
    # If not - alert and save a new one 
      # Include git info, branch and config
      # hash of relevant files?
    # If in watch_dir
      # load latest in watch dir
        # specify columns 
      # Is the same?
        # if so, exit and alert true 
      
}

#' @export
list_watch_df_snapshots <- function(watch_name, watch_dir) {
  watch_name <- fs::path_sanitize(watch_name)
  regex = paste0(
        "\\d{4}-\\d{2}-\\d{2}T\\d{6}_",
        watch_name,
        "\\.rda$"
    )
    
  fs::dir_ls(watch_dir, regexp = regex, perl = TRUE) 
}

build_watch_filename <- function(watch_name) {
  iso_time_stamp <- lubridate::format_ISO8601(
    lubridate::now(tzone = 'UTC'), precision ='ymdhms'
  )
  
  file_name <- glue::glue("{iso_time_stamp}_{watch_name}.rda")
  fs::path_sanitize(file_name)
}