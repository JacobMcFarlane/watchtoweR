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
  


  # Watch dir df
  regex = glue::glue("^[:digit:]{4}-[:digit:]{2}-[:digit:]{2}T[:digit:]{6}_{watch_name}\\.rda$")
  files = fs::dir_ls(watch_dir, pattern = regex)

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