test_that("columns in mapping table are malformed", {

  expect_error(ledger:::check_maptab(test_path("maptab_malformed1.csv")),
               "columns in mapping table are malformed")
})

test_that("mapping_table contains NAs", {

  expect_error(ledger:::check_maptab(test_path("maptab_malformed2.csv")),
               "mapping_table contains NAs")
})

test_that("mapping_table has no rows", {

  expect_error(ledger:::check_maptab(test_path("maptab_malformed3.csv")),
               "mapping_table has no rows")
})

test_that("mapping_table doesnt exist", {
  expect_silent(ledger:::check_maptab(test_path("missing_maptab.csv")))
})