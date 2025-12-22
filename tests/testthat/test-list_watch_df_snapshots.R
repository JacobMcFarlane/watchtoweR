test_that("Basic watch_df functionality works as expected", {
  # Alert and save if no matches for string in testdir
  basic_df <- watch_fixtures()$base_df
  watch_folder <- withr::local_tempdir()
  watch_file_base <- "basic_df"

  watch_filename <- watchtoweR:::build_watch_filename(watch_file_base)


  expect_equal(
    length(list_watch_df_snapshots(watch_file_base, watch_folder)),
    0
  )

  fs::file_create(fs::path_join(c(watch_folder, watch_filename)))

  expect_equal(
    length(list_watch_df_snapshots(watch_file_base, watch_folder)),
    1
  )

  # Shouldn't match regex
  fs::file_create(fs::path_join(c(watch_folder, watch_file_base)))

    expect_equal(
    length(list_watch_df_snapshots(watch_file_base, watch_folder)),
    1
  )
})
