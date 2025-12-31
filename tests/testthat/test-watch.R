test_that("Basic watch_df functionality works as expected", {
  basic_df <- watch_fixtures()$base_df
  watch_folder <- withr::local_tempdir()

  expect_message(
    watch_df(basic_df,
            watch_dir = watch_folder),
    regexp = "No match found for basic_df in"
  )

  expect_true(
    watch_df(basic_df,
             watch_dir = watch_folder)
  )

  diff_df <- dplyr::mutate(basic_df, numeric_col = numeric_col + 1) 

  expect_false(
    watch_df(
      diff_df,
      watch_name = "basic_df",
      watch_dir = watch_folder,
      if_diff = "silent"
    )
  )

  expect_error(
    watch_df(
      diff_df,
      watch_name = "basic_df",
      watch_dir = watch_folder,
      if_diff = "error"
    )
  )

  expect_warning(
    watch_df(
      diff_df,
      watch_name = "basic_df",
      watch_dir = watch_folder,
      if_diff = "warn"
    )
  )
  

})
