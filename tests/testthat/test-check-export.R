test_that("path_to_export is not a character vector", {
  expect_error(ledger:::check_export(1),
               "path_to_export is not a character vector")
})

test_that("path_to_export is empty character vector", {
  expect_error(ledger:::check_export(""),
               "path_to_export is empty character vector")
})



test_that("export file doesnt exist", {
  expect_error(ledger:::check_export(test_path("non_existing_export.csv")),
               "export file doesnt exist")
})

test_that("export is not a csv", {
  expect_error(ledger:::check_export(test_path("dkb_example_export_3")),
               "export is not a csv")
})