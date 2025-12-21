watch_fixtures <- function(){
  fixtures <- list()
  
  fixtures[["base_df"]] <- tibble::tribble(
    ~numeric_col, ~string_col,
    1,            "a",
    2,            "b",
    3,            "c"
  )

  return(fixtures)
}