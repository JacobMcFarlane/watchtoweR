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
  watch_name,
  watch_dir = "tower_snaps"
){
  
  iso_time_stamp <- lubridate::format_ISO8601(lubridate::now(tzone = 'UTC'))
  file_name <- glue::glue("{watch_name}_{lubridate::now(tzone = 'UTC')}.rda")

  # Watch dir df
  files = list.files()

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

