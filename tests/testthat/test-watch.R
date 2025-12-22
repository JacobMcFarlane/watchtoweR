test_that("Basic watch_df functionality works as expected", {
  basic_df <- watch_fixtures()$base_df
  watch_folder <- withr::local_tempdir()

  expect_message(
    watch_df(basic_df,
            watch_dir = watch_folder),
    regexp = "No match found for basic_df in"
  )

})
