test_that("Basic watch_df functionality works as expected", {
  # Alert and save if no matches for string in testdir
  basic_df <- watch_fixtures()$base_df
  watch_folder <- withr::local_tempdir()


  expect_message(
    watch(basic_df,
          watch_folder),
    regexp = "No match found for basic_df in"
  )
})
